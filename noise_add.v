`timescale 1ns / 1ps

module noise_add(
    input [7:0] i_data,
    input [4:0] i_noise,
    output [7:0] o_data
    );
    
    reg [6:0] noise;
    
    wire [2:0] error_at_bit;
    assign error_at_bit = i_noise[2:0]; //for debuging only
    
    always @(*) begin
        case (i_noise[2:0])
            3'd1:   noise = {i_noise[3], 6'b00_0001};   //1-bit or 2-bit error
            3'd2:   noise = {i_noise[3], 6'b00_0010};
            3'd3:   noise = {i_noise[3], 6'b00_0100};
            3'd4:   noise = {i_noise[3], 6'b00_1000};
            3'd5:   noise = {i_noise[3], 6'b01_0000};
            3'd6:   noise = {i_noise[3], 6'b10_0001};
            3'd7:   noise = {6'b100_000, i_noise[3]};
            default: noise = {i_noise[3], 6'b00_0000};  //no error or 1-bit error
        endcase
    end
    
    assign o_data = i_data ^ {i_noise[4], noise};
endmodule
