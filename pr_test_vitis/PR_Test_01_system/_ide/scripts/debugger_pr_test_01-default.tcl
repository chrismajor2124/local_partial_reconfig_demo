# Usage with Vitis IDE:
# In Vitis IDE create a Single Application Debug launch configuration,
# change the debug type to 'Attach to running target' and provide this 
# tcl script in 'Execute Script' option.
# Path of this script: D:\Xilinx\local_PR_test_01\pr_test_vitis\PR_Test_01_system\_ide\scripts\debugger_pr_test_01-default.tcl
# 
# 
# Usage with xsct:
# To debug using xsct, launch xsct and run below command
# source D:\Xilinx\local_PR_test_01\pr_test_vitis\PR_Test_01_system\_ide\scripts\debugger_pr_test_01-default.tcl
# 
connect -url tcp:127.0.0.1:3121
targets -set -filter {jtag_cable_name =~ "Digilent Basys3 210183AB3E62A" && level==0 && jtag_device_ctx=="jsn-Basys3-210183AB3E62A-0362d093-0"}
fpga -file D:/Xilinx/local_PR_test_01/pr_test_vitis/PR_Test_01/_ide/bitstream/top.bit
targets -set -nocase -filter {name =~ "*microblaze*#0" && bscan=="USER2" }
loadhw -hw D:/Xilinx/local_PR_test_01/pr_test_vitis/top/export/top/hw/top.xsa -regs
configparams mdm-detect-bscan-mask 2
targets -set -nocase -filter {name =~ "*microblaze*#0" && bscan=="USER2" }
rst -system
after 3000
targets -set -nocase -filter {name =~ "*microblaze*#0" && bscan=="USER2" }
dow D:/Xilinx/local_PR_test_01/pr_test_vitis/PR_Test_01/Debug/PR_Test_01.elf
bpadd -addr &main
