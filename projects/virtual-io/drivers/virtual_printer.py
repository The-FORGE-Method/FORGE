#!/usr/bin/env python3
"""
Virtual 3D Printer Controller Module

Simulates a 3D printer that accepts G-code commands.
Provides G-code generation and virtual serial port for printer emulation.

Usage:
    from virtual_printer import VirtualPrinter, GCodeGenerator
    
    # Create virtual printer
    printer = VirtualPrinter()
    printer.start()
    print(f"Connect slicer to: {printer.port_name}")
    
    # Generate G-code
    gcode = GCodeGenerator()
    gcode.home()
    gcode.move_to(x=50, y=50, z=10)
    gcode.save("output.gcode")
"""

import os
import pty
import select
import time
import re
import threading
from typing import Optional, Callable, Dict, List, Tuple
from dataclasses import dataclass, field
from pathlib import Path


@dataclass
class PrinterState:
    """Current state of the virtual printer."""
    # Position
    x: float = 0.0
    y: float = 0.0
    z: float = 0.0
    e: float = 0.0  # Extruder position
    
    # Temperature
    hotend_temp: float = 20.0
    hotend_target: float = 0.0
    bed_temp: float = 20.0
    bed_target: float = 0.0
    
    # Motion
    feedrate: float = 1000.0
    is_homed: bool = False
    is_relative: bool = False
    e_relative: bool = False
    
    # Status
    is_printing: bool = False
    progress: float = 0.0
    layer: int = 0
    
    # Limits
    max_x: float = 220.0
    max_y: float = 220.0
    max_z: float = 250.0


@dataclass
class GCodeCommand:
    """Parsed G-code command."""
    code: str
    params: Dict[str, float] = field(default_factory=dict)
    comment: str = ""
    raw: str = ""


