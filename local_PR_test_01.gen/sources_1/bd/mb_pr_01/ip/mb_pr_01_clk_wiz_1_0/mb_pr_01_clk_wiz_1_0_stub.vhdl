-- Copyright 1986-2020 Xilinx, Inc. All Rights Reserved.
-- --------------------------------------------------------------------------------
-- Tool Version: Vivado v.2020.2 (win64) Build 3064766 Wed Nov 18 09:12:45 MST 2020
-- Date        : Mon Mar 15 17:29:38 2021
-- Host        : BZ-ECE-7F8ZR33 running 64-bit major release  (build 9200)
-- Command     : write_vhdl -force -mode synth_stub
--               d:/Xilinx/local_PR_test_01/local_PR_test_01.gen/sources_1/bd/mb_pr_01/ip/mb_pr_01_clk_wiz_1_0/mb_pr_01_clk_wiz_1_0_stub.vhdl
-- Design      : mb_pr_01_clk_wiz_1_0
-- Purpose     : Stub declaration of top-level module interface
-- Device      : xc7a35tcpg236-1
-- --------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity mb_pr_01_clk_wiz_1_0 is
  Port ( 
    o_clk_100MHz : out STD_LOGIC;
    reset : in STD_LOGIC;
    locked : out STD_LOGIC;
    clk_in1 : in STD_LOGIC
  );

end mb_pr_01_clk_wiz_1_0;

architecture stub of mb_pr_01_clk_wiz_1_0 is
attribute syn_black_box : boolean;
attribute black_box_pad_pin : string;
attribute syn_black_box of stub : architecture is true;
attribute black_box_pad_pin of stub : architecture is "o_clk_100MHz,reset,locked,clk_in1";
begin
end;
