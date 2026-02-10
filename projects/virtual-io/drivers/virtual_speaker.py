#!/usr/bin/env python3
"""
Virtual Speaker (Audio Sink) Capture Module

Captures audio output using PipeWire, PulseAudio, or ALSA.
Creates a virtual sink and captures audio from its monitor.

Usage:
    from virtual_speaker import VirtualSpeaker
    
    speaker = VirtualSpeaker()
    speaker.create_sink("ai_agent_sink")
    
    # Capture audio
    for chunk in speaker.stream_audio():
        process(chunk)
    
    # Or save to file
    speaker.capture_to_file("output.wav", duration=10)
"""

import os
import io
import subprocess
import shutil
import time
import struct
import wave
import threading
from typing import Iterator, Optional, Callable, Tuple
from dataclasses import dataclass
from pathlib import Path
from queue import Queue, Empty

# Try optional imports
try:
    import numpy as np
    HAS_NUMPY = True
except ImportError:
    HAS_NUMPY = False


@dataclass
class AudioFormat:
    """Audio format specification."""
    sample_rate: int = 48000
    channels: int = 2
    bits: int = 16
    format: str = "s16le"  # signed 16-bit little-endian


class AudioBackend:
    """Base class for audio backends."""
    
    name: str = "base"
    
    def is_available(self) -> bool:
        raise NotImplementedError
    
    def create_sink(self, name: str, description: str = "") -> bool:
        raise NotImplementedError
    
    def remove_sink(self, name: str) -> bool:
        raise NotImplementedError
    
    def list_sinks(self) -> list:
        raise NotImplementedError
    
    def capture_from_monitor(self, sink_name: str, format: AudioFormat) -> subprocess.Popen:
        raise NotImplementedError
    
    def set_default_sink(self, name: str) -> bool:
        raise NotImplementedError


class PipeWireBackend(AudioBackend):
    """PipeWire audio backend."""
    
    name = "pipewire"
    
    def is_available(self) -> bool:
        return shutil.which("pw-record") is not None and shutil.which("pw-cli") is not None
    
    def create_sink(self, name: str, description: str = "") -> bool:
        """Create virtual sink using PipeWire."""
        desc = description or f"Virtual Sink: {name}"
        
        # PipeWire uses module-null-sink from PulseAudio compatibility
        cmd = [
            "pactl", "load-module", "module-null-sink",
            f"sink_name={name}",
            f"sink_properties=device.description=\"{desc}\""
        ]
        
        try:
            result = subprocess.run(cmd, capture_output=True, text=True)
            return result.returncode == 0
        except Exception:
            return False
    
    def remove_sink(self, name: str) -> bool:
        """Remove virtual sink."""
        # Find and unload the module
        try:
            result = subprocess.run(
                ["pactl", "list", "short", "modules"],
                capture_output=True, text=True
            )
            
            for line in result.stdout.strip().split('\n'):
                if name in line and "module-null-sink" in line:
                    module_id = line.split()[0]
                    subprocess.run(["pactl", "unload-module", module_id])
                    return True
            return False
        except Exception:
            return False
    
    def list_sinks(self) -> list:
        """List available sinks."""
        try:
            result = subprocess.run(
                ["pw-cli", "list-objects", "Node"],
                capture_output=True, text=True
            )
            
            sinks = []
            current = {}
            for line in result.stdout.split('\n'):
                if 'node.name' in line:
                    if 'media.class = "Audio/Sink"' in result.stdout:
                        name = line.split('=')[-1].strip().strip('"')
                        sinks.append(name)
            
            return sinks
        except Exception:
            return []
    
    def capture_from_monitor(self, sink_name: str, format: AudioFormat) -> subprocess.Popen:
        """Start capturing from sink monitor."""
        fmt_map = {
            16: "s16",
            32: "f32"
        }
        
        cmd = [
            "pw-record",
            "--target", f"{sink_name}.monitor",
            "--format", fmt_map.get(format.bits, "s16"),
            "--rate", str(format.sample_rate),
            "--channels", str(format.channels),
            "-"
        ]
        
        return subprocess.Popen(cmd, stdout=subprocess.PIPE, stderr=subprocess.DEVNULL)
    
    def set_default_sink(self, name: str) -> bool:
        try:
            subprocess.run(["pactl", "set-default-sink", name], check=True)
            return True
        except Exception:
            return False


