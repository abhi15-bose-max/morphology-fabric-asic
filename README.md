# Programmable Cellular Morphology Engine (v1.0)

> **A Hardware-Native, Non-von Neumann Spatial Coprocessor Implementing Programmable Image Morphology and Cellular Automata Dynamics on a Tiled Silicon Grid.**

---

# Core Architecture Paradigm

Traditional image processing architectures execute morphology sequentially by scanning image kernels across centralized memory using nested CPU/GPU loops.

This architecture instead:
- physicalizes the image into silicon
- distributes computation spatially
- eliminates centralized processing bottlenecks

The image itself becomes:
# the compute fabric.

---

## Distributed Processing Fabric

```text
                           [ GLOBAL IMAGE MEMORY ]
                                      │
          ┌───────────────────────────┼───────────────────────────┐
          ▼                           ▼                           ▼

┌──────────────────┐        ┌──────────────────┐        ┌──────────────────┐
│   morpho_cell    │◄──────►│   morpho_cell    │◄──────►│   morpho_cell    │
│  [r=0, c=0] (PE) │        │  [r=0, c=1] (PE) │        │  [r=0, c=2] (PE) │
├──────────────────┤        ├──────────────────┤        ├──────────────────┤
│ Local Logic Mesh │        │ Local Logic Mesh │        │ Local Logic Mesh │
└──────────────────┘        └──────────────────┘        └──────────────────┘


```


# 1. `morpho_cell.v`

A single pixel-processing element (PE) that:

- samples its local 3×3 neighborhood
- applies a programmable Structuring Element mask
- executes spatial morphology logic

Each cell acts as:
# an autonomous local compute unit.

---

# 2. `morpho_grid_8x8.v`

A globally synchronized array composed of interconnected `morpho_cell` processing elements.

This fabric:

- connects neighboring cells spatially
- evolves synchronously every clock cycle
- generates emergent global image behavior

---

# Intuitive Overview

The architecture behaves like a grid of intelligent pixels.

Each pixel:

- communicates only with nearby neighbors
- evaluates local spatial rules
- updates synchronously with the rest of the fabric

As the grid evolves over time:
# global morphology behavior emerges naturally.

No centralized CPU scans the image.

The computation emerges directly from:
# local neighbor interactions.

---

# Cellular Automata (CA) Relation

This processor strongly resembles a programmable Cellular Automata fabric.

| CA Property | Hardware Implementation |
|---|---|
| Local State | Embedded 1-bit pixel register |
| Neighborhood Interaction | Hardwired 3×3 local mesh |
| Synchronous Evolution | Global `posedge clk` updates |
| Rule Programmability | Dynamic `se_mask` configuration |
| Emergent Behavior | Global morphology evolution |

---

# Mathematical Morphology Mapping

The architecture maps morphology directly onto hardware logic primitives.

---

# 1. Dilation → Spatial OR Fabric

Dilation performs:
# spatial growth.

Each cell asks:

> “Is ANY participating neighbor active?”

### Mathematical Representation

```math
dilation_result = \bigvee_{i=0}^{8} m_i

```
# Hardware Implementation

```verilog
wire dilation_result =
    m_nw | m_n | m_ne |
    m_w  | m_c | m_e |
    m_sw | m_s | m_se;
```

---

# 2. Erosion → Spatial AND Fabric

Erosion performs:
# spatial shrinking.

Each cell asks:

> “Are ALL required neighbors active?”

---

## Mathematical Representation

```math
erosion_result = \bigwedge_{i=0}^{8} m_i
```

---

## Hardware Implementation

```verilog
wire erosion_result =
    m_nw & m_n & m_ne &
    m_w  & m_c & m_e &
    m_sw & m_s & m_se;
```

---

# Runtime Structuring Element Neutralization

The architecture supports:
# programmable morphology kernels.

This is achieved through:

```verilog
se_mask
```

When a mask bit is disabled:

```verilog
se_mask[i] == 0
```

the corresponding neighbor must become:
# logically neutralized.

---

# Neutralization Principle

## OR Logic Identity

```text
X OR 0 = X
```

Therefore:

- excluded dilation neighbors become `0`

---

## AND Logic Identity

```text
X AND 1 = X
```

Therefore:

- excluded erosion neighbors become `1`

---

# Neutralization Circuit

```verilog
wire m_nw = se_mask[8] ? nw : (mode ? 1'b0 : 1'b1);
```

This dynamically inserts:

- OR-neutral values during dilation
- AND-neutral values during erosion

without additional multiplexing stages.

---

# Structuring Element Spatial Mapping

```text
se_mask[8] (nw)   │  se_mask[7] (north)  │  se_mask[6] (ne)
──────────────────┼──────────────────────┼──────────────────
se_mask[5] (west) │  se_mask[4] (self)   │  se_mask[3] (east)
──────────────────┼──────────────────────┼──────────────────
se_mask[2] (sw)   │  se_mask[1] (south)  │  se_mask[0] (se)
```

---

# Example Structuring Elements

## Full 3×3 Kernel

```verilog
9'b111111111
```

---

## Cross Kernel

```verilog
9'b010111010
```

```text
0 1 0
1 1 1
0 1 0
```

---

## Vertical Kernel

```verilog
9'b010010010
```

```text
0 1 0
0 1 0
0 1 0
```

---

# Hardware Verification Flow

## Project Structure

```text
openlane/designs/morpho_mvp/
├── src/
│   ├── morpho_cell.v
│   └── morpho_grid_8x8.v
│
└── tb/
    ├── tb_dilation.v
    ├── tb_erosion.v
    ├── tb_cross.v
    └── tb_vertical.v
```

---

# Environment Setup

```bash
wsl

sudo apt update

sudo apt install -y nano iverilog gtkwave
```

---

# Dilation Simulation

```bash
iverilog -o sim_dilation \
morpho_cell.v \
morpho_grid_8x8.v \
tb_dilation.v

vvp sim_dilation
```

---

# Erosion Simulation

```bash
iverilog -o sim_erosion \
morpho_cell.v \
morpho_grid_8x8.v \
tb_erosion.v

vvp sim_erosion
```

---

# Cross-Mask Simulation

```bash
iverilog -o sim_cross \
morpho_cell.v \
morpho_grid_8x8.v \
tb_cross.v

vvp sim_cross
```

---

# Vertical-Mask Simulation

```bash
iverilog -o sim_vertical \
morpho_cell.v \
morpho_grid_8x8.v \
tb_vertical.v

vvp sim_vertical
```

---

# Seed Configuration

The initial spatial pattern is configured through:

```verilog
reg [63:0] pixels = 64'h8040201008040201;
```

inside:

```verilog
morpho_grid_8x8.v
```

---

# Example Seed Patterns

## Checkerboard

```verilog
64'hAA55AA55AA55AA55
```

---

## Central Square

```verilog
64'h00003C3C3C3C0000
```

---

## Random Spatial Field

```verilog
64'h18A53C7E81D22442
```

---

# ASIC Flow

This architecture was synthesized using:

- OpenLane
- SKY130 PDK
- KLayout

The repository includes:

- RTL
- testbenches
- GDS layouts
- OpenLane configuration
- simulation infrastructure

---

# Future Directions

- Larger scalable PE fabrics
- Runtime-programmable kernels
- Grayscale morphology support
- FPGA benchmarking
- SPI image streaming
- CA-inspired spatial accelerators
- Non-von Neumann vision hardware

---

# Author

Abhinav Basu


