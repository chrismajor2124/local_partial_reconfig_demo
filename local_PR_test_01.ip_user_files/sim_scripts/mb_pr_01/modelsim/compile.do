vlib modelsim_lib/work
vlib modelsim_lib/msim

vlib modelsim_lib/msim/xpm
vlib modelsim_lib/msim/axi_lite_ipif_v3_0_4
vlib modelsim_lib/msim/lib_cdc_v1_0_2
vlib modelsim_lib/msim/lib_pkg_v1_0_2
vlib modelsim_lib/msim/fifo_generator_v13_2_5
vlib modelsim_lib/msim/lib_fifo_v1_0_14
vlib modelsim_lib/msim/interrupt_control_v3_1_4
vlib modelsim_lib/msim/axi_hwicap_v3_0_26
vlib modelsim_lib/msim/xil_defaultlib
vlib modelsim_lib/msim/microblaze_v11_0_4
vlib modelsim_lib/msim/lib_srl_fifo_v1_0_2
vlib modelsim_lib/msim/axi_uartlite_v2_0_26
vlib modelsim_lib/msim/mdm_v3_2_19
vlib modelsim_lib/msim/lmb_v10_v3_0_11
vlib modelsim_lib/msim/lmb_bram_if_cntlr_v4_0_19
vlib modelsim_lib/msim/blk_mem_gen_v8_4_4
vlib modelsim_lib/msim/proc_sys_reset_v5_0_13
vlib modelsim_lib/msim/generic_baseblocks_v2_1_0
vlib modelsim_lib/msim/axi_infrastructure_v1_1_0
vlib modelsim_lib/msim/axi_register_slice_v2_1_22
vlib modelsim_lib/msim/axi_data_fifo_v2_1_21
vlib modelsim_lib/msim/axi_crossbar_v2_1_23
vlib modelsim_lib/msim/dist_mem_gen_v8_0_13
vlib modelsim_lib/msim/axi_quad_spi_v3_2_21
vlib modelsim_lib/msim/axi_gpio_v2_0_24

vmap xpm modelsim_lib/msim/xpm
vmap axi_lite_ipif_v3_0_4 modelsim_lib/msim/axi_lite_ipif_v3_0_4
vmap lib_cdc_v1_0_2 modelsim_lib/msim/lib_cdc_v1_0_2
vmap lib_pkg_v1_0_2 modelsim_lib/msim/lib_pkg_v1_0_2
vmap fifo_generator_v13_2_5 modelsim_lib/msim/fifo_generator_v13_2_5
vmap lib_fifo_v1_0_14 modelsim_lib/msim/lib_fifo_v1_0_14
vmap interrupt_control_v3_1_4 modelsim_lib/msim/interrupt_control_v3_1_4
vmap axi_hwicap_v3_0_26 modelsim_lib/msim/axi_hwicap_v3_0_26
vmap xil_defaultlib modelsim_lib/msim/xil_defaultlib
vmap microblaze_v11_0_4 modelsim_lib/msim/microblaze_v11_0_4
vmap lib_srl_fifo_v1_0_2 modelsim_lib/msim/lib_srl_fifo_v1_0_2
vmap axi_uartlite_v2_0_26 modelsim_lib/msim/axi_uartlite_v2_0_26
vmap mdm_v3_2_19 modelsim_lib/msim/mdm_v3_2_19
vmap lmb_v10_v3_0_11 modelsim_lib/msim/lmb_v10_v3_0_11
vmap lmb_bram_if_cntlr_v4_0_19 modelsim_lib/msim/lmb_bram_if_cntlr_v4_0_19
vmap blk_mem_gen_v8_4_4 modelsim_lib/msim/blk_mem_gen_v8_4_4
vmap proc_sys_reset_v5_0_13 modelsim_lib/msim/proc_sys_reset_v5_0_13
vmap generic_baseblocks_v2_1_0 modelsim_lib/msim/generic_baseblocks_v2_1_0
vmap axi_infrastructure_v1_1_0 modelsim_lib/msim/axi_infrastructure_v1_1_0
vmap axi_register_slice_v2_1_22 modelsim_lib/msim/axi_register_slice_v2_1_22
vmap axi_data_fifo_v2_1_21 modelsim_lib/msim/axi_data_fifo_v2_1_21
vmap axi_crossbar_v2_1_23 modelsim_lib/msim/axi_crossbar_v2_1_23
vmap dist_mem_gen_v8_0_13 modelsim_lib/msim/dist_mem_gen_v8_0_13
vmap axi_quad_spi_v3_2_21 modelsim_lib/msim/axi_quad_spi_v3_2_21
vmap axi_gpio_v2_0_24 modelsim_lib/msim/axi_gpio_v2_0_24

