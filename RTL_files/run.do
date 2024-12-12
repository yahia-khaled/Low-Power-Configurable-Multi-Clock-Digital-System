vlib work
vlog -f sourcefile.txt
vsim -voptargs=+accs work.SYS_TB
add wave *
add wave -position insertpoint sim:/SYS_TB/DUT/UART_TX0/*
add wave -position insertpoint sim:/SYS_TB/DUT/UART_TX0/U2/*
add wave -position insertpoint sim:/SYS_TB/DUT/UART_TX0/U1/*
add wave -position insertpoint sim:/SYS_TB/DUT/UART_TX0/U3/*
add wave -position insertpoint  \
sim:/SYS_TB/Receive_data_UART_TX/Received_Frame
add wave -position insertpoint sim:/SYS_TB/DUT/UART_RX0/*
add wave -position insertpoint sim:/SYS_TB/DUT/SYS_CTRL0/*
add wave -position insertpoint sim:/SYS_TB/DUT/REG_FILE0/*
add wave -position insertpoint sim:/SYS_TB/DUT/ALU_U0/*
add wave -position insertpoint sim:/SYS_TB/DUT/FIFO_U0/*
add wave -position insertpoint sim:/SYS_TB/DUT/FIFO_U0/U1/*
run -all