-----------------------------------------------------------------------
-- Bipolar TTL models (VHDL)                                         --
-- David R Brooks                                                    --
-- May, 2016.  Perth, Australia                                      --
-- Compliance: VHDL 2008                                             --
-- NB Simulation only: they are NOT synthesizable.                   --
-- Based on: Fairchild TTL Data Book (see for pinouts)               --
--           Signetics Low-Power Schottky Pocket Guide, 1978         --
-- Part names are in Texas format, ie SN74LSxxN                      --
-- The LS part is given when available, else the basic 74 part.      --
-- Pinouts & naming agree with Altium libraries & VHDL netlister.    --
-----------------------------------------------------------------------
library ieee;
    use ieee.std_logic_1164.all;

package LSTTL is

-----------------------------------------------------------------------
-- SN74LS00N: Quad 2-input NAND gate (Pinout A)
-----------------------------------------------------------------------
component SN74LS00N is
generic(
    tPLH : time := 10 ns;
    tPHL : time := 10 ns
);
port(
    X_1  : in    std_logic;  -- 1A
    X_2  : in    std_logic;  -- 1B
    X_3  : out   std_logic;  -- 1Y\
    X_4  : in    std_logic;  -- 2A
    X_5  : in    std_logic;  -- 2B
    X_6  : out   std_logic;  -- 2Y\
    X_7  : inout std_logic;  -- GND
    X_8  : out   std_logic;  -- 3Y\
    X_9  : in    std_logic;  -- 3B
    X_10 : in    std_logic;  -- 3A
    X_11 : out   std_logic;  -- 4Y\
    X_12 : in    std_logic;  -- 4B
    X_13 : in    std_logic;  -- 4A
    X_14 : inout std_logic   -- Vcc 
);
end component SN74LS00N;

-----------------------------------------------------------------------
-- SN7401N: Quad 2-input NAND gate (open collector) (Pinout A)
-----------------------------------------------------------------------
component SN7401N is
generic(
    tPLH : time := 15 ns;
    tPHL : time := 15 ns
);
port(
    X_1  : out   std_logic;  -- 1Y\
    X_2  : in    std_logic;  -- 1A
    X_3  : in    std_logic;  -- 1B
    X_4  : out   std_logic;  -- 2Y\
    X_5  : in    std_logic;  -- 2A
    X_6  : in    std_logic;  -- 2B
    X_7  : inout std_logic;  -- GND
    X_8  : in    std_logic;  -- 3B
    X_9  : in    std_logic;  -- 3A
    X_10 : out   std_logic;  -- 3Y\
    X_11 : in    std_logic;  -- 4B
    X_12 : in    std_logic;  -- 4A
    X_13 : out   std_logic;  -- 4Y\
    X_14 : inout std_logic   -- Vcc
);
end component SN7401N;

-----------------------------------------------------------------------
-- SN74LS02N: Quad 2-input NOR gate (Pinout A)
-----------------------------------------------------------------------
component SN74LS02N is
generic(
    tPLH : time := 15 ns;
    tPHL : time := 15 ns
);
port(
    X_1  : out   std_logic;  -- 1Y\
    X_2  : in    std_logic;  -- 1A
    X_3  : in    std_logic;  -- 1B
    X_4  : out   std_logic;  -- 2Y\
    X_5  : in    std_logic;  -- 2A
    X_6  : in    std_logic;  -- 2B
    X_7  : inout std_logic;  -- GND
    X_8  : in    std_logic;  -- 3B
    X_9  : in    std_logic;  -- 3A
    X_10 : out   std_logic;  -- 3Y\
    X_11 : in    std_logic;  -- 4B
    X_12 : in    std_logic;  -- 4A
    X_13 : out   std_logic;  -- 4Y\
    X_14 : inout std_logic   -- Vcc
);
end component SN74LS02N;

-----------------------------------------------------------------------
-- SN74LS03N: Quad 2-input NAND gate (open collector)
-----------------------------------------------------------------------
component SN74LS03N is
generic(
    tPLH : time := 22 ns;
    tPHL : time := 18 ns
);
port(
    X_1  : in    std_logic;  -- 1A
    X_2  : in    std_logic;  -- 1B
    X_3  : out   std_logic;  -- 1Y\
    X_4  : in    std_logic;  -- 2A
    X_5  : in    std_logic;  -- 2B
    X_6  : out   std_logic;  -- 2Y\
    X_7  : inout std_logic;  -- GND
    X_8  : out   std_logic;  -- 3Y\
    X_9  : in    std_logic;  -- 3B
    X_10 : in    std_logic;  -- 3A
    X_11 : out   std_logic;  -- 4Y\
    X_12 : in    std_logic;  -- 4B
    X_13 : in    std_logic;  -- 4A
    X_14 : inout std_logic   -- Vcc 
);
end component SN74LS03N;

-----------------------------------------------------------------------
-- SN74LS04N: Hex inverter (Pinout A)
-----------------------------------------------------------------------
component SN74LS04N is
generic(
    tPLH : time := 10 ns;
    tPHL : time := 10 ns
);
port(
    X_1  : in    std_logic;  -- 1A
    X_2  : out   std_logic;  -- 1Y\
    X_3  : in    std_logic;  -- 2A
    X_4  : out   std_logic;  -- 2Y\
    X_5  : in    std_logic;  -- 3A
    X_6  : out   std_logic;  -- 3Y\
    X_7  : inout std_logic;  -- GND
    X_8  : out   std_logic;  -- 4Y\
    X_9  : in    std_logic;  -- 4A
    X_10 : out   std_logic;  -- 5Y\
    X_11 : in    std_logic;  -- 5A
    X_12 : out   std_logic;  -- 6Y\
    X_13 : in    std_logic;  -- 6A
    X_14 : inout std_logic   -- Vcc
);
end component SN74LS04N;

-----------------------------------------------------------------------
-- SN74LS05N: Hex inverter (open collector) (Pinout A)
-----------------------------------------------------------------------
component SN74LS05N is
generic(
    tPLH : time := 32 ns;
    tPHL : time := 28 ns
);
port(
    X_1  : in    std_logic;  -- 1A
    X_2  : out   std_logic;  -- 1Y\
    X_3  : in    std_logic;  -- 2A
    X_4  : out   std_logic;  -- 2Y\
    X_5  : in    std_logic;  -- 3A
    X_6  : out   std_logic;  -- 3Y\
    X_7  : inout std_logic;  -- GND
    X_8  : out   std_logic;  -- 4Y\
    X_9  : in    std_logic;  -- 4A
    X_10 : out   std_logic;  -- 5Y\
    X_11 : in    std_logic;  -- 5A
    X_12 : out   std_logic;  -- 6Y\
    X_13 : in    std_logic;  -- 6A
    X_14 : inout std_logic   -- Vcc
);
end component SN74LS05N;

-----------------------------------------------------------------------
-- SN7406N: Hex inverter (high voltage open collector)
-----------------------------------------------------------------------
component SN7406N is
generic(
    tPLH : time := 15 ns;
    tPHL : time := 23 ns
);
port(
    X_1  : in    std_logic;  -- 1A
    X_2  : out   std_logic;  -- 1Y\
    X_3  : in    std_logic;  -- 2A
    X_4  : out   std_logic;  -- 2Y\
    X_5  : in    std_logic;  -- 3A
    X_6  : out   std_logic;  -- 3Y\
    X_7  : inout std_logic;  -- GND
    X_8  : out   std_logic;  -- 4Y\
    X_9  : in    std_logic;  -- 4A
    X_10 : out   std_logic;  -- 5Y\
    X_11 : in    std_logic;  -- 5A
    X_12 : out   std_logic;  -- 6Y\
    X_13 : in    std_logic;  -- 6A
    X_14 : inout std_logic   -- Vcc
);
end component SN7406N;

-----------------------------------------------------------------------
-- SN7407N: Hex buffer (high voltage open collector)
-----------------------------------------------------------------------
component SN7407N is
generic(
    tPLH : time := 10 ns;
    tPHL : time := 30 ns
);
port(
    X_1  : in    std_logic;  -- 1A
    X_2  : out   std_logic;  -- 1Y\
    X_3  : in    std_logic;  -- 2A
    X_4  : out   std_logic;  -- 2Y\
    X_5  : in    std_logic;  -- 3A
    X_6  : out   std_logic;  -- 3Y\
    X_7  : inout std_logic;  -- GND
    X_8  : out   std_logic;  -- 4Y\
    X_9  : in    std_logic;  -- 4A
    X_10 : out   std_logic;  -- 5Y\
    X_11 : in    std_logic;  -- 5A
    X_12 : out   std_logic;  -- 6Y\
    X_13 : in    std_logic;  -- 6A
    X_14 : inout std_logic   -- Vcc
);
end component SN7407N;

-----------------------------------------------------------------------
-- SN74LS08N: Quad 2-input AND gate (Pinout A)
-----------------------------------------------------------------------
component SN74LS08N is
port(
    X_1  : in    std_logic;  -- 1A
    X_2  : in    std_logic;  -- 1B
    X_3  : out   std_logic;  -- 1Y
    X_4  : in    std_logic;  -- 2A
    X_5  : in    std_logic;  -- 2B
    X_6  : out   std_logic;  -- 2Y
    X_7  : inout std_logic;  -- GND
    X_8  : out   std_logic;  -- 3Y
    X_9  : in    std_logic;  -- 3B
    X_10 : in    std_logic;  -- 3A
    X_11 : out   std_logic;  -- 4Y
    X_12 : in    std_logic;  -- 4B
    X_13 : in    std_logic;  -- 4A
    X_14 : inout std_logic   -- Vcc 
);
end component SN74LS08N;

-----------------------------------------------------------------------
-- SN74LS09N: Quad 2-input AND gate (open collector)
-----------------------------------------------------------------------
component SN74LS09N is
port(
    X_1  : in    std_logic;  -- 1A
    X_2  : in    std_logic;  -- 1B
    X_3  : out   std_logic;  -- 1Y
    X_4  : in    std_logic;  -- 2A
    X_5  : in    std_logic;  -- 2B
    X_6  : out   std_logic;  -- 2Y
    X_7  : inout std_logic;  -- GND
    X_8  : out   std_logic;  -- 3Y
    X_9  : in    std_logic;  -- 3B
    X_10 : in    std_logic;  -- 3A
    X_11 : out   std_logic;  -- 4Y
    X_12 : in    std_logic;  -- 4B
    X_13 : in    std_logic;  -- 4A
    X_14 : inout std_logic   -- Vcc 
);
end component SN74LS09N;

-----------------------------------------------------------------------
-- SN74LS10N: Triple 3-input NAND gate (Pinout A)
-----------------------------------------------------------------------
component SN74LS10N is
generic(
    tPLH : time := 15 ns;
    tPHL : time := 15 ns
);
port(
    X_1  : in    std_logic;  -- 1A
    X_2  : in    std_logic;  -- 1B
    X_3  : in    std_logic;  -- 2A
    X_4  : in    std_logic;  -- 2B
    X_5  : in    std_logic;  -- 2C
    X_6  : out   std_logic;  -- 2Y\
    X_7  : inout std_logic;  -- GND
    X_8  : out   std_logic;  -- 3Y\
    X_9  : in    std_logic;  -- 3C
    X_10 : in    std_logic;  -- 3B
    X_11 : in    std_logic;  -- 3A
    X_12 : out   std_logic;  -- 1Y\
    X_13 : in    std_logic;  -- 1C
    X_14 : inout std_logic   -- Vcc
);
end component SN74LS10N;

-----------------------------------------------------------------------
-- SN74LS11N: Triple 3-input AND gate (Pinout A)
-----------------------------------------------------------------------
component SN74LS11N is
generic(
    tPLH : time := 15 ns;
    tPHL : time := 20 ns
);
port(
    X_1  : in    std_logic;  -- 1A
    X_2  : in    std_logic;  -- 1B
    X_3  : in    std_logic;  -- 2A
    X_4  : in    std_logic;  -- 2B
    X_5  : in    std_logic;  -- 2C
    X_6  : out   std_logic;  -- 2Y\
    X_7  : inout std_logic;  -- GND
    X_8  : out   std_logic;  -- 3Y\
    X_9  : in    std_logic;  -- 3C
    X_10 : in    std_logic;  -- 3B
    X_11 : in    std_logic;  -- 3A
    X_12 : out   std_logic;  -- 1Y\
    X_13 : in    std_logic;  -- 1C
    X_14 : inout std_logic   -- Vcc
);
end component SN74LS11N;

-----------------------------------------------------------------------
-- SN74LS12N: Triple 3-input NAND gate (open collector)
-----------------------------------------------------------------------
component SN74LS12N is
generic(
    tPLH : time := 32 ns;
    tPHL : time := 28 ns
);
port(
    X_1  : in    std_logic;  -- 1A
    X_2  : in    std_logic;  -- 1B
    X_3  : in    std_logic;  -- 2A
    X_4  : in    std_logic;  -- 2B
    X_5  : in    std_logic;  -- 2C
    X_6  : out   std_logic;  -- 2Y\
    X_7  : inout std_logic;  -- GND
    X_8  : out   std_logic;  -- 3Y\
    X_9  : in    std_logic;  -- 3C
    X_10 : in    std_logic;  -- 3B
    X_11 : in    std_logic;  -- 3A
    X_12 : out   std_logic;  -- 1Y\
    X_13 : in    std_logic;  -- 1C
    X_14 : inout std_logic   -- Vcc
);
end component SN74LS12N;

-----------------------------------------------------------------------
-- SN74LS13N: Dual 4-input NAND Schmitt trigger
-----------------------------------------------------------------------
component SN74LS13N is
generic(
    tPLH : time := 22 ns;
    tPHL : time := 27 ns
);
port(
    X_1  : in    std_logic;  -- 1A
    X_2  : in    std_logic;  -- 1B
                             -- 
    X_4  : in    std_logic;  -- 1C
    X_5  : in    std_logic;  -- 1D
    X_6  : out   std_logic;  -- 1Y\
    X_7  : inout std_logic;  -- GND
    X_8  : out   std_logic;  -- 2Y\
    X_9  : in    std_logic;  -- 2D
    X_10 : in    std_logic;  -- 2C
                             -- 
    X_12 : in    std_logic;  -- 2B
    X_13 : in    std_logic;  -- 2A
    X_14 : inout std_logic   -- Vcc
);
end component SN74LS13N;

-----------------------------------------------------------------------
-- SN74LS14N: Hex Schmitt trigger inverter
-----------------------------------------------------------------------
component SN74LS14N is
generic(
    tPLH : time := 22 ns;
    tPHL : time := 22 ns
);
port(
    X_1  : in    std_logic;  -- 1A
    X_2  : out   std_logic;  -- 1Y\
    X_3  : in    std_logic;  -- 2A
    X_4  : out   std_logic;  -- 2Y\
    X_5  : in    std_logic;  -- 3A
    X_6  : out   std_logic;  -- 3Y\
    X_7  : inout std_logic;  -- GND
    X_8  : out   std_logic;  -- 4Y\
    X_9  : in    std_logic;  -- 4A
    X_10 : out   std_logic;  -- 5Y\
    X_11 : in    std_logic;  -- 5A
    X_12 : out   std_logic;  -- 6Y\
    X_13 : in    std_logic;  -- 6A
    X_14 : inout std_logic   -- Vcc
);
end component SN74LS14N;

-----------------------------------------------------------------------
-- SN74LS15N: Triple 3-input AND gate (open collector)
-----------------------------------------------------------------------
component SN74LS15N is
generic(
    tPLH : time := 35 ns;
    tPHL : time := 35 ns
);
port(
    X_1  : in    std_logic;  -- 1A
    X_2  : in    std_logic;  -- 1B
    X_3  : in    std_logic;  -- 2A
    X_4  : in    std_logic;  -- 2B
    X_5  : in    std_logic;  -- 2C
    X_6  : out   std_logic;  -- 2Y\
    X_7  : inout std_logic;  -- GND
    X_8  : out   std_logic;  -- 3Y\
    X_9  : in    std_logic;  -- 3C
    X_10 : in    std_logic;  -- 3B
    X_11 : in    std_logic;  -- 3A
    X_12 : out   std_logic;  -- 1Y\
    X_13 : in    std_logic;  -- 1C
    X_14 : inout std_logic   -- Vcc
);
end component SN74LS15N;

-----------------------------------------------------------------------
-- SN7416N: Hex inverter/driver (high voltage open collector)
-----------------------------------------------------------------------
component SN7416N is
generic(
    tPLH : time := 15 ns;
    tPHL : time := 23 ns
);
port(
    X_1  : in    std_logic;  -- 1A
    X_2  : out   std_logic;  -- 1Y\
    X_3  : in    std_logic;  -- 2A
    X_4  : out   std_logic;  -- 2Y\
    X_5  : in    std_logic;  -- 3A
    X_6  : out   std_logic;  -- 3Y\
    X_7  : inout std_logic;  -- GND
    X_8  : out   std_logic;  -- 4Y\
    X_9  : in    std_logic;  -- 4A
    X_10 : out   std_logic;  -- 5Y\
    X_11 : in    std_logic;  -- 5A
    X_12 : out   std_logic;  -- 6Y\
    X_13 : in    std_logic;  -- 6A
    X_14 : inout std_logic   -- Vcc
);
end component SN7416N;

-----------------------------------------------------------------------
-- SN7417N: Hex buffer/driver (high voltage open collector)
-----------------------------------------------------------------------
component SN7417N is
generic(
    tPLH : time := 10 ns;
    tPHL : time := 30 ns
);
port(
    X_1  : in    std_logic;  -- 1A
    X_2  : out   std_logic;  -- 1Y\
    X_3  : in    std_logic;  -- 2A
    X_4  : out   std_logic;  -- 2Y\
    X_5  : in    std_logic;  -- 3A
    X_6  : out   std_logic;  -- 3Y\
    X_7  : inout std_logic;  -- GND
    X_8  : out   std_logic;  -- 4Y\
    X_9  : in    std_logic;  -- 4A
    X_10 : out   std_logic;  -- 5Y\
    X_11 : in    std_logic;  -- 5A
    X_12 : out   std_logic;  -- 6Y\
    X_13 : in    std_logic;  -- 6A
    X_14 : inout std_logic   -- Vcc
);
end component SN7417N;

-- SN74LS19AN: Schmitt trigger inverters

-----------------------------------------------------------------------
-- SN74LS20N: Dual 4-input NAND gate (Pinout A)
-----------------------------------------------------------------------
component SN74LS20N is
generic(
    tPLH : time := 15 ns;
    tPHL : time := 15 ns
);
port(
    X_1  : in    std_logic;  -- 1A
    X_2  : in    std_logic;  -- 1B
                             -- 
    X_4  : in    std_logic;  -- 1C
    X_5  : in    std_logic;  -- 1D
    X_6  : out   std_logic;  -- 1Y\
    X_7  : inout std_logic;  -- GND
    X_8  : out   std_logic;  -- 2Y\
    X_9  : in    std_logic;  -- 2D
    X_10 : in    std_logic;  -- 2C
                             -- 
    X_12 : in    std_logic;  -- 2B
    X_13 : in    std_logic;  -- 2A
    X_14 : inout std_logic   -- Vcc
);
end component SN74LS20N;

-----------------------------------------------------------------------
-- SN74LS21N: Dual 4-input AND gate (Pinout A)
-----------------------------------------------------------------------
component SN74LS21N is
generic(
    tPLH : time := 15 ns;
    tPHL : time := 20 ns
);
port(
    X_1  : in    std_logic;  -- 1A
    X_2  : in    std_logic;  -- 1B
                             -- 
    X_4  : in    std_logic;  -- 1C
    X_5  : in    std_logic;  -- 1D
    X_6  : out   std_logic;  -- 1Y\
    X_7  : inout std_logic;  -- GND
    X_8  : out   std_logic;  -- 2Y\
    X_9  : in    std_logic;  -- 2D
    X_10 : in    std_logic;  -- 2C
                             -- 
    X_12 : in    std_logic;  -- 2B
    X_13 : in    std_logic;  -- 2A
    X_14 : inout std_logic   -- Vcc
);
end component SN74LS21N;

-----------------------------------------------------------------------
-- SN74LS22N: Dual 4-input NAND gate (open collector) (Pinout A)
-----------------------------------------------------------------------
component SN74LS22N is
generic(
    tPLH : time := 22 ns;
    tPHL : time := 18 ns
);
port(
    X_1  : in    std_logic;  -- 1A
    X_2  : in    std_logic;  -- 1B
                             -- 
    X_4  : in    std_logic;  -- 1C
    X_5  : in    std_logic;  -- 1D
    X_6  : out   std_logic;  -- 1Y\
    X_7  : inout std_logic;  -- GND
    X_8  : out   std_logic;  -- 2Y\
    X_9  : in    std_logic;  -- 2D
    X_10 : in    std_logic;  -- 2C
                             -- 
    X_12 : in    std_logic;  -- 2B
    X_13 : in    std_logic;  -- 2A
    X_14 : inout std_logic   -- Vcc
);
end component SN74LS22N;

-- SN74LS24AN: Schmitt trigger positive NAND gates
-- SN7425N: Dual 4-input NOR gate (with strobe)

-----------------------------------------------------------------------
-- SN74LS26N: Quad 2-input NAND buffer (open collector)
-----------------------------------------------------------------------
component SN74LS26N is
port(
    X_1  : in    std_logic;  -- 1A
    X_2  : in    std_logic;  -- 1B
    X_3  : out   std_logic;  -- 1Y\
    X_4  : in    std_logic;  -- 2A
    X_5  : in    std_logic;  -- 2B
    X_6  : out   std_logic;  -- 2Y\
    X_7  : inout std_logic;  -- GND
    X_8  : out   std_logic;  -- 3Y\
    X_9  : in    std_logic;  -- 3B
    X_10 : in    std_logic;  -- 3A
    X_11 : out   std_logic;  -- 4Y\
    X_12 : in    std_logic;  -- 4B
    X_13 : in    std_logic;  -- 4A
    X_14 : inout std_logic   -- Vcc 
);
end component SN74LS26N;

-----------------------------------------------------------------------
-- SN74LS27N: Triple 3-input NOR gate
-----------------------------------------------------------------------
component SN74LS27N is
generic(
    tPLH : time := 13 ns;
    tPHL : time := 13 ns
);
port(
    X_1  : in    std_logic;  -- 1A
    X_2  : in    std_logic;  -- 1B
    X_3  : in    std_logic;  -- 2A
    X_4  : in    std_logic;  -- 2B
    X_5  : in    std_logic;  -- 2C
    X_6  : out   std_logic;  -- 2Y\
    X_7  : inout std_logic;  -- GND
    X_8  : out   std_logic;  -- 3Y\
    X_9  : in    std_logic;  -- 3C
    X_10 : in    std_logic;  -- 3B
    X_11 : in    std_logic;  -- 3A
    X_12 : out   std_logic;  -- 1Y\
    X_13 : in    std_logic;  -- 1C
    X_14 : inout std_logic   -- Vcc
);
end component SN74LS27N;

-----------------------------------------------------------------------
-- SN74LS28N: Quad 2-input NOR buffer
-----------------------------------------------------------------------
component SN74LS28N is
generic(
    tPLH : time := 20 ns;
    tPHL : time := 20 ns
);
port(
    X_1  : out   std_logic;  -- 1Y\
    X_2  : in    std_logic;  -- 1A
    X_3  : in    std_logic;  -- 1B
    X_4  : out   std_logic;  -- 2Y\
    X_5  : in    std_logic;  -- 2A
    X_6  : in    std_logic;  -- 2B
    X_7  : inout std_logic;  -- GND
    X_8  : in    std_logic;  -- 3B
    X_9  : in    std_logic;  -- 3A
    X_10 : out   std_logic;  -- 3Y\
    X_11 : in    std_logic;  -- 4B
    X_12 : in    std_logic;  -- 4A
    X_13 : out   std_logic;  -- 4Y\
    X_14 : inout std_logic   -- Vcc
);
end component SN74LS28N;

-----------------------------------------------------------------------
-- SN74LS30N: 8-input NAND gate (Pinout A)
-----------------------------------------------------------------------
component SN74LS30N is
generic(
    tPLH : time := 15 ns;
    tPHL : time := 20 ns
);
port(
    X_1  : in    std_logic;  -- 1A
    X_2  : in    std_logic;  -- 1B
    X_3  : in    std_logic;  -- 1C
    X_4  : in    std_logic;  -- 1D
    X_5  : in    std_logic;  -- 1E
    X_6  : in    std_logic;  -- 1F
    X_7  : inout std_logic;  -- GND
    X_8  : out   std_logic;  -- 1Y\
                             -- 
                             -- 
    X_11 : in    std_logic;  -- 1G
    X_12 : in    std_logic;  -- 1H
                             --
    X_14 : inout std_logic   -- Vcc
);
end component SN74LS30N;

-- SN74LS31N: delay element

-----------------------------------------------------------------------
-- SN74LS32N: Quad 2-input OR gate
-----------------------------------------------------------------------
component SN74LS32N is
port(
    X_1  : in    std_logic;  -- 1A
    X_2  : in    std_logic;  -- 1B
    X_3  : out   std_logic;  -- 1Y
    X_4  : in    std_logic;  -- 2A
    X_5  : in    std_logic;  -- 2B
    X_6  : out   std_logic;  -- 2Y
    X_7  : inout std_logic;  -- GND
    X_8  : out   std_logic;  -- 3Y
    X_9  : in    std_logic;  -- 3B
    X_10 : in    std_logic;  -- 3A
    X_11 : out   std_logic;  -- 4Y
    X_12 : in    std_logic;  -- 4B
    X_13 : in    std_logic;  -- 4A
    X_14 : inout std_logic   -- Vcc 
);
end component SN74LS32N;

-----------------------------------------------------------------------
-- SN74LS33N: Quad 2-input NOR buffer (open collector)
-----------------------------------------------------------------------
component SN74LS33N is
generic(
    tPLH : time := 32 ns;
    tPHL : time := 28 ns
);
port(
    X_1  : out   std_logic;  -- 1Y\
    X_2  : in    std_logic;  -- 1A
    X_3  : in    std_logic;  -- 1B
    X_4  : out   std_logic;  -- 2Y\
    X_5  : in    std_logic;  -- 2A
    X_6  : in    std_logic;  -- 2B
    X_7  : inout std_logic;  -- GND
    X_8  : in    std_logic;  -- 3B
    X_9  : in    std_logic;  -- 3A
    X_10 : out   std_logic;  -- 3Y\
    X_11 : in    std_logic;  -- 4B
    X_12 : in    std_logic;  -- 4A
    X_13 : out   std_logic;  -- 4Y\
    X_14 : inout std_logic   -- Vcc
);
end component SN74LS33N;

