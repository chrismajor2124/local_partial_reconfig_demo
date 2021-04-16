vlib work
vlib activehdl

vlib activehdl/xpm
vlib activehdl/sem_v4_1_13
vlib activehdl/xil_defaultlib

vmap xpm activehdl/xpm
vmap sem_v4_1_13 activehdl/sem_v4_1_13
vmap xil_defaultlib activehdl/xil_defaultlib

vlog -work xpm  -sv2k12 \
"C:/Xilinx/Vivado/2020.2/data/ip/xpm/xpm_cdc/hdl/xpm_cdc.sv" \
"C:/Xilinx/Vivado/2020.2/data/ip/xpm/xpm_fifo/hdl/xpm_fifo.sv" \
"C:/Xilinx/Vivado/2020.2/data/ip/xpm/xpm_memory/hdl/xpm_memory.sv" \

vcom -work xpm -93 \
"C:/Xilinx/Vivado/2020.2/data/ip/xpm/xpm_VCOMP.vhd" \

vlog -work sem_v4_1_13  -v2k5 \
"../../../ipstatic/hdl/sem_v4_1_vl_rfs.v" \

vlog -work xil_defaultlib  -v2k5 \
"../../../ip/new/sim/sem_0.v" \

vlog -work xil_defaultlib \
"glbl.v"