vlog -work xpm  -incr -sv "+incdir+../../../../../../local_PR_test_01.gen/sources_1/bd/mb_pr_01/ipshared/ec67/hdl" \
"C:/Xilinx/Vivado/2020.2/data/ip/xpm/xpm_cdc/hdl/xpm_cdc.sv" \
"C:/Xilinx/Vivado/2020.2/data/ip/xpm/xpm_fifo/hdl/xpm_fifo.sv" \
"C:/Xilinx/Vivado/2020.2/data/ip/xpm/xpm_memory/hdl/xpm_memory.sv" \

vcom -work xpm  -93 \
"C:/Xilinx/Vivado/2020.2/data/ip/xpm/xpm_VCOMP.vhd" \

vcom -work axi_lite_ipif_v3_0_4  -93 \
"../../../../../../local_PR_test_01.gen/sources_1/bd/mb_pr_01/ipshared/66ea/hdl/axi_lite_ipif_v3_0_vh_rfs.vhd" \

vcom -work lib_cdc_v1_0_2  -93 \
"../../../../../../local_PR_test_01.gen/sources_1/bd/mb_pr_01/ipshared/ef1e/hdl/lib_cdc_v1_0_rfs.vhd" \

vcom -work lib_pkg_v1_0_2  -93 \
"../../../../../../local_PR_test_01.gen/sources_1/bd/mb_pr_01/ipshared/0513/hdl/lib_pkg_v1_0_rfs.vhd" \

vlog -work fifo_generator_v13_2_5  -incr "+incdir+../../../../../../local_PR_test_01.gen/sources_1/bd/mb_pr_01/ipshared/ec67/hdl" \
"../../../../../../local_PR_test_01.gen/sources_1/bd/mb_pr_01/ipshared/276e/simulation/fifo_generator_vlog_beh.v" \

vcom -work fifo_generator_v13_2_5  -93 \
"../../../../../../local_PR_test_01.gen/sources_1/bd/mb_pr_01/ipshared/276e/hdl/fifo_generator_v13_2_rfs.vhd" \

vlog -work fifo_generator_v13_2_5  -incr "+incdir+../../../../../../local_PR_test_01.gen/sources_1/bd/mb_pr_01/ipshared/ec67/hdl" \
"../../../../../../local_PR_test_01.gen/sources_1/bd/mb_pr_01/ipshared/276e/hdl/fifo_generator_v13_2_rfs.v" \

vcom -work lib_fifo_v1_0_14  -93 \
"../../../../../../local_PR_test_01.gen/sources_1/bd/mb_pr_01/ipshared/a5cb/hdl/lib_fifo_v1_0_rfs.vhd" \

vcom -work interrupt_control_v3_1_4  -93 \
"../../../../../../local_PR_test_01.gen/sources_1/bd/mb_pr_01/ipshared/a040/hdl/interrupt_control_v3_1_vh_rfs.vhd" \

vcom -work axi_hwicap_v3_0_26  -93 \
"../../../../../../local_PR_test_01.gen/sources_1/bd/mb_pr_01/ipshared/10b4/hdl/axi_hwicap_v3_0_vh_rfs.vhd" \

vcom -work xil_defaultlib  -93 \
"../../../../../../local_PR_test_01.gen/sources_1/bd/mb_pr_01/ip/mb_pr_01_axi_hwicap_0_0/sim/mb_pr_01_axi_hwicap_0_0.vhd" \

vcom -work microblaze_v11_0_4  -93 \
"../../../../../../local_PR_test_01.gen/sources_1/bd/mb_pr_01/ipshared/9285/hdl/microblaze_v11_0_vh_rfs.vhd" \

