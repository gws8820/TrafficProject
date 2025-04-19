`timescale 1ns / 1ps

module fsm_intersection(
    input clk, rstn,
    output [3:0] car_traffic_0,
    output [1:0] walk_traffic_0,
    output [3:0] car_traffic_1,
    output [1:0] walk_traffic_1
);

    fsm_traffic tr0(
        .clk(clk),
        .rstn(rstn),
        .path_index(1'd0),
        .car_traffic(car_traffic_0),
        .walk_traffic(walk_traffic_0)
    );

    fsm_traffic tr1(
        .clk(clk),
        .rstn(rstn),
        .path_index(1'd1),
        .car_traffic(car_traffic_1),
        .walk_traffic(walk_traffic_1)
    );

endmodule