-----------------------------------------------------------------------
-- SN74LS37N: Quad 2-input NAND buffer
-----------------------------------------------------------------------
component SN74LS37N is
port(
    X_1  : in    std_logic;  -- 1A
    X_2  : in    std_logic;  -- 1B
    X_3  : out   std_logic;  -- 1Y\
    X_4  : in    std_logic;  -- 2A
    X_5  : in    std_logic;  -- 2B
    X_6  : out   std_logic;  -- 2Y\
    X_7  : inout std_logic;  -- GND
    X_8  : out   std_logic;  -- 3Y\
    X_9  : in    std_logic;  -- 3B
    X_10 : in    std_logic;  -- 3A
    X_11 : out   std_logic;  -- 4Y\
    X_12 : in    std_logic;  -- 4B
    X_13 : in    std_logic;  -- 4A
    X_14 : inout std_logic   -- Vcc 
);
end component SN74LS37N;

-----------------------------------------------------------------------
-- SN74LS38N: Quad 2-input NAND buffer (open collector)
-----------------------------------------------------------------------
component SN74LS38N is
port(
    X_1  : in    std_logic;  -- 1A
    X_2  : in    std_logic;  -- 1B
    X_3  : out   std_logic;  -- 1Y\
    X_4  : in    std_logic;  -- 2A
    X_5  : in    std_logic;  -- 2B
    X_6  : out   std_logic;  -- 2Y\
    X_7  : inout std_logic;  -- GND
    X_8  : out   std_logic;  -- 3Y\
    X_9  : in    std_logic;  -- 3B
    X_10 : in    std_logic;  -- 3A
    X_11 : out   std_logic;  -- 4Y\
    X_12 : in    std_logic;  -- 4B
    X_13 : in    std_logic;  -- 4A
    X_14 : inout std_logic   -- Vcc 
);
end component SN74LS38N;

-----------------------------------------------------------------------
-- SN74LS39N: Quad 2-input NAND buffer (open collector) (Pinout A)
-----------------------------------------------------------------------
component SN74LS39N is
generic(
    tPLH : time := 22 ns;
    tPHL : time := 18 ns
);
port(
    X_1  : out   std_logic;  -- 1Y\
    X_2  : in    std_logic;  -- 1A
    X_3  : in    std_logic;  -- 1B
    X_4  : out   std_logic;  -- 2Y\
    X_5  : in    std_logic;  -- 2A
    X_6  : in    std_logic;  -- 2B
    X_7  : inout std_logic;  -- GND
    X_8  : in    std_logic;  -- 3B
    X_9  : in    std_logic;  -- 3A
    X_10 : out   std_logic;  -- 3Y\
    X_11 : in    std_logic;  -- 4B
    X_12 : in    std_logic;  -- 4A
    X_13 : out   std_logic;  -- 4Y\
    X_14 : inout std_logic   -- Vcc
);
end component SN74LS39N;

-----------------------------------------------------------------------
-- SN74LS40N: Dual 4-input NAND buffer (Pinout A)
-----------------------------------------------------------------------
component SN74LS40N is
generic(
    tPLH : time := 24 ns;
    tPHL : time := 24 ns
);
port(
    X_1  : in    std_logic;  -- 1A
    X_2  : in    std_logic;  -- 1B
                             -- 
    X_4  : in    std_logic;  -- 1C
    X_5  : in    std_logic;  -- 1D
    X_6  : out   std_logic;  -- 1Y\
    X_7  : inout std_logic;  -- GND
    X_8  : out   std_logic;  -- 2Y\
    X_9  : in    std_logic;  -- 2D
    X_10 : in    std_logic;  -- 2C
                             -- 
    X_12 : in    std_logic;  -- 2B
    X_13 : in    std_logic;  -- 2A
    X_14 : inout std_logic   -- Vcc
);
end component SN74LS40N;

-----------------------------------------------------------------------
-- SN74LS42N: 1-of-10 decoder
-----------------------------------------------------------------------
component SN74LS42N is
generic(
    tPLH : time := 20 ns;
    tPHL : time := 27 ns
);
port(
    X_1  : out   std_logic;  -- Q0\
    X_2  : out   std_logic;  -- Q1\
    X_3  : out   std_logic;  -- Q2\
    X_4  : out   std_logic;  -- Q3\
    X_5  : out   std_logic;  -- Q4\
    X_6  : out   std_logic;  -- Q5\
    X_7  : out   std_logic;  -- Q6\
    X_8  : inout std_logic;  -- GND
    X_9  : out   std_logic;  -- Q7\
    X_10 : out   std_logic;  -- Q8\
    X_11 : out   std_logic;  -- Q9\
    X_12 : in    std_logic;  -- A3
    X_13 : in    std_logic;  -- A2
    X_14 : in    std_logic;  -- A1
    X_15 : in    std_logic;  -- A0
    X_16 : inout std_logic   -- Vcc
);
end component SN74LS42N;

-----------------------------------------------------------------------
-- SN7445N: 1-of-10 decoder/driver (open collector)
-----------------------------------------------------------------------
component SN7445N is
generic(
    tPLH : time := 50 ns;
    tPHL : time := 50 ns
);
port(
    X_1  : out   std_logic;  -- Q0\
    X_2  : out   std_logic;  -- Q1\
    X_3  : out   std_logic;  -- Q2\
    X_4  : out   std_logic;  -- Q3\
    X_5  : out   std_logic;  -- Q4\
    X_6  : out   std_logic;  -- Q5\
    X_7  : out   std_logic;  -- Q6\
    X_8  : inout std_logic;  -- GND
    X_9  : out   std_logic;  -- Q7\
    X_10 : out   std_logic;  -- Q8\
    X_11 : out   std_logic;  -- Q9\
    X_12 : in    std_logic;  -- A3
    X_13 : in    std_logic;  -- A2
    X_14 : in    std_logic;  -- A1
    X_15 : in    std_logic;  -- A0
    X_16 : inout std_logic   -- Vcc
);
end component SN7445N;

-- SN74LS47N: BCD to 7-segment decoder/driver
-- SN74LS48N: BCD to 7-segment decoder
-- SN74LS49N: BCD to 7-segment decoder
-- SN7450P: Expandable dual 2-wide 2-input and-or-invert gate

-----------------------------------------------------------------------
-- SN74LS51N: Dual 2-wide, 2/3-input AND-OR-Invert gate (Pinout B)
-----------------------------------------------------------------------
component SN74LS51N is
generic(
    tPLH : time := 20 ns;
    tPHL : time := 20 ns
);
port(
    X_1  : in    std_logic;  -- 2A1
    X_2  : in    std_logic;  -- 1A1
    X_3  : in    std_logic;  -- 1A2
    X_4  : in    std_logic;  -- 1B1
    X_5  : in    std_logic;  -- 1B2
    X_6  : out   std_logic;  -- 1Y\
    X_7  : inout std_logic;  -- GND
    X_8  : out   std_logic;  -- 2Y\
    X_9  : in    std_logic;  -- 2B3
    X_10 : in    std_logic;  -- 2B2
    X_11 : in    std_logic;  -- 2B1
    X_12 : in    std_logic;  -- 2A3
    X_13 : in    std_logic;  -- 2A2
    X_14 : inout std_logic   -- Vcc
);
end component SN74LS51N;

-- SN74H52: Expandable 2-2-2-3-input and-or gate
-- SN7453:  Expandable 4-wide 2-input and-or-invert gate
-- SN74H53: Expandable 2-2-2-3-input and-or-invert gate

-----------------------------------------------------------------------
-- SN74LS54N: 4-wide 2-input AND-OR-Invert gate (Pinout C)
-----------------------------------------------------------------------
component SN74LS54N is
generic(
    tPLH : time := 20 ns;
    tPHL : time := 20 ns
);
port(
    X_1  : in    std_logic;  -- 1A1
    X_2  : in    std_logic;  -- 1A2
    X_3  : in    std_logic;  -- 1B1
    X_4  : in    std_logic;  -- 1B2
    X_5  : in    std_logic;  -- 1B3
    X_6  : out   std_logic;  -- 1Y\
    X_7  : inout std_logic;  -- GND
                             -- 
    X_9  : in    std_logic;  -- 1D3
    X_10 : in    std_logic;  -- 1D2
    X_11 : in    std_logic;  -- 1D1
    X_12 : in    std_logic;  -- 1C2
    X_13 : in    std_logic;  -- 1C1
    X_14 : inout std_logic   -- Vcc
);
end component SN74LS54N;

-----------------------------------------------------------------------
-- SN74LS55N: 2-wide 4-input AND-OR-Invert gate (Pinout B)
-----------------------------------------------------------------------
component SN74LS55N is
generic(
    tPLH : time := 15 ns;
    tPHL : time := 15 ns
);
port(
    X_1  : in    std_logic;  -- 1A1
    X_2  : in    std_logic;  -- 1A2
    X_3  : in    std_logic;  -- 1A3
    X_4  : in    std_logic;  -- 1A4
                             -- 
                             -- 
    X_7  : inout std_logic;  -- GND
    X_8  : out   std_logic;  -- 1Y\
                             -- 
    X_10 : in    std_logic;  -- 1B4
    X_11 : in    std_logic;  -- 1B3
    X_12 : in    std_logic;  -- 1B2
    X_13 : in    std_logic;  -- 1B1
    X_14 : inout std_logic   -- Vcc
);
end component SN74LS55N;

-- SN74LS56P: frequency divider
-- SN74LS57P: frequency divider
-- SN7460: Dual 4-input expander
-- SN74H60: Dual 4-input expander
-- SN74H61: Triple 3-input expander
-- SN74H62: 3-2-2-3-input and-or expander

-----------------------------------------------------------------------
-- SN74S64N: 4-2-3-2 input AND-OR-Invert gate
-----------------------------------------------------------------------
component SN74S64N is
generic(
    tPLH : time := 5.5 ns;
    tPHL : time := 5.5 ns
);
port(
    X_1  : in    std_logic;  -- 1D1
    X_2  : in    std_logic;  -- 1A1
    X_3  : in    std_logic;  -- 1A2
    X_4  : in    std_logic;  -- 1B1
    X_5  : in    std_logic;  -- 1B2
    X_6  : in    std_logic;  -- 1B3
    X_7  : inout std_logic;  -- GND
    X_8  : out   std_logic;  -- 1Y\
    X_9  : in    std_logic;  -- 1C2
    X_10 : in    std_logic;  -- 1C1
    X_11 : in    std_logic;  -- 1D4
    X_12 : in    std_logic;  -- 1D3
    X_13 : in    std_logic;  -- 1D2
    X_14 : inout std_logic   -- Vcc
);
end component SN74S64N;

-----------------------------------------------------------------------
-- SN74S65N: 4-2-3-2 input AND-OR-Invert gate (open collector)
-----------------------------------------------------------------------
component SN74S65N is
generic(
    tPLH : time := 7.5 ns;
    tPHL : time := 8.5 ns
);
port(
    X_1  : in    std_logic;  -- 1D1
    X_2  : in    std_logic;  -- 1A1
    X_3  : in    std_logic;  -- 1A2
    X_4  : in    std_logic;  -- 1B1
    X_5  : in    std_logic;  -- 1B2
    X_6  : in    std_logic;  -- 1B3
    X_7  : inout std_logic;  -- GND
    X_8  : out   std_logic;  -- 1Y\
    X_9  : in    std_logic;  -- 1C2
    X_10 : in    std_logic;  -- 1C1
    X_11 : in    std_logic;  -- 1D4
    X_12 : in    std_logic;  -- 1D3
    X_13 : in    std_logic;  -- 1D2
    X_14 : inout std_logic   -- Vcc
);
end component SN74S65N;

-----------------------------------------------------------------------
-- SN74LS68N: Dual 4-bit decade counter
-----------------------------------------------------------------------
component SN74LS68N is
generic(
    tPLH10 : time := 11 ns;
    tPHL10 : time := 21 ns;
    tPLH11 : time := 12 ns;
    tPHL11 : time := 18 ns;
    tPLH12 : time := 23 ns;
    tPHL12 : time := 32 ns;
    tPLH13 : time := 12 ns;
    tPHL13 : time := 20 ns;
    tPLH20 : time := 11 ns;
    tPHL20 : time := 21 ns;
    tPLH21 : time := 24 ns;
    tPHL21 : time := 29 ns;
    tPLH22 : time := 35 ns;
    tPHL22 : time := 40 ns;
    tPLH23 : time := 24 ns;
    tPHL23 : time := 29 ns
);
port(
    X_1  : in    std_logic;  -- 1CLKA
    X_2  : out   std_logic;  -- 1QB
    X_3  : out   std_logic;  -- 1QD
    X_4  : in    std_logic;  -- \1CLR
    X_5  : out   std_logic;  -- 2QC
                             -- 
    X_7  : out   std_logic;  -- 2QA
    X_8  : inout std_logic;  -- GND
    X_9  : in    std_logic;  -- 2CLK
    X_10 : out   std_logic;  -- 2QB
    X_11 : in    std_logic;  -- \2CLR
    X_12 : out   std_logic;  -- 2QD
    X_13 : out   std_logic;  -- 1QC
    X_14 : out   std_logic;  -- 1QA
    X_15 : in    std_logic;  -- 1CLKB
    X_16 : inout std_logic   -- Vcc
);
end component SN74LS68N;

-----------------------------------------------------------------------
-- SN74LS69N: Dual 4-bit binary counter
-----------------------------------------------------------------------
component SN74LS69N is
generic(
    tPLH10 : time := 11 ns;
    tPHL10 : time := 21 ns;
    tPLH11 : time := 11 ns;
    tPHL11 : time := 21 ns;
    tPLH12 : time := 24 ns;
    tPHL12 : time := 32 ns;
    tPLH13 : time := 38 ns;
    tPHL13 : time := 45 ns;
    tPLH20 : time := 11 ns;
    tPHL20 : time := 21 ns;
    tPLH21 : time := 21 ns;
    tPHL21 : time := 29 ns;
    tPLH22 : time := 35 ns;
    tPHL22 : time := 40 ns;
    tPLH23 : time := 54 ns;
    tPHL23 : time := 30 ns
);
port(
    X_1  : in    std_logic;  -- 1CLKA
    X_2  : out   std_logic;  -- 1QB
    X_3  : out   std_logic;  -- 1QD
    X_4  : in    std_logic;  -- \1CLR
    X_5  : out   std_logic;  -- 2QC
                             -- 
    X_7  : out   std_logic;  -- 2QA
    X_8  : inout std_logic;  -- GND
    X_9  : in    std_logic;  -- 2CLK
    X_10 : out   std_logic;  -- 2QB
    X_11 : in    std_logic;  -- \2CLR
    X_12 : out   std_logic;  -- 2QD
    X_13 : out   std_logic;  -- 1QC
    X_14 : out   std_logic;  -- 1QA
    X_15 : in    std_logic;  -- 1CLKB
    X_16 : inout std_logic   -- Vcc
);
end component SN74LS69N;

-----------------------------------------------------------------------
-- SN74LS70N: JK edge-triggered flipflop (Pinout A)
-----------------------------------------------------------------------
component SN74LS70N is
generic(
    tSETUP : time := 20 ns;     -- Setup time before clock
    tPLHCP : time := 50 ns;     -- Clock rising
    tPHLCP : time := 50 ns;     -- Clock falling
    tPLHSC : time := 50 ns;     -- S/C rising
    tPHLSC : time := 50 ns      -- S/C falling
);
port(
                             -- 
    X_2  : in    std_logic;  -- CD\
    X_3  : in    std_logic;  -- J1
    X_4  : in    std_logic;  -- J2
    X_5  : in    std_logic;  -- J3\
    X_6  : out   std_logic;  -- Q\
    X_7  : inout std_logic;  -- GND
    X_8  : out   std_logic;  -- Q
    X_9  : in    std_logic;  -- K3\
    X_10 : in    std_logic;  -- K1
    X_11 : in    std_logic;  -- K2
    X_12 : in    std_logic;  -- CP
    X_13 : in    std_logic;  -- SD\
    X_14 : inout std_logic   -- Vcc
);
end component SN74LS70N;

-----------------------------------------------------------------------
-- SN74LS71N: JK master-slave flipflop (with AND/OR inputs)
-----------------------------------------------------------------------
component SN74LS71N is
generic(
    tSETUP : time :=  0 ns;     -- Setup time before clock
    tPLHCP : time := 21 ns;     -- Clock rising
    tPHLCP : time := 27 ns;     -- Clock falling
    tPLHSC : time := 13 ns;     -- S/C rising
    tPHLSC : time := 24 ns      -- S/C falling
);
port(
    X_1  : in    std_logic;  -- J1A
    X_2  : in    std_logic;  -- J1B
    X_3  : in    std_logic;  -- J2A
    X_4  : in    std_logic;  -- J2B
    X_5  : in    std_logic;  -- SD\
    X_6  : out   std_logic;  -- Q
    X_7  : inout std_logic;  -- GND
    X_8  : out   std_logic;  -- Q\
    X_9  : in    std_logic;  -- K1A
    X_10 : in    std_logic;  -- K1B
    X_11 : in    std_logic;  -- K2A
    X_12 : in    std_logic;  -- K2B
    X_13 : in    std_logic;  -- CP
    X_14 : inout std_logic   -- Vcc
);
end component SN74LS71N;

-----------------------------------------------------------------------
-- SN74LS72N: JK master-slave flipflop (with AND inputs) (Pinout A)
-----------------------------------------------------------------------
component SN74LS72N is
generic(
    tSETUP : time :=  0 ns;     -- Setup time before clock
    tPLHCP : time := 21 ns;     -- Clock rising
    tPHLCP : time := 27 ns;     -- Clock falling
    tPLHSC : time := 13 ns;     -- S/C rising
    tPHLSC : time := 24 ns      -- S/C falling
);
port(
                             -- 
    X_2  : in    std_logic;  -- CD\
    X_3  : in    std_logic;  -- J1
    X_4  : in    std_logic;  -- J2
    X_5  : in    std_logic;  -- J3
    X_6  : out   std_logic;  -- Q\
    X_7  : inout std_logic;  -- GND
    X_8  : out   std_logic;  -- Q
    X_9  : in    std_logic;  -- K1
    X_10 : in    std_logic;  -- K2
    X_11 : in    std_logic;  -- K3
    X_12 : in    std_logic;  -- CP\
    X_13 : in    std_logic;  -- SD\
    X_14 : inout std_logic   -- Vcc
 );
end component SN74LS72N;

-----------------------------------------------------------------------
-- SN74LS73N: Dual JK flipflop
-----------------------------------------------------------------------
component SN74LS73N is
generic(
    tSETUP : time := 20 ns;     -- Setup time before clock
    tPLHCP : time := 20 ns;     -- Clock rising
    tPHLCP : time := 30 ns;     -- Clock falling
    tPLHSC : time := 20 ns;     -- S/C rising
    tPHLSC : time := 30 ns      -- S/C falling
);
port(
    X_1  : in    std_logic;  -- CP1\
    X_2  : in    std_logic;  -- CD1\
    X_3  : in    std_logic;  -- K1
    X_4  : inout std_logic;  -- Vcc
    X_5  : in    std_logic;  -- CP2\
    X_6  : in    std_logic;  -- CD2\
    X_7  : in    std_logic;  -- J2
    X_8  : out   std_logic;  -- Q2\
    X_9  : out   std_logic;  -- Q2
    X_10 : in    std_logic;  -- K2
    X_11 : inout std_logic;  -- GND
    X_12 : out   std_logic;  -- Q1
    X_13 : out   std_logic;  -- Q1\
    X_14 : in    std_logic   -- J1
);
end component SN74LS73N;

-----------------------------------------------------------------------
-- SN74LS74N: Dual D-type +ve edge-triggered flipflop (Pinout A)
-----------------------------------------------------------------------
component SN74LS74N is
generic(
    tSETUP : time := 20 ns;     -- Setup time before clock
    tPLHCP : time := 25 ns;     -- Clock rising
    tPHLCP : time := 35 ns;     -- Clock falling
    tPLHSC : time := 15 ns;     -- S/C rising
    tPHLSC : time := 35 ns      -- S/C falling
);
port(
    X_1  : in    std_logic;  -- CD1\
    X_2  : in    std_logic;  -- D1
    X_3  : in    std_logic;  -- CP1
    X_4  : in    std_logic;  -- SD1\
    X_5  : out   std_logic;  -- Q1
    X_6  : out   std_logic;  -- Q1\
    X_7  : inout std_logic;  -- GND
    X_8  : out   std_logic;  -- Q2\
    X_9  : out   std_logic;  -- Q2
    X_10 : in    std_logic;  -- SD2\
    X_11 : in    std_logic;  -- CP2
    X_12 : in    std_logic;  -- D2
    X_13 : in    std_logic;  -- CD2\
    X_14 : inout std_logic   -- Vcc
);
end component SN74LS74N;

-----------------------------------------------------------------------
-- SN74LS75N: 4-bit bistable latch
-----------------------------------------------------------------------
component SN74LS75N is
generic(
    tSETUP : time := 20 ns;     -- Setup time before clock
    tPLHCP : time := 40 ns;     -- Rising
    tPHLCP : time := 25 ns      -- Ralling
);
port(
    X_1  : out   std_logic;  -- Q1\
    X_2  : in    std_logic;  -- D1
    X_3  : in    std_logic;  -- D2
    X_4  : in    std_logic;  -- E34
    X_5  : inout std_logic;  -- Vcc
    X_6  : in    std_logic;  -- D3
    X_7  : in    std_logic;  -- D4
    X_8  : out   std_logic;  -- Q4\
    X_9  : out   std_logic;  -- Q4
    X_10 : out   std_logic;  -- Q3\
    X_11 : out   std_logic;  -- Q3
    X_12 : inout std_logic;  -- GND
    X_13 : in    std_logic;  -- E12
    X_14 : out   std_logic;  -- Q2\
    X_15 : out   std_logic;  -- Q2
    X_16 : out   std_logic   -- Q1
);
end component SN74LS75N;

-----------------------------------------------------------------------
-- SN74LS76N: Dual JK flipflop
-----------------------------------------------------------------------
component SN74LS76N is
generic(
    tSETUP : time := 20 ns;     -- Setup time before clock
    tPLHCP : time := 20 ns;     -- Clock rising
    tPHLCP : time := 30 ns;     -- Clock falling
    tPLHSC : time := 20 ns;     -- S/C rising
    tPHLSC : time := 30 ns      -- S/C falling
);
port(
    X_1  : in    std_logic;  -- CP1\
    X_2  : in    std_logic;  -- SD1\
    X_3  : in    std_logic;  -- CD1\
    X_4  : in    std_logic;  -- J1
    X_5  : inout std_logic;  -- Vcc
    X_6  : in    std_logic;  -- CP2\
    X_7  : in    std_logic;  -- SD2\
    X_8  : in    std_logic;  -- CD2\
    X_9  : in    std_logic;  -- J2
    X_10 : out   std_logic;  -- Q2\
    X_11 : out   std_logic;  -- Q2
    X_12 : in    std_logic;  -- K2
    X_13 : inout std_logic;  -- GND
    X_14 : out   std_logic;  -- Q1\
    X_15 : out   std_logic;  -- Q1
    X_16 : in    std_logic   -- K1
);
end component SN74LS76N;

-----------------------------------------------------------------------
-- SN74LS77N: Quad D-type latch
-----------------------------------------------------------------------
component SN74LS77N is
generic(
    tSETUP : time := 20 ns;     -- Setup time before clock
    tPLHCP : time := 40 ns;     -- Rising
    tPHLCP : time := 25 ns      -- Ralling
);
port(
    X_1  : in    std_logic;  -- D1
    X_2  : in    std_logic;  -- D2
    X_3  : in    std_logic;  -- E34
    X_4  : inout std_logic;  -- Vcc
    X_5  : in    std_logic;  -- D3
    X_6  : in    std_logic;  -- D4
                             -- 
    X_8  : out   std_logic;  -- Q4
    X_9  : out   std_logic;  -- Q3
                             -- 
    X_11 : inout std_logic;  -- GND
    X_12 : in    std_logic;  -- E12
    X_13 : out   std_logic;  -- Q2
    X_14 : out   std_logic   -- Q1
);
end component SN74LS77N;

-----------------------------------------------------------------------
-- SN74LS78N: Dual JK flipflop (Pinout A)
-----------------------------------------------------------------------
component SN74LS78N is
generic(
    tSETUP : time := 20 ns;     -- Setup time before clock
    tPLHCP : time := 20 ns;     -- Clock rising
    tPHLCP : time := 30 ns;     -- Clock falling
    tPLHSC : time := 20 ns;     -- S/C rising
    tPHLSC : time := 30 ns      -- S/C falling
);
port(
    X_1  : in    std_logic;  -- K1
    X_2  : out   std_logic;  -- Q1
    X_3  : out   std_logic;  -- Q1\
    X_4  : in    std_logic;  -- J1
    X_5  : out   std_logic;  -- Q2\
    X_6  : out   std_logic;  -- Q2
    X_7  : inout std_logic;  -- GND
    X_8  : in    std_logic;  -- K2
    X_9  : in    std_logic;  -- CP\
    X_10 : in    std_logic;  -- SD2\
    X_11 : in    std_logic;  -- J2
    X_12 : in    std_logic;  -- CD\
    X_13 : in    std_logic;  -- SD1\
    X_14 : inout std_logic   -- Vcc
);
end component SN74LS78N;

