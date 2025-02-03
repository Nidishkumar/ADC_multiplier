//--------------------------------------------------------------------------------
// Module name: qmul_f
// Module Description: This module performs multiplication of two 32-bit floating-point numbers
// in IEEE 754 format, specifically for unsigned numbers. It manages the sign, exponent, and mantissa,
// with normalization and rounding. Special cases like infinity, zero, and NaN are also handled as per
// IEEE 754 specifications.
//
// Author: 
// Date: 14-10-2024
// Version: v1.0
//--------------------------------------------------------------------------------

module qmul_f #(
    parameter I     = 9,                                                                                           // Number of integer bits
    parameter F     = 23,                                                                                          // Number of fractional bits
    parameter bias  = 8'd127                                                                                          // Bias for single-precision floating-point (2^7)-1
)(
    input  logic             clk_i,                                                                                //clk_i is 100MHz
    input  logic             rst_i,
    input  logic [(I+F-1):0] a_i,                                                                                  // Input A (32-bit IEEE 754 floating-point)
    input  logic [(I+F-1):0] b_i,                                                                                  // Input B (32-bit IEEE 754 floating-point)
    output logic [(I+F-1):0] result_o                                                                              // Output result (32-bit IEEE 754 floating-point)
);

    // Decompose input a_i into sign, exponent, and mantissa
    logic sign_a;
    logic [(I-2):0] exp_a;
    logic [(F-1):0] mant_a;
    logic [F:0]     mant_a_extended;

    // Decompose input b_i into sign, exponent, and mantissa
    logic sign_b;
    logic [(I-2):0] exp_b;
    logic [(F-1):0] mant_b;
    logic [F:0]     mant_b_extended;

    // Result variables
    logic               result_sign;
    logic [(I-2):0]     exp_sum;                                                                                    // To hold sum of exponents (with extra bit for overflow)
    logic [(F*2)+1:0]   mant_product;                                                                               // Product of mantissas
    logic [(F-1):0]     result_mant;
    logic [(I-2):0]     result_exp;
    logic [(I+F-1):0]   result;

    // Special constants for IEEE 754
    logic [(I+F-1):0] zero_result, infinity_result, NaN;
    assign zero_result     = {1'b0, {(I+F-1){1'b0}}};                                                               // Zero with appropriate sign
    assign infinity_result = {1'b0, 8'b11111111, {(F-1){1'b0}}};                                                    // Infinity
    assign NaN             = {1'b0, 8'b11111111, 23'b10000000};                                                     // Standard quiet NaN

    // Break down input a_i
    assign sign_a          = a_i[(I+F-1)];
    assign exp_a           = a_i[(I+F-2):F];
    assign mant_a          = a_i[(F-1):0];
    assign mant_a_extended = (exp_a == 0) ? {1'b0, mant_a} : {1'b1, mant_a};                                        // Handle subnormal case

    // Break down input b_i
    assign sign_b          = b_i[(I+F-1)];
    assign exp_b           = b_i[(I+F-2):F];
    assign mant_b          = b_i[(F-1):0];
    assign mant_b_extended = (exp_b == 0) ? {1'b0, mant_b} : {1'b1, mant_b};                                        // Handle subnormal case

    // Result sign (XOR of signs of operands)
    assign result_sign = sign_a ^ sign_b;

    // Handle zero cases
    always_comb begin

        exp_sum = '0;
        mant_product = '0;
        result_mant = '0;
        result_exp = '0;

        if ((exp_a == 0 && mant_a == 0) || (exp_b == 0 && mant_b == 0)) begin
            result = zero_result;                                                                                   // Zero case
        end 
        else if ((exp_a == 8'b11111111 && mant_a == 0) || (exp_b == 8'b11111111 && mant_b == 0)) begin
            result = infinity_result;                                                                               // Handle Infinity case
        end 
        else if ((exp_a == 8'b11111111 && mant_a != 0) || (exp_b == 8'b11111111 && mant_b != 0)) begin
            result = NaN;                                                                                           // Handle NaN case
        end 
        else begin
            // Step 1: Add exponents and subtract bias
            exp_sum = exp_a + exp_b - bias;

            // Step 2: Multiply the mantissas
            mant_product = mant_a_extended * mant_b_extended;

            // Step 3: Normalize the result
            if (mant_product[(2*F) + 1]) begin
                // Leading 1 in the MSB of the mantissa product
                result_mant = mant_product[((2*F)+1):(F+2)];                                                        // Top 23 bits
                result_exp = exp_sum + 8'd1;                                                                           // Adjust exponent
            end 
            else begin
                result_mant = mant_product[(2*F)-1:F];                                                              // Top 23 bits
                result_exp = exp_sum;                                                                               // No adjustment
            end

            // Step 4: Handle overflow or underflow in exponent
            if (result_exp >= 8'b11111111) begin
                result = infinity_result;                                                                           // Overflow
            end 
            else if (result_exp <= 0) begin
                result = zero_result;                                                                               // Underflow
            end 
            else begin
                result = {result_sign, result_exp, result_mant};                                                    // Normal case
            end
        end
    end

    always_ff @( posedge clk_i or posedge rst_i ) begin
        if (rst_i) 
            result_o    <=   '0;
        else
            result_o    <=   result;
    end 
endmodule