class VirtualPrinter:
    """
    Virtual 3D printer that accepts G-code commands.
    
    Creates a PTY (pseudo-terminal) that acts as a serial port.
    Software like OctoPrint, Cura, or Pronterface can connect to it.
    """
    
    def __init__(self, 
                 on_command: Optional[Callable[[GCodeCommand, PrinterState], None]] = None,
                 on_move: Optional[Callable[[PrinterState], None]] = None):
        """
        Initialize virtual printer.
        
        Args:
            on_command: Callback when command is received
            on_move: Callback when position changes
        """
        self.state = PrinterState()
        self.on_command = on_command
        self.on_move = on_move
        
        self._running = False
        self._thread: Optional[threading.Thread] = None
        self._master_fd: Optional[int] = None
        self._slave_fd: Optional[int] = None
        self.port_name: Optional[str] = None
        
        # Command history
        self.command_history: List[GCodeCommand] = []
        self._max_history = 1000
    
    def start(self) -> str:
        """
        Start the virtual printer.
        
        Returns:
            Path to the virtual serial port
        """
        # Create PTY pair
        self._master_fd, self._slave_fd = pty.openpty()
        self.port_name = os.ttyname(self._slave_fd)
        
        print(f"Virtual printer started at: {self.port_name}")
        
        # Start read thread
        self._running = True
        self._thread = threading.Thread(target=self._read_loop)
        self._thread.daemon = True
        self._thread.start()
        
        return self.port_name
    
    def stop(self) -> None:
        """Stop the virtual printer."""
        self._running = False
        
        if self._thread:
            self._thread.join(timeout=2)
            self._thread = None
        
        if self._master_fd:
            os.close(self._master_fd)
            self._master_fd = None
        
        if self._slave_fd:
            os.close(self._slave_fd)
            self._slave_fd = None
    
    def _read_loop(self) -> None:
        """Background thread for reading G-code commands."""
        buffer = ""
        
        while self._running:
            try:
                r, _, _ = select.select([self._master_fd], [], [], 0.1)
                
                if r:
                    data = os.read(self._master_fd, 1024)
                    if not data:
                        continue
                    
                    buffer += data.decode('utf-8', errors='ignore')
                    
                    # Process complete lines
                    while '\n' in buffer:
                        line, buffer = buffer.split('\n', 1)
                        line = line.strip()
                        if line:
                            self._process_line(line)
            except OSError:
                break
    
    def _process_line(self, line: str) -> None:
        """Process a line of G-code."""
        cmd = self._parse_command(line)
        
        if cmd.code:
            # Add to history
            self.command_history.append(cmd)
            if len(self.command_history) > self._max_history:
                self.command_history.pop(0)
            
            # Execute command
            response = self._execute_command(cmd)
            
            # Notify callback
            if self.on_command:
                self.on_command(cmd, self.state)
        else:
            response = "ok"
        
        # Send response
        self._respond(response)
    
    def _parse_command(self, line: str) -> GCodeCommand:
        """Parse a G-code line into command object."""
        # Remove comments
        comment = ""
        if ';' in line:
            line, comment = line.split(';', 1)
            comment = comment.strip()
        
        line = line.strip().upper()
        
        if not line:
            return GCodeCommand(code="", comment=comment, raw=line)
        
        parts = line.split()
        code = parts[0]
        
        # Parse parameters (e.g., X10 Y20 F1000)
        params = {}
        for part in parts[1:]:
            if len(part) > 1 and part[0].isalpha():
                try:
                    params[part[0]] = float(part[1:])
                except ValueError:
                    pass
        
        return GCodeCommand(code=code, params=params, comment=comment, raw=line)
    
    def _execute_command(self, cmd: GCodeCommand) -> str:
        """Execute a G-code command and return response."""
        code = cmd.code
        params = cmd.params
        
        # G-codes (geometry/motion)
        if code == "G0" or code == "G1":
            return self._cmd_move(params)
        elif code == "G28":
            return self._cmd_home(params)
        elif code == "G90":
            self.state.is_relative = False
            return "ok"
        elif code == "G91":
            self.state.is_relative = True
            return "ok"
        elif code == "G92":
            return self._cmd_set_position(params)
        
        # M-codes (miscellaneous)
        elif code == "M104":
            # Set hotend temperature
            self.state.hotend_target = params.get('S', 0)
            return "ok"
        elif code == "M105":
            # Report temperatures
            return (f"ok T:{self.state.hotend_temp:.1f}/{self.state.hotend_target:.1f} "
                   f"B:{self.state.bed_temp:.1f}/{self.state.bed_target:.1f}")
        elif code == "M109":
            # Wait for hotend temperature
            self.state.hotend_target = params.get('S', 0)
            self.state.hotend_temp = self.state.hotend_target  # Simulate instant heating
            return "ok"
        elif code == "M114":
            # Report position
            return (f"X:{self.state.x:.2f} Y:{self.state.y:.2f} "
                   f"Z:{self.state.z:.2f} E:{self.state.e:.2f} "
                   f"Count X:{int(self.state.x*80)} Y:{int(self.state.y*80)} Z:{int(self.state.z*400)}")
        elif code == "M115":
            # Firmware info
            return "ok FIRMWARE_NAME:VirtualPrinter PROTOCOL_VERSION:1.0"
        elif code == "M140":
            # Set bed temperature
            self.state.bed_target = params.get('S', 0)
            return "ok"
        elif code == "M190":
            # Wait for bed temperature
            self.state.bed_target = params.get('S', 0)
            self.state.bed_temp = self.state.bed_target
            return "ok"
        elif code == "M82":
            # Absolute extrusion
            self.state.e_relative = False
            return "ok"
        elif code == "M83":
            # Relative extrusion
            self.state.e_relative = True
            return "ok"
        elif code == "M106":
            # Fan on
            return "ok"
        elif code == "M107":
            # Fan off
            return "ok"
        elif code == "M84" or code == "M18":
            # Disable steppers
            return "ok"
        elif code == "M220":
            # Set speed factor
            return "ok"
        elif code == "M221":
            # Set flow factor
            return "ok"
        
        # Unknown command - still acknowledge
        return "ok"
    
    def _cmd_move(self, params: Dict[str, float]) -> str:
        """Handle G0/G1 move command."""
        old_pos = (self.state.x, self.state.y, self.state.z, self.state.e)
        
        if self.state.is_relative:
            if 'X' in params:
                self.state.x += params['X']
            if 'Y' in params:
                self.state.y += params['Y']
            if 'Z' in params:
                self.state.z += params['Z']
        else:
            if 'X' in params:
                self.state.x = params['X']
            if 'Y' in params:
                self.state.y = params['Y']
            if 'Z' in params:
                self.state.z = params['Z']
        
        if self.state.e_relative:
            if 'E' in params:
                self.state.e += params['E']
        else:
            if 'E' in params:
                self.state.e = params['E']
        
        if 'F' in params:
            self.state.feedrate = params['F']
        
        # Clamp to limits
        self.state.x = max(0, min(self.state.x, self.state.max_x))
        self.state.y = max(0, min(self.state.y, self.state.max_y))
        self.state.z = max(0, min(self.state.z, self.state.max_z))
        
        # Notify callback if position changed
        new_pos = (self.state.x, self.state.y, self.state.z, self.state.e)
        if new_pos != old_pos and self.on_move:
            self.on_move(self.state)
        
        return "ok"
    
    def _cmd_home(self, params: Dict[str, float]) -> str:
        """Handle G28 home command."""
        # Home specified axes or all if none specified
        if not params or 'X' in params:
            self.state.x = 0
        if not params or 'Y' in params:
            self.state.y = 0
        if not params or 'Z' in params:
            self.state.z = 0
        
        self.state.is_homed = True
        
        if self.on_move:
            self.on_move(self.state)
        
        return "ok"
    
    def _cmd_set_position(self, params: Dict[str, float]) -> str:
        """Handle G92 set position command."""
        if 'X' in params:
            self.state.x = params['X']
        if 'Y' in params:
            self.state.y = params['Y']
        if 'Z' in params:
            self.state.z = params['Z']
        if 'E' in params:
            self.state.e = params['E']
        
        return "ok"
    
    def _respond(self, msg: str) -> None:
        """Send response to connected software."""
        if self._master_fd:
            try:
                os.write(self._master_fd, (msg + '\n').encode())
            except OSError:
                pass
    
    def get_position(self) -> Tuple[float, float, float, float]:
        """Get current position (x, y, z, e)."""
        return (self.state.x, self.state.y, self.state.z, self.state.e)
    
    def get_temperature(self) -> Tuple[float, float, float, float]:
        """Get temperatures (hotend, hotend_target, bed, bed_target)."""
        return (
            self.state.hotend_temp, 
            self.state.hotend_target,
            self.state.bed_temp,
            self.state.bed_target
        )
    
    def __enter__(self):
        self.start()
        return self
    
    def __exit__(self, exc_type, exc_val, exc_tb):
        self.stop()