vcom -work xil_defaultlib  -93 \
"../../../../../../local_PR_test_01.gen/sources_1/bd/mb_pr_01/ip/mb_pr_01_microblaze_0_0/sim/mb_pr_01_microblaze_0_0.vhd" \

vcom -work lib_srl_fifo_v1_0_2  -93 \
"../../../../../../local_PR_test_01.gen/sources_1/bd/mb_pr_01/ipshared/51ce/hdl/lib_srl_fifo_v1_0_rfs.vhd" \

vcom -work axi_uartlite_v2_0_26  -93 \
"../../../../../../local_PR_test_01.gen/sources_1/bd/mb_pr_01/ipshared/5edb/hdl/axi_uartlite_v2_0_vh_rfs.vhd" \

vcom -work xil_defaultlib  -93 \
"../../../../../../local_PR_test_01.gen/sources_1/bd/mb_pr_01/ip/mb_pr_01_axi_uartlite_0_0/sim/mb_pr_01_axi_uartlite_0_0.vhd" \

vcom -work mdm_v3_2_19  -93 \
"../../../../../../local_PR_test_01.gen/sources_1/bd/mb_pr_01/ipshared/8715/hdl/mdm_v3_2_vh_rfs.vhd" \

vcom -work xil_defaultlib  -93 \
"../../../../../../local_PR_test_01.gen/sources_1/bd/mb_pr_01/ip/mb_pr_01_mdm_0_0/sim/mb_pr_01_mdm_0_0.vhd" \

vcom -work lmb_v10_v3_0_11  -93 \
"../../../../../../local_PR_test_01.gen/sources_1/bd/mb_pr_01/ipshared/c2ed/hdl/lmb_v10_v3_0_vh_rfs.vhd" \

vcom -work xil_defaultlib  -93 \
"../../../../../../local_PR_test_01.gen/sources_1/bd/mb_pr_01/ip/mb_pr_01_dlmb_v10_0/sim/mb_pr_01_dlmb_v10_0.vhd" \
"../../../../../../local_PR_test_01.gen/sources_1/bd/mb_pr_01/ip/mb_pr_01_ilmb_v10_0/sim/mb_pr_01_ilmb_v10_0.vhd" \

vcom -work lmb_bram_if_cntlr_v4_0_19  -93 \
"../../../../../../local_PR_test_01.gen/sources_1/bd/mb_pr_01/ipshared/0b98/hdl/lmb_bram_if_cntlr_v4_0_vh_rfs.vhd" \

vcom -work xil_defaultlib  -93 \
"../../../../../../local_PR_test_01.gen/sources_1/bd/mb_pr_01/ip/mb_pr_01_dlmb_bram_if_cntlr_0/sim/mb_pr_01_dlmb_bram_if_cntlr_0.vhd" \
"../../../../../../local_PR_test_01.gen/sources_1/bd/mb_pr_01/ip/mb_pr_01_ilmb_bram_if_cntlr_0/sim/mb_pr_01_ilmb_bram_if_cntlr_0.vhd" \

vlog -work blk_mem_gen_v8_4_4  -incr "+incdir+../../../../../../local_PR_test_01.gen/sources_1/bd/mb_pr_01/ipshared/ec67/hdl" \
"../../../../../../local_PR_test_01.gen/sources_1/bd/mb_pr_01/ipshared/2985/simulation/blk_mem_gen_v8_4.v" \

vlog -work xil_defaultlib  -incr "+incdir+../../../../../../local_PR_test_01.gen/sources_1/bd/mb_pr_01/ipshared/ec67/hdl" \
"../../../../../../local_PR_test_01.gen/sources_1/bd/mb_pr_01/ip/mb_pr_01_lmb_bram_0/sim/mb_pr_01_lmb_bram_0.v" \

vcom -work proc_sys_reset_v5_0_13  -93 \
"../../../../../../local_PR_test_01.gen/sources_1/bd/mb_pr_01/ipshared/8842/hdl/proc_sys_reset_v5_0_vh_rfs.vhd" \

