transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -vlog01compat -work work +incdir+C:/Users/Manuel/Documents/TEC/Arqui\ 2/Arqui_de_computadores_2/CPU/Memory {C:/Users/Manuel/Documents/TEC/Arqui 2/Arqui_de_computadores_2/CPU/Memory/ROM.v}
vlog -sv -work work +incdir+C:/Users/Manuel/Documents/TEC/Arqui\ 2/Arqui_de_computadores_2/CPU {C:/Users/Manuel/Documents/TEC/Arqui 2/Arqui_de_computadores_2/CPU/mux_2inputs.sv}
vlog -sv -work work +incdir+C:/Users/Manuel/Documents/TEC/Arqui\ 2/Arqui_de_computadores_2/CPU {C:/Users/Manuel/Documents/TEC/Arqui 2/Arqui_de_computadores_2/CPU/PC_adder.sv}
vlog -sv -work work +incdir+C:/Users/Manuel/Documents/TEC/Arqui\ 2/Arqui_de_computadores_2/CPU {C:/Users/Manuel/Documents/TEC/Arqui 2/Arqui_de_computadores_2/CPU/PC_register.sv}
vlog -sv -work work +incdir+C:/Users/Manuel/Documents/TEC/Arqui\ 2/Arqui_de_computadores_2/CPU {C:/Users/Manuel/Documents/TEC/Arqui 2/Arqui_de_computadores_2/CPU/FetchDecode_register.sv}
vlog -sv -work work +incdir+C:/Users/Manuel/Documents/TEC/Arqui\ 2/Arqui_de_computadores_2/CPU {C:/Users/Manuel/Documents/TEC/Arqui 2/Arqui_de_computadores_2/CPU/Processor.sv}

vlog -sv -work work +incdir+C:/Users/Manuel/Documents/TEC/Arqui\ 2/Arqui_de_computadores_2/CPU/Testbenches {C:/Users/Manuel/Documents/TEC/Arqui 2/Arqui_de_computadores_2/CPU/Testbenches/Fetch_Stage_tb.sv}

vsim -t 1ps -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver -L altera_lnsim_ver -L cyclonev_ver -L cyclonev_hssi_ver -L cyclonev_pcie_hip_ver -L rtl_work -L work -voptargs="+acc"  Fetch_Stage_tb

add wave *
view structure
view signals
run -all
