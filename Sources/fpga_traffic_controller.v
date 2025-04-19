`timescale 1ns / 1ps

module fpga_traffic_controller(
    input clk, // Clock
    input rstn_push, start_push, // Push Switches
    input [1:0] vip_slide, [1:0] tr_slide, [2:0] ch_slide, // Slide Switches
    output reg rstn, start, // LED
    output reg isvip, // LED
    output reg isnight, // LED
    output reg [9:0] light_sensor, // LED
    
    /* PMOD Ports */
    input dout,
    output cs, sclk,
    output din,
    output [3:0] car_traffic_0,
    output [1:0] walk_traffic_0,
    output [3:0] car_traffic_1,
    output [1:0] walk_traffic_1
);

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
    reg [24:0] cnt_2hz;
    reg [13:0] cnt_10khz;
    reg clk_2hz, clk_10khz;
    assign sclk = clk_10khz;
    
    always@(posedge clk) begin
        if(!rstn) begin
            clk_2hz <= 0;
            cnt_2hz <= 0;
            
            clk_10khz <= 0;
            cnt_10khz <= 0;
        end
        else begin
            if (cnt_2hz == 25'd25000000 - 1) begin
                clk_2hz <= ~clk_2hz;
                cnt_2hz <= 0;
            end
            else cnt_2hz <= cnt_2hz + 1;
            
            if (cnt_10khz == 14'd10000 - 1) begin
                clk_10khz <= ~clk_10khz;
                cnt_10khz <= 0;
            end
            else cnt_10khz <= cnt_10khz + 1;
        end
    end
    
    // Select VIP
    reg vip_path_index;
    always@(posedge clk) begin
        case(vip_slide)
            2'b10: begin // North, South
                isvip <= 1;
                vip_path_index <= 0;
            end
            2'b01: begin // East, West
                isvip <= 1;
                vip_path_index <= 1;
            end
            default: begin
                isvip <= 0;
                vip_path_index <= 0;
            end
        endcase
    end
    
    // Select Channel
    reg [1:0] channel;
    always@(posedge clk) begin
        if(!start) begin
            channel <= 2'b11;
        end
        else begin
            case(ch_slide)
                3'b100: channel <= 2'b00;
                3'b010: channel <= 2'b01;
                3'b001: channel <= 2'b10;
                default: channel <= 2'b11;
            endcase
        end
    end
    
    // Select Traffic
    wire [1:0] traffic_camera;
    assign traffic_camera = {tr_slide[0], tr_slide[1]};
    
    // Select Night
    reg [3:0] night_enter_cnt;
    
    always@(posedge clk) begin
        if (!start) begin
            isnight <= 0;
            night_enter_cnt <= 0;
        end
        else begin
            if (isnight) begin // decrease counter to disable night mode
                if (light_sensor < 10'd800) begin
                    if (night_enter_cnt == 0) begin
                        isnight <= 0;
                        night_enter_cnt <= 0;
                    end
                    else night_enter_cnt <= night_enter_cnt - 1;
                end
                else begin 
                    night_enter_cnt <= 10;
                end
            end
            
            else if (!isnight) begin // increase counter to enable night mode
                if(light_sensor >= 10'd800) begin
                    if (night_enter_cnt == 10) isnight <= 1;
                    else night_enter_cnt <= night_enter_cnt + 1;
                end
                else begin
                    night_enter_cnt <= 0;
                end
            end
            else begin end
        end
    end
    
    wire [9:0] light_sensor_out;
    
    always@(posedge clk) light_sensor <= light_sensor_out;
    
    intersection_vip_night intersection(
        .clk(clk_2hz), .start(start),
        .isvip(isvip),
        .isnight(isnight),
        .vip_path_index(vip_path_index),
        .traffic_camera(traffic_camera),
        .car_traffic_0(car_traffic_0),
        .walk_traffic_0(walk_traffic_0),
        .car_traffic_1(car_traffic_1),
        .walk_traffic_1(walk_traffic_1)
    );
    
    spi_master spi_master(
        .clk(clk),
        .sclk(sclk), .start(start),
        .channel(channel),
        .dout(dout),
        .cs(cs),
        .din(din),
        .light_sensor(light_sensor_out)
    );
    
endmodule
