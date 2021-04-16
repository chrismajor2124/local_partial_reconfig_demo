## OTHER LINES
##-------------------------------------------------------------------------------------------------------------------------------

# Set the Essential Bits reporting in the design
set_property BITSTREAM.SEU.ESSENTIALBITS yes [current_design]


## PINS
##-------------------------------------------------------------------------------------------------------------------------------

# i_clk_100_MHz - Clock
# Set IO standard voltage and pins for the clock signal
set_property -dict {PACKAGE_PIN W5 IOSTANDARD LVCMOS33} [get_ports i_clk]

# i_act_high_reset - Reset
# Set IO standard voltage and pins for the center button of the Basys
# (Often used as a reset, feed through an inverter to make active low)
set_property -dict {PACKAGE_PIN U18 IOSTANDARD LVCMOS33} [get_ports i_reset]

# o_led - LEDs
# Set IO standard voltage and pins for the LED outputs
set_property -dict {PACKAGE_PIN L1 IOSTANDARD LVCMOS33} [get_ports {o_led[15]}]
set_property -dict {PACKAGE_PIN P1 IOSTANDARD LVCMOS33} [get_ports {o_led[14]}]
set_property -dict {PACKAGE_PIN N3 IOSTANDARD LVCMOS33} [get_ports {o_led[13]}]
set_property -dict {PACKAGE_PIN P3 IOSTANDARD LVCMOS33} [get_ports {o_led[12]}]
set_property -dict {PACKAGE_PIN U3 IOSTANDARD LVCMOS33} [get_ports {o_led[11]}]
set_property -dict {PACKAGE_PIN W3 IOSTANDARD LVCMOS33} [get_ports {o_led[10]}]
set_property -dict {PACKAGE_PIN V3 IOSTANDARD LVCMOS33} [get_ports {o_led[9]}]
set_property -dict {PACKAGE_PIN V13 IOSTANDARD LVCMOS33} [get_ports {o_led[8]}]
set_property -dict {PACKAGE_PIN V14 IOSTANDARD LVCMOS33} [get_ports {o_led[7]}]
set_property -dict {PACKAGE_PIN U14 IOSTANDARD LVCMOS33} [get_ports {o_led[6]}]
set_property -dict {PACKAGE_PIN U15 IOSTANDARD LVCMOS33} [get_ports {o_led[5]}]
set_property -dict {PACKAGE_PIN W18 IOSTANDARD LVCMOS33} [get_ports {o_led[4]}]
set_property -dict {PACKAGE_PIN V19 IOSTANDARD LVCMOS33} [get_ports {o_led[3]}]
set_property -dict {PACKAGE_PIN U19 IOSTANDARD LVCMOS33} [get_ports {o_led[2]}]
set_property -dict {PACKAGE_PIN E19 IOSTANDARD LVCMOS33} [get_ports {o_led[1]}]
set_property -dict {PACKAGE_PIN U16 IOSTANDARD LVCMOS33} [get_ports {o_led[0]}]


# Set IO standard voltage and pins for o_seven_seg_anode
set_property -dict {PACKAGE_PIN W4 IOSTANDARD LVCMOS33} [get_ports {o_seven_seg_anode[3]}]
set_property -dict {PACKAGE_PIN V4 IOSTANDARD LVCMOS33} [get_ports {o_seven_seg_anode[2]}]
set_property -dict {PACKAGE_PIN U4 IOSTANDARD LVCMOS33} [get_ports {o_seven_seg_anode[1]}]
set_property -dict {PACKAGE_PIN U2 IOSTANDARD LVCMOS33} [get_ports {o_seven_seg_anode[0]}]


