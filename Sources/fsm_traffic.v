`timescale 1ns / 1ps

module fsm_traffic(
    input clk, rstn,
    input path_index,
    output [3:0] car_traffic,
    output [1:0] walk_traffic
);
    
    reg [6:0] car_cycle_cnt;
    reg [6:0] walk_cycle_cnt;
    
    reg [3:0] car_current_state, car_next_state;
    reg [1:0] walk_current_state, walk_next_state;
    
    parameter CAR_RED = 4'b1000;
    parameter CAR_YELLOW = 4'b0100;
    parameter CAR_LEFT = 4'b0010;
    parameter CAR_GREEN = 4'b0001;
    
    parameter WALK_RED = 2'b10;
    parameter WALK_GREEN = 2'b01;
    parameter WALK_OFF = 2'b00;

    // Next State Logic
    always@(*) begin
        case(car_current_state)
            CAR_GREEN: begin
                if (car_cycle_cnt < 20)
                    car_next_state = CAR_GREEN;
                else begin
                    car_cycle_cnt = 0;
                    car_next_state = CAR_YELLOW;
                end
            end
            
            CAR_YELLOW: begin
                if (car_cycle_cnt < 10) begin
                    if (car_cycle_cnt < 2)
                        car_next_state = CAR_YELLOW;
                    else begin
                        car_cycle_cnt = 0;
                        car_next_state = CAR_LEFT;
                    end
                end
                else begin
                    if (car_cycle_cnt < 12)
                        car_next_state = CAR_YELLOW;
                    else begin
                        car_cycle_cnt = 0;
                        car_next_state = CAR_RED;
                    end
                end
            end
            
            CAR_LEFT: begin
                if(car_cycle_cnt < 10)
                    car_next_state = CAR_LEFT;
                else begin
                    car_cycle_cnt = 10;
                    car_next_state = CAR_YELLOW;
                end
            end
            
            CAR_RED: begin
                if (car_cycle_cnt < 34)
                    car_next_state = CAR_RED;
                else begin
                    car_cycle_cnt = 0;
                    car_next_state = CAR_GREEN;
                end
            end
            
            default: car_next_state = CAR_RED;
        endcase
    end
    
    always@(*) begin
        case(walk_current_state)
            WALK_RED: begin
                if(walk_cycle_cnt < 48)
                    walk_next_state = WALK_RED;
                else begin
                    walk_cycle_cnt = 0;
                    walk_next_state = WALK_GREEN;
                end
            end
            
            WALK_GREEN: begin
                if(walk_cycle_cnt < 14)
                    walk_next_state = WALK_GREEN;
                else if(walk_cycle_cnt < 20)
                    walk_next_state = WALK_OFF;
                else begin
                    walk_cycle_cnt = 0;
                    walk_next_state = WALK_RED;
                end
            end
  
            WALK_OFF:
                walk_next_state = WALK_GREEN;
                
            default: walk_next_state = WALK_RED;
        endcase
    end
    
    // State Register
    always@(posedge clk) begin
        if (!rstn) begin
            if(path_index == 0) begin
                car_current_state <= CAR_GREEN;
                walk_cycle_cnt <= 14;
                
                walk_current_state <= WALK_RED;
                car_cycle_cnt <= 0;
            end
            else begin
                car_current_state <= CAR_RED;
                car_cycle_cnt <= 0;
                
                walk_current_state <= WALK_GREEN;
                walk_cycle_cnt <= 0;
            end
        end
        else begin
            car_current_state <= car_next_state;
            car_cycle_cnt <= car_cycle_cnt + 1;
            
            walk_current_state <= walk_next_state;
            walk_cycle_cnt <= walk_cycle_cnt + 1;
        end
    end
    
    // Output Logic
    assign car_traffic = car_current_state;
    assign walk_traffic = walk_current_state;
   
endmodule
