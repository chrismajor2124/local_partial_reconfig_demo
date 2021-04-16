// Copyright 1986-2020 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2020.2 (win64) Build 3064766 Wed Nov 18 09:12:45 MST 2020
// Date        : Tue Apr 13 16:50:00 2021
// Host        : BZ-ECE-7F8ZR33 running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode synth_stub
//               D:/Xilinx/local_PR_test_01/local_PR_test_01.runs/clk_wiz_0_synth_1/clk_wiz_0_stub.v
// Design      : clk_wiz_0
// Purpose     : Stub declaration of top-level module interface
// Device      : xc7a35tcpg236-1
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
module clk_wiz_0(o_clk_16MHz, o_clk_8MHz, resetn, locked, 
  i_clk_100MHz)
/* synthesis syn_black_box black_box_pad_pin="o_clk_16MHz,o_clk_8MHz,resetn,locked,i_clk_100MHz" */;
  output o_clk_16MHz;
  output o_clk_8MHz;
  input resetn;
  output locked;
  input i_clk_100MHz;
endmodule
