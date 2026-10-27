# Spartan6 - DSP48A1 Slice: Design & Verification

## 📌 Project Overview
This project involves the complete RTL design and functional verification of the **DSP48A1 Slice** (originally introduced in Xilinx Spartan-6 FPGAs). The module is modeled in Verilog HDL and verified using a robust testbench on QuestaSim, followed by elaboration and synthesis on Vivado.

## 🛠️ EDA Tools Used
* **Design & Verification:** Verilog HDL, QuestaSim (ModelSim)
* **Synthesis & Implementation:** AMD Xilinx Vivado

## 🏗️ Architecture Highlights
* Designed a highly configurable datapath including pre-adders, multipliers, and post-adders/logic units.
* Implemented parameterized register multiplexing (`REG_MUX`) to support dynamic pipeline stages (A0REG, A1REG, MREG, PREG, etc.).
* Supported multiple operational modes (`opmode`) and carry-in selections (`CARRYINSEL`).

## 📊 Verification & Synthesis
* Developed a comprehensive testbench (`DSP_tb.v`) verifying multiple critical datapaths.
* Ensured cycle-accurate operations matching the DSP48A1 golden specifications.
* Synthesized successfully on Vivado with optimized LUT and register utilization.
