# Virtual I/O Drivers for AI Agents

Virtual device drivers that give AI agents direct peripheral-level access to computer systems.

## Overview

This package provides Python modules for:

| Module | Purpose |
|--------|---------|
| `virtual_display.py` | Capture screen/display output |
| `virtual_speaker.py` | Capture audio output (create virtual sink) |
| `virtual_mic.py` | Inject audio as microphone input |
| `virtual_printer.py` | G-code processing and virtual 3D printer |
| `io_hub.py` | Unified controller for all devices |

## Quick Start

```python
from io_hub import IOHub

# Create and start the hub
hub = IOHub()
hub.start()

# Register event handlers
@hub.on("display.frame")
def on_frame(event):
    print(f"Captured frame: {len(event.data)} bytes")

@hub.on("speaker.audio")
def on_audio(event):
    process_audio(event.data)

# Use devices
hub.speak(audio_bytes)  # Output through virtual mic
frame = hub.capture_frame()  # Get screenshot
hub.save_screenshot("/tmp/screen.png")

# Get printer port
port = hub.get_printer_port()
print(f"Connect slicer to: {port}")
```

## Requirements

### Minimal (Standard Library Only)

The modules work with Python 3.8+ standard library. For basic functionality:

- Python 3.8+
- Linux with X11 (for display capture)

### Recommended Dependencies

```bash
# Ubuntu/Debian
sudo apt install scrot python3-pip pipewire pipewire-pulse

# Optional: Better screen capture
sudo apt install maim imagemagick

# Optional: FFmpeg for audio/video
sudo apt install ffmpeg

# Python packages (optional, for enhanced features)
pip3 install pillow numpy mss
```

### Audio Backend Setup

#### PipeWire (Recommended)

Modern Linux distributions use PipeWire. Virtual audio devices work automatically.

```bash
# Check if PipeWire is running
systemctl --user status pipewire

# List available sinks
pw-cli list-objects Node | grep Audio
```

#### PulseAudio

For systems using PulseAudio:

```bash
# Install PulseAudio tools
sudo apt install pulseaudio-utils

# Create virtual sink manually
pactl load-module module-null-sink sink_name=ai_sink

# List sinks
pactl list short sinks
```

## Module Details

### Virtual Display

Captures screen frames using available tools (prioritized):
1. `mss` - Python library (fastest)
2. `scrot` - CLI tool
3. `maim` - CLI tool
4. `import` - ImageMagick
5. `xwd` - X Window Dump
6. `ffmpeg` - Video encoder

```python
from virtual_display import VirtualDisplay

display = VirtualDisplay(display=":0")

# Capture single frame (returns PNG bytes)
frame = display.capture_frame()

# Capture as PIL Image (requires pillow)
img = display.capture_frame_pil()

# Capture as numpy array (requires pillow + numpy)
arr = display.capture_frame_numpy()

# Stream frames at 30 FPS
for frame in display.stream_frames(fps=30, duration=10):
    process(frame)

# Capture specific region
display = VirtualDisplay(region=(100, 100, 800, 600))
```

### Virtual Speaker (Audio Capture)

Creates virtual audio sink and captures what's "played" to it.

```python
from virtual_speaker import VirtualSpeaker

speaker = VirtualSpeaker()
speaker.create_sink("ai_sink", "AI Agent Speaker")

# Set as default output
speaker.set_as_default()

# Capture audio
speaker.start_capture()
for chunk in speaker.stream_audio(duration=10):
    process(chunk)

# Save to WAV file
speaker.capture_to_file("output.wav", duration=5)
```

**How it works:**
1. Creates a virtual sink using PipeWire/PulseAudio
2. Applications play audio to this sink
3. We capture from the sink's monitor port

### Virtual Microphone (Audio Injection)

Creates virtual audio source that applications see as a microphone.

```python
from virtual_mic import VirtualMicrophone

mic = VirtualMicrophone()
mic.create_source("ai_mic", "AI Agent Microphone")

# Set as default mic
mic.set_as_default()

# Play audio file through virtual mic
mic.play_file("speech.wav")

# Write raw audio data
mic.write_audio(audio_bytes)

# Generate test tone (requires numpy)
mic.generate_tone(440, 1.0)  # 440Hz for 1 second
```

**Use cases:**
- TTS output to voice chat
- Audio injection for testing
- AI speaking in voice calls

### Virtual 3D Printer

Simulates a 3D printer with G-code support. Creates a PTY that acts as a serial port.

