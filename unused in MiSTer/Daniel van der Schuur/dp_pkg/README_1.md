## Copyright 

Copyright (C) 2019

ASTRON (Netherlands Institute for Radio Astronomy) <http://www.astron.nl/>
P.O.Box 2, 7990 AA Dwingeloo, The Netherlands

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <http://www.gnu.org/licenses/>.

## About this core

This is a collection of commonly used base functions, used in all of ASTRONs
cores that have a DP (based on Avalon) streaming interface.

These source files can work in any environment, however it is recommended to
use the RadioHDL tool to easily generate project files for e.g. Modelsim,
Quartus and Vivado (see 'About hdllib.cfg and the RadioHDL tool').

## Test bench(es)
This core does not contain a test bench. Note that tb_dp_pkg.vhd does have a
'tb' prefix but is a package file containing useful simulation functions.

## Dependencies
This core has the following dependencies:

common_pkg

## Source files
The source files are listed hdllib.cfg.

## More information about this core
Each source file comes with a header containing more information.

## About hdllib.cfg and the RadioHDL tool
The hdllib.cfg file is included in all ASTRONs cores and is a config file that
is detected by the RadioHDL development tool (also on OpenCores). 

The source files are in order of dependency. However, some or all files could 
also be standalone.

The section 'test_bench_files' can list test benches, but also simulation-only
source files that are not test benches.
