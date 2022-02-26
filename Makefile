CROSS=riscv32-unknown-elf-
CFLAGS=

RTL_DIR="./rtl"
TB_DIR="./tb"

RTL_FILES := $(shell find $(RTL_DIR) -name '*.sv')
TB_FILES := $(shell find $(TB_DIR) -name '*.sv')

#DO_COMMAND := "transcript on; if {[file exists work]} {vdel -lib work -all}; vlib work;"
#DO_COMMAND := $(DO_COMMAND) -do "$(foreach file, $(RTL_FILES), vlog -reportprogress 300 -sv -sv12compat $(file);)"
#DO_COMMAND := $(DO_COMMAND) -do "$(foreach file, $(TB_FILES), vlog -reportprogress 300 -sv -sv12compat $(file);)"

modelsim: $(RTL_FILES) $(TB_FILES)
	vsim -do rv32im.do
	#vsim -do $(DO_COMMAND)
yosys: $(RTL_FILES) $(TB_FILES)
	yosys -s yosys_syn
	# yosys -o rv32im.blif -S $^

iverilog: $(RTL_FILES) $(TB_FILES)
	iverilog $^ -g2012 -o rv32im_test -s CPU

lint: $(RTL_FILES) $(TB_FILES)
	# verible-verilog-lint --rules=-unpacked-dimensions-range-ordering,-explicit-parameter-storage-type,-parameter-name-style $^ | less
	svlint $^

clean:
	rm -f *.vvp *.vcd *.blif *.wlf transcript

