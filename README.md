# Hamming(7,4) SECDED Verilog Design

A Verilog-based implementation of Hamming(7,4) error-correcting code with:
- **Single-bit error correction**
- **Double-bit error detection**
- **Self-checking simulation and visualization using 7-segment display**

## Overview

This project implements a complete data protection system based on the Hamming(7,4) code. The design is modular and includes encoding, decoding, error simulation, error position identification, and visual feedback using a 7-segment display.

---

## Project Structure

### 1. Hamming Encoder
Encodes 4-bit input data into a 7-bit Hamming codeword with parity bits.

### 2. Hamming Decoder
Decodes the 7-bit codeword, corrects single-bit errors, and detects double-bit errors. Outputs the corrected data and the syndrome.

### 3. Noise Generator
Simulates 1-bit, 2-bit, and 3-bit random errors for validation and robustness testing.

### 4. Priority Encoder
Takes the syndrome (one-hot encoded) and converts it to a binary index representing the error bit position.

### 5. 7-Segment Display 
Displays the current error bit position (0 to 6) or indicates no error on a 7-segment display.

### 6. Self-Checking Testbench
Automated testbench that simulates different error scenarios and validates the encoder-decoder system end-to-end using assertions.

---

## Technical Summary

- **Code Standard:** Verilog HDL (IEEE 1364)
- **Toolchain:** Xilinx Vivado (for simulation and functional verification)
- **Testbench:** Self-checking with expected outputs and assertions
- **Supported Error Types:**
  - Single-bit errors → *Correctable*
  - Double-bit errors → *Detectable only*
  - Parity errors → *Indicates parity mismatch*

---

## Simulation Workflow

1. **Encode** the 4-bit input using the Hamming Encoder.
2. **Inject** noise via the Noise Generator (simulate 1, 2, or 3-bit errors).
3. **Decode** the received data using the Hamming Decoder.
4. **Locate** error position with the Priority Encoder.
5. **Display** error position using the 7-segment driver.
6. **Verify** correctness using assertions in the self-checking testbench.

---


![hamming74_secded](https://github.com/user-attachments/assets/07bd25f8-912c-4370-8c28-369d91f3856f)

