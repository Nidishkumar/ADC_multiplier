//--------------------------------------------------------------------------------
// Module name: adc_mul
// Module Description: This is the top wrapper for the ADC Multiplier. It comprises of 32 - bit floating point
// multiplier and 32 bit floating divider. Also fixed point to floating point conversion
// as well as float to  fixed point conversion are instantiated.  
//
// Author: 
// Date: 14-10-2024
// Version: v1.0
//--------------------------------------------------------------------------------
module adc_mul                  // #(parameter y_i = 12'b001000000000)							  //constant value y_i == 512
(
    // input  logic         clk_i,                                               //clk signal for triggering the input                                  
    // input  logic         rst_i,                                               //rst signal is to bring the output signal from unknown state to known state
    // input  logic [11:0]  x_i,                                                 //fixed point input-1 of adc_multiplier
    // input  logic [11:0]  y_i,                                                 //fixed point input-2
    // input  logic [11:0]  z_i,                                                 //fixed point input-3 of adc_multiplier
    // output logic         clk_o,
    // output logic [11:0]  fp_o                                                 //fixed point output of  adc_multiplier

    input  logic         clk_i,                                               //clk signal for triggering the input                                  
    input  logic         rst_i,                                               //rst signal is to bring the output signal from unknown state to known state
    input  logic [11:0]  x_i,                                                 //fixed point input-1 of adc_multiplier
    input  logic [11:0]  y_i,                                                 //fixed point input-2
    input  logic [11:0]  z_i,                                                 //fixed point input-3 of adc_multiplier
    output logic         clk_o,
    output logic [11:0]  fp_o                                                 //fixed point output of  adc_multiplier


); 

	//for rtl_drop0 (14 oct 2024) z_i port size is 12 - bits. As per specification z_i is 10 - bits, for the implementation drop z_i[11] and z_i[10]
	//to have the port width of z_i = 10 - bits.
	
	//for rtl_drop0 (14 oct 2024) y_i port size is 12 - bits. As per specification y_i is 10 - bits, for the implementation drop y_i[11] and y_i[10]
	//to have the port width of y_i = 10 - bits.
	
	assign clk_o = clk_i;
    
    //intermediate signlas
    logic [31:0]    x_fp;                                                       //floating point output for input-1           
    logic [31:0]    y_fp;                                                       //floating point output for input-2
    logic [31:0]    z_fp;                                                       //floating point output for input-3
    logic [31:0]    mul_o_fp;                                                   //floating point output for multiplier
    logic [31:0]    div_o_fp;                                                   //floating point output for divider
    logic [31:0]    x_ffp;                                                      //floating point output for input-1 with 1 clock delay
 
//    logic [31:0] float_x_reg, float_y_reg, float_z_reg;
//    logic [31:0] div_out_reg, mul_out_reg;
    fixed_to_float converter1 (	
								.clk_i	    (clk_i) ,
								.rst_i	    (rst_i) ,
                                .fixed_in   (x_i)  ,
                                .float_out  (x_fp)  
                               );    

    fixed_to_float converter2 (
	 							.clk_i	    (clk_i) ,
								.rst_i	    (rst_i) ,
                                .fixed_in   (y_i)   ,
                                .float_out  (y_fp)  
                              );
    
    fixed_to_float converter3 (
	 							.clk_i      (clk_i) ,
								.rst_i		(rst_i) ,
                                .fixed_in   (z_i)   ,
                                .float_out  (z_fp)  
                              );
    
/*   always_ff @(posedge clk_i or posedge rst_i) begin
        if (rst_i) begin
            float_x_reg <= 32'b0;
            float_y_reg <= 32'b0;
            float_z_reg <= 32'b0;
        end else begin
            float_x_reg <= x_fp;
            float_y_reg <= y_fp;
            float_z_reg <= z_fp;
        end
    end
*/   
    qdiv_f div1 (
		.clk_i		    (clk_i)		    ,
		.rst_i			(rst_i)		    ,
        .a_i            (y_fp)          ,
        .b_i            (z_fp)          ,
        .result_o       (div_o_fp)
    );
    
