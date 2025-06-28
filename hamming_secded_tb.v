`define ERROR 1
`define NO_ERROR 0

`timescale 1ns/1ps
module tb_hamming74_enc_dec();

  // Declare the testbench variables
  reg [3:0] i_secded;
  reg [4:0] i_noise;

  wire [6:0] o_7seg;
  wire [3:0] o_secded;
  wire o_1bit_error;
  wire o_2bit_error;
  wire o_parity_error;

  // TB variables
  integer success_count = 0, error_count = 0, test_count = 0, i = 0;

  // Instantiate the SECDED DUT
  hamming_secded SECDED0 ( // this is the TOP level module
    .i_secded (i_secded),
    .i_noise  (i_noise),
    .o_7seg   (o_7seg),    // optional
    .o_secded (o_secded),
    .o_1bit_error (o_1bit_error),
    .o_2bit_error (o_2bit_error),
    .o_parity_error(o_parity_error)
  );

  // Test scenario
  initial begin
    $display($stime, " TEST START");

    $display($stime, "\n TEST1: No bit error");
    for(i=0; i<16; i=i+1) begin
      i_secded = i[3:0]; i_noise = 0;
      #1; compare_data(i_secded, o_secded, `NO_ERROR, `NO_ERROR, `NO_ERROR);
    end

    #10; // pause between tests
    $display($stime, "\n TEST2: 1bit error");
    for(i=0; i<16; i=i+1) begin
      i_secded = i[3:0];
      i_noise = (i==16) ? 5'b10000 : $urandom_range(7,1);
      #1;
      if(i<16)
          compare_data(i_secded, o_secded, `ERROR, `NO_ERROR, `NO_ERROR);
      else
          compare_data(i_secded, o_secded, `NO_ERROR, `NO_ERROR, `ERROR);   //trigger a parity error
  end
  
    #10; // pause between tests
    $display($stime, "\n TEST3: 2bit error");
    for(i=0; i<16; i=i+1) begin
      i_secded = i[3:0];
      i_noise = (1 << 3) | $urandom_range(7,1);
      #1; compare_data(i_secded, o_secded, `NO_ERROR, `ERROR, `NO_ERROR);
    end
    
    // $display($stime, " TEST4: 3bit error - add more tests to see what happens");
    #10; // pause between tests
    $display($stime, "\n TEST4: Parity altered + 2bit error = 3bit error (Not correctable, partially detectable)");
    i_secded = 4'd8;
    i_noise = (1 << 4) | (1 << 3) | $urandom_range(7,1);
    #1; i_secded = 0; i_noise = 0;
    
    #10; // pause between tests
    $display($stime, "\n TEST5: No bit error (again)");
    i_secded = 4'b1010; i_noise = 0;
    #1; compare_data(i_secded, o_secded, `NO_ERROR, `NO_ERROR, `NO_ERROR);
    
    #10; // pause between tests
    
    // Print statistics
    $display($stime, " TEST STOP. \n\t\t RESULTS success_count = %0d, error_count = %0d, test_count = %0d",
      success_count, error_count, test_count);
    
    $stop;
end

    task compare_data(input [3:0] i_secded, input [3:0] o_secded, input exp_1bit_error, input exp_2bit_error, input exp_parity_error);
    begin: cmp_data
        reg [6:0] exp_hamming74;
        
        // The decoded data (o_secded) is compared only in the case of 1bit or parity errors
        if (!exp_2bit_error) begin
            if ((i_secded === o_secded) && 
                (exp_1bit_error === o_1bit_error) && 
                (exp_parity_error === o_parity_error)) begin
                $display ($time,"SUCCESS \t i_secded = %b, o_secded = %b, 1bit_error = %b, parity_error = %b | SECDED_IN = %b | SECDED_OUT = %b",
                                i_secded, o_secded, exp_1bit_error, exp_parity_error, i_secded, o_secded);
                success_count = success_count + 1;
            end else begin
                $display ($time,"ERROR \t i_secded = %b, o_secded = %b, 1bit_error = %b, parity_error = %b | SECDED_IN = %b | SECDED_OUT = %b",
                                i_secded, o_secded, exp_1bit_error, exp_parity_error, i_secded, o_secded);
                error_count = error_count + 1; 
            end 
        end else begin
            if (exp_2bit_error === o_2bit_error) begin
                $display ($time,"SUCCESS \t i_secded = %b, o_secded = %b, 2bit_error = %b, parity_error = %b | SECDED_IN = %b | SECDED_OUT = %b",
                                i_secded, o_secded, exp_2bit_error, exp_parity_error, i_secded, o_secded);
                success_count = success_count + 1;
            end else begin
                $display ($time,"ERROR \t i_secded = %b, o_secded = %b, 2bit_error = %b, parity_error = %b | SECDED_IN = %b | SECDED_OUT = %b",
                                i_secded, o_secded, exp_2bit_error, exp_parity_error, i_secded, o_secded);
                error_count = error_count + 1; 
            end 
        end               
        test_count = test_count + 1;
    end: cmp_data
    endtask
    
endmodule
      
      
//`timescale 1ns / 1ps
//`define ERROR     1
//`define NO_ERROR  0

//module tb_hamming74_enc_dec;

