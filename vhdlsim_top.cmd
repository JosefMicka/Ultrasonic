::VHDL simulation using ghdl and gtkwave on win
::
SET "testbench=top_tb"
SET "testbench_vhd=%testbench%.vhd"
SET "outvcd=%testbench%.vcd"

ghdl -a --ieee=synopsys -fexplicit bcd_cnt.vhd
ghdl -a --ieee=synopsys -fexplicit four_bcd_cnts.vhd

ghdl -a --ieee=synopsys -fexplicit up_to_six.vhd
ghdl -a --ieee=synopsys timer2.vhd
ghdl -a --ieee=synopsys meas.vhd
ghdl -a --ieee=synopsys bin_cnt.vhd
ghdl -a --ieee=synopsys one_of_four.vhd
ghdl -a --ieee=synopsys hex_to_sseg.vhd
ghdl -a --ieee=synopsys disp_mux.vhd
ghdl -a --ieee=synopsys top.vhd

ghdl -a --ieee=synopsys %testbench_vhd%
ghdl -e --ieee=synopsys -fexplicit %testbench%
ghdl -r --ieee=synopsys -fexplicit %testbench% --vcd=%outvcd% --stop-time=120ms
gtkwave %outvcd%