# Set IO standard voltage and pins for o_seven_seg_data
set_property -dict {PACKAGE_PIN W7 IOSTANDARD LVCMOS33} [get_ports {o_seven_seg_data[7]}]
set_property -dict {PACKAGE_PIN W6 IOSTANDARD LVCMOS33} [get_ports {o_seven_seg_data[6]}]
set_property -dict {PACKAGE_PIN U8 IOSTANDARD LVCMOS33} [get_ports {o_seven_seg_data[5]}]
set_property -dict {PACKAGE_PIN V8 IOSTANDARD LVCMOS33} [get_ports {o_seven_seg_data[4]}]
set_property -dict {PACKAGE_PIN U5 IOSTANDARD LVCMOS33} [get_ports {o_seven_seg_data[3]}]
set_property -dict {PACKAGE_PIN V5 IOSTANDARD LVCMOS33} [get_ports {o_seven_seg_data[2]}]
set_property -dict {PACKAGE_PIN U7 IOSTANDARD LVCMOS33} [get_ports {o_seven_seg_data[1]}]
set_property -dict {PACKAGE_PIN V7 IOSTANDARD LVCMOS33} [get_ports {o_seven_seg_data[0]}]


# Set IO standard voltage and pins for o_pmod_ja
set_property -dict {PACKAGE_PIN G3 IOSTANDARD LVCMOS33} [get_ports {o_pmod_ja[7]}]
set_property -dict {PACKAGE_PIN H2 IOSTANDARD LVCMOS33} [get_ports {o_pmod_ja[6]}]
set_property -dict {PACKAGE_PIN K2 IOSTANDARD LVCMOS33} [get_ports {o_pmod_ja[5]}]
set_property -dict {PACKAGE_PIN H1 IOSTANDARD LVCMOS33} [get_ports {o_pmod_ja[4]}]
set_property -dict {PACKAGE_PIN G2 IOSTANDARD LVCMOS33} [get_ports {o_pmod_ja[3]}]
set_property -dict {PACKAGE_PIN J2 IOSTANDARD LVCMOS33} [get_ports {o_pmod_ja[2]}]
set_property -dict {PACKAGE_PIN L2 IOSTANDARD LVCMOS33} [get_ports {o_pmod_ja[1]}]
set_property -dict {PACKAGE_PIN J1 IOSTANDARD LVCMOS33} [get_ports {o_pmod_ja[0]}]


# Set IO standard voltage and pins for o_pmod_jb
set_property -dict {PACKAGE_PIN C16 IOSTANDARD LVCMOS33} [get_ports {o_pmod_jb[7]}]
set_property -dict {PACKAGE_PIN C15 IOSTANDARD LVCMOS33} [get_ports {o_pmod_jb[6]}]
set_property -dict {PACKAGE_PIN A17 IOSTANDARD LVCMOS33} [get_ports {o_pmod_jb[5]}]
set_property -dict {PACKAGE_PIN A15 IOSTANDARD LVCMOS33} [get_ports {o_pmod_jb[4]}]
set_property -dict {PACKAGE_PIN B16 IOSTANDARD LVCMOS33} [get_ports {o_pmod_jb[3]}]
set_property -dict {PACKAGE_PIN B15 IOSTANDARD LVCMOS33} [get_ports {o_pmod_jb[2]}]
set_property -dict {PACKAGE_PIN A16 IOSTANDARD LVCMOS33} [get_ports {o_pmod_jb[1]}]
set_property -dict {PACKAGE_PIN A14 IOSTANDARD LVCMOS33} [get_ports {o_pmod_jb[0]}]


# Set IO standard voltage and pins for o_pmod_jc
set_property -dict {PACKAGE_PIN R18 IOSTANDARD LVCMOS33} [get_ports {o_pmod_jc[7]}]
set_property -dict {PACKAGE_PIN P17 IOSTANDARD LVCMOS33} [get_ports {o_pmod_jc[6]}]
set_property -dict {PACKAGE_PIN M19 IOSTANDARD LVCMOS33} [get_ports {o_pmod_jc[5]}]
set_property -dict {PACKAGE_PIN L17 IOSTANDARD LVCMOS33} [get_ports {o_pmod_jc[4]}]
set_property -dict {PACKAGE_PIN P18 IOSTANDARD LVCMOS33} [get_ports {o_pmod_jc[3]}]
set_property -dict {PACKAGE_PIN N17 IOSTANDARD LVCMOS33} [get_ports {o_pmod_jc[2]}]
set_property -dict {PACKAGE_PIN M18 IOSTANDARD LVCMOS33} [get_ports {o_pmod_jc[1]}]
set_property -dict {PACKAGE_PIN K17 IOSTANDARD LVCMOS33} [get_ports {o_pmod_jc[0]}]


