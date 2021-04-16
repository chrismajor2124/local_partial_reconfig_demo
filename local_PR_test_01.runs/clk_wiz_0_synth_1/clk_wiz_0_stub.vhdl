-- Copyright 1986-2020 Xilinx, Inc. All Rights Reserved.
-- --------------------------------------------------------------------------------
-- Tool Version: Vivado v.2020.2 (win64) Build 3064766 Wed Nov 18 09:12:45 MST 2020
-- Date        : Tue Apr 13 16:50:00 2021
-- Host        : BZ-ECE-7F8ZR33 running 64-bit major release  (build 9200)
-- Command     : write_vhdl -force -mode synth_stub
--               D:/Xilinx/local_PR_test_01/local_PR_test_01.runs/clk_wiz_0_synth_1/clk_wiz_0_stub.vhdl
-- Design      : clk_wiz_0
-- Purpose     : Stub declaration of top-level module interface
-- Device      : xc7a35tcpg236-1
-- --------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity clk_wiz_0 is
  Port ( 
    o_clk_16MHz : out STD_LOGIC;
    o_clk_8MHz : out STD_LOGIC;
    resetn : in STD_LOGIC;
    locked : out STD_LOGIC;
    i_clk_100MHz : in STD_LOGIC
  );

end clk_wiz_0;

architecture stub of clk_wiz_0 is
attribute syn_black_box : boolean;
attribute black_box_pad_pin : string;
attribute syn_black_box of stub : architecture is true;
attribute black_box_pad_pin of stub : architecture is "o_clk_16MHz,o_clk_8MHz,resetn,locked,i_clk_100MHz";
begin
end;
