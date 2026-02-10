#!/usr/bin/env python3
"""
Virtual Display Capture Module

Captures screen/display output using available system tools.
Supports: scrot, maim, import (ImageMagick), X11 via Xlib, or mss.

Usage:
    from virtual_display import VirtualDisplay
    display = VirtualDisplay()
    frame = display.capture_frame()
    
    # Stream frames
    for frame in display.stream_frames(fps=30):
        process(frame)
"""

import os
import io
import time
import subprocess
import tempfile
import shutil
from typing import Iterator, Optional, Tuple, Callable
from dataclasses import dataclass
from pathlib import Path

# Try optional imports
try:
    from PIL import Image
    HAS_PIL = True
except ImportError:
    HAS_PIL = False

try:
    import numpy as np
    HAS_NUMPY = True
except ImportError:
    HAS_NUMPY = False

try:
    import mss
    HAS_MSS = True
except ImportError:
    HAS_MSS = False


@dataclass
class CaptureMethod:
    """Represents a screen capture method."""
    name: str
    available: bool
    priority: int
    capture_fn: Optional[Callable] = None


class VirtualDisplay:
    """
    Virtual display capture for AI agents.
    
    Automatically selects the best available capture method.
    Returns frames as bytes (PNG) or as PIL Image / numpy array if available.
    """
    
    def __init__(self, display: str = ":0", region: Optional[Tuple[int, int, int, int]] = None):
        """
        Initialize virtual display capture.
        
        Args:
            display: X11 display string (e.g., ":0")
            region: Optional (x, y, width, height) to capture specific region
        """
        self.display = display
        self.region = region
        self._temp_dir = tempfile.mkdtemp(prefix="vdisplay_")
        self._capture_method = self._detect_capture_method()
        
        if not self._capture_method:
            raise RuntimeError("No screen capture method available. Install scrot, maim, imagemagick, or mss")
    
    def _detect_capture_method(self) -> Optional[CaptureMethod]:
        """Detect available capture methods and select the best one."""
        methods = []
        
        # Check mss (Python library - fastest)
        if HAS_MSS:
            methods.append(CaptureMethod("mss", True, 1, self._capture_mss))
        
        # Check scrot
        if shutil.which("scrot"):
            methods.append(CaptureMethod("scrot", True, 2, self._capture_scrot))
        
        # Check maim
        if shutil.which("maim"):
            methods.append(CaptureMethod("maim", True, 3, self._capture_maim))
        
        # Check ImageMagick import
        if shutil.which("import"):
            methods.append(CaptureMethod("import", True, 4, self._capture_imagemagick))
        
        # Check xwd + convert
        if shutil.which("xwd"):
            methods.append(CaptureMethod("xwd", True, 5, self._capture_xwd))
        
        # Check ffmpeg
        if shutil.which("ffmpeg"):
            methods.append(CaptureMethod("ffmpeg", True, 6, self._capture_ffmpeg))
        
        # Sort by priority and return best
        methods.sort(key=lambda m: m.priority)
        return methods[0] if methods else None
    
    def _get_region_args(self, method: str) -> list:
        """Get region arguments for a capture method."""
        if not self.region:
            return []
        
        x, y, w, h = self.region
        
        if method == "scrot":
            return ["-a", f"{x},{y},{w},{h}"]
        elif method == "maim":
            return ["-g", f"{w}x{h}+{x}+{y}"]
        elif method == "import":
            return ["-crop", f"{w}x{h}+{x}+{y}"]
        elif method == "ffmpeg":
            return ["-video_size", f"{w}x{h}", "-offset_x", str(x), "-offset_y", str(y)]
        
        return []
    
    def _capture_mss(self) -> bytes:
        """Capture using mss (fastest method)."""
        with mss.mss() as sct:
            if self.region:
                x, y, w, h = self.region
                monitor = {"top": y, "left": x, "width": w, "height": h}
            else:
                monitor = sct.monitors[1]  # Primary monitor
            
            screenshot = sct.grab(monitor)
            
            # Convert to PNG bytes
            if HAS_PIL:
                img = Image.frombytes("RGB", screenshot.size, screenshot.bgra, "raw", "BGRX")
                buffer = io.BytesIO()
                img.save(buffer, format="PNG")
                return buffer.getvalue()
            else:
                # Return raw BGRA data with dimensions header
                return b"MSS:" + f"{screenshot.width}x{screenshot.height}:".encode() + screenshot.rgb
    
    def _capture_scrot(self) -> bytes:
        """Capture using scrot."""
        output = os.path.join(self._temp_dir, "frame.png")
        cmd = ["scrot", "-o", output] + self._get_region_args("scrot")
        
        env = os.environ.copy()
        env["DISPLAY"] = self.display
        
        subprocess.run(cmd, env=env, check=True, capture_output=True)
        
        with open(output, "rb") as f:
            return f.read()
    
    def _capture_maim(self) -> bytes:
        """Capture using maim."""
        cmd = ["maim"] + self._get_region_args("maim")
        
        env = os.environ.copy()
        env["DISPLAY"] = self.display
        
        result = subprocess.run(cmd, env=env, capture_output=True, check=True)
        return result.stdout
    
    def _capture_imagemagick(self) -> bytes:
        """Capture using ImageMagick import."""
        output = os.path.join(self._temp_dir, "frame.png")
        cmd = ["import", "-window", "root"] + self._get_region_args("import") + [output]
        
        env = os.environ.copy()
        env["DISPLAY"] = self.display
        
        subprocess.run(cmd, env=env, check=True, capture_output=True)
        
        with open(output, "rb") as f:
            return f.read()
    
    def _capture_xwd(self) -> bytes:
        """Capture using xwd (X Window Dump)."""
        env = os.environ.copy()
        env["DISPLAY"] = self.display
        
        # Capture to XWD format
        xwd_cmd = ["xwd", "-root", "-silent"]
        xwd_result = subprocess.run(xwd_cmd, env=env, capture_output=True, check=True)
        
        # Convert to PNG if convert is available
        if shutil.which("convert"):
            convert_cmd = ["convert", "xwd:-", "png:-"]
            convert_result = subprocess.run(
                convert_cmd, 
                input=xwd_result.stdout, 
                capture_output=True, 
                check=True
            )
            return convert_result.stdout
        
        # Return raw XWD data
        return xwd_result.stdout
    
    def _capture_ffmpeg(self) -> bytes:
        """Capture using ffmpeg."""
        env = os.environ.copy()
        env["DISPLAY"] = self.display
        
        region_args = self._get_region_args("ffmpeg")
        
        cmd = [
            "ffmpeg", "-y",
            "-f", "x11grab",
            "-framerate", "1",
            "-i", self.display,
        ] + region_args + [
            "-frames:v", "1",
            "-f", "image2pipe",
            "-vcodec", "png",
            "-"
        ]
        
        result = subprocess.run(cmd, env=env, capture_output=True, check=True)
        return result.stdout
    
    def capture_frame(self) -> bytes:
        """
        Capture a single frame.
        
        Returns:
            PNG image as bytes
        """
        return self._capture_method.capture_fn()
    
    def capture_frame_pil(self) -> "Image.Image":
        """
        Capture frame as PIL Image.
        
        Returns:
            PIL Image object
        
        Raises:
            ImportError: If PIL is not available
        """
        if not HAS_PIL:
            raise ImportError("PIL/Pillow is required for this method")
        
        png_data = self.capture_frame()
        return Image.open(io.BytesIO(png_data))
    
    def capture_frame_numpy(self) -> "np.ndarray":
        """
        Capture frame as numpy array (RGB format).
        
        Returns:
            numpy array of shape (height, width, 3)
        
        Raises:
            ImportError: If numpy or PIL is not available
        """
        if not HAS_NUMPY:
            raise ImportError("numpy is required for this method")
        if not HAS_PIL:
            raise ImportError("PIL/Pillow is required for this method")
        
        img = self.capture_frame_pil()
        return np.array(img.convert("RGB"))
    
    def stream_frames(self, fps: float = 30, duration: Optional[float] = None) -> Iterator[bytes]:
        """
        Stream frames at specified FPS.
        
        Args:
            fps: Target frames per second
            duration: Optional duration in seconds (None for infinite)
        
        Yields:
            PNG image bytes for each frame
        """
        frame_interval = 1.0 / fps
        start_time = time.time()
        next_frame_time = start_time
        
        while True:
            current_time = time.time()
            
            # Check duration
            if duration and (current_time - start_time) >= duration:
                break
            
            # Wait for next frame time
            if current_time < next_frame_time:
                time.sleep(next_frame_time - current_time)
            
            # Capture and yield frame
            yield self.capture_frame()
            
            # Schedule next frame
            next_frame_time += frame_interval
    
    def save_frame(self, path: str) -> None:
        """Save a single frame to file."""
        frame = self.capture_frame()
        with open(path, "wb") as f:
            f.write(frame)
    
    def get_method_name(self) -> str:
        """Get name of the capture method being used."""
        return self._capture_method.name if self._capture_method else "none"
    
    def cleanup(self) -> None:
        """Clean up temporary files."""
        shutil.rmtree(self._temp_dir, ignore_errors=True)
    
    def __enter__(self):
        return self
    
    def __exit__(self, exc_type, exc_val, exc_tb):
        self.cleanup()
    
    def __del__(self):
        self.cleanup()


