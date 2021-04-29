# create clk1 and clk2 from CLOCK_50, where clk1 is a bit faster than clk2
create_clock -name clk1 -period 20.000 [get_ports clk1]
create_clock -name clk2 -period 30 [get_ports clk2]

# min is hold time, max is the period of clk1 - set up time
set_input_delay -clock clk1 -min 5 [get_ports newdata1]
set_input_delay -clock clk1 -max 15 [get_ports newdata1]

# set constrain for data1, max is half of the clk1 period 
set_input_delay -clock clk1 -min 1 [get_ports data1[*]]
set_input_delay -clock clk1 -max 10 [get_ports data1[*]]

#set constrain for output busy1, max delay is half of the period of clk1
set_output_delay -clock clk1 -min 1 [get_ports busy1]
set_output_delay -clock clk1 -max 10 [get_ports busy1]

#set constrain for dataready2
set_output_delay -clock clk2 -min 1 [get_ports dataready2]
set_output_delay -clock clk2 -max 10 [get_ports dataready2]

#set constrain for data2
set_output_delay -clock clk2 -min 1 [get_ports data2[*]]
set_output_delay -clock clk2 -max 10 [get_ports data2[*]]