class GCodeGenerator:
    """
    G-code generator for AI agents.
    
    Generates G-code commands for 3D printing operations.
    """
    
    def __init__(self, flavor: str = "marlin"):
        """
        Initialize G-code generator.
        
        Args:
            flavor: G-code flavor ("marlin", "klipper", "reprap")
        """
        self.flavor = flavor
        self.commands: List[str] = []
        
        # Current state tracking
        self._x = 0.0
        self._y = 0.0
        self._z = 0.0
        self._e = 0.0
        self._feedrate = 1000.0
    
    def comment(self, text: str) -> "GCodeGenerator":
        """Add a comment."""
        self.commands.append(f"; {text}")
        return self
    
    def home(self, x: bool = True, y: bool = True, z: bool = True) -> "GCodeGenerator":
        """Home axes."""
        axes = ""
        if x:
            axes += " X"
        if y:
            axes += " Y"
        if z:
            axes += " Z"
        
        self.commands.append(f"G28{axes}".strip())
        
        if x:
            self._x = 0
        if y:
            self._y = 0
        if z:
            self._z = 0
        
        return self
    
    def move_to(self, x: Optional[float] = None, y: Optional[float] = None,
                z: Optional[float] = None, feedrate: Optional[float] = None,
                rapid: bool = False) -> "GCodeGenerator":
        """
        Move to position (non-printing).
        
        Args:
            x, y, z: Target position
            feedrate: Speed in mm/min
            rapid: Use G0 rapid move instead of G1
        """
        cmd = "G0" if rapid else "G1"
        
        if x is not None:
            cmd += f" X{x:.3f}"
            self._x = x
        if y is not None:
            cmd += f" Y{y:.3f}"
            self._y = y
        if z is not None:
            cmd += f" Z{z:.3f}"
            self._z = z
        if feedrate is not None:
            cmd += f" F{feedrate:.0f}"
            self._feedrate = feedrate
        
        self.commands.append(cmd)
        return self
    
    def extrude_to(self, x: Optional[float] = None, y: Optional[float] = None,
                   z: Optional[float] = None, e: Optional[float] = None,
                   feedrate: Optional[float] = None) -> "GCodeGenerator":
        """
        Move while extruding (printing).
        
        Args:
            x, y, z: Target position
            e: Extruder position
            feedrate: Speed in mm/min
        """
        cmd = "G1"
        
        if x is not None:
            cmd += f" X{x:.3f}"
            self._x = x
        if y is not None:
            cmd += f" Y{y:.3f}"
            self._y = y
        if z is not None:
            cmd += f" Z{z:.3f}"
            self._z = z
        if e is not None:
            cmd += f" E{e:.5f}"
            self._e = e
        if feedrate is not None:
            cmd += f" F{feedrate:.0f}"
            self._feedrate = feedrate
        
        self.commands.append(cmd)
        return self
    
    def retract(self, distance: float = 1.0, feedrate: float = 2400) -> "GCodeGenerator":
        """Retract filament."""
        self._e -= distance
        self.commands.append(f"G1 E{self._e:.5f} F{feedrate:.0f}")
        return self
    
    def unretract(self, distance: float = 1.0, feedrate: float = 2400) -> "GCodeGenerator":
        """Unretract (prime) filament."""
        self._e += distance
        self.commands.append(f"G1 E{self._e:.5f} F{feedrate:.0f}")
        return self
    
    def set_hotend_temp(self, temp: float, wait: bool = False) -> "GCodeGenerator":
        """Set hotend temperature."""
        cmd = "M109" if wait else "M104"
        self.commands.append(f"{cmd} S{temp:.0f}")
        return self
    
    def set_bed_temp(self, temp: float, wait: bool = False) -> "GCodeGenerator":
        """Set bed temperature."""
        cmd = "M190" if wait else "M140"
        self.commands.append(f"{cmd} S{temp:.0f}")
        return self
    
    def fan_on(self, speed: int = 255) -> "GCodeGenerator":
        """Turn on part cooling fan."""
        self.commands.append(f"M106 S{speed}")
        return self
    
    def fan_off(self) -> "GCodeGenerator":
        """Turn off part cooling fan."""
        self.commands.append("M107")
        return self
    
    def set_absolute(self) -> "GCodeGenerator":
        """Set absolute positioning."""
        self.commands.append("G90")
        return self
    
    def set_relative(self) -> "GCodeGenerator":
        """Set relative positioning."""
        self.commands.append("G91")
        return self
    
    def set_extrusion_absolute(self) -> "GCodeGenerator":
        """Set absolute extrusion mode."""
        self.commands.append("M82")
        return self
    
    def set_extrusion_relative(self) -> "GCodeGenerator":
        """Set relative extrusion mode."""
        self.commands.append("M83")
        return self
    
    def reset_extruder(self) -> "GCodeGenerator":
        """Reset extruder position to 0."""
        self.commands.append("G92 E0")
        self._e = 0
        return self
    
    def disable_steppers(self) -> "GCodeGenerator":
        """Disable stepper motors."""
        self.commands.append("M84")
        return self
    
    def dwell(self, ms: int) -> "GCodeGenerator":
        """Wait for specified milliseconds."""
        self.commands.append(f"G4 P{ms}")
        return self
    
    def draw_line(self, x1: float, y1: float, x2: float, y2: float,
                  z: float, layer_height: float = 0.2, 
                  line_width: float = 0.4, feedrate: float = 1200) -> "GCodeGenerator":
        """
        Draw a line from (x1, y1) to (x2, y2).
        
        Automatically calculates extrusion based on geometry.
        """
        import math
        
        # Move to start
        self.move_to(x=x1, y=y1, z=z, rapid=True)
        
        # Calculate line length
        length = math.sqrt((x2 - x1)**2 + (y2 - y1)**2)
        
        # Calculate extrusion (simplified formula)
        # E = (line_width * layer_height * length) / (pi * (filament_diameter/2)^2)
        filament_diameter = 1.75
        cross_section = 3.14159 * (filament_diameter/2)**2
        extrusion = (line_width * layer_height * length) / cross_section
        
        self._e += extrusion
        self.extrude_to(x=x2, y=y2, e=self._e, feedrate=feedrate)
        
        return self
    
    def draw_rectangle(self, x: float, y: float, width: float, height: float,
                       z: float, layer_height: float = 0.2,
                       line_width: float = 0.4, feedrate: float = 1200) -> "GCodeGenerator":
        """Draw a rectangle perimeter."""
        # Move to start
        self.move_to(x=x, y=y, z=z, rapid=True)
        
        # Draw four sides
        points = [
            (x + width, y),
            (x + width, y + height),
            (x, y + height),
            (x, y)
        ]
        
        for px, py in points:
            self.draw_line(self._x, self._y, px, py, z, layer_height, line_width, feedrate)
        
        return self
    
    def draw_circle(self, cx: float, cy: float, radius: float, z: float,
                    segments: int = 32, layer_height: float = 0.2,
                    line_width: float = 0.4, feedrate: float = 1200) -> "GCodeGenerator":
        """Draw a circle."""
        import math
        
        # Calculate points
        points = []
        for i in range(segments + 1):
            angle = 2 * math.pi * i / segments
            x = cx + radius * math.cos(angle)
            y = cy + radius * math.sin(angle)
            points.append((x, y))
        
        # Move to first point
        self.move_to(x=points[0][0], y=points[0][1], z=z, rapid=True)
        
        # Draw segments
        for i in range(1, len(points)):
            self.draw_line(points[i-1][0], points[i-1][1], 
                          points[i][0], points[i][1], 
                          z, layer_height, line_width, feedrate)
        
        return self
    
    def start_print(self, bed_temp: float = 60, hotend_temp: float = 200) -> "GCodeGenerator":
        """Add standard print start sequence."""
        self.comment("Start G-code")
        self.set_bed_temp(bed_temp, wait=False)
        self.set_hotend_temp(hotend_temp, wait=False)
        self.home()
        self.set_bed_temp(bed_temp, wait=True)
        self.set_hotend_temp(hotend_temp, wait=True)
        self.set_absolute()
        self.set_extrusion_absolute()
        self.reset_extruder()
        self.comment("Prime nozzle")
        self.move_to(x=0.1, y=20, z=0.3)
        self.draw_line(0.1, 20, 0.1, 200, 0.3)
        self.reset_extruder()
        self.comment("End start G-code")
        return self
    
    def end_print(self) -> "GCodeGenerator":
        """Add standard print end sequence."""
        self.comment("End G-code")
        self.fan_off()
        self.set_hotend_temp(0)
        self.set_bed_temp(0)
        self.move_to(z=self._z + 10)  # Raise Z
        self.home(x=True, y=True, z=False)
        self.disable_steppers()
        self.comment("Print complete")
        return self
    
    def get_gcode(self) -> str:
        """Get generated G-code as string."""
        return '\n'.join(self.commands)
    
    def save(self, path: str) -> None:
        """Save G-code to file."""
        with open(path, 'w') as f:
            f.write(self.get_gcode())
    
    def clear(self) -> "GCodeGenerator":
        """Clear all commands."""
        self.commands.clear()
        self._x = 0
        self._y = 0
        self._z = 0
        self._e = 0
        return self


