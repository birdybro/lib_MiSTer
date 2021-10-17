@echo off
REM Regression tests for TTL models
REM Usage: regress [-c] [test]
REM If "-c" is present, testbenches are compiled first.
REM If "test" is omitted, [compile &] run all tests.
REM
REM Note the forward slashes: correct for vsim
setlocal
if "%1" EQU "-c" (
  set ZZVCOM=1
  shift
  ) else set ZZVCOM=0

if "%1" NEQ "" (
  if %ZZVCOM% == 1 (
    vcom -2008 +acc -quiet Testbench/Testbench_%1.vhd
  )
  vsim -c work.Testbench_%1 < vsim.txt | find "Verify failed"
) else (
for %%G in (Testbench/Testbench_*.vhd) do (
  echo %%~nG
  if %ZZVCOM% == 1 (
    vcom -2008 +acc -quiet Testbench/%%G
  )
  vsim -c work.%%~nG < vsim.txt | find "Verify failed"
)
)
endlocal
