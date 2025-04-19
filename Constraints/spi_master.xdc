## Clock signal
create_clock -period 10.000 [get_ports clk]
set_property -dict { PACKAGE_PIN E3    IOSTANDARD LVCMOS33 } [get_ports clk]

## Push Switch
set_property -dict { PACKAGE_PIN M18   IOSTANDARD LVCMOS33 } [get_ports rstn_push]
set_property -dict { PACKAGE_PIN N17   IOSTANDARD LVCMOS33 } [get_ports start_push]

## Slide Switch
set_property -dict { PACKAGE_PIN M13   IOSTANDARD LVCMOS33 } [get_ports { ch_slide[2] }]
set_property -dict { PACKAGE_PIN L16   IOSTANDARD LVCMOS33 } [get_ports { ch_slide[1] }]
set_property -dict { PACKAGE_PIN J15   IOSTANDARD LVCMOS33 } [get_ports { ch_slide[0] }]

## LED
set_property -dict { PACKAGE_PIN V11   IOSTANDARD LVCMOS33 } [get_ports rstn]
set_property -dict { PACKAGE_PIN V12   IOSTANDARD LVCMOS33 } [get_ports start]

## Light Sensor
set_property -dict { PACKAGE_PIN T15   IOSTANDARD LVCMOS33 } [get_ports light_sensor[9]]
set_property -dict { PACKAGE_PIN V16   IOSTANDARD LVCMOS33 } [get_ports light_sensor[8]]
set_property -dict { PACKAGE_PIN U16   IOSTANDARD LVCMOS33 } [get_ports light_sensor[7]]
set_property -dict { PACKAGE_PIN U17   IOSTANDARD LVCMOS33 } [get_ports light_sensor[6]]
set_property -dict { PACKAGE_PIN V17   IOSTANDARD LVCMOS33 } [get_ports light_sensor[5]]
set_property -dict { PACKAGE_PIN R18   IOSTANDARD LVCMOS33 } [get_ports light_sensor[4]]
set_property -dict { PACKAGE_PIN N14   IOSTANDARD LVCMOS33 } [get_ports light_sensor[3]]
set_property -dict { PACKAGE_PIN J13   IOSTANDARD LVCMOS33 } [get_ports light_sensor[2]]
set_property -dict { PACKAGE_PIN K15   IOSTANDARD LVCMOS33 } [get_ports light_sensor[1]]
set_property -dict { PACKAGE_PIN H17   IOSTANDARD LVCMOS33 } [get_ports light_sensor[0]]


##Pmod Header JA
## P2: 11, 9, 7, 5
#set_property -dict { PACKAGE_PIN C17   IOSTANDARD LVCMOS33 } [get_ports { car_traffic_1[2] }];
#set_property -dict { PACKAGE_PIN D18   IOSTANDARD LVCMOS33 } [get_ports { car_traffic_1[3] }];
#set_property -dict { PACKAGE_PIN E18   IOSTANDARD LVCMOS33 } [get_ports { walk_traffic_0[1] }];
#set_property -dict { PACKAGE_PIN G17   IOSTANDARD LVCMOS33 } [get_ports { walk_traffic_0[0] }];

## P1: 12, 10, 8, 6
#set_property -dict { PACKAGE_PIN D17   IOSTANDARD LVCMOS33 } [get_ports { walk_traffic_1[1] }];
#set_property -dict { PACKAGE_PIN E17   IOSTANDARD LVCMOS33 } [get_ports { walk_traffic_1[0] }];
#set_property -dict { PACKAGE_PIN F18   IOSTANDARD LVCMOS33 } [get_ports { car_traffic_1[1] }];
#set_property -dict { PACKAGE_PIN G18   IOSTANDARD LVCMOS33 } [get_ports { car_traffic_0[1] }];

#Pmod Header JB
## 11, 9, 7, 5
set_property -dict { PACKAGE_PIN D14   IOSTANDARD LVCMOS33 } [get_ports { cs }];
set_property -dict { PACKAGE_PIN F16   IOSTANDARD LVCMOS33 } [get_ports { din }];
set_property -dict { PACKAGE_PIN G16   IOSTANDARD LVCMOS33 } [get_ports { dout }];
set_property -dict { PACKAGE_PIN H14   IOSTANDARD LVCMOS33 } [get_ports { sclk }];

## 12, 10, 8, 6
#set_property -dict { PACKAGE_PIN E16   IOSTANDARD LVCMOS33 } [get_ports { car_traffic_1[0] }];
#set_property -dict { PACKAGE_PIN F13   IOSTANDARD LVCMOS33 } [get_ports { car_traffic_0[0] }];
#set_property -dict { PACKAGE_PIN G13   IOSTANDARD LVCMOS33 } [get_ports { car_traffic_0[2] }];
#set_property -dict { PACKAGE_PIN H16   IOSTANDARD LVCMOS33 } [get_ports { car_traffic_0[3] }];