# Wishbone System6800/01

by Michael L. Hasenfratz Sr. - 2009

## Description

A Wishbone SoC of a 6800/01 CPU based project

## Features

* Motorola 6800/01 'instruction set' CPU CORE (Object code compatable)
* RMCA01 - Relocatable Macro Cross Assembler included (Shareware by M. Hasenfratz)
* Tested on Altera Apex20K, Cyclone and Stratix developement boards (NIOS Kits)
* All system components have Wishbone Interfaces:
* 6800/01 CPU (Core by John Kent)
* miniUart/ACIA
* miniUart/SCI
* Timer / Counter
* Programmable I/O (PIO)
* 128byte RAM [Note: uses Altera LPM_RAM encapsulated in WishBone I/F]
* 2KB ROM with debug monitor [Note: uses Altera LPM_ROM encapsulated in WishBone I/F]
* External SRAM 'wrapper'
* External ROM 'wrapper'

## Status

* Wishbone CPU01 CORE, Done
* Wishbone miniUart/ACIA (6850 style), Done
* Wishbone miniUart/SCI (6801 Serial Communications Interface), Testing
* Wishbone Internal Altera LPM_ROM / LPM_RAM 'wrapper', Done
* Wishbone External SRAM 'wrapper', Done
* Wishbone External ROM 'wrapper', Done
* Wishbone PIO (Programmable I/O port), Testing