```python
from virtual_printer import VirtualPrinter, GCodeGenerator

# Start virtual printer
printer = VirtualPrinter()
port = printer.start()
print(f"Connect slicer to: {port}")  # e.g., /dev/pts/5

# Handle commands
printer.on_command = lambda cmd, state: print(f"Got: {cmd.code}")
printer.on_move = lambda state: print(f"Pos: {state.x}, {state.y}, {state.z}")

# Generate G-code
gcode = GCodeGenerator()
gcode.start_print(bed_temp=60, hotend_temp=200)
gcode.draw_rectangle(100, 100, 20, 20, 0.3)
gcode.draw_circle(110, 110, 10, 0.5)
gcode.end_print()
gcode.save("test.gcode")
```

**Supported G-codes:**
- G0, G1 - Move/Extrude
- G28 - Home
- G90, G91 - Absolute/Relative
- G92 - Set position
- M104, M109 - Hotend temperature
- M140, M190 - Bed temperature
- M105 - Report temperatures
- M114 - Report position
- M115 - Firmware info
- M82, M83 - Extrusion mode
- M106, M107 - Fan control
- M84 - Disable steppers

### I/O Hub (Central Controller)

Unified interface for all devices with event-driven architecture.

```python
from io_hub import IOHub, IOEvent

hub = IOHub(
    enable_display=True,
    enable_speaker=True,
    enable_mic=True,
    enable_printer=True
)

# Register handlers using decorator
@hub.on("display.frame")
def handle_frame(event: IOEvent):
    print(f"Frame at {event.timestamp}: {len(event.data)} bytes")

@hub.on("speaker.audio")
def handle_audio(event: IOEvent):
    print(f"Audio chunk: {len(event.data)} bytes")

@hub.on("printer.command")
def handle_printer(event: IOEvent):
    print(f"G-code: {event.data['code']}")

# Start all devices
status = hub.start(
    display_fps=1.0,
    audio_sink_name="ai_sink",
    audio_source_name="ai_mic"
)

print(hub.get_status())

# Use device methods
hub.capture_frame()
hub.speak(audio_data)
hub.speak_file("hello.wav")

# Cleanup
hub.stop()
```

## Testing

Run each module directly to test:

```bash
# Test display capture
python3 virtual_display.py

# Test audio capture
python3 virtual_speaker.py

# Test audio injection
python3 virtual_mic.py

# Test printer
python3 virtual_printer.py

# Test hub
python3 io_hub.py
```

## Troubleshooting

### Display Capture

**"No capture method available"**
```bash
# Install scrot (simplest)
sudo apt install scrot

# Or install mss (fastest)
pip3 install mss
```

**"Cannot open display"**
```bash
# Set DISPLAY variable
export DISPLAY=:0

# For Wayland, some tools may not work
# Use wlroots-based tools or enable XWayland
```

### Audio

**"No audio backend available"**
```bash
# Check what's running
systemctl --user status pipewire pulseaudio

# Install PipeWire tools
sudo apt install pipewire-pulse

# Or install PulseAudio tools
sudo apt install pulseaudio-utils
```

**"Sink creation failed"**
```bash
# Make sure audio daemon is running
systemctl --user start pipewire pipewire-pulse

# Check permissions
id  # Should show 'audio' group
```

### Printer

**"Cannot connect to virtual printer"**
```bash
# Check PTY permissions
ls -la /dev/pts/

# May need to be in 'tty' group
sudo usermod -aG tty $USER
```

## Architecture

```
┌─────────────────────────────────────────────────────────┐
│                        IOHub                             │
│  (Central Controller + Event Emitter)                   │
├─────────────────────────────────────────────────────────┤
│                                                          │
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐      │
│  │   Display   │  │   Speaker   │  │     Mic     │      │
│  │   Capture   │  │   Capture   │  │  Injection  │      │
│  └──────┬──────┘  └──────┬──────┘  └──────┬──────┘      │
│         │                │                │              │
│  ┌──────▼──────┐  ┌──────▼──────┐  ┌──────▼──────┐      │
│  │ scrot/mss/  │  │  PipeWire/  │  │  PipeWire/  │      │
│  │  X11/etc    │  │ PulseAudio  │  │ PulseAudio  │      │
│  └─────────────┘  └─────────────┘  └─────────────┘      │
│                                                          │
│  ┌─────────────────────────────────────────────────┐    │
│  │              Virtual Printer                     │    │
│  │  (PTY Serial Port + G-code Processor)           │    │
│  └─────────────────────────────────────────────────┘    │
│                                                          │
└─────────────────────────────────────────────────────────┘
                          ▼
              ┌─────────────────────┐
              │     AI Agent        │
              │  (Event Handlers)   │
              └─────────────────────┘
```

## Security Notes

- Virtual devices require appropriate permissions
- Audio devices can capture system audio (privacy concern)
- Virtual printer port is accessible to all users
- Consider running in isolated environment for sensitive applications

## License

MIT License - See LICENSE file
