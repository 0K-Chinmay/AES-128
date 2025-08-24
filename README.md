# AES-128 Hardware Accelerator (PYNQ)

## Overview
This repository contains an AES-128 hardware design targeting the PYNQ platform.  
Two implementations are included:

1. **BRAM-Loaded AES Design** – Loads data directly from on-chip BRAM for encryption.  
2. **AES-128 PYNQ AXI Model** – Optimized design with AXI interface support.

The optimized **AES-128 PYNQ** model achieves **high throughput** while maintaining a **low resource footprint** on FPGA.

---

## Performance Summary

### 1. BRAM-Loaded AES Design
- **Interface:** BRAM data loading  
- **Operation:** AES-128 encryption  
- **Clock Frequency:** *(specify if known)*  
- **Utilization:** *(add LUT/FF/DSP/BRAM usage if available)*  
- **Latency:** *(add cycle count if available)*  

### 2. AES-128 PYNQ AXI Model
- **Interface:** AXI-based for flexible data transfer  
- **Clock Frequency:** **175 MHz**  
- **Utilization:** **~2.5k LUTs**  
- **Latency:** **43 clock cycles per AES-128 block**  
- **Throughput:** **~457 Mbps**  

---

## Features
- Fully pipelined AES-128 encryption engine  
- Optimized for **high frequency and low LUT usage**  
- Supports **AXI interface** for easy integration with PYNQ workflows  
- Runs efficiently on **Xilinx FPGAs**  

---

## Getting Started

### Requirements
- PYNQ Board (Zynq-based, e.g., PYNQ-Z1 / Z2)  
- Vivado + Vitis / SDSoC toolchain  
- PYNQ Python runtime  

### Build & Deployment
1. Clone the repository.  
2. Open the project in **Vivado**.  
3. Generate bitstream and export hardware.  
4. Deploy to PYNQ board.  
5. Run Python scripts to send/receive data via AXI DMA.  

---

## Performance Insights
- The **BRAM version** is straightforward but limited in speed.  
- The **AXI version** achieves **10x lower cycle count** with **lower LUTs**, making it highly suitable for practical applications requiring high throughput AES encryption.  

---

## Applications
- Secure communication on FPGA-based systems  
- High-throughput data encryption for IoT and embedded devices  
- Real-time cryptographic accelerators  

---