-----------------------------------------------------------------------
-- SN7480N: Gated full adder (Pinout A)
--          The expansion inputs are not modelled
-----------------------------------------------------------------------
component SN7480N is
generic(
    tPLHCC : time := 17 ns;  -- Carry-in to carry-out
    tPHLCC : time := 12 ns;
    tPLHBC : time := 25 ns;  -- Data to carry-out
    tPHLBC : time := 55 ns;
    tPLHS  : time := 70 ns;  -- Data* to S
    tPHLS  : time := 80 ns;
    tPLHSB : time := 55 ns;  -- Data* to S\
    tPHLSB : time := 75 ns;
    tPLHX  : time := 65 ns;  -- Data to Data*
    tPHLX  : time := 25 ns
);
port(
                             -- BX
    X_2  : in    std_logic;  -- BC
    X_3  : in    std_logic;  -- CN
    X_4  : out   std_logic;  -- CNP1\
    X_5  : out   std_logic;  -- S
    X_6  : out   std_logic;  -- S\
    X_7  : inout std_logic;  -- GND
    X_8  : in    std_logic;  -- A1
    X_9  : in    std_logic;  -- A2
                             -- AX
    X_11 : in    std_logic;  -- AC
    X_12 : in    std_logic;  -- B1
    X_13 : in    std_logic;  -- B2
    X_14 : inout std_logic   -- Vcc
);
end component SN7480N;

-----------------------------------------------------------------------
-- SN7482N: 2-bit full adder
-----------------------------------------------------------------------
component SN7482N is
generic(
    tPLHS1 : time := 34 ns;
    tPHLS1 : time := 40 ns;
    tPLHS2 : time := 40 ns;
    tPHLS2 : time := 42 ns;
    tPLHC  : time := 19 ns;
    tPHLC  : time := 27 ns
);
port(
    X_1  : out   std_logic;  -- S1
    X_2  : in    std_logic;  -- A1
    X_3  : in    std_logic;  -- B1
    X_4  : inout std_logic;  -- Vcc
    X_5  : in    std_logic;  -- CIN
                             -- 
                             -- 
                             -- 
                             -- 
    X_10 : out   std_logic;  -- C2
    X_11 : inout std_logic;  -- GND
    X_12 : out   std_logic;  -- S2
    X_13 : in    std_logic;  -- B2
    X_14 : in    std_logic   -- A2
);
end component SN7482N;

-----------------------------------------------------------------------
-- SN74LS83AN: 4-bit binary full adder (fast carry)
-----------------------------------------------------------------------
component SN74LS83AN is
generic(
    tPLHS  : time := 24 ns;
    tPHLS  : time := 24 ns;
    tPLHC  : time := 17 ns;
    tPHLC  : time := 17 ns
);
port(
    X_1  : in    std_logic;  -- A3
    X_2  : out   std_logic;  -- S2
    X_3  : in    std_logic;  -- A2
    X_4  : in    std_logic;  -- B2
    X_5  : inout std_logic;  -- Vcc
    X_6  : out   std_logic;  -- S1
    X_7  : in    std_logic;  -- B1
    X_8  : in    std_logic;  -- A1
    X_9  : out   std_logic;  -- S0
    X_10 : in    std_logic;  -- A0
    X_11 : in    std_logic;  -- B0
    X_12 : inout std_logic;  -- GND
    X_13 : in    std_logic;  -- C0
    X_14 : out   std_logic;  -- C4
    X_15 : out   std_logic;  -- S3
    X_16 : in    std_logic   -- B3
);
end component SN74LS83AN;

-----------------------------------------------------------------------
-- SN74LS85N: 4-bit magnitude comparator
-----------------------------------------------------------------------
component SN74LS85N is
generic(
    tPLH : time := 45 ns;
    tPHL : time := 45 ns
);
port(
    X_1  : in    std_logic;  -- B3
    X_2  : in    std_logic;  -- IA<B
    X_3  : in    std_logic;  -- IA=B
    X_4  : in    std_logic;  -- IA>B
    X_5  : out   std_logic;  -- OA>B
    X_6  : out   std_logic;  -- OA=B
    X_7  : out   std_logic;  -- OA<B
    X_8  : inout std_logic;  -- GND
    X_9  : in    std_logic;  -- B0
    X_10 : in    std_logic;  -- A0
    X_11 : in    std_logic;  -- B1
    X_12 : in    std_logic;  -- A1
    X_13 : in    std_logic;  -- A2
    X_14 : in    std_logic;  -- B2
    X_15 : in    std_logic;  -- A3
    X_16 : inout std_logic   -- Vcc
);
end component SN74LS85N;

-----------------------------------------------------------------------
-- SN74LS86N: Quad 2-input XOR gate
-----------------------------------------------------------------------
component SN74LS86N is
generic(
    tPLH : time := 30 ns;
    tPHL : time := 22 ns
);
port(
    X_1  : in    std_logic;  -- 1A
    X_2  : in    std_logic;  -- 1B
    X_3  : out   std_logic;  -- 1Y
    X_4  : in    std_logic;  -- 2A
    X_5  : in    std_logic;  -- 2B
    X_6  : out   std_logic;  -- 2Y
    X_7  : inout std_logic;  -- GND
    X_8  : out   std_logic;  -- 3Y
    X_9  : in    std_logic;  -- 3B
    X_10 : in    std_logic;  -- 3A
    X_11 : out   std_logic;  -- 4Y
    X_12 : in    std_logic;  -- 4B
    X_13 : in    std_logic;  -- 4A
    X_14 : inout std_logic   -- Vcc
);
end component SN74LS86N;

-----------------------------------------------------------------------
-- SN74H87N: 4-bit true/complement, zero-one element
-----------------------------------------------------------------------
component SN74H87N is
generic(
    tPLHI : time := 20 ns;
    tPHLI : time := 19 ns;
    tPLHS : time := 25 ns;
    tPHLS : time := 25 ns
);
port(
    X_1  :       std_logic;  -- S2
    X_2  :       std_logic;  -- I1
    X_3  : out   std_logic;  -- Q1
                             -- 
    X_5  :       std_logic;  -- I2
    X_6  : out   std_logic;  -- Q2
    X_7  : inout std_logic;  -- GND
    X_8  :       std_logic;  -- S1
    X_9  : out   std_logic;  -- Q3
    X_10 :       std_logic;  -- I3
                             --
    X_12 : out   std_logic;  -- Q4
    X_13 :       std_logic;  -- I4
    X_14 : inout std_logic   -- Vcc
);
end component SN74H87N;

-----------------------------------------------------------------------
-- SN74LS89N: 64-bit random-access memory (open collector)
-----------------------------------------------------------------------
component SN74LS89N is
generic(
    tPLC  : time     := 10 ns;
    tPLA  : time     := 37 ns;
    tREC  : time     := 30 ns;
    tSUD  : time     := 25 ns;
    tSUA  : time     := 10 ns
);        
port(     
    X_1   : in    std_logic;  -- A0
    X_2   : in    std_logic;  -- CS\
    X_3   : in    std_logic;  -- WE\
    X_4   : in    std_logic;  -- D1
    X_5   : out   std_logic;  -- Q1\
    X_6   : in    std_logic;  -- D2
    X_7   : out   std_logic;  -- Q2\
    X_8   : inout std_logic;  -- GND
    X_9   : out   std_logic;  -- Q3\
    X_10  : in    std_logic;  -- D3
    X_11  : out   std_logic;  -- Q4\
    X_12  : in    std_logic;  -- D4
    X_13  : in    std_logic;  -- A3
    X_14  : in    std_logic;  -- A2
    X_15  : in    std_logic;  -- A1
    X_16  : inout std_logic   -- Vcc
);
end component SN74LS89N;

-----------------------------------------------------------------------
-- SN74LS90AN: Decade counter (ripple)
-----------------------------------------------------------------------
component SN74LS90AN is
generic(
    tPLH0 : time := 16 ns;
    tPHL0 : time := 18 ns;
    tPLH1 : time := 16 ns;
    tPHL1 : time := 21 ns;
    tPLH2 : time := 32 ns;
    tPHL2 : time := 35 ns;
    tPLH3 : time := 32 ns;
    tPHL3 : time := 35 ns
);
port(
    X_1  : in    std_logic;  -- CP1\
    X_2  : in    std_logic;  -- MR1
    X_3  : in    std_logic;  -- MR2
                             -- 
    X_5  : inout std_logic;  -- Vcc
    X_6  : in    std_logic;  -- MS1
    X_7  : in    std_logic;  -- MS2
    X_8  : out   std_logic;  -- Q2
    X_9  : out   std_logic;  -- Q1
    X_10 : inout std_logic;  -- GND
    X_11 : out   std_logic;  -- Q3
    X_12 : out   std_logic;  -- Q0
                             -- 
    X_14 : in    std_logic   -- CP0\
);
end component SN74LS90AN;

-----------------------------------------------------------------------
-- SN74LS91AN: 8-bit shift register (Pinout A)
-----------------------------------------------------------------------
component SN74LS91AN is
generic(
    tPLH : time := 40 ns;
    tPHL : time := 40 ns;
    tSU  : time := 25 ns
);
port(
                             -- 
                             -- 
                             -- 
                             -- 
    X_5  : inout std_logic;  -- Vcc
                             -- 
                             -- 
                             -- 
    X_9  : in    std_logic;  -- CP
    X_10 : inout std_logic;  -- GND
    X_11 : in    std_logic;  -- B
    X_12 : in    std_logic;  -- A
    X_13 : out   std_logic;  -- Q
    X_14 : out   std_logic   -- Q\
);
end component SN74LS91AN;

-----------------------------------------------------------------------
-- SN74LS92N: Divide-by-12 counter (ripple)
-----------------------------------------------------------------------
component SN74LS92N is
generic(
    tPLH0 : time := 16 ns;
    tPHL0 : time := 18 ns;
    tPLH1 : time := 16 ns;
    tPHL1 : time := 21 ns;
    tPLH2 : time := 16 ns;
    tPHL2 : time := 21 ns;
    tPLH3 : time := 32 ns;
    tPHL3 : time := 35 ns
);
port(
    X_1  : in    std_logic;  -- CP1\
                             -- 
                             -- 
                             -- 
    X_5  : inout std_logic;  -- Vcc
    X_6  : in    std_logic;  -- MR1
    X_7  : in    std_logic;  -- MR2
    X_8  : out   std_logic;  -- Q3
    X_9  : out   std_logic;  -- Q2
    X_10 : inout std_logic;  -- GND
    X_11 : out   std_logic;  -- Q1
    X_12 : out   std_logic;  -- Q0
                             -- 
    X_14 : in    std_logic   -- CP0\
);
end component SN74LS92N;

-----------------------------------------------------------------------
-- SN74LS93N: Divide-by-16 (binary) counter (ripple)
-----------------------------------------------------------------------
component SN74LS93N is
generic(
    tPLH0 : time := 16 ns;
    tPHL0 : time := 18 ns;
    tPLH1 : time := 16 ns;
    tPHL1 : time := 21 ns;
    tPLH2 : time := 32 ns;
    tPHL2 : time := 35 ns;
    tPLH3 : time := 51 ns;
    tPHL3 : time := 51 ns
);
port(
    X_1  : in    std_logic;  -- CP1\
    X_2  : in    std_logic;  -- MR1
    X_3  : in    std_logic;  -- MR2
                             -- 
    X_5  : inout std_logic;  -- Vcc
                             -- 
                             -- 
    X_8  : out   std_logic;  -- Q2
    X_9  : out   std_logic;  -- Q1
    X_10 : inout std_logic;  -- GND
    X_11 : out   std_logic;  -- Q3
    X_12 : out   std_logic;  -- Q0
                             -- 
    X_14 : in    std_logic   -- CP0\
);
end component SN74LS93N;

-----------------------------------------------------------------------
-- SN74LS94N: 4-bit shift register
-----------------------------------------------------------------------
component SN74LS94N is
generic(
    tPLH : time := 40 ns;
    tPHL : time := 40 ns;
    tSU  : time := 35 ns
);
port(
    X_1  : in    std_logic;  -- P1A
    X_2  : in    std_logic;  -- P1B
    X_3  : in    std_logic;  -- P1C
    X_4  : in    std_logic;  -- P1D
    X_5  : inout std_logic;  -- Vcc
    X_6  : in    std_logic;  -- PL1
    X_7  : in    std_logic;  -- DS
    X_8  : in    std_logic;  -- CP
    X_9  : out   std_logic;  -- QD
    X_10 : in    std_logic;  -- CL
    X_11 : in    std_logic;  -- P2D
    X_12 : inout std_logic;  -- GND
    X_13 : in    std_logic;  -- P2C
    X_14 : in    std_logic;  -- P2B
    X_15 : in    std_logic;  -- PL2
    X_16 : in    std_logic   -- P2A
);
end component SN74LS94N;

-----------------------------------------------------------------------
-- SN74LS95N: 4-bit right/left shift register
-----------------------------------------------------------------------
component SN74LS95N is
generic(
    tPLH : time := 27 ns;
    tPHL : time := 27 ns;
    tSU  : time := 20 ns
);
port(
    X_1  : in    std_logic;  -- DS
    X_2  : in    std_logic;  -- P0
    X_3  : in    std_logic;  -- P1
    X_4  : in    std_logic;  -- P2
    X_5  : in    std_logic;  -- P3
    X_6  : in    std_logic;  -- PE
    X_7  : inout std_logic;  -- GND
    X_8  : in    std_logic;  -- CP2\
    X_9  : in    std_logic;  -- CP1\
    X_10 : out   std_logic;  -- Q3
    X_11 : out   std_logic;  -- Q2
    X_12 : out   std_logic;  -- Q1
    X_13 : out   std_logic;  -- Q0
    X_14 : inout std_logic   -- Vcc
);
end component SN74LS95N;

-----------------------------------------------------------------------
-- SN74LS96N: 5-bit shift register
-----------------------------------------------------------------------
component SN74LS96N is
generic(
    tPLH : time := 40 ns;
    tPHL : time := 40 ns;
    tSU  : time := 30 ns
);
port(
    X_1  : in    std_logic;  -- CP
    X_2  : in    std_logic;  -- P0
    X_3  : in    std_logic;  -- P1
    X_4  : in    std_logic;  -- P2
    X_5  : inout std_logic;  -- Vcc
    X_6  : in    std_logic;  -- P3
    X_7  : in    std_logic;  -- P4
    X_8  : in    std_logic;  -- PL
    X_9  : in    std_logic;  -- DS
    X_10 : out   std_logic;  -- Q4
    X_11 : out   std_logic;  -- Q3
    X_12 : inout std_logic;  -- GND
    X_13 : out   std_logic;  -- Q2
    X_14 : out   std_logic;  -- Q1
    X_15 : out   std_logic;  -- Q0
    X_16 : in    std_logic   -- CL\
);
end component SN74LS96N;

-- SN74LS97N: Synchronous modulo-64 bit-rate multiplier

-----------------------------------------------------------------------
-- SN74100N: Dual 4-bit latch
-----------------------------------------------------------------------
component SN74100N is
generic(
    tPLH : time := 30 ns;
    tPHL : time := 25 ns
);
port(
                             --
    X_2  : in    std_logic;  -- 1D1
    X_3  : in    std_logic;  -- 1D2
    X_4  : out   std_logic;  -- 1Q2
    X_5  : out   std_logic;  -- 1Q1
                             --
    X_7  : inout std_logic;  -- GND
    X_8  : out   std_logic;  -- 2Q1
    X_9  : out   std_logic;  -- 2Q2
    X_10 : in    std_logic;  -- 2D2
    X_11 : in    std_logic;  -- 2D1
    X_12 : in    std_logic;  -- 2G
                             -- 
                             -- 
    X_15 : in    std_logic;  -- 2D3
    X_16 : in    std_logic;  -- 2D4
    X_17 : out   std_logic;  -- 2Q4
    X_18 : out   std_logic;  -- 2Q3
    X_19 : out   std_logic;  -- 1Q3
    X_20 : out   std_logic;  -- 1Q4
    X_21 : in    std_logic;  -- 1D4
    X_22 : in    std_logic;  -- 1D3
    X_23 : in    std_logic;  -- 1G
    X_24 : inout std_logic   -- Vcc
);
end component SN74100N;

-----------------------------------------------------------------------
-- SN74H101N: JK edge-triggered flipflop (with AND-OR inputs) (Pinout A)
-----------------------------------------------------------------------
component SN74H101N is
generic(
    tSETUP : time := 13 ns;     -- Setup time before clock
    tPLHCP : time := 15 ns;     -- Clock rising
    tPHLCP : time := 20 ns;     -- Clock falling
    tPLHSC : time := 12 ns;     -- S/C rising
    tPHLSC : time := 20 ns      -- S/C falling
);
port(
    X_1  : in    std_logic;  -- J1A
    X_2  : in    std_logic;  -- J1B
    X_3  : in    std_logic;  -- J2A
    X_4  : in    std_logic;  -- J2B
    X_5  : in    std_logic;  -- SD\
    X_6  : out   std_logic;  -- Q
    X_7  : inout std_logic;  -- GND
    X_8  : out   std_logic;  -- Q\
    X_9  : in    std_logic;  -- K1A
    X_10 : in    std_logic;  -- K1B
    X_11 : in    std_logic;  -- K2A
    X_12 : in    std_logic;  -- K2B
    X_13 : in    std_logic;  -- CP
    X_14 : inout std_logic   -- Vcc
);
end component SN74H101N;

-----------------------------------------------------------------------
-- SN74H102N: JK edge-triggered flipflop (with AND inputs) (Pinout A)
-----------------------------------------------------------------------
component SN74H102N is
generic(
    tSETUP : time := 13 ns;     -- Setup time before clock
    tPLHCP : time := 15 ns;     -- Clock rising
    tPHLCP : time := 20 ns;     -- Clock falling
    tPLHSC : time := 12 ns;     -- S/C rising
    tPHLSC : time := 20 ns      -- S/C falling
);
port(
                             -- 
    X_2  : in    std_logic;  -- CD\
    X_3  : in    std_logic;  -- J1
    X_4  : in    std_logic;  -- J2
    X_5  : in    std_logic;  -- J3
    X_6  : out   std_logic;  -- Q\
    X_7  : inout std_logic;  -- GND
    X_8  : out   std_logic;  -- Q
    X_9  : in    std_logic;  -- K1
    X_10 : in    std_logic;  -- K2
    X_11 : in    std_logic;  -- K3
    X_12 : in    std_logic;  -- CP\
    X_13 : in    std_logic;  -- SD\
    X_14 : inout std_logic   -- Vcc
);
end component SN74H102N;

-----------------------------------------------------------------------
-- SN74H103N: Dual JK edge-triggered flipflop
-----------------------------------------------------------------------
component SN74H103N is
generic(
    tSETUP : time := 13 ns;     -- Setup time before clock
    tPLHCP : time := 15 ns;     -- Clock rising
    tPHLCP : time := 20 ns;     -- Clock falling
    tPLHSC : time := 12 ns;     -- S/C rising
    tPHLSC : time := 35 ns      -- S/C falling
);
port(
    X_1  : in    std_logic;  -- CP1\
    X_2  : in    std_logic;  -- CD1\
    X_3  : in    std_logic;  -- K1
    X_4  : inout std_logic;  -- Vcc
    X_5  : in    std_logic;  -- CP2\
    X_6  : in    std_logic;  -- CD2\
    X_7  : in    std_logic;  -- J2
    X_8  : out   std_logic;  -- Q2\
    X_9  : out   std_logic;  -- Q2
    X_10 : in    std_logic;  -- K2
    X_11 : inout std_logic;  -- GND
    X_12 : out   std_logic;  -- Q1
    X_13 : out   std_logic;  -- Q1\
    X_14 : in    std_logic   -- J1
);
end component SN74H103N;

-- SN74105N: JK flipflop with extra gating
 
-----------------------------------------------------------------------
-- SN74H106N: Dual JK edge-triggered flipflop
-----------------------------------------------------------------------
component SN74H106N is
generic(
    tSETUP : time := 13 ns;     -- Setup time before clock
    tPLHCP : time := 15 ns;     -- Clock rising
    tPHLCP : time := 20 ns;     -- Clock falling
    tPLHSC : time := 12 ns;     -- S/C rising
    tPHLSC : time := 35 ns      -- S/C falling
);
port(
    X_1  : in    std_logic;  -- CP1\
    X_2  : in    std_logic;  -- SD1\
    X_3  : in    std_logic;  -- CD1\
    X_4  : in    std_logic;  -- J1
    X_5  : inout std_logic;  -- Vcc
    X_6  : in    std_logic;  -- CP2\
    X_7  : in    std_logic;  -- SD2\
    X_8  : in    std_logic;  -- CD2\
    X_9  : in    std_logic;  -- J2
    X_10 : out   std_logic;  -- Q2\
    X_11 : out   std_logic;  -- Q2
    X_12 : in    std_logic;  -- K2
    X_13 : inout std_logic;  -- GND
    X_14 : out   std_logic;  -- Q1\
    X_15 : out   std_logic;  -- Q1
    X_16 : in    std_logic   -- K1
);
end component SN74H106N;

-----------------------------------------------------------------------
-- SN74LS107N: Dual JK flipflop
-----------------------------------------------------------------------
component SN74LS107N is
generic(
    tSETUP : time := 20 ns;     -- Setup time before clock
    tPLHCP : time := 20 ns;     -- Clock rising
    tPHLCP : time := 30 ns;     -- Clock falling
    tPLHSC : time := 20 ns;     -- S/C rising
    tPHLSC : time := 30 ns      -- S/C falling
);
port(
    X_1  : in    std_logic;  -- J1
    X_2  : out   std_logic;  -- Q1\
    X_3  : out   std_logic;  -- Q1
    X_4  : in    std_logic;  -- K1
    X_5  : out   std_logic;  -- Q2
    X_6  : out   std_logic;  -- Q2\
    X_7  : inout std_logic;  -- GND
    X_8  : in    std_logic;  -- J2
    X_9  : in    std_logic;  -- CP2\
    X_10 : in    std_logic;  -- CD2\
    X_11 : in    std_logic;  -- K2
    X_12 : in    std_logic;  -- CP1\
    X_13 : in    std_logic;  -- CD2\
    X_14 : inout std_logic   -- Vcc
);
end component SN74LS107N;

-----------------------------------------------------------------------
-- SN74H108N: Dual JK edge-triggered flipflop
-----------------------------------------------------------------------
component SN74H108N is
generic(
    tSETUP : time := 13 ns;     -- Setup time before clock
    tPLHCP : time := 15 ns;     -- Clock rising
    tPHLCP : time := 20 ns;     -- Clock falling
    tPLHSC : time := 12 ns;     -- S/C rising
    tPHLSC : time := 35 ns      -- S/C falling
);
port(
    X_1  : in    std_logic;  -- K1
    X_2  : out   std_logic;  -- Q1
    X_3  : out   std_logic;  -- Q1\
    X_4  : in    std_logic;  -- J1
    X_5  : out   std_logic;  -- Q2\
    X_6  : out   std_logic;  -- Q2
    X_7  : inout std_logic;  -- GND
    X_8  : in    std_logic;  -- K2
    X_9  : in    std_logic;  -- CP\
    X_10 : in    std_logic;  -- SD2\
    X_11 : in    std_logic;  -- J2
    X_12 : in    std_logic;  -- CD\
    X_13 : in    std_logic;  -- SD1\
    X_14 : inout std_logic   -- Vcc
);
end component SN74H108N;

-----------------------------------------------------------------------
-- SN74LS109N: Dual JK +ve edge-triggered flipflop
-----------------------------------------------------------------------
component SN74LS109N is
generic(
    tSETUP : time := 18 ns;     -- Setup time before clock
    tPLHCP : time := 25 ns;     -- Clock rising
    tPHLCP : time := 35 ns;     -- Clock falling
    tPLHSC : time := 15 ns;     -- S/C rising
    tPHLSC : time := 24 ns      -- S/C falling
);
port(
    X_1  : in    std_logic;  -- CD1\
    X_2  : in    std_logic;  -- J1
    X_3  : in    std_logic;  -- K1\
    X_4  : in    std_logic;  -- CP1
    X_5  : in    std_logic;  -- SD1\
    X_6  : out   std_logic;  -- Q1
    X_7  : out   std_logic;  -- Q1\
    X_8  : inout std_logic;  -- GND
    X_9  : out   std_logic;  -- Q2\
    X_10 : out   std_logic;  -- Q2
    X_11 : in    std_logic;  -- SD2\
    X_12 : in    std_logic;  -- CP2
    X_13 : in    std_logic;  -- K2\
    X_14 : in    std_logic;  -- J2
    X_15 : in    std_logic;  -- CD2\
    X_16 : inout std_logic   -- Vcc
);
end component SN74LS109N;

-----------------------------------------------------------------------
-- SN74LS112N: Dual JK -ve edge-triggered flipflop
-----------------------------------------------------------------------
component SN74LS112N is
generic(
    tSETUP : time := 20 ns;     -- Setup time before clock
    tPLHCP : time := 16 ns;     -- Clock rising
    tPHLCP : time := 24 ns;     -- Clock falling
    tPLHSC : time := 16 ns;     -- S/C rising
    tPHLSC : time := 24 ns      -- S/C falling
);
port(
    X_1  : in    std_logic;  -- CP1\
    X_2  : in    std_logic;  -- K1
    X_3  : in    std_logic;  -- J1
    X_4  : in    std_logic;  -- SD1\
    X_5  : out   std_logic;  -- Q1
    X_6  : out   std_logic;  -- Q1\
    X_7  : out   std_logic;  -- Q2\
    X_8  : inout std_logic;  -- GND
    X_9  : out   std_logic;  -- Q2
    X_10 : in    std_logic;  -- SD2\
    X_11 : in    std_logic;  -- J2
    X_12 : in    std_logic;  -- K2
    X_13 : in    std_logic;  -- CP2\
    X_14 : in    std_logic;  -- CD2\
    X_15 : in    std_logic;  -- CD1\
    X_16 : inout std_logic   -- Vcc
);
end component SN74LS112N;

-----------------------------------------------------------------------
-- SN74LS113N: Dual JK edge-triggered flipflop
-----------------------------------------------------------------------
component SN74LS113N is
generic(
    tSETUP : time := 20 ns;     -- Setup time before clock
    tPLHCP : time := 16 ns;     -- Clock rising
    tPHLCP : time := 24 ns;     -- Clock falling
    tPLHSC : time := 16 ns;     -- S/C rising
    tPHLSC : time := 24 ns      -- S/C falling
);
port(
    X_1  : in    std_logic;  -- CP1\
    X_2  : in    std_logic;  -- K1
    X_3  : in    std_logic;  -- J1
    X_4  : in    std_logic;  -- SD1\
    X_5  : out   std_logic;  -- Q1
    X_6  : out   std_logic;  -- Q1\
    X_7  : inout std_logic;  -- GND
    X_8  : out   std_logic;  -- Q2\
    X_9  : out   std_logic;  -- Q2
    X_10 : in    std_logic;  -- SD2\
    X_11 : in    std_logic;  -- J2
    X_12 : in    std_logic;  -- K2
    X_13 : in    std_logic;  -- CP2\
    X_14 : inout std_logic   -- Vcc
);
end component SN74LS113N;

