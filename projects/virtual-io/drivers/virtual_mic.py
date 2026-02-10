#!/usr/bin/env python3
"""
Virtual Microphone (Audio Source) Module

Injects audio as microphone input using PipeWire, PulseAudio, or ALSA.
Creates a virtual audio source that applications can use as a microphone.

Usage:
    from virtual_mic import VirtualMicrophone
    
    mic = VirtualMicrophone()
    mic.create_source("ai_agent_mic")
    
    # Play audio file through virtual mic
    mic.play_file("speech.wav")
    
    # Or stream audio data
    mic.write_audio(audio_samples)
"""

import os
import io
import subprocess
import shutil
import time
import struct
import wave
import threading
from typing import Iterator, Optional, Callable, Union
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
    channels: int = 1  # Mono for microphone
    bits: int = 16
    format: str = "s16le"


class VirtualMicrophone:
    """
    Virtual microphone (audio source) for AI agents.
    
    Creates a virtual audio source and allows injecting audio data
    that applications will receive as microphone input.
    """
    
    def __init__(self, format: Optional[AudioFormat] = None):
        """
        Initialize virtual microphone.
        
        Args:
            format: Audio format specification
        """
        self.format = format or AudioFormat()
        self.backend = self._detect_backend()
        self._source_name: Optional[str] = None
        self._write_proc: Optional[subprocess.Popen] = None
        self._module_id: Optional[str] = None
        
        if not self.backend:
            raise RuntimeError("No audio backend available. Install PipeWire, PulseAudio, or ALSA tools.")
    
    def _detect_backend(self) -> str:
        """Detect available audio backend."""
        if shutil.which("pw-cat") and shutil.which("pw-cli"):
            return "pipewire"
        elif shutil.which("pactl") and shutil.which("pacat"):
            return "pulseaudio"
        elif shutil.which("aplay"):
            return "alsa"
        return None
    
    def create_source(self, name: str = "ai_agent_mic", description: str = "") -> bool:
        """
        Create a virtual microphone source.
        
        Args:
            name: Source name
            description: Human-readable description
        
        Returns:
            True if source was created successfully
        """
        self._source_name = name
        desc = description or "AI Agent Virtual Microphone"
        
        if self.backend == "pipewire" or self.backend == "pulseaudio":
            # Create virtual source using module-null-sink with source output
            # This creates a sink that we write to, and a source.monitor that apps read from
            cmd = [
                "pactl", "load-module", "module-null-sink",
                f"sink_name={name}_sink",
                f"sink_properties=device.description=\"{desc}\""
            ]
            
            try:
                result = subprocess.run(cmd, capture_output=True, text=True)
                if result.returncode == 0:
                    self._module_id = result.stdout.strip()
                    
                    # The monitor of this sink acts as our virtual mic source
                    # Apps should connect to: {name}_sink.monitor
                    
                    # Optionally, we can remap it as a proper source
                    remap_cmd = [
                        "pactl", "load-module", "module-remap-source",
                        f"source_name={name}",
                        f"master={name}_sink.monitor",
                        f"source_properties=device.description=\"{desc}\""
                    ]
                    subprocess.run(remap_cmd, capture_output=True)
                    
                    return True
            except Exception:
                pass
        
        return False
    
    def remove_source(self) -> bool:
        """Remove the virtual source."""
        if not self._source_name:
            return False
        
        try:
            # Find and unload all related modules
            result = subprocess.run(
                ["pactl", "list", "short", "modules"],
                capture_output=True, text=True
            )
            
            removed = False
            for line in result.stdout.strip().split('\n'):
                if self._source_name in line:
                    module_id = line.split()[0]
                    subprocess.run(["pactl", "unload-module", module_id])
                    removed = True
            
            return removed
        except Exception:
            return False
    
    def list_sources(self) -> list:
        """List available audio sources."""
        try:
            if self.backend in ("pipewire", "pulseaudio"):
                result = subprocess.run(
                    ["pactl", "list", "short", "sources"],
                    capture_output=True, text=True
                )
                
                sources = []
                for line in result.stdout.strip().split('\n'):
                    if line:
                        parts = line.split()
                        if len(parts) >= 2:
                            sources.append(parts[1])
                return sources
            else:
                result = subprocess.run(
                    ["arecord", "-l"],
                    capture_output=True, text=True
                )
                return result.stdout.split('\n')
        except Exception:
            return []
    
    def set_as_default(self) -> bool:
        """Set the virtual source as the default microphone."""
        if self._source_name:
            try:
                subprocess.run(
                    ["pactl", "set-default-source", self._source_name],
                    check=True
                )
                return True
            except Exception:
                pass
        return False
    
    def _start_write_pipeline(self) -> None:
        """Start the audio write pipeline."""
        if self._write_proc is not None:
            return
        
        sink_name = f"{self._source_name}_sink"
        
        if self.backend == "pipewire":
            fmt_map = {16: "s16", 32: "f32"}
            cmd = [
                "pw-cat", "--playback",
                "--target", sink_name,
                "--format", fmt_map.get(self.format.bits, "s16"),
                "--rate", str(self.format.sample_rate),
                "--channels", str(self.format.channels),
                "-"
            ]
        else:  # pulseaudio
            fmt_map = {16: "s16le", 32: "float32le"}
            cmd = [
                "pacat",
                "--playback",
                "-d", sink_name,
                "--format", fmt_map.get(self.format.bits, "s16le"),
                "--rate", str(self.format.sample_rate),
                "--channels", str(self.format.channels),
                "--raw"
            ]
        
        self._write_proc = subprocess.Popen(
            cmd,
            stdin=subprocess.PIPE,
            stderr=subprocess.DEVNULL
        )
    
    def _stop_write_pipeline(self) -> None:
        """Stop the audio write pipeline."""
        if self._write_proc:
            try:
                self._write_proc.stdin.close()
                self._write_proc.terminate()
                self._write_proc.wait(timeout=2)
            except Exception:
                self._write_proc.kill()
            self._write_proc = None
    
    def write_audio(self, samples: Union[bytes, "np.ndarray"]) -> None:
        """
        Write audio samples to virtual microphone.
        
        Args:
            samples: Audio data as bytes or numpy array
                     If numpy: expected shape (n_samples,) or (n_samples, channels)
                     Values should be int16 or float32 depending on format
        """
        if not self._source_name:
            raise RuntimeError("No source created. Call create_source() first.")
        
        self._start_write_pipeline()
        
        if HAS_NUMPY and isinstance(samples, np.ndarray):
            # Convert numpy to bytes
            if samples.ndim == 2:
                samples = samples.flatten()
            
            if self.format.bits == 16:
                if samples.dtype == np.float32 or samples.dtype == np.float64:
                    # Convert float [-1, 1] to int16
                    samples = (samples * 32767).astype(np.int16)
                audio_bytes = samples.astype(np.int16).tobytes()
            else:
                audio_bytes = samples.astype(np.float32).tobytes()
        else:
            audio_bytes = samples
        
        try:
            self._write_proc.stdin.write(audio_bytes)
            self._write_proc.stdin.flush()
        except BrokenPipeError:
            # Restart pipeline
            self._stop_write_pipeline()
            self._start_write_pipeline()
            self._write_proc.stdin.write(audio_bytes)
            self._write_proc.stdin.flush()
    
    def play_file(self, path: str, block: bool = True) -> None:
        """
        Play audio file through virtual microphone.
        
        Args:
            path: Path to audio file (WAV, MP3, etc.)
            block: If True, wait for playback to complete
        """
        path = Path(path)
        
        if not path.exists():
            raise FileNotFoundError(f"Audio file not found: {path}")
        
        # Handle WAV files directly
        if path.suffix.lower() == '.wav':
            self._play_wav(str(path), block)
            return
        
        # For other formats, try ffmpeg conversion
        if shutil.which("ffmpeg"):
            self._play_with_ffmpeg(str(path), block)
        else:
            raise RuntimeError(f"Cannot play {path.suffix} files without ffmpeg")
    
    def _play_wav(self, path: str, block: bool = True) -> None:
        """Play WAV file."""
        with wave.open(path, 'rb') as wf:
            # Read file parameters
            channels = wf.getnchannels()
            sample_width = wf.getsampwidth()
            framerate = wf.getframerate()
            n_frames = wf.getnframes()
            
            # Read all audio data
            audio_data = wf.readframes(n_frames)
        
        # Resample if needed
        if framerate != self.format.sample_rate or channels != self.format.channels:
            if HAS_NUMPY:
                audio_data = self._resample(audio_data, framerate, channels)
            else:
                print(f"Warning: Audio format mismatch and numpy not available for resampling")
        
        if block:
            # Write all at once
            self.write_audio(audio_data)
            
            # Wait for playback
            duration = len(audio_data) / (self.format.sample_rate * self.format.channels * (self.format.bits // 8))
            time.sleep(duration)
        else:
            # Start background playback
            def _play():
                chunk_size = 4096
                for i in range(0, len(audio_data), chunk_size):
                    self.write_audio(audio_data[i:i+chunk_size])
                    time.sleep(chunk_size / (self.format.sample_rate * self.format.channels * (self.format.bits // 8)))
            
            thread = threading.Thread(target=_play)
            thread.daemon = True
            thread.start()
    
    def _play_with_ffmpeg(self, path: str, block: bool = True) -> None:
        """Play audio file using ffmpeg for conversion."""
        sink_name = f"{self._source_name}_sink"
        
        # Use ffmpeg to convert and pipe to pw-cat/pacat
        if self.backend == "pipewire":
            output_cmd = [
                "pw-cat", "--playback",
                "--target", sink_name,
                "--format", "s16",
                "--rate", str(self.format.sample_rate),
                "--channels", str(self.format.channels),
                "-"
            ]
        else:
            output_cmd = [
                "pacat",
                "--playback",
                "-d", sink_name,
                "--format", "s16le",
                "--rate", str(self.format.sample_rate),
                "--channels", str(self.format.channels),
                "--raw"
            ]
        
        ffmpeg_cmd = [
            "ffmpeg", "-i", path,
            "-f", "s16le",
            "-acodec", "pcm_s16le",
            "-ar", str(self.format.sample_rate),
            "-ac", str(self.format.channels),
            "-"
        ]
        
        # Pipe ffmpeg output to audio player
        ffmpeg_proc = subprocess.Popen(
            ffmpeg_cmd,
            stdout=subprocess.PIPE,
            stderr=subprocess.DEVNULL
        )
        
        audio_proc = subprocess.Popen(
            output_cmd,
            stdin=ffmpeg_proc.stdout,
            stderr=subprocess.DEVNULL
        )
        
        if block:
            audio_proc.wait()
        else:
            # Let it run in background
            pass
    
    def _resample(self, audio_data: bytes, src_rate: int, src_channels: int) -> bytes:
        """Simple resampling using numpy (basic linear interpolation)."""
        if not HAS_NUMPY:
            return audio_data
        
        # Convert bytes to numpy
        samples = np.frombuffer(audio_data, dtype=np.int16)
        
        # Handle channels
        if src_channels == 2 and self.format.channels == 1:
            # Stereo to mono
            samples = samples.reshape(-1, 2).mean(axis=1).astype(np.int16)
        elif src_channels == 1 and self.format.channels == 2:
            # Mono to stereo
            samples = np.repeat(samples, 2)
        
        # Handle sample rate
        if src_rate != self.format.sample_rate:
            # Simple linear resampling
            src_len = len(samples)
            dst_len = int(src_len * self.format.sample_rate / src_rate)
            
            x_old = np.linspace(0, 1, src_len)
            x_new = np.linspace(0, 1, dst_len)
            samples = np.interp(x_new, x_old, samples).astype(np.int16)
        
        return samples.tobytes()
    
    def generate_tone(self, frequency: float, duration: float, amplitude: float = 0.5) -> None:
        """
        Generate and play a sine wave tone.
        
        Args:
            frequency: Tone frequency in Hz
            duration: Duration in seconds
            amplitude: Amplitude (0.0 to 1.0)
        """
        if not HAS_NUMPY:
            raise ImportError("numpy required for tone generation")
        
        n_samples = int(duration * self.format.sample_rate)
        t = np.linspace(0, duration, n_samples)
        
        # Generate sine wave
        samples = amplitude * np.sin(2 * np.pi * frequency * t)
        
        # Convert to int16
        samples = (samples * 32767).astype(np.int16)
        
        # Duplicate for stereo if needed
        if self.format.channels == 2:
            samples = np.repeat(samples, 2)
        
        self.write_audio(samples)
        time.sleep(duration)
    
    def generate_silence(self, duration: float) -> None:
        """Generate silence for specified duration."""
        n_samples = int(duration * self.format.sample_rate * self.format.channels)
        silence = bytes(n_samples * (self.format.bits // 8))
        self.write_audio(silence)
        time.sleep(duration)
    
    def get_backend_name(self) -> str:
        """Get name of the audio backend being used."""
        return self.backend if self.backend else "none"
    
    def get_source_name(self) -> Optional[str]:
        """Get the virtual source name for applications to connect to."""
        return self._source_name
    
    def cleanup(self) -> None:
        """Clean up resources."""
        self._stop_write_pipeline()
        self.remove_source()
    
    def __enter__(self):
        return self
    
    def __exit__(self, exc_type, exc_val, exc_tb):
        self.cleanup()


def list_available_backends() -> list:
    """List available audio backends."""
    backends = []
    
    if shutil.which("pw-cat"):
        backends.append(("pipewire", "PipeWire (recommended)"))
    if shutil.which("pacat"):
        backends.append(("pulseaudio", "PulseAudio"))
    if shutil.which("aplay"):
        backends.append(("alsa", "ALSA (limited)"))
    
    return backends


if __name__ == "__main__":
    print("Virtual Microphone (Audio Source) Module")
    print("=" * 40)
    
    backends = list_available_backends()
    if backends:
        print("Available audio backends:")
        for name, desc in backends:
            print(f"  - {name}: {desc}")
        
        try:
            mic = VirtualMicrophone()
            print(f"\nUsing backend: {mic.get_backend_name()}")
            
            # List existing sources
            sources = mic.list_sources()
            print(f"Existing sources: {sources[:5]}...")  # Show first 5
            
            # Try to create source
            if mic.create_source("test_ai_mic"):
                print("Created virtual microphone: test_ai_mic")
                print(f"Applications should use source: {mic.get_source_name()}")
                
                # Generate a brief test tone if numpy available
                if HAS_NUMPY:
                    print("Generating 440Hz test tone for 0.5s...")
                    try:
                        mic.generate_tone(440, 0.5, 0.3)
                        print("Tone generated!")
                    except Exception as e:
                        print(f"Tone generation failed: {e}")
                
                # Clean up
                mic.cleanup()
                print("Removed virtual microphone")
            else:
                print("Could not create source (may require audio daemon)")
                
        except Exception as e:
            print(f"Error: {e}")
    else:
        print("No audio backends available!")
        print("Install PipeWire or PulseAudio")
