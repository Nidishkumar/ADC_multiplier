//--------------------------------------------------------------------------------
// Module name: adc_mul_tb
// Module Description:  This testbench initializes and simulates the behavior of the ADC multiplier modul., 
// The testbench drives a variety of test cases, including normal multiplication, 
// edge cases like zero, overflow, and special conditions such as infinity and NaN. 
// It verifies the output against expected results to ensure proper functionality.
//
// Author: 
// Date: 14-10-2024
// Version: v1.0
//-------------------------------------------------------------------------------- 
module adc_mul_tb;
  // parameter     y_i =  12'b001000000000;                                                   // Input 12-bit y_i, the constant value for input y_i is [512]
   logic         clk_i;                                                                     // Input clock signal for the Multiplier_ADC
   logic         rst_i;                                                                     // Input reset signal for the Multiplier_ADC
   logic [11:0]  x_i;                                                                       // Input 12-bit x_i signal for the Multiplier_ADC
   logic [11:0]  z_i;                                                                       // Input 12-bit z_i signal for the Multiplier_ADC
   logic         clk_o;
   logic [11:0]  fp_o;                                                                      // Output 12-bit fixed signal for the Multiplier_ADC

   adc_mul // # ( .y_i       (y_i)   
  // )
   dut( 
               .clk_i     (clk_i)               ,                                            // Instantiation of clock signal
               .rst_i     (rst_i)               ,                                            // Instantiation of reset signal
               .x_i       (x_i)                 ,                                            // Instantiation of x_i signal
               .y_i       (12'b001000000000)    ,                                            // Instantiation of z_i signal
               .z_i       (z_i)                 ,                                            // Instantiation of z_i signal
               .fp_o      (fp_o)                ,                                            // Instantiation of fp_o signal
               .clk_o     (clk_o)
            );
            
   always #1 clk_i   =  ~ clk_i;                                                             // Generating the 500MHz clock
   initial begin

      clk_i = 0;
      rst_i = 1;
      #1;
      rst_i = 0;
      
      // Test case 1
      x_i = 12'b000000000001;
      z_i = 1.4855;
      #12;  
      assert(fp_o == 12'h200)
        begin
            $display($time,"<<<<<<<<<<<<<<<<<<<<<<<<<TEST-1 PASSED>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>");
            $display($time," x_i = %h  | z_i = %h | fp_o = %h" , x_i , z_i, fp_o);
        end
      else
        begin
            $error($time,"<<<<<<<<<<<<<<<<<<<<<<<<<<<TEST-1 FAILED>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>");
            $error($time," x_i = %h  | z_i = %h | fp_o = %h" , x_i , z_i, fp_o);
        end  

      // Test case 2
      x_i = 12'b000000000100;
      z_i = 1.7948;
      #12;
      assert(fp_o == 12'h400)
        begin
            $display($time,"<<<<<<<<<<<<<<<<<<<<<<<<<TEST-2 PASSED>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>");
            $display($time," x_i = %h  | z_i = %h | fp_o = %h" , x_i, z_i, fp_o);
        end
      else
        begin
            $error($time,"<<<<<<<<<<<<<<<<<<<<<<<<<<<TEST-2 FAILED>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>");
            $error($time," x_i = %h   | z_i = %h | fp_o = %h" , x_i, z_i, fp_o);
        end

      // Test case 3
      x_i = 12'b000000000011;
      z_i = 1.7947;
      #12;
      assert(fp_o == 12'h300)
        begin
            $display($time,"<<<<<<<<<<<<<<<<<<<<<<<<<TEST-3 PASSED>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>");
            $display($time," x_i = %h   | z_i = %h | fp_o = %h" , x_i, z_i, fp_o);
        end
      else
        begin
            $error($time,"<<<<<<<<<<<<<<<<<<<<<<<<<<<TEST-3 FAILED>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>");
            $error($time," x_i = %h   | z_i = %h | fp_o = %h" , x_i, z_i, fp_o);
        end

      // Test case 4
      x_i = 12'b000000000010;
      z_i = 1.7885;
      #12;
      assert(fp_o == 12'h200)
        begin
            $display($time,"<<<<<<<<<<<<<<<<<<<<<<<<<TEST-4 PASSED>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>");
            $display($time," x_i = %h   | z_i = %h | fp_o = %h" , x_i, z_i, fp_o);
        end
      else
        begin
            $error($time,"<<<<<<<<<<<<<<<<<<<<<<<<<<<TEST-4 FAILED>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>");
            $error($time," x_i = %h   | z_i = %h | fp_o = %h" , x_i, z_i, fp_o);
        end
      // Test case 5
      x_i = 12'b000000001000;
      z_i = 1.7810;
      #12;
      assert(fp_o == 12'h800)
        begin
            $display($time,"<<<<<<<<<<<<<<<<<<<<<<<<<TEST-5 PASSED>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>");
            $display($time," x_i = %h   | z_i = %h | fp_o = %h" , x_i, z_i, fp_o);
        end
      else
        begin
            $error($time,"<<<<<<<<<<<<<<<<<<<<<<<<<<<TEST-5 FAILED>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>");
            $error($time," x_i = %h   | z_i = %h | fp_o = %h" , x_i, z_i, fp_o);
        end
      // Test case 6
      x_i = 12'b000110000000;
      z_i = 1.7720;
      #12; 
      assert(fp_o == 12'hfff)
        begin
            $display($time,"<<<<<<<<<<<<<<<<<<<<<<<<<TEST-6 PASSED>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>");
            $display($time," x_i = %h   | z_i = %h | fp_o = %h" , x_i, z_i, fp_o);
        end
      else
        begin
            $error($time,"<<<<<<<<<<<<<<<<<<<<<<<<<<<TEST-6 FAILED>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>");
            $error($time," x_i = %h   | z_i = %h | fp_o = %h" , x_i,z_i, fp_o);
        end

      // Test case 6
      x_i = 12'b0000000000100;
      z_i = 1.7720;
      #12; 
      assert(fp_o == 12'h400)
        begin
            $display($time,"<<<<<<<<<<<<<<<<<<<<<<<<<TEST-6 PASSED>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>");
            $display($time," x_i = %h   | z_i = %h | fp_o = %h" , x_i, z_i, fp_o);
        end
      else
        begin
            $error($time,"<<<<<<<<<<<<<<<<<<<<<<<<<<<TEST-6 FAILED>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>");
            $error($time," x_i = %h   | z_i = %h | fp_o = %h" , x_i,z_i, fp_o);
        end

      // // Test case 6
      // x_i = 12'b000110000000;
      // z_i = 1.7720;
      // #12; 
      // assert(fp_o == 12'hfff)
      //   begin
      //       $display($time,"<<<<<<<<<<<<<<<<<<<<<<<<<TEST-6 PASSED>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>");
      //       $display($time," x_i = %h   | z_i = %h | fp_o = %h" , x_i, z_i, fp_o);
      //   end
      // else
      //   begin
      //       $error($time,"<<<<<<<<<<<<<<<<<<<<<<<<<<<TEST-6 FAILED>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>");
      //       $error($time," x_i = %h   | z_i = %h | fp_o = %h" , x_i,z_i, fp_o);
      //   end      
      
      // // Test case 6
      // x_i = 12'b000110000000;
      // z_i = 1.7720;
      // #12; 
      // assert(fp_o == 12'hfff)
      //   begin
      //       $display($time,"<<<<<<<<<<<<<<<<<<<<<<<<<TEST-6 PASSED>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>");
      //       $display($time," x_i = %h   | z_i = %h | fp_o = %h" , x_i, z_i, fp_o);
      //   end
      // else
      //   begin
      //       $error($time,"<<<<<<<<<<<<<<<<<<<<<<<<<<<TEST-6 FAILED>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>");
      //       $error($time," x_i = %h   | z_i = %h | fp_o = %h" , x_i,z_i, fp_o);
      //   end      // Test case 6
      // x_i = 12'b000110000000;
      // z_i = 1.7720;
      // #12; 
      // assert(fp_o == 12'hfff)
      //   begin
      //       $display($time,"<<<<<<<<<<<<<<<<<<<<<<<<<TEST-6 PASSED>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>");
      //       $display($time," x_i = %h   | z_i = %h | fp_o = %h" , x_i, z_i, fp_o);
      //   end
      // else
      //   begin
      //       $error($time,"<<<<<<<<<<<<<<<<<<<<<<<<<<<TEST-6 FAILED>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>");
      //       $error($time," x_i = %h   | z_i = %h | fp_o = %h" , x_i,z_i, fp_o);
      //   end      // Test case 6
      // x_i = 12'b000110000000;
      // z_i = 1.7720;
      // #12; 
      // assert(fp_o == 12'hfff)
      //   begin
      //       $display($time,"<<<<<<<<<<<<<<<<<<<<<<<<<TEST-6 PASSED>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>");
      //       $display($time," x_i = %h   | z_i = %h | fp_o = %h" , x_i, z_i, fp_o);
      //   end
      // else
      //   begin
      //       $error($time,"<<<<<<<<<<<<<<<<<<<<<<<<<<<TEST-6 FAILED>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>");
      //       $error($time," x_i = %h   | z_i = %h | fp_o = %h" , x_i,z_i, fp_o);
      //   end      // Test case 6
      // x_i = 12'b000110000000;
      // z_i = 1.7720;
      // #12; 
      // assert(fp_o == 12'hfff)
      //   begin
      //       $display($time,"<<<<<<<<<<<<<<<<<<<<<<<<<TEST-6 PASSED>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>");
      //       $display($time," x_i = %h   | z_i = %h | fp_o = %h" , x_i, z_i, fp_o);
      //   end
      // else
      //   begin
      //       $error($time,"<<<<<<<<<<<<<<<<<<<<<<<<<<<TEST-6 FAILED>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>");
      //       $error($time," x_i = %h   | z_i = %h | fp_o = %h" , x_i,z_i, fp_o);
      //   end      // Test case 6
      // x_i = 12'b000110000000;
      // z_i = 1.7720;
      // #12; 
      // assert(fp_o == 12'hfff)
      //   begin
      //       $display($time,"<<<<<<<<<<<<<<<<<<<<<<<<<TEST-6 PASSED>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>");
      //       $display($time," x_i = %h   | z_i = %h | fp_o = %h" , x_i, z_i, fp_o);
      //   end
      // else
      //   begin
      //       $error($time,"<<<<<<<<<<<<<<<<<<<<<<<<<<<TEST-6 FAILED>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>");
      //       $error($time," x_i = %h   | z_i = %h | fp_o = %h" , x_i,z_i, fp_o);
      //   end      // Test case 6
      // x_i = 12'b000110000000;
      // z_i = 1.7720;
      // #12; 
      // assert(fp_o == 12'hfff)
      //   begin
      //       $display($time,"<<<<<<<<<<<<<<<<<<<<<<<<<TEST-6 PASSED>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>");
      //       $display($time," x_i = %h   | z_i = %h | fp_o = %h" , x_i, z_i, fp_o);
      //   end
      // else
      //   begin
      //       $error($time,"<<<<<<<<<<<<<<<<<<<<<<<<<<<TEST-6 FAILED>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>");
      //       $error($time," x_i = %h   | z_i = %h | fp_o = %h" , x_i,z_i, fp_o);
      //   end      // Test case 6
      // x_i = 12'b000110000000;
      // z_i = 1.7720;
      // #12; 
      // assert(fp_o == 12'hfff)
      //   begin
      //       $display($time,"<<<<<<<<<<<<<<<<<<<<<<<<<TEST-6 PASSED>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>");
      //       $display($time," x_i = %h   | z_i = %h | fp_o = %h" , x_i, z_i, fp_o);
      //   end
      // else
      //   begin
      //       $error($time,"<<<<<<<<<<<<<<<<<<<<<<<<<<<TEST-6 FAILED>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>");
      //       $error($time," x_i = %h   | z_i = %h | fp_o = %h" , x_i,z_i, fp_o);
      //   end      // Test case 6
      // x_i = 12'b000110000000;
      // z_i = 1.7720;
      // #12; 
      // assert(fp_o == 12'hfff)
      //   begin
      //       $display($time,"<<<<<<<<<<<<<<<<<<<<<<<<<TEST-6 PASSED>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>");
      //       $display($time," x_i = %h   | z_i = %h | fp_o = %h" , x_i, z_i, fp_o);
      //   end
      // else
      //   begin
      //       $error($time,"<<<<<<<<<<<<<<<<<<<<<<<<<<<TEST-6 FAILED>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>");
      //       $error($time," x_i = %h   | z_i = %h | fp_o = %h" , x_i,z_i, fp_o);
      //   end      // Test case 6
      // x_i = 12'b000110000000;
      // z_i = 1.7720;
      // #12; 
      // assert(fp_o == 12'hfff)
      //   begin
      //       $display($time,"<<<<<<<<<<<<<<<<<<<<<<<<<TEST-6 PASSED>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>");
      //       $display($time," x_i = %h   | z_i = %h | fp_o = %h" , x_i, z_i, fp_o);
      //   end
      // else
      //   begin
      //       $error($time,"<<<<<<<<<<<<<<<<<<<<<<<<<<<TEST-6 FAILED>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>");
      //       $error($time," x_i = %h   | z_i = %h | fp_o = %h" , x_i,z_i, fp_o);
      //   end      // Test case 6
      // x_i = 12'b000110000000;
      // z_i = 1.7720;
      // #12; 
      // assert(fp_o == 12'hfff)
      //   begin
      //       $display($time,"<<<<<<<<<<<<<<<<<<<<<<<<<TEST-6 PASSED>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>");
      //       $display($time," x_i = %h   | z_i = %h | fp_o = %h" , x_i, z_i, fp_o);
      //   end
      // else
      //   begin
      //       $error($time,"<<<<<<<<<<<<<<<<<<<<<<<<<<<TEST-6 FAILED>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>");
      //       $error($time," x_i = %h   | z_i = %h | fp_o = %h" , x_i,z_i, fp_o);
      //   end      // Test case 6
      // x_i = 12'b000110000000;
      // z_i = 1.7720;
      // #12; 
      // assert(fp_o == 12'hfff)
      //   begin
      //       $display($time,"<<<<<<<<<<<<<<<<<<<<<<<<<TEST-6 PASSED>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>");
      //       $display($time," x_i = %h   | z_i = %h | fp_o = %h" , x_i, z_i, fp_o);
      //   end
      // else
      //   begin
      //       $error($time,"<<<<<<<<<<<<<<<<<<<<<<<<<<<TEST-6 FAILED>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>");
      //       $error($time," x_i = %h   | z_i = %h | fp_o = %h" , x_i,z_i, fp_o);
      //   end      // Test case 6
      // x_i = 12'b000110000000;
      // z_i = 1.7720;
      // #12; 
      // assert(fp_o == 12'hfff)
      //   begin
      //       $display($time,"<<<<<<<<<<<<<<<<<<<<<<<<<TEST-6 PASSED>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>");
      //       $display($time," x_i = %h   | z_i = %h | fp_o = %h" , x_i, z_i, fp_o);
      //   end
      // else
      //   begin
      //       $error($time,"<<<<<<<<<<<<<<<<<<<<<<<<<<<TEST-6 FAILED>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>");
      //       $error($time," x_i = %h   | z_i = %h | fp_o = %h" , x_i,z_i, fp_o);
      //   end      // Test case 6
      // x_i = 12'b000110000000;
      // z_i = 1.7720;
      // #12; 
      // assert(fp_o == 12'hfff)
      //   begin
      //       $display($time,"<<<<<<<<<<<<<<<<<<<<<<<<<TEST-6 PASSED>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>");
      //       $display($time," x_i = %h   | z_i = %h | fp_o = %h" , x_i, z_i, fp_o);
      //   end
      // else
      //   begin
      //       $error($time,"<<<<<<<<<<<<<<<<<<<<<<<<<<<TEST-6 FAILED>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>");
      //       $error($time," x_i = %h   | z_i = %h | fp_o = %h" , x_i,z_i, fp_o);
      //   end      // Test case 6
      // x_i = 12'b000110000000;
      // z_i = 1.7720;
      // #12; 
      // assert(fp_o == 12'hfff)
      //   begin
      //       $display($time,"<<<<<<<<<<<<<<<<<<<<<<<<<TEST-6 PASSED>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>");
      //       $display($time," x_i = %h   | z_i = %h | fp_o = %h" , x_i, z_i, fp_o);
      //   end
      // else
      //   begin
      //       $error($time,"<<<<<<<<<<<<<<<<<<<<<<<<<<<TEST-6 FAILED>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>");
      //       $error($time," x_i = %h   | z_i = %h | fp_o = %h" , x_i,z_i, fp_o);
      //   end      // Test case 6
      // x_i = 12'b000110000000;
      // z_i = 1.7720;
      // #12; 
      // assert(fp_o == 12'hfff)
      //   begin
      //       $display($time,"<<<<<<<<<<<<<<<<<<<<<<<<<TEST-6 PASSED>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>");
      //       $display($time," x_i = %h   | z_i = %h | fp_o = %h" , x_i, z_i, fp_o);
      //   end
      // else
      //   begin
      //       $error($time,"<<<<<<<<<<<<<<<<<<<<<<<<<<<TEST-6 FAILED>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>");
      //       $error($time," x_i = %h   | z_i = %h | fp_o = %h" , x_i,z_i, fp_o);
      //   end      // Test case 6
      // x_i = 12'b000110000000;
      // z_i = 1.7720;
      // #12; 
      // assert(fp_o == 12'hfff)
      //   begin
      //       $display($time,"<<<<<<<<<<<<<<<<<<<<<<<<<TEST-6 PASSED>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>");
      //       $display($time," x_i = %h   | z_i = %h | fp_o = %h" , x_i, z_i, fp_o);
      //   end
      // else
      //   begin
      //       $error($time,"<<<<<<<<<<<<<<<<<<<<<<<<<<<TEST-6 FAILED>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>");
      //       $error($time," x_i = %h   | z_i = %h | fp_o = %h" , x_i,z_i, fp_o);
      //   end      // Test case 6
      // x_i = 12'b000110000000;
      // z_i = 1.7720;
      // #12; 
      // assert(fp_o == 12'hfff)
      //   begin
      //       $display($time,"<<<<<<<<<<<<<<<<<<<<<<<<<TEST-6 PASSED>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>");
      //       $display($time," x_i = %h   | z_i = %h | fp_o = %h" , x_i, z_i, fp_o);
      //   end
      // else
      //   begin
      //       $error($time,"<<<<<<<<<<<<<<<<<<<<<<<<<<<TEST-6 FAILED>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>");
      //       $error($time," x_i = %h   | z_i = %h | fp_o = %h" , x_i,z_i, fp_o);
      //   end      // Test case 6
      // x_i = 12'b000110000000;
      // z_i = 1.7720;
      // #12; 
      // assert(fp_o == 12'hfff)
      //   begin
      //       $display($time,"<<<<<<<<<<<<<<<<<<<<<<<<<TEST-6 PASSED>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>");
      //       $display($time," x_i = %h   | z_i = %h | fp_o = %h" , x_i, z_i, fp_o);
      //   end
      // else
      //   begin
      //       $error($time,"<<<<<<<<<<<<<<<<<<<<<<<<<<<TEST-6 FAILED>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>");
      //       $error($time," x_i = %h   | z_i = %h | fp_o = %h" , x_i,z_i, fp_o);
      //   end      // Test case 6
      // x_i = 12'b000110000000;
      // z_i = 1.7720;
      // #12; 
      // assert(fp_o == 12'hfff)
      //   begin
      //       $display($time,"<<<<<<<<<<<<<<<<<<<<<<<<<TEST-6 PASSED>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>");
      //       $display($time," x_i = %h   | z_i = %h | fp_o = %h" , x_i, z_i, fp_o);
      //   end
      // else
      //   begin
      //       $error($time,"<<<<<<<<<<<<<<<<<<<<<<<<<<<TEST-6 FAILED>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>");
      //       $error($time," x_i = %h   | z_i = %h | fp_o = %h" , x_i,z_i, fp_o);
      //   end      // Test case 6
      // x_i = 12'b000110000000;
      // z_i = 1.7720;
      // #12; 
      // assert(fp_o == 12'hfff)
      //   begin
      //       $display($time,"<<<<<<<<<<<<<<<<<<<<<<<<<TEST-6 PASSED>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>");
      //       $display($time," x_i = %h   | z_i = %h | fp_o = %h" , x_i, z_i, fp_o);
      //   end
      // else
      //   begin
      //       $error($time,"<<<<<<<<<<<<<<<<<<<<<<<<<<<TEST-6 FAILED>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>");
      //       $error($time," x_i = %h   | z_i = %h | fp_o = %h" , x_i,z_i, fp_o);
      //   end      // Test case 6
      // x_i = 12'b000110000000;
      // z_i = 1.7720;
      // #12; 
      // assert(fp_o == 12'hfff)
      //   begin
      //       $display($time,"<<<<<<<<<<<<<<<<<<<<<<<<<TEST-6 PASSED>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>");
      //       $display($time," x_i = %h   | z_i = %h | fp_o = %h" , x_i, z_i, fp_o);
      //   end
      // else
      //   begin
      //       $error($time,"<<<<<<<<<<<<<<<<<<<<<<<<<<<TEST-6 FAILED>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>");
      //       $error($time," x_i = %h   | z_i = %h | fp_o = %h" , x_i,z_i, fp_o);
      //   end      // Test case 6
      // x_i = 12'b000110000000;
      // z_i = 1.7720;
      // #12; 
      // assert(fp_o == 12'hfff)
      //   begin
      //       $display($time,"<<<<<<<<<<<<<<<<<<<<<<<<<TEST-6 PASSED>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>");
      //       $display($time," x_i = %h   | z_i = %h | fp_o = %h" , x_i, z_i, fp_o);
      //   end
      // else
      //   begin
      //       $error($time,"<<<<<<<<<<<<<<<<<<<<<<<<<<<TEST-6 FAILED>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>");
      //       $error($time," x_i = %h   | z_i = %h | fp_o = %h" , x_i,z_i, fp_o);
      //   end      // Test case 6
      // x_i = 12'b000110000000;
      // z_i = 1.7720;
      // #12; 
      // assert(fp_o == 12'hfff)
      //   begin
      //       $display($time,"<<<<<<<<<<<<<<<<<<<<<<<<<TEST-6 PASSED>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>");
      //       $display($time," x_i = %h   | z_i = %h | fp_o = %h" , x_i, z_i, fp_o);
      //   end
      // else
      //   begin
      //       $error($time,"<<<<<<<<<<<<<<<<<<<<<<<<<<<TEST-6 FAILED>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>");
      //       $error($time," x_i = %h   | z_i = %h | fp_o = %h" , x_i,z_i, fp_o);
      //   end      // Test case 6
      // x_i = 12'b000110000000;
      // z_i = 1.7720;
      // #12; 
      // assert(fp_o == 12'hfff)
      //   begin
      //       $display($time,"<<<<<<<<<<<<<<<<<<<<<<<<<TEST-6 PASSED>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>");
      //       $display($time," x_i = %h   | z_i = %h | fp_o = %h" , x_i, z_i, fp_o);
      //   end
      // else
      //   begin
      //       $error($time,"<<<<<<<<<<<<<<<<<<<<<<<<<<<TEST-6 FAILED>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>");
      //       $error($time," x_i = %h   | z_i = %h | fp_o = %h" , x_i,z_i, fp_o);
      //   end      // Test case 6
      // x_i = 12'b000110000000;
      // z_i = 1.7720;
      // #12; 
      // assert(fp_o == 12'hfff)
      //   begin
      //       $display($time,"<<<<<<<<<<<<<<<<<<<<<<<<<TEST-6 PASSED>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>");
      //       $display($time," x_i = %h   | z_i = %h | fp_o = %h" , x_i, z_i, fp_o);
      //   end
      // else
      //   begin
      //       $error($time,"<<<<<<<<<<<<<<<<<<<<<<<<<<<TEST-6 FAILED>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>");
      //       $error($time," x_i = %h   | z_i = %h | fp_o = %h" , x_i,z_i, fp_o);
      //   end      // Test case 6
      // x_i = 12'b000110000000;
      // z_i = 1.7720;
      // #12; 
      // assert(fp_o == 12'hfff)
      //   begin
      //       $display($time,"<<<<<<<<<<<<<<<<<<<<<<<<<TEST-6 PASSED>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>");
      //       $display($time," x_i = %h   | z_i = %h | fp_o = %h" , x_i, z_i, fp_o);
      //   end
      // else
      //   begin
      //       $error($time,"<<<<<<<<<<<<<<<<<<<<<<<<<<<TEST-6 FAILED>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>");
      //       $error($time," x_i = %h   | z_i = %h | fp_o = %h" , x_i,z_i, fp_o);
      //   end      // Test case 6
      // x_i = 12'b000110000000;
      // z_i = 1.7720;
      // #12; 
      // assert(fp_o == 12'hfff)
      //   begin
      //       $display($time,"<<<<<<<<<<<<<<<<<<<<<<<<<TEST-6 PASSED>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>");
      //       $display($time," x_i = %h   | z_i = %h | fp_o = %h" , x_i, z_i, fp_o);
      //   end
      // else
      //   begin
      //       $error($time,"<<<<<<<<<<<<<<<<<<<<<<<<<<<TEST-6 FAILED>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>");
      //       $error($time," x_i = %h   | z_i = %h | fp_o = %h" , x_i,z_i, fp_o);
      //   end      // Test case 6
      // x_i = 12'b000110000000;
      // z_i = 1.7720;
      // #12; 
      // assert(fp_o == 12'hfff)
      //   begin
      //       $display($time,"<<<<<<<<<<<<<<<<<<<<<<<<<TEST-6 PASSED>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>");
      //       $display($time," x_i = %h   | z_i = %h | fp_o = %h" , x_i, z_i, fp_o);
      //   end
      // else
      //   begin
      //       $error($time,"<<<<<<<<<<<<<<<<<<<<<<<<<<<TEST-6 FAILED>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>");
      //       $error($time," x_i = %h   | z_i = %h | fp_o = %h" , x_i,z_i, fp_o);
      //   end      // Test case 6
      // x_i = 12'b000110000000;
      // z_i = 1.7720;
      // #12; 
      // assert(fp_o == 12'hfff)
      //   begin
      //       $display($time,"<<<<<<<<<<<<<<<<<<<<<<<<<TEST-6 PASSED>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>");
      //       $display($time," x_i = %h   | z_i = %h | fp_o = %h" , x_i, z_i, fp_o);
      //   end
      // else
      //   begin
      //       $error($time,"<<<<<<<<<<<<<<<<<<<<<<<<<<<TEST-6 FAILED>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>");
      //       $error($time," x_i = %h   | z_i = %h | fp_o = %h" , x_i,z_i, fp_o);
      //   end      // Test case 6
      // x_i = 12'b000110000000;
      // z_i = 1.7720;
      // #12; 
      // assert(fp_o == 12'hfff)
      //   begin
      //       $display($time,"<<<<<<<<<<<<<<<<<<<<<<<<<TEST-6 PASSED>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>");
      //       $display($time," x_i = %h   | z_i = %h | fp_o = %h" , x_i, z_i, fp_o);
      //   end
      // else
      //   begin
      //       $error($time,"<<<<<<<<<<<<<<<<<<<<<<<<<<<TEST-6 FAILED>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>");
      //       $error($time," x_i = %h   | z_i = %h | fp_o = %h" , x_i,z_i, fp_o);
      //   end      // Test case 6
      // x_i = 12'b000110000000;
      // z_i = 1.7720;
      // #12; 
      // assert(fp_o == 12'hfff)
      //   begin
      //       $display($time,"<<<<<<<<<<<<<<<<<<<<<<<<<TEST-6 PASSED>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>");
      //       $display($time," x_i = %h   | z_i = %h | fp_o = %h" , x_i, z_i, fp_o);
      //   end
      // else
      //   begin
      //       $error($time,"<<<<<<<<<<<<<<<<<<<<<<<<<<<TEST-6 FAILED>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>");
      //       $error($time," x_i = %h   | z_i = %h | fp_o = %h" , x_i,z_i, fp_o);
      //   end      // Test case 6
      // x_i = 12'b000110000000;
      // z_i = 1.7720;
      // #12; 
      // assert(fp_o == 12'hfff)
      //   begin
      //       $display($time,"<<<<<<<<<<<<<<<<<<<<<<<<<TEST-6 PASSED>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>");
      //       $display($time," x_i = %h   | z_i = %h | fp_o = %h" , x_i, z_i, fp_o);
      //   end
      // else
      //   begin
      //       $error($time,"<<<<<<<<<<<<<<<<<<<<<<<<<<<TEST-6 FAILED>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>");
      //       $error($time," x_i = %h   | z_i = %h | fp_o = %h" , x_i,z_i, fp_o);
      //   end      // Test case 6
      // x_i = 12'b000110000000;
      // z_i = 1.7720;
      // #12; 
      // assert(fp_o == 12'hfff)
      //   begin
      //       $display($time,"<<<<<<<<<<<<<<<<<<<<<<<<<TEST-6 PASSED>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>");
      //       $display($time," x_i = %h   | z_i = %h | fp_o = %h" , x_i, z_i, fp_o);
      //   end
      // else
      //   begin
      //       $error($time,"<<<<<<<<<<<<<<<<<<<<<<<<<<<TEST-6 FAILED>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>");
      //       $error($time," x_i = %h   | z_i = %h | fp_o = %h" , x_i,z_i, fp_o);
      //   end      // Test case 6
      // x_i = 12'b000110000000;
      // z_i = 1.7720;
      // #12; 
      // assert(fp_o == 12'hfff)
      //   begin
      //       $display($time,"<<<<<<<<<<<<<<<<<<<<<<<<<TEST-6 PASSED>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>");
      //       $display($time," x_i = %h   | z_i = %h | fp_o = %h" , x_i, z_i, fp_o);
      //   end
      // else
      //   begin
      //       $error($time,"<<<<<<<<<<<<<<<<<<<<<<<<<<<TEST-6 FAILED>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>");
      //       $error($time," x_i = %h   | z_i = %h | fp_o = %h" , x_i,z_i, fp_o);
      //   end      // Test case 6
      // x_i = 12'b000110000000;
      // z_i = 1.7720;
      // #12; 
      // assert(fp_o == 12'hfff)
      //   begin
      //       $display($time,"<<<<<<<<<<<<<<<<<<<<<<<<<TEST-6 PASSED>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>");
      //       $display($time," x_i = %h   | z_i = %h | fp_o = %h" , x_i, z_i, fp_o);
      //   end
      // else
      //   begin
      //       $error($time,"<<<<<<<<<<<<<<<<<<<<<<<<<<<TEST-6 FAILED>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>");
      //       $error($time," x_i = %h   | z_i = %h | fp_o = %h" , x_i,z_i, fp_o);
      //   end      // Test case 6
      // x_i = 12'b000110000000;
      // z_i = 1.7720;
      // #12; 
      // assert(fp_o == 12'hfff)
      //   begin
      //       $display($time,"<<<<<<<<<<<<<<<<<<<<<<<<<TEST-6 PASSED>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>");
      //       $display($time," x_i = %h   | z_i = %h | fp_o = %h" , x_i, z_i, fp_o);
      //   end
      // else
      //   begin
      //       $error($time,"<<<<<<<<<<<<<<<<<<<<<<<<<<<TEST-6 FAILED>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>");
      //       $error($time," x_i = %h   | z_i = %h | fp_o = %h" , x_i,z_i, fp_o);
      //   end      // Test case 6
      // x_i = 12'b000110000000;
      // z_i = 1.7720;
      // #12; 
      // assert(fp_o == 12'hfff)
      //   begin
      //       $display($time,"<<<<<<<<<<<<<<<<<<<<<<<<<TEST-6 PASSED>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>");
      //       $display($time," x_i = %h   | z_i = %h | fp_o = %h" , x_i, z_i, fp_o);
      //   end
      // else
      //   begin
      //       $error($time,"<<<<<<<<<<<<<<<<<<<<<<<<<<<TEST-6 FAILED>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>");
      //       $error($time," x_i = %h   | z_i = %h | fp_o = %h" , x_i,z_i, fp_o);
      //   end      // Test case 6
      // x_i = 12'b000110000000;
      // z_i = 1.7720;
      // #12; 
      // assert(fp_o == 12'hfff)
      //   begin
      //       $display($time,"<<<<<<<<<<<<<<<<<<<<<<<<<TEST-6 PASSED>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>");
      //       $display($time," x_i = %h   | z_i = %h | fp_o = %h" , x_i, z_i, fp_o);
      //   end
      // else
      //   begin
      //       $error($time,"<<<<<<<<<<<<<<<<<<<<<<<<<<<TEST-6 FAILED>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>");
      //       $error($time," x_i = %h   | z_i = %h | fp_o = %h" , x_i,z_i, fp_o);
      //   end      // Test case 6
      // x_i = 12'b000110000000;
      // z_i = 1.7720;
      // #12; 
      // assert(fp_o == 12'hfff)
      //   begin
      //       $display($time,"<<<<<<<<<<<<<<<<<<<<<<<<<TEST-6 PASSED>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>");
      //       $display($time," x_i = %h   | z_i = %h | fp_o = %h" , x_i, z_i, fp_o);
      //   end
      // else
      //   begin
      //       $error($time,"<<<<<<<<<<<<<<<<<<<<<<<<<<<TEST-6 FAILED>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>");
      //       $error($time," x_i = %h   | z_i = %h | fp_o = %h" , x_i,z_i, fp_o);
      //   end      // Test case 6
      // x_i = 12'b000110000000;
      // z_i = 1.7720;
      // #12; 
      // assert(fp_o == 12'hfff)
      //   begin
      //       $display($time,"<<<<<<<<<<<<<<<<<<<<<<<<<TEST-6 PASSED>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>");
      //       $display($time," x_i = %h   | z_i = %h | fp_o = %h" , x_i, z_i, fp_o);
      //   end
      // else
      //   begin
      //       $error($time,"<<<<<<<<<<<<<<<<<<<<<<<<<<<TEST-6 FAILED>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>");
      //       $error($time," x_i = %h   | z_i = %h | fp_o = %h" , x_i,z_i, fp_o);
      //   end      // Test case 6
      // x_i = 12'b000110000000;
      // z_i = 1.7720;
      // #12; 
      // assert(fp_o == 12'hfff)
      //   begin
      //       $display($time,"<<<<<<<<<<<<<<<<<<<<<<<<<TEST-6 PASSED>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>");
      //       $display($time," x_i = %h   | z_i = %h | fp_o = %h" , x_i, z_i, fp_o);
      //   end
      // else
      //   begin
      //       $error($time,"<<<<<<<<<<<<<<<<<<<<<<<<<<<TEST-6 FAILED>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>");
      //       $error($time," x_i = %h   | z_i = %h | fp_o = %h" , x_i,z_i, fp_o);
      //   end      // Test case 6
      // x_i = 12'b000110000000;
      // z_i = 1.7720;
      // #12; 
      // assert(fp_o == 12'hfff)
      //   begin
      //       $display($time,"<<<<<<<<<<<<<<<<<<<<<<<<<TEST-6 PASSED>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>");
      //       $display($time," x_i = %h   | z_i = %h | fp_o = %h" , x_i, z_i, fp_o);
      //   end
      // else
      //   begin
      //       $error($time,"<<<<<<<<<<<<<<<<<<<<<<<<<<<TEST-6 FAILED>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>");
      //       $error($time," x_i = %h   | z_i = %h | fp_o = %h" , x_i,z_i, fp_o);
      //   end      // Test case 6
      // x_i = 12'b000110000000;
      // z_i = 1.7720;
      // #12; 
      // assert(fp_o == 12'hfff)
      //   begin
      //       $display($time,"<<<<<<<<<<<<<<<<<<<<<<<<<TEST-6 PASSED>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>");
      //       $display($time," x_i = %h   | z_i = %h | fp_o = %h" , x_i, z_i, fp_o);
      //   end
      // else
      //   begin
      //       $error($time,"<<<<<<<<<<<<<<<<<<<<<<<<<<<TEST-6 FAILED>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>");
      //       $error($time," x_i = %h   | z_i = %h | fp_o = %h" , x_i,z_i, fp_o);
      //   end      // Test case 6
      // x_i = 12'b000110000000;
      // z_i = 1.7720;
      // #12; 
      // assert(fp_o == 12'hfff)
      //   begin
      //       $display($time,"<<<<<<<<<<<<<<<<<<<<<<<<<TEST-6 PASSED>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>");
      //       $display($time," x_i = %h   | z_i = %h | fp_o = %h" , x_i, z_i, fp_o);
      //   end
      // else
      //   begin
      //       $error($time,"<<<<<<<<<<<<<<<<<<<<<<<<<<<TEST-6 FAILED>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>");
      //       $error($time," x_i = %h   | z_i = %h | fp_o = %h" , x_i,z_i, fp_o);
      //   end      // Test case 6
      // x_i = 12'b000110000000;
      // z_i = 1.7720;
      // #12; 
      // assert(fp_o == 12'hfff)
      //   begin
      //       $display($time,"<<<<<<<<<<<<<<<<<<<<<<<<<TEST-6 PASSED>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>");
      //       $display($time," x_i = %h   | z_i = %h | fp_o = %h" , x_i, z_i, fp_o);
      //   end
      // else
      //   begin
      //       $error($time,"<<<<<<<<<<<<<<<<<<<<<<<<<<<TEST-6 FAILED>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>");
      //       $error($time," x_i = %h   | z_i = %h | fp_o = %h" , x_i,z_i, fp_o);
      //   end      // Test case 6
      // x_i = 12'b000110000000;
      // z_i = 1.7720;
      // #12; 
      // assert(fp_o == 12'hfff)
      //   begin
      //       $display($time,"<<<<<<<<<<<<<<<<<<<<<<<<<TEST-6 PASSED>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>");
      //       $display($time," x_i = %h   | z_i = %h | fp_o = %h" , x_i, z_i, fp_o);
      //   end
      // else
      //   begin
      //       $error($time,"<<<<<<<<<<<<<<<<<<<<<<<<<<<TEST-6 FAILED>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>");
      //       $error($time," x_i = %h   | z_i = %h | fp_o = %h" , x_i,z_i, fp_o);
      //   end      // Test case 6
      // x_i = 12'b000110000000;
      // z_i = 1.7720;
      // #12; 
      // assert(fp_o == 12'hfff)
      //   begin
      //       $display($time,"<<<<<<<<<<<<<<<<<<<<<<<<<TEST-6 PASSED>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>");
      //       $display($time," x_i = %h   | z_i = %h | fp_o = %h" , x_i, z_i, fp_o);
      //   end
      // else
      //   begin
      //       $error($time,"<<<<<<<<<<<<<<<<<<<<<<<<<<<TEST-6 FAILED>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>");
      //       $error($time," x_i = %h   | z_i = %h | fp_o = %h" , x_i,z_i, fp_o);
      //   end      // Test case 6
      // x_i = 12'b000110000000;
      // z_i = 1.7720;
      // #12; 
      // assert(fp_o == 12'hfff)
      //   begin
      //       $display($time,"<<<<<<<<<<<<<<<<<<<<<<<<<TEST-6 PASSED>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>");
      //       $display($time," x_i = %h   | z_i = %h | fp_o = %h" , x_i, z_i, fp_o);
      //   end
      // else
      //   begin
      //       $error($time,"<<<<<<<<<<<<<<<<<<<<<<<<<<<TEST-6 FAILED>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>");
      //       $error($time," x_i = %h   | z_i = %h | fp_o = %h" , x_i,z_i, fp_o);
      //   end      // Test case 6
      // x_i = 12'b000110000000;
      // z_i = 1.7720;
      // #12; 
      // assert(fp_o == 12'hfff)
      //   begin
      //       $display($time,"<<<<<<<<<<<<<<<<<<<<<<<<<TEST-6 PASSED>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>");
      //       $display($time," x_i = %h   | z_i = %h | fp_o = %h" , x_i, z_i, fp_o);
      //   end
      // else
      //   begin
      //       $error($time,"<<<<<<<<<<<<<<<<<<<<<<<<<<<TEST-6 FAILED>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>");
      //       $error($time," x_i = %h   | z_i = %h | fp_o = %h" , x_i,z_i, fp_o);
      //   end      // Test case 6
      // x_i = 12'b000110000000;
      // z_i = 1.7720;
      // #12; 
      // assert(fp_o == 12'hfff)
      //   begin
      //       $display($time,"<<<<<<<<<<<<<<<<<<<<<<<<<TEST-6 PASSED>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>");
      //       $display($time," x_i = %h   | z_i = %h | fp_o = %h" , x_i, z_i, fp_o);
      //   end
      // else
      //   begin
      //       $error($time,"<<<<<<<<<<<<<<<<<<<<<<<<<<<TEST-6 FAILED>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>");
      //       $error($time," x_i = %h   | z_i = %h | fp_o = %h" , x_i,z_i, fp_o);
      //   end      // Test case 6
      // x_i = 12'b000110000000;
      // z_i = 1.7720;
      // #12; 
      // assert(fp_o == 12'hfff)
      //   begin
      //       $display($time,"<<<<<<<<<<<<<<<<<<<<<<<<<TEST-6 PASSED>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>");
      //       $display($time," x_i = %h   | z_i = %h | fp_o = %h" , x_i, z_i, fp_o);
      //   end
      // else
      //   begin
      //       $error($time,"<<<<<<<<<<<<<<<<<<<<<<<<<<<TEST-6 FAILED>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>");
      //       $error($time," x_i = %h   | z_i = %h | fp_o = %h" , x_i,z_i, fp_o);
      //   end      // Test case 6
      // x_i = 12'b000110000000;
      // z_i = 1.7720;
      // #12; 
      // assert(fp_o == 12'hfff)
      //   begin
      //       $display($time,"<<<<<<<<<<<<<<<<<<<<<<<<<TEST-6 PASSED>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>");
      //       $display($time," x_i = %h   | z_i = %h | fp_o = %h" , x_i, z_i, fp_o);
      //   end
      // else
      //   begin
      //       $error($time,"<<<<<<<<<<<<<<<<<<<<<<<<<<<TEST-6 FAILED>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>");
      //       $error($time," x_i = %h   | z_i = %h | fp_o = %h" , x_i,z_i, fp_o);
      //   end      // Test case 6
      // x_i = 12'b000110000000;
      // z_i = 1.7720;
      // #12; 
      // assert(fp_o == 12'hfff)
      //   begin
      //       $display($time,"<<<<<<<<<<<<<<<<<<<<<<<<<TEST-6 PASSED>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>");
      //       $display($time," x_i = %h   | z_i = %h | fp_o = %h" , x_i, z_i, fp_o);
      //   end
      // else
      //   begin
      //       $error($time,"<<<<<<<<<<<<<<<<<<<<<<<<<<<TEST-6 FAILED>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>");
      //       $error($time," x_i = %h   | z_i = %h | fp_o = %h" , x_i,z_i, fp_o);
      //   end      // Test case 6
      // x_i = 12'b000110000000;
      // z_i = 1.7720;
      // #12; 
      // assert(fp_o == 12'hfff)
      //   begin
      //       $display($time,"<<<<<<<<<<<<<<<<<<<<<<<<<TEST-6 PASSED>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>");
      //       $display($time," x_i = %h   | z_i = %h | fp_o = %h" , x_i, z_i, fp_o);
      //   end
      // else
      //   begin
      //       $error($time,"<<<<<<<<<<<<<<<<<<<<<<<<<<<TEST-6 FAILED>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>");
      //       $error($time," x_i = %h   | z_i = %h | fp_o = %h" , x_i,z_i, fp_o);
      //   end      // Test case 6
      // x_i = 12'b000110000000;
      // z_i = 1.7720;
      // #12; 
      // assert(fp_o == 12'hfff)
      //   begin
      //       $display($time,"<<<<<<<<<<<<<<<<<<<<<<<<<TEST-6 PASSED>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>");
      //       $display($time," x_i = %h   | z_i = %h | fp_o = %h" , x_i, z_i, fp_o);
      //   end
      // else
      //   begin
      //       $error($time,"<<<<<<<<<<<<<<<<<<<<<<<<<<<TEST-6 FAILED>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>");
      //       $error($time," x_i = %h   | z_i = %h | fp_o = %h" , x_i,z_i, fp_o);
      //   end      // Test case 6
      // x_i = 12'b000110000000;
      // z_i = 1.7720;
      // #12; 
      // assert(fp_o == 12'hfff)
      //   begin
      //       $display($time,"<<<<<<<<<<<<<<<<<<<<<<<<<TEST-6 PASSED>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>");
      //       $display($time," x_i = %h   | z_i = %h | fp_o = %h" , x_i, z_i, fp_o);
      //   end
      // else
      //   begin
      //       $error($time,"<<<<<<<<<<<<<<<<<<<<<<<<<<<TEST-6 FAILED>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>");
      //       $error($time," x_i = %h   | z_i = %h | fp_o = %h" , x_i,z_i, fp_o);
      //   end      // Test case 6
      // x_i = 12'b000110000000;
      // z_i = 1.7720;
      // #12; 
      // assert(fp_o == 12'hfff)
      //   begin
      //       $display($time,"<<<<<<<<<<<<<<<<<<<<<<<<<TEST-6 PASSED>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>");
      //       $display($time," x_i = %h   | z_i = %h | fp_o = %h" , x_i, z_i, fp_o);
      //   end
      // else
      //   begin
      //       $error($time,"<<<<<<<<<<<<<<<<<<<<<<<<<<<TEST-6 FAILED>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>");
      //       $error($time," x_i = %h   | z_i = %h | fp_o = %h" , x_i,z_i, fp_o);
      //   end      // Test case 6
      // x_i = 12'b000110000000;
      // z_i = 1.7720;
      // #12; 
      // assert(fp_o == 12'hfff)
      //   begin
      //       $display($time,"<<<<<<<<<<<<<<<<<<<<<<<<<TEST-6 PASSED>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>");
      //       $display($time," x_i = %h   | z_i = %h | fp_o = %h" , x_i, z_i, fp_o);
      //   end
      // else
      //   begin
      //       $error($time,"<<<<<<<<<<<<<<<<<<<<<<<<<<<TEST-6 FAILED>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>");
      //       $error($time," x_i = %h   | z_i = %h | fp_o = %h" , x_i,z_i, fp_o);
      //   end      // Test case 6
      // x_i = 12'b000110000000;
      // z_i = 1.7720;
      // #12; 
      // assert(fp_o == 12'hfff)
      //   begin
      //       $display($time,"<<<<<<<<<<<<<<<<<<<<<<<<<TEST-6 PASSED>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>");
      //       $display($time," x_i = %h   | z_i = %h | fp_o = %h" , x_i, z_i, fp_o);
      //   end
      // else
      //   begin
      //       $error($time,"<<<<<<<<<<<<<<<<<<<<<<<<<<<TEST-6 FAILED>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>");
      //       $error($time," x_i = %h   | z_i = %h | fp_o = %h" , x_i,z_i, fp_o);
      //   end      // Test case 6
      // x_i = 12'b000110000000;
      // z_i = 1.7720;
      // #12; 
      // assert(fp_o == 12'hfff)
      //   begin
      //       $display($time,"<<<<<<<<<<<<<<<<<<<<<<<<<TEST-6 PASSED>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>");
      //       $display($time," x_i = %h   | z_i = %h | fp_o = %h" , x_i, z_i, fp_o);
      //   end
      // else
      //   begin
      //       $error($time,"<<<<<<<<<<<<<<<<<<<<<<<<<<<TEST-6 FAILED>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>");
      //       $error($time," x_i = %h   | z_i = %h | fp_o = %h" , x_i,z_i, fp_o);
      //   end      // Test case 6
      // x_i = 12'b000110000000;
      // z_i = 1.7720;
      // #12; 
      // assert(fp_o == 12'hfff)
      //   begin
      //       $display($time,"<<<<<<<<<<<<<<<<<<<<<<<<<TEST-6 PASSED>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>");
      //       $display($time," x_i = %h   | z_i = %h | fp_o = %h" , x_i, z_i, fp_o);
      //   end
      // else
      //   begin
      //       $error($time,"<<<<<<<<<<<<<<<<<<<<<<<<<<<TEST-6 FAILED>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>");
      //       $error($time," x_i = %h   | z_i = %h | fp_o = %h" , x_i,z_i, fp_o);
      //   end      // Test case 6
      // x_i = 12'b000110000000;
      // z_i = 1.7720;
      // #12; 
      // assert(fp_o == 12'hfff)
      //   begin
      //       $display($time,"<<<<<<<<<<<<<<<<<<<<<<<<<TEST-6 PASSED>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>");
      //       $display($time," x_i = %h   | z_i = %h | fp_o = %h" , x_i, z_i, fp_o);
      //   end
      // else
      //   begin
      //       $error($time,"<<<<<<<<<<<<<<<<<<<<<<<<<<<TEST-6 FAILED>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>");
      //       $error($time," x_i = %h   | z_i = %h | fp_o = %h" , x_i,z_i, fp_o);
      //   end      // Test case 6
      // x_i = 12'b000110000000;
      // z_i = 1.7720;
      // #12; 
      // assert(fp_o == 12'hfff)
      //   begin
      //       $display($time,"<<<<<<<<<<<<<<<<<<<<<<<<<TEST-6 PASSED>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>");
      //       $display($time," x_i = %h   | z_i = %h | fp_o = %h" , x_i, z_i, fp_o);
      //   end
      // else
      //   begin
      //       $error($time,"<<<<<<<<<<<<<<<<<<<<<<<<<<<TEST-6 FAILED>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>");
      //       $error($time," x_i = %h   | z_i = %h | fp_o = %h" , x_i,z_i, fp_o);
      //   end      // Test case 6
      // x_i = 12'b000110000000;
      // z_i = 1.7720;
      // #12; 
      // assert(fp_o == 12'hfff)
      //   begin
      //       $display($time,"<<<<<<<<<<<<<<<<<<<<<<<<<TEST-6 PASSED>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>");
      //       $display($time," x_i = %h   | z_i = %h | fp_o = %h" , x_i, z_i, fp_o);
      //   end
      // else
      //   begin
      //       $error($time,"<<<<<<<<<<<<<<<<<<<<<<<<<<<TEST-6 FAILED>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>");
      //       $error($time," x_i = %h   | z_i = %h | fp_o = %h" , x_i,z_i, fp_o);
      //   end      // Test case 6
      // x_i = 12'b000110000000;
      // z_i = 1.7720;
      // #12; 
      // assert(fp_o == 12'hfff)
      //   begin
      //       $display($time,"<<<<<<<<<<<<<<<<<<<<<<<<<TEST-6 PASSED>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>");
      //       $display($time," x_i = %h   | z_i = %h | fp_o = %h" , x_i, z_i, fp_o);
      //   end
      // else
      //   begin
      //       $error($time,"<<<<<<<<<<<<<<<<<<<<<<<<<<<TEST-6 FAILED>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>");
      //       $error($time," x_i = %h   | z_i = %h | fp_o = %h" , x_i,z_i, fp_o);
      //   end
   end

   initial begin
      // finish the simulation
       #100 $finish;
    end
endmodule
