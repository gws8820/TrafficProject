`timescale 1ns / 1ps

module traffic_vip(
    input clk, start,
    input path_index,
    input vip_path_index,
    input isvip,
    input [3:0] rollback_cnt,
    output reg [3:0] prev_counter,
    output [3:0] car_traffic,
    output [1:0] walk_traffic
);

    parameter CAR_RED = 4'b1000;
    parameter CAR_YELLOW = 4'b0100;
    parameter CAR_LEFT = 4'b1010;
    parameter CAR_GREEN = 4'b0001;
    
    parameter WALK_RED = 2'b10;
    parameter WALK_GREEN = 2'b01;
    parameter WALK_OFF = 2'b00;
    
    reg [6:0] global_counter;

    reg [3:0] car_current_state, car_next_state;
    reg [1:0] walk_current_state, walk_next_state;

    reg active_vip;
    wire active_condition;
    assign active_condition = (car_current_state == CAR_LEFT) ||
                           (car_current_state == CAR_YELLOW) ||
                           ((car_current_state == CAR_RED) && (walk_current_state == WALK_RED));

    reg is_interrupted;
    reg [6:0] interrupted_counter;
    
    reg [3:0] car_interrupted_state;
    reg [1:0] walk_interrupted_state;
                               
    reg [1:0] vip_enter_cnt;
    reg [1:0] vip_leave_cnt;
    
    always@(posedge clk) begin
        if (!start) begin
            if(path_index == 0) begin
                car_current_state <= CAR_GREEN;
                walk_current_state <= WALK_RED;
                global_counter <= 0;
            end
            else begin
                car_current_state <= CAR_RED;
                walk_current_state <= WALK_GREEN;
                global_counter <= 34;
            end
            
            active_vip <= 0;
            is_interrupted <= 0;
            interrupted_counter <= 0;
            
            vip_enter_cnt <= 0;
            vip_leave_cnt <= 0;
        end
        else begin
            if (isvip && active_condition)
                active_vip = 1;
            else if (!isvip)
                active_vip = 0;
            else begin end

            if(active_vip) begin
                if (!is_interrupted) begin
                    car_interrupted_state <= car_next_state;
                    walk_interrupted_state<= walk_next_state;
                    interrupted_counter <= global_counter;
                    is_interrupted <= 1;
                    
                    if (car_current_state == CAR_LEFT) begin
                        if (global_counter < 28) begin
                            prev_counter[3] <= 0;
                            prev_counter[2:0] <= global_counter - 23;
                        end
                        else begin
                            prev_counter[3] <= 1;
                            prev_counter <= 10 - (global_counter - 23);
                        end
                    end
                    else prev_counter <= 0;
                end
                else begin end
                
                if (vip_enter_cnt == 2) begin
                    if (path_index == vip_path_index) begin
                        car_current_state <= CAR_GREEN;
                        walk_current_state <= WALK_RED;
                    end
                    else begin
                        car_current_state <= CAR_RED;
                        walk_current_state <= WALK_RED;
                    end
                end
                else begin
                    car_current_state <= CAR_YELLOW;
                    vip_enter_cnt <= vip_enter_cnt + 1;
                end
            end
            
            else begin
                if (is_interrupted) begin
                    if (vip_leave_cnt == 2) begin
                        car_current_state <= car_interrupted_state;
                        walk_current_state <= walk_interrupted_state;
 
                        if (rollback_cnt[3] == 0)
                            global_counter <= interrupted_counter - rollback_cnt[2:0];
                        else 
                            global_counter <= interrupted_counter + rollback_cnt[2:0];
                        
                        is_interrupted <= 0;
                    end 
                    else begin
                        car_current_state <= CAR_YELLOW;
                        vip_leave_cnt <= vip_leave_cnt + 1;
                    end
                end
                else begin
                    if (global_counter == 68) global_counter <= 1;
                    else global_counter <= global_counter + 1;
                    
                    car_current_state <= car_next_state;
                    walk_current_state <= walk_next_state;
                    
                    vip_enter_cnt <= 0;
                    vip_leave_cnt <= 0;
                end
            end
        end
    end
       
    always @(*) begin
        case(car_current_state)
            CAR_GREEN: begin
                if (global_counter < 20)
                    car_next_state = CAR_GREEN;
                else
                    car_next_state = CAR_YELLOW;
            end

            CAR_YELLOW: begin
                if (global_counter == 22)
                    car_next_state = CAR_LEFT;
                else if (global_counter == 34)
                    car_next_state = CAR_RED;
                else
                    car_next_state = CAR_YELLOW;
            end

            CAR_LEFT: begin
                if (global_counter < 32)
                    car_next_state = CAR_LEFT;
                else 
                    car_next_state = CAR_YELLOW;
            end

            CAR_RED: begin
                if (global_counter == 68)
                    car_next_state = CAR_GREEN;
                else 
                    car_next_state = CAR_RED;
            end

            default: car_next_state = CAR_RED;
        endcase
    end
    
    always@(*) begin
        case(walk_current_state)
            WALK_RED: begin
                if(global_counter == 34)
                    walk_next_state = WALK_GREEN;
                else
                    walk_next_state = WALK_RED;
            end
            
            WALK_GREEN: begin
                if(global_counter < 48)
                    walk_next_state = WALK_GREEN;
                else if(global_counter < 54)
                    walk_next_state = WALK_OFF;
                else
                    walk_next_state = WALK_RED;
            end
            
            WALK_OFF:
                walk_next_state = WALK_GREEN;
                
            default: walk_next_state = WALK_RED;
        endcase
    end
    
    assign car_traffic  = car_current_state;
    assign walk_traffic = walk_current_state;
    
endmodule