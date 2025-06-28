module hamming_secded (     // this is the TOP level module
  input  [3:0] i_secded,
  input  [4:0] i_noise,
  output [6:0] o_7seg,
  output [3:0] o_secded,
  output       o_1bit_error,
  output       o_2bit_error,
  output       o_parity_error
);

  // Internal logic (glue logic)
  wire [6:0] enc_hamming_code;     // Outputs for the Hamming encoder
  wire       enc_parity;

  wire [6:0] o_noise_hamming_code; // Outputs for the noise module
  wire       o_noise_parity;

  wire [6:0] o_syndrome;           // Outputs for the Hamming decoder
  wire [2:0] in_7seg;              // Input for the 7Segment display decoder


  // Instantiate the Hamming74 Encoder
  hamming74_encoder HAMM_ENC(
    .i_data        (i_secded),
    .o_hamming_code(enc_hamming_code),
    .o_parity      (enc_parity)
  );

  // Instantiate the noise module
  noise_add NOISE0(
    .i_data  ({enc_parity, enc_hamming_code}),
    .i_noise (i_noise),
    .o_data  ({o_noise_parity, o_noise_hamming_code})
  );

  // Instantiate the Hamming74 DEcoder
  hamming74_decoder HAMM_DEC0(
    .i_data       (o_noise_hamming_code),
    .i_parity     (o_noise_parity),
    .o_syndrome   (o_syndrome),
    .o_data       (o_secded),
    .o_1bit_error (o_1bit_error),
    .o_2bit_error (o_2bit_error),
    .o_parity_error(o_parity_error)
  );
  // Instantiate the priority encoder
    prio_enc_8to3 PRIO0 (
  .d({1'b0, o_syndrome}),  // 8-bit input
  .q(in_7seg),             // 3-bit output
  .v()                     // output unused
);

//Instantiate a 7seg decoder (optional)

hex_7seg_decoder
//# (COMMON_ANODE_CATHODE = 0) // 0 for common Anode / 1 for common cathode
HEX0
(
  .in({1'b0, in_7seg}),
  .o_a(o_7seg[0]),
  .o_b(o_7seg[1]),
  .o_c(o_7seg[2]),
  .o_d(o_7seg[3]),
  .o_e(o_7seg[4]),
  .o_f(o_7seg[5]),
  .o_g(o_7seg[6])
  //output dot // optional - NOT used on DE1-SoC board
);

endmodule