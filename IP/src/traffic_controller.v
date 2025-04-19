`timescale 1ns / 1ps

module traffic_controller(
    input clk,
    input rstn, start,
    input isvip, vip_path_index,
    input [1:0] traffic_camera,
    input [1:0] channel,
    
    /* PMOD Ports */
    input dout,
    output cs, sclk,
    output din,
    
    output reg isnight,
    output [3:0] car_traffic_0,
    output [1:0] walk_traffic_0,
    output [3:0] car_traffic_1,
    output [1:0] walk_traffic_1
);

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
    
    // Select Night
    wire [9:0] light_sensor;
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
        .light_sensor(light_sensor)
    );
    
endmodule