-----------------------------------------------------------------------
-- SN74LS114N: Dual JK -ve edge-triggered flipflop
-----------------------------------------------------------------------
component SN74LS114N is
generic(
    tSETUP : time := 20 ns;     -- Setup time before clock
    tPLHCP : time := 16 ns;     -- Clock rising
    tPHLCP : time := 24 ns;     -- Clock falling
    tPLHSC : time := 16 ns;     -- S/C rising
    tPHLSC : time := 24 ns      -- S/C falling
);
port(
    X_1  : in    std_logic;  -- CD\
    X_2  : in    std_logic;  -- K1
    X_3  : in    std_logic;  -- J1
    X_4  : in    std_logic;  -- SD1\
    X_5  : out   std_logic;  -- Q1
    X_6  : out   std_logic;  -- Q1\
    X_7  : inout std_logic;  -- GND
    X_8  : out   std_logic;  -- Q2\
    X_9  : out   std_logic;  -- Q2
    X_10 : in    std_logic;  -- SD2\
    X_11 : in    std_logic;  -- J2
    X_12 : in    std_logic;  -- K2
    X_13 : in    std_logic;  -- CP\
    X_14 : inout std_logic   -- Vcc
);
end component SN74LS114N;

-----------------------------------------------------------------------
-- SN74121N: Monostable multivibrator
--           Tw = 0.69 * R * C
-----------------------------------------------------------------------
component SN74121N is
generic(
    W  : time := 100 us      -- Pulse width
);
port(
    X_1  : out   std_logic;  -- Q\
                             -- 
    X_3  : in    std_logic;  -- A1\
    X_4  : in    std_logic;  -- A2\
    X_5  : in    std_logic;  -- B
    X_6  : out   std_logic;  -- Q
    X_7  : inout std_logic;  -- GND
                             -- 
    X_9  : inout std_logic;  -- Rint (open for simulation)
    X_10 : inout std_logic;  -- Cx
    X_11 : inout std_logic;  -- RxCx
                             -- 
                             -- 
    X_14 : inout std_logic   -- Vcc
);
end component SN74121N;

-----------------------------------------------------------------------
-- SN74122N: Retriggerable resettable monostable multivibrator
--           Tw = 0.32 * R * X * (1.0 + 0.7/R)
-----------------------------------------------------------------------
component SN74122N is
generic(
    W  : time := 100 us      -- Pulse width
);
port(
    X_1  : in    std_logic;  -- A1\
    X_2  : in    std_logic;  -- A2\
    X_3  : in    std_logic;  -- B1
    X_4  : in    std_logic;  -- B2
    X_5  : in    std_logic;  -- CD\
    X_6  : out   std_logic;  -- Q\
    X_7  : inout std_logic;  -- GND
    X_8  : out   std_logic;  -- Q
    X_9  : inout std_logic;  -- Rint
                             -- 
    X_11 : inout std_logic;  -- Cx
                             -- 
    X_13 : inout std_logic;  -- RxCx
    X_14 : inout std_logic   -- Vcc
);
end component SN74122N;

-----------------------------------------------------------------------
-- SN74123N: Dual retriggerable resettable monostable multivibrator
--           Tw = 0.28 * R * C * (1.0 + 0.7/R)
-----------------------------------------------------------------------
component SN74123N is
generic(
    W1 : time := 100 us;     -- Pulse widths
    W2 : time := 100 us
);
port(
    X_1  : in    std_logic;  -- A1\
    X_2  : in    std_logic;  -- B1
    X_3  : in    std_logic;  -- CD1\
    X_4  : out   std_logic;  -- Q1\
    X_5  : out   std_logic;  -- Q2
    X_6  : inout std_logic;  -- Cx2
    X_7  : inout std_logic;  -- Rx2Cx2
    X_8  : inout std_logic;  -- GND
    X_9  : in    std_logic;  -- A2\
    X_10 : in    std_logic;  -- B2
    X_11 : in    std_logic;  -- CD2\
    X_12 : out   std_logic;  -- Q2\
    X_13 : out   std_logic;  -- Q1
    X_14 : inout std_logic;  -- Cx1
    X_15 : inout std_logic;  -- Rx1Cx1
    X_16 : inout std_logic   -- Vcc
);
end component SN74123N;

-----------------------------------------------------------------------
-- SN74LS125N: Quad bus buffer (3-state outputs)
-----------------------------------------------------------------------
component SN74LS125N is
generic(
    tPLH : time := 15 ns;
    tPHL : time := 18 ns;
    tPHZ : time := 25 ns;
    tPLZ : time := 25 ns;
    tPHE : time := 16 ns;
    tPLE : time := 25 ns
);
port(
    X_1  : in    std_logic;  -- E1\
    X_2  : in    std_logic;  -- D1
    X_3  : out   std_logic;  -- Q1
    X_4  : in    std_logic;  -- E2\
    X_5  : in    std_logic;  -- D2
    X_6  : out   std_logic;  -- Q2
    X_7  : inout std_logic;  -- GND
    X_8  : out   std_logic;  -- Q3
    X_9  : in    std_logic;  -- D3
    X_10 : in    std_logic;  -- E3\
    X_11 : out   std_logic;  -- Q4
    X_12 : in    std_logic;  -- D4
    X_13 : in    std_logic;  -- E4\
    X_14 : inout std_logic   -- Vcc
);
end component SN74LS125N;

-----------------------------------------------------------------------
-- SN74LS126N: Quad bus buffer (3-state outputs)
-----------------------------------------------------------------------
component SN74LS126N is
generic(
    tPLH : time := 15 ns;
    tPHL : time := 18 ns;
    tPHZ : time := 30 ns;
    tPLZ : time := 30 ns;
    tPHE : time := 20 ns;
    tPLE : time := 30 ns
);
port(
    X_1  : in    std_logic;  -- E1
    X_2  : in    std_logic;  -- D1
    X_3  : out   std_logic;  -- Q1
    X_4  : in    std_logic;  -- E2
    X_5  : in    std_logic;  -- D2
    X_6  : out   std_logic;  -- Q2
    X_7  : inout std_logic;  -- GND
    X_8  : out   std_logic;  -- Q3
    X_9  : in    std_logic;  -- D3
    X_10 : in    std_logic;  -- E3
    X_11 : out   std_logic;  -- Q4
    X_12 : in    std_logic;  -- D4
    X_13 : in    std_logic;  -- E4
    X_14 : inout std_logic   -- Vcc
);
end component SN74LS126N;

-----------------------------------------------------------------------
-- SN74LS132N: Quad 2-input Schmitt trigger NAND gate
-----------------------------------------------------------------------
component SN74LS132N is
generic(
    tPLH : time := 20 ns;
    tPHL : time := 20 ns
);
port(
    X_1  : in    std_logic;  -- 1A
    X_2  : in    std_logic;  -- 1B
    X_3  : out   std_logic;  -- 1Y\
    X_4  : in    std_logic;  -- 2A
    X_5  : in    std_logic;  -- 2B
    X_6  : out   std_logic;  -- 2Y\
    X_7  : inout std_logic;  -- GND
    X_8  : out   std_logic;  -- 3Y\
    X_9  : in    std_logic;  -- 3B
    X_10 : in    std_logic;  -- 3A
    X_11 : out   std_logic;  -- 4Y\
    X_12 : in    std_logic;  -- 4B
    X_13 : in    std_logic;  -- 4A
    X_14 : inout std_logic   -- Vcc 
);
end component SN74LS132N;

-----------------------------------------------------------------------
-- SN74LS133N: 13-input NAND gate
-----------------------------------------------------------------------
component SN74LS133N is
generic(
    tPLH : time := 15 ns;
    tPHL : time := 38 ns
);
port(
    X_1  : in    std_logic;  -- 1A
    X_2  : in    std_logic;  -- 1B
    X_3  : in    std_logic;  -- 1C
    X_4  : in    std_logic;  -- 1D
    X_5  : in    std_logic;  -- 1E
    X_6  : in    std_logic;  -- 1F
    X_7  : in    std_logic;  -- 1G
    X_8  : inout std_logic;  -- GND
    X_9  : out   std_logic;  -- 1Y\
    X_10 : in    std_logic;  -- 1H
    X_11 : in    std_logic;  -- 1J
    X_12 : in    std_logic;  -- 1K
    X_13 : in    std_logic;  -- 1L
    X_14 : in    std_logic;  -- 1M
    X_15 : in    std_logic;  -- 1N
    X_16 : inout std_logic   -- Vcc
);
end component SN74LS133N;

-----------------------------------------------------------------------
-- SN74S134N: 12-input NAND gate (3-state output)
-----------------------------------------------------------------------
component SN74S134N is
generic(
    tPLH : time :=  6.0 ns;
    tPHL : time :=  7.5 ns;
    tPZH : time := 19.5 ns;
    tPZL : time := 21.0 ns;
    tPHZ : time :=  8.5 ns;
    tPLZ : time := 14.0 ns
);
port(
    X_1  : in    std_logic;  -- 1A
    X_2  : in    std_logic;  -- 1B
    X_3  : in    std_logic;  -- 1C
    X_4  : in    std_logic;  -- 1D
    X_5  : in    std_logic;  -- 1E
    X_6  : in    std_logic;  -- 1F
    X_7  : in    std_logic;  -- 1G
    X_8  : inout std_logic;  -- GND
    X_9  : out   std_logic;  -- 1Y\
    X_10 : in    std_logic;  -- 1H
    X_11 : in    std_logic;  -- 1J
    X_12 : in    std_logic;  -- 1K
    X_13 : in    std_logic;  -- 1L
    X_14 : in    std_logic;  -- 1M
    X_15 : in    std_logic;  -- EB
    X_16 : inout std_logic   -- Vcc
);
end component SN74S134N;

-----------------------------------------------------------------------
-- SN74S135N: Quad XOR/NOR gate
-----------------------------------------------------------------------
component SN74S135N is
generic(
    tPXX : time := 13 ns
);
port(
    X_1  : in    std_logic;  -- A1
    X_2  : in    std_logic;  -- B1
    X_3  : out   std_logic;  -- Y1
    X_4  : in    std_logic;  -- C12
    X_5  : in    std_logic;  -- A2
    X_6  : in    std_logic;  -- B2
    X_7  : out   std_logic;  -- Y2
    X_8  : inout std_logic;  -- GND
    X_9  : out   std_logic;  -- Y3
    X_10 : in    std_logic;  -- B3
    X_11 : in    std_logic;  -- A3
    X_12 : in    std_logic;  -- C34
    X_13 : out   std_logic;  -- Y4
    X_14 : in    std_logic;  -- B4
    X_15 : in    std_logic;  -- A4
    X_16 : inout std_logic   -- Vcc
);
end component SN74S135N;

-----------------------------------------------------------------------
-- SN74LS136N: Quad 2-input XOR gate (open collector)
-----------------------------------------------------------------------
component SN74LS136N is
generic(
    tPLH : time := 30 ns;
    tPHL : time := 30 ns
);
port(
    X_1  : in    std_logic;  -- 1A
    X_2  : in    std_logic;  -- 1B
    X_3  : out   std_logic;  -- 1Y\
    X_4  : in    std_logic;  -- 2A
    X_5  : in    std_logic;  -- 2B
    X_6  : out   std_logic;  -- 2Y\
    X_7  : inout std_logic;  -- GND
    X_8  : out   std_logic;  -- 3Y\
    X_9  : in    std_logic;  -- 3B
    X_10 : in    std_logic;  -- 3A
    X_11 : out   std_logic;  -- 4Y\
    X_12 : in    std_logic;  -- 4B
    X_13 : in    std_logic;  -- 4A
    X_14 : inout std_logic   -- Vcc 
);
end component SN74LS136N;

-----------------------------------------------------------------------
-- SN74LS137N: 1-of-8 decoder/demultiplexer (input latches)
-----------------------------------------------------------------------
component SN74LS137N is
generic(
    tPLH : time := 12 ns;
    tPHL : time := 20 ns
);
port(
    X_1  : in    std_logic;  -- A0
    X_2  : in    std_logic;  -- A1
    X_3  : in    std_logic;  -- A2
    X_4  : in    std_logic;  -- LE\
    X_5  : in    std_logic;  -- E1\
    X_6  : in    std_logic;  -- E2
    X_7  : out   std_logic;  -- O7\
    X_8  : inout std_logic;  -- GND
    X_9  : out   std_logic;  -- O6\
    X_10 : out   std_logic;  -- O5\
    X_11 : out   std_logic;  -- O4\
    X_12 : out   std_logic;  -- O3\
    X_13 : out   std_logic;  -- O2\
    X_14 : out   std_logic;  -- O1\
    X_15 : out   std_logic;  -- O0\
    X_16 : inout std_logic   -- Vcc
);
end component SN74LS137N;

-----------------------------------------------------------------------
-- SN74LS138N: 1-of-8 decoder/demultiplexer
-----------------------------------------------------------------------
component SN74LS138N is
generic(
    tPLH : time := 18 ns;
    tPHL : time := 28 ns
);
port(
    X_1  : in    std_logic;  -- A0
    X_2  : in    std_logic;  -- A1
    X_3  : in    std_logic;  -- A2
    X_4  : in    std_logic;  -- E1\
    X_5  : in    std_logic;  -- E2\
    X_6  : in    std_logic;  -- E3
    X_7  : out   std_logic;  -- O7\
    X_8  : inout std_logic;  -- GND
    X_9  : out   std_logic;  -- O6\
    X_10 : out   std_logic;  -- O5\
    X_11 : out   std_logic;  -- O4\
    X_12 : out   std_logic;  -- O3\
    X_13 : out   std_logic;  -- O2\
    X_14 : out   std_logic;  -- O1\
    X_15 : out   std_logic;  -- O0\
    X_16 : inout std_logic   -- Vcc
);
end component SN74LS138N;

-----------------------------------------------------------------------
-- SN74LS139N: Dual 1-of-4 decoder
-----------------------------------------------------------------------
component SN74LS139N is
generic(
    tPLH : time := 18 ns;
    tPHL : time := 28 ns
);
port(
    X_1  : in    std_logic;  -- EA\
    X_2  : in    std_logic;  -- A0A
    X_3  : in    std_logic;  -- A1A
    X_4  : out   std_logic;  -- O0A\
    X_5  : out   std_logic;  -- O1A\
    X_6  : out   std_logic;  -- O2A\
    X_7  : out   std_logic;  -- O3A\
    X_8  : inout std_logic;  -- GND
    X_9  : out   std_logic;  -- O3B\
    X_10 : out   std_logic;  -- O2B\
    X_11 : out   std_logic;  -- O1B\
    X_12 : out   std_logic;  -- O0B\
    X_13 : in    std_logic;  -- A1B
    X_14 : in    std_logic;  -- A0B
    X_15 : in    std_logic;  -- EB\
    X_16 : inout std_logic   -- Vcc
);
end component SN74LS139N;

-----------------------------------------------------------------------
-- SN74S140N: Dual 4-input NAND line driver
-----------------------------------------------------------------------
component SN74S140N is
generic(
    tPLH : time := 6.5 ns;
    tPHL : time := 6.5 ns
);
port(
    X_1  : in    std_logic;  -- 1A
    X_2  : in    std_logic;  -- 1B
                             -- 
    X_4  : in    std_logic;  -- 1C
    X_5  : in    std_logic;  -- 1D
    X_6  : out   std_logic;  -- 1Y\
    X_7  : inout std_logic;  -- GND
    X_8  : out   std_logic;  -- 2Y\
    X_9  : in    std_logic;  -- 2D
    X_10 : in    std_logic;  -- 2C
                             -- 
    X_12 : in    std_logic;  -- 2B
    X_13 : in    std_logic;  -- 2A
    X_14 : inout std_logic   -- Vcc
);
end component SN74S140N;

-- SN74LS141N: 1-of-10 Nixie decoder/driver (open collector)

-----------------------------------------------------------------------
-- SN74145N: 1-of-10 decoder/driver (open collector)
-----------------------------------------------------------------------
component SN74145N is
generic(
    tPLH : time := 50 ns;
    tPHL : time := 50 ns
);
port(
    X_1  : out   std_logic;  -- Q0\
    X_2  : out   std_logic;  -- Q1\
    X_3  : out   std_logic;  -- Q2\
    X_4  : out   std_logic;  -- Q3\
    X_5  : out   std_logic;  -- Q4\
    X_6  : out   std_logic;  -- Q5\
    X_7  : out   std_logic;  -- Q6\
    X_8  : inout std_logic;  -- GND
    X_9  : out   std_logic;  -- Q7\
    X_10 : out   std_logic;  -- Q8\
    X_11 : out   std_logic;  -- Q9\
    X_12 : in    std_logic;  -- A3
    X_13 : in    std_logic;  -- A2
    X_14 : in    std_logic;  -- A1
    X_15 : in    std_logic;  -- A0
    X_16 : inout std_logic   -- Vcc
);
end component SN74145N;

-- SN74LS147N: 10-to-4 line priority encoder
-- SN74LS148N: 8-to-3 line priority encoder

-----------------------------------------------------------------------
-- SN74150N: 16-input multiplexer
-----------------------------------------------------------------------
component SN74150N is
generic(
    tPLH : time := 35 ns;
    tPHL : time := 33 ns
);
port(
    X_1  : in    std_logic;  -- I7
    X_2  : in    std_logic;  -- I6
    X_3  : in    std_logic;  -- I5
    X_4  : in    std_logic;  -- I4
    X_5  : in    std_logic;  -- I3
    X_6  : in    std_logic;  -- I2
    X_7  : in    std_logic;  -- I1
    X_8  : in    std_logic;  -- I0
    X_9  : in    std_logic;  -- E\
    X_10 : out   std_logic;  -- Z\
    X_11 : in    std_logic;  -- S3
    X_12 : inout std_logic;  -- GND
    X_13 : in    std_logic;  -- S2
    X_14 : in    std_logic;  -- S1
    X_15 : in    std_logic;  -- S0
    X_16 : in    std_logic;  -- I15
    X_17 : in    std_logic;  -- I14
    X_18 : in    std_logic;  -- I13
    X_19 : in    std_logic;  -- I12
    X_20 : in    std_logic;  -- I11
    X_21 : in    std_logic;  -- I10
    X_22 : in    std_logic;  -- I9
    X_23 : in    std_logic;  -- I8
    X_24 : inout std_logic   -- Vcc
);
end component SN74150N;

-----------------------------------------------------------------------
-- SN74LS151N: 8-input multiplexer
-----------------------------------------------------------------------
component SN74LS151N is
generic(
    tPLHZ  : time := 48 ns;
    tPHLZ  : time := 32 ns;
    tPLHZB : time := 24 ns;
    tPHLZB : time := 34 ns
);
port(
    X_1  : in    std_logic;  -- I3
    X_2  : in    std_logic;  -- I2
    X_3  : in    std_logic;  -- I1
    X_4  : in    std_logic;  -- I0
    X_5  : out   std_logic;  -- Z
    X_6  : out   std_logic;  -- Z\
    X_7  : in    std_logic;  -- E\
    X_8  : inout std_logic;  -- GND
    X_9  : in    std_logic;  -- S2
    X_10 : in    std_logic;  -- S1
    X_11 : in    std_logic;  -- S0
    X_12 : in    std_logic;  -- I7
    X_13 : in    std_logic;  -- I6
    X_14 : in    std_logic;  -- I5
    X_15 : in    std_logic;  -- I4
    X_16 : inout std_logic   -- Vcc
);
end component SN74LS151N;

-- SN74LS152N: 8-input multiplexer (flatpack only, no DIP)

-----------------------------------------------------------------------
-- SN74LS153N: Dual 4-input multiplexer (common selects)
-----------------------------------------------------------------------
component SN74LS153N is
generic(
    tPLH : time := 29 ns;
    tPHL : time := 32 ns
);
port(
    X_1  : in    std_logic;  -- EA\
    X_2  : in    std_logic;  -- S1
    X_3  : in    std_logic;  -- I3A
    X_4  : in    std_logic;  -- I2A
    X_5  : in    std_logic;  -- I1A
    X_6  : in    std_logic;  -- I0A
    X_7  : out   std_logic;  -- ZA
    X_8  : inout std_logic;  -- GND
    X_9  : out   std_logic;  -- ZB
    X_10 : in    std_logic;  -- I0B
    X_11 : in    std_logic;  -- I1B
    X_12 : in    std_logic;  -- I2B
    X_13 : in    std_logic;  -- I3B
    X_14 : in    std_logic;  -- S0
    X_15 : in    std_logic;  -- EB\
    X_16 : inout std_logic   -- Vcc
);
end component SN74LS153N;

-----------------------------------------------------------------------
-- SN74154N: 1-of-16 decoder/demultiplexer
-----------------------------------------------------------------------
component SN74154N is
generic(
    tPLH : time := 31 ns;
    tPHL : time := 28 ns
);
port(
    X_1  : out   std_logic;  -- O0\
    X_2  : out   std_logic;  -- O1\
    X_3  : out   std_logic;  -- O2\
    X_4  : out   std_logic;  -- O3\
    X_5  : out   std_logic;  -- O4\
    X_6  : out   std_logic;  -- O5\
    X_7  : out   std_logic;  -- O6\
    X_8  : out   std_logic;  -- O7\
    X_9  : out   std_logic;  -- O8\
    X_10 : out   std_logic;  -- O9\
    X_11 : out   std_logic;  -- O10\
    X_12 : inout std_logic;  -- GND
    X_13 : out   std_logic;  -- O11\
    X_14 : out   std_logic;  -- O12\
    X_15 : out   std_logic;  -- O13\
    X_16 : out   std_logic;  -- O14\
    X_17 : out   std_logic;  -- O15\
    X_18 : in    std_logic;  -- E0\
    X_19 : in    std_logic;  -- E1\
    X_20 : in    std_logic;  -- A3
    X_21 : in    std_logic;  -- A2
    X_22 : in    std_logic;  -- A1
    X_23 : in    std_logic;  -- A0
    X_24 : inout std_logic   -- Vcc
);
end component SN74154N;

-----------------------------------------------------------------------
-- SN74LS155N: Dual 1-of-4 decoder/demultiplexer
-----------------------------------------------------------------------
component SN74LS155N is
generic(
    tPLH : time := 18 ns;
    tPHL : time := 27 ns
);
port(
    X_1  : in    std_logic;  -- EA
    X_2  : in    std_logic;  -- EA\
    X_3  : in    std_logic;  -- A1
    X_4  : out   std_logic;  -- O3A\
    X_5  : out   std_logic;  -- O2A\
    X_6  : out   std_logic;  -- O1A\
    X_7  : out   std_logic;  -- O0A\
    X_8  : inout std_logic;  -- GND
    X_9  : out   std_logic;  -- O0B\
    X_10 : out   std_logic;  -- O1B\
    X_11 : out   std_logic;  -- O2B\
    X_12 : out   std_logic;  -- O3B\
    X_13 : in    std_logic;  -- A0
    X_14 : in    std_logic;  -- EB2\
    X_15 : in    std_logic;  -- EB1\
    X_16 : inout std_logic   -- Vcc
);
end component SN74LS155N;

-----------------------------------------------------------------------
-- SN74LS156N: Dual 1-of-4 decoder/demultiplexer (open collector)
-----------------------------------------------------------------------
component SN74LS156N is
generic(
    tPLH : time := 34 ns;
    tPHL : time := 34 ns
);
port(
    X_1  : in    std_logic;  -- EA
    X_2  : in    std_logic;  -- EA\
    X_3  : in    std_logic;  -- A1
    X_4  : out   std_logic;  -- O3A\
    X_5  : out   std_logic;  -- O2A\
    X_6  : out   std_logic;  -- O1A\
    X_7  : out   std_logic;  -- O0A\
    X_8  : inout std_logic;  -- GND
    X_9  : out   std_logic;  -- O0B\
    X_10 : out   std_logic;  -- O1B\
    X_11 : out   std_logic;  -- O2B\
    X_12 : out   std_logic;  -- O3B\
    X_13 : in    std_logic;  -- A0
    X_14 : in    std_logic;  -- EB2\
    X_15 : in    std_logic;  -- EB1\
    X_16 : inout std_logic   -- Vcc
);
end component SN74LS156N;

-----------------------------------------------------------------------
-- SN74LS157N: Quad 2-input multiplexer (common select)
-----------------------------------------------------------------------
component SN74LS157N is
generic(
    tPLH : time := 26 ns;
    tPHL : time := 24 ns
);
port(
    X_1  : in    std_logic;  -- S
    X_2  : in    std_logic;  -- I0A
    X_3  : in    std_logic;  -- I1A
    X_4  : out   std_logic;  -- ZA
    X_5  : in    std_logic;  -- I0B
    X_6  : in    std_logic;  -- I1B
    X_7  : out   std_logic;  -- ZB
    X_8  : inout std_logic;  -- GND
    X_9  : out   std_logic;  -- ZD
    X_10 : in    std_logic;  -- I1D
    X_11 : in    std_logic;  -- I0D
    X_12 : out   std_logic;  -- ZC
    X_13 : in    std_logic;  -- I1C
    X_14 : in    std_logic;  -- I0C
    X_15 : in    std_logic;  -- E\
    X_16 : inout std_logic   -- Vcc
);
end component SN74LS157N;

-----------------------------------------------------------------------
-- SN74LS158N: Quad 2-input multiplexer (common select: inverting)
-----------------------------------------------------------------------
component SN74LS158N is
generic(
    tPLH : time := 20 ns;
    tPHL : time := 24 ns
);
port(
    X_1  : in    std_logic;  -- S
    X_2  : in    std_logic;  -- I0A
    X_3  : in    std_logic;  -- I1A
    X_4  : out   std_logic;  -- ZA\
    X_5  : in    std_logic;  -- I0B
    X_6  : in    std_logic;  -- I1B
    X_7  : out   std_logic;  -- ZB\
    X_8  : inout std_logic;  -- GND
    X_9  : out   std_logic;  -- ZD\
    X_10 : in    std_logic;  -- I1D
    X_11 : in    std_logic;  -- I0D
    X_12 : out   std_logic;  -- ZC\
    X_13 : in    std_logic;  -- I1C
    X_14 : in    std_logic;  -- I0C
    X_15 : in    std_logic;  -- E\
    X_16 : inout std_logic   -- Vcc
);
end component SN74LS158N;