class PulseAudioBackend(AudioBackend):
    """PulseAudio audio backend."""
    
    name = "pulseaudio"
    
    def is_available(self) -> bool:
        return shutil.which("pactl") is not None and shutil.which("parec") is not None
    
    def create_sink(self, name: str, description: str = "") -> bool:
        desc = description or f"Virtual Sink: {name}"
        
        cmd = [
            "pactl", "load-module", "module-null-sink",
            f"sink_name={name}",
            f"sink_properties=device.description=\"{desc}\""
        ]
        
        try:
            result = subprocess.run(cmd, capture_output=True, text=True)
            return result.returncode == 0
        except Exception:
            return False
    
    def remove_sink(self, name: str) -> bool:
        try:
            result = subprocess.run(
                ["pactl", "list", "short", "modules"],
                capture_output=True, text=True
            )
            
            for line in result.stdout.strip().split('\n'):
                if name in line and "module-null-sink" in line:
                    module_id = line.split()[0]
                    subprocess.run(["pactl", "unload-module", module_id])
                    return True
            return False
        except Exception:
            return False
    
    def list_sinks(self) -> list:
        try:
            result = subprocess.run(
                ["pactl", "list", "short", "sinks"],
                capture_output=True, text=True
            )
            
            sinks = []
            for line in result.stdout.strip().split('\n'):
                if line:
                    parts = line.split()
                    if len(parts) >= 2:
                        sinks.append(parts[1])
            return sinks
        except Exception:
            return []
    
    def capture_from_monitor(self, sink_name: str, format: AudioFormat) -> subprocess.Popen:
        fmt_map = {
            16: "s16le",
            32: "float32le"
        }
        
        cmd = [
            "parec",
            "-d", f"{sink_name}.monitor",
            "--format", fmt_map.get(format.bits, "s16le"),
            "--rate", str(format.sample_rate),
            "--channels", str(format.channels),
            "--file-format=raw"
        ]
        
        return subprocess.Popen(cmd, stdout=subprocess.PIPE, stderr=subprocess.DEVNULL)
    
    def set_default_sink(self, name: str) -> bool:
        try:
            subprocess.run(["pactl", "set-default-sink", name], check=True)
            return True
        except Exception:
            return False


class ALSABackend(AudioBackend):
    """ALSA audio backend (limited functionality)."""
    
    name = "alsa"
    
    def is_available(self) -> bool:
        return shutil.which("arecord") is not None
    
    def create_sink(self, name: str, description: str = "") -> bool:
        # ALSA doesn't support dynamic sink creation
        # User needs to configure snd-aloop kernel module
        return False
    
    def remove_sink(self, name: str) -> bool:
        return False
    
    def list_sinks(self) -> list:
        try:
            result = subprocess.run(
                ["aplay", "-l"],
                capture_output=True, text=True
            )
            
            cards = []
            for line in result.stdout.split('\n'):
                if line.startswith('card'):
                    # Extract card name
                    parts = line.split(':')
                    if len(parts) >= 2:
                        cards.append(parts[1].split(',')[0].strip())
            return cards
        except Exception:
            return []
    
    def capture_from_monitor(self, sink_name: str, format: AudioFormat) -> subprocess.Popen:
        # For ALSA, we need snd-aloop module loaded
        # Capture from the loopback device
        fmt_map = {
            16: "S16_LE",
            32: "FLOAT_LE"
        }
        
        cmd = [
            "arecord",
            "-f", fmt_map.get(format.bits, "S16_LE"),
            "-r", str(format.sample_rate),
            "-c", str(format.channels),
            "-t", "raw",
            "-"
        ]
        
        return subprocess.Popen(cmd, stdout=subprocess.PIPE, stderr=subprocess.DEVNULL)
    
    def set_default_sink(self, name: str) -> bool:
        return False