/*  always_ff @(posedge clk_i or posedge rst_i) begin
        if (rst_i) begin
            div_out_reg <= 32'b0;
        end else begin
            div_out_reg <= div_o_fp;
        end
    end
*/
    // 1 clock delay to match with the qdiv_f
    always_ff @( posedge clk_i or posedge rst_i ) begin 
        if(rst_i)begin
            x_ffp <= '0;
        end
        else  begin
            x_ffp <= x_fp;
        end
    end    

    
    qmul_f mul1 (
		.clk_i 	    	(clk_i)			,
		.rst_i   		(rst_i)		    ,
        .a_i            (x_ffp)         ,
        .b_i            (div_o_fp)      ,
        .result_o       (mul_o_fp)
    );
    
/*  always_ff @(posedge clk_i or posedge rst_i) begin
        if (rst_i) begin
            mul_out_reg <= 32'b0;
        end else begin
            mul_out_reg <= mul_o_fp;
        end
    end
*/    
    float_to_fixed converter4 (	
								.clk_i 		    (clk_i)		     ,
								.rst_i			(rst_i)			 ,
                                .float_input    (mul_o_fp)       ,
                                .fixed_out      (fp_o)
                              );
  
                
endmodule
//-----------------------------------fixed_to_float------------------------------------------------
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

//-----------------------------------qdiv_f------------------------------------

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


//-------------------------------qmul_f-------------------------------------------------

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

//------------------------------------float_to_fixed------------------------------



module float_to_fixed
(
    input   logic        clk_i,
    input   logic        rst_i,
    input   logic [31:0] float_input,                                                                        // 32-bit unsigned floating point input
    output  logic [11:0] fixed_out                                                                           // 12-bit unsigned fixed point output
);
    logic        sign;
    logic [7:0]  exponent;
    logic [23:0] mantissa;
    logic [23:0] temp_fixed;                                                                                 // Temporary fixed point value
    logic [7:0]  exponent_bias;                                                                              // Bias for single precision
    logic [8:0]  actual_exponent;
    logic [11:0] fixed_output;

    always_comb begin
        actual_exponent = 9'b0;
        exponent_bias = 8'd127;
        // Extract sign, exponent, and mantissa
        sign        = float_input[31];                                                                     // For unsigned, this will always be 0
        exponent    = float_input[30:23];
        mantissa    = {1'b1, float_input[22:0]};                                                             // Include implicit leading 1

        // Initialize temp_fixed to zero
        temp_fixed  = 24'b0;
        if (exponent < exponent_bias) begin
            // If exponent is zero, the number is either zero or denormalized
            fixed_output = 12'b0;
        end else if (exponent == 8'hFF) begin
            // Handle special cases: Inf or NaN
            fixed_output = (mantissa == 24'b0) ? 12'b111111111111 : 12'b000000000000;                       // NaN or Inf
        end else begin
            // Calculate the actual exponent
            actual_exponent = exponent - exponent_bias;
            if (actual_exponent < 0 && sign == 1'b1 ) begin                                                                  // If the actual exponent is negative, result is less than 1                                                                          
                fixed_output = 12'b0;                                                                       // Result is less than 1, so it's zero in fixed-point
            end else if (actual_exponent >= 12) begin                                                       // If the actual exponent is too large for 12 bits, saturate to max value
                fixed_output    = 12'b111111111111;                                                            // Max value for unsigned 12 bits
            end else begin                                                                                  // Shift mantissa based on actual_exponent to convert to fixed-point
                temp_fixed = mantissa >> (9'd23 - actual_exponent);                                         // Right shift to fit into 12 bits
                fixed_output = temp_fixed[11:0];                                                            // Only take the least significant 12 bits as fixed point value
            end
        end
        // if (sign == 1'b1) begin
        //     fixed_output = 12'b0;  // This can be adjusted based on your desired behavior for negative values
        // end
    end
    // assign  fixed_output =   (exponent < exponent_bias)  ? 12'b0 :
    //                         (exponent == 8'hFF)         ? ((mantissa == 24'b0) ? 12'b111111111111 : 12'b000000000000) : (actual_exponent = exponent - exponent_bias):
    //                         (actual_exponent < 0)       ? 12'b0 :
    //                         (actual_exponent >= 12)     ? 12'b111111111111 :(temp_fixed = mantissa >> (8'd23 - actual_exponent), temp_fixed[11:0])):
    //                         (sign == 1'b1)              ? 12'b0;
    always_ff @( posedge clk_i or posedge rst_i ) begin
        if (rst_i) begin
            fixed_out     <=   12'b0;
        end
        else begin
            fixed_out     <=   fixed_output;
        end        
    end
endmodule

 