-----------------------------------------------------------------------
-- SN74LS160N: Synchronous presettable BCD decade counter
-----------------------------------------------------------------------
component SN74LS160N is
generic(
    tPLHT : time := 25 ns;
    tPHLT : time := 23 ns;
    tPLHQ : time := 24 ns;
    tPHLQ : time := 27 ns
);
port(
    X_1  : in    std_logic;  -- R\
    X_2  : in    std_logic;  -- CP
    X_3  : in    std_logic;  -- P0
    X_4  : in    std_logic;  -- P1
    X_5  : in    std_logic;  -- P2
    X_6  : in    std_logic;  -- P3
    X_7  : in    std_logic;  -- CEP
    X_8  : inout std_logic;  -- GND
    X_9  : in    std_logic;  -- PE\
    X_10 : in    std_logic;  -- CET
    X_11 : out   std_logic;  -- Q3
    X_12 : out   std_logic;  -- Q2
    X_13 : out   std_logic;  -- Q1
    X_14 : out   std_logic;  -- Q0
    X_15 : out   std_logic;  -- TC
    X_16 : inout std_logic   -- Vcc
);
end component SN74LS160N;

-----------------------------------------------------------------------
-- SN74LS161N: Synchronous presettable 4-bit binary counter
-----------------------------------------------------------------------
component SN74LS161N is
generic(
    tPLHT : time := 25 ns;
    tPHLT : time := 23 ns;
    tPLHQ : time := 24 ns;
    tPHLQ : time := 27 ns
);
port(
    X_1  : in    std_logic;  -- R\
    X_2  : in    std_logic;  -- CP
    X_3  : in    std_logic;  -- P0
    X_4  : in    std_logic;  -- P1
    X_5  : in    std_logic;  -- P2
    X_6  : in    std_logic;  -- P3
    X_7  : in    std_logic;  -- CEP
    X_8  : inout std_logic;  -- GND
    X_9  : in    std_logic;  -- PE\
    X_10 : in    std_logic;  -- CET
    X_11 : out   std_logic;  -- Q3
    X_12 : out   std_logic;  -- Q2
    X_13 : out   std_logic;  -- Q1
    X_14 : out   std_logic;  -- Q0
    X_15 : out   std_logic;  -- TC
    X_16 : inout std_logic   -- Vcc
);
end component SN74LS161N;

-----------------------------------------------------------------------
-- SN74LS162N: Synchronous presettable BCD decade counter
-----------------------------------------------------------------------
component SN74LS162N is
generic(
    tPLHT : time := 25 ns;
    tPHLT : time := 23 ns;
    tPLHQ : time := 24 ns;
    tPHLQ : time := 27 ns
);
port(
    X_1  : in    std_logic;  -- R\
    X_2  : in    std_logic;  -- CP
    X_3  : in    std_logic;  -- P0
    X_4  : in    std_logic;  -- P1
    X_5  : in    std_logic;  -- P2
    X_6  : in    std_logic;  -- P3
    X_7  : in    std_logic;  -- CEP
    X_8  : inout std_logic;  -- GND
    X_9  : in    std_logic;  -- PE\
    X_10 : in    std_logic;  -- CET
    X_11 : out   std_logic;  -- Q3
    X_12 : out   std_logic;  -- Q2
    X_13 : out   std_logic;  -- Q1
    X_14 : out   std_logic;  -- Q0
    X_15 : out   std_logic;  -- TC
    X_16 : inout std_logic   -- Vcc
);
end component SN74LS162N;

-----------------------------------------------------------------------
-- SN74LS163N: Synchronous presettable 4-bit binary counter
-----------------------------------------------------------------------
component SN74LS163N is
generic(
    tPLHT : time := 25 ns;
    tPHLT : time := 23 ns;
    tPLHQ : time := 24 ns;
    tPHLQ : time := 27 ns
);
port(
    X_1  : in    std_logic;  -- R\
    X_2  : in    std_logic;  -- CP
    X_3  : in    std_logic;  -- P0
    X_4  : in    std_logic;  -- P1
    X_5  : in    std_logic;  -- P2
    X_6  : in    std_logic;  -- P3
    X_7  : in    std_logic;  -- CEP
    X_8  : inout std_logic;  -- GND
    X_9  : in    std_logic;  -- PE\
    X_10 : in    std_logic;  -- CET
    X_11 : out   std_logic;  -- Q3
    X_12 : out   std_logic;  -- Q2
    X_13 : out   std_logic;  -- Q1
    X_14 : out   std_logic;  -- Q0
    X_15 : out   std_logic;  -- TC
    X_16 : inout std_logic   -- Vcc
);
end component SN74LS163N;

-----------------------------------------------------------------------
-- SN74LS164N: SIPO shift register
-----------------------------------------------------------------------
component SN74LS164N is
generic(
    tPLH : time := 27 ns;
    tPHL : time := 32 ns
);
port(
    X_1  : in    std_logic;  -- A
    X_2  : in    std_logic;  -- B
    X_3  : out   std_logic;  -- Q0
    X_4  : out   std_logic;  -- Q1
    X_5  : out   std_logic;  -- Q2
    X_6  : out   std_logic;  -- Q3
    X_7  : inout std_logic;  -- GND
    X_8  : in    std_logic;  -- CP
    X_9  : in    std_logic;  -- MR\
    X_10 : out   std_logic;  -- Q4
    X_11 : out   std_logic;  -- Q5
    X_12 : out   std_logic;  -- Q6
    X_13 : out   std_logic;  -- Q7
    X_14 : inout std_logic   -- Vcc
);
end component SN74LS164N;

-----------------------------------------------------------------------
-- SN74LS165N: 8-bit parallel-to-serial converter
-----------------------------------------------------------------------
component SN74LS165N is
generic(
    tPLH : time := 30 ns;
    tPHL : time := 30 ns
);
port(
    X_1  : in    std_logic;  -- PL\
    X_2  : in    std_logic;  -- CP1
    X_3  : in    std_logic;  -- P4
    X_4  : in    std_logic;  -- P5
    X_5  : in    std_logic;  -- P6
    X_6  : in    std_logic;  -- P7
    X_7  : out   std_logic;  -- Q7\
    X_8  : inout std_logic;  -- GND
    X_9  : out   std_logic;  -- Q7
    X_10 : in    std_logic;  -- DS
    X_11 : in    std_logic;  -- P0
    X_12 : in    std_logic;  -- P1
    X_13 : in    std_logic;  -- P2
    X_14 : in    std_logic;  -- P3
    X_15 : in    std_logic;  -- CP2
    X_16 : inout std_logic   -- Vcc
);
end component SN74LS165N;

-----------------------------------------------------------------------
-- SN74LS166N: 8-bit PISO shift register
-----------------------------------------------------------------------
component SN74LS166N is
generic(
    tPLH : time := 18 ns;
    tPHL : time := 27 ns;
    tSU  : time := 20 ns
);
port(
    X_1  : in    std_logic;  -- DS
    X_2  : in    std_logic;  -- P0
    X_3  : in    std_logic;  -- P1
    X_4  : in    std_logic;  -- P2
    X_5  : in    std_logic;  -- P3
    X_6  : in    std_logic;  -- CP2
    X_7  : in    std_logic;  -- CP1
    X_8  : inout std_logic;  -- GND
    X_9  : in    std_logic;  -- MR\
    X_10 : in    std_logic;  -- P4
    X_11 : in    std_logic;  -- P5
    X_12 : in    std_logic;  -- P6
    X_13 : out   std_logic;  -- Q7
    X_14 : in    std_logic;  -- P7
    X_15 : in    std_logic;  -- PE\
    X_16 : inout std_logic   -- Vcc
);
end component SN74LS166N;

-- SN74167N: Synchronous decade rate multiplier

-----------------------------------------------------------------------
-- SN74LS168N: Synchronous bidirectional BCD decade counter
-----------------------------------------------------------------------
component SN74LS168N is
generic(
    tPLHQ : time := 20 ns;
    tPHLQ : time := 20 ns;
    tPLHT : time := 30 ns;
    tPHLT : time := 30 ns;
    tSU   : time := 15 ns;
    tSUPE : time := 20 ns
);
port(
    X_1  : in    std_logic;  -- U_D\
    X_2  : in    std_logic;  -- CP
    X_3  : in    std_logic;  -- P0
    X_4  : in    std_logic;  -- P1
    X_5  : in    std_logic;  -- P2
    X_6  : in    std_logic;  -- P3
    X_7  : in    std_logic;  -- CEP\
    X_8  : inout std_logic;  -- GND
    X_9  : in    std_logic;  -- PE\
    X_10 : in    std_logic;  -- CET\
    X_11 : out   std_logic;  -- Q3
    X_12 : out   std_logic;  -- Q2
    X_13 : out   std_logic;  -- Q1
    X_14 : out   std_logic;  -- Q0
    X_15 : out   std_logic;  -- TC\
    X_16 : inout std_logic   -- Vcc
);
end component SN74LS168N;

-----------------------------------------------------------------------
-- SN74LS169N: Synchronous bidirectional 4-bit binary counter
-----------------------------------------------------------------------
component SN74LS169N is
generic(
    tPLHQ : time := 20 ns;
    tPHLQ : time := 20 ns;
    tPLHT : time := 30 ns;
    tPHLT : time := 30 ns;
    tSU   : time := 15 ns;
    tSUPE : time := 20 ns
);
port(
    X_1  : in    std_logic;  -- U_D\
    X_2  : in    std_logic;  -- CP
    X_3  : in    std_logic;  -- P0
    X_4  : in    std_logic;  -- P1
    X_5  : in    std_logic;  -- P2
    X_6  : in    std_logic;  -- P3
    X_7  : in    std_logic;  -- CEP\
    X_8  : inout std_logic;  -- GND
    X_9  : in    std_logic;  -- PE\
    X_10 : in    std_logic;  -- CET\
    X_11 : out   std_logic;  -- Q3
    X_12 : out   std_logic;  -- Q2
    X_13 : out   std_logic;  -- Q1
    X_14 : out   std_logic;  -- Q0
    X_15 : out   std_logic;  -- TC\
    X_16 : inout std_logic   -- Vcc
);
end component SN74LS169N;

-----------------------------------------------------------------------
-- SN74LS170N: 4 X 4 register file (open collector)
-----------------------------------------------------------------------
component SN74LS170N is
generic(
    tPLC : time    := 35 ns;
    tPLA : time    := 35 ns;
    tSUD : time    := 10 ns;
    tSUA : time    := 10 ns
);
port(
    X_1  : in    std_logic;  -- D2
    X_2  : in    std_logic;  -- D3
    X_3  : in    std_logic;  -- D4
    X_4  : in    std_logic;  -- RA1
    X_5  : in    std_logic;  -- RA0
    X_6  : out   std_logic;  -- Q4
    X_7  : out   std_logic;  -- Q3
    X_8  : inout std_logic;  -- GND
    X_9  : out   std_logic;  -- Q2
    X_10 : out   std_logic;  -- Q1
    X_11 : in    std_logic;  -- RE\
    X_12 : in    std_logic;  -- WE\
    X_13 : in    std_logic;  -- WA1
    X_14 : in    std_logic;  -- WA0
    X_15 : in    std_logic;  -- D1
    X_16 : inout std_logic   -- Vcc
);
end component SN74LS170N;

-----------------------------------------------------------------------
-- SN74LS173N: 4-bit D-type register (3-state outputs)
-----------------------------------------------------------------------
component SN74LS173N is
generic(
    tSD  : time  := 10 ns;
    tSE  : time  := 17 ns;
    tPQ  : time  := 40 ns;
    tQZ  : time  := 20 ns
);    
port(
    X_1  : in    std_logic;  -- OE1\
    X_2  : in    std_logic;  -- OE2\
    X_3  : out   std_logic;  -- Q0
    X_4  : out   std_logic;  -- Q1
    X_5  : out   std_logic;  -- Q2
    X_6  : out   std_logic;  -- Q3
    X_7  : in    std_logic;  -- CP
    X_8  : inout std_logic;  -- GND
    X_9  : in    std_logic;  -- IE1\
    X_10 : in    std_logic;  -- IE2\
    X_11 : in    std_logic;  -- D3
    X_12 : in    std_logic;  -- D2
    X_13 : in    std_logic;  -- D1
    X_14 : in    std_logic;  -- D0
    X_15 : in    std_logic;  -- MR
    X_16 : inout std_logic   -- Vcc
);
end component SN74LS173N;

-----------------------------------------------------------------------
-- SN74LS174N: Hex D-flipflop
-----------------------------------------------------------------------
component SN74LS174N is
generic(
    tSU  : time := 10 ns;
    tPD  : time := 25 ns
);
port(
    X_1  : in    std_logic;  -- MR\
    X_2  : out   std_logic;  -- Q0
    X_3  : in    std_logic;  -- D0
    X_4  : in    std_logic;  -- D1
    X_5  : out   std_logic;  -- Q1
    X_6  : in    std_logic;  -- D2
    X_7  : out   std_logic;  -- Q2
    X_8  : inout std_logic;  -- GND
    X_9  : in    std_logic;  -- CP
    X_10 : out   std_logic;  -- Q3
    X_11 : in    std_logic;  -- D3
    X_12 : out   std_logic;  -- Q4
    X_13 : in    std_logic;  -- D4
    X_14 : in    std_logic;  -- D5
    X_15 : out   std_logic;  -- Q5
    X_16 : inout std_logic   -- Vcc
);
end component SN74LS174N;

-----------------------------------------------------------------------
-- SN74LS175N: Quad D-flipflop
-----------------------------------------------------------------------
component SN74LS175N is
generic(
    tSU  : time := 10 ns;
    tPD  : time := 25 ns
);
port(
    X_1  : in    std_logic;  -- MR\
    X_2  : out   std_logic;  -- Q0
    X_3  : out   std_logic;  -- Q0\
    X_4  : in    std_logic;  -- D0
    X_5  : in    std_logic;  -- D1
    X_6  : out   std_logic;  -- Q1\
    X_7  : out   std_logic;  -- Q1
    X_8  : inout std_logic;  -- GND
    X_9  : in    std_logic;  -- CP
    X_10 : out   std_logic;  -- Q2
    X_11 : out   std_logic;  -- Q2\
    X_12 : in    std_logic;  -- D2
    X_13 : in    std_logic;  -- D3
    X_14 : out   std_logic;  -- Q3\
    X_15 : out   std_logic;  -- Q3
    X_16 : inout std_logic   -- Vcc
);
end component SN74LS175N;

-----------------------------------------------------------------------
-- SN74176N: Presettable decade counter
-----------------------------------------------------------------------
component SN74176N is
generic(
    tPLH0 : time := 13 ns;
    tPHL0 : time := 17 ns;
    tPLH1 : time := 17 ns;
    tPHL1 : time := 26 ns;
    tPLH2 : time := 41 ns;
    tPHL2 : time := 51 ns;
    tPLH3 : time := 20 ns;
    tPHL3 : time := 26 ns
);
port(
    X_1  : in    std_logic;  -- PL\
    X_2  : out   std_logic;  -- Q2
    X_3  : in    std_logic;  -- P2
    X_4  : in    std_logic;  -- P0
    X_5  : out   std_logic;  -- Q0
    X_6  : in    std_logic;  -- CP1\
    X_7  : inout std_logic;  -- GND
    X_8  : in    std_logic;  -- CP0\
    X_9  : out   std_logic;  -- Q1
    X_10 : in    std_logic;  -- P1
    X_11 : in    std_logic;  -- P3
    X_12 : out   std_logic;  -- Q3
    X_13 : in    std_logic;  -- MR\
    X_14 : inout std_logic   -- Vcc
);
end component SN74176N;

-----------------------------------------------------------------------
-- SN74177N: Presettable binary counter
-----------------------------------------------------------------------
component SN74177N is
generic(
    tPLH0 : time := 13 ns;
    tPHL0 : time := 17 ns;
    tPLH1 : time := 17 ns;
    tPHL1 : time := 26 ns;
    tPLH2 : time := 41 ns;
    tPHL2 : time := 51 ns;
    tPLH3 : time := 66 ns;
    tPHL3 : time := 75 ns
);
port(
    X_1  : in    std_logic;  -- PL\
    X_2  : out   std_logic;  -- Q2
    X_3  : in    std_logic;  -- P2
    X_4  : in    std_logic;  -- P0
    X_5  : out   std_logic;  -- Q0
    X_6  : in    std_logic;  -- CP1\
    X_7  : inout std_logic;  -- GND
    X_8  : in    std_logic;  -- CP0\
    X_9  : out   std_logic;  -- Q1
    X_10 : in    std_logic;  -- P1
    X_11 : in    std_logic;  -- P3
    X_12 : out   std_logic;  -- Q3
    X_13 : in    std_logic;  -- MR\
    X_14 : inout std_logic   -- Vcc
);
end component SN74177N;

-----------------------------------------------------------------------
-- SN74178N: 4-bit shift register
-----------------------------------------------------------------------
component SN74178N is
generic(
    tDL  : time := 36 ns;
    tSU  : time := 35 ns
);
port(
    X_1  : in    std_logic;  -- P1
    X_2  : in    std_logic;  -- P0
    X_3  : in    std_logic;  -- DS
    X_4  : out   std_logic;  -- Q0
    X_5  : in    std_logic;  -- CP\
    X_6  : out   std_logic;  -- Q1
    X_7  : inout std_logic;  -- GND
    X_8  : out   std_logic;  -- Q2
    X_9  : in    std_logic;  -- PE
    X_10 : out   std_logic;  -- Q3
    X_11 : in    std_logic;  -- SE
    X_12 : in    std_logic;  -- P3
    X_13 : in    std_logic;  -- P2
    X_14 : inout std_logic   -- Vcc
);
end component SN74178N;

-----------------------------------------------------------------------
-- SN74179N: 4-bit shift register
-----------------------------------------------------------------------
component SN74179N is
generic(
    tDL  : time := 36 ns;
    tSU  : time := 35 ns
);
port(
    X_1  : in    std_logic;  -- MR\
    X_2  : in    std_logic;  -- P1
    X_3  : in    std_logic;  -- P0
    X_4  : in    std_logic;  -- DS
    X_5  : out   std_logic;  -- Q0
    X_6  : in    std_logic;  -- CP\
    X_7  : out   std_logic;  -- Q1
    X_8  : inout std_logic;  -- GND
    X_9  : out   std_logic;  -- Q2
    X_10 : in    std_logic;  -- PE
    X_11 : out   std_logic;  -- Q3
    X_12 : out   std_logic;  -- Q3\
    X_13 : in    std_logic;  -- SE
    X_14 : in    std_logic;  -- P3
    X_15 : in    std_logic;  -- P2
    X_16 : inout std_logic   -- Vcc
);
end component SN74179N;

-----------------------------------------------------------------------
-- SN74180N: 8-bit parity generator/checker
-----------------------------------------------------------------------
component SN74180N is
generic(
    tPI  : time  := 68 ns;
    tPE  : time  := 20 ns
);
port(
    X_1  : in    std_logic;  -- I6
    X_2  : in    std_logic;  -- I7
    X_3  : in    std_logic;  -- EI
    X_4  : in    std_logic;  -- OI
    X_5  : out   std_logic;  -- SE
    X_6  : out   std_logic;  -- SO
    X_7  : inout std_logic;  -- GND
    X_8  : in    std_logic;  -- I0
    X_9  : in    std_logic;  -- I1
    X_10 : in    std_logic;  -- I2
    X_11 : in    std_logic;  -- I3
    X_12 : in    std_logic;  -- I4
    X_13 : in    std_logic;  -- I5
    X_14 : inout std_logic   -- Vcc
);
end component SN74180N;

-----------------------------------------------------------------------
-- SN74LS181N: 4-bit arithmetic/logic unit
-----------------------------------------------------------------------
component SN74LS181N is
generic(
    T1   : time :=  7 ns;
    T2   : time := 19 ns;
    T3   : time := 16 ns;
    T4   : time := 25 ns;
    T5   : time := 29 ns
);
port(
    X_1  : in    std_logic;  -- B0\
    X_2  : in    std_logic;  -- A0\
    X_3  : in    std_logic;  -- S3
    X_4  : in    std_logic;  -- S2
    X_5  : in    std_logic;  -- S1
    X_6  : in    std_logic;  -- S0
    X_7  : in    std_logic;  -- Cn
    X_8  : in    std_logic;  -- M
    X_9  : out   std_logic;  -- F0\
    X_10 : out   std_logic;  -- F1\
    X_11 : out   std_logic;  -- F2\
    X_12 : inout std_logic;  -- GND
    X_13 : out   std_logic;  -- F3\
    X_14 : out   std_logic;  -- A=B
    X_15 : out   std_logic;  -- P\
    X_16 : out   std_logic;  -- Cn+4
    X_17 : out   std_logic;  -- G\
    X_18 : in    std_logic;  -- B3\
    X_19 : in    std_logic;  -- A3\
    X_20 : in    std_logic;  -- B2\
    X_21 : in    std_logic;  -- A2\
    X_22 : in    std_logic;  -- B1\
    X_23 : in    std_logic;  -- A1\
    X_24 : inout std_logic   -- Vcc
);
end component SN74LS181N;

-----------------------------------------------------------------------
-- SN74LS182N: Fast carry unit for 4 x LS181
-----------------------------------------------------------------------
component SN74LS182N is
generic(
    tCLH : time := 10   ns;
    tCHL : time := 11.5 ns;
    tGLH : time :=  7.5 ns;
    tGHL : time := 10.5 ns;
    tPLH : time :=  6.5 ns;
    tPHL : time := 10   ns
);
port(
    X_1  : in    std_logic;  -- G1
    X_2  : in    std_logic;  -- P1
    X_3  : in    std_logic;  -- G0
    X_4  : in    std_logic;  -- P0
    X_5  : in    std_logic;  -- G3
    X_6  : in    std_logic;  -- P3
    X_7  : out   std_logic;  -- P
    X_8  : inout std_logic;  -- GND
    X_9  : out   std_logic;  -- Cz
    X_10 : out   std_logic;  -- G
    X_11 : out   std_logic;  -- Cy
    X_12 : out   std_logic;  -- Cx
    X_13 : in    std_logic;  -- Cn
    X_14 : in    std_logic;  -- G2
    X_15 : in    std_logic;  -- P2
    X_16 : inout std_logic   -- Vcc
);
end component SN74LS182N;

-----------------------------------------------------------------------
-- SN74H183N: Dual high-speed adder
-----------------------------------------------------------------------
component SN74H183N is
generic(
    tPLH : time := 15 ns;
    tPHL : time := 18 ns
);
port(
    X_1  : in    std_logic;  -- Aa
                             -- 
    X_3  : in    std_logic;  -- Ba
    X_4  : in    std_logic;  -- CIa
    X_5  : out   std_logic;  -- COa
    X_6  : out   std_logic;  -- Sa
    X_7  : inout std_logic;  -- GND
    X_8  : out   std_logic;  -- Sb
                             -- 
    X_10 : out   std_logic;  -- COb
    X_11 : in    std_logic;  -- CIb
    X_12 : in    std_logic;  -- Bb
    X_13 : in    std_logic;  -- Ab
    X_14 : inout std_logic   -- Vcc
);
end component SN74H183N;

-----------------------------------------------------------------------
-- SN74LS189N: 64-bit random-access memory (3-state outputs)
-----------------------------------------------------------------------
component SN74LS189N is
generic(
    tPLC  : time     := 10 ns;
    tPLA  : time     := 37 ns;
    tSUD  : time     := 25 ns;
    tSUA  : time     := 10 ns
);        
port(     
    X_1   : in    std_logic;  -- A0
    X_2   : in    std_logic;  -- CS\
    X_3   : in    std_logic;  -- WE\
    X_4   : in    std_logic;  -- D1
    X_5   : out   std_logic;  -- Q1\
    X_6   : in    std_logic;  -- D2
    X_7   : out   std_logic;  -- Q2\
    X_8   : inout std_logic;  -- GND
    X_9   : out   std_logic;  -- Q3\
    X_10  : in    std_logic;  -- D3
    X_11  : out   std_logic;  -- Q4\
    X_12  : in    std_logic;  -- D4
    X_13  : in    std_logic;  -- A3
    X_14  : in    std_logic;  -- A2
    X_15  : in    std_logic;  -- A1
    X_16  : inout std_logic   -- Vcc
);
end component SN74LS189N;

-----------------------------------------------------------------------
-- SN74LS190N: Up/down decade counter
-----------------------------------------------------------------------
component SN74LS190N is
generic(
    MODULUS : positive := 10;
    tQLH    : time     := 24 ns;
    tQHL    : time     := 36 ns;
    tTLH    : time     := 42 ns;
    tTHL    : time     := 52 ns;
    tRLH    : time     := 20 ns;
    tRHL    : time     := 24 ns
);
port(
    X_1  : in    std_logic;  -- P1
    X_2  : out   std_logic;  -- Q1
    X_3  : out   std_logic;  -- Q0
    X_4  : in    std_logic;  -- CE\
    X_5  : in    std_logic;  -- U\/D
    X_6  : out   std_logic;  -- Q2
    X_7  : out   std_logic;  -- Q3
    X_8  : inout std_logic;  -- GND
    X_9  : in    std_logic;  -- P3
    X_10 : in    std_logic;  -- P2
    X_11 : in    std_logic;  -- PL\
    X_12 : out   std_logic;  -- TC
    X_13 : out   std_logic;  -- RC\
    X_14 : in    std_logic;  -- CP
    X_15 : in    std_logic;  -- P0
    X_16 : inout std_logic   -- Vcc
);
end component SN74LS190N;