if __name__ == "__main__":
    print("Virtual 3D Printer Controller Module")
    print("=" * 40)
    
    # Test G-code generator
    print("\nGenerating sample G-code...")
    gcode = GCodeGenerator()
    gcode.start_print(bed_temp=60, hotend_temp=200)
    gcode.draw_rectangle(100, 100, 20, 20, 0.3)
    gcode.draw_circle(110, 110, 5, 0.5)
    gcode.end_print()
    
    output_path = "/tmp/test_print.gcode"
    gcode.save(output_path)
    print(f"Saved to: {output_path}")
    print(f"Total lines: {len(gcode.commands)}")
    
    # Test virtual printer
    print("\nStarting virtual printer...")
    
    def on_cmd(cmd, state):
        print(f"  Received: {cmd.code} {cmd.params}")
    
    def on_move(state):
        print(f"  Position: X={state.x:.1f} Y={state.y:.1f} Z={state.z:.1f}")
    
    with VirtualPrinter(on_command=on_cmd, on_move=on_move) as printer:
        print(f"Virtual printer available at: {printer.port_name}")
        print("Press Ctrl+C to stop\n")
        
        # Keep running for demo
        try:
            time.sleep(5)
        except KeyboardInterrupt:
            pass
    
    print("\nVirtual printer stopped")