//  // Inputs
//  reg  [3:0] i_secded;
//  reg  [4:0] i_noise;

//  // Outputs
//  wire [6:0] o_7seg;
//  wire [3:0] o_secded;
//  wire       o_1bit_error;
//  wire       o_2bit_error;
//  wire       o_parity_error;

//  // Testbench counters
//  integer success_count = 0;
//  integer error_count   = 0;
//  integer test_count    = 0;
//  integer i;

//  // Instantiate the top module (DUT)
//  hamming_secded uut (
//    .i_secded       (i_secded),
//    .i_noise        (i_noise),
//    .o_7seg         (o_7seg),
//    .o_secded       (o_secded),
//    .o_1bit_error   (o_1bit_error),
//    .o_2bit_error   (o_2bit_error),
//    .o_parity_error (o_parity_error)
//  );

//  // Initial Block - Main Test Routine
//  initial begin
//    $display("===== HAMMING SECDED TEST START =====");

//    test_no_error();
//    test_single_bit_error();
//    test_double_bit_error();
//    test_three_bit_error();
//    test_no_error_again();

//    $display("===== HAMMING SECDED TEST END =====");
//    $display("Results: Success = %0d, Error = %0d, Total = %0d",
//              success_count, error_count, test_count);
//    $stop;
//  end

//  // ===============================
//  // TEST 1: No Error
//  // ===============================
//  task test_no_error;
//    begin
//      $display("\n[TEST1] No Bit Error");

//      for (i = 0; i < 16; i = i + 1) begin
//        i_secded = i[3:0];
//        i_noise  = 5'b00000;
//        #1;
//        compare_data(i_secded, o_secded, `NO_ERROR, `NO_ERROR, `NO_ERROR);
//      end
//    end
//  endtask

//  // ===============================
//  // TEST 2: Single Bit Error
//  // ===============================
//  task test_single_bit_error;
//    begin
//      $display("\n[TEST2] Single Bit Error");

//      for (i = 0; i < 16; i = i + 1) begin
//        i_secded = i[3:0];
//        i_noise = $urandom_range(6, 0);
//        #1;
//        compare_data(i_secded, o_secded, `ERROR, `NO_ERROR, `NO_ERROR);
//      end
//    end
//  endtask

//  // ===============================
//  // TEST 3: Double Bit Error
//  // ===============================
//  task test_double_bit_error;
//    begin
//      $display("\n[TEST3] Double Bit Error");

//      for (i = 0; i < 16; i = i + 1) begin
//        i_secded = i[3:0];
//        // Inject two bits flipped
//        i_noise = (1 << $urandom_range(6,0)) | (1 << $urandom_range(6,0));
//        #1;
//        compare_data(i_secded, o_secded, `NO_ERROR, `ERROR, `NO_ERROR);
//      end
//    end
//  endtask

//  // ===============================
//  // TEST 4: Triple Bit Error (Parity + 2bits)
//  // ===============================
//  task test_three_bit_error;
//    begin
//      $display("\n[TEST4] Triple Bit Error (Uncorrectable)");

//      i_secded = 4'd8;
//      i_noise  = (1 << 4) | (1 << 2) | (1 << 0); // Flip 3 bits
//      #1;
//      compare_data(i_secded, o_secded, `NO_ERROR, `ERROR, `ERROR);
//    end
//  endtask

//  // ===============================
//  // TEST 5: No Error Again
//  // ===============================
//  task test_no_error_again;
//    begin
//      $display("\n[TEST5] No Bit Error (Again)");

//      i_secded = 4'b1010;
//      i_noise  = 5'b00000;
//      #1;
//      compare_data(i_secded, o_secded, `NO_ERROR, `NO_ERROR, `NO_ERROR);
//    end
//  endtask

//  // ===============================
//  // Comparison Task
//  // ===============================
//task compare_data(
//  input [3:0] i_secded,
//  input [3:0] o_secded,
//  input       exp_1bit_error,
//  input       exp_2bit_error,
//  input       exp_parity_error
//);
//begin
//  if (!exp_2bit_error) begin
//    if ((i_secded === o_secded) &&
//        (o_1bit_error === exp_1bit_error) &&
//        (o_parity_error === exp_parity_error)) begin
//      $display("PASS @%0t ns: IN = %b, OUT = %b, 1bit = %b, parity = %b",
//               $time, i_secded, o_secded, o_1bit_error, o_parity_error);
//      success_count = success_count + 1;
//    end else begin
//      $display("FAIL @%0t ns: IN = %b, OUT = %b, 1bit = %b, parity = %b",
//               $time, i_secded, o_secded, o_1bit_error, o_parity_error);
//      error_count = error_count + 1;
//    end
//  end else begin
//    if (o_2bit_error === exp_2bit_error) begin
//      $display("PASS @%0t ns: IN = %b, OUT = %b, 2bit = %b, parity = %b",
//               $time, i_secded, o_secded, o_2bit_error, o_parity_error);
//      success_count = success_count + 1;
//    end else begin
//      $display("FAIL @%0t ns: IN = %b, OUT = %b, 2bit = %b, parity = %b",
//               $time, i_secded, o_secded, o_2bit_error, o_parity_error);
//      error_count = error_count + 1;
//    end
//  end

//  test_count = test_count + 1;
//end
//endtask


//endmodule
