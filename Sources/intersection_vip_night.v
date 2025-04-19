`timescale 1ns / 1ps

module intersection_vip_night(
    input clk,
    input start,
    input isvip,
    input isnight,
    input vip_path_index,
    input [1:0] traffic_camera,
    output [3:0] car_traffic_0,
    output [1:0] walk_traffic_0,
    output [3:0] car_traffic_1,
    output [1:0] walk_traffic_1
);

    reg [4:0] renew_hold_cnt;
    reg [3:0] change_hold_cnt;
    
    reg [1:0] current_night_priority, next_night_priority;
    wire night_path_index;
    assign night_path_index = current_night_priority[1];
    
    always@(posedge clk) begin        
        if (!isnight) begin
            if (car_traffic_0 == 4'b1000) begin // priority to path 0 and 2
                current_night_priority[1] = 1'd0;
                current_night_priority[0] = 1'd1;
            end
            
            else if (car_traffic_1 == 4'b1000) begin// priority to path 1 and 3
                current_night_priority[1] = 1'd1;
                current_night_priority[0] = 1'd0;
            end
            
            else begin end
        end
        else begin
            if (!traffic_camera[night_path_index]) begin // traffic_camera turned off
                renew_hold_cnt <= 0;
                
                if(change_hold_cnt == 2) begin // wait for 3 cnts
                    change_hold_cnt <= 0;
                    
                    current_night_priority[1] <= next_night_priority[1];
                    current_night_priority[0] <= next_night_priority[0];
                end
                else change_hold_cnt <= change_hold_cnt + 1;
            end
            else begin
                change_hold_cnt <= 0;
                
                if(renew_hold_cnt == 19) begin // wait for 20 cnts
                    renew_hold_cnt <= 0;
                    
                    current_night_priority[1] <= next_night_priority[1];
                    current_night_priority[0] <= next_night_priority[0];
                end
                else renew_hold_cnt <= renew_hold_cnt + 1;
            end
        end
    end
    
    always@(*) begin
        if(traffic_camera[current_night_priority[0]]) begin
            next_night_priority[1] = current_night_priority[0];
            next_night_priority[0] = current_night_priority[1];
        end
        else begin
            next_night_priority[1] = current_night_priority[1];
            next_night_priority[0] = current_night_priority[0];
        end
    end
    
    wire [3:0] prev_counter_0, prev_counter_1;
    wire [3:0] rollback_cnt;
    
    assign rollback_cnt = prev_counter_0 ? prev_counter_0 : prev_counter_1;
    
    traffic_vip_night tr0(
        .clk(clk),
        .start(start),
        .path_index(1'd0),
        .vip_path_index(vip_path_index),
        .night_path_index(night_path_index),
        .isvip(isvip),
        .isnight(isnight),
        .rollback_cnt(rollback_cnt),
        .prev_counter(prev_counter_0),
        .car_traffic(car_traffic_0),
        .walk_traffic(walk_traffic_0)
    );

    traffic_vip_night tr1(
        .clk(clk),
        .start(start),
        .path_index(1'd1),
        .vip_path_index(vip_path_index),
        .night_path_index(night_path_index),
        .isvip(isvip),
        .isnight(isnight),
        .rollback_cnt(rollback_cnt),
        .prev_counter(prev_counter_1),
        .car_traffic(car_traffic_1),
        .walk_traffic(walk_traffic_1)
    );

endmodule