class VirtualSpeaker:
    """
    Virtual speaker (audio sink) for AI agents.
    
    Creates a virtual audio sink and captures audio from its monitor.
    """
    
    def __init__(self, format: Optional[AudioFormat] = None):
        """
        Initialize virtual speaker.
        
        Args:
            format: Audio format specification
        """
        self.format = format or AudioFormat()
        self.backend = self._detect_backend()
        self._capture_proc: Optional[subprocess.Popen] = None
        self._sink_name: Optional[str] = None
        self._audio_queue: Queue = Queue(maxsize=1000)
        self._running = False
        self._capture_thread: Optional[threading.Thread] = None
        
        if not self.backend:
            raise RuntimeError("No audio backend available. Install PipeWire, PulseAudio, or ALSA tools.")
    
    def _detect_backend(self) -> Optional[AudioBackend]:
        """Detect available audio backend."""
        backends = [
            PipeWireBackend(),
            PulseAudioBackend(),
            ALSABackend()
        ]
        
        for backend in backends:
            if backend.is_available():
                return backend
        
        return None
    
    def create_sink(self, name: str = "ai_agent_sink", description: str = "") -> bool:
        """
        Create a virtual audio sink.
        
        Args:
            name: Sink name (used for identification)
            description: Human-readable description
        
        Returns:
            True if sink was created successfully
        """
        self._sink_name = name
        return self.backend.create_sink(name, description or "AI Agent Virtual Speaker")
    
    def remove_sink(self) -> bool:
        """Remove the virtual sink."""
        if self._sink_name:
            return self.backend.remove_sink(self._sink_name)
        return False
    
    def list_sinks(self) -> list:
        """List available audio sinks."""
        return self.backend.list_sinks()
    
    def set_as_default(self) -> bool:
        """Set the virtual sink as the default audio output."""
        if self._sink_name:
            return self.backend.set_default_sink(self._sink_name)
        return False
    
    def start_capture(self, sink_name: Optional[str] = None) -> None:
        """
        Start capturing audio from sink monitor.
        
        Args:
            sink_name: Name of sink to capture from (uses created sink if not specified)
        """
        sink = sink_name or self._sink_name
        if not sink:
            raise ValueError("No sink specified. Create a sink first or provide sink_name.")
        
        self._capture_proc = self.backend.capture_from_monitor(sink, self.format)
        self._running = True
        
        # Start capture thread
        self._capture_thread = threading.Thread(target=self._capture_loop)
        self._capture_thread.daemon = True
        self._capture_thread.start()
    
    def _capture_loop(self) -> None:
        """Background thread for reading audio data."""
        bytes_per_sample = self.format.bits // 8
        chunk_samples = 1024
        chunk_bytes = chunk_samples * self.format.channels * bytes_per_sample
        
        while self._running and self._capture_proc:
            data = self._capture_proc.stdout.read(chunk_bytes)
            if data:
                try:
                    self._audio_queue.put_nowait(data)
                except Exception:
                    pass  # Queue full, drop oldest
    
    def stop_capture(self) -> None:
        """Stop capturing audio."""
        self._running = False
        
        if self._capture_proc:
            self._capture_proc.terminate()
            self._capture_proc.wait()
            self._capture_proc = None
        
        if self._capture_thread:
            self._capture_thread.join(timeout=1.0)
            self._capture_thread = None
    
    def get_audio_chunk(self, timeout: float = 1.0) -> Optional[bytes]:
        """
        Get next audio chunk from capture buffer.
        
        Args:
            timeout: Seconds to wait for data
        
        Returns:
            Raw audio bytes or None if timeout
        """
        try:
            return self._audio_queue.get(timeout=timeout)
        except Empty:
            return None
    
    def get_audio_numpy(self, timeout: float = 1.0) -> Optional["np.ndarray"]:
        """
        Get next audio chunk as numpy array.
        
        Returns:
            numpy array of shape (samples, channels) or None
        """
        if not HAS_NUMPY:
            raise ImportError("numpy is required for this method")
        
        data = self.get_audio_chunk(timeout)
        if data is None:
            return None
        
        if self.format.bits == 16:
            samples = np.frombuffer(data, dtype=np.int16)
        elif self.format.bits == 32:
            samples = np.frombuffer(data, dtype=np.float32)
        else:
            samples = np.frombuffer(data, dtype=np.int16)
        
        return samples.reshape(-1, self.format.channels)
    
    def stream_audio(self, duration: Optional[float] = None) -> Iterator[bytes]:
        """
        Stream audio chunks.
        
        Args:
            duration: Optional duration in seconds
        
        Yields:
            Raw audio bytes
        """
        start_time = time.time()
        
        while True:
            if duration and (time.time() - start_time) >= duration:
                break
            
            chunk = self.get_audio_chunk(timeout=0.5)
            if chunk:
                yield chunk
    
    def capture_to_file(self, path: str, duration: float, sink_name: Optional[str] = None) -> bool:
        """
        Capture audio to WAV file.
        
        Args:
            path: Output file path
            duration: Duration in seconds
            sink_name: Optional sink name (uses created sink if not specified)
        
        Returns:
            True if capture succeeded
        """
        sink = sink_name or self._sink_name
        if not sink:
            raise ValueError("No sink specified")
        
        # Calculate expected size
        bytes_per_sample = self.format.bits // 8
        expected_bytes = int(
            duration * self.format.sample_rate * self.format.channels * bytes_per_sample
        )
        
        # Capture audio
        self.start_capture(sink)
        
        audio_data = []
        captured_bytes = 0
        
        try:
            start_time = time.time()
            while captured_bytes < expected_bytes and (time.time() - start_time) < duration + 1:
                chunk = self.get_audio_chunk(timeout=0.5)
                if chunk:
                    audio_data.append(chunk)
                    captured_bytes += len(chunk)
        finally:
            self.stop_capture()
        
        # Write WAV file
        raw_audio = b''.join(audio_data)
        
        with wave.open(path, 'wb') as wf:
            wf.setnchannels(self.format.channels)
            wf.setsampwidth(self.format.bits // 8)
            wf.setframerate(self.format.sample_rate)
            wf.writeframes(raw_audio)
        
        return True
    
    def get_backend_name(self) -> str:
        """Get name of the audio backend being used."""
        return self.backend.name if self.backend else "none"
    
    def cleanup(self) -> None:
        """Clean up resources."""
        self.stop_capture()
        self.remove_sink()
    
    def __enter__(self):
        return self
    
    def __exit__(self, exc_type, exc_val, exc_tb):
        self.cleanup()


def list_available_backends() -> list:
    """List all available audio backends."""
    backends = []
    
    if PipeWireBackend().is_available():
        backends.append(("pipewire", "PipeWire (recommended)"))
    if PulseAudioBackend().is_available():
        backends.append(("pulseaudio", "PulseAudio"))
    if ALSABackend().is_available():
        backends.append(("alsa", "ALSA (limited)"))
    
    return backends


if __name__ == "__main__":
    print("Virtual Speaker (Audio Sink) Module")
    print("=" * 40)
    
    backends = list_available_backends()
    if backends:
        print("Available audio backends:")
        for name, desc in backends:
            print(f"  - {name}: {desc}")
        
        try:
            speaker = VirtualSpeaker()
            print(f"\nUsing backend: {speaker.get_backend_name()}")
            
            # List existing sinks
            sinks = speaker.list_sinks()
            print(f"Existing sinks: {sinks}")
            
            # Try to create sink
            if speaker.create_sink("test_ai_sink"):
                print("Created virtual sink: test_ai_sink")
                print("(Audio output can now be routed to this sink)")
                
                # Clean up
                speaker.remove_sink()
                print("Removed virtual sink")
            else:
                print("Could not create sink (may require audio daemon)")
                
        except Exception as e:
            print(f"Error: {e}")
    else:
        print("No audio backends available!")
        print("Install PipeWire or PulseAudio")
