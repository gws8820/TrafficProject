`timescale 1ns / 1ps

module fpga_test(
    input clk, rstn,
    output reg led
);

reg [26:0] counter;
reg clk_1hz;

always@(posedge clk) begin
    if(!rstn) begin
        counter <= 0;
        clk_1hz <= 0;
    end
    else begin
        if (counter == 26'd50000000 - 1) begin
            clk_1hz <= ~clk_1hz;
            counter <= 0;
        end
        else counter <= counter + 1;        
    end
end

always@(posedge clk_1hz) begin
    if(!rstn)
        led <= 0;
    else
        led <= ~led;
end

endmodule
