`timescale 1ns / 1ps

module hamming74_decoder(
    input [6:0] i_data,
    input i_parity,
    output [3:0] o_data,
    output o_1bit_error,
    output o_2bit_error,
    output o_parity_error,
    output [6:0] o_syndrome
    );
    
    //logics
    reg p1, p2, p4;
    reg [6:0] syndrome; //the value for the bit to be corrected
    wire [6:0] data_decoded;
    wire overall_parity;
    
    // logic for p1, p2, p4 i.e the syndrome
    always  @(*) begin
        p1 = i_data[0] ^ i_data[2] ^ i_data[4] ^ i_data[6];
        p2 = i_data[1] ^ i_data[2] ^ i_data[5] ^ i_data[6];
        p4 = i_data[3] ^ i_data[4] ^ i_data[5] ^ i_data[6];
    end
    
    //3x8 decoder
    always @(*) begin
        case({p4,p2,p1})
            3'd1: syndrome = 7'b0000_001;
            3'd2: syndrome = 7'b0000_010;
            3'd3: syndrome = 7'b0000_100;
            3'd4: syndrome = 7'b0001_000;
            3'd5: syndrome = 7'b0010_000;
            3'd6: syndrome = 7'b0100_000;
            3'd7: syndrome = 7'b1000_000;
            default: syndrome = 7'b0000_000;
        endcase
    end
    
    assign data_encoded = syndrome ^ i_data;
    assign o_syndrome = syndrome;   //only for debug
    
    //overall parity
    assign overall_parity = ^{i_parity, i_data};
    
/*

Syndrome Overall Parity Error Type Notes
==0         0                No Error
!=0       1                Single Error Correctable. Syndrome holds incorrect bit position.
!=0       0                Double Error Not correctable.
0         1                Parity Error Overall parity, parity is in error and can be corrected.

*/

    assign o_1bit_error = ({p4,p2,p1} != 3'b0) & overall_parity;
    assign o_2bit_error = ({p4,p2,p1} != 3'b0) & ~overall_parity;
    assign o_1bit_error = ({p4,p2,p1} == 3'b0) & overall_parity;
    
    //now rearange the data bits
    //input:  d7 d6 d5 p4 d3 p2 p1
    //output: d3 d2 d1    d0
    assign o_data = {data_decoded[6:4], data_decoded[2]};
endmodule
   
    
            
            
            
            
            
            
            
            
            