# Set IO standard voltage and pins for i_switch
set_property -dict {PACKAGE_PIN R2 IOSTANDARD LVCMOS33} [get_ports {i_switch[15]}]
set_property -dict {PACKAGE_PIN T1 IOSTANDARD LVCMOS33} [get_ports {i_switch[14]}]
set_property -dict {PACKAGE_PIN U1 IOSTANDARD LVCMOS33} [get_ports {i_switch[13]}]
set_property -dict {PACKAGE_PIN W2 IOSTANDARD LVCMOS33} [get_ports {i_switch[12]}]
set_property -dict {PACKAGE_PIN R3 IOSTANDARD LVCMOS33} [get_ports {i_switch[11]}]
set_property -dict {PACKAGE_PIN T2 IOSTANDARD LVCMOS33} [get_ports {i_switch[10]}]
set_property -dict {PACKAGE_PIN T3 IOSTANDARD LVCMOS33} [get_ports {i_switch[9]}]
set_property -dict {PACKAGE_PIN V2 IOSTANDARD LVCMOS33} [get_ports {i_switch[8]}]
set_property -dict {PACKAGE_PIN W13 IOSTANDARD LVCMOS33} [get_ports {i_switch[7]}]
set_property -dict {PACKAGE_PIN W14 IOSTANDARD LVCMOS33} [get_ports {i_switch[6]}]
set_property -dict {PACKAGE_PIN V15 IOSTANDARD LVCMOS33} [get_ports {i_switch[5]}]
set_property -dict {PACKAGE_PIN W15 IOSTANDARD LVCMOS33} [get_ports {i_switch[4]}]
set_property -dict {PACKAGE_PIN W17 IOSTANDARD LVCMOS33} [get_ports {i_switch[3]}]
set_property -dict {PACKAGE_PIN W16 IOSTANDARD LVCMOS33} [get_ports {i_switch[2]}]
set_property -dict {PACKAGE_PIN V16 IOSTANDARD LVCMOS33} [get_ports {i_switch[1]}]
set_property -dict {PACKAGE_PIN V17 IOSTANDARD LVCMOS33} [get_ports {i_switch[0]}]


# i_rx - UART Receive
# Set IO standard voltage and pins for the RX
set_property -dict {PACKAGE_PIN B18 IOSTANDARD LVCMOS33} [get_ports i_rx]

# o_tx - UART Transmit
# Set IO standard voltage and pins for the TX
set_property -dict {PACKAGE_PIN A18 IOSTANDARD LVCMOS33} [get_ports o_tx]


## PBlocks
##-------------------------------------------------------------------------------------------------------------------------------
set_property HD.RECONFIGURABLE true [get_cells CNTR]
create_pblock pblock_cntr
add_cells_to_pblock [get_pblocks pblock_cntr] [get_cells -quiet [list CNTR]]
resize_pblock [get_pblocks pblock_cntr] -add {SLICE_X0Y0:SLICE_X3Y5}
set_property RESET_AFTER_RECONFIG true [get_pblocks pblock_cntr]
set_property SNAPPING_MODE ON [get_pblocks pblock_cntr]

create_pblock RECONF
add_cells_to_pblock [get_pblocks RECONF] [get_cells -quiet [list RECON_01]]
resize_pblock [get_pblocks RECONF] -add {SLICE_X38Y0:SLICE_X65Y99}
resize_pblock [get_pblocks RECONF] -add {DSP48_X1Y0:DSP48_X1Y39}
resize_pblock [get_pblocks RECONF] -add {RAMB18_X1Y0:RAMB18_X2Y39}
resize_pblock [get_pblocks RECONF] -add {RAMB36_X1Y0:RAMB36_X2Y19}





