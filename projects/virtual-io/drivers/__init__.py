"""
Virtual I/O Drivers for AI Agents

Provides virtual device interfaces for:
- Display capture (screen)
- Audio capture (speaker sink)
- Audio injection (microphone source)
- 3D printer control (G-code)
"""

from .virtual_display import VirtualDisplay, list_available_methods
from .virtual_speaker import VirtualSpeaker, AudioFormat
from .virtual_mic import VirtualMicrophone
from .virtual_printer import VirtualPrinter, GCodeGenerator, PrinterState
from .io_hub import IOHub, IOEvent

__all__ = [
    'VirtualDisplay',
    'VirtualSpeaker',
    'VirtualMicrophone',
    'VirtualPrinter',
    'GCodeGenerator',
    'PrinterState',
    'AudioFormat',
    'IOHub',
    'IOEvent',
    'list_available_methods',
]

__version__ = '0.1.0'
