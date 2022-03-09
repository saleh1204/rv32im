transcript on; 
if {[file exists work]} {
    vdel -lib work -all
};
vlib work;
vlog -reportprogress 300 -sv -sv12compat "./rtl/RegisterFile.sv";
vlog -reportprogress 300 -sv -sv12compat "./rtl/InstructionMemory.sv";
vlog -reportprogress 300 -sv -sv12compat "./rtl/ALU.sv";
vlog -reportprogress 300 -sv -sv12compat "./rtl/ControlUnit.sv";
vlog -reportprogress 300 -sv -sv12compat "./rtl/ForwardingUnit.sv";
vlog -reportprogress 300 -sv -sv12compat "./rtl/DataMemory.sv";
vlog -reportprogress 300 -sv -sv12compat "./rtl/CPU.sv";
vlog -reportprogress 300 -sv -sv12compat "./rtl/GPIO.sv";
vlog -reportprogress 300 -sv -sv12compat "./rtl/TOP.sv";

# ip components
vlog -reportprogress 300 "../rv32im_project/ip/div.v";
vlog -reportprogress 300 "../rv32im_project/ip/divu.v";
vlog -reportprogress 300 "../rv32im_project/ip/mul.v";
vlog -reportprogress 300 "../rv32im_project/ip/mulu.v";


vlog -reportprogress 300 -sv -sv12compat "./tb/TOP_tb.sv";

vsim -t 1ps -L work -L twentynm_ver -L altera_ver -L altera_lnsim_ver -L lpm_ver -L altera_mf_ver work.TOP_tb

###add wave *
quietly WaveActivateNextPane {} 0
add wave  -format Logic -label CLK CLK 
add wave  -format Logic -label RST RESET 
add wave  -format Literal -radix hex -label PC1 dut/cpu/program_counter1
add wave  -format Literal -radix hex -label PC2 dut/cpu/program_counter2
add wave  -format Literal -radix hex -label PC3 dut/cpu/program_counter3
add wave  -format Literal -radix hex -label PC4 dut/cpu/program_counter4
add wave  -format Literal -radix hex -label INST dut/cpu/instruction1
view structure
view signals 
run -all