vcom -work xil_defaultlib  -93 \
"../../../../../../local_PR_test_01.gen/sources_1/bd/mb_pr_01/ip/mb_pr_01_rst_clk_wiz_1_100M_0/sim/mb_pr_01_rst_clk_wiz_1_100M_0.vhd" \

vlog -work generic_baseblocks_v2_1_0  -incr "+incdir+../../../../../../local_PR_test_01.gen/sources_1/bd/mb_pr_01/ipshared/ec67/hdl" \
"../../../../../../local_PR_test_01.gen/sources_1/bd/mb_pr_01/ipshared/b752/hdl/generic_baseblocks_v2_1_vl_rfs.v" \

vlog -work axi_infrastructure_v1_1_0  -incr "+incdir+../../../../../../local_PR_test_01.gen/sources_1/bd/mb_pr_01/ipshared/ec67/hdl" \
"../../../../../../local_PR_test_01.gen/sources_1/bd/mb_pr_01/ipshared/ec67/hdl/axi_infrastructure_v1_1_vl_rfs.v" \

vlog -work axi_register_slice_v2_1_22  -incr "+incdir+../../../../../../local_PR_test_01.gen/sources_1/bd/mb_pr_01/ipshared/ec67/hdl" \
"../../../../../../local_PR_test_01.gen/sources_1/bd/mb_pr_01/ipshared/af2c/hdl/axi_register_slice_v2_1_vl_rfs.v" \

vlog -work axi_data_fifo_v2_1_21  -incr "+incdir+../../../../../../local_PR_test_01.gen/sources_1/bd/mb_pr_01/ipshared/ec67/hdl" \
"../../../../../../local_PR_test_01.gen/sources_1/bd/mb_pr_01/ipshared/54c0/hdl/axi_data_fifo_v2_1_vl_rfs.v" \

vlog -work axi_crossbar_v2_1_23  -incr "+incdir+../../../../../../local_PR_test_01.gen/sources_1/bd/mb_pr_01/ipshared/ec67/hdl" \
"../../../../../../local_PR_test_01.gen/sources_1/bd/mb_pr_01/ipshared/bc0a/hdl/axi_crossbar_v2_1_vl_rfs.v" \

vlog -work xil_defaultlib  -incr "+incdir+../../../../../../local_PR_test_01.gen/sources_1/bd/mb_pr_01/ipshared/ec67/hdl" \
"../../../../../../local_PR_test_01.gen/sources_1/bd/mb_pr_01/ip/mb_pr_01_xbar_0/sim/mb_pr_01_xbar_0.v" \

vlog -work dist_mem_gen_v8_0_13  -incr "+incdir+../../../../../../local_PR_test_01.gen/sources_1/bd/mb_pr_01/ipshared/ec67/hdl" \
"../../../../local_PR_test_01.srcs/mb_pr_01/ipshared/0bf5/simulation/dist_mem_gen_v8_0.v" \

vcom -work axi_quad_spi_v3_2_21  -93 \
"../../../../local_PR_test_01.srcs/mb_pr_01/ipshared/63ec/hdl/axi_quad_spi_v3_2_rfs.vhd" \

vcom -work xil_defaultlib  -93 \
"../../../../../../local_PR_test_01.gen/sources_1/bd/mb_pr_01/ip/mb_pr_01_axi_quad_spi_0_0/sim/mb_pr_01_axi_quad_spi_0_0.vhd" \

vcom -work axi_gpio_v2_0_24  -93 \
"../../../../local_PR_test_01.srcs/mb_pr_01/ipshared/4318/hdl/axi_gpio_v2_0_vh_rfs.vhd" \

vcom -work xil_defaultlib  -93 \
"../../../../../../local_PR_test_01.gen/sources_1/bd/mb_pr_01/ip/mb_pr_01_axi_gpio_0_0/sim/mb_pr_01_axi_gpio_0_0.vhd" \
"../../../../../../local_PR_test_01.gen/sources_1/bd/mb_pr_01/ip/mb_pr_01_axi_gpio_1_0/sim/mb_pr_01_axi_gpio_1_0.vhd" \
"../../../../../../local_PR_test_01.gen/sources_1/bd/mb_pr_01/sim/mb_pr_01.vhd" \

vlog -work xil_defaultlib \
"glbl.v"

