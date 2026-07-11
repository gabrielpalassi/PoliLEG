# 🖥️ PoliLEG

A processor can be viewed as a design based on the control-unit and datapath paradigm. The control unit is responsible for the fetch, decode, execute, and write-back cycle that governs a programmable, general-purpose computer. The datapath consists of memory elements (such as a register file), flow-control components (which are usually combinational), and functional units.

Specified in VHDL, PoliLEG is a single-cycle Harvard-architecture processor designed to execute one instruction per clock cycle. It implements a subset of the ARMv8 instruction set (the LEGv8 subset presented by Hennessy and Patterson).

## Supported Instructions

PoliLEG supports the following instructions:

<img src="./images/supported-instructions.png" width="612.5" alt="Table of instructions supported by PoliLEG">

> **Language note:** The table retains the Portuguese headers _Instrução_, _Formato_, and _Sintaxe/Descrição_ because it is an original project artifact. They mean _Instruction_, _Format_, and _Syntax/Description_, respectively.

### Instruction Formats

- D-format for LDUR and STUR
- R-format for ADD, SUB, AND, and ORR
- CB-format for CBZ
- B-format for B

<img src="./images/instruction-formats.png" width="612.5" alt="LEGv8 instruction formats">

## Functional Units

PoliLEG consists of several functional units:

1. **Memory**
   - Instruction memory (IM) stores instructions.
   - Data memory (DM) stores data.

2. **Register**
   - The PC (program counter).

3. **Register file**
   - Stores the registers used by instructions.

4. **ALU (arithmetic logic unit)**
   - Performs arithmetic and logical operations.

5. **Multiplexers**
   - Route data to the appropriate units.

6. **Sign extension**
   - Extends signed values when required.

<img src="./images/architecture.png" width="612.5" alt="PoliLEG datapath and control architecture">

## ROM Program

The program stored in ROM (`rom.dat`) computes the greatest common divisor (GCD). The GCD algorithm's parameters are stored in RAM (`ram.dat`):

- Address 0: a constant representing the most negative two's-complement value.
- Address 1: the first GCD parameter (A).
- Address 2: the second GCD parameter (B).

The program reads A and B, computes their GCD, and stores the result at address 0, replacing the constant.

> **Compatibility note:** The final RAM and ROM contents do not exactly follow the [project specification](./Project-Specification-pt-BR.pdf), because they were adapted to the implemented processor's word size, addressing, and related constraints.
>
> **Language note:** The linked specification is in Brazilian Portuguese because it is the original assignment issued for the PCS3225 Digital Systems II course at the University of São Paulo; no official English version was provided with this project.

## Reference Material

- [Processor documentation (pt-BR)](./Documentation-pt-BR.pdf)
- [Project specification (pt-BR)](./Project-Specification-pt-BR.pdf)
- [LEGv8 Green Card](./LEGv8-Green-Card.pdf)
- [GCD assembly source](./GCD-Assembly.s)

> **Language note:** The processor documentation and project specification are in Brazilian Portuguese because they are preserved original course materials. The Green Card and assembly source are in English.
