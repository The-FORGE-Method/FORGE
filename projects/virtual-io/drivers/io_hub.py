#!/usr/bin/env python3
"""
Virtual I/O Hub - Central Controller

Integrates all virtual I/O modules into a unified interface for AI agents.
Provides event-driven architecture for receiving and processing I/O data.

Usage:
    from io_hub import IOHub, IOEvent
    
    hub = IOHub()
    
    # Register event handlers
    @hub.on("display.frame")
    def handle_frame(event):
        print(f"New frame captured: {len(event.data)} bytes")
    
    @hub.on("audio.capture")
    def handle_audio(event):
        print(f"Audio chunk: {len(event.data)} samples")
    
    # Start all devices
    hub.start()
    
    # Use devices
    hub.speak("Hello world")
    hub.print_gcode("G28\\nG1 X50 Y50 F3000")
"""

import time
import threading
from typing import Optional, Callable, Dict, List, Any, Union
from dataclasses import dataclass, field
from queue import Queue, Empty
from pathlib import Path
import io

# Import virtual I/O modules
from virtual_display import VirtualDisplay, list_available_methods as display_methods
from virtual_speaker import VirtualSpeaker, list_available_backends as speaker_backends
from virtual_mic import VirtualMicrophone, list_available_backends as mic_backends
from virtual_printer import VirtualPrinter, GCodeGenerator, PrinterState


@dataclass
class IOEvent:
    """Event from virtual I/O device."""
    device: str      # "display", "speaker", "mic", "printer"
    event_type: str  # "frame", "audio", "command", etc.
    data: Any
    timestamp: float = field(default_factory=time.time)
    metadata: Dict[str, Any] = field(default_factory=dict)


class EventEmitter:
    """Simple event emitter for I/O events."""
    
    def __init__(self):
        self._handlers: Dict[str, List[Callable]] = {}
    
    def on(self, event: str, handler: Optional[Callable] = None):
        """
        Register event handler.
        
        Can be used as decorator:
            @emitter.on("event.type")
            def handler(event): ...
        """
        def decorator(fn):
            if event not in self._handlers:
                self._handlers[event] = []
            self._handlers[event].append(fn)
            return fn
        
        if handler:
            return decorator(handler)
        return decorator
    
    def off(self, event: str, handler: Callable = None):
        """Remove event handler(s)."""
        if handler and event in self._handlers:
            self._handlers[event] = [h for h in self._handlers[event] if h != handler]
        elif event in self._handlers:
            del self._handlers[event]
    
    def emit(self, event: str, data: IOEvent):
        """Emit event to all handlers."""
        handlers = self._handlers.get(event, [])
        handlers += self._handlers.get("*", [])  # Wildcard handlers
        
        for handler in handlers:
            try:
                handler(data)
            except Exception as e:
                print(f"Handler error for {event}: {e}")


