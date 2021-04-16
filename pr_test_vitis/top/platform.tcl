# 
# Usage: To re-create this platform project launch xsct with below options.
# xsct D:\Xilinx\local_PR_test_01\pr_test_vitis\top\platform.tcl
# 
# OR launch xsct and run below command.
# source D:\Xilinx\local_PR_test_01\pr_test_vitis\top\platform.tcl
# 
# To create the platform in a different location, modify the -out option of "platform create" command.
# -out option specifies the output directory of the platform project.

platform create -name {top}\
-hw {D:\Xilinx\local_PR_test_01\top.xsa}\
-fsbl-target {psu_cortexa53_0} -out {D:/Xilinx/local_PR_test_01/pr_test_vitis}

platform write
domain create -name {standalone_microblaze_0} -display-name {standalone_microblaze_0} -os {standalone} -proc {microblaze_0} -runtime {cpp} -arch {32-bit} -support-app {hello_world}
platform generate -domains 
platform active {top}
platform generate -quick
platform generate
platform config -updatehw {D:/Xilinx/local_PR_test_01/top.xsa}
platform generate -domains 
platform generate
platform active {top}
platform config -updatehw {D:/Xilinx/local_PR_test_01/top.xsa}
platform generate -domains 
platform active {top}
platform config -updatehw {D:/Xilinx/local_PR_test_01/top.xsa}
platform generate -domains 
platform config -updatehw {D:/Xilinx/local_PR_test_01/top.xsa}
platform generate -domains 
platform config -updatehw {D:/Xilinx/local_PR_test_01/top.xsa}
platform generate -domains 
platform config -updatehw {D:/Xilinx/local_PR_test_01/top.xsa}
platform generate -domains 
platform active {top}
platform config -updatehw {D:/Xilinx/local_PR_test_01/top.xsa}
platform generate -domains 
platform active {top}
platform config -updatehw {D:/Xilinx/local_PR_test_01/top.xsa}
platform generate -domains 
platform config -updatehw {D:/Xilinx/local_PR_test_01/top.xsa}
platform clean
platform clean
platform clean
platform generate
platform clean
platform clean
platform config -updatehw {D:/Xilinx/local_PR_test_01/top.xsa}
platform generate
platform config -updatehw {D:/Xilinx/local_PR_test_01/top.xsa}
platform generate -domains 
platform config -updatehw {D:/Xilinx/local_PR_test_01/top.xsa}
platform clean
platform clean
platform generate
platform config -updatehw {D:/Xilinx/local_PR_test_01/top.xsa}
platform clean
platform generate
platform config -updatehw {D:/Xilinx/local_PR_test_01/top.xsa}
platform clean
platform generate
platform config -updatehw {D:/Xilinx/local_PR_test_01/top.xsa}
platform generate -domains 
platform config -updatehw {D:/Xilinx/local_PR_test_01/top.xsa}
platform generate -domains 
platform active {top}
platform config -updatehw {D:/Xilinx/local_PR_test_01/top.xsa}
platform generate -domains 
platform config -updatehw {D:/Xilinx/local_PR_test_01/top.xsa}
platform clean
platform generate
platform config -updatehw {D:/Xilinx/local_PR_test_01/top.xsa}
platform clean
platform generate
platform config -updatehw {D:/Xilinx/local_PR_test_01/top.xsa}
platform clean
platform generate
platform config -updatehw {D:/Xilinx/local_PR_test_01/top.xsa}
platform generate -domains 
platform clean
platform generate
platform config -updatehw {D:/Xilinx/local_PR_test_01/top.xsa}
platform clean
platform generate
platform active {top}
platform config -updatehw {D:/Xilinx/local_PR_test_01/top.xsa}
platform generate -domains 
platform config -updatehw {D:/Xilinx/local_PR_test_01/top.xsa}
platform config -updatehw {D:/Xilinx/local_PR_test_01/top.xsa}
platform generate -domains 
platform active {top}
platform config -updatehw {D:/Xilinx/local_PR_test_01/top.xsa}
platform generate -domains standalone_microblaze_0 
platform clean
platform generate
platform config -updatehw {D:/Xilinx/local_PR_test_01/top.xsa}
platform generate -domains 
platform config -updatehw {D:/Xilinx/local_PR_test_01/top.xsa}
platform generate -domains 
platform active {top}
platform config -updatehw {D:/Xilinx/local_PR_test_01/top.xsa}
platform config -updatehw {D:/Xilinx/local_PR_test_01/top.xsa}
platform clean
platform generate
platform config -updatehw {D:/Xilinx/local_PR_test_01/top.xsa}
platform clean
platform generate
platform config -updatehw {D:/Xilinx/local_PR_test_01/top.xsa}
platform generate -domains 
platform config -updatehw {D:/Xilinx/local_PR_test_01/top.xsa}
platform generate -domains 
platform config -updatehw {D:/Xilinx/local_PR_test_01/top.xsa}
platform generate -domains 
platform config -updatehw {D:/Xilinx/local_PR_test_01/top.xsa}
platform generate -domains 
platform config -updatehw {D:/Xilinx/local_PR_test_01/top.xsa}
platform generate -domains 
platform config -updatehw {D:/Xilinx/local_PR_test_01/top.xsa}
platform clean
platform generate
platform active {top}
platform config -updatehw {D:/Xilinx/local_PR_test_01/top.xsa}
platform generate -domains 
platform config -updatehw {D:/Xilinx/local_PR_test_01/top.xsa}
platform generate -domains 
platform config -updatehw {D:/Xilinx/local_PR_test_01/top.xsa}
platform generate -domains 
platform config -updatehw {D:/Xilinx/local_PR_test_01/top.xsa}
platform generate -domains 
platform config -updatehw {D:/Xilinx/local_PR_test_01/top.xsa}
platform clean
platform generate
platform config -updatehw {D:/Xilinx/local_PR_test_01/top.xsa}
platform clean
platform generate
platform active {top}
platform config -updatehw {D:/Xilinx/local_PR_test_01/top.xsa}
platform generate -domains 
platform clean
platform clean
platform generate
platform config -updatehw {D:/Xilinx/local_PR_test_01/top.xsa}
platform generate -domains 
platform clean
platform config -updatehw {D:/Xilinx/local_PR_test_01/top.xsa}
platform generate
platform config -updatehw {D:/Xilinx/local_PR_test_01/top.xsa}
platform generate -domains 
platform clean
platform generate
platform clean
platform clean
platform generate
platform active {top}
platform config -updatehw {D:/Xilinx/local_PR_test_01/top.xsa}
platform clean
platform generate
platform clean
platform generate
platform config -updatehw {D:/Xilinx/local_PR_test_01/top.xsa}
platform clean
platform generate
platform config -updatehw {D:/Xilinx/local_PR_test_01/top.xsa}
platform clean
platform generate
platform config -updatehw {D:/Xilinx/local_PR_test_01/top.xsa}
platform generate -domains 
platform clean
platform generate
