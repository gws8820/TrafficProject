`timescale 1ns / 1ps

module spi_master(
    input clk, sclk, start,
    input [1:0] channel,
    input dout,
    output reg cs,
    output reg din,
    output reg [9:0] light_sensor
);
    reg [9:0] timing_counter;
    
    // Send Control Bit
    always@(negedge sclk) begin
        if(!start) begin
            timing_counter <= 0;
            cs <= 1;
            din <= 0;
        end
        else begin
            if (timing_counter < 18) begin
                cs <= 0;
                timing_counter <= timing_counter + 1;
            end
            
            else if (timing_counter < 10'd1000 - 1) begin // 0.1s
                cs <= 1;
                timing_counter <= timing_counter + 1;
            end
            
            else begin
                timing_counter <= 0;
                cs <= 1;
            end
            
            case (timing_counter)
                0: din <= 1;
                1: din <= 1;
                2: din <= 0;
                3: din <= channel[1];
                4: din <= channel[0];
                default: din <= 0;
            endcase
        end
    end
    
    // Receive Data
    always@(posedge sclk) begin
        if(!start) light_sensor <= 0;
        else begin
            case (timing_counter)
                8: light_sensor[9] <= dout;
                9: light_sensor[8] <= dout;
                10: light_sensor[7] <= dout;
                11: light_sensor[6] <= dout;
                12: light_sensor[5] <= dout;
                13: light_sensor[4] <= dout;
                14: light_sensor[3] <= dout;
                15: light_sensor[2] <= dout;
                16: light_sensor[1] <= dout;
                17: light_sensor[0] <= dout;
                default: light_sensor <= light_sensor;
            endcase
        end
    end
endmodule