<!---
# SPDX-FileCopyrightText: 2020 Anish Singhani
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
# SPDX-License-Identifier: Apache-2.0
-->
# Crypto Accelerator Chip

This is a cryptography accelerator ASIC designed using the SKY130 (130nm) process node, to be taped out on the Google/Skywater/efabless open-source MPW shuttle. It includes hardware implementations of cores for AES128/AES256 and SHA256, as well as an experimental VGA-based game demo (it also includes the "caravel" debug-harness/padframe which is being used in this tapeout). The eventual goal of this project is to use it for embedded/IoT security applications.

## Project Structure

This repository ([asinghani/crypto-accelerator-chip](https://github.com/asinghani/crypto-accelerator-chip)) is the main project repository, containing the build configs, RTL, and testbenches for the design.

The openlane-based build environment (including the final tapeout-ready GDS files) is at [asinghani/crypto-accelerator-builds](https://github.com/asinghani/crypto-accelerator-builds). The build environment repository contains the project repository (this repository) as a submodule and uses symbolic links to form the directory structure (this is done to keep the main repository cleaner, as the build repository is quite unwieldy to manipulate due to its size). The build products must be stored inside the repo in order to use it with the efabless Open MPW platform, which pulls the build products directly from the git repository.

The accelerator itself (which is designed to be usable on both FPGA and ASIC) is designed in Chisel3 and is at [asinghani/crypto-accelerator](https://github.com/asinghani/crypto-accelerator) (it is also submoduled into this repository to make builds easier).


## Table of Contents

- [Architecture](#architecture)
- [Gate-Level Visualizations](#gate-level-visualizations)
    - [Chip Overview](#chip-overview)
    - [AES128 Encrypt/Decrypt](#aes128-encryptdecrypt)
    - [AES256 Encrypt/Decrypt](#aes256-encryptdecrypt)
    - [SHA256 Hashing](#sha256-hashing)
- [Build Instructions](#build-instructions)
    - [Dependencies](#dependencies)
    - [Download and Extract](#download-and-extract)
    - [Running Design Tests](#running-design-tests)
    - [Full Accelerator Build](#full-accelerator-build)
- [Directory Structure](#directory-structure)

## Architecture

This chip contains 4 major components:

1. AES128/256 Accelerator
    - Optimized for balance between speed and area, can encrypt or decrypt a 16-byte block in ~20 cycles for AES128 or ~28 cycles for AES256
    - Supports both ECB and CBC modes (CBC is recommended because it is much more secure against certain types of attacks) with no performance penalty for using CBC

2. SHA256 Accelerator
    - Can hash a single 512-bit block in ~66 cycles (and is able to process multiple blocks immediately back-to-back, i.e. when hashing a large file)

3. VGA Game Demo (experimental)
    - Original design was contributed by [Ethan Polcyn](https://github.com/ethanleep) (and then ported to run on the ASIC environment)
    - Consists of a small infinite side-scrolling jumping game (based on the Chromium Browser's "No internet"-game), playable using button input from one of the chip's I/O pins
    - Renders VGA video output at 640x480 through the chip's output pins

<img src="https://raw.githubusercontent.com/asinghani/crypto-accelerator-chip/main/doc/dino.png" width="600pt" />

4. Caravel harness/padframe
    - Required as part of Open MPW tapeout - contains a picorv32 CPU (which is used to interface with the rest of the cores through the Wishbone bus) and the padframe
    - See [efabless/caravel](https://github.com/efabless/caravel) for details. 

## Gate-Level Visualizations

### Chip Overview

<img src="https://raw.githubusercontent.com/asinghani/crypto-accelerator-chip/main/doc/chip.png" />

### AES128 Encrypt/Decrypt

<img src="https://raw.githubusercontent.com/asinghani/crypto-accelerator-chip/main/vis/out_compressed/aes128_tb/vis_3.gif" width="400pt" />

### AES256 Encrypt/Decrypt

<img src="https://raw.githubusercontent.com/asinghani/crypto-accelerator-chip/main/vis/out_compressed/aes256_tb/vis_3.gif" width="400pt" />

### SHA256 Hashing

<img src="https://raw.githubusercontent.com/asinghani/crypto-accelerator-chip/main/vis/out_compressed/sha256_tb/vis_3.gif" width="400pt" />

## Build Instructions

### Dependencies

- Python 3
- Icarus Verilog (for simulations)
- [OpenLANE](https://github.com/efabless/openlane) rc6
- [Magic VLSI Layout Tool](http://opencircuitdesign.com/magic/index.html) (>= 8.3.60)
- (Optional) Scala & SBT (only needed to regenerate the full build from the Chisel3 sources - otherwise can just use the prebuilt `crypto_accelerator.v` file that is already in the repository)

### Download and Extract

```sh
# Clone repo (and submodules)
git clone --recurse-submodules https://github.com/asinghani/crypto-accelerator-builds

# Uncompress the gzipped build products and harness files
make uncompress
```

### Running Design Tests

To run the tests (both RTL-level and gate-level):

```sh
cd verilog/dv/caravel/accelerator/

# To run a specific test case:
cd <aes / dino_vga / sha256>
make SIM=RTL SPOOF_FAST_FLASH=1 # for accelerated RTL test
make SIM=RTL # for normal RTL test
make SIM=GL # for gate-level test

# To run all AES and SHA test cases (from inside `accelerator` directory):
make rtl # RTL tests
make gl # gate-level tests
```

The `aes` and `sha256` testbenches are self-checking, and will print failure messages if there are any issues. There are additional verification steps in the Chisel3 testbenches (in the `crypto-accelerator` repo), including several hundred more test cases.

The `dino_vga` test is special because it cannot be automatically verified. Instead, there is a python script in the `dino_vga` directory (named `parse.py`, with `numpy`, `vcdvcd`, and `opencv-python` modules as dependencies) which can be invoked (from inside the `dino_vga` directory) as `python3 parse.py dino_vga.vcd "dino_vga_tb.dump[40:0]"` to parse the VCD and generate a PNG file `frame.png` containing the VGA frame outputted by the design (which can be visually inspected for correctness).

### Full Accelerator Build

(Expects that the download procedure has been completed, including the uncompress stage)

```sh
# Optional (only if need to re-generate crypto_accelerator.v from Chisel3 sources)
cd crypto-accelerator-chip && ./update-verilog.sh && cd ..

# Build top-level accelerator
cd openlane && make accelerator_top && cd ..
ls openlane/accelerator_top/runs/ # Find the most recent run name

# Move the netlists & build files
./migrate-accel-gds.sh <path to run including openlane/accelerator_top/runs/>
./migrate-gl.sh <path to run including openlane/accelerator_top/runs/>

# Build the "user project wrapper" which fits the accelerator into the caravel padframe
cd openlane && make user_project_wrapper && cd ..

# Re-run the netlist migration since it includes user_project_wrapper as well
./migrate-gl.sh <path to run including openlane/accelerator_top/runs/>

# Add user_project_wrapper into caravel padframe
make ship

# At this point, the top-level GDS (caravel + accelerator) is generated in `gds/caravel.gds`

# Optionally, to render the caravel to an image using KLayout
./render.sh # May need to run with XVFB if in a headless environment
```

## Directory Structure

The relevant files in this repository are as follows:
```
crypto-accelerator - Submodule which contains the Chisel3 design for the crypto accelerator
doc - Images / diagrams
openlane
├─accelerator_top - Configuration for building the main accelerator block
└─user_project_wrapper - Configuration for building the "wrapper" block which is used to fit the accelerator into the harness

update-verilog.sh - Script to re-generate crypto_accelerator.v from the Chisel3 sources in the crypto-accelerator submodule
verilog
├─dv
│ └─caravel
│   └─accelerator
│     ├─aes - Test cases for the AES128/256 core
│     ├─dino_vga - Simulation for the VGA game demo (must be verified visually)
│     ├─Makefile - Runs all simulations
│     └─sha256 - Test cases for the SHA256 core
│
└─rtl
  ├─accelerator
  │ ├─accelerator_top.v - Top-level design, instantiates and connects all the relevant modules
  │ ├─crypto_accelerator.v - Crypto accelerator verilog (auto-generated from Chisel3 RTL design)
  │ └─dino - Directory which contains all the sources for the VGA game demo
  │
  │
  └─user_project_wrapper.v - Instantiation of the accelerator core (exposing relevant ports to caravel)

vis - Scripts & testbenches for generating gate-level visualization diagrams of the chip
```
