`timescale 1ns / 1ps

module traffic(
    input clk, start,
    input path_index,
    output reg [3:0] car_traffic,
    output reg [1:0] walk_traffic
);
    
    reg [6:0] cycle_cnt;
    
    parameter CAR_RED = 4'b1000;
    parameter CAR_YELLOW = 4'b0100;
    parameter CAR_LEFT = 4'b0010;
    parameter CAR_GREEN = 4'b0001;
    
    parameter WALK_RED = 2'b10;
    parameter WALK_GREEN = 2'b01;
    parameter WALK_OFF = 2'b00;
    
    always@(*) begin
        if (cycle_cnt <= 20)
            car_traffic = CAR_GREEN;
        else if (cycle_cnt <= 22)
            car_traffic = CAR_YELLOW;
        else if (cycle_cnt <= 32)
            car_traffic = CAR_LEFT;
        else if (cycle_cnt <= 34)
            car_traffic = CAR_YELLOW;
        else
            car_traffic = CAR_RED;
            
        if (cycle_cnt <= 34)
            walk_traffic = WALK_RED;
        else if (cycle_cnt <= 48)
            walk_traffic = WALK_GREEN;
        else if (cycle_cnt <= 54)
            if (cycle_cnt[0])
                walk_traffic = WALK_OFF;
            else walk_traffic = WALK_GREEN;
        else
            walk_traffic = WALK_RED;
    end
    
    always@(posedge clk) begin
        if (!start) begin
            if(path_index == 0)
                cycle_cnt <= 7'd0;
            else cycle_cnt <= 7'd34;
        end
        else begin
            if (cycle_cnt == 68)
                cycle_cnt <= 1;
            else cycle_cnt <= cycle_cnt + 1; 
        end
    end
    
endmodule
