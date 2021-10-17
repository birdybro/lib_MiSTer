# gh vhdl library

by ghuber and Howard A. LeFevre - 2009
from --> https://opencores.org/projects/gh_vhdl_library

## Description

Perhaps more of a collection of part than a true library, this is a set of VHDL parts that may be used as a set of building blocks for larger designs.

## Features

* counters, shift registers, pulse stretchers (high, low, and programmable) and other MSI parts
* six fixed length LFSR's (24, 36, 48, 64 bits and two that are set with Generics)
* two Programmable length LFSR's
* clocked delay lines (fixed and programmable)
* control registers (individual bits may be set, cleared, or inverted)
* GPIO
* Pulse Generator
* Burst Generator
* Parity generator
* Sweep Generator
* CIC filter
* NCO's (some using a CORDIC, others using a Look up tables)
* CORDIC (with 20 bit or 28 bit atan function)
* (-)Sin/Cos look-up tables (12 bit, 14 bit, and 16 bit)
* baud rate generator
* FIR Filters (Serial and parallel - most with generics, some that do not use multipliers)
* three MAC's (Multiply Accumlator - one with generics)
* TVFD filter
* FIFO's (sync and async)
* Dual port RAM (1 write port, 2 read ports)
* Four byte dual port RAM (2nd port of 32, 16, or 8 bits)
* FASM RAM (Synchronous write port, Asynchronous read port(s))

* Random Number Generator
* Random number scaler (2)

* Six “In place” Multipliers
(two with two signed inputs, two with two unsigned inputs, and two with both- a signed input and an unsigned input two of those have all bits on output)

* Complex adder, multipliers
* digital attenuator

* VMEbus Slave interface Modules (A32D32,A24D16,A16D16)

* Pulse Width Modulator
