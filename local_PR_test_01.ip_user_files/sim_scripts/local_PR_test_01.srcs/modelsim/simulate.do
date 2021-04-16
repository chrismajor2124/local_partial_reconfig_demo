onbreak {quit -f}
onerror {quit -f}

vsim -voptargs="+acc" -L xpm -L sem_v4_1_13 -L xil_defaultlib -L unisims_ver -L unimacro_ver -L secureip -lib xil_defaultlib xil_defaultlib.sem_0 xil_defaultlib.glbl

do {wave.do}

view wave
view structure
view signals

do {sem_0.udo}

run -all

quit -force