def list_available_methods() -> list:
    """List all available capture methods."""
    display = VirtualDisplay.__new__(VirtualDisplay)
    display.display = ":0"
    display.region = None
    display._temp_dir = "/tmp"
    
    methods = []
    
    if HAS_MSS:
        methods.append(("mss", "Python library - fastest"))
    if shutil.which("scrot"):
        methods.append(("scrot", "CLI tool"))
    if shutil.which("maim"):
        methods.append(("maim", "CLI tool"))
    if shutil.which("import"):
        methods.append(("import", "ImageMagick"))
    if shutil.which("xwd"):
        methods.append(("xwd", "X Window Dump"))
    if shutil.which("ffmpeg"):
        methods.append(("ffmpeg", "FFmpeg"))
    
    return methods


if __name__ == "__main__":
    print("Virtual Display Capture Module")
    print("=" * 40)
    
    methods = list_available_methods()
    if methods:
        print(f"Available capture methods:")
        for name, desc in methods:
            print(f"  - {name}: {desc}")
        
        try:
            with VirtualDisplay() as display:
                print(f"\nUsing method: {display.get_method_name()}")
                print("Capturing frame...")
                frame = display.capture_frame()
                print(f"Captured {len(frame)} bytes")
                
                # Save test frame
                test_path = "/tmp/vdisplay_test.png"
                display.save_frame(test_path)
                print(f"Saved to: {test_path}")
        except Exception as e:
            print(f"Capture failed: {e}")
            print("(This is expected if running without a display)")
    else:
        print("No capture methods available!")
        print("Install one of: scrot, maim, imagemagick, mss (pip)")
