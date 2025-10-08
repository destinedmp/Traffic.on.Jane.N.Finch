`timescale 1ns / 1ps

module TrafficLightController(
    input  wire clk,
    input  wire rst,
    input  wire emergency_vehicle,
    input  wire [1:0] emergency_road, // 00=M1, 01=M2, 10=MT, 11=S
    output reg [2:0] main_road_1,    // [R Y G]
    output reg [2:0] main_road_2,    // [R Y G]
    output reg [2:0] main_turn,      // [R Y G]
    output reg [2:0] side_road       // [R Y G]
);

    // State encoding
    typedef enum logic [3:0] {
        S1 = 4'd0,
        S2 = 4'd1,
        S3 = 4'd2,
        S4 = 4'd3,
        S5 = 4'd4,
        S6 = 4'd5,
        EMERGENCY_MODE = 4'd6
    } state_t;

    state_t current_state, next_state;

    // Adjust for different timings for phases
    localparam int SEC1 = 7, SEC2 = 2, SEC3 = 5, SEC4 = 2, SEC5 = 3, SEC6 = 2, EMERGENCY_SEC = 3;

    // State duration
    function automatic int state_time(state_t s);
        case(s)
            S1: state_time = SEC1;
            S2: state_time = SEC2;
            S3: state_time = SEC3;
            S4: state_time = SEC4;
            S5: state_time = SEC5;
            S6: state_time = SEC6;
            EMERGENCY_MODE: state_time = EMERGENCY_SEC;
            default: state_time = 1;
        endcase
    endfunction

    reg [3:0] timer;

    // Sequential state and timer
    always_ff @(posedge clk or posedge rst) begin
        if (rst) begin
            current_state <= S1;
            timer <= 0;
        end else begin
            if (timer < state_time(current_state))
                timer <= timer + 1;
            else begin
                current_state <= next_state;
                timer <= 0;
            end
        end
    end

    // Next state logic
    always_comb begin
        if (emergency_vehicle)
            next_state = EMERGENCY_MODE;
        else begin
            case(current_state)
                S1: next_state = S2;
                S2: next_state = S3;
                S3: next_state = S4;
                S4: next_state = S5;
                S5: next_state = S6;
                S6: next_state = S1;
                EMERGENCY_MODE: next_state = S1;
                default: next_state = S1;
            endcase
        end
    end

    // Output logic [R Y G]
    always_comb begin
        // default all red
        main_road_1 = 3'b100;
        main_road_2 = 3'b100;
        main_turn   = 3'b100;
        side_road   = 3'b100;

        case(current_state)
            S1: begin main_road_1=3'b001; main_road_2=3'b001; main_turn=3'b100; side_road=3'b100; end
            S2: begin main_road_1=3'b001; main_road_2=3'b010; main_turn=3'b100; side_road=3'b100; end
            S3: begin main_road_1=3'b001; main_road_2=3'b100; main_turn=3'b001; side_road=3'b100; end
            S4: begin main_road_1=3'b010; main_road_2=3'b100; main_turn=3'b010; side_road=3'b100; end
            S5: begin main_road_1=3'b100; main_road_2=3'b100; main_turn=3'b100; side_road=3'b001; end
            S6: begin main_road_1=3'b100; main_road_2=3'b100; main_turn=3'b100; side_road=3'b010; end
            EMERGENCY_MODE: begin
                main_road_1 = (emergency_road==2'b00) ? 3'b001 : 3'b100;
                main_road_2 = (emergency_road==2'b01) ? 3'b001 : 3'b100;
                main_turn   = (emergency_road==2'b10) ? 3'b001 : 3'b100;
                side_road   = (emergency_road==2'b11) ? 3'b001 : 3'b100;
            end
        endcase
    end

endmodule
