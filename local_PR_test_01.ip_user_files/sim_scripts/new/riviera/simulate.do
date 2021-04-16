onbreak {quit -force}
onerror {quit -force}

asim +access +r +m+sem_0 -L xpm -L sem_v4_1_13 -L xil_defaultlib -L unisims_ver -L unimacro_ver -L secureip -O5 xil_defaultlib.sem_0 xil_defaultlib.glbl

do {wave.do}

view wave
view structure

do {sem_0.udo}

run -all

endsim

quit -force
