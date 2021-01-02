#!/bin/sh
TARGET=$1

PDK=sky130_fd_sc_hd
GL=../../verilog/gl/accelerator_top.v
GDS=../../gds/accelerator_top.gds

TB=$TARGET.v
VCD=build/$TARGET.vcd

echo "PDK = $PDK"
echo "PDK_ROOT = $PDK_ROOT"

PRIMITIVES=$PDK_ROOT/open_pdks/sky130/sky130A/libs.ref/$PDK/verilog/primitives.v
CELLS=$PDK_ROOT/open_pdks/sky130/sky130A/libs.ref/$PDK/verilog/$PDK.v

if [ ! -f "$PRIMITIVES" ]; then
    echo "Verilog cell models not found."
    exit 1
fi

if [ ! -f "$CELLS" ]; then
    echo "Verilog cell models not found."
    exit 1
fi

if [ ! -f "$TB" ]; then
    echo "Usage: $0 <name of testbench module>"
    exit 1
fi

if [ ! -f "$GL" ]; then
    echo "Gate-level netlist not found. Is this script being run from the correct directory?"
    exit 1
fi

mkdir -p build
echo "Compiling sim..."
iverilog -o build/sim -g2012 -DFUNCTIONAL -DSIM -DGL -DUNIT_DELAY="#1" -DUSE_POWER_PINS -I . $PRIMITIVES $CELLS $GL $TB || exit 1

echo "Running sim..."
./build/sim || exit 1

# TODO
exit 1

# Hack to fix cells to work with yosys verilog parser
echo "Patching cells..."
cp $CELLS build/tmp_${PDK}_cells_fixed.v
sed -i 's/wire 1/wire __1/g' build/tmp_${PDK}_cells_fixed.v

if [ ! -f "$GDS" ]; then
    echo "GDS file not found. Has it been uncompressed?"
    exit 1
fi

if [ ! -f "$VCD" ]; then
    echo "VCD file not found."
    exit 1
fi

mkdir -p out
mkdir -p out/$TARGET
echo "Running visualization..."
python3 sky130-chip-vis/chip-vis.py \
                    --cell_models build/tmp_${PDK}_cells_fixed.v \
                    --gl_netlist $GL \
                    --vcd $VCD \
                    --gds $GDS \
                    --prefix "$TARGET.uut." \
                    --status_var "$TARGET.status" \
                    --rst "$TARGET.uut.wb_rst_i" \
                    --clk "$TARGET.uut.wb_clk_i" \
                    --start_status "" \
                    --outfile "out/$TARGET/vis.gif" \
                    --mode 0,1,2,3,4,5 \
                    --scale 3 \
                    --fps 8 \
                    --downscale 0.3 \
                    --blur 7 \
                    --exp_grow 1.2 \
                    --exp_decay 0.8 \
                    --lin_grow 0.15 \
                    --lin_decay 0.15 \
                    --build_dir build || exit 1
