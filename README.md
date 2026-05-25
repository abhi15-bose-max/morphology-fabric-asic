# Morphology Fabric ASIC

A cellular-automata-inspired morphology processing fabric implemented in Verilog and synthesized using OpenLane and the SKY130 PDK.

## Overview

This project explores massively parallel spatial morphology computation using a tiled processing-element architecture.

The fabric supports:
- binary dilation
- binary erosion
- programmable structuring-element masks
- spatial evolution dynamics
- ASIC physical synthesis

The architecture was implemented using:
- Verilog RTL
- OpenLane ASIC flow
- SKY130 standard-cell PDK
- KLayout visualization

---

## Features

- Fully parallel morphology engine
- Cellular automata-inspired local computation
- 4×4 and 8×8 scalable fabrics
- Programmable SE-mask behavior
- ASIC-synthesized layouts
- Simulation animations
- SPI-enabled top-level chip integration

---

## Repository Structure

- rtl/ → Verilog RTL
- testbench/ → simulation testbenches
- gds/ → final ASIC layouts
- animations/ → morphology evolution GIFs
- docs/ → architectural writeups
- openlane/ → ASIC synthesis configuration

---

## Physical Design

Generated using:
- OpenLane
- SKY130 PDK
- KLayout

---

## Author

Abhinav Basu
