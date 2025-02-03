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

