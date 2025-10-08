# Traffic Light Controller

This is a Verilog implementation of a 3-way intersection traffic light FSM with emergency vehicle support.

## Features
- 6-state normal traffic light cycle
- Emergency vehicle interrupts any state
- 3-bit R/Y/G encoding for lights

## Simulation
- Testbench (`TrafficLightController_tb.v`) cycles through normal states and tests emergency interrupts.
- Run simulation in any Verilog simulator and monitor outputs.

## Light Encoding
- 001 = Green
- 010 = Yellow
- 100 = Red
