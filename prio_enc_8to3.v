`timescale 1ns / 1ps
module prio_enc_8to3 (
  input [7:0] d,
  output reg [2:0] q,
  output reg v
);

always @ (*) begin
  case (1) // checks if a signal is set
    d[7]: begin q = 3'd7; v = 1'b1; end
    d[6]: begin q = 3'd6; v = 1'b1; end
    d[5]: begin q = 3'd5; v = 1'b1; end
    d[4]: begin q = 3'd4; v = 1'b1; end
    d[3]: begin q = 3'd3; v = 1'b1; end
    d[2]: begin q = 3'd2; v = 1'b1; end
    d[1]: begin q = 3'd1; v = 1'b1; end
    default: begin q = 3'd0; v = 1'b0; end
  endcase
end

endmodule