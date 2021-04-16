-makelib ies_lib/xpm -sv \
  "C:/Xilinx/Vivado/2020.2/data/ip/xpm/xpm_cdc/hdl/xpm_cdc.sv" \
  "C:/Xilinx/Vivado/2020.2/data/ip/xpm/xpm_fifo/hdl/xpm_fifo.sv" \
  "C:/Xilinx/Vivado/2020.2/data/ip/xpm/xpm_memory/hdl/xpm_memory.sv" \
-endlib
-makelib ies_lib/xpm \
  "C:/Xilinx/Vivado/2020.2/data/ip/xpm/xpm_VCOMP.vhd" \
-endlib
-makelib ies_lib/sem_v4_1_13 \
  "../../../ipstatic/hdl/sem_v4_1_vl_rfs.v" \
-endlib
-makelib ies_lib/xil_defaultlib \
  "../../../ip/local_PR_test_01.srcs/sim/sem_0.v" \
-endlib
-makelib ies_lib/xil_defaultlib \
  glbl.v
-endlib