-----------------------------------------------------------------------
-- SN74LS191N: Up/down binary counter
-----------------------------------------------------------------------
component SN74LS191N is
generic(
    MODULUS : positive := 16;
    tQLH    : time     := 24 ns;
    tQHL    : time     := 36 ns;
    tTLH    : time     := 42 ns;
    tTHL    : time     := 52 ns;
    tRLH    : time     := 20 ns;
    tRHL    : time     := 24 ns
);
port(
    X_1  : in    std_logic;  -- P1
    X_2  : out   std_logic;  -- Q1
    X_3  : out   std_logic;  -- Q0
    X_4  : in    std_logic;  -- CE\
    X_5  : in    std_logic;  -- U\/D
    X_6  : out   std_logic;  -- Q2
    X_7  : out   std_logic;  -- Q3
    X_8  : inout std_logic;  -- GND
    X_9  : in    std_logic;  -- P3
    X_10 : in    std_logic;  -- P2
    X_11 : in    std_logic;  -- PL\
    X_12 : out   std_logic;  -- TC
    X_13 : out   std_logic;  -- RC\
    X_14 : in    std_logic;  -- CP
    X_15 : in    std_logic;  -- P0
    X_16 : inout std_logic   -- Vcc
);
end component SN74LS191N;

-----------------------------------------------------------------------
-- SN74LS192N: Up/down decade counter
-----------------------------------------------------------------------
component SN74LS192N is
generic(
    MODULUS : positive := 10;
    tQLH    : time     := 32 ns;
    tQHL    : time     := 30 ns;
    tTCULH  : time     := 16 ns;
    tTCUHL  : time     := 21 ns;
    tTCDLH  : time     := 16 ns;
    tTCDHL  : time     := 24 ns
);
port(
    X_1  : in    std_logic;  -- P1
    X_2  : out   std_logic;  -- Q1
    X_3  : out   std_logic;  -- Q0
    X_4  : in    std_logic;  -- CPD
    X_5  : in    std_logic;  -- CPU
    X_6  : out   std_logic;  -- Q2
    X_7  : out   std_logic;  -- Q3
    X_8  : inout std_logic;  -- GND
    X_9  : in    std_logic;  -- P3
    X_10 : in    std_logic;  -- P2
    X_11 : in    std_logic;  -- PL\
    X_12 : out   std_logic;  -- TCU\
    X_13 : out   std_logic;  -- TCD\
    X_14 : in    std_logic;  -- MR
    X_15 : in    std_logic;  -- P0
    X_16 : inout std_logic   -- Vcc
);
end component SN74LS192N;

-----------------------------------------------------------------------
-- SN74LS193N: Up/down binary counter
-----------------------------------------------------------------------
component SN74LS193N is
generic(
    MODULUS : positive := 16;
    tQLH    : time     := 32 ns;
    tQHL    : time     := 30 ns;
    tTCULH  : time     := 16 ns;
    tTCUHL  : time     := 21 ns;
    tTCDLH  : time     := 16 ns;
    tTCDHL  : time     := 24 ns
);
port(
    X_1  : in    std_logic;  -- P1
    X_2  : out   std_logic;  -- Q1
    X_3  : out   std_logic;  -- Q0
    X_4  : in    std_logic;  -- CPD
    X_5  : in    std_logic;  -- CPU
    X_6  : out   std_logic;  -- Q2
    X_7  : out   std_logic;  -- Q3
    X_8  : inout std_logic;  -- GND
    X_9  : in    std_logic;  -- P3
    X_10 : in    std_logic;  -- P2
    X_11 : in    std_logic;  -- PL\
    X_12 : out   std_logic;  -- TCU\
    X_13 : out   std_logic;  -- TCD\
    X_14 : in    std_logic;  -- MR
    X_15 : in    std_logic;  -- P0
    X_16 : inout std_logic   -- Vcc
);
end component SN74LS193N;

-----------------------------------------------------------------------
-- SN74LS194N: 4-bit bidirectional shift register
-----------------------------------------------------------------------
component SN74LS194N is
generic(
    tPLH : time := 21 ns;
    tPHL : time := 24 ns
);
port(
    X_1  : in    std_logic;  -- MR\
    X_2  : in    std_logic;  -- DSR
    X_3  : in    std_logic;  -- P0
    X_4  : in    std_logic;  -- P1
    X_5  : in    std_logic;  -- P2
    X_6  : in    std_logic;  -- P3
    X_7  : in    std_logic;  -- DSL
    X_8  : inout std_logic;  -- GND
    X_9  : in    std_logic;  -- S0
    X_10 : in    std_logic;  -- S1
    X_11 : in    std_logic;  -- CP
    X_12 : out   std_logic;  -- Q3
    X_13 : out   std_logic;  -- Q2
    X_14 : out   std_logic;  -- Q1
    X_15 : out   std_logic;  -- Q0
    X_16 : inout std_logic   -- Vcc
);
end component SN74LS194N;

-----------------------------------------------------------------------
-- SN74LS195N: Universal 4-bit shift register
-----------------------------------------------------------------------
component SN74LS195N is
generic(
    tPLH : time := 21 ns;
    tPHL : time := 24 ns
);
port(
    X_1  : in    std_logic;  -- MR\
    X_2  : in    std_logic;  -- J
    X_3  : in    std_logic;  -- K\
    X_4  : in    std_logic;  -- P0
    X_5  : in    std_logic;  -- P1
    X_6  : in    std_logic;  -- P2
    X_7  : in    std_logic;  -- P3
    X_8  : inout std_logic;  -- GND
    X_9  : in    std_logic;  -- PE\
    X_10 : in    std_logic;  -- CP
    X_11 : out   std_logic;  -- Q3\
    X_12 : out   std_logic;  -- Q3
    X_13 : out   std_logic;  -- Q2
    X_14 : out   std_logic;  -- Q1
    X_15 : out   std_logic;  -- Q0
    X_16 : inout std_logic   -- Vcc
);
end component SN74LS195N;

-----------------------------------------------------------------------
-- SN74LS196N: Presettable decade counter
--             Verified 03/08/2016
-----------------------------------------------------------------------
component SN74LS196N is
generic(
    tPLH0 : time := 12 ns;
    tPHL0 : time := 12 ns;
    tPLH1 : time := 14 ns;
    tPHL1 : time := 14 ns;
    tPLH2 : time := 34 ns;
    tPHL2 : time := 32 ns;
    tPLH3 : time := 18 ns;
    tPHL3 : time := 18 ns
);
port(
    X_1  : in    std_logic;  -- PL\
    X_2  : out   std_logic;  -- Q2
    X_3  : in    std_logic;  -- P2
    X_4  : in    std_logic;  -- P0
    X_5  : out   std_logic;  -- Q0
    X_6  : in    std_logic;  -- CP1\
    X_7  : inout std_logic;  -- GND
    X_8  : in    std_logic;  -- CP0\
    X_9  : out   std_logic;  -- Q1
    X_10 : in    std_logic;  -- P1
    X_11 : in    std_logic;  -- P3
    X_12 : out   std_logic;  -- Q3
    X_13 : in    std_logic;  -- MR\
    X_14 : inout std_logic   -- Vcc
);
end component SN74LS196N;

-----------------------------------------------------------------------
-- SN74LS197N: Presettable binary counter
-----------------------------------------------------------------------
component SN74LS197N is
generic(
    tPLH0 : time := 12 ns;
    tPHL0 : time := 12 ns;
    tPLH1 : time := 14 ns;
    tPHL1 : time := 14 ns;
    tPLH2 : time := 36 ns;
    tPHL2 : time := 34 ns;
    tPLH3 : time := 50 ns;
    tPHL3 : time := 55 ns
);
port(
    X_1  : in    std_logic;  -- PL\
    X_2  : out   std_logic;  -- Q2
    X_3  : in    std_logic;  -- P2
    X_4  : in    std_logic;  -- P0
    X_5  : out   std_logic;  -- Q0
    X_6  : in    std_logic;  -- CP1\
    X_7  : inout std_logic;  -- GND
    X_8  : in    std_logic;  -- CP0\
    X_9  : out   std_logic;  -- Q1
    X_10 : in    std_logic;  -- P1
    X_11 : in    std_logic;  -- P3
    X_12 : out   std_logic;  -- Q3
    X_13 : in    std_logic;  -- MR\
    X_14 : inout std_logic   -- Vcc
);
end component SN74LS197N;

-----------------------------------------------------------------------
-- SN74LS198N: 8-bit right/left shift register
-----------------------------------------------------------------------
component SN74LS198N is
generic(
    tPLH : time := 26 ns;
    tPHL : time := 30 ns
);
port(
    X_1  : in    std_logic;  -- S0
    X_2  : in    std_logic;  -- DSR
    X_3  : in    std_logic;  -- P0
    X_4  : out   std_logic;  -- Q0
    X_5  : in    std_logic;  -- P1
    X_6  : out   std_logic;  -- Q1
    X_7  : in    std_logic;  -- P2
    X_8  : out   std_logic;  -- Q2
    X_9  : in    std_logic;  -- P3
    X_10 : out   std_logic;  -- Q3
    X_11 : in    std_logic;  -- CP
    X_12 : inout std_logic;  -- GND
    X_13 : in    std_logic;  -- MR\
    X_14 : out   std_logic;  -- Q4
    X_15 : in    std_logic;  -- P4
    X_16 : out   std_logic;  -- Q5
    X_17 : in    std_logic;  -- P5
    X_18 : out   std_logic;  -- Q6
    X_19 : in    std_logic;  -- P6
    X_20 : out   std_logic;  -- Q7
    X_21 : in    std_logic;  -- P7
    X_22 : in    std_logic;  -- DSL
    X_23 : in    std_logic;  -- S1
    X_24 : inout std_logic   -- Vcc
);
end component SN74LS198N;

-----------------------------------------------------------------------
-- SN74LS199N: 8-bit parallel IO shift register
-----------------------------------------------------------------------
component SN74LS199N is
generic(
    tPLH : time := 26 ns;
    tPHL : time := 30 ns
);
port(
    X_1  : in    std_logic;  -- K\
    X_2  : in    std_logic;  -- J
    X_3  : in    std_logic;  -- P0
    X_4  : out   std_logic;  -- Q0
    X_5  : in    std_logic;  -- P1
    X_6  : out   std_logic;  -- Q1
    X_7  : in    std_logic;  -- P2
    X_8  : out   std_logic;  -- Q2
    X_9  : in    std_logic;  -- P3
    X_10 : out   std_logic;  -- Q3
    X_11 : in    std_logic;  -- CP1
    X_12 : inout std_logic;  -- GND
    X_13 : in    std_logic;  -- CP2
    X_14 : in    std_logic;  -- MR\
    X_15 : out   std_logic;  -- Q4
    X_16 : in    std_logic;  -- P4
    X_17 : out   std_logic;  -- Q5
    X_18 : in    std_logic;  -- P5
    X_19 : out   std_logic;  -- Q6
    X_20 : in    std_logic;  -- P6
    X_21 : out   std_logic;  -- Q7
    X_22 : in    std_logic;  -- P7
    X_23 : in    std_logic;  -- PE\
    X_24 : inout std_logic   -- Vcc
);
end component SN74LS199N;

-----------------------------------------------------------------------
-- SN74LS221N: Dual monostable multivibrator
-----------------------------------------------------------------------
component SN74LS221N is
generic(
    W1   : time := 100 us;   -- Pulse widths
    W2   : time := 100 us
);
port(
    X_1  : in    std_logic;  -- A1\
    X_2  : in    std_logic;  -- B1
    X_3  : in    std_logic;  -- CD1\
    X_4  : out   std_logic;  -- Q1\
    X_5  : out   std_logic;  -- Q2
    X_6  : inout std_logic;  -- Cx2
    X_7  : inout std_logic;  -- Rx2Cx2
    X_8  : inout std_logic;  -- GND
    X_9  : in    std_logic;  -- A2\
    X_10 : in    std_logic;  -- B2
    X_11 : in    std_logic;  -- CD2\
    X_12 : out   std_logic;  -- Q2\
    X_13 : out   std_logic;  -- Q1
    X_14 : inout std_logic;  -- Cx1
    X_15 : inout std_logic;  -- Rx1Cx1
    X_16 : inout std_logic   -- Vcc
);
end component SN74LS221N;

-----------------------------------------------------------------------
-- SN74LS240N: Octal buffer/line driver (3-state outputs)
-----------------------------------------------------------------------
component SN74LS240N is
generic(
    tPLH : time := 14 ns;
    tPHL : time := 18 ns;
    tPZH : time := 23 ns;
    tPZL : time := 30 ns;
    tPHZ : time := 25 ns;
    tPLZ : time := 18 ns
);
port(
    X_1  : in    std_logic;  -- OEA\
    X_2  : in    std_logic;  -- IA0
    X_3  : out   std_logic;  -- YB0\
    X_4  : in    std_logic;  -- IA1
    X_5  : out   std_logic;  -- YB1\
    X_6  : in    std_logic;  -- IA2
    X_7  : out   std_logic;  -- YB2\
    X_8  : in    std_logic;  -- IA3
    X_9  : out   std_logic;  -- YB3\
    X_10 : inout std_logic;  -- GND
    X_11 : in    std_logic;  -- IB3
    X_12 : out   std_logic;  -- YA3\
    X_13 : in    std_logic;  -- IB2
    X_14 : out   std_logic;  -- YA2\
    X_15 : in    std_logic;  -- IB1
    X_16 : out   std_logic;  -- YA1\
    X_17 : in    std_logic;  -- IB0
    X_18 : out   std_logic;  -- YA0\
    X_19 : in    std_logic;  -- OEB\
    X_20 : inout std_logic   -- Vcc
);
end component SN74LS240N;

-----------------------------------------------------------------------
-- SN74LS241N: Octal buffer/line driver (3-state outputs)
-----------------------------------------------------------------------
component SN74LS241N is
generic(
    tPLH : time := 18 ns;
    tPHL : time := 18 ns;
    tPZH : time := 23 ns;
    tPZL : time := 30 ns;
    tPHZ : time := 25 ns;
    tPLZ : time := 18 ns
);
port(
    X_1  : in    std_logic;  -- OEA\
    X_2  : in    std_logic;  -- IA0
    X_3  : out   std_logic;  -- YB0
    X_4  : in    std_logic;  -- IA1
    X_5  : out   std_logic;  -- YB1
    X_6  : in    std_logic;  -- IA2
    X_7  : out   std_logic;  -- YB2
    X_8  : in    std_logic;  -- IA3
    X_9  : out   std_logic;  -- YB3
    X_10 : inout std_logic;  -- GND
    X_11 : in    std_logic;  -- IB3
    X_12 : out   std_logic;  -- YA3
    X_13 : in    std_logic;  -- IB2
    X_14 : out   std_logic;  -- YA2
    X_15 : in    std_logic;  -- IB1
    X_16 : out   std_logic;  -- YA1
    X_17 : in    std_logic;  -- IB0
    X_18 : out   std_logic;  -- YA0
    X_19 : in    std_logic;  -- OEB
    X_20 : inout std_logic   -- Vcc
);
end component SN74LS241N;

-----------------------------------------------------------------------
-- SN74LS242N: Quad bus transceiver (3-state outputs)
-----------------------------------------------------------------------
component SN74LS242N is
generic(
    tPLH : time := 14 ns;
    tPHL : time := 18 ns;
    tPZH : time := 23 ns;
    tPZL : time := 30 ns;
    tPHZ : time := 25 ns;
    tPLZ : time := 18 ns
);
port(
    X_1  : in    std_logic;  -- A2B\
                             -- 
    X_3  : inout std_logic;  -- A1
    X_4  : inout std_logic;  -- A2
    X_5  : inout std_logic;  -- A3
    X_6  : inout std_logic;  -- A4
    X_7  : inout std_logic;  -- GND
    X_8  : inout std_logic;  -- B4\
    X_9  : inout std_logic;  -- B3\
    X_10 : inout std_logic;  -- B2\
    X_11 : inout std_logic;  -- B1\
                             -- 
    X_13 : in    std_logic;  -- B2A
    X_14 : inout std_logic   -- Vcc
);
end component SN74LS242N;

-----------------------------------------------------------------------
-- SN74LS243N: Quad bus transceiver (3-state outputs)
-----------------------------------------------------------------------
component SN74LS243N is
generic(
    tPLH : time := 18 ns;
    tPHL : time := 18 ns;
    tPZH : time := 23 ns;
    tPZL : time := 30 ns;
    tPHZ : time := 25 ns;
    tPLZ : time := 18 ns
);
port(
    X_1  : in    std_logic;  -- A2B\
                             -- 
    X_3  : inout std_logic;  -- A1
    X_4  : inout std_logic;  -- A2
    X_5  : inout std_logic;  -- A3
    X_6  : inout std_logic;  -- A4
    X_7  : inout std_logic;  -- GND
    X_8  : inout std_logic;  -- B4
    X_9  : inout std_logic;  -- B3
    X_10 : inout std_logic;  -- B2
    X_11 : inout std_logic;  -- B1
                             -- 
    X_13 : in    std_logic;  -- B2A
    X_14 : inout std_logic   -- Vcc
);
end component SN74LS243N;

-----------------------------------------------------------------------
-- SN74LS244N: Octal buffer/line driver (3-state outputs)
-----------------------------------------------------------------------
component SN74LS244N is
generic(
    tPLH : time := 18 ns;
    tPHL : time := 18 ns;
    tPZH : time := 23 ns;
    tPZL : time := 30 ns;
    tPHZ : time := 25 ns;
    tPLZ : time := 18 ns
);
port(
    X_1  : in    std_logic;  -- OEA\
    X_2  : in    std_logic;  -- IA0
    X_3  : out   std_logic;  -- YB0
    X_4  : in    std_logic;  -- IA1
    X_5  : out   std_logic;  -- YB1
    X_6  : in    std_logic;  -- IA2
    X_7  : out   std_logic;  -- YB2
    X_8  : in    std_logic;  -- IA3
    X_9  : out   std_logic;  -- YB3
    X_10 : inout std_logic;  -- GND
    X_11 : in    std_logic;  -- IB3
    X_12 : out   std_logic;  -- YA3
    X_13 : in    std_logic;  -- IB2
    X_14 : out   std_logic;  -- YA2
    X_15 : in    std_logic;  -- IB1
    X_16 : out   std_logic;  -- YA1
    X_17 : in    std_logic;  -- IB0
    X_18 : out   std_logic;  -- YA0
    X_19 : in    std_logic;  -- OEB\
    X_20 : inout std_logic   -- Vcc
);
end component SN74LS244N;

-----------------------------------------------------------------------
-- SN74LS245N: Octal bus transceiver (3-state outputs)
-----------------------------------------------------------------------
component SN74LS245N is
generic(
    tPLH : time := 18 ns;
    tPHL : time := 18 ns;
    tPZH : time := 23 ns;
    tPZL : time := 30 ns;
    tPHZ : time := 25 ns;
    tPLZ : time := 18 ns
);
port(
    X_1  : in    std_logic;  -- A2B
    X_2  : inout std_logic;  -- A0
    X_3  : inout std_logic;  -- A1
    X_4  : inout std_logic;  -- A2
    X_5  : inout std_logic;  -- A3
    X_6  : inout std_logic;  -- A4
    X_7  : inout std_logic;  -- A5
    X_8  : inout std_logic;  -- A6
    X_9  : inout std_logic;  -- A7
    X_10 : inout std_logic;  -- GND
    X_11 : inout std_logic;  -- B7
    X_12 : inout std_logic;  -- B6
    X_13 : inout std_logic;  -- B5
    X_14 : inout std_logic;  -- B4
    X_15 : inout std_logic;  -- B3
    X_16 : inout std_logic;  -- B2
    X_17 : inout std_logic;  -- B1
    X_18 : inout std_logic;  -- B0
    X_19 : in    std_logic;  -- E\
    X_20 : inout std_logic   -- Vcc
);
end component SN74LS245N;

-- SN74LS247N: BCD to 7-segment decoder/driver (open collector)
-- SN74LS248N: BCD to 7-segment decoder/driver (2kR pullups)
-- SN74LS249N: BCD to 7-segment decoder (open collector)

-----------------------------------------------------------------------
-- SN74LS251N: 8-input multiplexer (3-state outputs)
-----------------------------------------------------------------------
component SN74LS251N is
generic(
    tQBLH  : time :=  18 ns;    -- Synthetic values, QB - Q delay
    tQBHL  : time :=  12 ns;
    tPS    : time :=  33 ns;
    tPI    : time :=  15 ns;    
    tPZH   : time :=  20 ns;
    tPZL   : time :=  25 ns;
    tPHZ   : time :=  25 ns;
    tPLZ   : time :=  20 ns
);
port(
    X_1  : in    std_logic;  -- I3
    X_2  : in    std_logic;  -- I2
    X_3  : in    std_logic;  -- I1
    X_4  : in    std_logic;  -- I0
    X_5  : out   std_logic;  -- Z
    X_6  : out   std_logic;  -- Z\
    X_7  : in    std_logic;  -- OE\
    X_8  : inout std_logic;  -- GND
    X_9  : in    std_logic;  -- S2
    X_10 : in    std_logic;  -- S1
    X_11 : in    std_logic;  -- S0
    X_12 : in    std_logic;  -- I7
    X_13 : in    std_logic;  -- I6
    X_14 : in    std_logic;  -- I5
    X_15 : in    std_logic;  -- I4
    X_16 : inout std_logic   -- Vcc
);
end component SN74LS251N;

-----------------------------------------------------------------------
-- SN74LS253N: Dual 4-input multiplexer (3-state outputs)
-----------------------------------------------------------------------
component SN74LS253N is
generic(
    tPLH  : time := 29 ns;
    tPHL  : time := 24 ns;
    tPZX  : time := 22 ns;
    tPXZ  : time := 32 ns
);
port(
    X_1  : in    std_logic;  -- OEA\
    X_2  : in    std_logic;  -- S1
    X_3  : in    std_logic;  -- I3A
    X_4  : in    std_logic;  -- I2A
    X_5  : in    std_logic;  -- I1A
    X_6  : in    std_logic;  -- I0A
    X_7  : out   std_logic;  -- ZA
    X_8  : inout std_logic;  -- GND
    X_9  : out   std_logic;  -- ZB
    X_10 : in    std_logic;  -- I0B
    X_11 : in    std_logic;  -- I1B
    X_12 : in    std_logic;  -- I2B
    X_13 : in    std_logic;  -- I3B
    X_14 : in    std_logic;  -- S0
    X_15 : in    std_logic;  -- OEB\
    X_16 : inout std_logic   -- Vcc
);
end component SN74LS253N;

-----------------------------------------------------------------------
-- SN74LS256N: Dual 4-bit addressable latch
-----------------------------------------------------------------------
component SN74LS256N is
generic(
    tPXDA : time := 30 ns;
    tPHLC : time := 18 ns
);
port(
    X_1  : in    std_logic;  -- A0
    X_2  : in    std_logic;  -- A1
    X_3  : in    std_logic;  -- DA
    X_4  : out   std_logic;  -- O0A
    X_5  : out   std_logic;  -- O1A
    X_6  : out   std_logic;  -- O2A
    X_7  : out   std_logic;  -- O3A
    X_8  : inout std_logic;  -- GND
    X_9  : out   std_logic;  -- O0B
    X_10 : out   std_logic;  -- O1B
    X_11 : out   std_logic;  -- O2B
    X_12 : out   std_logic;  -- O3B
    X_13 : in    std_logic;  -- DB
    X_14 : in    std_logic;  -- E\
    X_15 : in    std_logic;  -- CL\
    X_16 : inout std_logic   -- Vcc
);
end component SN74LS256N;

-----------------------------------------------------------------------
-- SN74LS257N: Quad 2-input multiplexer (3-state outputs)
-----------------------------------------------------------------------
component SN74LS257N is
generic(
    tPI  : time := 18 ns;
    tPS  : time := 21 ns;
    tPE  : time := 30 ns
);
port(
    X_1  : in    std_logic;  -- S
    X_2  : in    std_logic;  -- I0A
    X_3  : in    std_logic;  -- I1A
    X_4  : out   std_logic;  -- ZA
    X_5  : in    std_logic;  -- I0B
    X_6  : in    std_logic;  -- I1B
    X_7  : out   std_logic;  -- ZB
    X_8  : inout std_logic;  -- GND
    X_9  : out   std_logic;  -- ZD
    X_10 : in    std_logic;  -- I1D
    X_11 : in    std_logic;  -- I0D
    X_12 : out   std_logic;  -- ZC
    X_13 : in    std_logic;  -- I1C
    X_14 : in    std_logic;  -- I0C
    X_15 : in    std_logic;  -- OE\
    X_16 : inout std_logic   -- Vcc
);
end component SN74LS257N;

-----------------------------------------------------------------------
-- SN74LS258N: Quad 2-input multiplexer (inverting 3-state outputs)
-----------------------------------------------------------------------
component SN74LS258N is
generic(
    tPI  : time := 18 ns;
    tPS  : time := 21 ns;
    tPE  : time := 30 ns
);
port(
    X_1  : in    std_logic;  -- S
    X_2  : in    std_logic;  -- I0A
    X_3  : in    std_logic;  -- I1A
    X_4  : out   std_logic;  -- ZA\
    X_5  : in    std_logic;  -- I0B
    X_6  : in    std_logic;  -- I1B
    X_7  : out   std_logic;  -- ZB\
    X_8  : inout std_logic;  -- GND
    X_9  : out   std_logic;  -- ZD\
    X_10 : in    std_logic;  -- I1D
    X_11 : in    std_logic;  -- I0D
    X_12 : out   std_logic;  -- ZC\
    X_13 : in    std_logic;  -- I1C
    X_14 : in    std_logic;  -- I0C
    X_15 : in    std_logic;  -- OE\
    X_16 : inout std_logic   -- Vcc
);
end component SN74LS258N;

-----------------------------------------------------------------------
-- SN74LS259N: 8-bit addressable latch
-----------------------------------------------------------------------
component SN74LS259N is
generic(
    tPXDA : time := 30 ns;
    tPHLC : time := 18 ns
);
port(
    X_1  : in    std_logic;  -- A0
    X_2  : in    std_logic;  -- A1
    X_3  : in    std_logic;  -- A2
    X_4  : out   std_logic;  -- Q0
    X_5  : out   std_logic;  -- Q1
    X_6  : out   std_logic;  -- Q2
    X_7  : out   std_logic;  -- Q3
    X_8  : inout std_logic;  -- GND
    X_9  : out   std_logic;  -- Q4
    X_10 : out   std_logic;  -- Q5
    X_11 : out   std_logic;  -- Q6
    X_12 : out   std_logic;  -- Q7
    X_13 : in    std_logic;  -- D
    X_14 : in    std_logic;  -- E\
    X_15 : in    std_logic;  -- CL\
    X_16 : inout std_logic   -- Vcc
);
end component SN74LS259N;