class IOHub(EventEmitter):
    """
    Central hub for all virtual I/O devices.
    
    Provides unified interface for:
    - Display capture
    - Audio capture (speaker)
    - Audio injection (microphone)
    - 3D printer control
    """
    
    def __init__(self, 
                 enable_display: bool = True,
                 enable_speaker: bool = True,
                 enable_mic: bool = True,
                 enable_printer: bool = True):
        """
        Initialize I/O Hub.
        
        Args:
            enable_*: Enable/disable specific devices
        """
        super().__init__()
        
        self.config = {
            "display": enable_display,
            "speaker": enable_speaker,
            "mic": enable_mic,
            "printer": enable_printer
        }
        
        # Device instances
        self._display: Optional[VirtualDisplay] = None
        self._speaker: Optional[VirtualSpeaker] = None
        self._mic: Optional[VirtualMicrophone] = None
        self._printer: Optional[VirtualPrinter] = None
        self._gcode: Optional[GCodeGenerator] = None
        
        # Thread management
        self._running = False
        self._threads: List[threading.Thread] = []
        self._event_queue: Queue = Queue()
        
        # State
        self._started = False
        self._device_status: Dict[str, str] = {}
    
    def start(self, 
              display_fps: float = 1.0,
              audio_sink_name: str = "ai_agent_sink",
              audio_source_name: str = "ai_agent_mic") -> Dict[str, str]:
        """
        Start all enabled devices.
        
        Args:
            display_fps: Frame capture rate
            audio_sink_name: Name for virtual audio sink
            audio_source_name: Name for virtual audio source
        
        Returns:
            Dict of device statuses
        """
        if self._started:
            return self._device_status
        
        self._running = True
        self._device_status = {}
        
        # Start event processing thread
        event_thread = threading.Thread(target=self._event_loop)
        event_thread.daemon = True
        event_thread.start()
        self._threads.append(event_thread)
        
        # Initialize display
        if self.config["display"]:
            try:
                self._display = VirtualDisplay()
                self._device_status["display"] = f"ok:{self._display.get_method_name()}"
                
                # Start capture thread
                thread = threading.Thread(
                    target=self._display_capture_loop,
                    args=(display_fps,)
                )
                thread.daemon = True
                thread.start()
                self._threads.append(thread)
            except Exception as e:
                self._device_status["display"] = f"error:{e}"
        
        # Initialize speaker (audio capture)
        if self.config["speaker"]:
            try:
                self._speaker = VirtualSpeaker()
                if self._speaker.create_sink(audio_sink_name):
                    self._speaker.start_capture()
                    self._device_status["speaker"] = f"ok:{self._speaker.get_backend_name()}"
                    
                    # Start audio capture processing
                    thread = threading.Thread(target=self._audio_capture_loop)
                    thread.daemon = True
                    thread.start()
                    self._threads.append(thread)
                else:
                    self._device_status["speaker"] = "error:sink_creation_failed"
            except Exception as e:
                self._device_status["speaker"] = f"error:{e}"
        
        # Initialize microphone (audio injection)
        if self.config["mic"]:
            try:
                self._mic = VirtualMicrophone()
                if self._mic.create_source(audio_source_name):
                    self._device_status["mic"] = f"ok:{self._mic.get_backend_name()}"
                else:
                    self._device_status["mic"] = "error:source_creation_failed"
            except Exception as e:
                self._device_status["mic"] = f"error:{e}"
        
        # Initialize printer
        if self.config["printer"]:
            try:
                self._printer = VirtualPrinter(
                    on_command=self._on_printer_command,
                    on_move=self._on_printer_move
                )
                port = self._printer.start()
                self._gcode = GCodeGenerator()
                self._device_status["printer"] = f"ok:{port}"
            except Exception as e:
                self._device_status["printer"] = f"error:{e}"
        
        self._started = True
        return self._device_status
    
    def stop(self):
        """Stop all devices and clean up."""
        self._running = False
        
        # Wait for threads
        for thread in self._threads:
            thread.join(timeout=2)
        self._threads.clear()
        
        # Clean up devices
        if self._display:
            self._display.cleanup()
            self._display = None
        
        if self._speaker:
            self._speaker.cleanup()
            self._speaker = None
        
        if self._mic:
            self._mic.cleanup()
            self._mic = None
        
        if self._printer:
            self._printer.stop()
            self._printer = None
        
        self._started = False
    
    def _event_loop(self):
        """Process events from queue."""
        while self._running:
            try:
                event = self._event_queue.get(timeout=0.1)
                event_key = f"{event.device}.{event.event_type}"
                self.emit(event_key, event)
                self.emit(event.device, event)  # Also emit by device only
            except Empty:
                pass
    
    def _display_capture_loop(self, fps: float):
        """Capture display frames at specified FPS."""
        interval = 1.0 / fps
        
        while self._running:
            try:
                start = time.time()
                frame = self._display.capture_frame()
                
                event = IOEvent(
                    device="display",
                    event_type="frame",
                    data=frame,
                    metadata={"method": self._display.get_method_name()}
                )
                self._event_queue.put(event)
                
                # Sleep for remaining interval
                elapsed = time.time() - start
                if elapsed < interval:
                    time.sleep(interval - elapsed)
            except Exception as e:
                time.sleep(1)  # Error backoff
    
    def _audio_capture_loop(self):
        """Capture audio from virtual speaker."""
        while self._running:
            try:
                chunk = self._speaker.get_audio_chunk(timeout=0.5)
                if chunk:
                    event = IOEvent(
                        device="speaker",
                        event_type="audio",
                        data=chunk,
                        metadata={"backend": self._speaker.get_backend_name()}
                    )
                    self._event_queue.put(event)
            except Exception:
                pass
    
    def _on_printer_command(self, cmd, state: PrinterState):
        """Handle printer command."""
        event = IOEvent(
            device="printer",
            event_type="command",
            data={"code": cmd.code, "params": cmd.params},
            metadata={"state": state}
        )
        self._event_queue.put(event)
    
    def _on_printer_move(self, state: PrinterState):
        """Handle printer move."""
        event = IOEvent(
            device="printer",
            event_type="move",
            data={"x": state.x, "y": state.y, "z": state.z, "e": state.e},
            metadata={"state": state}
        )
        self._event_queue.put(event)
    
    # ========== Display Methods ==========
    
    def capture_frame(self) -> Optional[bytes]:
        """Capture a single display frame."""
        if self._display:
            return self._display.capture_frame()
        return None
    
    def save_screenshot(self, path: str) -> bool:
        """Save screenshot to file."""
        if self._display:
            self._display.save_frame(path)
            return True
        return False
    
    # ========== Speaker Methods ==========
    
    def get_audio_chunk(self, timeout: float = 1.0) -> Optional[bytes]:
        """Get audio chunk from virtual speaker."""
        if self._speaker:
            return self._speaker.get_audio_chunk(timeout)
        return None
    
    def capture_audio_to_file(self, path: str, duration: float) -> bool:
        """Capture audio to WAV file."""
        if self._speaker:
            return self._speaker.capture_to_file(path, duration)
        return False
    
    # ========== Microphone Methods ==========
    
    def speak(self, audio_data: Union[bytes, "np.ndarray"]) -> bool:
        """
        Output audio through virtual microphone.
        
        Args:
            audio_data: Raw audio bytes or numpy array
        """
        if self._mic:
            self._mic.write_audio(audio_data)
            return True
        return False
    
    def speak_file(self, path: str, block: bool = True) -> bool:
        """Play audio file through virtual microphone."""
        if self._mic:
            self._mic.play_file(path, block)
            return True
        return False
    
    def speak_tone(self, frequency: float, duration: float, 
                   amplitude: float = 0.5) -> bool:
        """Generate tone through virtual microphone."""
        if self._mic:
            try:
                self._mic.generate_tone(frequency, duration, amplitude)
                return True
            except Exception:
                return False
        return False
    
    # ========== Printer Methods ==========
    
    def get_printer_port(self) -> Optional[str]:
        """Get virtual printer serial port path."""
        if self._printer:
            return self._printer.port_name
        return None
    
    def get_printer_position(self) -> Optional[tuple]:
        """Get current printer position (x, y, z, e)."""
        if self._printer:
            return self._printer.get_position()
        return None
    
    def get_printer_temperature(self) -> Optional[tuple]:
        """Get printer temperatures."""
        if self._printer:
            return self._printer.get_temperature()
        return None
    
    def create_gcode(self) -> GCodeGenerator:
        """Get G-code generator instance."""
        return GCodeGenerator()
    
    # ========== Status Methods ==========
    
    def get_status(self) -> Dict[str, Any]:
        """Get status of all devices."""
        status = {
            "running": self._running,
            "started": self._started,
            "devices": self._device_status.copy()
        }
        
        if self._printer:
            pos = self._printer.get_position()
            temp = self._printer.get_temperature()
            status["printer_state"] = {
                "position": pos,
                "temperature": temp
            }
        
        return status
    
    def is_device_available(self, device: str) -> bool:
        """Check if device is available and running."""
        status = self._device_status.get(device, "")
        return status.startswith("ok:")
    
    @staticmethod
    def list_available_devices() -> Dict[str, List[tuple]]:
        """List available methods/backends for each device type."""
        return {
            "display": display_methods(),
            "speaker": speaker_backends(),
            "mic": mic_backends()
        }
    
    def __enter__(self):
        self.start()
        return self
    
    def __exit__(self, exc_type, exc_val, exc_tb):
        self.stop()


