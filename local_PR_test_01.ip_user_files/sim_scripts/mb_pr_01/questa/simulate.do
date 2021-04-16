onbreak {quit -f}
onerror {quit -f}

vsim -lib xil_defaultlib mb_pr_01_opt

do {wave.do}

view wave
view structure
view signals

do {mb_pr_01.udo}

run -all

quit -force
