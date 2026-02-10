# Virtual I/O Device Implementation Guide for AI Agents

**Purpose:** Enable AI agents to have direct peripheral-level access to computer systems through virtual device drivers and interfaces.

**Last Updated:** 2026-02-07

---

## Table of Contents

1. [Virtual Display Adapter/Driver](#1-virtual-display-adapterdriver)
2. [Virtual Audio Speaker Sink](#2-virtual-audio-speaker-sink)
3. [Virtual Microphone Source](#3-virtual-microphone-source)
4. [Virtual 3D Printer Controller](#4-virtual-3d-printer-controller)
5. [Holographic Display Drivers](#5-holographic-display-drivers)
6. [Cross-Platform Considerations](#6-cross-platform-considerations)
7. [AI Agent Integration Patterns](#7-ai-agent-integration-patterns)
8. [Real-Time Streaming Considerations](#8-real-time-streaming-considerations)

---

## 1. Virtual Display Adapter/Driver

### Overview
Capture video output at the device level (not screen capture) by creating virtual GPU/display adapters that intercept the video pipeline before it reaches physical hardware.

### Existing Solutions

#### DRM Virtual Driver (vkms)
The Linux kernel includes **VKMS (Virtual Kernel Mode Setting)** - a software-only KMS driver for testing and headless operation.

```bash
# Load the virtual KMS driver
sudo modprobe vkms

# Check if loaded
ls /sys/devices/virtual/drm/
```

**Key Features:**
- Implements full DRM/KMS pipeline
- Supports atomic mode setting
- CRC capture for frame validation
- Writeback connector support

**Kernel Configuration:**
```
CONFIG_DRM_VKMS=m
```

#### evdi (Extensible Virtual Display Interface)
DisplayLink's open-source virtual display driver for creating software displays.

```bash
# Install from source
git clone https://github.com/DisplayLink/evdi.git
cd evdi
make
sudo make install

# Load module
sudo modprobe evdi
```

**Python Integration:**
```python
import ctypes
import struct

# Open evdi device
evdi = ctypes.CDLL("libevdi.so")
handle = evdi.evdi_open(0)  # Opens /dev/dri/card0

# Register for frame updates
# evdi provides callbacks for new frames
```

#### Building a Custom Virtual DRM Driver

**Minimal kernel module structure:**

```c
// virtual_gpu.c
#include <linux/module.h>
#include <drm/drm_drv.h>
#include <drm/drm_gem.h>
#include <drm/drm_atomic_helper.h>
#include <drm/drm_probe_helper.h>

static struct drm_driver virtual_gpu_driver = {
    .driver_features = DRIVER_MODESET | DRIVER_GEM | DRIVER_ATOMIC,
    .name = "virtual_gpu",
    .desc = "Virtual GPU for AI Agent",
    .date = "20260207",
    .major = 1,
    .minor = 0,
    
    // DRM gem callbacks for buffer management
    .gem_create_object = virtual_gpu_gem_create_object,
    .dumb_create = virtual_gpu_dumb_create,
    .dumb_map_offset = virtual_gpu_dumb_map_offset,
    
    // IOCTL for AI agent communication
    .ioctls = virtual_gpu_ioctls,
    .num_ioctls = ARRAY_SIZE(virtual_gpu_ioctls),
};

// Frame capture callback - this is what the AI agent reads
static void virtual_gpu_writeback_job(struct drm_writeback_job *job) {
    struct drm_framebuffer *fb = job->fb;
    void *vaddr;
    
    // Map framebuffer to CPU-accessible memory
    vaddr = drm_gem_vmap(fb->obj[0]);
    
    // Copy to shared memory for AI agent access
    memcpy(ai_agent_framebuffer, vaddr, fb->width * fb->height * 4);
    
    // Signal AI agent that new frame is ready
    wake_up_interruptible(&ai_agent_wait_queue);
}
```

#### Frame Capture Architecture

```
┌─────────────────┐
│  Application    │
│   (GPU output)  │
└────────┬────────┘
         │ DRM/KMS
         ▼
┌─────────────────┐
│  Virtual GPU    │
│   Driver        │
│  (kernel space) │
└────────┬────────┘
         │ Shared Memory / DMA-BUF
         ▼
┌─────────────────┐
│  AI Agent       │
│   Interface     │
│  (user space)   │
└─────────────────┘
```

### Integration with AI Agents

**User-space frame reader using DRM:**

```python
#!/usr/bin/env python3
"""Virtual display frame capture for AI agents."""

import os
import mmap
import ctypes
from fcntl import ioctl

class VirtualDisplayCapture:
    DRM_IOCTL_MODE_MAP_DUMB = 0xC01064B3
    
    def __init__(self, device="/dev/dri/card1"):
        self.fd = os.open(device, os.O_RDWR)
        self.width = 1920
        self.height = 1080
        self.pitch = self.width * 4
        self._setup_framebuffer()
    
    def _setup_framebuffer(self):
        # Create dumb buffer
        create_req = struct.pack("IIIIQ", 
            self.width, self.height, 32, 0, 0)
        result = ioctl(self.fd, DRM_IOCTL_MODE_CREATE_DUMB, create_req)
        
        # Memory map for direct access
        self.buffer = mmap.mmap(self.fd, self.width * self.height * 4,
                                prot=mmap.PROT_READ)
    
    def capture_frame(self):
        """Returns current framebuffer as bytes."""
        return bytes(self.buffer)
    
    def capture_frame_numpy(self):
        """Returns frame as numpy array for AI processing."""
        import numpy as np
        return np.frombuffer(self.buffer, dtype=np.uint8).reshape(
            self.height, self.width, 4)
```

---

## 2. Virtual Audio Speaker Sink

### Overview
Create virtual audio output devices that receive the audio stream intended for speakers, making it available to AI agents for processing.

### PipeWire (Recommended for Modern Linux)

PipeWire is the modern multimedia framework replacing PulseAudio and JACK.

#### Creating a Virtual Sink

```bash
# Create a null sink (virtual speaker)
pactl load-module module-null-sink \
    sink_name=ai_agent_sink \
    sink_properties=device.description="AI_Agent_Speaker"

# Or with PipeWire native config
cat >> ~/.config/pipewire/pipewire.conf.d/virtual-sink.conf << 'EOF'
context.objects = [
    {
        factory = adapter
        args = {
            factory.name = support.null-audio-sink
            node.name = "ai_agent_sink"
            media.class = Audio/Sink
            audio.position = [ FL FR ]
            monitor.channel-volumes = true
            monitor.passthrough = true
        }
    }
]
EOF
```

#### Capturing Audio from Virtual Sink

**Python with PipeWire:**

```python
#!/usr/bin/env python3
"""Virtual audio sink capture for AI agents."""

import subprocess
import numpy as np
from threading import Thread
from queue import Queue

class VirtualAudioCapture:
    def __init__(self, sink_name="ai_agent_sink", sample_rate=48000):
        self.sink_name = sink_name
        self.sample_rate = sample_rate
        self.audio_queue = Queue(maxsize=100)
        self._running = False
    
    def start_capture(self):
        """Start capturing audio from virtual sink monitor."""
        self._running = True
        self._capture_thread = Thread(target=self._capture_loop)
        self._capture_thread.start()
    
    def _capture_loop(self):
        # Use pw-record to capture from sink monitor
        cmd = [
            "pw-record",
            "--target", f"{self.sink_name}.monitor",
            "--format", "f32",
            "--rate", str(self.sample_rate),
            "--channels", "2",
            "-"  # Output to stdout
        ]
        
        proc = subprocess.Popen(cmd, stdout=subprocess.PIPE)
        
        while self._running:
            # Read 1024 samples (4096 bytes for float32 stereo)
            data = proc.stdout.read(4096 * 2)
            if data:
                audio = np.frombuffer(data, dtype=np.float32)
                self.audio_queue.put(audio.reshape(-1, 2))
    
    def get_audio_chunk(self, timeout=1.0):
        """Get next audio chunk for AI processing."""
        return self.audio_queue.get(timeout=timeout)
    
    def stop(self):
        self._running = False
```

**C with PipeWire API:**

```c
// virtual_audio_capture.c
#include <pipewire/pipewire.h>
#include <spa/param/audio/format-utils.h>

struct audio_data {
    struct pw_main_loop *loop;
    struct pw_stream *stream;
    float *buffer;
    size_t buffer_size;
    void (*callback)(float *samples, size_t count, void *userdata);
    void *userdata;
};

static void on_process(void *userdata) {
    struct audio_data *data = userdata;
    struct pw_buffer *b;
    struct spa_buffer *buf;
    float *samples;
    uint32_t n_samples;
    
    if ((b = pw_stream_dequeue_buffer(data->stream)) == NULL)
        return;
    
    buf = b->buffer;
    samples = buf->datas[0].data;
    n_samples = buf->datas[0].chunk->size / sizeof(float);
    
    // Call AI agent callback with audio samples
    if (data->callback)
        data->callback(samples, n_samples, data->userdata);
    
    pw_stream_queue_buffer(data->stream, b);
}

// Connect to virtual sink monitor
int capture_virtual_audio(const char *sink_name,
                          void (*callback)(float*, size_t, void*),
                          void *userdata) {
    pw_init(NULL, NULL);
    
    struct audio_data data = {
        .callback = callback,
        .userdata = userdata
    };
    
    data.loop = pw_main_loop_new(NULL);
    
    char target[256];
    snprintf(target, sizeof(target), "%s.monitor", sink_name);
    
    struct pw_properties *props = pw_properties_new(
        PW_KEY_MEDIA_TYPE, "Audio",
        PW_KEY_MEDIA_CATEGORY, "Capture",
        PW_KEY_TARGET_OBJECT, target,
        NULL);
    
    data.stream = pw_stream_new_simple(
        pw_main_loop_get_loop(data.loop),
        "ai-agent-capture",
        props,
        &stream_events,
        &data);
    
    // Start capture
    pw_stream_connect(data.stream,
        PW_DIRECTION_INPUT,
        PW_ID_ANY,
        PW_STREAM_FLAG_AUTOCONNECT,
        params, n_params);
    
    pw_main_loop_run(data.loop);
    return 0;
}
```

### PulseAudio (Legacy but widely supported)

```bash
# Load null sink module
pactl load-module module-null-sink sink_name=ai_speaker

# Record from monitor (what's being "played" to the sink)
parec -d ai_speaker.monitor --file-format=raw > /tmp/audio_capture.raw
```

---

## 3. Virtual Microphone Source

### Overview
Create virtual audio input devices that allow AI agents to inject audio into applications as if it came from a physical microphone.

### PipeWire Virtual Source

```bash
# Create virtual microphone source
cat >> ~/.config/pipewire/pipewire.conf.d/virtual-mic.conf << 'EOF'
context.objects = [
    {
        factory = adapter
        args = {
            factory.name = support.null-audio-sink
            node.name = "ai_agent_mic"
            node.description = "AI Agent Microphone"
            media.class = Audio/Source/Virtual
            audio.position = [ FL FR ]
        }
    }
]
EOF
```

### Writing Audio to Virtual Microphone

**Python implementation:**

```python
#!/usr/bin/env python3
"""Virtual microphone for AI agent audio injection."""

import subprocess
import numpy as np
import struct

class VirtualMicrophone:
    def __init__(self, source_name="ai_agent_mic", sample_rate=48000):
        self.source_name = source_name
        self.sample_rate = sample_rate
        self._proc = None
    
    def start(self):
        """Start the virtual microphone pipeline."""
        # Use pw-cat to write audio to the virtual source
        cmd = [
            "pw-cat",
            "--target", self.source_name,
            "--format", "f32",
            "--rate", str(self.sample_rate),
            "--channels", "1",
            "-"  # Read from stdin
        ]
        self._proc = subprocess.Popen(cmd, stdin=subprocess.PIPE)
    
    def write_audio(self, samples: np.ndarray):
        """Write audio samples to virtual microphone.
        
        Args:
            samples: numpy array of float32 samples, mono, [-1.0, 1.0]
        """
        if self._proc is None:
            self.start()
        
        # Ensure correct format
        audio_data = samples.astype(np.float32).tobytes()
        self._proc.stdin.write(audio_data)
        self._proc.stdin.flush()
    
    def write_tts_output(self, audio_file: str):
        """Stream TTS output file to virtual microphone."""
        import soundfile as sf
        data, sr = sf.read(audio_file)
        
        # Resample if needed
        if sr != self.sample_rate:
            import librosa
            data = librosa.resample(data, orig_sr=sr, target_sr=self.sample_rate)
        
        self.write_audio(data)
    
    def stop(self):
        if self._proc:
            self._proc.stdin.close()
            self._proc.wait()
```

### Module-Based Virtual Microphone (snd-aloop)

The kernel's ALSA loopback module creates virtual audio devices:

```bash
# Load ALSA loopback module
sudo modprobe snd-aloop

# This creates:
# - Playback: hw:Loopback,0,0 (write here)
# - Capture: hw:Loopback,1,0 (apps read from here)
```

**Python with ALSA loopback:**

```python
import alsaaudio

class ALSAVirtualMic:
    def __init__(self, card="Loopback", device=0, subdevice=0):
        self.pcm = alsaaudio.PCM(
            alsaaudio.PCM_PLAYBACK,
            alsaaudio.PCM_NORMAL,
            cardindex=self._find_card(card),
            device=f"hw:{card},{device},{subdevice}"
        )
        self.pcm.setchannels(1)
        self.pcm.setrate(48000)
        self.pcm.setformat(alsaaudio.PCM_FORMAT_FLOAT_LE)
        self.pcm.setperiodsize(1024)
    
    def write(self, samples):
        """Write float samples to virtual mic."""
        self.pcm.write(samples.tobytes())
```

---

## 4. Virtual 3D Printer Controller

### Overview
Create a virtual 3D printer that accepts G-code commands, allowing AI agents to control or simulate 3D printing operations.

### G-Code Protocol Basics

3D printers use G-code commands over serial (USB) connections:

```gcode
; Example G-code for AI agent
G28              ; Home all axes
G1 Z5 F1000      ; Move Z up 5mm at 1000mm/min
G1 X50 Y50 F3000 ; Move to position
M104 S200        ; Set hotend temp to 200°C
M109 S200        ; Wait for temp
G1 E10 F100      ; Extrude 10mm filament
```

### Virtual Serial Port Approach

**Create virtual serial port pair using socat:**

```bash
# Create virtual serial port pair
socat -d -d pty,raw,echo=0,link=/tmp/printer pty,raw,echo=0,link=/tmp/controller &

# Now:
# - AI agent writes G-code to /tmp/controller
# - Applications (OctoPrint, etc.) connect to /tmp/printer
```

### Python Virtual Printer Controller

```python
#!/usr/bin/env python3
"""Virtual 3D printer controller for AI agents."""

import os
import pty
import select
import re
from dataclasses import dataclass
from typing import Optional, Callable
import threading

@dataclass
class PrinterState:
    x: float = 0.0
    y: float = 0.0
    z: float = 0.0
    e: float = 0.0  # Extruder position
    hotend_temp: float = 20.0
    hotend_target: float = 0.0
    bed_temp: float = 20.0
    bed_target: float = 0.0
    feedrate: float = 1000.0
    is_homed: bool = False

class VirtualPrinter:
    """Simulates a 3D printer that accepts G-code."""
    
    def __init__(self, on_command: Optional[Callable] = None):
        self.state = PrinterState()
        self.on_command = on_command
        self._running = False
        
        # Create virtual serial ports
        self.master_fd, self.slave_fd = pty.openpty()
        self.port_name = os.ttyname(self.slave_fd)
        
        print(f"Virtual printer available at: {self.port_name}")
    
    def start(self):
        """Start listening for G-code commands."""
        self._running = True
        self._thread = threading.Thread(target=self._read_loop)
        self._thread.start()
    
    def _read_loop(self):
        buffer = ""
        while self._running:
            r, _, _ = select.select([self.master_fd], [], [], 0.1)
            if r:
                data = os.read(self.master_fd, 1024).decode('utf-8', errors='ignore')
                buffer += data
                
                # Process complete lines
                while '\n' in buffer:
                    line, buffer = buffer.split('\n', 1)
                    self._process_command(line.strip())
    
    def _process_command(self, cmd: str):
        """Process a G-code command."""
        if not cmd or cmd.startswith(';'):
            self._respond("ok")
            return
        
        # Parse command
        parts = cmd.upper().split()
        if not parts:
            return
        
        code = parts[0]
        params = self._parse_params(parts[1:])
        
        # Handle common commands
        if code == 'G0' or code == 'G1':
            self._handle_move(params)
        elif code == 'G28':
            self._handle_home(params)
        elif code == 'M104':
            self.state.hotend_target = params.get('S', 0)
        elif code == 'M105':
            self._respond(f"ok T:{self.state.hotend_temp:.1f}/{self.state.hotend_target:.1f} "
                         f"B:{self.state.bed_temp:.1f}/{self.state.bed_target:.1f}")
            return
        elif code == 'M114':
            self._respond(f"X:{self.state.x:.2f} Y:{self.state.y:.2f} "
                         f"Z:{self.state.z:.2f} E:{self.state.e:.2f}")
            return
        
        # Notify AI agent of command
        if self.on_command:
            self.on_command(code, params, self.state)
        
        self._respond("ok")
    
    def _parse_params(self, parts):
        """Parse G-code parameters like X10 Y20 F1000."""
        params = {}
        for part in parts:
            if len(part) > 1:
                key = part[0]
                try:
                    params[key] = float(part[1:])
                except ValueError:
                    pass
        return params
    
    def _handle_move(self, params):
        """Handle G0/G1 move commands."""
        if 'X' in params:
            self.state.x = params['X']
        if 'Y' in params:
            self.state.y = params['Y']
        if 'Z' in params:
            self.state.z = params['Z']
        if 'E' in params:
            self.state.e = params['E']
        if 'F' in params:
            self.state.feedrate = params['F']
    
    def _handle_home(self, params):
        """Handle G28 home command."""
        self.state.x = 0
        self.state.y = 0
        self.state.z = 0
        self.state.is_homed = True
    
    def _respond(self, msg: str):
        """Send response to connected software."""
        os.write(self.master_fd, (msg + '\n').encode())
    
    def stop(self):
        self._running = False
        if hasattr(self, '_thread'):
            self._thread.join()
        os.close(self.master_fd)
        os.close(self.slave_fd)


class AIGCodeGenerator:
    """AI agent interface for generating G-code."""
    
    def __init__(self, port: str):
        import serial
        self.serial = serial.Serial(port, 115200, timeout=1)
    
    def send_command(self, gcode: str) -> str:
        """Send G-code command and wait for response."""
        self.serial.write((gcode + '\n').encode())
        return self.serial.readline().decode().strip()
    
    def home(self):
        """Home all axes."""
        return self.send_command('G28')
    
    def move_to(self, x=None, y=None, z=None, feedrate=None):
        """Move to position."""
        cmd = 'G1'
        if x is not None:
            cmd += f' X{x}'
        if y is not None:
            cmd += f' Y{y}'
        if z is not None:
            cmd += f' Z{z}'
        if feedrate is not None:
            cmd += f' F{feedrate}'
        return self.send_command(cmd)
    
    def extrude(self, amount: float, feedrate: float = 100):
        """Extrude filament."""
        return self.send_command(f'G1 E{amount} F{feedrate}')
    
    def set_temperature(self, temp: float, wait: bool = False):
        """Set hotend temperature."""
        cmd = 'M109' if wait else 'M104'
        return self.send_command(f'{cmd} S{temp}')
    
    def get_position(self) -> dict:
        """Get current position."""
        response = self.send_command('M114')
        # Parse response like "X:10.00 Y:20.00 Z:5.00 E:0.00"
        pos = {}
        for part in response.split():
            if ':' in part:
                key, val = part.split(':')
                pos[key] = float(val)
        return pos
    
    def print_shape(self, gcode_file: str):
        """Execute a G-code file."""
        with open(gcode_file) as f:
            for line in f:
                line = line.strip()
                if line and not line.startswith(';'):
                    self.send_command(line)


# Example usage
if __name__ == '__main__':
    # Create virtual printer
    def on_cmd(code, params, state):
        print(f"Received: {code} {params}")
        print(f"Position: X={state.x} Y={state.y} Z={state.z}")
    
    printer = VirtualPrinter(on_command=on_cmd)
    printer.start()
    
    print(f"Connect slicer/OctoPrint to: {printer.port_name}")
    
    # AI agent can also send commands
    import time
    time.sleep(1)
    
    agent = AIGCodeGenerator(printer.port_name)
    agent.home()
    agent.move_to(x=100, y=100, z=10, feedrate=3000)
```

### USB Gadget Mode (For Hardware Integration)

On devices with USB OTG (Raspberry Pi, etc.), create a virtual USB serial device:

```bash
# Load USB gadget module
sudo modprobe libcomposite

# Create USB serial gadget
cd /sys/kernel/config/usb_gadget
mkdir virtual_printer
cd virtual_printer

echo 0x1d6b > idVendor  # Linux Foundation
echo 0x0104 > idProduct # Multifunction Composite Gadget
echo 0x0100 > bcdDevice
echo 0x0200 > bcdUSB

# Create configuration
mkdir -p configs/c.1/strings/0x409
echo "Virtual 3D Printer" > configs/c.1/strings/0x409/configuration

# Create ACM function (serial)
mkdir -p functions/acm.usb0
ln -s functions/acm.usb0 configs/c.1/

# Bind to UDC
echo $(ls /sys/class/udc) > UDC
```

---

## 5. Holographic Display Drivers

### Looking Glass Displays

Looking Glass Factory produces light field displays that show true 3D holograms viewable without glasses.

#### Software Stack

- **Looking Glass Bridge SDK**: Low-level integration for custom renderers
- **Unity Plugin**: Real-time 3D content creation
- **Looking Glass Studio**: Media playback (RGBD, quilt formats)

#### Quilt Format

Looking Glass displays use "quilt" images - tiled views representing different angles:

```
┌───┬───┬───┬───┐
│ 0 │ 1 │ 2 │ 3 │  Each tile is one view angle
├───┼───┼───┼───┤  Typically 4x8 or 5x9 grid
│ 4 │ 5 │ 6 │ 7 │  
├───┼───┼───┼───┤
│ 8 │ 9 │10 │11 │
├───┼───┼───┼───┤
│12 │13 │14 │15 │
└───┴───┴───┴───┘
```

#### Python Integration with Looking Glass Bridge

```python
#!/usr/bin/env python3
"""Looking Glass display integration for AI agents."""

import numpy as np
import socket
import json

class LookingGlassController:
    """Control Looking Glass holographic displays."""
    
    def __init__(self, host="localhost", port=33334):
        self.host = host
        self.port = port
        self.sock = None
    
    def connect(self):
        """Connect to Looking Glass Bridge."""
        self.sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
        self.sock.connect((self.host, self.port))
    
    def get_displays(self) -> list:
        """Get list of connected Looking Glass displays."""
        self._send_command({"cmd": "info"})
        response = self._receive()
        return response.get("displays", [])
    
    def show_quilt(self, quilt_image: np.ndarray, display_index: int = 0):
        """Display a quilt image on the holographic display.
        
        Args:
            quilt_image: numpy array of shape (H, W, 3) containing the quilt
            display_index: which Looking Glass display to use
        """
        import base64
        from PIL import Image
        import io
        
        # Convert to PNG bytes
        img = Image.fromarray(quilt_image)
        buffer = io.BytesIO()
        img.save(buffer, format='PNG')
        img_data = base64.b64encode(buffer.getvalue()).decode()
        
        self._send_command({
            "cmd": "show",
            "display": display_index,
            "type": "quilt",
            "data": img_data,
            "cols": 5,
            "rows": 9,
            "aspect": 0.75
        })
    
    def show_rgbd(self, color: np.ndarray, depth: np.ndarray, 
                  display_index: int = 0):
        """Display RGB-D (color + depth) content.
        
        Args:
            color: RGB image array
            depth: Depth map (0-255, higher = closer)
        """
        # Looking Glass can render RGBD to quilt in real-time
        self._send_command({
            "cmd": "show_rgbd",
            "display": display_index,
            "color": self._encode_image(color),
            "depth": self._encode_image(depth)
        })
    
    def _send_command(self, cmd: dict):
        """Send command to Looking Glass Bridge."""
        data = json.dumps(cmd).encode() + b'\n'
        self.sock.sendall(data)
    
    def _receive(self) -> dict:
        """Receive response from Looking Glass Bridge."""
        data = b''
        while b'\n' not in data:
            data += self.sock.recv(4096)
        return json.loads(data.decode())
    
    def _encode_image(self, img: np.ndarray) -> str:
        import base64
        from PIL import Image
        import io
        
        pil_img = Image.fromarray(img)
        buffer = io.BytesIO()
        pil_img.save(buffer, format='PNG')
        return base64.b64encode(buffer.getvalue()).decode()


class QuiltGenerator:
    """Generate quilt images from 3D content for AI agents."""
    
    def __init__(self, cols: int = 5, rows: int = 9, 
                 tile_width: int = 420, tile_height: int = 560):
        self.cols = cols
        self.rows = rows
        self.tile_width = tile_width
        self.tile_height = tile_height
        self.total_views = cols * rows
    
    def from_depth_image(self, color: np.ndarray, depth: np.ndarray,
                         focus: float = 0.5, 
                         depth_scale: float = 30) -> np.ndarray:
        """Generate quilt from RGB-D image.
        
        Uses parallax shifting based on depth to create multiple views.
        """
        h, w = color.shape[:2]
        quilt_h = self.rows * self.tile_height
        quilt_w = self.cols * self.tile_width
        quilt = np.zeros((quilt_h, quilt_w, 3), dtype=np.uint8)
        
        # Normalize depth
        depth_norm = depth.astype(float) / 255.0
        
        for view_idx in range(self.total_views):
            # Calculate view offset
            view_progress = view_idx / (self.total_views - 1)
            offset = (view_progress - 0.5) * 2 * depth_scale
            
            # Create shifted view
            view = self._shift_by_depth(color, depth_norm, offset, focus)
            
            # Resize to tile size
            from PIL import Image
            pil_view = Image.fromarray(view)
            pil_view = pil_view.resize((self.tile_width, self.tile_height))
            view_resized = np.array(pil_view)
            
            # Place in quilt
            row = view_idx // self.cols
            col = view_idx % self.cols
            y = row * self.tile_height
            x = col * self.tile_width
            quilt[y:y+self.tile_height, x:x+self.tile_width] = view_resized
        
        return quilt
    
    def _shift_by_depth(self, color: np.ndarray, depth: np.ndarray,
                        offset: float, focus: float) -> np.ndarray:
        """Shift image pixels horizontally based on depth."""
        h, w = color.shape[:2]
        result = np.zeros_like(color)
        
        for y in range(h):
            for x in range(w):
                d = depth[y, x]
                shift = int((d - focus) * offset)
                new_x = x + shift
                if 0 <= new_x < w:
                    result[y, new_x] = color[y, x]
        
        return result
```

### Volumetric Displays

For true volumetric displays (displaying in 3D space):

#### Voxon VX1

```python
# Voxon displays use their own SDK
# Content is rendered as voxel data

class VoxonController:
    def __init__(self):
        import voxon
        self.vx = voxon.VoxieBox()
    
    def draw_point(self, x, y, z, color):
        self.vx.drawpoint(x, y, z, color)
    
    def draw_model(self, model_path):
        """Draw 3D model in volumetric space."""
        self.vx.drawmodel(model_path)
    
    def update(self):
        self.vx.startframe()
        # Draw content
        self.vx.endframe()
```

---

## 6. Cross-Platform Considerations

### Windows

| Component | Windows Solution |
|-----------|-----------------|
| Virtual Display | Indirect Display Driver (IDD) framework |
| Virtual Audio Sink | Virtual Audio Cable (VAC), VB-Cable |
| Virtual Microphone | Same as sink - bidirectional |
| Virtual Serial | com0com (null-modem emulator) |

**Windows Indirect Display Driver:**
```cpp
// Simplified IDD driver structure
NTSTATUS IddDeviceD0Entry(WDFDEVICE Device) {
    // Initialize virtual display adapter
    IddCxAdapterInitAsync(...);
}

NTSTATUS IddMonitorArrival(IDDCX_ADAPTER AdapterObject) {
    // Create virtual monitor
    IddCxMonitorCreate(...);
}
```

### macOS

| Component | macOS Solution |
|-----------|---------------|
| Virtual Display | CGVirtualDisplay (macOS 14+), Dummy Display |
| Virtual Audio | BlackHole, Soundflower, CoreAudio HAL |
| Virtual Microphone | Same as audio sink |
| Virtual Serial | socat, or IOKit virtual serial |

**macOS Virtual Audio with BlackHole:**
```bash
# Install BlackHole (2ch or 16ch)
brew install blackhole-2ch

# Create multi-output device in Audio MIDI Setup
# Route audio to both speakers and BlackHole
# AI agent captures from BlackHole
```

### Cross-Platform Libraries

**libusb/libftdi** - For USB device emulation:
```python
import usb.core
import usb.util

# Find virtual USB device
dev = usb.core.find(idVendor=0x1234, idProduct=0x5678)
```

**PortAudio** - Cross-platform audio:
```python
import pyaudio

p = pyaudio.PyAudio()
# Works on Linux, Windows, macOS
stream = p.open(format=pyaudio.paFloat32, channels=2, rate=48000, input=True)
```

---

## 7. AI Agent Integration Patterns

### Event-Driven Architecture

```python
from dataclasses import dataclass
from typing import Callable, Any
from queue import Queue
import threading

@dataclass
class IOEvent:
    device_type: str  # "display", "audio", "printer", etc.
    event_type: str   # "frame", "audio_chunk", "gcode", etc.
    data: Any
    timestamp: float

class VirtualIOBus:
    """Central bus for all virtual I/O events."""
    
    def __init__(self):
        self.event_queue = Queue()
        self.handlers: dict[str, list[Callable]] = {}
        self._running = False
    
    def register_handler(self, device_type: str, handler: Callable):
        """Register handler for device events."""
        if device_type not in self.handlers:
            self.handlers[device_type] = []
        self.handlers[device_type].append(handler)
    
    def emit(self, event: IOEvent):
        """Emit event to bus."""
        self.event_queue.put(event)
    
    def start(self):
        """Start event processing."""
        self._running = True
        self._thread = threading.Thread(target=self._process_loop)
        self._thread.start()
    
    def _process_loop(self):
        while self._running:
            try:
                event = self.event_queue.get(timeout=0.1)
                handlers = self.handlers.get(event.device_type, [])
                for handler in handlers:
                    try:
                        handler(event)
                    except Exception as e:
                        print(f"Handler error: {e}")
            except:
                pass


class AIPeripheralAgent:
    """AI agent with direct peripheral access."""
    
    def __init__(self):
        self.io_bus = VirtualIOBus()
        self.display = VirtualDisplayCapture()
        self.audio_in = VirtualAudioCapture()
        self.audio_out = VirtualMicrophone()
        self.printer = VirtualPrinter()
        
        # Register handlers
        self.io_bus.register_handler("display", self.on_frame)
        self.io_bus.register_handler("audio", self.on_audio)
        self.io_bus.register_handler("printer", self.on_gcode)
    
    def on_frame(self, event: IOEvent):
        """Process video frame with AI."""
        frame = event.data
        # Analyze frame, detect objects, etc.
        result = self.vision_model.process(frame)
        return result
    
    def on_audio(self, event: IOEvent):
        """Process audio with AI."""
        audio = event.data
        # Speech recognition, audio analysis, etc.
        text = self.speech_model.transcribe(audio)
        return text
    
    def speak(self, text: str):
        """AI speaks through virtual microphone."""
        audio = self.tts_model.synthesize(text)
        self.audio_out.write_audio(audio)
    
    def print_object(self, gcode: str):
        """Send G-code to virtual printer."""
        self.printer.send_gcode(gcode)
```

### Shared Memory for High Performance

For high-bandwidth data like video frames:

```python
import mmap
import posix_ipc
import numpy as np

class SharedFrameBuffer:
    """Zero-copy frame sharing between kernel module and AI agent."""
    
    def __init__(self, name: str, width: int, height: int):
        self.width = width
        self.height = height
        self.size = width * height * 4  # RGBA
        
        # Create shared memory
        self.shm = posix_ipc.SharedMemory(
            f"/vio_frame_{name}",
            posix_ipc.O_CREAT,
            size=self.size
        )
        
        # Memory map
        self.buffer = mmap.mmap(
            self.shm.fd, 
            self.size,
            mmap.MAP_SHARED,
            mmap.PROT_READ | mmap.PROT_WRITE
        )
        
        # Semaphore for synchronization
        self.sem = posix_ipc.Semaphore(
            f"/vio_sem_{name}",
            posix_ipc.O_CREAT
        )
    
    def write_frame(self, frame: np.ndarray):
        """Write frame (used by capture side)."""
        self.buffer.seek(0)
        self.buffer.write(frame.tobytes())
        self.sem.release()  # Signal new frame available
    
    def read_frame(self) -> np.ndarray:
        """Read frame (used by AI agent)."""
        self.sem.acquire()  # Wait for new frame
        self.buffer.seek(0)
        data = self.buffer.read(self.size)
        return np.frombuffer(data, dtype=np.uint8).reshape(
            self.height, self.width, 4)
```

---

## 8. Real-Time Streaming Considerations

### Latency Requirements

| Use Case | Target Latency | Buffer Size |
|----------|---------------|-------------|
| Video capture | < 16ms (60fps) | 1-2 frames |
| Audio playback | < 10ms | 256-512 samples |
| Audio capture | < 20ms | 512-1024 samples |
| 3D printing | Not critical | Command queue |

### Buffer Management

```python
from collections import deque
import time

class RingBuffer:
    """Lock-free ring buffer for real-time data."""
    
    def __init__(self, max_size: int):
        self.buffer = deque(maxlen=max_size)
        self.dropped = 0
    
    def put(self, item, timestamp=None):
        """Add item, dropping oldest if full."""
        if len(self.buffer) == self.buffer.maxlen:
            self.dropped += 1
        self.buffer.append((item, timestamp or time.time()))
    
    def get(self, timeout=None):
        """Get oldest item."""
        start = time.time()
        while not self.buffer:
            if timeout and (time.time() - start) > timeout:
                return None
            time.sleep(0.001)
        return self.buffer.popleft()
    
    def get_latest(self):
        """Get newest item, discarding older ones."""
        if not self.buffer:
            return None
        item = self.buffer[-1]
        self.buffer.clear()
        return item
```

### Audio Jitter Buffer

```python
class JitterBuffer:
    """Smooth audio playback with variable latency sources."""
    
    def __init__(self, target_latency_ms: float = 50, 
                 sample_rate: int = 48000):
        self.target_samples = int(target_latency_ms * sample_rate / 1000)
        self.buffer = deque()
        self.sample_rate = sample_rate
    
    def add_packet(self, samples: np.ndarray, sequence: int):
        """Add audio packet to buffer."""
        # Insert in order
        idx = 0
        for i, (seq, _) in enumerate(self.buffer):
            if sequence < seq:
                idx = i
                break
            idx = i + 1
        self.buffer.insert(idx, (sequence, samples))
    
    def get_samples(self, count: int) -> np.ndarray:
        """Get samples for playback."""
        result = []
        remaining = count
        
        while remaining > 0 and self.buffer:
            seq, samples = self.buffer[0]
            
            if len(samples) <= remaining:
                result.append(samples)
                remaining -= len(samples)
                self.buffer.popleft()
            else:
                result.append(samples[:remaining])
                self.buffer[0] = (seq, samples[remaining:])
                remaining = 0
        
        # Pad with silence if buffer underrun
        if remaining > 0:
            result.append(np.zeros(remaining, dtype=np.float32))
        
        return np.concatenate(result)
```

---

## Summary

This guide covers the core techniques for creating virtual I/O devices that give AI agents direct peripheral-level access:

1. **Virtual Displays**: Use DRM/KMS (vkms, evdi) or custom kernel modules to capture video output
2. **Virtual Audio Sinks**: PipeWire/PulseAudio null sinks capture audio streams
3. **Virtual Microphones**: PipeWire sources or snd-aloop for audio injection
4. **Virtual 3D Printers**: PTY-based serial emulation with G-code parsing
5. **Holographic Displays**: Looking Glass SDK with quilt image generation

Key integration patterns:
- Event-driven architecture with central I/O bus
- Shared memory for zero-copy high-bandwidth data
- Ring buffers and jitter buffers for real-time streaming
- Cross-platform abstraction layers

For production deployment, consider:
- Proper error handling and recovery
- Security implications of virtual devices
- Resource management and cleanup
- Performance monitoring and profiling
