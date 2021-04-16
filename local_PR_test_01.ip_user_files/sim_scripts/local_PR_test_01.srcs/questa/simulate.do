onbreak {quit -f}
onerror {quit -f}

vsim -lib xil_defaultlib sem_0_opt

do {wave.do}

view wave
view structure
view signals

do {sem_0.udo}

run -all

quit -force
