//--------------------------------------------------------------------------------
// Module name: fixed_to_float
// Module Description: This module converts a 12-bit unsigned fixed-point number into a 32-bit IEEE 754
// single-precision (32-bit) floating-point format. It calculates the exponent and normalizes the mantissa, handling
// denormalized values and ensuring proper rounding for edge cases, including zero and overflow conditions.
//
// Author: 
// Date: 14-10-2024
// Version: v1.0
//--------------------------------------------------------------------------------
module fixed_to_float ( 
                            input  logic        clk_i       ,
                            input  logic        rst_i       ,
                            input  logic [11:0] fixed_in    ,                                   // 12-bit unsigned fixed-point input
                            output logic [31:0] float_out                                       // 32-bit IEEE 754 floating-point output
                      );

    // Internal signals
    logic [7:0]  exponent;                                                                      // 8-bit exponent field
    logic [22:0] mantissa;                                                                      // 23-bit mantissa field
    logic [11:0] temp_fixed;                                                                    // Temporary variable for the fixed-point input
    logic [4:0]  leading_zeros;                                                                 // Number of leading zeros in the fixed-point input
 //   logic [31:0] result;


    // Step 1: Calculate leading zeros, exponent, and mantissa
    always_comb begin

        // Initialize signals

        temp_fixed = 12'b0;         
        leading_zeros = 5'b0;
        exponent = 8'b0;
        mantissa = 23'b0;

        // Step 1: Find the position of the first '1' from the left (leading zeros)
        if (fixed_in == 12'b0) begin
            leading_zeros = 5'd12;                                                                // Special case for zero
        end else begin

    if (fixed_in[11:6] != 6'b000000) begin
        if (fixed_in[11:9] != 3'b000)
            leading_zeros = (fixed_in[11]) ? 5'd0 : (fixed_in[10]) ? 5'd1 : 5'd2;
        else
            leading_zeros = (fixed_in[8]) ? 5'd3 : (fixed_in[7]) ? 5'd4 : 5'd5;
    end else begin
        if (fixed_in[5:3] != 3'b000)
            leading_zeros = (fixed_in[5]) ? 5'd6 : (fixed_in[4]) ? 5'd7 : 5'd8;
        else
            leading_zeros = (fixed_in[2]) ? 5'd9 : (fixed_in[1]) ? 5'd10 : 5'd11;
    end

        end


        // Step 2: Calculate exponent and mantissa for non-zero values
        if (fixed_in != 0) begin
            // Exponent = 127 + (11 - leading_zeros)
            exponent = 8'd127 + (5'd11 - leading_zeros);

            // Mantissa = fixed_in shifted left by (leading_zeros + 1) bits (to drop the leading '1')
            temp_fixed = fixed_in << leading_zeros;                                           // Shift left by `leading_zeros`
            mantissa = temp_fixed[10:0] << 23'd12;   // << 23'd12                                          // Align to 23-bit mantissa by shifting left
            //result  = {1'b0, exponent, mantissa};   
        end

 //   result  = {1'b0, exponent, mantissa};  
    end

    // Step 3: Construct IEEE 754 floating-point format
    always_ff @( posedge clk_i or posedge rst_i ) begin 
        if  (rst_i) begin
            float_out <= 32'b0;
        end
        else  begin
            float_out <=  {1'b0, exponent, mantissa};                                                  // 1 sign bit, 8 exponent bits, 23 mantissa bits
        end
    end
    
endmodule

