@ECHO OFF

ECHO "Creating working library"
vlib work
IF errorlevel 2 (
	ECHO failed to create library
	GOTO done:
)

ECHO "invoking ==============> vlog  adc_mul.sv qmul_f.sv qdiv_f.sv fixed_to_float.sv float_to_fixed.sv adc_mul_tb"
vlog  adc_mul.sv qmul_f.sv qdiv_f.sv fixed_to_float.sv float_to_fixed.sv adc_mul_tb.sv +acc
IF errorlevel 2 (
	ECHO there was an error, fix it and try again
	GOTO done:
)

ECHO "invoking ==============> vsim adc_mul_tb.sv"
vsim -do "add wave -r /*; run -all; quit" adc_mul_tb
IF errorlevel 2(
	ECHO there was an error, fix it and try again
	GOTO done:
)

:done
ECHO Done