-----------------------------------------------------------------------
-- SN74LS260N: Dual 5-input NOR gate
-----------------------------------------------------------------------
component SN74LS260N is
generic(
    tPLH : time := 10 ns;
    tPHL : time := 12 ns
);
port(
    X_1  : in    std_logic;  -- I1A
    X_2  : in    std_logic;  -- I2A
    X_3  : in    std_logic;  -- I3A
    X_4  : in    std_logic;  -- I1B
    X_5  : out   std_logic;  -- ZA\
    X_6  : out   std_logic;  -- ZB\
    X_7  : inout std_logic;  -- GND
    X_8  : in    std_logic;  -- I2B
    X_9  : in    std_logic;  -- I3B
    X_10 : in    std_logic;  -- I4B
    X_11 : in    std_logic;  -- I5B
    X_12 : in    std_logic;  -- I4A
    X_13 : in    std_logic;  -- I5A
    X_14 : inout std_logic   -- Vcc
);
end component SN74LS260N;

-- SN74LS261N: 2-bit x 4-bit parallel binary multiplier

-----------------------------------------------------------------------
-- SN74LS266N: Quad 2-input XNOR gate (open collector)
-----------------------------------------------------------------------
component SN74LS266N is
generic(
    tPLH : time := 30 ns;
    tPHL : time := 30 ns
);
port(
    X_1  : in    std_logic;  -- 1A
    X_2  : in    std_logic;  -- 1B
    X_3  : out   std_logic;  -- 1Y\
    X_4  : out   std_logic;  -- 2Y\
    X_5  : in    std_logic;  -- 2A
    X_6  : in    std_logic;  -- 2B
    X_7  : inout std_logic;  -- GND
    X_8  : in    std_logic;  -- 3B
    X_9  : in    std_logic;  -- 3A
    X_10 : out   std_logic;  -- 3Y\
    X_11 : out   std_logic;  -- 4Y\
    X_12 : in    std_logic;  -- 4B
    X_13 : in    std_logic;  -- 4A
    X_14 : inout std_logic   -- Vcc 
);
end component SN74LS266N;

-----------------------------------------------------------------------
-- SN74LS273N: 8-bit register, with Clear
-----------------------------------------------------------------------
component SN74LS273N is
generic(
    tPX  : time := 24 ns
);
port(
    X_1  : in    std_logic;  -- MR\
    X_2  : out   std_logic;  -- Q0
    X_3  : in    std_logic;  -- D0
    X_4  : in    std_logic;  -- D1
    X_5  : out   std_logic;  -- Q1
    X_6  : out   std_logic;  -- Q2
    X_7  : in    std_logic;  -- D2
    X_8  : in    std_logic;  -- D3
    X_9  : out   std_logic;  -- Q3
    X_10 : inout std_logic;  -- GND
    X_11 : in    std_logic;  -- CP
    X_12 : out   std_logic;  -- Q4
    X_13 : in    std_logic;  -- D4
    X_14 : in    std_logic;  -- D5
    X_15 : out   std_logic;  -- Q5
    X_16 : out   std_logic;  -- Q6
    X_17 : in    std_logic;  -- D6
    X_18 : in    std_logic;  -- D7
    X_19 : out   std_logic;  -- Q7
    X_20 : inout std_logic   -- Vcc
);
end component SN74LS273N;

-----------------------------------------------------------------------
-- SN74LS279N: Quad set/reset latch
-----------------------------------------------------------------------
component SN74LS279N is
generic(
    tPX  : time := 27 ns
);
port(
    X_1  : in    std_logic;  -- 1R\
    X_2  : in    std_logic;  -- 1S1\
    X_3  : in    std_logic;  -- 1S2\
    X_4  : out   std_logic;  -- 1Q
    X_5  : in    std_logic;  -- 2R\
    X_6  : in    std_logic;  -- 2S\
    X_7  : out   std_logic;  -- 2Q
    X_8  : inout std_logic;  -- GND
    X_9  : out   std_logic;  -- 3Q
    X_10 : in    std_logic;  -- 3S\
    X_11 : in    std_logic;  -- 3R1\
    X_12 : in    std_logic;  -- 3R2\
    X_13 : out   std_logic;  -- 4Q
    X_14 : in    std_logic;  -- 4S\
    X_15 : in    std_logic;  -- 4R\
    X_16 : inout std_logic   -- Vcc
);
end component SN74LS279N;

-----------------------------------------------------------------------
-- SN74LS280N: 9-bit parity generator/checker
-----------------------------------------------------------------------
component SN74LS280N is
generic(
    tPLH : time := 21 ns;
    tPHL : time := 18 ns
);
port(
    X_1  : in    std_logic;  -- I6
    X_2  : in    std_logic;  -- I7
                             -- 
    X_4  : in    std_logic;  -- I8
    X_5  : out   std_logic;  -- SE
    X_6  : out   std_logic;  -- SO
    X_7  : inout std_logic;  -- GND
    X_8  : in    std_logic;  -- I0
    X_9  : in    std_logic;  -- I1
    X_10 : in    std_logic;  -- I2
    X_11 : in    std_logic;  -- I3
    X_12 : in    std_logic;  -- I4
    X_13 : in    std_logic;  -- I5
    X_14 : inout std_logic   -- Vcc
);
end component SN74LS280N;

-----------------------------------------------------------------------
-- SN74LS283N: 4-bit binary full adder (with fast carry)
-----------------------------------------------------------------------
component SN74LS283N is
generic(
    tPLHS  : time := 24 ns;
    tPHLS  : time := 24 ns;
    tPLHC  : time := 17 ns;
    tPHLC  : time := 17 ns
);
port(
    X_1  : out   std_logic;  -- S1
    X_2  : in    std_logic;  -- B1
    X_3  : in    std_logic;  -- A1
    X_4  : out   std_logic;  -- S0
    X_5  : in    std_logic;  -- A0
    X_6  : in    std_logic;  -- B0
    X_7  : in    std_logic;  -- C0
    X_8  : inout std_logic;  -- GND
    X_9  : out   std_logic;  -- C4
    X_10 : out   std_logic;  -- S3
    X_11 : in    std_logic;  -- B3
    X_12 : in    std_logic;  -- A3
    X_13 : out   std_logic;  -- S2
    X_14 : in    std_logic;  -- A2
    X_15 : in    std_logic;  -- B2
    X_16 : inout std_logic   -- Vcc
);
end component SN74LS283N;

-----------------------------------------------------------------------
-- SN74LS289N: 64-bit random access memory (open collector)
-----------------------------------------------------------------------
component SN74LS289N is
generic(
    tPLC  : time     := 10 ns;
    tPLA  : time     := 37 ns;
    tSUD  : time     := 25 ns;
    tSUA  : time     := 10 ns
);        
port(     
    X_1   : in    std_logic;  -- A0
    X_2   : in    std_logic;  -- CS\
    X_3   : in    std_logic;  -- WE\
    X_4   : in    std_logic;  -- D1
    X_5   : out   std_logic;  -- Q1\
    X_6   : in    std_logic;  -- D2
    X_7   : out   std_logic;  -- Q2\
    X_8   : inout std_logic;  -- GND
    X_9   : out   std_logic;  -- Q3\
    X_10  : in    std_logic;  -- D3
    X_11  : out   std_logic;  -- Q4\
    X_12  : in    std_logic;  -- D4
    X_13  : in    std_logic;  -- A3
    X_14  : in    std_logic;  -- A2
    X_15  : in    std_logic;  -- A1
    X_16  : inout std_logic   -- Vcc
);
end component SN74LS289N;

-----------------------------------------------------------------------
-- SN74LS290N: BCD decade counter
-----------------------------------------------------------------------
component SN74LS290N is
generic(
    tPLH0 : time := 16 ns;
    tPHL0 : time := 18 ns;
    tPLH1 : time := 16 ns;
    tPHL1 : time := 21 ns;
    tPLH2 : time := 32 ns;
    tPHL2 : time := 35 ns;
    tPLH3 : time := 32 ns;
    tPHL3 : time := 35 ns
);
port(
    X_1  : in    std_logic;  -- MS1
                             -- 
    X_3  : in    std_logic;  -- MS2
    X_4  : out   std_logic;  -- Q2
    X_5  : out   std_logic;  -- Q1
                             -- 
    X_7  : inout std_logic;  -- GND
    X_8  : out   std_logic;  -- Q3
    X_9  : out   std_logic;  -- Q0
    X_10 : in    std_logic;  -- CP0\
    X_11 : in    std_logic;  -- CP1\
    X_12 : in    std_logic;  -- MR1
    X_13 : in    std_logic;  -- MR2
    X_14 : inout std_logic   -- Vcc
);
end component SN74LS290N;

-- SN74LS292N: Programmable frequency divider / digital timer

-----------------------------------------------------------------------
-- SN74LS293N: 4-bit binary counter
-----------------------------------------------------------------------
component SN74LS293N is
generic(
    tPLH0 : time := 16 ns;
    tPHL0 : time := 18 ns;
    tPLH1 : time := 16 ns;
    tPHL1 : time := 21 ns;
    tPLH2 : time := 32 ns;
    tPHL2 : time := 35 ns;
    tPLH3 : time := 32 ns;
    tPHL3 : time := 35 ns
);
port(
                             -- 
                             -- 
                             -- 
    X_4  : out   std_logic;  -- Q2
    X_5  : out   std_logic;  -- Q1
                             -- 
    X_7  : inout std_logic;  -- GND
    X_8  : out   std_logic;  -- Q3
    X_9  : out   std_logic;  -- Q0
    X_10 : in    std_logic;  -- CP0\
    X_11 : in    std_logic;  -- CP1\
    X_12 : in    std_logic;  -- MR1
    X_13 : in    std_logic;  -- MR2
    X_14 : inout std_logic   -- Vcc
);
end component SN74LS293N;

-- SN74LS294N: Programmable frequency divider / digital timer

-----------------------------------------------------------------------
-- SN74LS295AN: 4-bit shift register (3-state outputs)
-----------------------------------------------------------------------
component SN74LS295AN is
generic(
    tPLH : time := 30 ns;
    tPHL : time := 26 ns;
    tPZH : time := 18 ns;
    tPZL : time := 20 ns;
    tPHZ : time := 24 ns;
    tPLZ : time := 20 ns
);
port(
    X_1  : in    std_logic;  -- DS
    X_2  : in    std_logic;  -- P0
    X_3  : in    std_logic;  -- P1
    X_4  : in    std_logic;  -- P2
    X_5  : in    std_logic;  -- P3
    X_6  : in    std_logic;  -- PE
    X_7  : inout std_logic;  -- GND
    X_8  : in    std_logic;  -- OE
    X_9  : in    std_logic;  -- CP\
    X_10 : out   std_logic;  -- Q3
    X_11 : out   std_logic;  -- Q2
    X_12 : out   std_logic;  -- Q1
    X_13 : out   std_logic;  -- Q0
    X_14 : inout std_logic   -- Vcc
);
end component SN74LS295AN;

-----------------------------------------------------------------------
-- SN74LS298N: Quad 2-port register (multiplexer with storage)
-----------------------------------------------------------------------
component SN74LS298N is
generic(
    tPLH : time := 25 ns;
    tPHL : time := 25 ns
);
port(
    X_1  : in    std_logic;  -- I1B
    X_2  : in    std_logic;  -- I1A
    X_3  : in    std_logic;  -- I0A
    X_4  : in    std_logic;  -- I0B
    X_5  : in    std_logic;  -- I1C
    X_6  : in    std_logic;  -- I1D
    X_7  : in    std_logic;  -- I0D
    X_8  : inout std_logic;  -- GND
    X_9  : in    std_logic;  -- I0C
    X_10 : in    std_logic;  -- S
    X_11 : in    std_logic;  -- CP\
    X_12 : out   std_logic;  -- QD
    X_13 : out   std_logic;  -- QC
    X_14 : out   std_logic;  -- QB
    X_15 : out   std_logic;  -- QA
    X_16 : inout std_logic   -- Vcc
);
end component SN74LS298N;

-----------------------------------------------------------------------
-- SN74LS299N: 8-bit universal shift/storage register
-----------------------------------------------------------------------
component SN74LS299N is
generic(
    tPLH : time := 25 ns;
    tPHL : time := 29 ns;
    tPZH : time := 18 ns;
    tPZL : time := 23 ns;
    tPHZ : time := 15 ns;
    tPLZ : time := 15 ns;
    tRSD : time :=  3 ns     -- Extra delay after reset
);
port(
    X_1  : in    std_logic;  -- S0
    X_2  : in    std_logic;  -- OE1\
    X_3  : in    std_logic;  -- OE2\
    X_4  : inout std_logic;  -- IO6
    X_5  : inout std_logic;  -- IO4
    X_6  : inout std_logic;  -- IO2
    X_7  : inout std_logic;  -- IO0
    X_8  : out   std_logic;  -- Q0
    X_9  : in    std_logic;  -- MR\
    X_10 : inout std_logic;  -- GND
    X_11 : in    std_logic;  -- DS0
    X_12 : in    std_logic;  -- CP
    X_13 : inout std_logic;  -- IO1
    X_14 : inout std_logic;  -- IO3
    X_15 : inout std_logic;  -- IO5
    X_16 : inout std_logic;  -- IO7
    X_17 : out   std_logic;  -- Q7
    X_18 : in    std_logic;  -- DS7
    X_19 : in    std_logic;  -- S1
    X_20 : inout std_logic   -- Vcc
);
end component SN74LS299N;

-----------------------------------------------------------------------
-- SN74LS322N: 8-bit SIPO register (with sign extend)
-----------------------------------------------------------------------
component SN74LS322N is
generic(
    tPLH : time := 25 ns;
    tPHL : time := 30 ns;
    tPZH : time := 25 ns;
    tPZL : time := 30 ns;
    tPHZ : time := 23 ns;
    tPLZ : time := 23 ns;
    tRSD : time :=  3 ns     -- Extra delay after reset
);
port(
    X_1  : in    std_logic;  -- RE\
    X_2  : in    std_logic;  -- S/P\
    X_3  : in    std_logic;  -- D0
    X_4  : inout std_logic;  -- IO7
    X_5  : inout std_logic;  -- IO5
    X_6  : inout std_logic;  -- IO3
    X_7  : inout std_logic;  -- IO1
    X_8  : in    std_logic;  -- OE\
    X_9  : in    std_logic;  -- MR\
    X_10 : inout std_logic;  -- GND
    X_11 : in    std_logic;  -- CP
    X_12 : out   std_logic;  -- Q0
    X_13 : inout std_logic;  -- IO0
    X_14 : inout std_logic;  -- IO2
    X_15 : inout std_logic;  -- IO4
    X_16 : inout std_logic;  -- IO6
    X_17 : in    std_logic;  -- D1
    X_18 : in    std_logic;  -- SE\
    X_19 : in    std_logic;  -- S
    X_20 : inout std_logic   -- Vcc
);
end component SN74LS322N;

-----------------------------------------------------------------------
-- SN74LS323N: 8-bit universal shift/storage register
-----------------------------------------------------------------------
component SN74LS323N is
generic(
    tPLH : time := 25 ns;
    tPHL : time := 29 ns;
    tPZH : time := 18 ns;
    tPZL : time := 23 ns;
    tPHZ : time := 15 ns;
    tPLZ : time := 15 ns
);
port(
    X_1  : in    std_logic;  -- S0
    X_2  : in    std_logic;  -- OE1\
    X_3  : in    std_logic;  -- OE2\
    X_4  : inout std_logic;  -- IO6
    X_5  : inout std_logic;  -- IO4
    X_6  : inout std_logic;  -- IO2
    X_7  : inout std_logic;  -- IO0
    X_8  : out   std_logic;  -- Q0
    X_9  : in    std_logic;  -- SR\
    X_10 : inout std_logic;  -- GND
    X_11 : in    std_logic;  -- DSO
    X_12 : in    std_logic;  -- CP
    X_13 : inout std_logic;  -- IO1
    X_14 : inout std_logic;  -- IO3
    X_15 : inout std_logic;  -- IO5
    X_16 : inout std_logic;  -- IO7
    X_17 : out   std_logic;  -- Q7
    X_18 : in    std_logic;  -- DS7
    X_19 : in    std_logic;  -- S1
    X_20 : inout std_logic   -- Vcc
);
end component SN74LS323N;

-- SN74LS347N: BCD to 7-segment decoder/demultiplexer
-- SN74LS348N: 8-to-3 line priority encoder (3-state outputs)

-----------------------------------------------------------------------
-- SN74LS352N: Dual 4-input multiplexer
-----------------------------------------------------------------------
component SN74LS352N is
generic(
    tPLH : time := 22 ns;
    tPHL : time := 38 ns
);
port(
    X_1  : in    std_logic;  -- EA\
    X_2  : in    std_logic;  -- S1
    X_3  : in    std_logic;  -- I3A
    X_4  : in    std_logic;  -- I2A
    X_5  : in    std_logic;  -- I1A
    X_6  : in    std_logic;  -- I0A
    X_7  : out   std_logic;  -- ZA\
    X_8  : inout std_logic;  -- GND
    X_9  : out   std_logic;  -- ZB\
    X_10 : in    std_logic;  -- I0B
    X_11 : in    std_logic;  -- I1B
    X_12 : in    std_logic;  -- I2B
    X_13 : in    std_logic;  -- I3B
    X_14 : in    std_logic;  -- S0
    X_15 : in    std_logic;  -- EB\
    X_16 : inout std_logic   -- Vcc
);
end component SN74LS352N;

-----------------------------------------------------------------------
-- SN74LS353N: Dual 4-input multiplexer (3-state outputs)
-----------------------------------------------------------------------
component SN74LS353N is
generic(
    tPLH  : time := 24 ns;
    tPHL  : time := 32 ns;
    tPZX  : time := 18 ns;
    tPXZ  : time := 18 ns
);
port(
    X_1  : in    std_logic;  -- OEA\
    X_2  : in    std_logic;  -- S1
    X_3  : in    std_logic;  -- I3A
    X_4  : in    std_logic;  -- I2A
    X_5  : in    std_logic;  -- I1A
    X_6  : in    std_logic;  -- I0A
    X_7  : out   std_logic;  -- ZA\
    X_8  : inout std_logic;  -- GND
    X_9  : out   std_logic;  -- ZB\
    X_10 : in    std_logic;  -- I0B
    X_11 : in    std_logic;  -- I1B
    X_12 : in    std_logic;  -- I2B
    X_13 : in    std_logic;  -- I3B
    X_14 : in    std_logic;  -- S0
    X_15 : in    std_logic;  -- OEB\
    X_16 : inout std_logic   -- Vcc
);
end component SN74LS353N;

-- SN74LS354N: 8-to-1 line selector/multiplexer/register
-- SN74LS355N: 8-to-1 line selector/multiplexer/register
-- SN74LS356N: 8-to-1 line selector/multiplexer/register

-----------------------------------------------------------------------
-- SN74LS365AN: Hex 3-state buffer
-----------------------------------------------------------------------
component SN74LS365AN is
generic(
    tPLH : time := 16 ns;
    tPHL : time := 22 ns;
    tPZH : time := 24 ns;
    tPZL : time := 30 ns;
    tPHZ : time := 20 ns;
    tPLZ : time := 25 ns
);
port(
    X_1  : in    std_logic;  -- E1\
    X_2  : in    std_logic;  -- A1
    X_3  : out   std_logic;  -- Y1
    X_4  : in    std_logic;  -- A2
    X_5  : out   std_logic;  -- Y2
    X_6  : in    std_logic;  -- A3
    X_7  : out   std_logic;  -- Y3
    X_8  : inout std_logic;  -- GND
    X_9  : out   std_logic;  -- Y4
    X_10 : in    std_logic;  -- A4
    X_11 : out   std_logic;  -- Y5
    X_12 : in    std_logic;  -- A5
    X_13 : out   std_logic;  -- Y6
    X_14 : in    std_logic;  -- A6
    X_15 : in    std_logic;  -- E2\
    X_16 : inout std_logic   -- Vcc
);
end component SN74LS365AN;

-----------------------------------------------------------------------
-- SN74LS366AN: Hex 3-state inverter buffer
-----------------------------------------------------------------------
component SN74LS366AN is
generic(
    tPLH : time := 16 ns;
    tPHL : time := 22 ns;
    tPZH : time := 24 ns;
    tPZL : time := 30 ns;
    tPHZ : time := 20 ns;
    tPLZ : time := 25 ns
);
port(
    X_1  : in    std_logic;  -- E1\
    X_2  : in    std_logic;  -- A1
    X_3  : out   std_logic;  -- Y1\
    X_4  : in    std_logic;  -- A2
    X_5  : out   std_logic;  -- Y2\
    X_6  : in    std_logic;  -- A3
    X_7  : out   std_logic;  -- Y3\
    X_8  : inout std_logic;  -- GND
    X_9  : out   std_logic;  -- Y4\
    X_10 : in    std_logic;  -- A4
    X_11 : out   std_logic;  -- Y5\
    X_12 : in    std_logic;  -- A5
    X_13 : out   std_logic;  -- Y6\
    X_14 : in    std_logic;  -- A6
    X_15 : in    std_logic;  -- E2\
    X_16 : inout std_logic   -- Vcc
);
end component SN74LS366AN;

-----------------------------------------------------------------------
-- SN74LS367AN: Hex 3-state buffer (2 & 4-bit sections)
-----------------------------------------------------------------------
component SN74LS367AN is
generic(
    tPLH : time := 16 ns;
    tPHL : time := 22 ns;
    tPZH : time := 24 ns;
    tPZL : time := 30 ns;
    tPHZ : time := 20 ns;
    tPLZ : time := 25 ns
);
port(
    X_1  : in    std_logic;  -- E14\
    X_2  : in    std_logic;  -- A1
    X_3  : out   std_logic;  -- Y1
    X_4  : in    std_logic;  -- A2
    X_5  : out   std_logic;  -- Y2
    X_6  : in    std_logic;  -- A3
    X_7  : out   std_logic;  -- Y3
    X_8  : inout std_logic;  -- GND
    X_9  : out   std_logic;  -- Y4
    X_10 : in    std_logic;  -- A4
    X_11 : out   std_logic;  -- Y5
    X_12 : in    std_logic;  -- A5
    X_13 : out   std_logic;  -- Y6
    X_14 : in    std_logic;  -- A6
    X_15 : in    std_logic;  -- E56\
    X_16 : inout std_logic   -- Vcc
);
end component SN74LS367AN;

-----------------------------------------------------------------------
-- SN74LS368AN: Hex 3-state inverter/buffer (2 & 4-bit sections)
-----------------------------------------------------------------------
component SN74LS368AN is
generic(
    tPLH : time := 16 ns;
    tPHL : time := 22 ns;
    tPZH : time := 24 ns;
    tPZL : time := 30 ns;
    tPHZ : time := 20 ns;
    tPLZ : time := 25 ns
);
port(
    X_1  : in    std_logic;  -- E14\
    X_2  : in    std_logic;  -- A1
    X_3  : out   std_logic;  -- Y1\
    X_4  : in    std_logic;  -- A2
    X_5  : out   std_logic;  -- Y2\
    X_6  : in    std_logic;  -- A3
    X_7  : out   std_logic;  -- Y3\
    X_8  : inout std_logic;  -- GND
    X_9  : out   std_logic;  -- Y4\
    X_10 : in    std_logic;  -- A4
    X_11 : out   std_logic;  -- Y5\
    X_12 : in    std_logic;  -- A5
    X_13 : out   std_logic;  -- Y6\
    X_14 : in    std_logic;  -- A6
    X_15 : in    std_logic;  -- E56\
    X_16 : inout std_logic   -- Vcc
);
end component SN74LS368AN;

-----------------------------------------------------------------------
-- SN74LS373N: Octal transparent latch (3-state outputs)
-----------------------------------------------------------------------
component SN74LS373N is
generic(
    tPLH : time := 18 ns;
    tPHL : time := 20 ns;
    tPZH : time := 28 ns;
    tPZL : time := 36 ns;
    tPHZ : time := 20 ns;
    tPLZ : time := 25 ns
);
port(
    X_1  : in    std_logic;  -- OE\
    X_2  : out   std_logic;  -- Q0
    X_3  : in    std_logic;  -- D0
    X_4  : in    std_logic;  -- D1
    X_5  : out   std_logic;  -- Q1
    X_6  : out   std_logic;  -- Q2
    X_7  : in    std_logic;  -- D2
    X_8  : in    std_logic;  -- D3
    X_9  : out   std_logic;  -- Q3
    X_10 : inout std_logic;  -- GND
    X_11 : in    std_logic;  -- LE
    X_12 : out   std_logic;  -- Q4
    X_13 : in    std_logic;  -- D4
    X_14 : in    std_logic;  -- D5
    X_15 : out   std_logic;  -- Q5
    X_16 : out   std_logic;  -- Q6
    X_17 : in    std_logic;  -- D6
    X_18 : in    std_logic;  -- D7
    X_19 : out   std_logic;  -- Q7
    X_20 : inout std_logic   -- Vcc
);
end component SN74LS373N;

-----------------------------------------------------------------------
-- SN74LS374N: Octal D-flipflop (3-state outputs)
-----------------------------------------------------------------------
component SN74LS374N is
generic(
    tPLH : time := 18 ns;
    tPHL : time := 20 ns;
    tPZH : time := 28 ns;
    tPZL : time := 36 ns;
    tPHZ : time := 20 ns;
    tPLZ : time := 25 ns
);
port(
    X_1  : in    std_logic;  -- OE\
    X_2  : out   std_logic;  -- Q0
    X_3  : in    std_logic;  -- D0
    X_4  : in    std_logic;  -- D1
    X_5  : out   std_logic;  -- Q1
    X_6  : out   std_logic;  -- Q2
    X_7  : in    std_logic;  -- D2
    X_8  : in    std_logic;  -- D3
    X_9  : out   std_logic;  -- Q3
    X_10 : inout std_logic;  -- GND
    X_11 : in    std_logic;  -- CP
    X_12 : out   std_logic;  -- Q4
    X_13 : in    std_logic;  -- D4
    X_14 : in    std_logic;  -- D5
    X_15 : out   std_logic;  -- Q5
    X_16 : out   std_logic;  -- Q6
    X_17 : in    std_logic;  -- D6
    X_18 : in    std_logic;  -- D7
    X_19 : out   std_logic;  -- Q7
    X_20 : inout std_logic   -- Vcc
);
end component SN74LS374N;

