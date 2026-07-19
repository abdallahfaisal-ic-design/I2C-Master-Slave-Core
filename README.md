# Parameterized I2C Master/Slave IP Core

A fully synthesizable, flexible I2C (Inter-Integrated Circuit) Controller IP Core modeled in Verilog HDL. This design provides a robust implementation of the synchronous, multi-master, serial communication bus protocol, optimized for reliable chip-to-chip data transfers in modern embedded systems.

## Key Technical Features
* **Complete Protocol Handshaking:** Dedicated hardware logic to automatically detect and generate strict I2C signaling conditions including `START`, `STOP`, and `Repeated START (Sr)`.
* * **Bidirectional Data Line Management:** Tri-state buffer control logic accurately modeled in Verilog to manage the open-drain Serial Data line (`SDA`) and handle acknowledgment (`ACK`/`NACK`) phases safely.
* * **Dual Master/Slave Operational Modes:** Features highly modular design components with independent `I2C_Master` and `I2C_Slave` controllers.
* * **Clock Synchronization & Stretching:** Built-in support for Slave clock stretching to allow slower peripheral targets to hold the Serial Clock line (`SCL`) low and throttle data rates.
* * **7-bit Device Addressing:** Hardware address decoding logic supporting standard 7-bit addressing with integrated Read/Write bit evaluation.
       
* ## Core Modules & Design Blocks
* * **I2C Master Controller:** Manages the generation of the `SCL` clock, initiates bus framing conditions, and controls the main communication Finite State Machine (FSM).
* * **I2C Slave Controller:** Monitors the bus for matching device addresses, tracks system states, and samples or drives data lines synchronously.
* * **Input Glitch Filter:** Digital spike suppression filters on both `SDA` and `SCL` to eliminate high-frequency bus noise and cross-talk.
             
* ## Simulation & Verification
* * **HDL Language:** Verilog HDL
* * **Simulation Tool:** ModelSim SE
* * **Testbench Methodology:** End-to-end simulation testbench covering a full Master-to-Slave read and write transaction cycle, validation of target address acknowledgment, and verification of error handling during data collision or `NACK` scenarios.