def main():
    """Demo/test the I/O Hub."""
    print("Virtual I/O Hub")
    print("=" * 50)
    
    # List available devices
    print("\nAvailable devices:")
    devices = IOHub.list_available_devices()
    for device, methods in devices.items():
        print(f"\n  {device}:")
        if methods:
            for name, desc in methods:
                print(f"    - {name}: {desc}")
        else:
            print("    - None available")
    
    print("\n" + "=" * 50)
    print("Starting I/O Hub...")
    
    # Create event handlers
    frame_count = [0]
    audio_count = [0]
    
    hub = IOHub()
    
    @hub.on("display.frame")
    def on_frame(event):
        frame_count[0] += 1
        print(f"  [Display] Frame #{frame_count[0]}: {len(event.data)} bytes")
    
    @hub.on("speaker.audio")
    def on_audio(event):
        audio_count[0] += 1
        if audio_count[0] % 10 == 0:
            print(f"  [Speaker] Audio chunks received: {audio_count[0]}")
    
    @hub.on("printer.command")
    def on_printer_cmd(event):
        print(f"  [Printer] Command: {event.data['code']} {event.data['params']}")
    
    @hub.on("printer.move")
    def on_printer_move(event):
        data = event.data
        print(f"  [Printer] Move: X={data['x']:.1f} Y={data['y']:.1f} Z={data['z']:.1f}")
    
    try:
        # Start hub
        status = hub.start(display_fps=0.5)  # Slow FPS for demo
        
        print("\nDevice status:")
        for device, stat in status.items():
            print(f"  {device}: {stat}")
        
        if hub.is_device_available("printer"):
            print(f"\nPrinter available at: {hub.get_printer_port()}")
            print("Connect your slicer software to this port!")
        
        print("\nHub running. Press Ctrl+C to stop...")
        
        # Keep running for demo
        while True:
            time.sleep(1)
            
    except KeyboardInterrupt:
        print("\n\nStopping...")
    finally:
        hub.stop()
        print("Hub stopped.")
        print(f"\nStats: {frame_count[0]} frames, {audio_count[0]} audio chunks")


if __name__ == "__main__":
    main()
