`timescale 1ns / 1ps

module tb_fsm_traffic();
    reg clk, rstn;
    wire [3:0] car_traffic;
    wire [1:0] walk_traffic;
    
    parameter CLK_PERIOD = 10;
    
    fsm_traffic dut(
        .clk(clk), 
        .rstn(rstn),
        .path_index(2'd0),
        .car_traffic(car_traffic), 
        .walk_traffic(walk_traffic)
    );
    
    initial forever #(CLK_PERIOD/2) clk = ~clk;
    
    initial begin
        clk = 0;
        rstn = 0;
        #(10*CLK_PERIOD) rstn = 1;
        #(100*CLK_PERIOD) $finish;
    end
    
endmodule