-----------------------------------------------------------------------
-- SN74LS375N: 4-bit latch
-----------------------------------------------------------------------
component SN74LS375N is
generic(
    tSETUP : time := 20 ns;     -- Setup time before clock
    tPLHCP : time := 40 ns;     -- Rising
    tPHLCP : time := 25 ns      -- Ralling
);
port(
    X_1  : in    std_logic;  -- D1
    X_2  : out   std_logic;  -- Q1\
    X_3  : out   std_logic;  -- Q1
    X_4  : in    std_logic;  -- E12
    X_5  : out   std_logic;  -- Q2
    X_6  : out   std_logic;  -- Q2\
    X_7  : in    std_logic;  -- D2
    X_8  : inout std_logic;  -- GND
    X_9  : in    std_logic;  -- D3
    X_10 : out   std_logic;  -- Q3\
    X_11 : out   std_logic;  -- Q3
    X_12 : in    std_logic;  -- E34
    X_13 : out   std_logic;  -- Q4
    X_14 : out   std_logic;  -- Q4\
    X_15 : in    std_logic;  -- D4
    X_16 : inout std_logic   -- Vcc
);
end component SN74LS375N;

-----------------------------------------------------------------------
-- SN74LS377N: Octal D-flipflop
-----------------------------------------------------------------------
component SN74LS377N is
generic(
    tPXX : time := 25 ns
);
port(
    X_1  : in    std_logic;  -- E\
    X_2  : out   std_logic;  -- Q0
    X_3  : in    std_logic;  -- D0
    X_4  : in    std_logic;  -- D1
    X_5  : out   std_logic;  -- Q1
    X_6  : out   std_logic;  -- Q2
    X_7  : in    std_logic;  -- D2
    X_8  : in    std_logic;  -- D3
    X_9  : out   std_logic;  -- Q3
    X_10 : inout std_logic;  -- GND
    X_11 : in    std_logic;  -- CP
    X_12 : out   std_logic;  -- Q4
    X_13 : in    std_logic;  -- D4
    X_14 : in    std_logic;  -- D5
    X_15 : out   std_logic;  -- Q5
    X_16 : out   std_logic;  -- Q6
    X_17 : in    std_logic;  -- D6
    X_18 : in    std_logic;  -- D7
    X_19 : out   std_logic;  -- Q7
    X_20 : inout std_logic   -- Vcc
);
end component SN74LS377N;

-----------------------------------------------------------------------
-- SN74LS378N: 6-bit D register
-----------------------------------------------------------------------
component SN74LS378N is
generic(
    tPXX : time := 27 ns
);
port(
    X_1  : in    std_logic;  -- E\
    X_2  : out   std_logic;  -- Q0
    X_3  : in    std_logic;  -- D0
    X_4  : in    std_logic;  -- D1
    X_5  : out   std_logic;  -- Q1
    X_6  : in    std_logic;  -- D2
    X_7  : out   std_logic;  -- Q2
    X_8  : inout std_logic;  -- GND
    X_9  : in    std_logic;  -- CP
    X_10 : out   std_logic;  -- Q3
    X_11 : in    std_logic;  -- D3
    X_12 : out   std_logic;  -- Q4
    X_13 : in    std_logic;  -- D4
    X_14 : in    std_logic;  -- D5
    X_15 : out   std_logic;  -- Q5
    X_16 : inout std_logic   -- Vcc
);
end component SN74LS378N;

-----------------------------------------------------------------------
-- SN74LS379N: 4-bit D register
-----------------------------------------------------------------------
component SN74LS379N is
generic(
    tPXX : time := 27 ns
);
port(
    X_1  : in    std_logic;  -- E\
    X_2  : out   std_logic;  -- Q0
    X_3  : out   std_logic;  -- Q0\
    X_4  : in    std_logic;  -- D0
    X_5  : in    std_logic;  -- D1
    X_6  : out   std_logic;  -- Q1\
    X_7  : out   std_logic;  -- Q1
    X_8  : inout std_logic;  -- GND
    X_9  : in    std_logic;  -- CP
    X_10 : out   std_logic;  -- Q2
    X_11 : out   std_logic;  -- Q2\
    X_12 : in    std_logic;  -- D2
    X_13 : in    std_logic;  -- D3
    X_14 : out   std_logic;  -- Q3\
    X_15 : out   std_logic;  -- Q3
    X_16 : inout std_logic   -- Vcc
);
end component SN74LS379N;

-- SN74LS381AN: Arithmetic/logic unit / function generator
-- SN74LS382AN: Arithmetic/logic unit / function generator
-- SN74LS384N: 8-bit serial/parallel 2's complement multiplier
-- SN74LS385N: Quad serial adder/subtractor

-----------------------------------------------------------------------
-- SN74LS386N: Quad 2-input XOR gate
-----------------------------------------------------------------------
component SN74LS386N is
generic(
    tPLH : time := 30 ns;
    tPHL : time := 22 ns
);
port(
    X_1  : in    std_logic;  -- 1A
    X_2  : in    std_logic;  -- 1B
    X_3  : out   std_logic;  -- 1Y\
    X_4  : out   std_logic;  -- 2Y\
    X_5  : in    std_logic;  -- 2A
    X_6  : in    std_logic;  -- 2B
    X_7  : inout std_logic;  -- GND
    X_8  : in    std_logic;  -- 3B
    X_9  : in    std_logic;  -- 3A
    X_10 : out   std_logic;  -- 3Y\
    X_11 : out   std_logic;  -- 4Y\
    X_12 : in    std_logic;  -- 4B
    X_13 : in    std_logic;  -- 4A
    X_14 : inout std_logic   -- Vcc 
);
end component SN74LS386N;

-----------------------------------------------------------------------
-- SN74LS390N: Dual decade counter
-----------------------------------------------------------------------
component SN74LS390N is
generic(
    tPLH0 : time := 15 ns;
    tPHL0 : time := 15 ns;
    tPLH1 : time := 21 ns;
    tPHL1 : time := 21 ns;
    tPLH2 : time := 30 ns;
    tPHL2 : time := 30 ns;
    tPLH3 : time := 21 ns;
    tPHL3 : time := 21 ns
);
port(
    X_1  : in    std_logic;  -- CPA0\
    X_2  : in    std_logic;  -- MRA
    X_3  : out   std_logic;  -- Q0A
    X_4  : in    std_logic;  -- CPA1\
    X_5  : out   std_logic;  -- Q1A
    X_6  : out   std_logic;  -- Q2A
    X_7  : out   std_logic;  -- Q3A
    X_8  : inout std_logic;  -- GND
    X_9  : out   std_logic;  -- Q3B
    X_10 : out   std_logic;  -- Q2B
    X_11 : out   std_logic;  -- Q1B
    X_12 : in    std_logic;  -- CPB1\
    X_13 : out   std_logic;  -- Q0B
    X_14 : in    std_logic;  -- MRB
    X_15 : in    std_logic;  -- CPB0\
    X_16 : inout std_logic   -- Vcc
);
end component SN74LS390N;

-----------------------------------------------------------------------
-- SN74LS393N: Dual 4-bit binary counter
-----------------------------------------------------------------------
component SN74LS393N is
generic(
    tPLH0 : time := 15 ns;
    tPHL0 : time := 15 ns;
    tPLH1 : time := 30 ns;
    tPHL1 : time := 30 ns;
    tPLH2 : time := 40 ns;
    tPHL2 : time := 40 ns;
    tPLH3 : time := 54 ns;
    tPHL3 : time := 54 ns
);
port(
    X_1  : in    std_logic;  -- CPA\
    X_2  : in    std_logic;  -- MRA
    X_3  : out   std_logic;  -- Q0A
    X_4  : out   std_logic;  -- Q1A
    X_5  : out   std_logic;  -- Q2A
    X_6  : out   std_logic;  -- Q3A
    X_7  : inout std_logic;  -- GND
    X_8  : out   std_logic;  -- Q3B
    X_9  : out   std_logic;  -- Q2B
    X_10 : out   std_logic;  -- Q1B
    X_11 : out   std_logic;  -- Q0B
    X_12 : in    std_logic;  -- MRB
    X_13 : in    std_logic;  -- CPB\
    X_14 : inout std_logic   -- Vcc
);
end component SN74LS393N;

-----------------------------------------------------------------------
-- SN74LS395N: 4-bit shift register (3-state outputs)
-----------------------------------------------------------------------
component SN74LS395N is
generic(
    tPLH : time := 35 ns;
    tPHL : time := 25 ns;
    tPZH : time := 20 ns;
    tPZL : time := 20 ns;
    tPHZ : time := 17 ns;
    tPLZ : time := 23 ns
);
port(
    X_1  : in    std_logic;  -- MR\
    X_2  : in    std_logic;  -- DS
    X_3  : in    std_logic;  -- P0
    X_4  : in    std_logic;  -- P1
    X_5  : in    std_logic;  -- P2
    X_6  : in    std_logic;  -- P3
    X_7  : in    std_logic;  -- S
    X_8  : inout std_logic;  -- GND
    X_9  : in    std_logic;  -- OE\
    X_10 : in    std_logic;  -- CP\
    X_11 : out   std_logic;  -- Q3
    X_12 : out   std_logic;  -- O3
    X_13 : out   std_logic;  -- O2
    X_14 : out   std_logic;  -- O1
    X_15 : out   std_logic;  -- O0
    X_16 : inout std_logic   -- Vcc
);
end component SN74LS395N;

-- SN74LS396N: Octal storage register
-- SN74LS398N: Quad 2-port register (registered multiplexer)
-- SN74LS399N: Quad 2-port register (registered multiplexer)
-- SN74LS422N: Retriggerable monostable multivibrator
-- SN74LS423N: Retriggerable monostable multivibrator
-- SN74LS445N: BCD-to-decimal decoder/driver
-- SN74LS447N: BCD to 7-segment decoder/driver
-- SN74LS465N: Octal buffer (3-state outputs)
-- SN74LS466N: Octal buffer (3-state outputs)
-- SN74LS467N: Octal buffer (3-state outputs)
-- SN74LS468N: Octal buffer (3-state outputs)

-----------------------------------------------------------------------
-- SN74LS490N: Dual decade counter
-----------------------------------------------------------------------
component SN74LS490N is
generic(
    tPLH0   : time := 15 ns;
    tPHL0   : time := 15 ns;
    tPLH1   : time := 30 ns;
    tPHL1   : time := 30 ns;
    tPLH2   : time := 45 ns;
    tPHL2   : time := 45 ns;
    tPLH3   : time := 35 ns;
    tPHL3   : time := 35 ns
);
port(
    X_1  : in    std_logic;  -- CPA\
    X_2  : in    std_logic;  -- MRA
    X_3  : out   std_logic;  -- Q0A
    X_4  : in    std_logic;  -- MSA
    X_5  : out   std_logic;  -- Q1A
    X_6  : out   std_logic;  -- Q2A
    X_7  : out   std_logic;  -- Q3A
    X_8  : inout std_logic;  -- GND
    X_9  : out   std_logic;  -- Q3B
    X_10 : out   std_logic;  -- Q2B
    X_11 : out   std_logic;  -- Q1B
    X_12 : in    std_logic;  -- MSB
    X_13 : out   std_logic;  -- Q0B
    X_14 : in    std_logic;  -- MRB
    X_15 : in    std_logic;  -- CPB\
    X_16 : inout std_logic   -- Vcc
);
end component SN74LS490N;

-- SN74LS502N: 8-bit successive approximation register
-- SN74LS503N: 8-bit successive approximation register
-- SN74LS504N: 12-bit successive approximation register

-----------------------------------------------------------------------
-- SN74LS533N: Octal transparent latch (3-state inverting outputs)
-----------------------------------------------------------------------
component SN74LS533N is
generic(
    tPLH : time := 23 ns;
    tPHL : time := 25 ns;
    tPZH : time := 28 ns;
    tPZL : time := 36 ns;
    tPHZ : time := 20 ns;
    tPLZ : time := 25 ns
);
port(
    X_1  : in    std_logic;  -- OE\
    X_2  : out   std_logic;  -- O0\
    X_3  : in    std_logic;  -- D0
    X_4  : in    std_logic;  -- D1
    X_5  : out   std_logic;  -- O1\
    X_6  : out   std_logic;  -- O2\
    X_7  : in    std_logic;  -- D2
    X_8  : in    std_logic;  -- D3
    X_9  : out   std_logic;  -- O3\
    X_10 : inout std_logic;  -- GND
    X_11 : in    std_logic;  -- LE
    X_12 : out   std_logic;  -- O4\
    X_13 : in    std_logic;  -- D4
    X_14 : in    std_logic;  -- D5
    X_15 : out   std_logic;  -- O5\
    X_16 : out   std_logic;  -- O6\
    X_17 : in    std_logic;  -- D6
    X_18 : in    std_logic;  -- D7
    X_19 : out   std_logic;  -- O7\
    X_20 : inout std_logic   -- Vcc
);
end component SN74LS533N;

-----------------------------------------------------------------------
-- SN74LS534N: Octal D-flipflop (3-state outputs)
-----------------------------------------------------------------------
component SN74LS534N is
generic(
    tPLH : time := 18 ns;
    tPHL : time := 20 ns;
    tPZH : time := 28 ns;
    tPZL : time := 36 ns;
    tPHZ : time := 20 ns;
    tPLZ : time := 25 ns
);
port(
    X_1  : in    std_logic;  -- OE\
    X_2  : out   std_logic;  -- O0\
    X_3  : in    std_logic;  -- D0
    X_4  : in    std_logic;  -- D1
    X_5  : out   std_logic;  -- O1\
    X_6  : out   std_logic;  -- O2\
    X_7  : in    std_logic;  -- D2
    X_8  : in    std_logic;  -- D3
    X_9  : out   std_logic;  -- O3\
    X_10 : inout std_logic;  -- GND
    X_11 : in    std_logic;  -- CP
    X_12 : out   std_logic;  -- O4\
    X_13 : in    std_logic;  -- D4
    X_14 : in    std_logic;  -- D5
    X_15 : out   std_logic;  -- O5\
    X_16 : out   std_logic;  -- O6\
    X_17 : in    std_logic;  -- D6
    X_18 : in    std_logic;  -- D7
    X_19 : out   std_logic;  -- O7\
    X_20 : inout std_logic   -- Vcc
);
end component SN74LS534N;

-----------------------------------------------------------------------
-- SN74LS540N: Octal buffer/line driver (inverting 3-state outputs)
-----------------------------------------------------------------------
component SN74LS540N is
generic(
    tPLH : time := 14 ns;
    tPHL : time := 18 ns;
    tPZH : time := 23 ns;
    tPZL : time := 30 ns;
    tPHZ : time := 25 ns;
    tPLZ : time := 18 ns
);
port(
    X_1  : in    std_logic;  -- E1\
    X_2  : in    std_logic;  -- A0
    X_3  : in    std_logic;  -- A1
    X_4  : in    std_logic;  -- A2
    X_5  : in    std_logic;  -- A3
    X_6  : in    std_logic;  -- A4
    X_7  : in    std_logic;  -- A5
    X_8  : in    std_logic;  -- A6
    X_9  : in    std_logic;  -- A7
    X_10 : inout std_logic;  -- GND
    X_11 : out   std_logic;  -- Y7\
    X_12 : out   std_logic;  -- Y6\
    X_13 : out   std_logic;  -- Y5\
    X_14 : out   std_logic;  -- Y4\
    X_15 : out   std_logic;  -- Y3\
    X_16 : out   std_logic;  -- Y2\
    X_17 : out   std_logic;  -- Y1\
    X_18 : out   std_logic;  -- Y0\
    X_19 : in    std_logic;  -- E2\
    X_20 : inout std_logic   -- Vcc
);
end component SN74LS540N;

-----------------------------------------------------------------------
-- SN74LS541N: Octal buffer/line driver (3-state outputs)
-----------------------------------------------------------------------
component SN74LS541N is
generic(
    tPLH : time := 14 ns;
    tPHL : time := 18 ns;
    tPZH : time := 23 ns;
    tPZL : time := 30 ns;
    tPHZ : time := 25 ns;
    tPLZ : time := 18 ns
);
port(
    X_1  : in    std_logic;  -- E1\
    X_2  : in    std_logic;  -- A0
    X_3  : in    std_logic;  -- A1
    X_4  : in    std_logic;  -- A2
    X_5  : in    std_logic;  -- A3
    X_6  : in    std_logic;  -- A4
    X_7  : in    std_logic;  -- A5
    X_8  : in    std_logic;  -- A6
    X_9  : in    std_logic;  -- A7
    X_10 : inout std_logic;  -- GND
    X_11 : out   std_logic;  -- Y7 
    X_12 : out   std_logic;  -- Y6 
    X_13 : out   std_logic;  -- Y5 
    X_14 : out   std_logic;  -- Y4 
    X_15 : out   std_logic;  -- Y3 
    X_16 : out   std_logic;  -- Y2 
    X_17 : out   std_logic;  -- Y1 
    X_18 : out   std_logic;  -- Y0 
    X_19 : in    std_logic;  -- E2\
    X_20 : inout std_logic   -- Vcc
);
end component SN74LS541N;

-----------------------------------------------------------------------
-- SN74LS563N: Octal D-type latch (3-state outputs)
-----------------------------------------------------------------------
component SN74LS563N is
generic(
    tPLH : time := 23 ns;
    tPHL : time := 25 ns;
    tPZH : time := 28 ns;
    tPZL : time := 36 ns;
    tPHZ : time := 20 ns;
    tPLZ : time := 25 ns
);
port(
    X_1  : in    std_logic;  -- OE\
    X_2  : in    std_logic;  -- D0
    X_3  : in    std_logic;  -- D1
    X_4  : in    std_logic;  -- D2
    X_5  : in    std_logic;  -- D3
    X_6  : in    std_logic;  -- D4
    X_7  : in    std_logic;  -- D5
    X_8  : in    std_logic;  -- D6
    X_9  : in    std_logic;  -- D7
    X_10 : inout std_logic;  -- GND
    X_11 : in    std_logic;  -- LE
    X_12 : out   std_logic;  -- O7\
    X_13 : out   std_logic;  -- O6\
    X_14 : out   std_logic;  -- O5\
    X_15 : out   std_logic;  -- O4\
    X_16 : out   std_logic;  -- O3\
    X_17 : out   std_logic;  -- O2\
    X_18 : out   std_logic;  -- O1\
    X_19 : out   std_logic;  -- O0\
    X_20 : inout std_logic   -- Vcc
);
end component SN74LS563N;

-----------------------------------------------------------------------
-- SN74LS564N: Octal D-flipflop (3-state outputs)
-----------------------------------------------------------------------
component SN74LS564N is
generic(
    tPLH : time := 18 ns;
    tPHL : time := 20 ns;
    tPZH : time := 28 ns;
    tPZL : time := 36 ns;
    tPHZ : time := 20 ns;
    tPLZ : time := 25 ns
);
port(
    X_1  : in    std_logic;  -- OE\
    X_2  : in    std_logic;  -- D0
    X_3  : in    std_logic;  -- D1
    X_4  : in    std_logic;  -- D2
    X_5  : in    std_logic;  -- D3
    X_6  : in    std_logic;  -- D4
    X_7  : in    std_logic;  -- D5
    X_8  : in    std_logic;  -- D6
    X_9  : in    std_logic;  -- D7
    X_10 : inout std_logic;  -- GND
    X_11 : in    std_logic;  -- CP
    X_12 : out   std_logic;  -- O7\
    X_13 : out   std_logic;  -- O6\
    X_14 : out   std_logic;  -- O5\
    X_15 : out   std_logic;  -- O4\
    X_16 : out   std_logic;  -- O3\
    X_17 : out   std_logic;  -- O2\
    X_18 : out   std_logic;  -- O1\
    X_19 : out   std_logic;  -- O0\
    X_20 : inout std_logic   -- Vcc
);
end component SN74LS564N;

-- SN74LS568N: BCD decade up/down counter (3-state outputs)
-- SN74LS569N: 4-bit binary up/down counter (3-state outputs)

-----------------------------------------------------------------------
-- SN74LS573N: Octal D-type latch (3-state outputs)
-----------------------------------------------------------------------
component SN74LS573N is
generic(
    tPLH : time := 18 ns;
    tPHL : time := 20 ns;
    tPZH : time := 28 ns;
    tPZL : time := 36 ns;
    tPHZ : time := 20 ns;
    tPLZ : time := 25 ns
);
port(
    X_1  : in    std_logic;  -- OE\
    X_2  : in    std_logic;  -- D0
    X_3  : in    std_logic;  -- D1
    X_4  : in    std_logic;  -- D2
    X_5  : in    std_logic;  -- D3
    X_6  : in    std_logic;  -- D4
    X_7  : in    std_logic;  -- D5
    X_8  : in    std_logic;  -- D6
    X_9  : in    std_logic;  -- D7
    X_10 : inout std_logic;  -- GND
    X_11 : in    std_logic;  -- LE
    X_12 : out   std_logic;  -- O7\
    X_13 : out   std_logic;  -- O6\
    X_14 : out   std_logic;  -- O5\
    X_15 : out   std_logic;  -- O4\
    X_16 : out   std_logic;  -- O3\
    X_17 : out   std_logic;  -- O2\
    X_18 : out   std_logic;  -- O1\
    X_19 : out   std_logic;  -- O0\
    X_20 : inout std_logic   -- Vcc
);
end component SN74LS573N;

-----------------------------------------------------------------------
-- SN74LS574N: Octal D-flipflop (3-state outputs)
-----------------------------------------------------------------------
component SN74LS574N is
generic(
    tPLH : time := 18 ns;
    tPHL : time := 20 ns;
    tPZH : time := 28 ns;
    tPZL : time := 36 ns;
    tPHZ : time := 20 ns;
    tPLZ : time := 25 ns
);
port(
    X_1  : in    std_logic;  -- OE\
    X_2  : in    std_logic;  -- D0
    X_3  : in    std_logic;  -- D1
    X_4  : in    std_logic;  -- D2
    X_5  : in    std_logic;  -- D3
    X_6  : in    std_logic;  -- D4
    X_7  : in    std_logic;  -- D5
    X_8  : in    std_logic;  -- D6
    X_9  : in    std_logic;  -- D7
    X_10 : inout std_logic;  -- GND
    X_11 : in    std_logic;  -- CP
    X_12 : out   std_logic;  -- O7\
    X_13 : out   std_logic;  -- O6\
    X_14 : out   std_logic;  -- O5\
    X_15 : out   std_logic;  -- O4\
    X_16 : out   std_logic;  -- O3\
    X_17 : out   std_logic;  -- O2\
    X_18 : out   std_logic;  -- O1\
    X_19 : out   std_logic;  -- O0\
    X_20 : inout std_logic   -- Vcc
);
end component SN74LS574N;

-- SN74LS590N: 8-bit binary counter with output registers
-- SN74LS591N: 8-bit binary counter with output registers
-- SN74LS592N: 8-bit binary counter with input registers
-- SN74LS593N: 8-bit binary counter with input registers
-- SN74LS595N: 8-bit shift register with output latch
-- SN74LS596N: 8-bit shift register with output latch
-- SN74LS597N: 8-bit shift register with input latch
-- SN74LS598N: 8-bit shift register with input latch
-- SN74LS599N: 8-bit shift register with output latches
-- SN74LS604N: Octal 2-input multiplexed latch
-- SN74LS606N: Octal 2-input multiplexed latch
-- SN74LS607N: Octal 2-input multiplexed latch
-- SN74LS646N: Octal bus transceivers & registers
-- SN74LS668N: Synchronous 4-bit up/down decade counter
-- SN74LS669N: Synchronous 4-bit up/down binary counter

-----------------------------------------------------------------------
-- SN74LS670N: 4 x 4 register file (3-state outputs)
-----------------------------------------------------------------------
component SN74LS670N is
generic(
    tPLC  : time     := 35 ns;
    tPLA  : time     := 35 ns;
    tSUD  : time     := 10 ns;
    tSUA  : time     := 10 ns
);        
port(     
    X_1   : in    std_logic;  -- D2
    X_2   : in    std_logic;  -- D3
    X_3   : in    std_logic;  -- D4
    X_4   : in    std_logic;  -- RA1
    X_5   : in    std_logic;  -- RA0
    X_6   : out   std_logic;  -- O4
    X_7   : out   std_logic;  -- O3
    X_8   : inout std_logic;  -- GND
    X_9   : out   std_logic;  -- O2
    X_10  : out   std_logic;  -- O1
    X_11  : in    std_logic;  -- OE\
    X_12  : in    std_logic;  -- WE\
    X_13  : in    std_logic;  -- WA1
    X_14  : in    std_logic;  -- WA0
    X_15  : in    std_logic;  -- D1
    X_16  : inout std_logic   -- Vcc
);
end component SN74LS670N;

-- SN74LS671N: 4-bit universal shift register/latch (3-state output)
-- SN74LS672N: 4-bit universal shift register/latch (3-state output)
-- SN74LS673N: 16-bit shift register
-- SN74LS674N: 16-bit shift register
-- SN74LS681N: 4-bit parallel binary accumulator
-- SN74LS682N: 8-bit magnitude/identity comparator
-- SN74LS684N: 8-bit magnitude/identity comparator
-- SN74LS685N: 8-bit magnitude/identity comparator
-- SN74LS686N: 8-bit magnitude/identity comparator
-- SN74LS687N: 8-bit magnitude/identity comparator
-- SN74LS688N: 8-bit magnitude/identity comparator
-- SN74LS690N: Synchronous counter with output registers & muliplexed 3-state outputs
-- SN74LS691N: Synchronous counter with output registers & muliplexed 3-state outputs
-- SN74LS693N: Synchronous counter with output registers & muliplexed 3-state outputs
-- SN74LS696N: Synchronous up/down counter with output registers & muliplexed 3-state outputs
-- SN74LS697N: Synchronous up/down counter with output registers & muliplexed 3-state outputs
-- SN74LS699N: Synchronous up/down counter with output registers & muliplexed 3-state outputs

end package LSTTL;
