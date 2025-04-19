`timescale 1ns / 1ps

module tb_intersection_vip_night();
    reg clk, rstn, start;
    reg [1:0] vip_slide;
    reg [9:0] light_sensor;
    reg [1:0] traffic_camera;
    wire [3:0] car_traffic_0;
    wire [1:0] walk_traffic_0;
    wire [3:0] car_traffic_1;
    wire [1:0] walk_traffic_1;
    
    parameter CLK_PERIOD = 10;
    
    intersection_vip_night dut(
        .clk(clk), .rstn(rstn), .start(start),
        .vip_slide(vip_slide),
        .light_sensor(light_sensor),
        .traffic_camera(traffic_camera),
        .car_traffic_0(car_traffic_0),
        .walk_traffic_0(walk_traffic_0),
        .car_traffic_1(car_traffic_1),
        .walk_traffic_1(walk_traffic_1)
    );
    
    initial forever #(CLK_PERIOD/2) clk = ~clk;
    
    initial begin
        clk = 0;
        rstn = 0;
        start = 0;
        vip_slide = 0;
        #(20*CLK_PERIOD) rstn = 1;
        
        light_sensor = 200;
        traffic_camera = 2'b00;        
        #(10*CLK_PERIOD) start = 1;
        
        #(25*CLK_PERIOD) vip_slide = 2'b10;
        #(20*CLK_PERIOD) vip_slide = 2'b00;
        #(130*CLK_PERIOD) vip_slide = 2'b01;
        #(50*CLK_PERIOD) vip_slide = 2'b00;
        
        #(20*CLK_PERIOD) light_sensor = 10;
        #(5*CLK_PERIOD) light_sensor = 100;
        #(200*CLK_PERIOD) light_sensor = 10;
        #(40*CLK_PERIOD) traffic_camera = 2'b01;
        #(10*CLK_PERIOD) traffic_camera = 2'b10;
        #(50*CLK_PERIOD) traffic_camera = 2'b00;
        #(30*CLK_PERIOD) traffic_camera = 2'b11;
               
        #(100*CLK_PERIOD) traffic_camera = 2'b01;
        #(10*CLK_PERIOD) traffic_camera = 2'b10;
        #(50*CLK_PERIOD) traffic_camera = 2'b00;
        #(30*CLK_PERIOD) traffic_camera = 2'b10;
        #(30*CLK_PERIOD) light_sensor = 100;
        #(200*CLK_PERIOD) $finish;
    end
    
endmodule
