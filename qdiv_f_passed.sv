//--------------------------------------------------------------------------------
// Module name: qdiv_f
// Module Description: This module performs division of two 32-bit floating-point numbers in
// IEEE 754 format, focusing on unsigned numbers. It ensures normalization, exponent adjustment,
// and rounding, while addressing edge cases such as division by zero, infinity, and NaN conditions.
//
// Author: 
// Date: 14-10-2024
// Version: v1.0
//--------------------------------------------------------------------------------
 module qdiv_f #(
    parameter I = 9,
    parameter F = 23,
    parameter bias = 8'd127
)
(
    input  logic             clk_i,
    input  logic             rst_i,
    input  logic [(I+F-1):0] a_i,                                               // Dividend (32-bit IEEE 754)
    input  logic [(I+F-1):0] b_i,                                               // Divisor (32-bit IEEE 754)
    output logic [(I+F-1):0] result_o                                           // Result (32-bit IEEE 754)
);

    // Decompose input A into sign, exponent, and mantissa
    logic                 sign_a;
    logic   [(I-2):0]     exp_a;
    logic   [(F-1):0]     mant_a;
    logic   [F:0]         mant_a_extended;

    // Decompose input B into sign, exponent, and mantissa
    logic                 sign_b;
    logic   [(I-2):0]     exp_b;
    logic   [(F-1):0]     mant_b;
    logic   [F:0]         mant_b_extended;

    // Result variables
    logic                 result_sign;
    logic   [(I-2):0]     exp_diff;
    logic   [(2*F)+1:0]   mant_quotient;                                        // Extra bit for rounding
    logic   [(F-1):0]     result_mant;
    logic   [(I-2):0]     result_exp;
    logic   [(I+F-1):0]   result;
	//logic 	[(F-1):0]	  result1;
    
    // Special constants for IEEE 754
    logic   [(I+F-1):0] zero_result, infinity_result, NaN;

    assign zero_result     = {result_sign, 31'b0};                              // Zero with sign
    assign infinity_result = {result_sign, 8'b11111111, 23'b0};                 // Infinity
    assign NaN             = 32'h7FC00000;                                      // Quiet NaN

    // Break down input A
    assign sign_a          = a_i[(I+F-1)];
    assign exp_a           = a_i[(I+F-2):F];
    assign mant_a          = a_i[(F-1):0];
    assign mant_a_extended = (exp_a == 0) ? {1'b0, mant_a} : {1'b1, mant_a};

    // Break down input B
    assign sign_b          = b_i[(I+F-1)];
    assign exp_b           = b_i[(I+F-2):F];
    assign mant_b          = b_i[(F-1):0];
    assign mant_b_extended = (exp_b == 0) ? {1'b0, mant_b} : {1'b1, mant_b};

    // Result sign (XOR of signs of operands)
    assign result_sign = sign_a ^ sign_b;

    // Handle zero and infinity cases
    always_comb begin

        exp_diff = '0;
//      mant_quotient = '0;                                        
        result_mant = '0;
        result_exp = '0;
		//result1 = '0;

        if (exp_a == 0 && mant_a == 0 && exp_b == 0 && mant_b == 0) begin
            // Case: 0 / 0 -> NaN
            result = NaN;
        end else if (exp_a == 0 && mant_a == 0) begin
            // Case: 0 / non-zero -> 0
            result = zero_result;
        end else if (exp_b == 0 && mant_b == 0) begin
            // Case: non-zero / 0 -> Infinity
            result = infinity_result;
        end else if (exp_a == 8'b11111111 || exp_b == 8'b11111111) begin
            // Handle Infinity or NaN case (a or b are infinity)
            if (exp_a == 8'b11111111 && exp_b == 8'b11111111) begin
                result = NaN;                                                   // Infinity / Infinity = NaN
            end else begin
                result = infinity_result;                                       // Infinity case
            end
        end else begin
            // Step 1: Subtract exponents and add bias
            exp_diff = exp_a - exp_b + bias;

            // Step 2: Divide the mantissas
//            mant_quotient = (mant_a_extended << F) / mant_b_extended;           // 2F bit quotient

            // Step 3: Normalize the result
            if (mant_quotient[F+1]) begin
                // Leading 1 in MSB of quotient
                result_mant = mant_quotient[F:1];                               // Take the top F bits
                result_exp = exp_diff + 8'd1;                                   // Adjust exponent
            end else begin
                result_mant = mant_quotient[F-1:0];                             // Take the top F bits
                result_exp = exp_diff;                                          // No adjustment
            end

            // Step 4: Rounding
            

            // if (mant_quotient[0] == 1) begin
            //     result1 = result_mant + 23'd1;                                  // Round up if LSB is 1
            //     if (result1 == 24'b100000000000000000000000) begin
            //         result_mant = 23'b0;                                         // Overflow in mantissa
            //         result_exp = result_exp + 1;                                // Adjust exponent
            //     end
            //     else
            //         result_mant = result1;
            // end

            // Step 5: Handle overflow or underflow in exponent
            if (result_exp >= 8'b11111111) begin         
                result = infinity_result;                                       // Overflow
            end else if (result_exp <= 0) begin     
                result = zero_result;                                           // Underflow
            end else begin
                result = {result_sign, result_exp, result_mant};                // Normal case
            end
        end
    end

    always_ff @( posedge clk_i or posedge rst_i ) begin 
        if (rst_i) begin
            mant_quotient   <=   '0;            
        end
        else if (!((exp_a == 8'b11111111 || exp_b == 8'b11111111) || (exp_b == 0 && mant_b == 0) || (exp_a == 0 && mant_a == 0))) begin
            mant_quotient <= ({{24{1'b0}},mant_a_extended}) / mant_b_extended;           // 2F bit quotient
        end
    end

    always_ff @( posedge clk_i or posedge rst_i ) begin 
        if (rst_i) begin
            result_o    <=   '0;            
        end
        else begin
            result_o    <=   result;
        end
    end
    
endmodule

