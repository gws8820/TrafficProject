`timescale 1ns / 1ps

module tb_intersection_vip();
    reg clk, start;
    reg [1:0] vip_slide;
    wire [3:0] car_traffic_0;
    wire [1:0] walk_traffic_0;
    wire [3:0] car_traffic_1;
    wire [1:0] walk_traffic_1;
    
    parameter CLK_PERIOD = 10;
    
    intersection_vip dut(
        .clk(clk),
        .start(start),
        .vip_slide(vip_slide),
        .car_traffic_0(car_traffic_0),
        .walk_traffic_0(walk_traffic_0),
        .car_traffic_1(car_traffic_1),
        .walk_traffic_1(walk_traffic_1)
    );
    
    initial forever #(CLK_PERIOD/2) clk = ~clk;
    
    initial begin
        clk = 0;
        start = 0;
        vip_slide = 0;
        
        #(10*CLK_PERIOD) start = 1;
        #(160*CLK_PERIOD) vip_slide = 2'b10;
        #(50*CLK_PERIOD) vip_slide = 2'b00;
        #(100*CLK_PERIOD) vip_slide = 2'b01;
        #(30*CLK_PERIOD) vip_slide = 2'b00;
        #(200*CLK_PERIOD) $finish;
    end
    
endmodule
