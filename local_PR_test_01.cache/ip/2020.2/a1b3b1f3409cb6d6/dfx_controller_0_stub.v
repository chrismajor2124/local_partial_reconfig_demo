// Copyright 1986-2020 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2020.2 (win64) Build 3064766 Wed Nov 18 09:12:45 MST 2020
// Date        : Fri Apr 16 10:05:47 2021
// Host        : BZ-ECE-7F8ZR33 running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode synth_stub -rename_top decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix -prefix
//               decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_ dfx_controller_0_stub.v
// Design      : dfx_controller_0
// Purpose     : Stub declaration of top-level module interface
// Device      : xc7a35tcpg236-1
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
(* x_core_info = "dfx_controller_dfx_controller_0,Vivado 2020.2" *)
module decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix(m_axi_mem_araddr, m_axi_mem_arlen, 
  m_axi_mem_arsize, m_axi_mem_arburst, m_axi_mem_arprot, m_axi_mem_arcache, 
  m_axi_mem_aruser, m_axi_mem_arvalid, m_axi_mem_arready, m_axi_mem_rdata, m_axi_mem_rresp, 
  m_axi_mem_rlast, m_axi_mem_rvalid, m_axi_mem_rready, clk, reset, icap_clk, icap_reset, 
  icap_csib, icap_rdwrb, icap_i, icap_o, vsm_CNTR_0_hw_triggers, vsm_CNTR_0_rm_shutdown_req, 
  vsm_CNTR_0_rm_shutdown_ack, vsm_CNTR_0_rm_decouple, vsm_CNTR_0_rm_reset, 
  vsm_CNTR_0_event_error, cap_req, cap_gnt, cap_rel)
/* synthesis syn_black_box black_box_pad_pin="m_axi_mem_araddr[31:0],m_axi_mem_arlen[7:0],m_axi_mem_arsize[2:0],m_axi_mem_arburst[1:0],m_axi_mem_arprot[2:0],m_axi_mem_arcache[3:0],m_axi_mem_aruser[3:0],m_axi_mem_arvalid,m_axi_mem_arready,m_axi_mem_rdata[31:0],m_axi_mem_rresp[1:0],m_axi_mem_rlast,m_axi_mem_rvalid,m_axi_mem_rready,clk,reset,icap_clk,icap_reset,icap_csib,icap_rdwrb,icap_i[31:0],icap_o[31:0],vsm_CNTR_0_hw_triggers[1:0],vsm_CNTR_0_rm_shutdown_req,vsm_CNTR_0_rm_shutdown_ack,vsm_CNTR_0_rm_decouple,vsm_CNTR_0_rm_reset,vsm_CNTR_0_event_error,cap_req,cap_gnt,cap_rel" */;
  output [31:0]m_axi_mem_araddr;
  output [7:0]m_axi_mem_arlen;
  output [2:0]m_axi_mem_arsize;
  output [1:0]m_axi_mem_arburst;
  output [2:0]m_axi_mem_arprot;
  output [3:0]m_axi_mem_arcache;
  output [3:0]m_axi_mem_aruser;
  output m_axi_mem_arvalid;
  input m_axi_mem_arready;
  input [31:0]m_axi_mem_rdata;
  input [1:0]m_axi_mem_rresp;
  input m_axi_mem_rlast;
  input m_axi_mem_rvalid;
  output m_axi_mem_rready;
  input clk;
  input reset;
  input icap_clk;
  input icap_reset;
  output icap_csib;
  output icap_rdwrb;
  input [31:0]icap_i;
  output [31:0]icap_o;
  input [1:0]vsm_CNTR_0_hw_triggers;
  output vsm_CNTR_0_rm_shutdown_req;
  input vsm_CNTR_0_rm_shutdown_ack;
  output vsm_CNTR_0_rm_decouple;
  output vsm_CNTR_0_rm_reset;
  output vsm_CNTR_0_event_error;
  output cap_req;
  input cap_gnt;
  input cap_rel;
endmodule
