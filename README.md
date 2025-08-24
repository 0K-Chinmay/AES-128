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


