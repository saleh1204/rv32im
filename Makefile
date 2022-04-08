CROSS=riscv32-unknown-elf-
CFLAGS=

RTL_DIR="./rtl"
TB_DIR="./tb"

RTL_FILES := $(shell find $(RTL_DIR) -name '*.sv')
TB_FILES := $(shell find $(TB_DIR) -name '*.sv')

modelsim: $(RTL_FILES) $(TB_FILES)
	vsim -do rv32im.do
	#vsim -do $(DO_COMMAND)

lint: $(RTL_FILES) $(TB_FILES)
	# verible-verilog-lint --rules=-unpacked-dimensions-range-ordering,-explicit-parameter-storage-type,-parameter-name-style $^ | less
	svlint $^

clean:
	rm -f *.vvp *.vcd *.blif *.wlf transcript

