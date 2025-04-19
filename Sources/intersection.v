`timescale 1ns / 1ps

module intersection(
    input clk, rstn_push, start_push,
    output pmod_clk,
    output reg rstn, start,
    output [3:0] car_traffic_0,
    output [1:0] walk_traffic_0,
    output [3:0] car_traffic_1,
    output [1:0] walk_traffic_1
);
    assign pmod_clk = clk;
    
    // Toggle Reset
    reg rstn_push_prev;
    reg [26:0] rstn_cooldown_cnt;
    
    always@(posedge clk) begin
        rstn_push_prev <= rstn_push;
        
        if(rstn_cooldown_cnt > 0) begin
            rstn_cooldown_cnt <= rstn_cooldown_cnt - 1;
        end
        else if(rstn_push && !rstn_push_prev) begin
            rstn <= ~rstn;
            rstn_cooldown_cnt <= 27'd100000000 - 1;
        end
    end
    
    // Toggle Start
    reg start_push_prev;
    reg [26:0] start_cooldown_cnt;
    
    always@(posedge clk) begin
        if(!rstn) begin
            start <= 0;
            start_cooldown_cnt <= 0;
            start_push_prev <= 0;
        end
        else begin
            start_push_prev <= start_push;
            
            if(start_cooldown_cnt > 0) begin
                start_cooldown_cnt <= start_cooldown_cnt - 1;
            end
            else if(start_push && !start_push_prev) begin
                start <= ~start;
                start_cooldown_cnt <= 27'd100000000 - 1;
            end
        end
    end
    
    // Generate Clock
    reg [24:0] clk_cnt;
    reg clk_2hz;
    
    always@(posedge clk) begin
        if(!rstn) begin
            clk_cnt <= 0;
            clk_2hz <= 0;
        end
        else begin
            if (clk_cnt == 25'd25000000 - 1) begin
                clk_2hz <= ~clk_2hz;
                clk_cnt <= 0;
            end
            else clk_cnt <= clk_cnt + 1;        
        end
    end

    traffic tr0(
        .clk(clk_2hz),
        .start(start),
        .path_index(1'd0),
        .car_traffic(car_traffic_0),
        .walk_traffic(walk_traffic_0)
    );

    traffic tr1(
        .clk(clk_2hz),
        .start(start),
        .path_index(1'd1),
        .car_traffic(car_traffic_1),
        .walk_traffic(walk_traffic_1)
    );

endmodule
