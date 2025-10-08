# Traffic Light Controller

This is a Verilog implementation of a 3-way intersection traffic light FSM with emergency vehicle support.

## Features
- 6-state normal traffic light cycle
- Emergency vehicle interrupts any state
- 3-bit R/Y/G encoding for lights

## Inputs

| Input               | Bits | Description |
|--------------------|-------|-------------|
| `clk`              | 1     | Clock signal |
| `rst`              | 1     | Active-high reset |
| `emergency_vehicle`| 1     | 0 = normal, 1 = emergency active |
| `emergency_road`   | 2     | Selects road with emergency priority: 00=M1, 01=M2, 10=MT, 11=S |

---

## Outputs

| Output        | Bits | Description |
|---------------|-------|-------------|
| `main_road_1` | 3     | [R Y G] traffic light for Main Road 1 |
| `main_road_2` | 3     | [R Y G] traffic light for Main Road 2 |
| `main_turn`   | 3     | [R Y G] traffic light for Main Turn |
| `side_road`   | 3     | [R Y G] traffic light for Side Road |

**Light Encoding (3-bit `[R Y G]`)**

| Binary | Color |
|--------|-------|
| 001    | Green |
| 010    | Yellow|
| 100    | Red   |

---

## FSM State Encoding

| State             | Binary |
|------------------|--------|
| S1               | 0000   |
| S2               | 0001   |
| S3               | 0010   |
| S4               | 0011   |
| S5               | 0100   |
| S6               | 0101   |
| EMERGENCY_MODE   | 0110   |

---

## Traffic Light Truth Table

| Current_State (FSM) | Emergency_vehicle | Emergency_road | M1 [R Y G] | M2 [R Y G] | MT [R Y G] | S [R Y G] | Notes |
|---------------------|-------------------|----------------|------------|------------|------------|-----------|-------|
| S1                 | 0               | -              | 001        | 001        | 100        | 100       | Normal: M1 & M2 green |
| S2                 | 0               | -              | 001        | 010        | 100        | 100       | M1 green, M2 yellow |
| S3                 | 0               | -              | 001        | 100        | 001        | 100       | M1 green, MT green |
| S4                 | 0               | -              | 010        | 100        | 010        | 100       | M1 yellow, MT yellow |
| S5                 | 0               | -              | 100        | 100        | 100        | 001       | Side road green |
| S6                 | 0               | -              | 100        | 100        | 100        | 010       | Side road yellow |
| EMERGENCY_MODE      | 1               | 00 (M1)        | 001        | 100        | 100        | 100       | Emergency on M1 |
| EMERGENCY_MODE      | 1               | 01 (M2)        | 100        | 001        | 100        | 100       | Emergency on M2 |
| EMERGENCY_MODE      | 1               | 10 (MT)        | 100        | 100        | 001        | 100       | Emergency on MT |
| EMERGENCY_MODE      | 1               | 11 (S)         | 100        | 100        | 100        | 001       | Emergency on Side Road |

---

## Simulation

- Testbench: `TrafficLightController_tb.v`  
- Demonstrates normal cycling and emergency vehicle interrupts for all roads.  
- Outputs are in 3-bit `[R Y G]` format and can be monitored in any Verilog simulator.
