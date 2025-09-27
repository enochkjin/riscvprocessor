# riscvprocessor

This project implements a **single-cycle RISC-V CPU** in Verilog as part of [EECS 20] at UCI.

## Features
- Implements the RV32I base instruction set
- Separate modules for ALU, register file, control unit, etc.
- Includes testbenches for simulation

## File Structure (Design Sources)
- processor.v
  - Datapath.v
    - FlipFlop.v
    - InstMem.v
    - RegFile.v
    - ImmGen.v
    - Mux.v (alu_mux)
    - ALU.v
    - DataMem.v
    - Mux.v (writeback_mux)
- Controller.v
- ALUController.v

## File Structure (Simulation Sources)
