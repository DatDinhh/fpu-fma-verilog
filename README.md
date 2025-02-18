# Pipelined Floating-Point FMA in Verilog

**Description**: This repository contains a **multi-stage pipelined floating-point Multiply-Add (FMA) unit** implemented in Verilog. It supports a simplified version of **IEEE 754 single-precision** (32-bit) arithmetic, including:

- Mantissa multiplication
- Exponent alignment
- Addition of partial product and a third operand
- Basic rounding/truncation
- Pipeline stages for higher throughput

---

## Features

- **IEEE 754 single-precision format** (sign, 8-bit exponent, 23-bit fraction)
- **Multiply-Add** operation: \((A \times B) + C\)
- **5+ pipeline stages** for decoding, multiply, normalize, align-add, and final rounding
- **Simplified** handling of exponent overflow/underflow
- **Verilog testbench** with example floating-point inputs

**Note**: This is not a production-level FPU—edge cases (NaNs, Infinities, subnormals, multiple rounding modes) are only partially handled. The design is primarily for learning and demonstration purposes.

---

## File Structure

- **fpu_fma_pipeline.v**  
  A Verilog module containing the pipelined FMA logic (decode, multiply, align, add, normalize).
- **fpu_fma_tb.v**  
  A basic testbench driving the FMA module with example floating-point values. Uses `$realtobits` and `$bitstoreal` for simulation-friendly input/output.
- **README.md**  
  This documentation file.

---

## How to Run (Icarus Verilog)

1. **Install** Icarus Verilog (version 11 or higher recommended).
2. **Clone** this repository:
   ```bash
   git clone https://github.com/DatDinhh/fpu-fma-verilog.git
   cd fpu-fma-verilog
3. Compile with -g2012 to enable SystemVerilog features:
    iverilog -g2012 -o fpu_fma.vvp fpu_fma_pipeline.v fpu_fma_tb.v

## Future Improvements

Full IEEE-754 compliance: Handle NaN, ±Infinity, subnormals, and different rounding modes
Exception flags: Overflow, underflow, inexact, invalid operations
Parameterize: Support half (16-bit), double (64-bit), or bfloat16
Deeper pipeline: Increase maximum clock frequency and throughput

## Acknowledgments

Inspired by standard FPU designs and various academic references on IEEE 754.
Uses $realtobits/$bitstoreal for quick testbench conversions (supported by many simulators).
