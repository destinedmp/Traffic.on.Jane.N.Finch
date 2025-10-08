`timescale 1ns / 1ps

module TrafficLightController_TB;

reg clk, rst;
reg emergency_vehicle;
reg [1:0] emergency_road;

wire [2:0] main_road_1;
wire [2:0] main_road_2;
wire [2:0] main_turn;
wire [2:0] side_road;


TrafficLightController dut(
    .clk(clk),
    .rst(rst),
    .emergency_vehicle(emergency_vehicle),
    .emergency_road(emergency_road),
    .main_road_1(main_road_1),
    .main_road_2(main_road_2),
    .main_turn(main_turn),
    .side_road(side_road)
);

// Clock generation
initial begin
    clk = 0;
    forever #5 clk = ~clk;
end

// Reset at start
initial begin
    rst = 1;
    emergency_vehicle = 0;
    emergency_road = 2'b00;
    #20;    // hold reset for 2 clock cycles
    rst = 0;
end

// Cycle through all emergency roads
initial begin
    #30; // wait a few cycles

    // Loop through each emergency road
    integer i;
    for (i=0; i<4; i=i+1) begin
        emergency_vehicle = 1;
        emergency_road = i[1:0];
        #30; // emergency active for 30 ns (3 clock cycles)
        emergency_vehicle = 0;
        #50; // back to normal operation
    end

    #200;
    $finish;
end

initial begin
    $monitor("Time=%0t | M1=%b M2=%b MT=%b S=%b | Emergency=%b Road=%b", 
              $time, main_road_1, main_road_2, main_turn, side_road, emergency_vehicle, emergency_road);
end

endmodule
