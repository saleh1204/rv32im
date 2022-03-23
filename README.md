RV32IM System-on-Chip (SOC)
===========================

What Is This?
-------------
This repository contains a five stage pipelined RISC-V (RV32IM) processor and multiple peripherals. The target FPGA is Intel (Altera) DE2-115.

What are the included peripherals?
-------------
Three peripherals are connected to the processor through Memory Mapped Input/Output (MMIO). Firstly, GPIO peripheral which controls the onboard 9 Green LEDs, 18 Red LEDs, 18 switches, and 8 7-Segment Displays. Secondly, the VGA peripheral which generate a video signal through the onboard VGA connector. Thirdly, LCD module which controls the LCD Display attached to the FPGA. The Base address for the GPIO module is 0x8000_0000, while the base address space for the VGA is 0x4000_0000. The base address for the LCD module is 0x5000_0000. The VGA module is still under development.

What HDL was used to develop this project?
-------------
The Hardware Description Language (HDL) used in this repository is SystemVerilog 2012 Standard (IEEE1800-2012).

Project Organization
------------
    ├── assembly           <- Contains sample testing programs for the processor written in assembly.
    ├── rtl                <- Contains SystemVerilog files of the processor and the peripherals.
    │
    ├── tb                 <- Contains test bench files for the stand alone processor and the top level module that includes the peripherals
    │
    ├── .svlint.toml       <- SystemVerilog lint configuration file.
    │
    ├── Makefile           <- Make file used to simulate and lint the system verilog files.
    ├── README.md          <- The top-level README for developers using this project.
    │
    ├── rv32im.do          <- Modelsim do file used to simulate the SystemVerilog files.
    │
    └── yosys_syn          <- yosys commands file used to synthesize SystemVerilog files.


## License
This work is licensed under the _GNU GENERAL PUBLIC LICENSE Version 3_, which implies that you can freely share and
adapt this content. To view a copy of this license, visit https://www.gnu.org/licenses/gpl-3.0.en.html .

References
------------
[RISC-V ISA Specification](
https://github.com/riscv/riscv-isa-manual/releases/download/Ratified-IMAFDQC/riscv-spec-20191213.pdf)

[System Verilog IEEE1800-2012 Standard](https://ieeexplore.ieee.org/document/6469140)