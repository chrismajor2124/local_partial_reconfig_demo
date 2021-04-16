# 
# Synthesis run script generated by Vivado
# 

set TIME_start [clock seconds] 
namespace eval ::optrace {
  variable script "D:/Xilinx/local_PR_test_01/local_PR_test_01.runs/synth_1/top.tcl"
  variable category "vivado_synth"
}

# Try to connect to running dispatch if we haven't done so already.
# This code assumes that the Tcl interpreter is not using threads,
# since the ::dispatch::connected variable isn't mutex protected.
if {![info exists ::dispatch::connected]} {
  namespace eval ::dispatch {
    variable connected false
    if {[llength [array get env XILINX_CD_CONNECT_ID]] > 0} {
      set result "true"
      if {[catch {
        if {[lsearch -exact [package names] DispatchTcl] < 0} {
          set result [load librdi_cd_clienttcl[info sharedlibextension]] 
        }
        if {$result eq "false"} {
          puts "WARNING: Could not load dispatch client library"
        }
        set connect_id [ ::dispatch::init_client -mode EXISTING_SERVER ]
        if { $connect_id eq "" } {
          puts "WARNING: Could not initialize dispatch client"
        } else {
          puts "INFO: Dispatch client connection id - $connect_id"
          set connected true
        }
      } catch_res]} {
        puts "WARNING: failed to connect to dispatch server - $catch_res"
      }
    }
  }
}
if {$::dispatch::connected} {
  # Remove the dummy proc if it exists.
  if { [expr {[llength [info procs ::OPTRACE]] > 0}] } {
    rename ::OPTRACE ""
  }
  proc ::OPTRACE { task action {tags {} } } {
    ::vitis_log::op_trace "$task" $action -tags $tags -script $::optrace::script -category $::optrace::category
  }
  # dispatch is generic. We specifically want to attach logging.
  ::vitis_log::connect_client
} else {
  # Add dummy proc if it doesn't exist.
  if { [expr {[llength [info procs ::OPTRACE]] == 0}] } {
    proc ::OPTRACE {{arg1 \"\" } {arg2 \"\"} {arg3 \"\" } {arg4 \"\"} {arg5 \"\" } {arg6 \"\"}} {
        # Do nothing
    }
  }
}

proc create_report { reportName command } {
  set status "."
  append status $reportName ".fail"
  if { [file exists $status] } {
    eval file delete [glob $status]
  }
  send_msg_id runtcl-4 info "Executing : $command"
  set retval [eval catch { $command } msg]
  if { $retval != 0 } {
    set fp [open $status w]
    close $fp
    send_msg_id runtcl-5 warning "$msg"
  }
}
OPTRACE "synth_1" START { ROLLUP_AUTO }
set_param chipscope.maxJobs 4
OPTRACE "Creating in-memory project" START { }
create_project -in_memory -part xc7a35tcpg236-1

set_param project.singleFileAddWarning.threshold 0
set_param project.compositeFile.enableAutoGeneration 0
set_param synth.vivado.isSynthRun true
set_msg_config -source 4 -id {IP_Flow 19-2162} -severity warning -new_severity info
set_property webtalk.parent_dir D:/Xilinx/local_PR_test_01/local_PR_test_01.cache/wt [current_project]
set_property parent.project_path D:/Xilinx/local_PR_test_01/local_PR_test_01.xpr [current_project]
set_property XPM_LIBRARIES {XPM_CDC XPM_FIFO XPM_MEMORY} [current_project]
set_property default_lib xil_defaultlib [current_project]
set_property target_language VHDL [current_project]
set_property ip_output_repo d:/Xilinx/local_PR_test_01/local_PR_test_01.cache/ip [current_project]
set_property ip_cache_permissions {read write} [current_project]
OPTRACE "Creating in-memory project" END { }
OPTRACE "Adding files" START { }
add_files D:/Xilinx/radpc-lunar/Lunar_Board_FPGA/radpc_vitis/radpc_app_01/Debug/radpc_app_01.elf
add_files D:/Xilinx/local_PR_test_01/pr_test_vitis/PR_Test_01/Debug/PR_Test_01.elf
set_property SCOPED_TO_REF mb_pr_01 [get_files -all D:/Xilinx/local_PR_test_01/pr_test_vitis/PR_Test_01/Debug/PR_Test_01.elf]
set_property SCOPED_TO_CELLS microblaze_0 [get_files -all D:/Xilinx/local_PR_test_01/pr_test_vitis/PR_Test_01/Debug/PR_Test_01.elf]
read_vhdl -library xil_defaultlib {
  D:/Xilinx/local_PR_test_01/local_PR_test_01.srcs/arbiter.vhd
  D:/Xilinx/local_PR_test_01/local_PR_test_01.srcs/basys_7seg_display.vhd
  D:/Xilinx/local_PR_test_01/local_PR_test_01.srcs/general_counter.vhd
  D:/local_PR_test_01.gen/sources_1/bd/mb_pr_01/hdl/mb_pr_01_wrapper.vhd
  D:/Xilinx/local_PR_test_01/local_PR_test_01.srcs/reconfiguration.vhd
  D:/Xilinx/local_PR_test_01/local_PR_test_01.srcs/sem_0_sem_mon.vhd
  D:/Xilinx/local_PR_test_01/local_PR_test_01.srcs/sem_0_sem_mon_fifo.vhd
  D:/Xilinx/local_PR_test_01/local_PR_test_01.srcs/sem_0_sem_mon_piso.vhd
  D:/Xilinx/local_PR_test_01/local_PR_test_01.srcs/sem_0_sem_mon_sipo.vhd
  D:/Xilinx/local_PR_test_01/local_PR_test_01.srcs/top.vhd
}
read_ip -quiet D:/Xilinx/local_PR_test_01/local_PR_test_01.srcs/sem_0.xci
set_property used_in_implementation false [get_files -all d:/Xilinx/local_PR_test_01/local_PR_test_01.srcs/synth/sem_0_ooc.xdc]

add_files D:/Xilinx/local_PR_test_01/local_PR_test_01.srcs/mb_pr_01/mb_pr_01.bd
set_property used_in_implementation false [get_files -all d:/local_PR_test_01.gen/sources_1/bd/mb_pr_01/ip/mb_pr_01_axi_hwicap_0_0/mb_pr_01_axi_hwicap_0_0.xdc]
set_property used_in_implementation false [get_files -all d:/local_PR_test_01.gen/sources_1/bd/mb_pr_01/ip/mb_pr_01_axi_hwicap_0_0/mb_pr_01_axi_hwicap_0_0_clocks.xdc]
set_property used_in_implementation false [get_files -all d:/local_PR_test_01.gen/sources_1/bd/mb_pr_01/ip/mb_pr_01_axi_hwicap_0_0/mb_pr_01_axi_hwicap_0_0_ooc.xdc]
set_property used_in_implementation false [get_files -all d:/local_PR_test_01.gen/sources_1/bd/mb_pr_01/ip/mb_pr_01_microblaze_0_0/mb_pr_01_microblaze_0_0.xdc]
set_property used_in_implementation false [get_files -all d:/local_PR_test_01.gen/sources_1/bd/mb_pr_01/ip/mb_pr_01_microblaze_0_0/mb_pr_01_microblaze_0_0_ooc_debug.xdc]
set_property used_in_implementation false [get_files -all d:/local_PR_test_01.gen/sources_1/bd/mb_pr_01/ip/mb_pr_01_microblaze_0_0/mb_pr_01_microblaze_0_0_ooc.xdc]
set_property used_in_implementation false [get_files -all d:/local_PR_test_01.gen/sources_1/bd/mb_pr_01/ip/mb_pr_01_axi_uartlite_0_0/mb_pr_01_axi_uartlite_0_0_board.xdc]
set_property used_in_implementation false [get_files -all d:/local_PR_test_01.gen/sources_1/bd/mb_pr_01/ip/mb_pr_01_axi_uartlite_0_0/mb_pr_01_axi_uartlite_0_0_ooc.xdc]
set_property used_in_implementation false [get_files -all d:/local_PR_test_01.gen/sources_1/bd/mb_pr_01/ip/mb_pr_01_axi_uartlite_0_0/mb_pr_01_axi_uartlite_0_0.xdc]
set_property used_in_implementation false [get_files -all d:/local_PR_test_01.gen/sources_1/bd/mb_pr_01/ip/mb_pr_01_mdm_0_0/mb_pr_01_mdm_0_0.xdc]
set_property used_in_implementation false [get_files -all d:/local_PR_test_01.gen/sources_1/bd/mb_pr_01/ip/mb_pr_01_mdm_0_0/mb_pr_01_mdm_0_0_ooc_trace.xdc]
set_property used_in_implementation false [get_files -all d:/local_PR_test_01.gen/sources_1/bd/mb_pr_01/ip/mb_pr_01_dlmb_v10_0/mb_pr_01_dlmb_v10_0_ooc.xdc]
set_property used_in_implementation false [get_files -all d:/local_PR_test_01.gen/sources_1/bd/mb_pr_01/ip/mb_pr_01_ilmb_v10_0/mb_pr_01_ilmb_v10_0_ooc.xdc]
set_property used_in_implementation false [get_files -all d:/local_PR_test_01.gen/sources_1/bd/mb_pr_01/ip/mb_pr_01_dlmb_bram_if_cntlr_0/mb_pr_01_dlmb_bram_if_cntlr_0_ooc.xdc]
set_property used_in_implementation false [get_files -all d:/local_PR_test_01.gen/sources_1/bd/mb_pr_01/ip/mb_pr_01_ilmb_bram_if_cntlr_0/mb_pr_01_ilmb_bram_if_cntlr_0_ooc.xdc]
set_property used_in_implementation false [get_files -all d:/local_PR_test_01.gen/sources_1/bd/mb_pr_01/ip/mb_pr_01_lmb_bram_0/mb_pr_01_lmb_bram_0_ooc.xdc]
set_property used_in_implementation false [get_files -all d:/local_PR_test_01.gen/sources_1/bd/mb_pr_01/ip/mb_pr_01_rst_clk_wiz_1_100M_0/mb_pr_01_rst_clk_wiz_1_100M_0_board.xdc]
set_property used_in_implementation false [get_files -all d:/local_PR_test_01.gen/sources_1/bd/mb_pr_01/ip/mb_pr_01_rst_clk_wiz_1_100M_0/mb_pr_01_rst_clk_wiz_1_100M_0.xdc]
set_property used_in_implementation false [get_files -all d:/local_PR_test_01.gen/sources_1/bd/mb_pr_01/ip/mb_pr_01_rst_clk_wiz_1_100M_0/mb_pr_01_rst_clk_wiz_1_100M_0_ooc.xdc]
set_property used_in_implementation false [get_files -all d:/local_PR_test_01.gen/sources_1/bd/mb_pr_01/ip/mb_pr_01_xbar_0/mb_pr_01_xbar_0_ooc.xdc]
set_property used_in_implementation false [get_files -all d:/local_PR_test_01.gen/sources_1/bd/mb_pr_01/ip/mb_pr_01_axi_quad_spi_0_0/mb_pr_01_axi_quad_spi_0_0_board.xdc]
set_property used_in_implementation false [get_files -all d:/local_PR_test_01.gen/sources_1/bd/mb_pr_01/ip/mb_pr_01_axi_quad_spi_0_0/mb_pr_01_axi_quad_spi_0_0.xdc]
set_property used_in_implementation false [get_files -all d:/local_PR_test_01.gen/sources_1/bd/mb_pr_01/ip/mb_pr_01_axi_quad_spi_0_0/mb_pr_01_axi_quad_spi_0_0_ooc.xdc]
set_property used_in_implementation false [get_files -all d:/local_PR_test_01.gen/sources_1/bd/mb_pr_01/ip/mb_pr_01_axi_quad_spi_0_0/mb_pr_01_axi_quad_spi_0_0_clocks.xdc]
set_property used_in_implementation false [get_files -all d:/local_PR_test_01.gen/sources_1/bd/mb_pr_01/ip/mb_pr_01_axi_gpio_0_0/mb_pr_01_axi_gpio_0_0_board.xdc]
set_property used_in_implementation false [get_files -all d:/local_PR_test_01.gen/sources_1/bd/mb_pr_01/ip/mb_pr_01_axi_gpio_0_0/mb_pr_01_axi_gpio_0_0_ooc.xdc]
set_property used_in_implementation false [get_files -all d:/local_PR_test_01.gen/sources_1/bd/mb_pr_01/ip/mb_pr_01_axi_gpio_0_0/mb_pr_01_axi_gpio_0_0.xdc]
set_property used_in_implementation false [get_files -all d:/local_PR_test_01.gen/sources_1/bd/mb_pr_01/ip/mb_pr_01_axi_gpio_1_0/mb_pr_01_axi_gpio_1_0_board.xdc]
set_property used_in_implementation false [get_files -all d:/local_PR_test_01.gen/sources_1/bd/mb_pr_01/ip/mb_pr_01_axi_gpio_1_0/mb_pr_01_axi_gpio_1_0_ooc.xdc]
set_property used_in_implementation false [get_files -all d:/local_PR_test_01.gen/sources_1/bd/mb_pr_01/ip/mb_pr_01_axi_gpio_1_0/mb_pr_01_axi_gpio_1_0.xdc]
set_property used_in_implementation false [get_files -all d:/local_PR_test_01.gen/sources_1/bd/mb_pr_01/mb_pr_01_ooc.xdc]
set_property used_in_implementation false [get_files -all d:/local_PR_test_01.gen/sources_1/bd/mb_pr_01/ip/mb_pr_01_microblaze_0_0/data/mb_bootloop_le.elf]

read_ip -quiet D:/Xilinx/local_PR_test_01/local_PR_test_01.srcs/sources_1/ip/clk_wiz_0/clk_wiz_0.xci
set_property used_in_implementation false [get_files -all d:/Xilinx/local_PR_test_01/local_PR_test_01.srcs/sources_1/ip/clk_wiz_0/clk_wiz_0_board.xdc]
set_property used_in_implementation false [get_files -all d:/Xilinx/local_PR_test_01/local_PR_test_01.srcs/sources_1/ip/clk_wiz_0/clk_wiz_0.xdc]
set_property used_in_implementation false [get_files -all d:/Xilinx/local_PR_test_01/local_PR_test_01.srcs/sources_1/ip/clk_wiz_0/clk_wiz_0_ooc.xdc]

OPTRACE "Adding files" END { }
# Mark all dcp files as not used in implementation to prevent them from being
# stitched into the results of this synthesis run. Any black boxes in the
# design are intentionally left as such for best results. Dcp files will be
# stitched into the design at a later time, either when this synthesis run is
# opened, or when it is stitched into a dependent implementation run.
foreach dcp [get_files -quiet -all -filter file_type=="Design\ Checkpoint"] {
  set_property used_in_implementation false $dcp
}
read_xdc D:/Xilinx/local_PR_test_01/local_PR_test_01.srcs/constraints.xdc
set_property used_in_implementation false [get_files D:/Xilinx/local_PR_test_01/local_PR_test_01.srcs/constraints.xdc]

read_xdc dont_touch.xdc
set_property used_in_implementation false [get_files dont_touch.xdc]
set_param ips.enableIPCacheLiteLoad 1
close [open __synthesis_is_running__ w]

OPTRACE "synth_design" START { }
synth_design -top top -part xc7a35tcpg236-1
OPTRACE "synth_design" END { }
if { [get_msg_config -count -severity {CRITICAL WARNING}] > 0 } {
 send_msg_id runtcl-6 info "Synthesis results are not added to the cache due to CRITICAL_WARNING"
}


OPTRACE "write_checkpoint" START { CHECKPOINT }
# disable binary constraint mode for synth run checkpoints
set_param constraints.enableBinaryConstraints false
write_checkpoint -force -noxdef top.dcp
OPTRACE "write_checkpoint" END { }
OPTRACE "synth reports" START { REPORT }
create_report "synth_1_synth_report_utilization_0" "report_utilization -file top_utilization_synth.rpt -pb top_utilization_synth.pb"
OPTRACE "synth reports" END { }
file delete __synthesis_is_running__
close [open __synthesis_is_complete__ w]
OPTRACE "synth_1" END { }