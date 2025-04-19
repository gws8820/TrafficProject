`timescale 1ns / 1ps

module tb_fsm_intersection();
    reg clk, rstn;
    wire [3:0] car_traffic_0;
    wire [1:0] walk_traffic_0;
    wire [3:0] car_traffic_1;
    wire [1:0] walk_traffic_1;
    wire [3:0] car_traffic_2;
    wire [1:0] walk_traffic_2;
    wire [3:0] car_traffic_3;
    wire [1:0] walk_traffic_3;

    parameter CLK_PERIOD = 10;
    
    fsm_intersection dut(
        .clk(clk),
        .rstn(rstn),
        .car_traffic_0(car_traffic_0),
        .walk_traffic_0(walk_traffic_0),
        .car_traffic_1(car_traffic_1),
        .walk_traffic_1(walk_traffic_1),
        .car_traffic_2(car_traffic_2),
        .walk_traffic_2(walk_traffic_2),
        .car_traffic_3(car_traffic_3),
        .walk_traffic_3(walk_traffic_3)
    );
    
    initial forever #(CLK_PERIOD/2) clk = ~clk;
    
    initial begin
        clk = 0;
        rstn = 0;
        #(10*CLK_PERIOD) rstn = 1;
        #(200*CLK_PERIOD) $finish;
    end
    
endmodule
