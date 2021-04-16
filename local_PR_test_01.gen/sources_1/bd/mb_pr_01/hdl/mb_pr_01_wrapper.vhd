--Copyright 1986-2020 Xilinx, Inc. All Rights Reserved.
----------------------------------------------------------------------------------
--Tool Version: Vivado v.2020.2 (win64) Build 3064766 Wed Nov 18 09:12:45 MST 2020
--Date        : Tue Mar 16 16:02:23 2021
--Host        : BZ-ECE-7F8ZR33 running 64-bit major release  (build 9200)
--Command     : generate_target mb_pr_01_wrapper.bd
--Design      : mb_pr_01_wrapper
--Purpose     : IP block netlist
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;
entity mb_pr_01_wrapper is
  port (
    i_clk_100MHz : in STD_LOGIC;
    i_reset : in STD_LOGIC;
    o_clk_100MHz : out STD_LOGIC;
    uart_rtl_0_rxd : in STD_LOGIC;
    uart_rtl_0_txd : out STD_LOGIC
  );
end mb_pr_01_wrapper;

architecture STRUCTURE of mb_pr_01_wrapper is
  component mb_pr_01 is
  port (
    i_reset : in STD_LOGIC;
    i_clk_100MHz : in STD_LOGIC;
    o_clk_100MHz : out STD_LOGIC;
    uart_rtl_0_rxd : in STD_LOGIC;
    uart_rtl_0_txd : out STD_LOGIC
  );
  end component mb_pr_01;
begin
mb_pr_01_i: component mb_pr_01
     port map (
      i_clk_100MHz => i_clk_100MHz,
      i_reset => i_reset,
      o_clk_100MHz => o_clk_100MHz,
      uart_rtl_0_rxd => uart_rtl_0_rxd,
      uart_rtl_0_txd => uart_rtl_0_txd
    );
end STRUCTURE;
