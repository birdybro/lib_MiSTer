-----------------------------------------------------------------------
-- Bipolar TTL models (VHDL)                                         --
-- David R Brooks                                                    --
-- May, 2016.  Perth, Australia                                      --
-- Compliance: VHDL 2008                                             --
-- NB Simulation only: they are not synthesizable.                   --
-- Based on: Fairchild TTL Data Book (see for pinouts)               --
--           Signetics Low-Power Schottky Pocket Guide, 1978         --
-- Part names are in Texas format, ie SN74LSxxN                      --
-- The LS part is given when available, else the basic 74 part.      --
-- Pinouts & naming agree with Altium libraries & VHDL netlister.    --
-----------------------------------------------------------------------

-----------------------------------------------------------------------
-- SN74LS00N: Quad 2-input NAND gate (Pinout A)
--            Verified 28/05/2016
-----------------------------------------------------------------------
library ieee;
    use ieee.std_logic_1164.all;

    use work.LSTTL.all;
    use work.TTLPrivate.all;

entity SN74LS00N is
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
end entity SN74LS00N;

architecture BEHAV of SN74LS00N is
    signal A : TTLInputs (1 to 4, 1 to 2);
    signal Y : TTLOutputs(1 to 4);
  
begin
    A <= ( (X_1, X_2), (X_4, X_5), (X_9, X_10), (X_12, X_13) );
    
    (X_3, X_6, X_8, X_11) <= Y;
  
    G: TTLgate
    generic map(
        mode   => Zand,     -- Zand, Zor, Zxor, Zbuf
        invert => '1',      -- '1' will invert the output
        ohigh  => '1',      -- '1' = normal, 'Z' = open collectors
        tPLH   => tPLH,
        tPHL   => tPHL
    )
    port map(
        ins   => A,
        outs  => Y
    );
  
end architecture BEHAV;

-----------------------------------------------------------------------
-- SN7401N: Quad 2-input NAND gate (open collector) (Pinout A)
--          Verified 29/05/2016
-----------------------------------------------------------------------
library ieee;
    use ieee.std_logic_1164.all;

    use work.LSTTL.all;
    use work.TTLPrivate.all;

entity SN7401N is
generic(
    tPLH : time := 45 ns;
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
end entity SN7401N;

architecture BEHAV of SN7401N is
    signal A : TTLInputs (1 to 4, 1 to 2);
    signal Y : TTLOutputs(1 to 4);
  
begin
    A <= ( (X_2, X_3), (X_5, X_6), (X_8, X_9), (X_11, X_12) );
    
    (X_1, X_4, X_10, X_13) <= Y;
  
    G: TTLgate
    generic map(
        mode   => Zand,     -- Zand, Zor, Zxor, Zbuf
        invert => '1',      -- '1' will invert the output
        ohigh  => 'Z',      -- '1' = normal, 'Z' = open collectors
        tPLH   => tPLH,
        tPHL   => tPHL
    )
    port map(
        ins   => A,
        outs  => Y
    );
  
end architecture BEHAV;

-----------------------------------------------------------------------
-- SN74LS02N: Quad 2-input NOR gate (Pinout A)
--            Verified 29/05/2016
-----------------------------------------------------------------------
library ieee;
    use ieee.std_logic_1164.all;

    use work.LSTTL.all;
    use work.TTLPrivate.all;

entity SN74LS02N is
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
end entity SN74LS02N;

architecture BEHAV of SN74LS02N is
    signal A : TTLInputs (1 to 4, 1 to 2);
    signal Y : TTLOutputs(1 to 4);
  
begin
    A <= ( (X_2, X_3), (X_5, X_6), (X_8, X_9), (X_11, X_12) );
    
    (X_1, X_4, X_10, X_13) <= Y;
  
    G: TTLgate
    generic map(
        mode   => Zor,      -- Zand, Zor, Zxor, Zbuf
        invert => '1',      -- '1' will invert the output
        ohigh  => '1',      -- '1' = normal, 'Z' = open collectors
        tPLH   => tPLH,
        tPHL   => tPHL
    )
    port map(
        ins   => A,
        outs  => Y
    );
  
end architecture BEHAV;

-----------------------------------------------------------------------
-- SN74LS03N: Quad 2-input NAND gate (open collector)
--            Verified 28/05/2016
-----------------------------------------------------------------------
library ieee;
    use ieee.std_logic_1164.all;

    use work.LSTTL.all;
    use work.TTLPrivate.all;

entity SN74LS03N is
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
end entity SN74LS03N;

architecture BEHAV of SN74LS03N is
    signal A : TTLInputs (1 to 4, 1 to 2);
    signal Y : TTLOutputs(1 to 4);
  
begin
    A <= ( (X_1, X_2), (X_4, X_5), (X_9, X_10), (X_12, X_13) );
    
    (X_3, X_6, X_8, X_11) <= Y;
  
    G: TTLgate
    generic map(
        mode   => Zand,     -- Zand, Zor, Zxor, Zbuf
        invert => '1',      -- '1' will invert the output
        ohigh  => 'Z',      -- '1' = normal, 'Z' = open collectors
        tPLH   => tPLH,
        tPHL   => tPHL
    )
    port map(
        ins   => A,
        outs  => Y
    );
  
end architecture BEHAV;

-----------------------------------------------------------------------
-- SN74LS04N: Hex inverter (Pinout A)
--            Verified 30/05/2016
-----------------------------------------------------------------------
library ieee;
    use ieee.std_logic_1164.all;

    use work.LSTTL.all;
    use work.TTLPrivate.all;

entity SN74LS04N is
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
end entity SN74LS04N;

architecture BEHAV of SN74LS04N is
    signal A : TTLInputs (1 to 6, 1 to 1);
    signal Y : TTLOutputs(1 to 6);
  
begin
    A(1,1) <= X_1;      -- Can't use aggregates when the substring has only 1 element
    A(2,1) <= X_3;
    A(3,1) <= X_5;
    A(4,1) <= X_9;
    A(5,1) <= X_11;
    A(6,1) <= X_13;
    
    (X_2, X_4, X_6, X_8, X_10, X_12) <= Y;
  
    G: TTLgate
    generic map(
        mode   => Zbuf,     -- Zand, Zor, Zxor, Zbuf
        invert => '1',      -- '1' will invert the output
        ohigh  => '1',      -- '1' = normal, 'Z' = open collectors
        tPLH   => tPLH,
        tPHL   => tPHL
    )
    port map(
        ins   => A,
        outs  => Y
    );
  
end architecture BEHAV;

-----------------------------------------------------------------------
-- SN74LS05N: Hex inverter (open collector) (Pinout A)
--            Verified 30/05/2016
-----------------------------------------------------------------------
library ieee;
    use ieee.std_logic_1164.all;

    use work.LSTTL.all;
    use work.TTLPrivate.all;

entity SN74LS05N is
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
end entity SN74LS05N;

architecture BEHAV of SN74LS05N is
    signal A : TTLInputs (1 to 6, 1 to 1);
    signal Y : TTLOutputs(1 to 6);
  
begin
    A(1,1) <= X_1;      -- Can't use aggregates when the substring has only 1 element
    A(2,1) <= X_3;
    A(3,1) <= X_5;
    A(4,1) <= X_9;
    A(5,1) <= X_11;
    A(6,1) <= X_13;
    
    (X_2, X_4, X_6, X_8, X_10, X_12) <= Y;
  
    G: TTLgate
    generic map(
        mode   => Zbuf,     -- Zand, Zor, Zxor, Zbuf
        invert => '1',      -- '1' will invert the output
        ohigh  => 'Z',      -- '1' = normal, 'Z' = open collectors
        tPLH   => tPLH,
        tPHL   => tPHL
    )
    port map(
        ins   => A,
        outs  => Y
    );
  
end architecture BEHAV;

-----------------------------------------------------------------------
-- SN7406N: Hex inverter (high voltage open collector)
--          Verified 30/05/2016
-----------------------------------------------------------------------
library ieee;
    use ieee.std_logic_1164.all;

    use work.LSTTL.all;
    use work.TTLPrivate.all;

entity SN7406N is
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
end entity SN7406N;

architecture BEHAV of SN7406N is
    signal A : TTLInputs (1 to 6, 1 to 1);
    signal Y : TTLOutputs(1 to 6);
  
begin
    A(1,1) <= X_1;      -- Can't use aggregates when the substring has only 1 element
    A(2,1) <= X_3;
    A(3,1) <= X_5;
    A(4,1) <= X_9;
    A(5,1) <= X_11;
    A(6,1) <= X_13;
    
    (X_2, X_4, X_6, X_8, X_10, X_12) <= Y;
  
    G: TTLgate
    generic map(
        mode   => Zbuf,     -- Zand, Zor, Zxor, Zbuf
        invert => '1',      -- '1' will invert the output
        ohigh  => 'Z',      -- '1' = normal, 'Z' = open collectors
        tPLH   => tPLH,
        tPHL   => tPHL
    )
    port map(
        ins   => A,
        outs  => Y
    );
  
end architecture BEHAV;

-----------------------------------------------------------------------
-- SN7407N: Hex buffer (high voltage open collector)
--          Verified 30/05/2016
-----------------------------------------------------------------------
library ieee;
    use ieee.std_logic_1164.all;

    use work.LSTTL.all;
    use work.TTLPrivate.all;

entity SN7407N is
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
end entity SN7407N;

architecture BEHAV of SN7407N is
    signal A : TTLInputs (1 to 6, 1 to 1);
    signal Y : TTLOutputs(1 to 6);
  
begin
    A(1,1) <= X_1;      -- Can't use aggregates when the substring has only 1 element
    A(2,1) <= X_3;
    A(3,1) <= X_5;
    A(4,1) <= X_9;
    A(5,1) <= X_11;
    A(6,1) <= X_13;
    
    (X_2, X_4, X_6, X_8, X_10, X_12) <= Y;
  
    G: TTLgate
    generic map(
        mode   => Zbuf,     -- Zand, Zor, Zxor, Zbuf
        invert => '0',      -- '1' will invert the output
        ohigh  => 'Z',      -- '1' = normal, 'Z' = open collectors
        tPLH   => tPLH,
        tPHL   => tPHL
    )
    port map(
        ins   => A,
        outs  => Y
    );
  
end architecture BEHAV;

-----------------------------------------------------------------------
-- SN74LS08N: Quad 2-input and gate (Pinout A)
--            Verified 28/05/2016
-----------------------------------------------------------------------
library ieee;
    use ieee.std_logic_1164.all;

    use work.LSTTL.all;
    use work.TTLPrivate.all;

entity SN74LS08N is
generic(
    tPLH : time := 15 ns;
    tPHL : time := 20 ns
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
end entity SN74LS08N;

architecture BEHAV of SN74LS08N is
    signal A : TTLInputs (1 to 4, 1 to 2);
    signal Y : TTLOutputs(1 to 4);
  
begin
    A <= ( (X_1, X_2), (X_4, X_5), (X_9, X_10), (X_12, X_13) );
    
    (X_3, X_6, X_8, X_11) <= Y;
  
    G: TTLgate
    generic map(
        mode   => Zand,     -- Zand, Zor, Zxor, Zbuf
        invert => '0',      -- '1' will invert the output
        ohigh  => '1',      -- '1' = normal, 'Z' = open collectors
        tPLH   => tPLH,
        tPHL   => tPHL
    )
    port map(
        ins   => A,
        outs  => Y
    );
  
end architecture BEHAV;

-----------------------------------------------------------------------
-- SN74LS09N: Quad 2-input and gate (open collector)
--            Verified 28/05/2016
-----------------------------------------------------------------------
library ieee;
    use ieee.std_logic_1164.all;

    use work.LSTTL.all;
    use work.TTLPrivate.all;

entity SN74LS09N is
generic(
    tPLH : time := 35 ns;
    tPHL : time := 35 ns
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
end entity SN74LS09N;

architecture BEHAV of SN74LS09N is
    signal A : TTLInputs (1 to 4, 1 to 2);
    signal Y : TTLOutputs(1 to 4);
  
begin
    A <= ( (X_1, X_2), (X_4, X_5), (X_9, X_10), (X_12, X_13) );
    
    (X_3, X_6, X_8, X_11) <= Y;
  
    G: TTLgate
    generic map(
        mode   => Zand,     -- Zand, Zor, Zxor, Zbuf
        invert => '0',      -- '1' will invert the output
        ohigh  => 'Z',      -- '1' = normal, 'Z' = open collectors
        tPLH   => tPLH,
        tPHL   => tPHL
    )
    port map(
        ins   => A,
        outs  => Y
    );
  
end architecture BEHAV;

-----------------------------------------------------------------------
-- SN74LS10N: Triple 3-input NAND gate (Pinout A)
--            Verified 30/05/2016
-----------------------------------------------------------------------
library ieee;
    use ieee.std_logic_1164.all;

    use work.LSTTL.all;
    use work.TTLPrivate.all;

entity SN74LS10N is
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
end entity SN74LS10N;

architecture BEHAV of SN74LS10N is
    signal A : TTLInputs (1 to 3, 1 to 3);
    signal Y : TTLOutputs(1 to 3);
  
begin
    A <= ( (X_1, X_2, X_13), (X_3, X_4, X_5), (X_9, X_10, X_11) );
    
    (X_12, X_6, X_8) <= Y;
  
    G: TTLgate
    generic map(
        mode   => Zand,     -- Zand, Zor, Zxor, Zbuf
        invert => '1',      -- '1' will invert the output
        ohigh  => '1',      -- '1' = normal, 'Z' = open collectors
        tPLH   => tPLH,
        tPHL   => tPHL
    )
    port map(
        ins   => A,
        outs  => Y
    );

end architecture BEHAV;

-----------------------------------------------------------------------
-- SN74LS11N: Triple 3-input and gate (Pinout A)
--            Verified 30/05/2016
-----------------------------------------------------------------------
library ieee;
    use ieee.std_logic_1164.all;

    use work.LSTTL.all;
    use work.TTLPrivate.all;

entity SN74LS11N is
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
end entity SN74LS11N;

architecture BEHAV of SN74LS11N is
    signal A : TTLInputs (1 to 3, 1 to 3);
    signal Y : TTLOutputs(1 to 3);
  
begin
    A <= ( (X_1, X_2, X_13), (X_3, X_4, X_5), (X_9, X_10, X_11) );
    
    (X_12, X_6, X_8) <= Y;
  
    G: TTLgate
    generic map(
        mode   => Zand,     -- Zand, Zor, Zxor, Zbuf
        invert => '0',      -- '1' will invert the output
        ohigh  => '1',      -- '1' = normal, 'Z' = open collectors
        tPLH   => tPLH,
        tPHL   => tPHL
    )
    port map(
        ins   => A,
        outs  => Y
    );

end architecture BEHAV;

-----------------------------------------------------------------------
-- SN74LS12N: Triple 3-input NAND gate (open collector)
--            Verified 30/05/2016
-----------------------------------------------------------------------
library ieee;
    use ieee.std_logic_1164.all;

    use work.LSTTL.all;
    use work.TTLPrivate.all;

entity SN74LS12N is
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
end entity SN74LS12N;

architecture BEHAV of SN74LS12N is
    signal A : TTLInputs (1 to 3, 1 to 3);
    signal Y : TTLOutputs(1 to 3);
  
begin
    A <= ( (X_1, X_2, X_13), (X_3, X_4, X_5), (X_9, X_10, X_11) );
    
    (X_12, X_6, X_8) <= Y;
  
    G: TTLgate
    generic map(
        mode   => Zand,     -- Zand, Zor, Zxor, Zbuf
        invert => '1',      -- '1' will invert the output
        ohigh  => 'Z',      -- '1' = normal, 'Z' = open collectors
        tPLH   => tPLH,
        tPHL   => tPHL
    )
    port map(
        ins   => A,
        outs  => Y
    );

end architecture BEHAV;

-----------------------------------------------------------------------
-- SN74LS13N: Dual 4-input NAND Schmitt trigger
--            Verified 30/05/2016
-----------------------------------------------------------------------
library ieee;
    use ieee.std_logic_1164.all;

    use work.LSTTL.all;
    use work.TTLPrivate.all;

entity SN74LS13N is
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
end entity SN74LS13N;

architecture BEHAV of SN74LS13N is
    signal A : TTLInputs (1 to 2, 1 to 4);
    signal Y : TTLOutputs(1 to 2);
  
begin
    A <= ( (X_1, X_2, X_4, X_5), (X_9, X_10, X_12, X_13) );
    
    (X_6, X_8) <= Y;
  
    G: TTLgate
    generic map(
        mode   => Zand,     -- Zand, Zor, Zxor, Zbuf
        invert => '1',      -- '1' will invert the output
        ohigh  => '1',      -- '1' = normal, 'Z' = open collectors
        tPLH   => tPLH,
        tPHL   => tPHL
    )
    port map(
        ins   => A,
        outs  => Y
    );

end architecture BEHAV;

-----------------------------------------------------------------------
-- SN74LS14N: Hex Schmitt trigger inverter
--            Verified 30/05/2016
-----------------------------------------------------------------------
library ieee;
    use ieee.std_logic_1164.all;

    use work.LSTTL.all;
    use work.TTLPrivate.all;

entity SN74LS14N is
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
end entity SN74LS14N;

architecture BEHAV of SN74LS14N is
    signal A : TTLInputs (1 to 6, 1 to 1);
    signal Y : TTLOutputs(1 to 6);
  
begin
    A(1,1) <= X_1;      -- Can't use aggregates when the substring has only 1 element
    A(2,1) <= X_3;
    A(3,1) <= X_5;
    A(4,1) <= X_9;
    A(5,1) <= X_11;
    A(6,1) <= X_13;
    
    (X_2, X_4, X_6, X_8, X_10, X_12) <= Y;
  
    G: TTLgate
    generic map(
        mode   => Zbuf,     -- Zand, Zor, Zxor, Zbuf
        invert => '1',      -- '1' will invert the output
        ohigh  => '1',      -- '1' = normal, 'Z' = open collectors
        tPLH   => tPLH,
        tPHL   => tPHL
    )
    port map(
        ins   => A,
        outs  => Y
    );
  
end architecture BEHAV;

-----------------------------------------------------------------------
-- SN74LS15N: Triple 3-input and gate (open collector)
--            Verified 30/05/2016
-----------------------------------------------------------------------
library ieee;
    use ieee.std_logic_1164.all;

    use work.LSTTL.all;
    use work.TTLPrivate.all;

entity SN74LS15N is
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
end entity SN74LS15N;

architecture BEHAV of SN74LS15N is
    signal A : TTLInputs (1 to 3, 1 to 3);
    signal Y : TTLOutputs(1 to 3);
  
begin
    A <= ( (X_1, X_2, X_13), (X_3, X_4, X_5), (X_9, X_10, X_11) );
    
    (X_12, X_6, X_8) <= Y;
  
    G: TTLgate
    generic map(
        mode   => Zand,     -- Zand, Zor, Zxor, Zbuf
        invert => '0',      -- '1' will invert the output
        ohigh  => 'Z',      -- '1' = normal, 'Z' = open collectors
        tPLH   => tPLH,
        tPHL   => tPHL
    )
    port map(
        ins   => A,
        outs  => Y
    );

end architecture BEHAV;

-----------------------------------------------------------------------
-- SN7416N: Hex inverter/driver (high voltage open collector)
--          Verified 30/05/2016
-----------------------------------------------------------------------
library ieee;
    use ieee.std_logic_1164.all;

    use work.LSTTL.all;
    use work.TTLPrivate.all;

entity SN7416N is
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
end entity SN7416N;

architecture BEHAV of SN7416N is
    signal A : TTLInputs (1 to 6, 1 to 1);
    signal Y : TTLOutputs(1 to 6);
  
begin
    A(1,1) <= X_1;      -- Can't use aggregates when the substring has only 1 element
    A(2,1) <= X_3;
    A(3,1) <= X_5;
    A(4,1) <= X_9;
    A(5,1) <= X_11;
    A(6,1) <= X_13;
    
    (X_2, X_4, X_6, X_8, X_10, X_12) <= Y;
  
    G: TTLgate
    generic map(
        mode   => Zbuf,     -- Zand, Zor, Zxor, Zbuf
        invert => '1',      -- '1' will invert the output
        ohigh  => 'Z',      -- '1' = normal, 'Z' = open collectors
        tPLH   => tPLH,
        tPHL   => tPHL
    )
    port map(
        ins   => A,
        outs  => Y
    );
  
end architecture BEHAV;

-----------------------------------------------------------------------
-- SN7417N: Hex buffer/driver (high voltage open collector)
--          Verified 30/05/2016
-----------------------------------------------------------------------
library ieee;
    use ieee.std_logic_1164.all;

    use work.LSTTL.all;
    use work.TTLPrivate.all;

entity SN7417N is
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
end entity SN7417N;

architecture BEHAV of SN7417N is
    signal A : TTLInputs (1 to 6, 1 to 1);
    signal Y : TTLOutputs(1 to 6);
  
begin
    A(1,1) <= X_1;      -- Can't use aggregates when the substring has only 1 element
    A(2,1) <= X_3;
    A(3,1) <= X_5;
    A(4,1) <= X_9;
    A(5,1) <= X_11;
    A(6,1) <= X_13;
    
    (X_2, X_4, X_6, X_8, X_10, X_12) <= Y;
  
    G: TTLgate
    generic map(
        mode   => Zbuf,     -- Zand, Zor, Zxor, Zbuf
        invert => '0',      -- '1' will invert the output
        ohigh  => 'Z',      -- '1' = normal, 'Z' = open collectors
        tPLH   => tPLH,
        tPHL   => tPHL
    )
    port map(
        ins   => A,
        outs  => Y
    );
  
end architecture BEHAV;

-----------------------------------------------------------------------
-- SN74LS20N: Dual 4-input NAND gate (Pinout A)
--            Verified 30/05/2016
-----------------------------------------------------------------------
library ieee;
    use ieee.std_logic_1164.all;

    use work.LSTTL.all;
    use work.TTLPrivate.all;

entity SN74LS20N is
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
end entity SN74LS20N;

architecture BEHAV of SN74LS20N is
    signal A : TTLInputs (1 to 2, 1 to 4);
    signal Y : TTLOutputs(1 to 2);
  
begin
    A <= ( (X_1, X_2, X_4, X_5), (X_9, X_10, X_12, X_13) );
    
    (X_6, X_8) <= Y;
  
    G: TTLgate
    generic map(
        mode   => Zand,     -- Zand, Zor, Zxor, Zbuf
        invert => '1',      -- '1' will invert the output
        ohigh  => '1',      -- '1' = normal, 'Z' = open collectors
        tPLH   => tPLH,
        tPHL   => tPHL
    )
    port map(
        ins   => A,
        outs  => Y
    );

end architecture BEHAV;

-----------------------------------------------------------------------
-- SN74LS21N: Dual 4-input and gate (Pinout A)
--            Verified 30/05/2016
-----------------------------------------------------------------------
library ieee;
    use ieee.std_logic_1164.all;

    use work.LSTTL.all;
    use work.TTLPrivate.all;

entity SN74LS21N is
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
end entity SN74LS21N;

architecture BEHAV of SN74LS21N is
    signal A : TTLInputs (1 to 2, 1 to 4);
    signal Y : TTLOutputs(1 to 2);
  
begin
    A <= ( (X_1, X_2, X_4, X_5), (X_9, X_10, X_12, X_13) );
    
    (X_6, X_8) <= Y;
  
    G: TTLgate
    generic map(
        mode   => Zand,     -- Zand, Zor, Zxor, Zbuf
        invert => '0',      -- '1' will invert the output
        ohigh  => '1',      -- '1' = normal, 'Z' = open collectors
        tPLH   => tPLH,
        tPHL   => tPHL
    )
    port map(
        ins   => A,
        outs  => Y
    );

end architecture BEHAV;

-----------------------------------------------------------------------
-- SN74LS22N: Dual 4-input NAND gate (open collector) (Pinout A)
--            Verified 30/05/2016
-----------------------------------------------------------------------
library ieee;
    use ieee.std_logic_1164.all;

    use work.LSTTL.all;
    use work.TTLPrivate.all;

entity SN74LS22N is
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
end entity SN74LS22N;

architecture BEHAV of SN74LS22N is
    signal A : TTLInputs (1 to 2, 1 to 4);
    signal Y : TTLOutputs(1 to 2);
  
begin
    A <= ( (X_1, X_2, X_4, X_5), (X_9, X_10, X_12, X_13) );
    
    (X_6, X_8) <= Y;
  
    G: TTLgate
    generic map(
        mode   => Zand,     -- Zand, Zor, Zxor, Zbuf
        invert => '1',      -- '1' will invert the output
        ohigh  => 'Z',      -- '1' = normal, 'Z' = open collectors
        tPLH   => tPLH,
        tPHL   => tPHL
    )
    port map(
        ins   => A,
        outs  => Y
    );

end architecture BEHAV;

-- SN7423N: Expandable dual 4-input NOR gate (with strobe)
-- SN7425N: Dual 4-input NOR gate (with strobe)

-----------------------------------------------------------------------
-- SN74LS26N: Quad 2-input NAND buffer (open collector)
--            Verified 29/05/2016
-----------------------------------------------------------------------
library ieee;
    use ieee.std_logic_1164.all;

    use work.LSTTL.all;
    use work.TTLPrivate.all;

entity SN74LS26N is
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
end entity SN74LS26N;

architecture BEHAV of SN74LS26N is
    signal A : TTLInputs (1 to 4, 1 to 2);
    signal Y : TTLOutputs(1 to 4);
  
begin
    A <= ( (X_1, X_2), (X_4, X_5), (X_9, X_10), (X_12, X_13) );
    
    (X_3, X_6, X_8, X_11) <= Y;
  
    G: TTLgate
    generic map(
        mode   => Zand,     -- Zand, Zor, Zxor, Zbuf
        invert => '1',      -- '1' will invert the output
        ohigh  => 'Z',      -- '1' = normal, 'Z' = open collectors
        tPLH   => tPLH,
        tPHL   => tPHL
    )
    port map(
        ins   => A,
        outs  => Y
    );
  
end architecture BEHAV;

-----------------------------------------------------------------------
-- SN74LS27N: Triple 3-input NOR gate
--            Verified 30/05/2016
-----------------------------------------------------------------------
library ieee;
    use ieee.std_logic_1164.all;

    use work.LSTTL.all;
    use work.TTLPrivate.all;

entity SN74LS27N is
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
end entity SN74LS27N;

architecture BEHAV of SN74LS27N is
    signal A : TTLInputs (1 to 3, 1 to 3);
    signal Y : TTLOutputs(1 to 3);
  
begin
    A <= ( (X_1, X_2, X_13), (X_3, X_4, X_5), (X_9, X_10, X_11) );
    
    (X_12, X_6, X_8) <= Y;
  
    G: TTLgate
    generic map(
        mode   => Zor,      -- Zand, Zor, Zxor, Zbuf
        invert => '1',      -- '1' will invert the output
        ohigh  => '1',      -- '1' = normal, 'Z' = open collectors
        tPLH   => tPLH,
        tPHL   => tPHL
    )
    port map(
        ins   => A,
        outs  => Y
    );

end architecture BEHAV;

-----------------------------------------------------------------------
-- SN74LS28N: Quad 2-input NOR buffer
--            Verified 29/05/2016
-----------------------------------------------------------------------
library ieee;
    use ieee.std_logic_1164.all;

    use work.LSTTL.all;
    use work.TTLPrivate.all;

entity SN74LS28N is
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
end entity SN74LS28N;

architecture BEHAV of SN74LS28N is
    signal A : TTLInputs (1 to 4, 1 to 2);
    signal Y : TTLOutputs(1 to 4);
  
begin
    A <= ( (X_2, X_3), (X_5, X_6), (X_8, X_9), (X_11, X_12) );
    
    (X_1, X_4, X_10, X_13) <= Y;
  
    G: TTLgate
    generic map(
        mode   => Zor,      -- Zand, Zor, Zxor, Zbuf
        invert => '1',      -- '1' will invert the output
        ohigh  => '1',      -- '1' = normal, 'Z' = open collectors
        tPLH   => tPLH,
        tPHL   => tPHL
    )
    port map(
        ins   => A,
        outs  => Y
    );
  
end architecture BEHAV;

-----------------------------------------------------------------------
-- SN74LS30N: 8-input NAND gate (Pinout A)
--            Verified 30/05/2016
-----------------------------------------------------------------------
library ieee;
    use ieee.std_logic_1164.all;

    use work.LSTTL.all;
    use work.TTLPrivate.all;

entity SN74LS30N is
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
end entity SN74LS30N;

architecture BEHAV of SN74LS30N is
    signal A : TTLInputs (1 to 1, 1 to 8);
    signal Y : TTLOutputs(1 to 1);
  
begin
    A(1,1) <= X_1;          -- Can't use aggregates with single gate
    A(1,2) <= X_2;
    A(1,3) <= X_3;
    A(1,4) <= X_4;
    A(1,5) <= X_5;
    A(1,6) <= X_6;
    A(1,7) <= X_11;
    A(1,8) <= X_12;
    
    X_8 <= Y(1);
  
    G: TTLgate
    generic map(
        mode   => Zand,     -- Zand, Zor, Zxor, Zbuf
        invert => '1',      -- '1' will invert the output
        ohigh  => '1',      -- '1' = normal, 'Z' = open collectors
        tPLH   => tPLH,
        tPHL   => tPHL
    )
    port map(
        ins   => A,
        outs  => Y
    );
  
end architecture BEHAV;

-----------------------------------------------------------------------
-- SN74LS32N: Quad 2-input or gate
--            Verified 28/05/2016
-----------------------------------------------------------------------
library ieee;
    use ieee.std_logic_1164.all;

    use work.LSTTL.all;
    use work.TTLPrivate.all;

entity SN74LS32N is
generic(
    tPLH : time := 15 ns;
    tPHL : time := 15 ns
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
end entity SN74LS32N;

architecture BEHAV of SN74LS32N is
    signal A : TTLInputs (1 to 4, 1 to 2);
    signal Y : TTLOutputs(1 to 4);
  
begin
    A <= ( (X_1, X_2), (X_4, X_5), (X_9, X_10), (X_12, X_13) );
    
    (X_3, X_6, X_8, X_11) <= Y;
  
    G: TTLgate
    generic map(
        mode   => Zor,      -- Zand, Zor, Zxor, Zbuf
        invert => '0',      -- '1' will invert the output
        ohigh  => '1',      -- '1' = normal, 'Z' = open collectors
        tPLH   => tPLH,
        tPHL   => tPHL
    )
    port map(
        ins   => A,
        outs  => Y
    );
  
end architecture BEHAV;

-----------------------------------------------------------------------
-- SN74LS33N: Quad 2-input NOR buffer (open collector)
--            Verified 29/05/2016
-----------------------------------------------------------------------
library ieee;
    use ieee.std_logic_1164.all;

    use work.LSTTL.all;
    use work.TTLPrivate.all;

entity SN74LS33N is
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
end entity SN74LS33N;

architecture BEHAV of SN74LS33N is
    signal A : TTLInputs (1 to 4, 1 to 2);
    signal Y : TTLOutputs(1 to 4);
  
begin
    A <= ( (X_2, X_3), (X_5, X_6), (X_8, X_9), (X_11, X_12) );
    
    (X_1, X_4, X_10, X_13) <= Y;
  
    G: TTLgate
    generic map(
        mode   => Zor,      -- Zand, Zor, Zxor, Zbuf
        invert => '1',      -- '1' will invert the output
        ohigh  => 'Z',      -- '1' = normal, 'Z' = open collectors
        tPLH   => tPLH,
        tPHL   => tPHL
    )
    port map(
        ins   => A,
        outs  => Y
    );
  
end architecture BEHAV;

-----------------------------------------------------------------------
-- SN74LS37N: Quad 2-input NAND buffer
--            Verified 28/05/2016
-----------------------------------------------------------------------
library ieee;
    use ieee.std_logic_1164.all;

    use work.LSTTL.all;
    use work.TTLPrivate.all;

entity SN74LS37N is
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
end entity SN74LS37N;

architecture BEHAV of SN74LS37N is
    signal A : TTLInputs (1 to 4, 1 to 2);
    signal Y : TTLOutputs(1 to 4);
  
begin
    A <= ( (X_1, X_2), (X_4, X_5), (X_9, X_10), (X_12, X_13) );
    
    (X_3, X_6, X_8, X_11) <= Y;
  
    G: TTLgate
    generic map(
        mode   => Zand,     -- Zand, Zor, Zxor, Zbuf
        invert => '1',      -- '1' will invert the output
        ohigh  => '1',      -- '1' = normal, 'Z' = open collectors
        tPLH   => tPLH,
        tPHL   => tPHL
    )
    port map(
        ins   => A,
        outs  => Y
    );
  
end architecture BEHAV;

-----------------------------------------------------------------------
-- SN74LS38N: Quad 2-input NAND buffer (open collector)
--            Verified 28/05/2016
-----------------------------------------------------------------------
library ieee;
    use ieee.std_logic_1164.all;

    use work.LSTTL.all;
    use work.TTLPrivate.all;

entity SN74LS38N is
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
end entity SN74LS38N;

architecture BEHAV of SN74LS38N is
    signal A : TTLInputs (1 to 4, 1 to 2);
    signal Y : TTLOutputs(1 to 4);
  
begin
    A <= ( (X_1, X_2), (X_4, X_5), (X_9, X_10), (X_12, X_13) );
    
    (X_3, X_6, X_8, X_11) <= Y;
  
    G: TTLgate
    generic map(
        mode   => Zand,     -- Zand, Zor, Zxor, Zbuf
        invert => '1',      -- '1' will invert the output
        ohigh  => 'Z',      -- '1' = normal, 'Z' = open collectors
        tPLH   => tPLH,
        tPHL   => tPHL
    )
    port map(
        ins   => A,
        outs  => Y
    );
  
end architecture BEHAV;

-----------------------------------------------------------------------
-- SN74LS39N: Quad 2-input NAND buffer (open collector) (Pinout A)
--            Verified 29/05/2016
-----------------------------------------------------------------------
library ieee;
    use ieee.std_logic_1164.all;

    use work.LSTTL.all;
    use work.TTLPrivate.all;

entity SN74LS39N is
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
end entity SN74LS39N;

architecture BEHAV of SN74LS39N is
    signal A : TTLInputs (1 to 4, 1 to 2);
    signal Y : TTLOutputs(1 to 4);
  
begin
    A <= ( (X_2, X_3), (X_5, X_6), (X_8, X_9), (X_11, X_12) );
    
    (X_1, X_4, X_10, X_13) <= Y;
  
    G: TTLgate
    generic map(
        mode   => Zand,     -- Zand, Zor, Zxor, Zbuf
        invert => '1',      -- '1' will invert the output
        ohigh  => 'Z',      -- '1' = normal, 'Z' = open collectors
        tPLH   => tPLH,
        tPHL   => tPHL
    )
    port map(
        ins   => A,
        outs  => Y
    );
  
end architecture BEHAV;

-----------------------------------------------------------------------
-- SN74LS40N: Dual 4-input NAND buffer (Pinout A)
--            Verified 30/05/2016
-----------------------------------------------------------------------
library ieee;
    use ieee.std_logic_1164.all;

    use work.LSTTL.all;
    use work.TTLPrivate.all;

entity SN74LS40N is
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
end entity SN74LS40N;

architecture BEHAV of SN74LS40N is
    signal A : TTLInputs (1 to 2, 1 to 4);
    signal Y : TTLOutputs(1 to 2);
  
begin
    A <= ( (X_1, X_2, X_4, X_5), (X_9, X_10, X_12, X_13) );
    
    (X_6, X_8) <= Y;
  
    G: TTLgate
    generic map(
        mode   => Zand,     -- Zand, Zor, Zxor, Zbuf
        invert => '1',      -- '1' will invert the output
        ohigh  => '1',      -- '1' = normal, 'Z' = open collectors
        tPLH   => tPLH,
        tPHL   => tPHL
    )
    port map(
        ins   => A,
        outs  => Y
    );

end architecture BEHAV;

-----------------------------------------------------------------------
-- SN74LS42N: 1-of-10 decoder
--            Verified 30/05/2016
-----------------------------------------------------------------------
library ieee;
    use ieee.std_logic_1164.all;
    use ieee.numeric_std.all;

    use work.LSTTL.all;
    use work.TTLPrivate.all;

entity SN74LS42N is
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
end entity SN74LS42N;

architecture BEHAV of SN74LS42N is
    signal OP, Y : std_logic_vector(15 downto 0);
begin
    process(all) is
    variable AT : unsigned(3 downto 0);
    variable AD :  natural range(OP'range);
    begin
        AT := (X_12 & X_13 & X_14 & X_15);
        AD := TTL_to_integer(AT);
        OP <= (others => '1');
        OP(AD) <= '0';
    end process;
    
    G1: for i in OP'range generate
    begin
        DL: TTLdelay
        generic map(
            tPLH => tPLH,
            tPHL => tPHL
        )
        port map(
            A => OP(i),
            B => Y(i)
        );
    end generate;
    
    ( X_11, X_10, X_9, X_7, X_6, X_5, X_4, X_3, X_2, X_1 ) <= Y(9 downto 0);
    
end architecture BEHAV;

-----------------------------------------------------------------------
-- SN7445N: 1-of-10 decoder/driver (open collector)
--          Verified 30/05/2016
-----------------------------------------------------------------------
library ieee;
    use ieee.std_logic_1164.all;
    use ieee.numeric_std.all;

    use work.LSTTL.all;
    use work.TTLPrivate.all;

entity SN7445N is
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
end entity SN7445N;

architecture BEHAV of SN7445N is
    signal OP, Y, Z : std_logic_vector(15 downto 0);
begin
    process(all) is
    variable AT : unsigned(3 downto 0);
    variable AD :  natural range(OP'range);
    begin
        AT := (X_12 & X_13 & X_14 & X_15);
        AD := TTL_to_integer(AT);
        OP <= (others => '1');
        OP(AD) <= '0';
    end process;
    
    G1: for i in OP'range generate
    begin
        DL: TTLdelay
        generic map(
            tPLH => tPLH,
            tPHL => tPHL
        )
        port map(
            A => OP(i),
            B => Y(i)
        );
        
        Z(i) <= '0' when Y(i) = '0' else 'Z';       -- Open collectors
    end generate;
    
    ( X_11, X_10, X_9, X_7, X_6, X_5, X_4, X_3, X_2, X_1 ) <= Z(9 downto 0);
    
end architecture BEHAV;

-- SN74LS47N: BCD to 7-segment decoder/driver
-- SN74LS48N: BCD to 7-segment decoder
-- SN74LS49N: BCD to 7-segment decoder
-- SN7450P: Expandable dual 2-wide 2-input and-or-invert gate

-----------------------------------------------------------------------
-- SN74LS51N: Dual 2-wide, 2/3-input and-or-Invert gate (Pinout B)
--            Verified 30/05/2016
-----------------------------------------------------------------------
library ieee;
    use ieee.std_logic_1164.all;

    use work.LSTTL.all;
    use work.TTLPrivate.all;

entity SN74LS51N is
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
end entity SN74LS51N;

architecture BEHAV of SN74LS51N is
    signal Y : std_logic_vector(2 downto 1);
begin
    Y(1) <= not( (X_2 and X_3) or (X_4 and X_5));
    Y(2) <= not( (X_1 and X_12 and X_13) or (X_9 and X_10 and X_11));
    
    G1: TTLdelay
        generic map(
            tPLH => tPLH,
            tPHL => tPHL
        )
        port map(
            A => Y(1),
            B => X_6
        );

    G2: TTLdelay
        generic map(
            tPLH => tPLH,
            tPHL => tPHL
        )
        port map(
            A => Y(2),
            B => X_8
        );

end architecture BEHAV;

-- SN74H52: Expandable 2-2-2-3-input and-or gate
-- SN74H53: Expandable 2-2-2-3-input and-or-Invert gate

-----------------------------------------------------------------------
-- SN74LS54N: 4-wide 2-input and-or-Invert gate (Pinout C)
--            Verified 30/05/2016
-----------------------------------------------------------------------
library ieee;
    use ieee.std_logic_1164.all;

    use work.LSTTL.all;
    use work.TTLPrivate.all;

entity SN74LS54N is
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
end entity SN74LS54N;

architecture BEHAV of SN74LS54N is
    signal Y : std_logic;
begin
    Y <= not( (X_1  and X_2) or
              (X_3  and X_4  and X_5 ) or
              (X_9  and X_10 and X_11) or              
              (X_12 and X_13) );
    
    G1: TTLdelay
        generic map(
            tPLH => tPLH,
            tPHL => tPHL
        )
        port map(
            A => Y,
            B => X_6
        );

end architecture BEHAV;

-----------------------------------------------------------------------
-- SN74LS55N: 2-wide 4-input and-or-Invert gate (Pinout B)
--            Verified 30/05/2016
-----------------------------------------------------------------------
library ieee;
    use ieee.std_logic_1164.all;

    use work.LSTTL.all;
    use work.TTLPrivate.all;

entity SN74LS55N is
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
end entity SN74LS55N;

architecture BEHAV of SN74LS55N is
    signal Y : std_logic;
begin
    Y <= not( (X_1  and X_2 and X_3  and X_4) or
              (X_10 and X_11 and X_12 and X_13) );             
    
    G1: TTLdelay
        generic map(
            tPLH => tPLH,
            tPHL => tPHL
        )
        port map(
            A => Y,
            B => X_8
        );

end architecture BEHAV;

-- SN74H60: Dual 4-input expander
-- SN74H61: Triple 3-input expander
-- SN74H62: 3-2-2-3-input And-Or expander

-----------------------------------------------------------------------
-- SN74S64N: 4-2-3-2 input and-or-Invert gate
--           Verified 30/05/2016
-----------------------------------------------------------------------
library ieee;
    use ieee.std_logic_1164.all;

    use work.LSTTL.all;
    use work.TTLPrivate.all;

entity SN74S64N is
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
end entity SN74S64N;

architecture BEHAV of SN74S64N is
    signal Y : std_logic;
begin
    Y <= not( (X_2  and X_3) or
              (X_4  and X_5 and X_6) or
              (X_9  and X_10) or
              (X_11 and X_12 and X_13 and X_1) );             
    
    G1: TTLdelay
        generic map(
            tPLH => tPLH,
            tPHL => tPHL
        )
        port map(
            A => Y,
            B => X_8
        );

end architecture BEHAV;

-----------------------------------------------------------------------
-- SN74S65N: 4-2-3-2 input and-or-Invert gate (open collector)
--           Verified 30/05/2016
-----------------------------------------------------------------------
library ieee;
    use ieee.std_logic_1164.all;

    use work.LSTTL.all;
    use work.TTLPrivate.all;

entity SN74S65N is
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
end entity SN74S65N;

architecture BEHAV of SN74S65N is
    signal Y, Z : std_logic;
begin
    Y <= not( (X_2  and X_3) or
              (X_4  and X_5 and X_6) or
              (X_9  and X_10) or
              (X_11 and X_12 and X_13 and X_1) );             
    
    G1: TTLdelay
        generic map(
            tPLH => tPLH,
            tPHL => tPHL
        )
        port map(
            A => Y,
            B => Z
        );

        X_8 <= '0' when Z = '0' else 'Z';   -- Open collector
        
end architecture BEHAV;

-----------------------------------------------------------------------
-- SN74LS68N: Dual 4-bit decade counter
--            Verified 01/06/2016
-----------------------------------------------------------------------
library ieee;
    use ieee.std_logic_1164.all;

    use work.LSTTL.all;
    use work.TTLPrivate.all;

entity SN74LS68N is
generic(
    tPLH10 : time := 11 ns;
    tPHL10 : time := 21 ns;
    tPLH11 : time := 12 ns;     -- From CLK2
    tPHL11 : time := 18 ns;
    tPLH12 : time := 23 ns;
    tPHL12 : time := 32 ns;     -- Worst delay = tPHL10 + tPHL12 = 53 ns
    tPLH13 : time := 12 ns;
    tPHL13 : time := 20 ns;
    
    tPLH20 : time := 11 ns;
    tPHL20 : time := 21 ns;
    tPLH21 : time := 24 ns;     -- From CLK1
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
end entity SN74LS68N;

architecture BEHAV of SN74LS68N is
    signal rst1, rst2 : std_logic;
    signal       q02  : std_logic;
begin
    rst1 <= not X_4;
    rst2 <= not X_11;
    
    C1: SN74LS90AN
    generic map(
        tPLH0 => tPLH10,
        tPHL0 => tPHL10,
        tPLH1 => tPLH11,            -- Delays not shortened: Q0 is explicit
        tPHL1 => tPHL11,
        tPLH2 => tPLH12,
        tPHL2 => tPHL12,
        tPLH3 => tPLH13,
        tPHL3 => tPHL13
    )
    port map(
        X_1  => X_15,  -- CP1\
        X_2  => rst1,  -- MR1
        X_3  => rst1,  -- MR2
                       -- 
        X_5  => open,  -- Vcc
        X_6  => '0',   -- MS1
        X_7  => '0',   -- MS2
        X_8  => X_13,  -- Q2
        X_9  => X_2,   -- Q1
        X_10 => open,  -- GND
        X_11 => X_3,   -- Q3
        X_12 => X_14,  -- Q0
                       -- 
        X_14 => X_1    -- CP0\
    );

    C2: SN74LS90AN
    generic map(
        tPLH0 => tPLH20,
        tPHL0 => tPHL20,
        tPLH1 => tPLH21-tPLH20,     -- Delays shortened, as they include Q0
        tPHL1 => tPHL21-tPHL20,
        tPLH2 => tPLH22-tPLH20,
        tPHL2 => tPHL22-tPHL20,
        tPLH3 => tPLH23-tPLH20,
        tPHL3 => tPHL23-tPHL20
    )
    port map(
        X_1  => q02,   -- CP1\
        X_2  => rst2,  -- MR1
        X_3  => rst2,  -- MR2
                       -- 
        X_5  => open,  -- Vcc
        X_6  => '0',   -- MS1
        X_7  => '0',   -- MS2
        X_8  => X_5,   -- Q2
        X_9  => X_10,  -- Q1
        X_10 => open,  -- GND
        X_11 => X_12,  -- Q3
        X_12 => q02,   -- Q0
                       -- 
        X_14 => X_9    -- CP0\
    );
    X_7 <= q02;

end architecture BEHAV;

-----------------------------------------------------------------------
-- SN74LS69N: Dual 4-bit binary counter
--            Verified 01/06/2016
-----------------------------------------------------------------------
library ieee;
    use ieee.std_logic_1164.all;

    use work.LSTTL.all;
    use work.TTLPrivate.all;

entity SN74LS69N is
generic(
    tPLH10 : time := 11 ns;
    tPHL10 : time := 21 ns;
    tPLH11 : time := 11 ns;     -- From CLK2
    tPHL11 : time := 21 ns;
    tPLH12 : time := 24 ns;
    tPHL12 : time := 32 ns;
    tPLH13 : time := 38 ns;
    tPHL13 : time := 45 ns;     -- Worst delay = tPHL10 + tPHL13 = 66 ns
    
    tPLH20 : time := 11 ns;
    tPHL20 : time := 21 ns;
    tPLH21 : time := 21 ns;     -- From CLK1
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
end entity SN74LS69N;

architecture BEHAV of SN74LS69N is
    signal rst1, rst2 : std_logic;
    signal       q02  : std_logic;
begin
    rst1 <= not X_4;
    rst2 <= not X_11;
    
    C1: SN74LS93N
    generic map(
        tPLH0 => tPLH10,
        tPHL0 => tPHL10,
        tPLH1 => tPLH11,
        tPHL1 => tPHL11,
        tPLH2 => tPLH12,
        tPHL2 => tPHL12,
        tPLH3 => tPLH13,
        tPHL3 => tPHL13
    )
    port map(
        X_1  => X_15,  -- CP1\
        X_2  => rst1,  -- MR1
        X_3  => rst1,  -- MR2
                       -- 
        X_5  => open,  -- Vcc
                       --
                       --
        X_8  => X_13,  -- Q2
        X_9  => X_2,   -- Q1
        X_10 => open,  -- GND
        X_11 => X_3,   -- Q3
        X_12 => X_14,  -- Q0
                       -- 
        X_14 => X_1    -- CP0\
    );

    C2: SN74LS93N
    generic map(
        tPLH0 => tPLH20,
        tPHL0 => tPHL20,
        tPLH1 => tPLH21-tPLH20,     -- Delays shortened, as they include Q0
        tPHL1 => tPHL21-tPHL20,
        tPLH2 => tPLH22-tPLH20,
        tPHL2 => tPHL22-tPHL20,
        tPLH3 => tPLH23-tPLH20,
        tPHL3 => tPHL23-tPHL20
    )
    port map(
        X_1  => q02,   -- CP1\
        X_2  => rst2,  -- MR1
        X_3  => rst2,  -- MR2
                       -- 
        X_5  => open,  -- Vcc
                       --
                       --
        X_8  => X_5,   -- Q2
        X_9  => X_10,  -- Q1
        X_10 => open,  -- GND
        X_11 => X_12,  -- Q3
        X_12 => q02,   -- Q0
                       -- 
        X_14 => X_9    -- CP0\
    );
    X_7 <= q02;

end architecture BEHAV;

-----------------------------------------------------------------------
-- SN74LS70N: JK edge-triggered flipflop (Pinout A)
--            Verified 01/06/2016
-----------------------------------------------------------------------
library ieee;
    use ieee.std_logic_1164.all;

    use work.LSTTL.all;
    use work.TTLPrivate.all;

entity SN74LS70N is
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
end entity SN74LS70N;

architecture BEHAV of SN74LS70N is
    signal j, k, nr, ns : std_logic;
begin
    j  <= X_3  and X_4  and not X_5;
    k  <= X_11 and X_10 and not X_9;
    nr <= not X_2;
    ns <= not X_13;
    
    FF: TTLflipflop
    generic map(
        tPLHCP  => tPLHCP,
        tPHLCP  => tPHLCP,
        tPLHSC  => tPLHSC,
        tPHLSC  => tPHLSC,
        tSETUP  => tSETUP,
        Safeclk => false  
    )
    port map(
        J  => j,
        K  => k,
        C  => X_12,
        S  => ns,
        R  => nr,
        Q  => X_8,
        QB => X_6
    );

end architecture BEHAV;

-----------------------------------------------------------------------
-- SN74LS71N: JK master-slave flipflop (with and/or inputs)
--            Verified 01/06/2016
-----------------------------------------------------------------------
library ieee;
    use ieee.std_logic_1164.all;

    use work.LSTTL.all;
    use work.TTLPrivate.all;

entity SN74LS71N is
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
end entity SN74LS71N;

architecture BEHAV of SN74LS71N is
    signal j, k, ns, nc : std_logic;
begin
    j  <= (X_1 and X_2 ) or (X_3  and X_4 );
    k  <= (X_9 and X_10) or (X_11 and X_12);
    ns <= not X_5;
    nc <= not X_13;
    
    FF: TTLflipflop
    generic map(
        tPLHCP  => tPLHCP,
        tPHLCP  => tPHLCP,
        tPLHSC  => tPLHSC,
        tPHLSC  => tPHLSC,
        tSETUP  => tSETUP,
        Safeclk => true
    )
    port map(
        J  => j,
        K  => k,
        C  => nc,
        S  => ns,
        R  => '0',
        Q  => X_6,
        QB => X_8
    );
    
end architecture BEHAV;

-----------------------------------------------------------------------
-- SN74LS72N: JK master-slave flipflop (with and inputs) (Pinout A)
--            Verified 01/06/2016
-----------------------------------------------------------------------
library ieee;
    use ieee.std_logic_1164.all;

    use work.LSTTL.all;
    use work.TTLPrivate.all;

entity SN74LS72N is
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
end entity SN74LS72N;

architecture BEHAV of SN74LS72N is
    signal j, k, ns, nr, nc : std_logic;
begin
    j  <= (X_3 and X_4  and X_5  );
    k  <= (X_9 and X_10 and X_11 );
    ns <= not X_13;
    nr <= not X_2;
    nc <= not X_12;
    
    FF: TTLflipflop
    generic map(
        tPLHCP  => tPLHCP,
        tPHLCP  => tPHLCP,
        tPLHSC  => tPLHSC,
        tPHLSC  => tPHLSC,
        tSETUP  => tSETUP,
        Safeclk => true
    )
    port map(
        J  => j,
        K  => k,
        C  => nc,
        S  => ns,
        R  => nr,
        Q  => X_8,
        QB => X_6
    );
    
end architecture BEHAV;

-----------------------------------------------------------------------
-- SN74LS73N: Dual JK flipflop
--            Verified 01/06/2016
-----------------------------------------------------------------------
library ieee;
    use ieee.std_logic_1164.all;

    use work.LSTTL.all;
    use work.TTLPrivate.all;

entity SN74LS73N is
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
end entity SN74LS73N;

architecture BEHAV of SN74LS73N is
    subtype Pair is std_logic_vector(0 to 1);
    signal C, J, K, R, Q, QB : Pair;
begin
    C <= (X_1,  X_5 );
    R <= (X_2,  X_6 );
    J <= (X_14, X_7 );
    K <= (X_3,  X_10);
    (X_12, X_9) <= Q;
    (X_13, X_8) <= QB;
    
    G1: for i in Pair'range generate
        signal nc, nr : std_logic;
    begin
        nc <= not C(i);
        nr <= not R(i);
    
        FF: TTLflipflop
        generic map(
            tPLHCP  => tPLHCP,
            tPHLCP  => tPHLCP,
            tPLHSC  => tPLHSC,
            tPHLSC  => tPHLSC,
            tSETUP  => tSETUP,
            Safeclk => true
        )
        port map(
            J  => J(i),
            K  => K(i),
            C  => nc,
            S  => '0',
            R  => nr,
            Q  => Q(i),
            QB => QB(i)
        );    
    end generate;
end architecture BEHAV;

-----------------------------------------------------------------------
-- SN74LS74N: Dual D-type +ve edge-triggered flipflop (Pinout A)
--            Verified 01/06/2016
-----------------------------------------------------------------------
library ieee;
    use ieee.std_logic_1164.all;

    use work.LSTTL.all;
    use work.TTLPrivate.all;

entity SN74LS74N is
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
end entity SN74LS74N;

architecture BEHAV of SN74LS74N is
    subtype Pair is std_logic_vector(0 to 1);
    signal C, D, R, S, Q, QB : Pair;
begin
    C <= (X_3,  X_11 );
    R <= (X_1,  X_13 );
    S <= (X_4,  X_10 );
    D <= (X_2,  X_12 );
    (X_5, X_9) <= Q;
    (X_6, X_8) <= QB;
    
    G1: for i in Pair'range generate
        signal nr, ns, nd : std_logic;
    begin
        nd <= not D(i);
        nr <= not R(i);
        ns <= not S(i);
    
        FF: TTLflipflop
        generic map(
            tPLHCP  => tPLHCP,
            tPHLCP  => tPHLCP,
            tPLHSC  => tPLHSC,
            tPHLSC  => tPHLSC,
            tSETUP  => tSETUP,
            Safeclk => false
        )
        port map(
            J  => D(i),
            K  => nd,
            C  => C(i),
            S  => ns,
            R  => nr,
            Q  => Q(i),
            QB => QB(i)
        );    
    end generate;
end architecture BEHAV;

-----------------------------------------------------------------------
-- SN74LS75N: 4-bit bistable latch
--             Verified 21/12/2016
-----------------------------------------------------------------------
library ieee;
    use ieee.std_logic_1164.all;

    use work.LSTTL.all;
    use work.TTLPrivate.all;

entity SN74LS75N is
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
end entity SN74LS75N;

architecture BEHAV of SN74LS75N is
    signal D, E, Q, QB : std_logic_vector(4 downto 1);
begin
    D  <= (X_7, X_6, X_3,  X_2);
    E  <= (X_4, X_4, X_13, X_13);
    (X_9, X_11, X_15, X_16) <= Q;
    (X_8, X_10, X_14, X_1 ) <= QB;

    G: for i in D'range generate
        signal R, S : std_logic;
    begin
        process(D, E) is
        begin
            if E(i)'event and E(i) = '0' and now > tSETUP then   -- Data is registered on the falling edge
                assert D(i)'stable(tSETUP)
                    report "Setup time violation: (" & integer'image(i) & ") " & time'image(D(i)'last_event)
                    severity failure;
            end if;
            
            if E(i) = '1' then
                R <= D(i);
                S <= not D(i);
            end if;
        end process;
        
        D1: TTLdelay 
            generic map(
                tPLH => tPLHCP,
                tPHL => tPHLCP
            )
            port map(
                A => R,
                B => Q(i)
            );

        D2: TTLdelay 
            generic map(
                tPLH => tPLHCP,
                tPHL => tPHLCP
            )
            port map(
                A => S,
                B => QB(i)
            );
    end generate;   
end architecture BEHAV;

-----------------------------------------------------------------------
-- SN74LS76N: Dual JK flipflop
--            Verified 01/06/2016
-----------------------------------------------------------------------
library ieee;
    use ieee.std_logic_1164.all;

    use work.LSTTL.all;
    use work.TTLPrivate.all;

entity SN74LS76N is
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
end entity SN74LS76N;

architecture BEHAV of SN74LS76N is
    subtype Pair is std_logic_vector(0 to 1);
    signal C, J, K, R, S, Q, QB : Pair;
begin
    C <= (X_1,  X_6 );
    R <= (X_3,  X_8 );
    S <= (X_2,  X_7 );
    J <= (X_4,  X_9 );
    K <= (X_16, X_12);
    (X_15, X_11) <= Q;
    (X_14, X_10) <= QB;
    
    G1: for i in Pair'range generate
        signal nc, nr, np : std_logic;
    begin
        nc <= not C(i);   
        nr <= not R(i);
        np <= not S(i);
    
        FF: TTLflipflop
        generic map(
            tPLHCP  => tPLHCP,
            tPHLCP  => tPHLCP,
            tPLHSC  => tPLHSC,
            tPHLSC  => tPHLSC,
            tSETUP  => tSETUP,
            Safeclk => true
        )
        port map(
            J  => J(i),
            K  => K(i),
            C  => nc,
            S  => np,
            R  => nr,
            Q  => Q(i),
            QB => QB(i)
        );    
    end generate;
end architecture BEHAV;

-----------------------------------------------------------------------
-- SN74LS77N: Quad D-type latch
--            As 7475 without the Q\ outputs
--            Verified 05/06/2016
-----------------------------------------------------------------------
library ieee;
    use ieee.std_logic_1164.all;

    use work.LSTTL.all;
    use work.TTLPrivate.all;

entity SN74LS77N is
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
end entity SN74LS77N;

architecture BEHAV of SN74LS77N is
    signal D, E, Q : std_logic_vector(4 downto 1);
begin
    D  <= (X_6, X_5, X_2,  X_1);
    E  <= (X_3, X_3, X_12, X_12);
    (X_8, X_9, X_13, X_14) <= Q;

    G: for i in D'range generate
        signal R, S : std_logic;
    begin
        process(D, E) is
        begin
            if E(i)'event and E(i) = '0' and now > tSETUP then   -- Data is registered on the falling edge
                assert D(i)'stable(tSETUP)
                    report "Setup time violation"
                    severity failure;
            end if;
            
            if E(i) = '1' then
                R <= D(i);
                S <= not D(i);
            end if;
        end process;
        
        D1: TTLdelay 
            generic map(
                tPLH => tPLHCP,
                tPHL => tPHLCP
            )
            port map(
                A => R,
                B => Q(i)
            );
    end generate;
    
end architecture BEHAV;

-----------------------------------------------------------------------
-- SN74LS78N: Dual JK flipflop (Pinout A)
--            Verified 01/06/2016
-----------------------------------------------------------------------
library ieee;
    use ieee.std_logic_1164.all;

    use work.LSTTL.all;
    use work.TTLPrivate.all;

entity SN74LS78N is
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
end entity SN74LS78N;

architecture BEHAV of SN74LS78N is
    subtype Pair is std_logic_vector(0 to 1);
    signal J, K, S, Q, QB : Pair;
begin
    S <= (X_13,  X_10);
    J <= (X_4,   X_11);
    K <= (X_1,   X_8 );
    (X_2, X_6) <= Q;
    (X_3, X_5) <= QB;
    
    G1: for i in Pair'range generate
        signal nc, nr, np : std_logic;
    begin
        nc <= not X_9;   
        nr <= not X_12;
        np <= not S(i);
    
        FF: TTLflipflop
        generic map(
            tPLHCP  => tPLHCP,
            tPHLCP  => tPHLCP,
            tPLHSC  => tPLHSC,
            tPHLSC  => tPHLSC,
            tSETUP  => tSETUP,
            Safeclk => true
        )
        port map(
            J  => J(i),
            K  => K(i),
            C  => nc,
            S  => np,
            R  => nr,
            Q  => Q(i),
            QB => QB(i)
        );    
    end generate;
end architecture BEHAV;

-----------------------------------------------------------------------
-- SN7480N: Gated full adder (Pinout A)
--          The expansion inputs are not modelled
--          Verified 05/06/2016
-----------------------------------------------------------------------
library ieee;
    use ieee.std_logic_1164.all;

    use work.LSTTL.all;
    use work.TTLPrivate.all;

entity SN7480N is
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
end entity SN7480N;

architecture BEHAV of SN7480N is
    signal ASI, BSI, AS, BS, C2, S, SB : std_logic;
    signal tPLHC, tPHLC : time;
begin
    ASI <= not(X_8  and X_9 );
    BSI <= not(X_12 and X_13);
    
    DASI: TTLdelay 
        generic map(
            tPLH => tPLHX,
            tPHL => tPHLX
        )
        port map(
            A => ASI,
            B => AS
        );
        
    DBSI: TTLdelay 
        generic map(
            tPLH => tPLHX,
            tPHL => tPHLX
        )
        port map(
            A => BSI,
            B => BS
        );
        
    process(all) is
        variable A, B : std_logic;
        variable IP   : std_logic_vector(2 downto 0);
    begin
        if X_3'event then
            tPLHC <= tPLHCC;
            tPHLC <= tPHLCC;
        else
            tPLHC <= tPLHBC;
            tPHLC <= tPHLBC;
        end if;
        
        A  := not(AS and X_11);
        B  := not(BS and X_2 );
        IP := (X_3, B, A);
        case IP is
            when "000"  => C2 <= '1'; SB <= '1'; S <= '0';
            when "001"  => C2 <= '1'; SB <= '0'; S <= '1';
            when "010"  => C2 <= '1'; SB <= '0'; S <= '1';
            when "011"  => C2 <= '0'; SB <= '1'; S <= '0';
            when "100"  => C2 <= '0'; SB <= '0'; S <= '1';
            when "101"  => C2 <= '1'; SB <= '1'; S <= '0';
            when "110"  => C2 <= '1'; SB <= '1'; S <= '0';
            when "111"  => C2 <= '0'; SB <= '0'; S <= '1';
            when others => null;
        end case;
    end process;
    
    process(all) is     -- Don't use TTLdelay: the delays are not constant
    begin
        if    rising_edge(C2) then
            X_4 <= 'X', C2 after tPLHC;     -- Rising delay
        elsif falling_edge(C2) then
            X_4 <= 'X', C2 after tPHLC;     -- Falling delay
        else
            X_4 <= C2;                      -- 'Z', or bad value
        end if;
    end process;

    DS: TTLdelay 
        generic map(
            tPLH => tPLHS,
            tPHL => tPHLS
        )
        port map(
            A => S,
            B => X_5
        );

    DSB: TTLdelay 
        generic map(
            tPLH => tPLHSB,
            tPHL => tPHLSB
        )
        port map(
            A => SB,
            B => X_6
        );
end architecture BEHAV;

-----------------------------------------------------------------------
-- SN7482N: 2-bit full adder
--          Verified 05/06/2016
-----------------------------------------------------------------------
library ieee;
    use ieee.std_logic_1164.all;

    use work.LSTTL.all;
    use work.TTLPrivate.all;

entity SN7482N is
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
end entity SN7482N;

architecture BEHAV of SN7482N is
    signal S1, S2, C2 : std_logic;
begin
    
    process(all) is
        variable IP : std_logic_vector(4 downto 0);
    begin  --   Cin  A1   B1   A2    B2      
        IP := ( X_5, X_2, X_3, X_14, X_13);
        case IP is
            when "00000" => S1 <= '0'; S2 <= '0'; C2 <= '0';
            when "10000" => S1 <= '1'; S2 <= '0'; C2 <= '0';
            when "01000" => S1 <= '1'; S2 <= '0'; C2 <= '0';
            when "11000" => S1 <= '0'; S2 <= '1'; C2 <= '0';
            when "00100" => S1 <= '1'; S2 <= '0'; C2 <= '0';
            when "10100" => S1 <= '0'; S2 <= '1'; C2 <= '0';
            when "01100" => S1 <= '0'; S2 <= '1'; C2 <= '0';
            when "11100" => S1 <= '1'; S2 <= '1'; C2 <= '0';
            when "00010" => S1 <= '0'; S2 <= '1'; C2 <= '0';
            when "10010" => S1 <= '1'; S2 <= '1'; C2 <= '0';
            when "01010" => S1 <= '1'; S2 <= '1'; C2 <= '0';
            when "11010" => S1 <= '0'; S2 <= '0'; C2 <= '1';
            when "00110" => S1 <= '1'; S2 <= '1'; C2 <= '0';
            when "10110" => S1 <= '0'; S2 <= '0'; C2 <= '1';
            when "01110" => S1 <= '0'; S2 <= '0'; C2 <= '1';
            when "11110" => S1 <= '1'; S2 <= '0'; C2 <= '1';
            when "00001" => S1 <= '0'; S2 <= '1'; C2 <= '0';
            when "10001" => S1 <= '1'; S2 <= '1'; C2 <= '0';
            when "01001" => S1 <= '1'; S2 <= '1'; C2 <= '0';
            when "11001" => S1 <= '0'; S2 <= '0'; C2 <= '1';
            when "00101" => S1 <= '1'; S2 <= '1'; C2 <= '0';
            when "10101" => S1 <= '0'; S2 <= '0'; C2 <= '1';
            when "01101" => S1 <= '0'; S2 <= '0'; C2 <= '1';
            when "11101" => S1 <= '1'; S2 <= '0'; C2 <= '1';
            when "00011" => S1 <= '0'; S2 <= '0'; C2 <= '1';
            when "10011" => S1 <= '1'; S2 <= '0'; C2 <= '1';
            when "01011" => S1 <= '1'; S2 <= '0'; C2 <= '1';
            when "11011" => S1 <= '0'; S2 <= '1'; C2 <= '1';
            when "00111" => S1 <= '1'; S2 <= '0'; C2 <= '1';
            when "10111" => S1 <= '0'; S2 <= '1'; C2 <= '1';
            when "01111" => S1 <= '0'; S2 <= '1'; C2 <= '1';
            when "11111" => S1 <= '1'; S2 <= '1'; C2 <= '1';
            when others  => S1 <= 'X'; S2 <= 'X'; C2 <= 'X';
        end case;
    end process;
    
    DS1: TTLdelay 
        generic map(
            tPLH => tPLHS1,
            tPHL => tPHLS1
        )
        port map(
            A => S1,
            B => X_1
        );

    DS2: TTLdelay 
        generic map(
            tPLH => tPLHS2,
            tPHL => tPHLS2
        )
        port map(
            A => S2,
            B => X_12
        );

    DC2: TTLdelay 
        generic map(
            tPLH => tPLHC,
            tPHL => tPHLC
        )
        port map(
            A => C2,
            B => X_10
        );
end architecture BEHAV;

-----------------------------------------------------------------------
-- SN74LS83AN: 4-bit binary full adder (fast carry)
--             Verified 05/06/2016
-----------------------------------------------------------------------
library ieee;
    use ieee.std_logic_1164.all;
    use ieee.numeric_std.all;

    use work.LSTTL.all;
    use work.TTLPrivate.all;

entity SN74LS83AN is
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
end entity SN74LS83AN;

architecture BEHAV of SN74LS83AN is
    signal A, B, S : unsigned(4 downto 0);  -- S(4) = carry-out
    signal SUM     : unsigned(3 downto 0);
begin
    A <= ('0', X_1,  X_3, X_8, X_10);
    B <= ('0', X_16, X_4, X_7, X_11);
    
    S <= A + B + X_13;

    G: for i in SUM'range generate
    begin
    DSM: TTLdelay 
        generic map(
            tPLH => tPLHS,
            tPHL => tPHLS
        )
        port map(
            A => S(i),
            B => SUM(i)
        );
    end generate;
    
    DCY: TTLdelay 
        generic map(
            tPLH => tPLHC,
            tPHL => tPHLC
        )
        port map(
            A => S(4),
            B => X_14
        );
    
    (X_15, X_2, X_6, X_9) <= SUM;
end architecture BEHAV;

-----------------------------------------------------------------------
-- SN74LS85N: 4-bit magnitude comparator
--            Verified 06/06/2016
-----------------------------------------------------------------------
library ieee;
    use ieee.std_logic_1164.all;
    use ieee.numeric_std.all;

    use work.LSTTL.all;
    use work.TTLPrivate.all;

entity SN74LS85N is
generic(
    tPLH : time := 45 ns;    -- Worst-case values
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
end entity SN74LS85N;

architecture BEHAV of SN74LS85N is
    signal A, B       : unsigned(3 downto 0);
    signal LT, EQ, GT : std_logic;
    
    alias inLT is X_2;
    alias inEQ is X_3;
    alias inGT is X_4;
begin
    A <= (X_15, X_13, X_12, X_10);
    B <= (X_1,  X_14, X_11, X_9 );
    
    process(all) is
        variable INCOND : std_logic_vector(2 downto 0);
    begin
        LT <= '0';
        EQ <= '0';
        GT <= '0';
        
        if    A < B then 
            LT <= '1';
        elsif A > B then 
            GT <= '1';
        else
            INCOND := inGT & inLT & inEQ;
            case INCOND is
                when "100"  => GT <= '1';
                when "010"  => LT <= '1';
                when "000"  => GT <= '1'; LT <= '1';
                when "110"  => null;
                when others => EQ <= '1';
            end case;
        end if;
   end process;
    
    DCG: TTLdelay 
        generic map(
            tPLH => tPLH,
            tPHL => tPHL
        )
        port map(
            A => GT,
            B => X_5
        );
    
    DCL: TTLdelay 
        generic map(
            tPLH => tPLH,
            tPHL => tPHL
        )
        port map(
            A => LT,
            B => X_7
        );
    
    DCE: TTLdelay 
        generic map(
            tPLH => tPLH,
            tPHL => tPHL
        )
        port map(
            A => EQ,
            B => X_6
        );
    
end architecture BEHAV;

-----------------------------------------------------------------------
-- SN74LS86N: Quad 2-input xor gate
--            Verified 30/05/2016
-----------------------------------------------------------------------
library ieee;
    use ieee.std_logic_1164.all;

    use work.LSTTL.all;
    use work.TTLPrivate.all;

entity SN74LS86N is
generic(
    tPLH : time := 30 ns;
    tPHL : time := 22 ns
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
end entity SN74LS86N;

architecture BEHAV of SN74LS86N is
    signal A : TTLInputs (1 to 4, 1 to 2);
    signal Y : TTLOutputs(1 to 4);
  
begin
    A <= ( (X_1, X_2), (X_4, X_5), (X_9, X_10), (X_12, X_13) );
    
    (X_3, X_6, X_8, X_11) <= Y;
  
    G: TTLgate
    generic map(
        mode   => Zxor,     -- Zand, Zor, Zxor, Zbuf
        invert => '0',      -- '1' will invert the output
        ohigh  => '1',      -- '1' = normal, 'Z' = open collectors
        tPLH   => tPLH,
        tPHL   => tPHL
    )
    port map(
        ins   => A,
        outs  => Y
    );
  
end architecture BEHAV;

-----------------------------------------------------------------------
-- SN74H87N: 4-bit true/complement, zero-one element
--           Verified 06/06/2016
-----------------------------------------------------------------------
library ieee;
    use ieee.std_logic_1164.all;

    use work.LSTTL.all;
    use work.TTLPrivate.all;

entity SN74H87N is
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
end entity SN74H87N;

architecture BEHAV of SN74H87N is
    signal S1, S2, Z1 : std_logic;
    signal I,  X,  O  : std_logic_vector(4 downto 1);
begin
    I  <= (X_13, X_10, X_5, X_2);
    (X_12, X_9, X_6, X_3) <= O;
    S1 <= not Z1;
    
    DS1: TTLdelay 
    generic map(
        tPLH => tPLHS,
        tPHL => tPHLS
    )
    port map(
        A => X_8,
        B => Z1
    );
    
    DS2: TTLdelay 
    generic map(
        tPLH => tPLHS,
        tPHL => tPHLS
    )
    port map(
        A => X_1,
        B => S2
    );
        
    G: for j in I'range generate
    begin
        DI: TTLdelay 
        generic map(
            tPLH => tPLHI,
            tPHL => tPHLI
        )
        port map(
            A => I(j),
            B => X(j)
        );
        
        O(j) <= S2 xor (not(S1 and X(j)));

    end generate;
end architecture BEHAV;

-----------------------------------------------------------------------
-- SN74LS89N: 64-bit random-access memory (open collector)
--            Verified 06/06/2016
-----------------------------------------------------------------------
library ieee;
    use ieee.std_logic_1164.all;
    use ieee.std_logic_misc.all;
    use ieee.numeric_std.all;

    use work.LSTTL.all;
    use work.TTLPrivate.all;

entity SN74LS89N is
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
end entity SN74LS89N;

architecture BEHAV of SN74LS89N is    
    signal   RE, WE   : std_logic := '1';
    signal   IA       : std_logic_vector(3 downto 0) := (others => '0');
    signal   D, QB, Q : std_logic_vector(3 downto 0);
    constant UNK      : std_logic_vector(3 downto 0) := (others => 'X');
    signal   X, Y, Z  : std_logic;
begin
    RE   <= not(    X_3 and not X_2);
    WE   <= not(not X_3 and not X_2);
    IA   <=    (X_13, X_14, X_15, X_1);
    D    <=    (X_12, X_10, X_6,  X_4);
    
    X    <= X_2 and not X_3;                -- Undefined outputs
    Y    <= X after tREC;
    Z    <= X or Y;                         -- Illegal during this time

    -- UNK case is explicit in the datasheet
    (X_11, X_9, X_7, X_5) <= UNK when Z = '1' else Q;
    
    MB: TTLramblock
    generic map(
        Omode => OpenColl,
        INVT  => '1',
        tPLC  => tPLC,
        tPLA  => tPLA,
        tSUD  => tSUD,
        tSUA  => tSUA
    )         
    port map( 
        RA    => IA,
        WA    => IA,
        D     => D,
        O     => Q,
        CE    => '0',
        RE    => RE,
        WE    => WE
    );    
end architecture BEHAV;

-----------------------------------------------------------------------
-- SN74LS90AN: Decade counter (ripple)
--             Verified 30/05/2016
-----------------------------------------------------------------------
library ieee;
    use ieee.std_logic_1164.all;

    use work.LSTTL.all;
    use work.TTLPrivate.all;

entity SN74LS90AN is
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
end entity SN74LS90AN;

architecture BEHAV of SN74LS90AN is
    signal rst, set : std_logic;
    signal val      : std_logic_vector(3 downto 0);
begin
    rst <= not (X_2 and X_3);
    set <= not (X_6 and X_7);
    (X_11, X_8, X_9, X_12) <= val;
    
    M1: TTLcount4
    generic map(
        tPLH0   => tPLH0,
        tPHL0   => tPHL0,
        tPLH1   => tPLH1,
        tPHL1   => tPHL1,
        tPLH2   => tPLH2,
        tPHL2   => tPHL2,
        tPLH3   => tPLH3,
        tPHL3   => tPHL3,
        modulus => 10
    )
    port map(
        ld   => '1',
        d    => (others => '0'),
        clka => X_14,
        clkb => X_1,
        rst  => rst,
        set  => set,
        val  => val
    );
end architecture BEHAV;

-----------------------------------------------------------------------
-- SN74LS91AN: 8-bit shift register (Pinout A)
--             Verified 06/06/2016
-----------------------------------------------------------------------
library ieee;
    use ieee.std_logic_1164.all;

    use work.LSTTL.all;
    use work.TTLPrivate.all;

entity SN74LS91AN is
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
end entity SN74LS91AN;

architecture BEHAV of SN74LS91AN is
    signal REG    : std_logic_vector(7 downto 0);
    signal Q7, DI : std_logic;
    
    alias CP is X_9;
    
begin
    DI <= not(X_11 and X_12);
    
    OPD: TTLdelay
    generic map(
        tPLH => tPLH,
        tPHL => tPHL
    )
    port map(
        A => REG(7),
        B => Q7
    );
    
    X_13 <= Q7;
    X_14 <= not Q7;
    
    process(CP) is
    begin
        if CP'event and CP = '1' then
            assert DI'stable(tSU) report "Setup violation" severity failure;
            REG <= REG(6 downto 0) & DI;
        end if;
    end process;

end architecture BEHAV;

-----------------------------------------------------------------------
-- SN74LS92N: Divide-by-12 counter (ripple)
--            Verified 31/05/2016
-----------------------------------------------------------------------
library ieee;
    use ieee.std_logic_1164.all;

    use work.LSTTL.all;
    use work.TTLPrivate.all;

entity SN74LS92N is
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
end entity SN74LS92N;

architecture BEHAV of SN74LS92N is
    signal rst : std_logic;
    signal val : std_logic_vector(3 downto 0);
begin
    rst <= not (X_6 and X_7);
    (X_8, X_9, X_11, X_12) <= val;
    
    M1: TTLcount4
    generic map(
        tPLH0   => tPLH0,
        tPHL0   => tPHL0,
        tPLH1   => tPLH1,
        tPHL1   => tPHL1,
        tPLH2   => tPLH2,
        tPHL2   => tPHL2,
        tPLH3   => tPLH3,
        tPHL3   => tPHL3,
        modulus => 12
    )
    port map(
        ld   => '1',
        d    => (others => '0'),
        clka => X_14,
        clkb => X_1,
        rst  => rst,
        set  => '1',
        val  => val
    );
end architecture BEHAV;

-----------------------------------------------------------------------
-- SN74LS93N: Divide-by-16 (binary) counter (ripple)
--            Verified 31/05/2016
-----------------------------------------------------------------------
library ieee;
    use ieee.std_logic_1164.all;

    use work.LSTTL.all;
    use work.TTLPrivate.all;

entity SN74LS93N is
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
end entity SN74LS93N;

architecture BEHAV of SN74LS93N is
    signal rst : std_logic;
    signal val : std_logic_vector(3 downto 0);
begin
    rst <= not (X_2 and X_3);
    (X_11, X_8, X_9, X_12) <= val;
    
    M1: TTLcount4
    generic map(
        tPLH0   => tPLH0,
        tPHL0   => tPHL0,
        tPLH1   => tPLH1,
        tPHL1   => tPHL1,
        tPLH2   => tPLH2,
        tPHL2   => tPHL2,
        tPLH3   => tPLH3,
        tPHL3   => tPHL3,
        modulus => 16
    )
    port map(
        ld   => '1',
        d    => (others => '0'),
        clka => X_14,
        clkb => X_1,
        rst  => rst,
        set  => '1',
        val  => val
    );
end architecture BEHAV;

-----------------------------------------------------------------------
-- SN74LS94N: 4-bit shift register
--            Verified 07/06/2016
-----------------------------------------------------------------------
library ieee;
    use ieee.std_logic_1164.all;

    use work.LSTTL.all;
    use work.TTLPrivate.all;

entity SN74LS94N is
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
end entity SN74LS94N;

architecture BEHAV of SN74LS94N is
    signal REG, PL1, PL2 : std_logic_vector(3 downto 0);
    signal LD            : std_logic;
    alias  CLK is X_8;
    alias  CL  is X_10;
    alias  LD1 is X_6;
    alias  LD2 is X_15;
    alias  DS  is X_7;
begin
    PL1 <= (X_4,  X_3,  X_2,  X_1 );
    PL2 <= (X_11, X_13, X_14, X_16);
    LD  <= LD1 or LD2;
    
    process(CLK, CL, LD) is
    begin
        if    CL = '1' then
            REG <= (others => '0');
        elsif LD = '1' then
            for i in REG'range loop
                REG(i) <= REG(i) or (PL1(i) and LD1) or (PL2(i) and LD2);
            end loop;
        elsif CLK'event and CLK = '1' then
            assert DS'stable(tSU) report "Data setup violation" severity failure;
            REG <= REG(2 downto 0) & DS;
        end if; 
    end process;
    
    DO: TTLdelay
    generic map(
        tPLH => tPLH,
        tPHL => tPHL
    )
    port map(
        A => REG(3),
        B => X_9
    );
    
end architecture BEHAV;

-----------------------------------------------------------------------
-- SN74LS95N: 4-bit right/left shift register
--            Verified 07/06/2016
-----------------------------------------------------------------------
library ieee;
    use ieee.std_logic_1164.all;

    use work.LSTTL.all;
    use work.TTLPrivate.all;

entity SN74LS95N is
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
end entity SN74LS95N;

architecture BEHAV of SN74LS95N is
    signal P, REG, Q : std_logic_vector(3 downto 0);
    
    alias CP1 is X_9;
    alias CP2 is X_8;
    alias PE  is X_6;
    alias DS  is X_1;
    
begin
    P <= (X_5, X_4, X_3, X_2);
    (X_10, X_11, X_12, X_13) <= Q;
    
    process(CP1, CP2) is
    begin
        if CP2'event and CP2 = '0' and PE = '1' then
            assert P'stable(tSU) report "Setup violation: parallel" severity failure;
            REG <= P;
        elsif CP1'event and CP1 = '0' and PE = '0' then
            assert DS'stable(tSU) report "Setup violation: serial" severity failure;
            REG <= REG(2 downto 0) & DS;
        end if;
    end process;
    
    DO: TTLdelays
    generic map(
        tPLH => tPLH,
        tPHL => tPHL
    )
    port map(
        A => REG,
        B => Q
    );
end architecture BEHAV;

-----------------------------------------------------------------------
-- SN74LS96N: 5-bit shift register
--            Verified 07/06/2016
-----------------------------------------------------------------------
library ieee;
    use ieee.std_logic_1164.all;

    use work.LSTTL.all;
    use work.TTLPrivate.all;

entity SN74LS96N is
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
end entity SN74LS96N;

architecture BEHAV of SN74LS96N is
    signal REG, PL, Q : std_logic_vector(4 downto 0);
    alias  CLK is X_1;
    alias  CL  is X_16;
    alias  LD  is X_8;
    alias  DS  is X_9;
begin
    (X_10, X_11, X_13, X_14, X_15) <= Q;
    PL <= (X_7,  X_6,  X_4,  X_3, X_2 );
    
    process(CLK, CL, LD) is
    begin
        if    CL = '0' then
            REG <= (others => '0');
        elsif LD = '1' then
            REG <= REG or PL;
        elsif CLK'event and CLK = '1' then
            assert DS'stable(tSU) report "Data setup violation" severity failure;
            REG <= REG(3 downto 0) & DS;
        end if; 
    end process;
    
    DO: TTLdelays
    generic map(
        tPLH => tPLH,
        tPHL => tPHL
    )
    port map(
        A => REG,
        B => Q
    );
end architecture BEHAV;

-- SN74LS97N: Synchronous modulo-64 bit-rate multiplier

-----------------------------------------------------------------------
-- SN74100N: Dual 4-bit latch
--           Verified 07/06/2016
-----------------------------------------------------------------------
library ieee;
    use ieee.std_logic_1164.all;

    use work.LSTTL.all;
    use work.TTLPrivate.all;

entity SN74100N is
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
end entity SN74100N;

architecture BEHAV of SN74100N is
    subtype quad is std_logic_vector(4 downto 1);
    type  biquad is array(2 downto 1) of quad;
    
    signal D, R, Q : biquad;
    signal G       : std_logic_vector(2 downto 1);
    
begin
    G <= (X_12, X_23);
    D <= ((X_16, X_15, X_10, X_11), (X_21, X_22, X_3, X_2));
    (X_17, X_18, X_9, X_8) <= Q(2); 
    (X_20, X_19, X_4, X_5) <= Q(1);
    
    G1: for i in G'range generate
    begin
        process(G(i), D(i)) is
        begin
            if G(i) = '1' then
                R(i) <= D(i);
            end if;
        end process;

        DO: TTLdelays
        generic map(
            tPLH => tPLH,
            tPHL => tPHL
        )
        port map(
            A => R(i),
            B => Q(i)
        );
    end generate;
    
end architecture BEHAV;

-----------------------------------------------------------------------
-- SN74H101N: JK edge-triggered flipflop (with and-or inputs) (Pinout A)
--            Verified 01/06/2016
-----------------------------------------------------------------------
library ieee;
    use ieee.std_logic_1164.all;

    use work.LSTTL.all;
    use work.TTLPrivate.all;

entity SN74H101N is
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
end entity SN74H101N;

architecture BEHAV of SN74H101N is
    signal j, k, ns, nc : std_logic;
begin
    j  <= (X_1 and X_2 ) or (X_3  and X_4 );
    k  <= (X_9 and X_10) or (X_11 and X_12);
    ns <= not X_5;
    nc <= not X_13;
    
    FF: TTLflipflop
    generic map(
        tPLHCP  => tPLHCP,
        tPHLCP  => tPHLCP,
        tPLHSC  => tPLHSC,
        tPHLSC  => tPHLSC,
        tSETUP  => tSETUP,
        Safeclk => false
    )
    port map(
        J  => j,
        K  => k,
        C  => nc,
        S  => ns,
        R  => '0',
        Q  => X_6,
        QB => X_8
    );
end architecture BEHAV;

-----------------------------------------------------------------------
-- SN74H102N: JK edge-triggered flipflop (with and inputs) (Pinout A)
--            Verified 02/06/2016
-----------------------------------------------------------------------
library ieee;
    use ieee.std_logic_1164.all;

    use work.LSTTL.all;
    use work.TTLPrivate.all;

entity SN74H102N is
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
end entity SN74H102N;

architecture BEHAV of SN74H102N is
    signal j, k, nr, ns, nc : std_logic;
begin
    j  <= X_3 and X_4  and X_5 ;
    k  <= X_9 and X_10 and X_11;
    nr <= not X_2;
    ns <= not X_13;
    nc <= not X_12;
    
    FF: TTLflipflop
    generic map(
        tPLHCP  => tPLHCP,
        tPHLCP  => tPHLCP,
        tPLHSC  => tPLHSC,
        tPHLSC  => tPHLSC,
        tSETUP  => tSETUP,
        Safeclk => false
    )
    port map(
        J  => j,
        K  => k,
        C  => nc,
        S  => ns,
        R  => nr,
        Q  => X_8,
        QB => X_6
    );
end architecture BEHAV;

-----------------------------------------------------------------------
-- SN74H103N: Dual JK edge-triggered flipflop
--            Verified 02/06/2016
-----------------------------------------------------------------------
library ieee;
    use ieee.std_logic_1164.all;

    use work.LSTTL.all;
    use work.TTLPrivate.all;

entity SN74H103N is
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
end entity SN74H103N;

architecture BEHAV of SN74H103N is
    subtype Pair is std_logic_vector(0 to 1);
    signal C, J, K, R, Q, QB : Pair;
begin
    C <= (X_1,  X_5 );
    R <= (X_2,  X_6 );
    J <= (X_14, X_7 );
    K <= (X_3,  X_10);
    (X_12, X_9) <= Q;
    (X_13, X_8) <= QB;
    
    G1: for i in Pair'range generate
        signal nc, nr : std_logic;
    begin
        nc <= not C(i);
        nr <= not R(i);
    
        FF: TTLflipflop
        generic map(
            tPLHCP  => tPLHCP,
            tPHLCP  => tPHLCP,
            tPLHSC  => tPLHSC,
            tPHLSC  => tPHLSC,
            tSETUP  => tSETUP,
            Safeclk => false
        )
        port map(
            J  => J(i),
            K  => K(i),
            C  => nc,
            S  => '0',
            R  => nr,
            Q  => Q(i),
            QB => QB(i)
        );    
    end generate;
end architecture BEHAV;

-- SN74105N: JK flipflop with extra gating
 
-----------------------------------------------------------------------
-- SN74H106N: Dual JK edge-triggered flipflop
--            Verified 02/06/2016
-----------------------------------------------------------------------
library ieee;
    use ieee.std_logic_1164.all;

    use work.LSTTL.all;
    use work.TTLPrivate.all;

entity SN74H106N is
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
end entity SN74H106N;

architecture BEHAV of SN74H106N is
    subtype Pair is std_logic_vector(0 to 1);
    signal C, J, K, R, S, Q, QB : Pair;
begin
    C <= (X_1,  X_6 );
    R <= (X_3,  X_8 );
    S <= (X_2,  X_7 );
    J <= (X_4,  X_9 );
    K <= (X_16, X_12);
    (X_15, X_11) <= Q;
    (X_14, X_10) <= QB;
    
    G1: for i in Pair'range generate
        signal nc, ns, nr : std_logic;
    begin
        nc <= not C(i);
        nr <= not R(i);
        ns <= not S(i);
    
        FF: TTLflipflop
        generic map(
            tPLHCP  => tPLHCP,
            tPHLCP  => tPHLCP,
            tPLHSC  => tPLHSC,
            tPHLSC  => tPHLSC,
            tSETUP  => tSETUP,
            Safeclk => false
        )
        port map(
            J  => J(i),
            K  => K(i),
            C  => nc,
            S  => ns,
            R  => nr,
            Q  => Q(i),
            QB => QB(i)
        );    
    end generate;
end architecture BEHAV;

-----------------------------------------------------------------------
-- SN74LS107N: Dual JK flipflop
--             Verified 02/06/2016
-----------------------------------------------------------------------
library ieee;
    use ieee.std_logic_1164.all;

    use work.LSTTL.all;
    use work.TTLPrivate.all;

entity SN74LS107N is
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
end entity SN74LS107N;

architecture BEHAV of SN74LS107N is
    subtype Pair is std_logic_vector(0 to 1);
    signal C, J, K, R, Q, QB : Pair;
begin
    C <= (X_12, X_9 );
    R <= (X_13, X_10);
    J <= (X_1,  X_8 );
    K <= (X_4,  X_11);
    (X_3, X_5) <= Q;
    (X_2, X_6) <= QB;
    
    G1: for i in Pair'range generate
        signal nc, nr : std_logic;
    begin
        nc <= not C(i);
        nr <= not R(i);
    
        FF: TTLflipflop
        generic map(
            tPLHCP  => tPLHCP,
            tPHLCP  => tPHLCP,
            tPLHSC  => tPLHSC,
            tPHLSC  => tPHLSC,
            tSETUP  => tSETUP,
            Safeclk => false
        )
        port map(
            J  => J(i),
            K  => K(i),
            C  => nc,
            S  => '0',
            R  => nr,
            Q  => Q(i),
            QB => QB(i)
        );    
    end generate;
end architecture BEHAV;

-----------------------------------------------------------------------
-- SN74H108N: Dual JK edge-triggered flipflop
--            Verified 02/06/2016
-----------------------------------------------------------------------
library ieee;
    use ieee.std_logic_1164.all;

    use work.LSTTL.all;
    use work.TTLPrivate.all;

entity SN74H108N is
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
end entity SN74H108N;

architecture BEHAV of SN74H108N is
    subtype Pair is std_logic_vector(0 to 1);
    signal J, K, S, Q, QB : Pair;
begin
    S <= (X_13, X_10);
    J <= (X_4,  X_11);
    K <= (X_1,  X_8 );
    (X_2, X_6) <= Q;
    (X_3, X_5) <= QB;
    
    G1: for i in Pair'range generate
        signal nc, nr, ns : std_logic;
    begin
        nc <= not X_9;
        nr <= not X_12;
        ns <= not S(i);
    
        FF: TTLflipflop
        generic map(
            tPLHCP  => tPLHCP,
            tPHLCP  => tPHLCP,
            tPLHSC  => tPLHSC,
            tPHLSC  => tPHLSC,
            tSETUP  => tSETUP,
            Safeclk => false
        )
        port map(
            J  => J(i),
            K  => K(i),
            C  => nc,
            S  => ns,
            R  => nr,
            Q  => Q(i),
            QB => QB(i)
        );    
    end generate;
end architecture BEHAV;

-----------------------------------------------------------------------
-- SN74LS109N: Dual JK +ve edge-triggered flipflop
--             Verified 04/06/2016
-----------------------------------------------------------------------
library ieee;
    use ieee.std_logic_1164.all;

    use work.LSTTL.all;
    use work.TTLPrivate.all;

entity SN74LS109N is
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
end entity SN74LS109N;

architecture BEHAV of SN74LS109N is
    subtype Pair is std_logic_vector(0 to 1);
    signal C, J, K, R, S, Q, QB : Pair;
begin
    C <= (X_4,  X_12);
    R <= (X_1,  X_15);
    S <= (X_5,  X_11);
    J <= (X_2,  X_14);
    K <= (X_3,  X_13);
    (X_6, X_10) <= Q;
    (X_7, X_9 ) <= QB;
    
    G1: for i in Pair'range generate
        signal kb, nr, ns : std_logic;
    begin
        nr <= not R(i);
        ns <= not S(i);
        kb <= not K(i);
    
        FF: TTLflipflop
        generic map(
            tPLHCP  => tPLHCP,
            tPHLCP  => tPHLCP,
            tPLHSC  => tPLHSC,
            tPHLSC  => tPHLSC,
            tSETUP  => tSETUP,
            Safeclk => false
        )
        port map(
            J  => J(i),
            K  => kb,
            C  => C(i),
            S  => ns,
            R  => nr,
            Q  => Q(i),
            QB => QB(i)
        );    
    end generate;
end architecture BEHAV;

-----------------------------------------------------------------------
-- SN74LS112N: Dual JK -ve edge-triggered flipflop
--             Verified 04/06/2016
-----------------------------------------------------------------------
library ieee;
    use ieee.std_logic_1164.all;

    use work.LSTTL.all;
    use work.TTLPrivate.all;

entity SN74LS112N is
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
end entity SN74LS112N;

architecture BEHAV of SN74LS112N is
    subtype Pair is std_logic_vector(0 to 1);
    signal C, J, K, R, S, Q, QB : Pair;
begin
    C <= (X_1,  X_13);
    R <= (X_15, X_14);
    S <= (X_4,  X_10);
    J <= (X_3,  X_11);
    K <= (X_2,  X_12);
    (X_5, X_9) <= Q;
    (X_6, X_7) <= QB;
    
    G1: for i in Pair'range generate
        signal nc, nr, ns : std_logic;
    begin
        nc <= not C(i);
        nr <= not R(i);
        ns <= not S(i);
    
        FF: TTLflipflop
        generic map(
            tPLHCP  => tPLHCP,
            tPHLCP  => tPHLCP,
            tPLHSC  => tPLHSC,
            tPHLSC  => tPHLSC,
            tSETUP  => tSETUP,
            Safeclk => false
        )
        port map(
            J  => J(i),
            K  => K(i),
            C  => nc,
            S  => ns,
            R  => nr,
            Q  => Q(i),
            QB => QB(i)
        );    
    end generate;
end architecture BEHAV;

-----------------------------------------------------------------------
-- SN74LS113N: Dual JK edge-triggered flipflop
--             Verified 04/06/2016
-----------------------------------------------------------------------
library ieee;
    use ieee.std_logic_1164.all;

    use work.LSTTL.all;
    use work.TTLPrivate.all;

entity SN74LS113N is
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
end entity SN74LS113N;

architecture BEHAV of SN74LS113N is
    subtype Pair is std_logic_vector(0 to 1);
    signal C, J, K, S, Q, QB : Pair;
begin
    C <= (X_1,  X_13);
    S <= (X_4,  X_10);
    J <= (X_3,  X_11);
    K <= (X_2,  X_12);
    (X_5, X_9) <= Q;
    (X_6, X_8) <= QB;
    
    G1: for i in Pair'range generate
        signal nc, ns : std_logic;
    begin
        nc <= not C(i);
        ns <= not S(i);
    
        FF: TTLflipflop
        generic map(
            tPLHCP  => tPLHCP,
            tPHLCP  => tPHLCP,
            tPLHSC  => tPLHSC,
            tPHLSC  => tPHLSC,
            tSETUP  => tSETUP,
            Safeclk => false
        )
        port map(
            J  => J(i),
            K  => K(i),
            C  => nc,
            S  => ns,
            R  => '0',
            Q  => Q(i),
            QB => QB(i)
        );    
    end generate;
end architecture BEHAV;

-----------------------------------------------------------------------
-- SN74LS114N: Dual JK -ve edge-triggered flipflop
--             Verified 04/06/2016
-----------------------------------------------------------------------
library ieee;
    use ieee.std_logic_1164.all;

    use work.LSTTL.all;
    use work.TTLPrivate.all;

entity SN74LS114N is
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
end entity SN74LS114N;

architecture BEHAV of SN74LS114N is
    subtype Pair is std_logic_vector(0 to 1);
    signal J, K, S, Q, QB : Pair;
begin
    S <= (X_4,  X_10);
    J <= (X_3,  X_11);
    K <= (X_2,  X_12);
    (X_5, X_9) <= Q;
    (X_6, X_8) <= QB;
    
    G1: for i in Pair'range generate
        signal nc, nr, ns : std_logic;
    begin
        nc <= not X_13;
        ns <= not S(i);
        nr <= not X_1;
    
        FF: TTLflipflop
        generic map(
            tPLHCP  => tPLHCP,
            tPHLCP  => tPHLCP,
            tPLHSC  => tPLHSC,
            tPHLSC  => tPHLSC,
            tSETUP  => tSETUP,
            Safeclk => false
        )
        port map(
            J  => J(i),
            K  => K(i),
            C  => nc,
            S  => ns,
            R  => nr,
            Q  => Q(i),
            QB => QB(i)
        );    
    end generate;
end architecture BEHAV;

-----------------------------------------------------------------------
-- SN74121N: Monostable multivibrator
--           Tw = 0.69 * R * C
--           Verified 04/06/2016
-----------------------------------------------------------------------
library ieee;
    use ieee.std_logic_1164.all;
    use ieee.std_logic_misc.all;

    use work.LSTTL.all;
    use work.TTLPrivate.all;

entity SN74121N is
generic(
    W    : time := 100 us    -- Pulse width
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
end entity SN74121N;

architecture BEHAV of SN74121N is
    constant tD : time :=  80 ns;   -- Trigger delay from input
    constant mt : time :=  50 ns;   -- Minimum trigger width

    signal trig, Q : std_logic;
begin
    trig <= X_5 and nand_reduce(X_3 & X_4) after tD;
    
    MS: TTLmonostable
    generic map(
        pwidth        => W,   -- Triggered pulse width
        mintrig       => mt,  -- Minimum trigger width
        retriggerable => false
    )
    port map(
        trig  => trig,
        reset => '0',
        Q     => Q
    );
    
    X_6 <= Q;
    X_1 <= not Q;

end architecture BEHAV;

-----------------------------------------------------------------------
-- SN74122N: Retriggerable resettable monostable multivibrator
--           Tw = 0.32 * R * X * (1.0 + 0.7/R)
--           Verified 04/06/2016
-----------------------------------------------------------------------
library ieee;
    use ieee.std_logic_1164.all;
    use ieee.std_logic_misc.all;

    use work.LSTTL.all;
    use work.TTLPrivate.all;

entity SN74122N is
generic(
    W    : time := 100 us    -- Pulse width
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
end entity SN74122N;

architecture BEHAV of SN74122N is
    constant tD : time :=  40 ns;   -- Trigger delay from input
    constant mt : time :=  40 ns;   -- Minimum trigger width
    
    signal trig, NR, Q : std_logic;
begin
    trig <= and_reduce(X_3 & X_4 & X_5 & nand_reduce(X_1 & X_2)) after tD;
    NR   <= not X_5;
    
    MS: TTLmonostable
    generic map(
    pwidth        =>  W,  -- Triggered pulse width
    mintrig       => mt,  -- Minimum trigger width
    retriggerable => true
    )
    port map(
        trig  => trig,
        reset => NR,
        Q     => Q
    );
    
    X_8 <= Q;
    X_6 <= not Q;

end architecture BEHAV;

-----------------------------------------------------------------------
-- SN74123N: Dual retriggerable resettable monostable multivibrator
--           Tw = 0.28 * R * C * (1.0 + 0.7/R)
--           Verified 04/06/2016
-----------------------------------------------------------------------
library ieee;
    use ieee.std_logic_1164.all;
    use ieee.std_logic_misc.all;

    use work.LSTTL.all;
    use work.TTLPrivate.all;

entity SN74123N is
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
end entity SN74123N;

architecture BEHAV of SN74123N is
    constant tD : time :=  40 ns;   -- Trigger delay from input
    constant mt : time :=  40 ns;   -- Minimum trigger width
    
    signal trig, NR, Q : std_logic_vector(2 downto 1);
    
    type Widths is array(2 downto 1) of time;
    constant pw : Widths := (W1, W2);
begin
    NR(1)   <= not X_3;
    trig(1) <= and_reduce(X_3  & X_2  & (not X_1)) after tD;
    NR(2)   <= not X_11;
    trig(2) <= and_reduce(X_11 & X_10 & (not X_9)) after tD;

    GN: for i in trig'range generate
    begin
        MS: TTLmonostable
        generic map(
            pwidth        => pw(i),  -- Triggered pulse width
            mintrig       =>    mt,  -- Minimum trigger width
            retriggerable => true
        )
        port map(
            trig  => trig(i),
            reset => NR(i),
            Q     => Q(i)
        );
    end generate;
    
    X_13 <= Q(1);
    X_4  <= not Q(1);
    X_5  <= Q(2);
    X_12 <= not Q(2);

end architecture BEHAV;

-----------------------------------------------------------------------
-- SN74LS125N: Quad bus buffer (3-state outputs)
--             Verified 07/06/2016
-----------------------------------------------------------------------
library ieee;
    use ieee.std_logic_1164.all;

    use work.LSTTL.all;
    use work.TTLPrivate.all;

entity SN74LS125N is
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
end entity SN74LS125N;

architecture BEHAV of SN74LS125N is
    subtype quad is std_logic_vector(3 downto 0);
    signal  D, E, Q, X : quad;
begin
    D <= (X_12, X_9,  X_5, X_2);
    E <= (X_13, X_10, X_4, X_1);
    (X_11, X_8, X_6, X_3) <= Q;
    
    G1: for i in D'range generate
    begin
        X(i) <= D(i) when E(i) = '0' else 'Z';
        
        process(X(i)) is
            variable Z : std_logic_vector(1 downto 0);
        begin
            if X(i)'event then
                Z(1) := X(i)'last_value;
                Z(0) := X(i);
                case Z is
                    when "01"   => Q(i) <= 'X', X(i) after tPLH;
                    when "10"   => Q(i) <= 'X', X(i) after tPHL;
                    when "0Z"   => Q(i) <= 'X', X(i) after tPLZ;
                    when "1Z"   => Q(i) <= 'X', X(i) after tPHZ;
                    when "Z0"   => Q(i) <= 'X', X(i) after tPLE;
                    when "Z1"   => Q(i) <= 'X', X(i) after tPHE;
                    when others => Q(i) <= 'X', X(i) after tPHL;
                end case;
            end if;
        end process;
    end generate;

end architecture BEHAV;

-----------------------------------------------------------------------
-- SN74LS126N: Quad bus buffer (3-state outputs)
--             Verified 07/06/2016
-----------------------------------------------------------------------
library ieee;
    use ieee.std_logic_1164.all;

    use work.LSTTL.all;
    use work.TTLPrivate.all;

entity SN74LS126N is
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
end entity SN74LS126N;

architecture BEHAV of SN74LS126N is
    subtype quad is std_logic_vector(3 downto 0);
    signal  D, E, Q, X : quad;
begin
    D <= (X_12, X_9,  X_5, X_2);
    E <= (X_13, X_10, X_4, X_1);
    (X_11, X_8, X_6, X_3) <= Q;
    
    G1: for i in D'range generate
    begin
        X(i) <= D(i) when E(i) = '1' else 'Z';
        
        process(X(i)) is
            variable Z : std_logic_vector(1 downto 0);
        begin
            if X(i)'event then
                Z(1) := X(i)'last_value;
                Z(0) := X(i);
                case Z is
                    when "01"   => Q(i) <= 'X', X(i) after tPLH;
                    when "10"   => Q(i) <= 'X', X(i) after tPHL;
                    when "0Z"   => Q(i) <= 'X', X(i) after tPLZ;
                    when "1Z"   => Q(i) <= 'X', X(i) after tPHZ;
                    when "Z0"   => Q(i) <= 'X', X(i) after tPLE;
                    when "Z1"   => Q(i) <= 'X', X(i) after tPHE;
                    when others => Q(i) <= 'X', X(i) after tPHL;
                end case;
            end if;
        end process;
    end generate;
end architecture BEHAV;

-----------------------------------------------------------------------
-- SN74LS132N: Quad 2-input Schmitt trigger NAND gate
--             Verified 30/05/2016
-----------------------------------------------------------------------
library ieee;
    use ieee.std_logic_1164.all;

    use work.LSTTL.all;
    use work.TTLPrivate.all;

entity SN74LS132N is
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
end entity SN74LS132N;

architecture BEHAV of SN74LS132N is
    signal A : TTLInputs (1 to 4, 1 to 2);
    signal Y : TTLOutputs(1 to 4);
  
begin
    A <= ( (X_1, X_2), (X_4, X_5), (X_9, X_10), (X_12, X_13) );
    
    (X_3, X_6, X_8, X_11) <= Y;
  
    G: TTLgate
    generic map(
        mode   => Zand,     -- Zand, Zor, Zxor, Zbuf
        invert => '1',      -- '1' will invert the output
        ohigh  => '1',      -- '1' = normal, 'Z' = open collectors
        tPLH   => tPLH,
        tPHL   => tPHL
    )
    port map(
        ins   => A,
        outs  => Y
    );
  
end architecture BEHAV;

-----------------------------------------------------------------------
-- SN74LS133N: 13-input NAND gate
--             Verified 05/06/2016
-----------------------------------------------------------------------
library ieee;
    use ieee.std_logic_1164.all;

    use work.LSTTL.all;
    use work.TTLPrivate.all;

entity SN74LS133N is
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
end entity SN74LS133N;

architecture BEHAV of SN74LS133N is
    signal A : TTLInputs (1 to 1, 1 to 13);
    signal Y : TTLOutputs(1 to 1);
  
begin
    A(1,1)  <= X_1;         -- Can't use aggregates with single gate
    A(1,2)  <= X_2;
    A(1,3)  <= X_3;
    A(1,4)  <= X_4;
    A(1,5)  <= X_5;
    A(1,6)  <= X_6;
    A(1,7)  <= X_7;
    A(1,8)  <= X_10;
    A(1,9)  <= X_11;
    A(1,10) <= X_12;
    A(1,11) <= X_13;
    A(1,12) <= X_14;
    A(1,13) <= X_15;
    
    X_9 <= Y(1);            -- Output
  
    G: TTLgate
    generic map(
        mode   => Zand,     -- Zand, Zor, Zxor, Zbuf
        invert => '1',      -- '1' will invert the output
        ohigh  => '1',      -- '1' = normal, 'Z' = open collectors
        tPLH   => tPLH,
        tPHL   => tPHL
    )
    port map(
        ins   => A,
        outs  => Y
    );
  
end architecture BEHAV;

-----------------------------------------------------------------------
-- SN74S134N: 12-input NAND gate (3-state output)
--            Verified 05/06/2016
-----------------------------------------------------------------------
library ieee;
    use ieee.std_logic_1164.all;
    use ieee.std_logic_misc.all;

    use work.LSTTL.all;
    use work.TTLPrivate.all;

entity SN74S134N is
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
end entity SN74S134N;

architecture BEHAV of SN74S134N is
    signal X, Y, EB : std_logic;
begin
    X  <= nand_reduce( X_1  & X_2  & X_3  & X_4  & X_5  & X_6  & 
                       X_7  & X_10 & X_11 & X_12 & X_13 & X_14 );
    EB <= not X_15;
    
    B1: TTL3State    
    generic map(
        tPLH => tPLH,
        tPHL => tPHL,
        tPZH => tPZH,
        tPZL => tPZL,
        tPHZ => tPHZ,
        tPLZ => tPLZ
    )
    port map(
        A  => X,
        E  => EB,
        Y  => X_9
    );

end architecture BEHAV;

-----------------------------------------------------------------------
-- SN74S135N: Quad XOR/NOR gate
--            Verified 05/06/2016
-----------------------------------------------------------------------
library ieee;
    use ieee.std_logic_1164.all;

    use work.LSTTL.all;
    use work.TTLPrivate.all;

entity SN74S135N is
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
end entity SN74S135N;

architecture BEHAV of SN74S135N is
begin
    X_3  <= X_4  xor (X_1  xor X_2 ) after tPXX;
    X_7  <= X_4  xor (X_5  xor X_6 ) after tPXX;
    X_9  <= X_12 xor (X_10 xor X_11) after tPXX;
    X_13 <= X_12 xor (X_14 xor X_15) after tPXX;
end architecture BEHAV;

-----------------------------------------------------------------------
-- SN74LS136N: Quad 2-input xor gate (open collector)
--             Verified 30/05/2016
-----------------------------------------------------------------------
library ieee;
    use ieee.std_logic_1164.all;

    use work.LSTTL.all;
    use work.TTLPrivate.all;

entity SN74LS136N is
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
end entity SN74LS136N;

architecture BEHAV of SN74LS136N is
    signal A : TTLInputs (1 to 4, 1 to 2);
    signal Y : TTLOutputs(1 to 4);
  
begin
    A <= ( (X_1, X_2), (X_4, X_5), (X_9, X_10), (X_12, X_13) );
    
    (X_3, X_6, X_8, X_11) <= Y;
  
    G: TTLgate
    generic map(
        mode   => Zxor,     -- Zand, Zor, Zxor, Zbuf
        invert => '0',      -- '1' will invert the output
        ohigh  => 'Z',      -- '1' = normal, 'Z' = open collectors
        tPLH   => tPLH,
        tPHL   => tPHL
    )
    port map(
        ins   => A,
        outs  => Y
    );
  
end architecture BEHAV;

-----------------------------------------------------------------------
-- SN74LS137N: 1-of-8 decoder/demultiplexer (input latches)
--             Verified 08/06/2016
-----------------------------------------------------------------------
library ieee;
    use ieee.std_logic_1164.all;
    use ieee.std_logic_misc.all;
    use ieee.numeric_std.all;

    use work.LSTTL.all;
    use work.TTLPrivate.all;

entity SN74LS137N is
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
end entity SN74LS137N;

architecture BEHAV of SN74LS137N is
    signal chn  : natural range 7 downto 0;
    signal Q, O : std_logic_vector(7 downto 0);
    signal A    : unsigned(2 downto 0);
    signal EN   : std_logic;
    
    alias LE is X_4;

begin
    A  <= (X_3, X_2, X_1);
    EN <= X_6 and not X_5;
    (X_7, X_9, X_10, X_11, X_12, X_13, X_14, X_15) <= O;
    
    process(A, LE) is
    begin
        if LE = '0' then
            chn <= TTL_to_integer(A); 
        end if;
    end process;
    
    process(chn, EN) is
    begin
        Q <= (others => '1');
        Q(chn) <= not EN;
    end process;
    
    OD: TTLdelays 
    generic map(
        tPLH => tPLH,
        tPHL => tPHL
    )
    port map(
        A => Q,
        B => O
    );
    
end architecture BEHAV;

-----------------------------------------------------------------------
-- SN74LS138N: 1-of-8 decoder/demultiplexer
--             Verified 08/06/2016
-----------------------------------------------------------------------
library ieee;
    use ieee.std_logic_1164.all;
    use ieee.std_logic_misc.all;
    use ieee.numeric_std.all;

    use work.LSTTL.all;
    use work.TTLPrivate.all;

entity SN74LS138N is
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
end entity SN74LS138N;

architecture BEHAV of SN74LS138N is
    signal Q, O : std_logic_vector(7 downto 0);
    signal A    : unsigned(2 downto 0);
    signal EN   : std_logic;
    
begin
    A  <= (X_3, X_2, X_1);
    EN <= X_6 and (not X_5) and not (X_4);
    (X_7, X_9, X_10, X_11, X_12, X_13, X_14, X_15) <= O;
    
    process(A, EN) is
        variable chn : natural range 7 downto 0;
    begin
        Q <= (others => '1');
        if EN = '1' then
            chn    := TTL_to_integer(A); 
            Q(chn) <= '0';
        end if;
    end process;
    
    OD: TTLdelays 
    generic map(
        tPLH => tPLH,
        tPHL => tPHL
    )
    port map(
        A => Q,
        B => O
    );
    
end architecture BEHAV;

-----------------------------------------------------------------------
-- SN74LS139N: Dual 1-of-4 decoder
--             Verified 09/06/2016
-----------------------------------------------------------------------
library ieee;
    use ieee.std_logic_1164.all;
    use ieee.std_logic_misc.all;
    use ieee.numeric_std.all;

    use work.LSTTL.all;
    use work.TTLPrivate.all;

entity SN74LS139N is
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
end entity SN74LS139N;

architecture BEHAV of SN74LS139N is
    signal A    : std_logic_vector(3 downto 0);
    signal E    : std_logic_vector(1 downto 0);
    signal Q, Z : std_logic_vector(7 downto 0);

begin
    A <= (X_13, X_14, X_3, X_2);
    E <= (X_15, X_1);
    (X_9, X_10, X_11, X_12, X_7, X_6,  X_5,  X_4) <= Q;
    
    process(A, E) is
        variable AA : unsigned(1 downto 0);
        variable N  : natural range 3 downto 0;
        variable QQ : std_logic_vector(3 downto 0);
    begin
        for i in E'range loop
            QQ    := (others => '1');
            if E(i) = '0' then
                AA    := unsigned(A((2*i)+1 downto (2*i)));
                N     := TTL_to_integer(AA);
                QQ(N) := '0';
            end if;
            Z((4*i)+3 downto (4*i)) <= QQ;
        end loop;
    end process;
    
    GD: for i in Q'range generate
    begin
        OD: TTLdelays 
        generic map(
            tPLH => tPLH,
            tPHL => tPHL
        )
        port map(
            A => Z,
            B => Q
        );
    end generate;
end architecture BEHAV;

-----------------------------------------------------------------------
-- SN74S140N: Dual 4-input NAND line driver
--            Verified 09/06/2016
-----------------------------------------------------------------------
library ieee;
    use ieee.std_logic_1164.all;

    use work.LSTTL.all;
    use work.TTLPrivate.all;

entity SN74S140N is
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
end entity SN74S140N;

architecture BEHAV of SN74S140N is
    signal A : TTLInputs (1 to 2, 1 to 4);
    signal Y : TTLOutputs(1 to 2);
  
begin
    A <= ( (X_1, X_2, X_4, X_5), (X_9, X_10, X_12, X_13) );
    
    (X_6, X_8) <= Y;
  
    G: TTLgate
    generic map(
        mode   => Zand,     -- Zand, Zor, Zxor, Zbuf
        invert => '1',      -- '1' will invert the output
        ohigh  => '1',      -- '1' = normal, 'Z' = open collectors
        tPLH   => tPLH,
        tPHL   => tPHL
    )
    port map(
        ins   => A,
        outs  => Y
    );
end architecture BEHAV;

-- SN74LS141N: 1-of-10 Nixie decoder/driver (open collector)

-----------------------------------------------------------------------
-- SN74145N: 1-of-10 decoder/driver (open collector)
--           Verified 09/06/2016
-----------------------------------------------------------------------
library ieee;
    use ieee.std_logic_1164.all;
    use ieee.std_logic_misc.all;
    use ieee.numeric_std.all;

    use work.LSTTL.all;
    use work.TTLPrivate.all;

entity SN74145N is
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
end entity SN74145N;

architecture BEHAV of SN74145N is
    signal OP, Y, Z : std_logic_vector(15 downto 0);
begin
    process(all) is
    variable AT : unsigned(3 downto 0);
    variable AD :  natural range(OP'range);
    begin
        AT := (X_12 & X_13 & X_14 & X_15);
        AD := TTL_to_integer(AT);
        OP <= (others => '1');
        OP(AD) <= '0';
    end process;
    
    G1: for i in OP'range generate
    begin
        DL: TTLdelay
        generic map(
            tPLH => tPLH,
            tPHL => tPHL
        )
        port map(
            A => OP(i),
            B => Y(i)
        );
        
        Z(i) <= '0' when Y(i) = '0' else 'Z';       -- Open collectors
    end generate;
    
    ( X_11, X_10, X_9, X_7, X_6, X_5, X_4, X_3, X_2, X_1 ) <= Z(9 downto 0);
    
end architecture BEHAV;

-----------------------------------------------------------------------
-- SN74150N: 16-input multiplexer
--           Verified 09/06/2016
-----------------------------------------------------------------------
library ieee;
    use ieee.std_logic_1164.all;
    use ieee.std_logic_misc.all;
    use ieee.numeric_std.all;

    use work.LSTTL.all;
    use work.TTLPrivate.all;

entity SN74150N is
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
end entity SN74150N;

architecture BEHAV of SN74150N is
    signal D : std_logic_vector(15 downto 0);
    signal A : unsigned(3 downto 0);
    signal Q : std_logic;
    
begin
    A <= (X_11, X_13, X_14, X_15);
    D <= (X_16, X_17, X_18, X_19, X_20, X_21, X_22, X_23,
          X_1,  X_2,  X_3,  X_4,  X_5,  X_6,  X_7,  X_8 );
    
    Q <= D(TTL_to_integer(A)) or X_9;
        
    OD: TTLdelay 
    generic map(
        tPLH => tPLH,
        tPHL => tPHL
    )
    port map(
        A => Q,
        B => X_10
    );
end architecture BEHAV;

-----------------------------------------------------------------------
-- SN74LS151N: 8-input multiplexer
--             Verified 09/06/2016
-----------------------------------------------------------------------
library ieee;
    use ieee.std_logic_1164.all;
    use ieee.std_logic_misc.all;
    use ieee.numeric_std.all;

    use work.LSTTL.all;
    use work.TTLPrivate.all;

entity SN74LS151N is
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
end entity SN74LS151N;

architecture BEHAV of SN74LS151N is
    signal D     : std_logic_vector(7 downto 0);
    signal A     : unsigned(2 downto 0);
    signal Q, QB : std_logic;
    
begin
    A <= (X_9, X_10, X_11);
    D <= (X_12,  X_13,  X_14,  X_15,  X_1,  X_2,  X_3,  X_4 );
    
    QB <= X_7 or not D(TTL_to_integer(A));
    Q  <= not QB;
        
    OQ: TTLdelay 
    generic map(
        tPLH => tPLHZ,
        tPHL => tPHLZ
    )
    port map(
        A => Q,
        B => X_5
    );
    
    OQB: TTLdelay 
    generic map(
        tPLH => tPLHZB,
        tPHL => tPHLZB
    )
    port map(
        A => QB,
        B => X_6
    );
end architecture BEHAV;

-- SN74LS152N: 8-input multiplexer (flatpack only, no DIP)

-----------------------------------------------------------------------
-- SN74LS153N: Dual 4-input multiplexer (common selects)
--             Verified 09/06/2016
-----------------------------------------------------------------------
library ieee;
    use ieee.std_logic_1164.all;
    use ieee.std_logic_misc.all;
    use ieee.numeric_std.all;

    use work.LSTTL.all;
    use work.TTLPrivate.all;

entity SN74LS153N is
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
end entity SN74LS153N;

architecture BEHAV of SN74LS153N is
    signal D : TTLInputs(2 downto 1, 4 downto 1);
    signal A : unsigned(2 downto 1);
    signal E : std_logic_vector(2 downto 1);        -- Enables: B:A channels
    signal Q : std_logic_vector(2 downto 1);
    signal C : natural range 4 downto 1;
    
begin
    A <= (X_2,  X_14);
    C <= 1+TTL_to_integer(A);
    E <= (X_15, X_1 );
    D <= ((X_13,  X_12,  X_11,  X_10), (X_3,  X_4,  X_5,  X_6));
    (X_9, X_7) <= Q;
    
    G: for i in E'range generate
        signal Z : std_logic;
    begin
        Z <= (not E(i)) and D(i,C);
        
        OQ: TTLdelay 
        generic map(
            tPLH => tPLH,
            tPHL => tPHL
        )
        port map(
            A => Z,
            B => Q(i)
        );
    end generate;
end architecture BEHAV;

-----------------------------------------------------------------------
-- SN74154N: 1-of-16 decoder/demultiplexer
--           Verified 09/06/2016
-----------------------------------------------------------------------
library ieee;
    use ieee.std_logic_1164.all;
    use ieee.std_logic_misc.all;
    use ieee.numeric_std.all;

    use work.LSTTL.all;
    use work.TTLPrivate.all;

entity SN74154N is
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
end entity SN74154N;

architecture BEHAV of SN74154N is
    signal Q, Z : std_logic_vector(15 downto 0);
    signal A    : unsigned(3 downto 0);
    signal E    : std_logic;
    
begin
    A <= (X_20, X_21, X_22, X_23);
    E <= X_18 or X_19;
    (X_17, X_16, X_15, X_14, X_13, X_11, X_10, X_9,
     X_8,  X_7,  X_6,  X_5,  X_4,  X_3,  X_2,  X_1) <= Q;
    
    process(A, E) is
    begin
        Z <= (others => '1');
        Z(TTL_to_integer(A)) <= E;
    end process;
    
    OQ: TTLdelays 
    generic map(
        tPLH => tPLH,
        tPHL => tPHL
    )
    port map(
        A => Z,
        B => Q
    );
end architecture BEHAV;

-----------------------------------------------------------------------
-- SN74LS155N: Dual 1-of-4 decoder/demultiplexer
--             Verified 10/06/2016
-----------------------------------------------------------------------
library ieee;
    use ieee.std_logic_1164.all;
    use ieee.std_logic_misc.all;
    use ieee.numeric_std.all;

    use work.LSTTL.all;
    use work.TTLPrivate.all;

entity SN74LS155N is
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
end entity SN74LS155N;

architecture BEHAV of SN74LS155N is
    signal A    : unsigned(1 downto 0);
    signal E    : std_logic_vector(1 downto 0);
    signal Q, Z : std_logic_vector(7 downto 0);
    signal N    : natural range 3 downto 0;

begin
    A <= (X_3, X_13);
    N <= TTL_to_integer(A);
    E <= (not(X_14 or X_15), X_1 and not X_2);
    (X_12, X_11, X_10, X_9, X_4, X_5, X_6, X_7) <= Q;
    
    process(N, E) is
    begin
        Z <= (others => '1');
        Z(4+N) <= not E(1);
        Z(N)   <= not E(0);
    end process;
    
    OD: TTLdelays 
    generic map(
        tPLH => tPLH,
        tPHL => tPHL
    )
    port map(
        A => Z,
        B => Q
    );
end architecture BEHAV;

-----------------------------------------------------------------------
-- SN74LS156N: Dual 1-of-4 decoder/demultiplexer (open collector)
--             Verified 10/06/2016
-----------------------------------------------------------------------
library ieee;
    use ieee.std_logic_1164.all;
    use ieee.std_logic_misc.all;
    use ieee.numeric_std.all;

    use work.LSTTL.all;
    use work.TTLPrivate.all;

entity SN74LS156N is
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
end entity SN74LS156N;

architecture BEHAV of SN74LS156N is
    signal A    : unsigned(1 downto 0);
    signal E    : std_logic_vector(1 downto 0);
    signal Q, Z : std_logic_vector(7 downto 0);
    signal N    : natural range 3 downto 0;

begin
    A <= (X_3, X_13);
    N <= TTL_to_integer(A);
    E <= (not(X_14 or X_15), X_1 and not X_2);
    (X_12, X_11, X_10, X_9, X_4, X_5, X_6, X_7) <= Q;
    
    process(N, E) is
    begin
        Z <= (others => 'Z');
        if E(1) = '1' then Z(4+N) <= '0'; end if;
        if E(0) = '1' then Z(N)   <= '0'; end if;
    end process;
    
    OD: TTLdelays 
    generic map(
        tPLH => tPLH,
        tPHL => tPHL
    )
    port map(
        A => Z,
        B => Q
    );
end architecture BEHAV;

-----------------------------------------------------------------------
-- SN74LS157N: Quad 2-input multiplexer (common select)
--             Verified 10/06/2016
-----------------------------------------------------------------------
library ieee;
    use ieee.std_logic_1164.all;
    use ieee.std_logic_misc.all;
    use ieee.numeric_std.all;

    use work.LSTTL.all;
    use work.TTLPrivate.all;

entity SN74LS157N is
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
end entity SN74LS157N;

architecture BEHAV of SN74LS157N is
    signal D : TTLInputs(4 downto 1, 2 downto 1);
    signal Q : std_logic_vector(4 downto 1);
    signal C : natural range 2 downto 1;
    
begin
    C <= 2 when To_bit(X_1) = '1' else 1;
    D <= ((X_10,  X_11), (X_13,  X_14), (X_6,  X_5), (X_3,  X_2));
    (X_9, X_12, X_7, X_4) <= Q;
    
    G: for i in Q'range generate
        signal Z : std_logic;
    begin
        Z <= D(i,C) and not X_15;
        
        OQ: TTLdelay 
        generic map(
            tPLH => tPLH,
            tPHL => tPHL
        )
        port map(
            A => Z,
            B => Q(i)
        );
    end generate;
end architecture BEHAV;

-----------------------------------------------------------------------
-- SN74LS158N: Quad 2-input multiplexer (common select: inverting)
--             Verified 10/06/2016
-----------------------------------------------------------------------
library ieee;
    use ieee.std_logic_1164.all;
    use ieee.std_logic_misc.all;
    use ieee.numeric_std.all;

    use work.LSTTL.all;
    use work.TTLPrivate.all;

entity SN74LS158N is
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
end entity SN74LS158N;

architecture BEHAV of SN74LS158N is
    signal D : TTLInputs(4 downto 1, 2 downto 1);
    signal Q : std_logic_vector(4 downto 1);
    signal C : natural range 2 downto 1;
    
begin
    C <= 2 when To_bit(X_1) = '1' else 1;
    D <= ((X_10,  X_11), (X_13,  X_14), (X_6,  X_5), (X_3,  X_2));
    (X_9, X_12, X_7, X_4) <= Q;
    
    G: for i in Q'range generate
        signal Z : std_logic;
    begin
        Z <= not(D(i,C) and not X_15);
        
        OQ: TTLdelay 
        generic map(
            tPLH => tPLH,
            tPHL => tPHL
        )
        port map(
            A => Z,
            B => Q(i)
        );
    end generate;
end architecture BEHAV;

-----------------------------------------------------------------------
-- SN74LS160N: Synchronous presettable BCD decade counter
--             Verified 10/06/2016
-----------------------------------------------------------------------
library ieee;
    use ieee.std_logic_1164.all;
    use ieee.std_logic_misc.all;
    use ieee.numeric_std.all;

    use work.LSTTL.all;
    use work.TTLPrivate.all;

entity SN74LS160N is
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
end entity SN74LS160N;

architecture BEHAV of SN74LS160N is
    signal Q : std_logic_vector(3 downto 0);
begin
    (X_11, X_12, X_13, X_14) <= Q;

    CT: TTLsynccount
    generic map(
        asyncreset => true,
        modulus    => 10,
        tPLHT      => tPLHT,
        tPHLT      => tPHLT,
        tPLHQ      => tPLHQ,
        tPHLQ      => tPHLQ
    )
    port map(
        PE  => X_9,
        CP  => X_2,
        CEP => X_7,
        CET => X_10,
        RST => X_1,
        TC  => X_15,
        P   => (X_6, X_5, X_4, X_3),
        Q   => Q   
    );
end architecture BEHAV;

-----------------------------------------------------------------------
-- SN74LS161N: Synchronous presettable 4-bit binary counter
--             Verified 10/06/2016
-----------------------------------------------------------------------
library ieee;
    use ieee.std_logic_1164.all;
    use ieee.std_logic_misc.all;
    use ieee.numeric_std.all;

    use work.LSTTL.all;
    use work.TTLPrivate.all;

entity SN74LS161N is
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
end entity SN74LS161N;

architecture BEHAV of SN74LS161N is
    signal Q : std_logic_vector(3 downto 0);
begin
    (X_11, X_12, X_13, X_14) <= Q;

    CT: TTLsynccount
    generic map(
        asyncreset => true,
        modulus    => 16,
        tPLHT      => tPLHT,
        tPHLT      => tPHLT,
        tPLHQ      => tPLHQ,
        tPHLQ      => tPHLQ
    )
    port map(
        PE  => X_9,
        CP  => X_2,
        CEP => X_7,
        CET => X_10,
        RST => X_1,
        TC  => X_15,
        P   => (X_6, X_5, X_4, X_3),
        Q   => Q   
    );
end architecture BEHAV;

-----------------------------------------------------------------------
-- SN74LS162N: Synchronous presettable BCD decade counter
--             Verified 10/06/2016
-----------------------------------------------------------------------
library ieee;
    use ieee.std_logic_1164.all;
    use ieee.std_logic_misc.all;
    use ieee.numeric_std.all;

    use work.LSTTL.all;
    use work.TTLPrivate.all;

entity SN74LS162N is
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
end entity SN74LS162N;

architecture BEHAV of SN74LS162N is
    signal Q : std_logic_vector(3 downto 0);
begin
    (X_11, X_12, X_13, X_14) <= Q;

    CT: TTLsynccount
    generic map(
        asyncreset => false,
        modulus    => 10,
        tPLHT      => tPLHT,
        tPHLT      => tPHLT,
        tPLHQ      => tPLHQ,
        tPHLQ      => tPHLQ
    )
    port map(
        PE  => X_9,
        CP  => X_2,
        CEP => X_7,
        CET => X_10,
        RST => X_1,
        TC  => X_15,
        P   => (X_6, X_5, X_4, X_3),
        Q   => Q   
    );
end architecture BEHAV;

-----------------------------------------------------------------------
-- SN74LS163N: Synchronous presettable 4-bit binary counter
--             Verified 10/06/2016
-----------------------------------------------------------------------
library ieee;
    use ieee.std_logic_1164.all;
    use ieee.std_logic_misc.all;
    use ieee.numeric_std.all;

    use work.LSTTL.all;
    use work.TTLPrivate.all;

entity SN74LS163N is
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
end entity SN74LS163N;

architecture BEHAV of SN74LS163N is
    signal Q : std_logic_vector(3 downto 0);
begin
    (X_11, X_12, X_13, X_14) <= Q;

    CT: TTLsynccount
    generic map(
        asyncreset => false,
        modulus    => 16,
        tPLHT      => tPLHT,
        tPHLT      => tPHLT,
        tPLHQ      => tPLHQ,
        tPHLQ      => tPHLQ
    )
    port map(
        PE  => X_9,
        CP  => X_2,
        CEP => X_7,
        CET => X_10,
        RST => X_1,
        TC  => X_15,
        P   => (X_6, X_5, X_4, X_3),
        Q   => Q   
    );
end architecture BEHAV;

-----------------------------------------------------------------------
-- SN74LS164N: SIPO shift register
--             Verified 10/06/2016
-----------------------------------------------------------------------
library ieee;
    use ieee.std_logic_1164.all;

    use work.LSTTL.all;
    use work.TTLPrivate.all;

entity SN74LS164N is
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
end entity SN74LS164N;

architecture BEHAV of SN74LS164N is
    signal R, Q : std_logic_vector(7 downto 0);
    signal D    : std_logic;
    
    alias RST : std_logic is X_9;
    alias CLK : std_logic is X_8;
    
begin
    (X_13, X_12, X_11, X_10, X_6, X_5, X_4, X_3) <= Q;
    D <= X_1 and X_2;
    
    process(CLK, RST) is
    begin
        if RST = '0' then
            R <= (others => '0');
        elsif CLK'event and CLK = '1' then
            R <= R(6 downto 0) & D;
        end if;
    end process;
    
    OQ: TTLdelays 
    generic map(
        tPLH => tPLH,
        tPHL => tPHL
    )
    port map(
        A => R,
        B => Q
    );

end architecture BEHAV;

-----------------------------------------------------------------------
-- SN74LS165N: 8-bit parallel-to-serial converter
--             Verified 11/06/2016
-----------------------------------------------------------------------
library ieee;
    use ieee.std_logic_1164.all;

    use work.LSTTL.all;
    use work.TTLPrivate.all;

entity SN74LS165N is
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
end entity SN74LS165N;

architecture BEHAV of SN74LS165N is
    signal R       : std_logic_vector(7 downto 0);
    signal CLK, N7 : std_logic;
    
    alias CP1 : std_logic is X_2;
    alias CP2 : std_logic is X_15;
    alias DS  : std_logic is X_10;
    alias PL  : std_logic is X_1;
    
begin
    N7  <= not R(7);
    CLK <= not((CP1 and PL) or (CP2 and PL));
    
    process(CLK, PL) is
    begin
        if PL = '0' then
            R <= (X_6, X_5, X_4, X_3, X_14, X_13, X_12, X_11);
        elsif CLK'event and CLK = '0' then
            R <= R(6 downto 0) & DS;
        end if;
    end process;
    
    OQ: TTLdelay 
    generic map(
        tPLH => tPLH,
        tPHL => tPHL
    )
    port map(
        A => R(7),
        B => X_9
    );
    OQB: TTLdelay 
    generic map(
        tPLH => tPLH,
        tPHL => tPHL
    )
    port map(
        A => N7,
        B => X_7
    );
    
end architecture BEHAV;

-----------------------------------------------------------------------
-- SN74LS166N: 8-bit PISO shift register
--             Verified 11/06/2016
-----------------------------------------------------------------------
library ieee;
    use ieee.std_logic_1164.all;

    use work.LSTTL.all;
    use work.TTLPrivate.all;

entity SN74LS166N is
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
end entity SN74LS166N;

architecture BEHAV of SN74LS166N is
    signal CP : std_logic;
    signal R  : std_logic_vector(7 downto 0);
    signal D  : std_logic_vector(7 downto 0);
    
    alias MR  : std_logic is X_9;
    alias PE  : std_logic is X_15;
    alias DS  : std_logic is X_1;
    
begin
    CP <= X_6 or X_7;
    D  <= (X_14, X_12, X_11, X_10, X_5, X_4, X_3, X_2);
    
    process(CP, MR) is
    begin
        if MR = '0' then
            R <= (others => '0');
        elsif CP'event and CP = '1' then
            if PE = '0' then
                assert D'stable(tSU) report "Setup violation" severity failure;
                R <= D;
            else
                R <= R(6 downto 0) & DS;
            end if;
        end if;
    end process;
    
    OQ: TTLdelay 
    generic map(
        tPLH => tPLH,
        tPHL => tPHL
    )
    port map(
        A => R(7),
        B => X_13
    );
end architecture BEHAV;

-- SN74167N: Synchronous decade rate multiplier

-----------------------------------------------------------------------
-- SN74LS168N: Synchronous bidirectional BCD decade counter
--             Verified 11/06/2016
-----------------------------------------------------------------------
library ieee;
    use ieee.std_logic_1164.all;

    use work.LSTTL.all;
    use work.TTLPrivate.all;

entity SN74LS168N is
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
end entity SN74LS168N;

architecture BEHAV of SN74LS168N is
    signal Z : std_logic_vector(3 downto 0);
begin
    (X_11, X_12, X_13, X_14) <= Z;
    
    CT: TTLbiCount
    generic map(
        decade => true,
        tPLHQ  => tPLHQ,
        tPHLQ  => tPHLQ,
        tPLHT  => tPLHT,
        tPHLT  => tPHLT,
        tSU    => tSU,
        tSUPE  => tSUPE
    )
    port map(
        PE  => X_9,
        CP  => X_2,
        CEP => X_7,
        CET => X_10,
        U_D => X_1,
        P   => (X_6, X_5, X_4, X_3),
        Q   => Z,
        TC  => X_15
    );
end architecture BEHAV;

-----------------------------------------------------------------------
-- SN74LS169N: Synchronous bidirectional 4-bit binary counter
--             Verified 11/06/2016
-----------------------------------------------------------------------
library ieee;
    use ieee.std_logic_1164.all;

    use work.LSTTL.all;
    use work.TTLPrivate.all;

entity SN74LS169N is
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
end entity SN74LS169N;

architecture BEHAV of SN74LS169N is
    signal Z : std_logic_vector(3 downto 0);
begin
    (X_11, X_12, X_13, X_14) <= Z;
    
    CT: TTLbiCount
    generic map(
        decade => false,
        tPLHQ  => tPLHQ,
        tPHLQ  => tPHLQ,
        tPLHT  => tPLHT,
        tPHLT  => tPHLT,
        tSU    => tSU,
        tSUPE  => tSUPE
    )
    port map(
        PE  => X_9,
        CP  => X_2,
        CEP => X_7,
        CET => X_10,
        U_D => X_1,
        P   => (X_6, X_5, X_4, X_3),
        Q   => Z,
        TC  => X_15
    );
end architecture BEHAV;

-----------------------------------------------------------------------
-- SN74LS170N: 4 X 4 register file (open collector)
--             Verified 17/07/2016
-----------------------------------------------------------------------
library ieee;
    use ieee.std_logic_1164.all;
    use ieee.std_logic_misc.all;
    use ieee.numeric_std.all;

    use work.LSTTL.all;
    use work.TTLPrivate.all;

entity SN74LS170N is
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
end entity SN74LS170N;

architecture BEHAV of SN74LS170N is
    signal  RE, WE   : std_logic := '1';
    signal  RA, WA   : std_logic_vector(1 downto 0) := (others => '0');
    signal  D,  Q    : std_logic_vector(3 downto 0);
begin
    RE <= X_11;
    WE <= X_12;
    RA <= (X_4, X_5);
    WA <= (X_13, X_14);
    D  <= (X_3, X_2, X_1, X_15);
    (X_6, X_7, X_9, X_10) <= Q;
    
    MB: TTLramblock
    generic map(
        Omode => OpenColl,
        INVT  => '0',
        tPLC  => tPLC,
        tPLA  => tPLA,
        tSUD  => tSUD,
        tSUA  => tSUA
    )         
    port map( 
        RA    => RA,
        WA    => WA,
        D     => D,
        O     => Q,
        CE    => '0',
        RE    => RE,
        WE    => WE
    );    
end architecture BEHAV;

-----------------------------------------------------------------------
-- SN74LS173N: 4-bit D-type register (3-state outputs)
--             Verified 17/07/2016
-----------------------------------------------------------------------
library ieee;
    use ieee.std_logic_1164.all;

    use work.LSTTL.all;
    use work.TTLPrivate.all;

entity SN74LS173N is
generic(
    tSD  : time  := 10 ns;  -- Setup, D to CLK
    tSE  : time  := 17 ns;  -- Setup, IE to CLK
    tPQ  : time  := 40 ns;  -- Delay, CLK to Q
    tQZ  : time  := 20 ns   -- Delay, OE to Z
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
end entity SN74LS173N;

architecture BEHAV of SN74LS173N is
    signal D,  REG : std_logic_vector(3 downto 0);
    signal IE, OE  : std_logic;
    
    alias CLK is X_7;
    alias MR  is X_15;
    
begin
    IE <= X_9 or X_10;
    OE <= X_1 or X_2 after tQZ;
    (X_6, X_5, X_4, X_3) <= REG when OE = '0' else (others => 'Z');
    
    D <= (X_11, X_12, X_13, X_14);
    
    RG: process(CLK, MR) is
    begin
        if MR = '1' then
            REG <= (others => '0');
        elsif rising_edge(CLK) then
            assert D'stable(tSD)  report "D setup violation"  severity failure;
            assert IE'stable(tSE) report "IE setup violation" severity failure;
            
            if IE = '0' then
                REG <= D after tSD;
            end if;
        end if;
    end process;
    
end architecture BEHAV;

-----------------------------------------------------------------------
-- SN74LS174N: Hex D-flipflop
--             Verified 17/07/2016
-----------------------------------------------------------------------
library ieee;
    use ieee.std_logic_1164.all;

    use work.LSTTL.all;
    use work.TTLPrivate.all;

entity SN74LS174N is
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
end entity SN74LS174N;

architecture BEHAV of SN74LS174N is
    signal D, Q : std_logic_vector(5 downto 0);
    alias  CLK is X_9;
    alias  MR  is X_1;
    
begin
    D <= (X_14, X_13, X_11, X_6, X_4, X_3);
    (X_15, X_12, X_10, X_7, X_5, X_2) <= Q;
    
    RG: process(CLK, MR) is
    begin
        if MR = '0' then
            Q <= (others => '0');
        elsif rising_edge(CLK) then
            assert D'stable(tSU) report "tSU failure" severity failure;
            Q <= D after tPD;
        end if;
    end process;
    
end architecture BEHAV;

-----------------------------------------------------------------------
-- SN74LS175N: Quad D-flipflop
--             Verified 17/07/2016
-----------------------------------------------------------------------
library ieee;
    use ieee.std_logic_1164.all;

    use work.LSTTL.all;
    use work.TTLPrivate.all;

entity SN74LS175N is
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
end entity SN74LS175N;

architecture BEHAV of SN74LS175N is
    signal D, Q, QB : std_logic_vector(3 downto 0);
    alias  CLK is X_9;
    alias  MR  is X_1;
    
begin
    D <= (X_13, X_12, X_5, X_4);
    (X_15, X_10, X_7, X_2) <= Q;
    (X_14, X_11, X_6, X_3) <= QB;
    QB <= not Q;
    
    RG: process(CLK, MR) is
    begin
        if MR = '0' then
            Q <= (others => '0');
        elsif rising_edge(CLK) then
            assert D'stable(tSU) report "tSU failure" severity failure;
            Q <= D after tPD;
        end if;
    end process;
end architecture BEHAV;

-----------------------------------------------------------------------
-- SN74176N: Presettable decade counter
--           Verified 19/07/2016
-----------------------------------------------------------------------
library ieee;
    use ieee.std_logic_1164.all;

    use work.LSTTL.all;
    use work.TTLPrivate.all;

entity SN74176N is
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
end entity SN74176N;

architecture BEHAV of SN74176N is
    signal p, q : std_logic_vector(3 downto 0);
    
begin
    p <= (X_11, X_3, X_10, X_4);
    (X_12, X_2, X_9, X_5) <= q;
    
    M1: TTLcount4
    generic map(
        tPLH0   => tPLH0,
        tPHL0   => tPHL0,
        tPLH1   => tPLH1,
        tPHL1   => tPHL1,
        tPLH2   => tPLH2,
        tPHL2   => tPHL2,
        tPLH3   => tPLH3,
        tPHL3   => tPHL3,
        modulus => 10
    )
    port map(
        ld   => X_1,
        d    => p,
        clka => X_8,
        clkb => X_6,
        rst  => X_13,
        set  => '1',
        val  => q
    );
end architecture BEHAV;

-----------------------------------------------------------------------
-- SN74177N: Presettable binary counter
--           Verified 19/07/2016
-----------------------------------------------------------------------
library ieee;
    use ieee.std_logic_1164.all;

    use work.LSTTL.all;
    use work.TTLPrivate.all;

entity SN74177N is
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
end entity SN74177N;

architecture BEHAV of SN74177N is
    signal p, q : std_logic_vector(3 downto 0);
    
begin
    p <= (X_11, X_3, X_10, X_4);
    (X_12, X_2, X_9, X_5) <= q;
    
    M1: TTLcount4
    generic map(
        tPLH0   => tPLH0,
        tPHL0   => tPHL0,
        tPLH1   => tPLH1,
        tPHL1   => tPHL1,
        tPLH2   => tPLH2,
        tPHL2   => tPHL2,
        tPLH3   => tPLH3,
        tPHL3   => tPHL3,
        modulus => 16
    )
    port map(
        ld   => X_1,
        d    => p,
        clka => X_8,
        clkb => X_6,
        rst  => X_13,
        set  => '1',
        val  => q
    );
end architecture BEHAV;

-----------------------------------------------------------------------
-- SN74178N: 4-bit shift register
--           Verified 20/07/2016
-----------------------------------------------------------------------
library ieee;
    use ieee.std_logic_1164.all;

    use work.LSTTL.all;
    use work.TTLPrivate.all;

entity SN74178N is
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
end entity SN74178N;

architecture BEHAV of SN74178N is
begin
    C: SN74179N             -- 74178 is 74179, with MR\ & Q3\ deleted
    generic map(
        tDL  => tDL,
        tSU  => tSU
    )
    port map(
        X_1  => '1',  -- MR\
        X_2  => X_1,  -- P1
        X_3  => X_2,  -- P0
        X_4  => X_3,  -- DS
        X_5  => X_4,  -- Q0
        X_6  => X_5,  -- CP\
        X_7  => X_6,  -- Q1
        X_8  => open, -- GND
        X_9  => X_8,  -- Q2
        X_10 => X_9,  -- PE
        X_11 => X_10, -- Q3
        X_12 => open, -- Q3\
        X_13 => X_11, -- SE
        X_14 => X_12, -- P3
        X_15 => X_13, -- P2
        X_16 => open  -- Vcc
    );
end architecture BEHAV;

-----------------------------------------------------------------------
-- SN74179N: 4-bit shift register
--           Verified 20/07/2016
-----------------------------------------------------------------------
library ieee;
    use ieee.std_logic_1164.all;

    use work.LSTTL.all;
    use work.TTLPrivate.all;

entity SN74179N is
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
    X_6  : in    std_logic;  -- CP\ (falling)
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
end entity SN74179N;

architecture BEHAV of SN74179N is
    signal D, REG, Q : std_logic_vector(3 downto 0);
    
    alias  CLK is X_6;
    alias  MR  is X_1;
    alias  DS  is X_4;
    alias  PE  is X_10;
    alias  SE  is X_13;
    
begin
    D <= (X_14, X_15, X_2, X_3);
    (X_11, X_9, X_7, X_5) <= Q;
    X_12 <= not Q(3);
    
    process(MR, CLK) is
    begin
        if MR = '0' then
            REG <= (others => '0');
        elsif falling_edge(CLK) then
            assert SE'stable(tSU) report "SE violation" severity failure;
            assert PE'stable(tSU) report "PE violation" severity failure;
            assert D'stable(tSU)  report "Data violation" severity failure;
            assert DS'stable(tSU) report "DS violation" severity failure;
            if SE = '1' then
                REG <= REG(2 downto 0) & DS;
            elsif PE = '1' then
                REG <= D;
            end if;
        end if;
    end process;
    
    Q <= REG after tDL;
    
end architecture BEHAV;

-----------------------------------------------------------------------
-- SN74180N: 8-bit parity generator/checker
--           Verified 20/07/2016
-----------------------------------------------------------------------
library ieee;
    use ieee.std_logic_1164.all;
    use ieee.std_logic_misc.all;

    use work.LSTTL.all;
    use work.TTLPrivate.all;

entity SN74180N is
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
end entity SN74180N;

architecture BEHAV of SN74180N is
    signal IP, OI, EI : std_logic;
    signal I  : std_logic_vector(7 downto 0);
begin
    I   <= (X_8, X_9, X_10, X_11, X_12, X_13, X_1, X_2);
    IP  <= xnor_reduce(I) after tPI;
    OI  <= X_4 after tPE;
    EI  <= X_3 after tPE;
    X_5 <= not ((IP and OI) or (EI and not IP));
    X_6 <= not ((IP and EI) or (OI and not IP));
end architecture BEHAV;

-----------------------------------------------------------------------
-- SN74LS181N: 4-bit arithmetic/logic unit
--             Verified 31/07/2016
-----------------------------------------------------------------------
library ieee;
    use ieee.std_logic_1164.all;
    use ieee.std_logic_misc.all;
    use ieee.numeric_std.all;

    use work.LSTTL.all;
    use work.TTLPrivate.all;

entity SN74LS181N is
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
end entity SN74LS181N;

architecture BEHAV of SN74LS181N is
    alias CN   is X_7; 
    alias M    is X_8; 
    alias EQB  is X_14;
    alias CO   is X_16;
    alias G    is X_17;
    alias P    is X_15;
    
    signal A, B, F, BN, X, Y, N, L, Z, QI : unsigned(3 downto 0);
    
    signal S   : std_logic_vector(3 downto 0);
    
    signal MN  : std_logic;
    signal L1 : std_logic;
    signal L2 : std_logic;
    signal L3 : std_logic;
    signal L4 : std_logic;
    signal L5 : std_logic;
    signal L6 : std_logic;
    signal L7 : std_logic;
    signal L8 : std_logic;
    signal L9 : std_logic;
    signal LA : std_logic;
    signal LB  : std_logic;
    signal LC : std_logic;

begin
    A  <= (X_19, X_21, X_23, X_2);
    B  <= (X_18, X_20, X_22, X_1);
    S  <= (X_3, X_4, X_5, X_6);
    BN <= not B;
    MN <= not ( M );
    
    G1: for i in A'range generate
        Y(i) <= not ( (  B(i) and S(3) and A(i) ) or ( A(i) and S(2) and BN(i) ) );
        X(i) <= not ( ( BN(i) and S(1) )          or ( S(0) and B(i) ) or A(i) );
        N(i) <= ( Y(i) and not X(i) ) after T5;
    end generate;
       
    Z(3)  <= ( X(3) ) after T1;
    Z(2)  <= ( Y(3) and X(2) ) after T1;
    Z(1)  <= ( Y(3) and Y(2) and X(1) ) after T1;
    Z(0)  <= ( Y(3) and Y(2) and Y(1) and X(0) ) after T1;
    L1    <= not ( Y(3) and Y(2) and Y(1) and Y(0) and CN );
    L2    <= ( CN and Y(0) and Y(1) and Y(2) and MN );
    L3    <= ( Y(1) and Y(2) and X(0) and MN );
    L4    <= ( Y(2) and X(1) and MN );
    L5    <= ( X(2) and MN );
    L6    <= ( CN and Y(0) and Y(1) and MN );
    L7    <= ( Y(1) and X(0) and MN );
    L8    <= ( X(1) and MN );
    L9    <= ( CN and Y(0) and MN );
    LA    <= ( X(0) and MN );
    L(0)  <= not ( CN and MN );
    L(3)  <= not ( L2 or L3 or L4 or L5 );
    L(2)  <= not ( L6 or L7 or L8 );
    L(1)  <= not ( L9 or LA );
    LC    <= nor_reduce(std_logic_vector(Z)) after T2;
    G     <= LC;
    LB    <= ( LC ) after T1;
    CO    <= not ( LB and L1 ) after T2;
    P     <= nand_reduce(std_logic_vector(Y)) after T4;
    F     <= ( N xor L ) after T2;
    
    G2: for i in 3 downto 1 generate
        QI(i) <= ( F(i) ) after T5;
    end generate;
    
    QI(0) <= F(0);     -- NB no delay
    EQB   <= and_reduce(std_logic_vector(QI)) after T3;
    (X_13, X_11, X_10, X_9) <= F;

end architecture BEHAV;

-----------------------------------------------------------------------
-- SN74LS182N: Fast carry unit for 4 x LS181
--             Verified 31/07/2016
-----------------------------------------------------------------------
library ieee;
    use ieee.std_logic_1164.all;
    use ieee.std_logic_misc.all;

    use work.LSTTL.all;
    use work.TTLPrivate.all;

entity SN74LS182N is
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
    X_9  : out   std_logic;  -- Cnz
    X_10 : out   std_logic;  -- G
    X_11 : out   std_logic;  -- Cny
    X_12 : out   std_logic;  -- Cnx
    X_13 : in    std_logic;  -- Cn
    X_14 : in    std_logic;  -- G2
    X_15 : in    std_logic;  -- P2
    X_16 : inout std_logic   -- Vcc
);
end entity SN74LS182N;

architecture BEHAV of SN74LS182N is
    alias  G1   is X_1;
    alias  P1   is X_2;
    alias  G0   is X_3;
    alias  P0   is X_4;
    alias  G3   is X_5;
    alias  P3   is X_6;
    alias  Cn   is X_13;
    alias  G2   is X_14;
    alias  P2   is X_15;
    
    signal NC   : std_logic;
    signal Cnx, Cny, Cnz, PI, GI  : std_logic;

begin
    NC  <= not Cn;
    PI  <= or_reduce(P3 & P2 & P1 & P0);
    GI  <= and_reduce(G3 & G2 & G1 & G0) or 
               and_reduce(G3 & G2 & G1 & P1) or
               and_reduce(G3 & G2 & P2) or (G3 and P3);
    Cnz <= not(and_reduce(G2 & G1 & G0 & NC) or
               and_reduce(G2 & G1 & G0 & P0) or
               and_reduce(G2 & G1 & P1) or (G2 and P2));
    Cny <= not(and_reduce(G1 & G0 & NC) or
               and_reduce(G1 & G0 & P0) or (G1 and P1));
    Cnx <= not((G0 and NC) or (G0 and P0));
    
    T1: TTLdelay
        generic map(
            tPLH => tCLH,
            tPHL => tCHL
        )
        port map(
            A => Cnx,
            B => X_12
        );
          
    T2: TTLdelay
        generic map(
            tPLH => tCLH,
            tPHL => tCHL
        )
        port map(
            A => Cny,
            B => X_11
        );
          
    T3: TTLdelay
        generic map(
            tPLH => tCLH,
            tPHL => tCHL
        )
        port map(
            A => Cnz,
            B => X_9
        );
          
    T4: TTLdelay
        generic map(
            tPLH => tPLH,
            tPHL => tPHL
        )
        port map(
            A => PI,
            B => X_7
        );
          
    T5: TTLdelay
        generic map(
            tPLH => tGLH,
            tPHL => tGHL
        )
        port map(
            A => GI,
            B => X_10
        );
          
end architecture BEHAV;

-----------------------------------------------------------------------
-- SN74H183N: Dual high-speed adder
--            Verified 31/07/2016
-----------------------------------------------------------------------
library ieee;
    use ieee.std_logic_1164.all;
    use ieee.std_logic_misc.all;
    use ieee.numeric_std.all;

    use work.LSTTL.all;
    use work.TTLPrivate.all;

entity SN74H183N is
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
end entity SN74H183N;

architecture BEHAV of SN74H183N is
    signal CI, A, B, S, CO : std_logic_vector(1 downto 0);  -- Order b, a
begin
    CI <= (X_11, X_4);
    A  <= (X_13, X_1);
    B  <= (X_12, X_3);
    
    ( X_8, X_6) <= S;
    (X_10, X_5) <= CO;
    
    G: for i in A'range generate
        signal AA, BB, R : unsigned(1 downto 0);
        signal Y,  Z     : std_logic_vector(1 downto 0);
    begin
        AA <= ('0', A(i));
        BB <= ('0', B(i));
        R  <= AA + BB + CI(i);
        Y  <= std_logic_vector(R);
        
        T1: TTLdelays
        generic map(
            tPLH => tPLH,
            tPHL => tPHL
        )
        port map(
            A => Y,
            B => Z
        );

        S(i)  <= Z(0);
        CO(i) <= Z(1);
    end generate;
    
end architecture BEHAV;

-----------------------------------------------------------------------
-- SN74LS189N: 64-bit random-access memory (3-state outputs)
--             Verified 18/07/2016
-----------------------------------------------------------------------
library ieee;
    use ieee.std_logic_1164.all;
    use ieee.std_logic_misc.all;
    use ieee.numeric_std.all;

    use work.LSTTL.all;
    use work.TTLPrivate.all;

entity SN74LS189N is
generic(
    tPLC : time    := 10 ns;
    tPLA : time    := 37 ns;
    tSUD : time    := 25 ns;
    tSUA : time    := 10 ns
);
port(
    X_1  : in    std_logic;  -- A0
    X_2  : in    std_logic;  -- CS\
    X_3  : in    std_logic;  -- WE\
    X_4  : in    std_logic;  -- D1
    X_5  : out   std_logic;  -- Q1\
    X_6  : in    std_logic;  -- D2
    X_7  : out   std_logic;  -- Q2\
    X_8  : inout std_logic;  -- GND
    X_9  : out   std_logic;  -- Q3\
    X_10 : in    std_logic;  -- D3
    X_11 : out   std_logic;  -- Q4\
    X_12 : in    std_logic;  -- D4
    X_13 : in    std_logic;  -- A3
    X_14 : in    std_logic;  -- A2
    X_15 : in    std_logic;  -- A1
    X_16 : inout std_logic   -- Vcc
);
end entity SN74LS189N;

architecture BEHAV of SN74LS189N is
    signal  RE, WE      : std_logic := '1';
    signal  IA          : std_logic_vector(3 downto 0) := (others => '0');
    signal  D, QB, Q    : std_logic_vector(3 downto 0);
begin
    RE <= not(    X_3 and not X_2);
    WE <= not(not X_3 and not X_2);
    IA <=    (X_13, X_14, X_15, X_1);
    D  <=    (X_12, X_10, X_6, X_4);
    (X_11, X_9, X_7, X_5) <= Q;
    
    MB: TTLramblock
    generic map(
        Omode => TriState,
        INVT  => '1',
        tPLC  => tPLC,
        tPLA  => tPLA,
        tSUD  => tSUD,
        tSUA  => tSUA
    )         
    port map( 
        RA    => IA,
        WA    => IA,
        D     => D,
        O     => Q,
        CE    => '0',
        RE    => RE,
        WE    => WE
    );    
end architecture BEHAV;

-----------------------------------------------------------------------
-- SN74LS190N: Up/down decade counter
--             Verified 01/08/2016
-----------------------------------------------------------------------
library ieee;
    use ieee.std_logic_1164.all;
    use ieee.std_logic_misc.all;
    use ieee.numeric_std.all;

    use work.LSTTL.all;
    use work.TTLPrivate.all;

entity SN74LS190N is
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
end entity SN74LS190N;

architecture BEHAV of SN74LS190N is
    subtype CVAL is natural range 15 downto 0;
    type VTAB is array(0 to 15) of CVAL;
    
    constant T10U : VTAB := ( 1, 2, 3, 4, 5, 6, 7, 8, 9, 0,11, 6,13, 4,15, 2);
    constant T10D : VTAB := ( 9, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9,10,11,12,13,14);
    constant T16U : VTAB := ( 1, 2, 3, 4, 5, 6, 7, 8, 9,10,11,12,13,14,15, 0);
    constant T16D : VTAB := (15, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9,10,11,12,13,14);
    
    signal P,  Q  : unsigned(3 downto 0);
    signal QI, QO : std_logic_vector(Q'range);
    signal CTR    : CVAL;
    signal RC, TC : std_logic;
    
    alias CP  is X_14;
    alias DWN is X_5;
    alias CE  is X_4;
    alias PL  is X_11;
    
begin
    assert (MODULUS = 10) or (MODULUS = 16) report "Incorrect modulus" severity failure;
    
    P <= (X_9, X_10, X_1, X_15);
    (X_7, X_6, X_2, X_3) <= QO;
    
    process(CP, PL, P) is
    begin
        if PL = '0' then
            CTR <= to_integer(P);
        elsif rising_edge(CP) and (CE = '0') then
            if MODULUS = 10 then
                if DWN = '0' then
                    CTR <= T10U(CTR);
                else
                    CTR <= T10D(CTR);
                end if;
            else
                if DWN = '0' then
                    CTR <= T16U(CTR);
                else
                    CTR <= T16D(CTR);
                end if;
            end if;
        end if;
    end process;
    
    process(all) is
        variable B : std_logic;
    begin
        B  := '1' when MODULUS = 10 else '0';
        TC <= '0';                  -- Default
        case CTR is
            when  0           => TC <=           DWN;
            when  9 | 11 | 13 => TC <= B and not DWN;
            when 15           => TC <=       not DWN;
            when others       => null;
        end case;
    end process;
    
    RC <= not(TC and (not CE) and (not CP));
    
    Q  <= to_unsigned(CTR, Q'length);
    QI <= std_logic_vector(Q);
    
    TQ: TTLdelays
    generic map(
        tPLH => tQLH,
        tPHL => tQHL
    )
    port map(
        A => QI,
        B => QO
    );
    
    TRC: TTLdelay
    generic map(
        tPLH => tRLH,
        tPHL => tRHL
    )
    port map(
        A => RC,
        B => X_13
    );
    
    TTC: TTLdelay
    generic map(
        tPLH => tTLH,
        tPHL => tTHL
    )
    port map(
        A => TC,
        B => X_12
    );
    
end architecture BEHAV;

-----------------------------------------------------------------------
-- SN74LS191N: Up/down binary counter
--             Verified 01/08/2016
-----------------------------------------------------------------------
library ieee;
    use ieee.std_logic_1164.all;

    use work.LSTTL.all;
    use work.TTLPrivate.all;

entity SN74LS191N is
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
end entity SN74LS191N;

architecture BEHAV of SN74LS191N is
begin
    Q: SN74LS190N       -- Use the generic device, set for modulus 16
    generic map(
        MODULUS => MODULUS,
        tQLH    => tQLH,
        tQHL    => tQHL,
        tTLH    => tTLH,
        tTHL    => tTHL,
        tRLH    => tRLH,
        tRHL    => tRHL
    )
    port map(
        X_1  => X_1,
        X_2  => X_2,
        X_3  => X_3,
        X_4  => X_4,
        X_5  => X_5,
        X_6  => X_6,
        X_7  => X_7,
        X_8  => X_8,
        X_9  => X_9,
        X_10 => X_10,
        X_11 => X_11,
        X_12 => X_12,
        X_13 => X_13,
        X_14 => X_14,
        X_15 => X_15,
        X_16 => X_16
    );
end architecture BEHAV;

-----------------------------------------------------------------------
-- SN74LS192N: Up/down decade counter
--             Verified 02/08/2016
-----------------------------------------------------------------------
library ieee;
    use ieee.std_logic_1164.all;
    use ieee.std_logic_misc.all;
    use ieee.numeric_std.all;

    use work.LSTTL.all;
    use work.TTLPrivate.all;

entity SN74LS192N is
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
end entity SN74LS192N;

architecture BEHAV of SN74LS192N is
    subtype CVAL is natural range 15 downto 0;
    type VTAB is array(0 to 15) of CVAL;
    
    constant T10U : VTAB := ( 1, 2, 3, 4, 5, 6, 7, 8, 9, 0,11, 6,13, 4,15, 2);
    constant T10D : VTAB := ( 9, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9,10,11,12,13,14);
    constant T16U : VTAB := ( 1, 2, 3, 4, 5, 6, 7, 8, 9,10,11,12,13,14,15, 0);
    constant T16D : VTAB := (15, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9,10,11,12,13,14);
    
    signal P,  Q,   QB : unsigned(3 downto 0);
    signal QI, QO      : std_logic_vector(Q'range);
    signal CTR         : CVAL;
    signal TCU, TCD    : std_logic;
    
    alias  PL  is X_11;
    alias  MR  is X_14;
    alias  CPD is X_4;
    alias  CPU is X_5;
    
begin
    assert (MODULUS = 10) or (MODULUS = 16) report "Incorrect modulus" severity failure;
    
    P <= (X_9, X_10, X_1, X_15);
    (X_7, X_6, X_2, X_3) <= QO;
    
    Q  <= to_unsigned(CTR, Q'length);
    QI <= std_logic_vector(Q);
    QB <= not Q;
    
    process(CPU, CPD, PL, MR, P) is
    begin
        if MR = '1' then
            CTR <= 0;
        elsif PL = '0' then
            CTR <= to_integer(P);
        elsif rising_edge(CPU) then
            if MODULUS = 10 then
                CTR <= T10U(CTR);
            else
                CTR <= T16U(CTR);
            end if;
        elsif rising_edge(CPD) then
            if MODULUS = 10 then
                CTR <= T10D(CTR);
            else
                CTR <= T16D(CTR);
            end if;
        end if;
    end process;
    
    process(all) is
    begin
        if MODULUS = 10 then
            TCU <= not((not CPU) and Q(0) and Q(3));
        else
            TCU <= not((not CPD) and Q(0) and Q(1) and Q(2) and Q(3));
        end if;
        TCD <= not((not CPD) and QB(0) and QB(1) and QB(2) and QB(3));
    end process;
    
    TQ: TTLdelays
    generic map(
        tPLH => tQLH,
        tPHL => tQHL
    )
    port map(
        A => QI,
        B => QO
    );
    
    TRC: TTLdelay
    generic map(
        tPLH => tTCULH,
        tPHL => tTCUHL
    )
    port map(
        A => TCU,
        B => X_12
    );
    
    TTC: TTLdelay
    generic map(
        tPLH => tTCDLH,
        tPHL => tTCDHL
    )
    port map(
        A => TCD,
        B => X_13
    );
    
end architecture BEHAV;

-----------------------------------------------------------------------
-- SN74LS193N: Up/down binary counter
--             Verified 02/08/2016
-----------------------------------------------------------------------
library ieee;
    use ieee.std_logic_1164.all;

    use work.LSTTL.all;
    use work.TTLPrivate.all;

entity SN74LS193N is
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
end entity SN74LS193N;

architecture BEHAV of SN74LS193N is
begin
    G: SN74LS192N       -- Use the generic device, set for modulus 16
    generic map(
        MODULUS => MODULUS,
        tQLH    => tQLH,
        tQHL    => tQHL,
        tTCULH  => tTCULH,
        tTCUHL  => tTCUHL,
        tTCDLH  => tTCDLH,
        tTCDHL  => tTCDHL 
    )
    port map(
        X_1  => X_1,
        X_2  => X_2,
        X_3  => X_3,
        X_4  => X_4,
        X_5  => X_5,
        X_6  => X_6,
        X_7  => X_7,
        X_8  => X_8,
        X_9  => X_9,
        X_10 => X_10,
        X_11 => X_11,
        X_12 => X_12,
        X_13 => X_13,
        X_14 => X_14,
        X_15 => X_15,
        X_16 => X_16
    );
end architecture BEHAV;

-----------------------------------------------------------------------
-- SN74LS194N: 4-bit bidirectional shift register
--             Verified 03/08/2016
-----------------------------------------------------------------------
library ieee;
    use ieee.std_logic_1164.all;

    use work.LSTTL.all;
    use work.TTLPrivate.all;

entity SN74LS194N is
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
end entity SN74LS194N;

architecture BEHAV of SN74LS194N is
    signal S       : std_logic_vector(1 downto 0);
    
    -- NB Q3 is considered the rightmost bit (see data sheet)
    signal P, Q, Z : std_logic_vector(0 to 3);
    
    alias CP is X_11;
    alias MR is X_1;
    alias DR is X_2;
    alias DL is X_7;
    
begin
    S <= (X_10, X_9);
    P <= (X_6, X_5, X_4, X_3);
    (X_12, X_13, X_14, X_15) <= Z;
    
    process(CP, MR) is
    begin
        if MR = '0' then
            Q <= (others => '0');
        elsif rising_edge(CP) then
            case S is
                when "01"   => Q <= DR & Q(0 to 2); -- Shift right
                when "10"   => Q <= Q(1 to 3) & DL; -- Shift left
                when "11"   => Q <= P;              -- Parallel load
                when others => null;                -- Hold
            end case;
        end if;
    end process;
    
    TQ: TTLdelays
    generic map(
        tPLH => tPLH,
        tPHL => tPHL
    )
    port map(
        A => Q,
        B => Z
    );
    
end architecture BEHAV;

-----------------------------------------------------------------------
-- SN74LS195N: Universal 4-bit shift register
--             Verified 03/08/2016
-----------------------------------------------------------------------
library ieee;
    use ieee.std_logic_1164.all;

    use work.LSTTL.all;
    use work.TTLPrivate.all;

entity SN74LS195N is
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
end entity SN74LS195N;

architecture BEHAV of SN74LS195N is
    signal P, Q, Z : std_logic_vector(3 downto 0);
    signal JK      : std_logic_vector(1 downto 0);
    signal D       : std_logic;
    
    alias CP is X_10;
    alias MR is X_1;
    alias PE is X_9;
    
begin
    JK <= (X_2, X_3);
    P  <= (X_7, X_6, X_5, X_4);
    (X_12, X_13, X_14, X_15) <= Z;
    X_11 <= not Z(3);
    
    with JK select D <=
        '0'      when "00",
        '1'      when "11",
        not Q(0) when "10",
        Q(0)     when others;
        
    process(CP, MR)
    begin
        if MR = '0' then
            Q <= (others => '0');
        elsif rising_edge(CP) then
            if PE = '0' then
                Q <= P;
            else
                Q <= Q(2 downto 0) & D;
            end if;
        end if;
    end process;

    TQ: TTLdelays
    generic map(
        tPLH => tPLH,
        tPHL => tPHL
    )
    port map(
        A => Q,
        B => Z
    );
end architecture BEHAV;

-----------------------------------------------------------------------
-- SN74LS196N: Presettable decade counter
--             Verified 03/08/2016
-----------------------------------------------------------------------
library ieee;
    use ieee.std_logic_1164.all;

    use work.LSTTL.all;
    use work.TTLPrivate.all;

entity SN74LS196N is
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
end entity SN74LS196N;

architecture BEHAV of SN74LS196N is
begin
CT: SN74176N      -- Same device, just faster
generic map(
    tPLH0 => tPLH0,
    tPHL0 => tPHL0,
    tPLH1 => tPLH1,
    tPHL1 => tPHL1,
    tPLH2 => tPLH2,
    tPHL2 => tPHL2,
    tPLH3 => tPLH3,
    tPHL3 => tPHL3 
)
port map(
    X_1  => X_1,   -- PL\
    X_2  => X_2,   -- Q2
    X_3  => X_3,   -- P2
    X_4  => X_4,   -- P0
    X_5  => X_5,   -- Q0
    X_6  => X_6,   -- CP1\
    X_7  => X_7,   -- GND
    X_8  => X_8,   -- CP0\
    X_9  => X_9,   -- Q1
    X_10 => X_10,  -- P1
    X_11 => X_11,  -- P3
    X_12 => X_12,  -- Q3
    X_13 => X_13,  -- MR\
    X_14 => X_14   -- Vcc
);
end architecture BEHAV;

-----------------------------------------------------------------------
-- SN74LS197N: Presettable binary counter
--             Verified 03/08/2016
-----------------------------------------------------------------------
library ieee;
    use ieee.std_logic_1164.all;

    use work.LSTTL.all;
    use work.TTLPrivate.all;

entity SN74LS197N is
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
end entity SN74LS197N;

architecture BEHAV of SN74LS197N is
begin
CT: SN74177N      -- Same device, just faster
generic map(
    tPLH0 => tPLH0,
    tPHL0 => tPHL0,
    tPLH1 => tPLH1,
    tPHL1 => tPHL1,
    tPLH2 => tPLH2,
    tPHL2 => tPHL2,
    tPLH3 => tPLH3,
    tPHL3 => tPHL3 
)
port map(
    X_1  => X_1,   -- PL\
    X_2  => X_2,   -- Q2
    X_3  => X_3,   -- P2
    X_4  => X_4,   -- P0
    X_5  => X_5,   -- Q0
    X_6  => X_6,   -- CP1\
    X_7  => X_7,   -- GND
    X_8  => X_8,   -- CP0\
    X_9  => X_9,   -- Q1
    X_10 => X_10,  -- P1
    X_11 => X_11,  -- P3
    X_12 => X_12,  -- Q3
    X_13 => X_13,  -- MR\
    X_14 => X_14   -- Vcc
);
end architecture BEHAV;

-----------------------------------------------------------------------
-- SN74LS198N: 8-bit right/left shift register
--             Verified 06/08/2016
-----------------------------------------------------------------------
-- NB Fairchild databook has S0, S1 interchanged. See Signetics book.
library ieee;
    use ieee.std_logic_1164.all;

    use work.LSTTL.all;
    use work.TTLPrivate.all;

entity SN74LS198N is
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
end entity SN74LS198N;

architecture BEHAV of SN74LS198N is
    signal P, D, Q, Z : std_logic_vector(0 to 7);
    signal S          : std_logic_vector(1 downto 0);
    
    alias DSL is X_22;
    alias DSR is X_2;
    alias CP  is X_11;
    alias MR  is X_13;
    
begin
    S <= (X_23, X_1);
    P <= (X_3, X_5, X_7, X_9, X_15, X_17, X_19, X_21);
    (X_4, X_6, X_8, X_10, X_14, X_16, X_18, X_20) <= Z;
    
    process(S) is
    begin
        assert (CP = '1') or (now < 6 ns) report "Change S only when CP = 1" severity error;
    end process;
    
    with S select D <=
        P               when "11",      -- Load
        Q(1 to 7) & DSL when "10",      -- Left
        DSR & Q(0 to 6) when "01",      -- Right
        Q               when others;    -- Hold
        
    process(CP, MR) is
    begin
        if MR = '0' then 
            Q <= (others => '0');
        elsif rising_edge(CP) then
            Q <= D;
        end if;
    end process;
    
    TQ: TTLdelays
    generic map(
        tPLH => tPLH,
        tPHL => tPHL
    )
    port map(
        A => Q,
        B => Z
    );
end architecture BEHAV;

-----------------------------------------------------------------------
-- SN74LS199N: 8-bit parallel IO shift register
-----------------------------------------------------------------------
library ieee;
    use ieee.std_logic_1164.all;

    use work.LSTTL.all;
    use work.TTLPrivate.all;

entity SN74LS199N is
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
end entity SN74LS199N;

architecture BEHAV of SN74LS199N is
    signal CLK, I, P0, CP     : std_logic;
    signal P, Q, Z            : std_logic_vector(0 to 7);
    signal L1, L2, L3, L4, L5 : std_logic;
    
    alias MR  is X_14;
    alias PE  is X_23;
    alias CP1 is X_11;
    alias CP2 is X_13;
    alias J   is X_2;
    alias KB  is X_1;
    
begin
    P <= (X_3, X_5, X_7, X_9, X_16, X_18, X_20, X_22);
    L1 <= not PE;
    L2 <= not Q(0);
    CP <= CP1 or CP2;
    
    L3 <= J and PE and L2;
    L4 <= L1 and P(0);
    L5 <= KB and PE and Q(0);
    P0 <= L3 or L4 or L5;
    FFC1 : TTL_FF 
    port map(
        q   => Q(0), 
        d   => P0, 
        clk => CP, 
        cl  => MR
    );
    
    G: for i in 1 to 7 generate
        signal Z : std_logic;
    begin
        Z <= (Q(i-1) and PE ) or ( L1 and P(i));
        FFC2 : TTL_FF 
        port map(
            q   => Q(i), 
            d   => Z, 
            clk => CP, 
            cl  => MR
        );
    end generate;
    
    TQ: TTLdelays
    generic map(
        tPLH => tPLH,
        tPHL => tPHL
    )
    port map(
        A => Q,
        B => Z
    ); 

    (X_4, X_6, X_8, X_10, X_15, X_17, X_19, X_21) <= Z;    
end architecture BEHAV;

-----------------------------------------------------------------------
-- SN74LS221N: Dual monostable multivibrator
--             Verified 06/08/2016
-----------------------------------------------------------------------
library ieee;
    use ieee.std_logic_1164.all;
    use ieee.std_logic_misc.all;

    use work.LSTTL.all;
    use work.TTLPrivate.all;

entity SN74LS221N is
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
end entity SN74LS221N;

architecture BEHAV of SN74LS221N is
    constant tD : time :=  40 ns;   -- Trigger delay from input
    constant mt : time :=  40 ns;   -- Minimum trigger width
    
    signal trig, NR, Q : std_logic_vector(2 downto 1);
    
    type Widths is array(2 downto 1) of time;
    constant pw : Widths := (W1, W2);
begin
    NR(1)   <= not X_3;
    trig(1) <= and_reduce(X_3  & X_2  & (not X_1)) after tD;
    NR(2)   <= not X_11;
    trig(2) <= and_reduce(X_11 & X_10 & (not X_9)) after tD;

    GN: for i in trig'range generate
    begin
        MS: TTLmonostable
        generic map(
            pwidth        => pw(i),  -- Triggered pulse width
            mintrig       =>    mt,  -- Minimum trigger width
            retriggerable => true
        )
        port map(
            trig  => trig(i),
            reset => NR(i),
            Q     => Q(i)
        );
    end generate;
    
    X_13 <= Q(1);
    X_4  <= not Q(1);
    X_5  <= Q(2);
    X_12 <= not Q(2);

end architecture BEHAV;

-----------------------------------------------------------------------
-- SN74LS240N: Octal buffer/line driver (3-state outputs)
--             Verified 06/08/2016
-----------------------------------------------------------------------
library ieee;
    use ieee.std_logic_1164.all;

    use work.LSTTL.all;
    use work.TTLPrivate.all;

entity SN74LS240N is
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
end entity SN74LS240N;

architecture BEHAV of SN74LS240N is
    signal IA, IB, YA, YB, IAN, IBN : std_logic_vector(0 to 3);
    signal OEA, OEB : std_logic;
    
begin
    OEA <= not X_1;         -- Enable, both active low
    OEB <= not X_19;

    IA <= (X_2,  X_4,  X_6,  X_8 );
    IB <= (X_17, X_15, X_13, X_11);
    IAN <= not IA;          -- '240 inverts data
    IBN <= not IB;
    
    G1: for i in IA'range generate
    begin
        B1: TTL3State     
        generic map(
            tPLH => tPLH,
            tPHL => tPHL,
            tPZH => tPZH,
            tPZL => tPZL,
            tPHZ => tPHZ,
            tPLZ => tPLZ
        )
        port map(
            A  => IAN(i),
            E  => OEA,
            Y  => YA(i)
        );
        
        B2: TTL3State     
        generic map(
            tPLH => tPLH,
            tPHL => tPHL,
            tPZH => tPZH,
            tPZL => tPZL,
            tPHZ => tPHZ,
            tPLZ => tPLZ
        )
        port map(
            A  => IBN(i),
            E  => OEB,
            Y  => YB(i)
        );
    end generate;

    (X_18, X_16, X_14, X_12) <= YA;
    (X_3,  X_5,  X_7,  X_9 ) <= YB;    
end architecture BEHAV;

-----------------------------------------------------------------------
-- SN74LS241N: Octal buffer/line driver (3-state outputs)
--             Verified 14/08/2016
-----------------------------------------------------------------------
library ieee;
    use ieee.std_logic_1164.all;

    use work.LSTTL.all;
    use work.TTLPrivate.all;

entity SN74LS241N is
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
end entity SN74LS241N;

architecture BEHAV of SN74LS241N is
    signal IA, IB, YA, YB : std_logic_vector(0 to 3);
    signal OEA, OEB : std_logic;
    
begin
    OEA <= not X_1;             -- Enable, active low
    OEB <= X_19;                -- Enable, active high

    IA <= (X_2,  X_4,  X_6,  X_8 );
    IB <= (X_17, X_15, X_13, X_11);
    
    G1: for i in IA'range generate
    begin
        B1: TTL3State     
        generic map(
            tPLH => tPLH,
            tPHL => tPHL,
            tPZH => tPZH,
            tPZL => tPZL,
            tPHZ => tPHZ,
            tPLZ => tPLZ
        )
        port map(
            A  => IA(i),
            E  => OEA,
            Y  => YA(i)
        );
        
        B2: TTL3State     
        generic map(
            tPLH => tPLH,
            tPHL => tPHL,
            tPZH => tPZH,
            tPZL => tPZL,
            tPHZ => tPHZ,
            tPLZ => tPLZ
        )
        port map(
            A  => IB(i),
            E  => OEB,
            Y  => YB(i)
        );
    end generate;

    (X_18, X_16, X_14, X_12) <= YA;
    (X_3,  X_5,  X_7,  X_9 ) <= YB;
end architecture BEHAV;

-----------------------------------------------------------------------
-- SN74LS242N: Quad bus transceiver (inverting 3-state outputs)
--             Verified 14/08/2016
-----------------------------------------------------------------------
library ieee;
    use ieee.std_logic_1164.all;

    use work.LSTTL.all;
    use work.TTLPrivate.all;

entity SN74LS242N is
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
end entity SN74LS242N;

architecture BEHAV of SN74LS242N is
    signal A2B, B2A             : std_logic;
    signal AIN, AOUT, BIN, BOUT : std_logic_vector(1 to 4);
    
begin
    A2B <= not X_1;             -- Enable, active low
    B2A <= X_13;                -- Enable, active high
    
    AIN <= (X_3,  X_4,  X_5, X_6);
    BIN <= (X_11, X_10, X_9, X_8);
    (X_3,  X_4,  X_5, X_6) <= AOUT;
    (X_11, X_10, X_9, X_8) <= BOUT;

    G: for i in AIN'range generate
        signal AX, BX : std_logic;
    begin
        AX <= not AIN(i);
        G1A: TTL3State     
        generic map(
            tPLH => tPLH,
            tPHL => tPHL,
            tPZH => tPZH,
            tPZL => tPZL,
            tPHZ => tPHZ,
            tPLZ => tPLZ
        )
        port map(
            A  => AX,
            E  => A2B,
            Y  => BOUT(i)
        );
        BX <= not BIN(i);
        G1B: TTL3State     
        generic map(
            tPLH => tPLH,
            tPHL => tPHL,
            tPZH => tPZH,
            tPZL => tPZL,
            tPHZ => tPHZ,
            tPLZ => tPLZ
        )
        port map(
            A  => BX,
            E  => B2A,
            Y  => AOUT(i)
        );
    end generate;

end architecture BEHAV;

-----------------------------------------------------------------------
-- SN74LS243N: Quad bus transceiver (3-state outputs)
--             Verified 14/08/2016
-----------------------------------------------------------------------
library ieee;
    use ieee.std_logic_1164.all;

    use work.LSTTL.all;
    use work.TTLPrivate.all;

entity SN74LS243N is
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
end entity SN74LS243N;

architecture BEHAV of SN74LS243N is
    signal A2B, B2A             : std_logic;
    signal AIN, AOUT, BIN, BOUT : std_logic_vector(1 to 4);
    
begin
    A2B <= not X_1;             -- Enable, active low
    B2A <= X_13;                -- Enable, active high
    
    AIN <= (X_3,  X_4,  X_5, X_6);
    BIN <= (X_11, X_10, X_9, X_8);
    (X_3,  X_4,  X_5, X_6) <= AOUT;
    (X_11, X_10, X_9, X_8) <= BOUT;

    G: for i in AIN'range generate
    begin
        G1A: TTL3State     
        generic map(
            tPLH => tPLH,
            tPHL => tPHL,
            tPZH => tPZH,
            tPZL => tPZL,
            tPHZ => tPHZ,
            tPLZ => tPLZ
        )
        port map(
            A  => AIN(i),
            E  => A2B,
            Y  => BOUT(i)
        );
        G1B: TTL3State     
        generic map(
            tPLH => tPLH,
            tPHL => tPHL,
            tPZH => tPZH,
            tPZL => tPZL,
            tPHZ => tPHZ,
            tPLZ => tPLZ
        )
        port map(
            A  => BIN(i),
            E  => B2A,
            Y  => AOUT(i)
        );
    end generate;

end architecture BEHAV;

-----------------------------------------------------------------------
-- SN74LS244N: Octal buffer/line driver (3-state outputs)
--             Verified 14/08/2016
-----------------------------------------------------------------------
library ieee;
    use ieee.std_logic_1164.all;

    use work.LSTTL.all;
    use work.TTLPrivate.all;

entity SN74LS244N is
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
end entity SN74LS244N;

architecture BEHAV of SN74LS244N is
    signal IA, IB, YA, YB : std_logic_vector(0 to 3);
    signal OEA, OEB : std_logic;
    
begin
    OEA <= not X_1;         -- Enable, both active low
    OEB <= not X_19;

    IA <= (X_2,  X_4,  X_6,  X_8 );
    IB <= (X_17, X_15, X_13, X_11);
    
    G1: for i in IA'range generate
    begin
        B1: TTL3State     
        generic map(
            tPLH => tPLH,
            tPHL => tPHL,
            tPZH => tPZH,
            tPZL => tPZL,
            tPHZ => tPHZ,
            tPLZ => tPLZ
        )
        port map(
            A  => IA(i),
            E  => OEA,
            Y  => YA(i)
        );
        
        B2: TTL3State     
        generic map(
            tPLH => tPLH,
            tPHL => tPHL,
            tPZH => tPZH,
            tPZL => tPZL,
            tPHZ => tPHZ,
            tPLZ => tPLZ
        )
        port map(
            A  => IB(i),
            E  => OEB,
            Y  => YB(i)
        );
    end generate;

    (X_18, X_16, X_14, X_12) <= YA;
    (X_3,  X_5,  X_7,  X_9 ) <= YB;
end architecture BEHAV;

-----------------------------------------------------------------------
-- SN74LS245N: Octal bus transceiver (3-state outputs)
--             Verified 15/12/2016
-----------------------------------------------------------------------
library ieee;
    use ieee.std_logic_1164.all;

    use work.LSTTL.all;
    use work.TTLPrivate.all;

entity SN74LS245N is
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
end entity SN74LS245N;

architecture BEHAV of SN74LS245N is
    signal A2B, B2A             : std_logic;
    signal AIN, AOUT, BIN, BOUT : std_logic_vector(0 to 7);
    
begin
    A2B <= X_1 and not X_19;
    B2A <= X_1 nor X_19;
    
    AIN <= (X_2,  X_3,  X_4,  X_5,  X_6,  X_7,  X_8,  X_9 );
    BIN <= (X_18, X_17, X_16, X_15, X_14, X_13, X_12, X_11);
    (X_2,  X_3,  X_4,  X_5,  X_6,  X_7,  X_8,  X_9 ) <= AOUT;
    (X_18, X_17, X_16, X_15, X_14, X_13, X_12, X_11) <= BOUT;

    G: for i in AIN'range generate
    begin
        G1A: TTL3State     
        generic map(
            tPLH => tPLH,
            tPHL => tPHL,
            tPZH => tPZH,
            tPZL => tPZL,
            tPHZ => tPHZ,
            tPLZ => tPLZ
        )
        port map(
            A  => AIN(i),
            E  => A2B,
            Y  => BOUT(i)
        );
        G1B: TTL3State     
        generic map(
            tPLH => tPLH,
            tPHL => tPHL,
            tPZH => tPZH,
            tPZL => tPZL,
            tPHZ => tPHZ,
            tPLZ => tPLZ
        )
        port map(
            A  => BIN(i),
            E  => B2A,
            Y  => AOUT(i)
        );
    end generate;
end architecture BEHAV;

-- SN74LS247N: BCD to 7-segment decoder/driver (open collector)
-- SN74LS248N: BCD to 7-segment decoder/driver (2kR pullups)
-- SN74LS249N: BCD to 7-segment decoder (open collector)

-----------------------------------------------------------------------
-- SN74LS251N: 8-input multiplexer (3-state outputs)
--             Verified 15/12/2016
-----------------------------------------------------------------------
library ieee;
    use ieee.std_logic_1164.all;
    use ieee.numeric_std.all;

    use work.LSTTL.all;
    use work.TTLPrivate.all;

entity SN74LS251N is
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
end entity SN74LS251N;

architecture BEHAV of SN74LS251N is
    signal D     : std_logic_vector(7 downto 0);
    signal A     : unsigned(2 downto 0);
    signal Q, QB : std_logic;
    signal EN    : std_logic;
    
begin
    A <= (X_9, X_10, X_11) after tPS;
    D <= (X_12,  X_13,  X_14,  X_15,  X_1,  X_2,  X_3,  X_4 ) after tPI;
    
    QB <= not D(TTL_to_integer(A));
    Q  <= not QB;
    EN <= not X_7;          -- Active-high enable
        
    OZ: TTL3State    
    generic map(
        tPLH => tQBLH,
        tPHL => tQBHL,
        tPZH => tPZH,
        tPZL => tPZL,
        tPHZ => tPHZ,
        tPLZ => tPLZ
    )
    port map(
        A => Q,
        E => EN,
        Y => X_5
    );

    OZB: TTL3State    
    generic map(
        tPLH => 1 ns,
        tPHL => 1 ns,
        tPZH => tPZH,
        tPZL => tPZL,
        tPHZ => tPHZ,
        tPLZ => tPLZ
    )
    port map(
        A => QB,
        E => EN,
        Y => X_6
    );

end architecture BEHAV;

-----------------------------------------------------------------------
-- SN74LS253N: Dual 4-input multiplexer (3-state outputs)
--             Verified 16/12/2016
-----------------------------------------------------------------------
library ieee;
    use ieee.std_logic_1164.all;
    use ieee.std_logic_misc.all;
    use ieee.numeric_std.all;

    use work.LSTTL.all;
    use work.TTLPrivate.all;

entity SN74LS253N is
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
end entity SN74LS253N;

architecture BEHAV of SN74LS253N is
    signal D : TTLInputs(2 downto 1, 4 downto 1);
    signal A : unsigned(2 downto 1);
    signal E : std_logic_vector(2 downto 1);        -- Enables: B:A channels
    signal Q : std_logic_vector(2 downto 1);
    signal C : natural range 4 downto 1;
    
begin
    A <= (X_2,  X_14);
    C <= 1+TTL_to_integer(A);
    E <= (not X_15, not X_1 );                      -- Active high internally
    D <= ((X_13, X_12, X_11, X_10), (X_3, X_4, X_5, X_6));
    (X_9, X_7) <= Q;
    
    G: for i in E'range generate
    begin
        OQ: TTL3State 
        generic map(
            tPLH => tPLH,
            tPHL => tPHL,
            tPZH => tPZX,
            tPZL => tPZX,
            tPHZ => tPXZ,
            tPLZ => tPXZ
        )
        port map(
            A => D(i,C),
            E => E(i),
            Y => Q(i)
        );
    end generate;
end architecture BEHAV;

-----------------------------------------------------------------------
-- SN74LS256N: Dual 4-bit addressable latch
--             Verified 18/12/2016
-----------------------------------------------------------------------
library ieee;
    use ieee.std_logic_1164.all;
    use ieee.std_logic_misc.all;
    use ieee.numeric_std.all;

    use work.LSTTL.all;
    use work.TTLPrivate.all;

entity SN74LS256N is
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
end entity SN74LS256N;

architecture BEHAV of SN74LS256N is
    signal AD : unsigned(1 downto 0);
    signal A, B : std_logic_vector(3 downto 0);
begin
    AD <= (X_2, X_1);
    (X_7,  X_6,  X_5,  X_4) <= A;
    (X_12, X_11, X_10, X_9) <= B;
    
    L1: TTLadLatch
    generic map(
        ABits => 2,
        tPXDA => tPXDA,
        tPHLC => tPHLC
    )
    port map(
        D     => X_3,
        En    => X_14,
        Cn    => X_15,
        A     => AD,
        Z     => A
    );

    L2: TTLadLatch
    generic map(
        ABits => 2,
        tPXDA => tPXDA,
        tPHLC => tPHLC
    )
    port map(
        D     => X_13,
        En    => X_14,
        Cn    => X_15,
        A     => AD,
        Z     => B
    );
end architecture BEHAV;

-----------------------------------------------------------------------
-- SN74LS257N: Quad 2-input multiplexer (3-state outputs)
--             Verified 18/12/2016
-----------------------------------------------------------------------
library ieee;
    use ieee.std_logic_1164.all;
    use ieee.std_logic_misc.all;
    use ieee.numeric_std.all;

    use work.LSTTL.all;
    use work.TTLPrivate.all;

entity SN74LS257N is
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
end entity SN74LS257N;

architecture BEHAV of SN74LS257N is
    signal D    : std_logic_vector(7 downto 0);     -- Raw data, vectorized
    signal Y, Z : std_logic_vector(3 downto 0);     -- Output data, ditto
    signal E    : std_logic;                        -- Output enable, active high
    signal N    : unsigned(1 downto 0);             -- Input select, as unsigned
    signal A    : natural;                          -- Ditto, numeric
begin
    N <= '0' & X_1;
    A <= to_integer(N) after tPS - tPI;
    D <= (X_10, X_11, X_13, X_14, X_6, X_5, X_3, X_2);
    E <= not X_15;
    (X_9, X_12, X_7, X_4) <= Z;
    
    GE: for i in Y'range generate
    begin
        ZB: TTL3State
        generic map(
            tPLH => tPI,
            tPHL => tPI,
            tPZH => tPE,
            tPZL => tPE,
            tPHZ => tPE,
            tPLZ => tPE
        )
        port map(
            A    => Y(i),
            E    => E,
            Y    => Z(i)
        );
    end generate;
    
    MUX: process(all) is
    begin
        for i in Y'range loop
            Y(i) <= D((2*i)+A);
        end loop;
    end process;   
end architecture BEHAV;

-----------------------------------------------------------------------
-- SN74LS258N: Quad 2-input multiplexer (inverting 3-state outputs)
-----------------------------------------------------------------------
library ieee;
    use ieee.std_logic_1164.all;
    use ieee.std_logic_misc.all;
    use ieee.numeric_std.all;

    use work.LSTTL.all;
    use work.TTLPrivate.all;

entity SN74LS258N is
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
end entity SN74LS258N;

architecture BEHAV of SN74LS258N is
    signal D    : std_logic_vector(7 downto 0);     -- Raw data, vectorized
    signal Y, Z : std_logic_vector(3 downto 0);     -- Output data, ditto
    signal E    : std_logic;                        -- Output enable, active high
    signal N    : unsigned(1 downto 0);             -- Input select, as unsigned
    signal A    : natural;                          -- Ditto, numeric
begin
    N <= '0' & X_1;
    A <= to_integer(N) after tPS - tPI;
    D <= (X_10, X_11, X_13, X_14, X_6, X_5, X_3, X_2);
    E <= not X_15;
    (X_9, X_12, X_7, X_4) <= Z;
    
    GE: for i in Y'range generate
    begin
        ZB: TTL3State
        generic map(
            tPLH => tPI,
            tPHL => tPI,
            tPZH => tPE,
            tPZL => tPE,
            tPHZ => tPE,
            tPLZ => tPE
        )
        port map(
            A    => Y(i),
            E    => E,
            Y    => Z(i)
        );
    end generate;
    
    MUX: process(all) is
    begin
        for i in Y'range loop
            Y(i) <= not D((2*i)+A);
        end loop;
    end process;
end architecture BEHAV;

-----------------------------------------------------------------------
-- SN74LS259N: 8-bit addressable latch
-----------------------------------------------------------------------
library ieee;
    use ieee.std_logic_1164.all;
    use ieee.std_logic_misc.all;
    use ieee.numeric_std.all;

    use work.LSTTL.all;
    use work.TTLPrivate.all;

entity SN74LS259N is
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
end entity SN74LS259N;

architecture BEHAV of SN74LS259N is
    signal AD : unsigned(2 downto 0);
    signal A  : std_logic_vector(7 downto 0);
begin
    AD <= (X_3, X_2, X_1);
    (X_12, X_11, X_10, X_9, X_7, X_6, X_5, X_4) <= A;
    
    L1: TTLadLatch
    generic map(
        ABits => 3,
        tPXDA => tPXDA,
        tPHLC => tPHLC
    )
    port map(
        D     => X_13,
        En    => X_14,
        Cn    => X_15,
        A     => AD,
        Z     => A
    );
end architecture BEHAV;

-----------------------------------------------------------------------
-- SN74LS260N: Dual 5-input NOR gate
--             Verified 30/05/2016
-----------------------------------------------------------------------
library ieee;
    use ieee.std_logic_1164.all;

    use work.LSTTL.all;
    use work.TTLPrivate.all;

entity SN74LS260N is
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
end entity SN74LS260N;

architecture BEHAV of SN74LS260N is
    signal A : TTLInputs (1 to 2, 1 to 5);
    signal Y : TTLOutputs(1 to 2);
  
begin
    A <= ( (X_1, X_2, X_3, X_12, X_13), (X_4, X_8, X_9, X_10, X_11) );
    
    (X_5, X_6) <= Y;
  
    G: TTLgate
    generic map(
        mode   => Zor,      -- Zand, Zor, Zxor, Zbuf
        invert => '1',      -- '1' will invert the output
        ohigh  => '1',      -- '1' = normal, 'Z' = open collectors
        tPLH   => tPLH,
        tPHL   => tPHL
    )
    port map(
        ins   => A,
        outs  => Y
    );
end architecture BEHAV;

-----------------------------------------------------------------------
-- SN74LS266N: Quad 2-input XNOR gate (open collector)
--             Verified 30/05/2016
-----------------------------------------------------------------------
library ieee;
    use ieee.std_logic_1164.all;

    use work.LSTTL.all;
    use work.TTLPrivate.all;

entity SN74LS266N is
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
end entity SN74LS266N;

architecture BEHAV of SN74LS266N is
    signal A : TTLInputs (1 to 4, 1 to 2);
    signal Y : TTLOutputs(1 to 4);
  
begin
    A <= ( (X_1, X_2), (X_5, X_6), (X_8, X_9), (X_12, X_13) );
    
    (X_3, X_4, X_10, X_11) <= Y;
  
    G: TTLgate
    generic map(
        mode   => Zxor,     -- Zand, Zor, Zxor, Zbuf
        invert => '1',      -- '1' will invert the output
        ohigh  => 'Z',      -- '1' = normal, 'Z' = open collectors
        tPLH   => tPLH,
        tPHL   => tPHL
    )
    port map(
        ins   => A,
        outs  => Y
    );
  
end architecture BEHAV;

-----------------------------------------------------------------------
-- SN74LS273N: 8-bit register, with Clear
--             Verified 18/12/2016
-----------------------------------------------------------------------
library ieee;
    use ieee.std_logic_1164.all;

    use work.LSTTL.all;
    use work.TTLPrivate.all;

entity SN74LS273N is
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
end entity SN74LS273N;

architecture BEHAV of SN74LS273N is
    signal A, Y : std_logic_vector(7 downto 0);
begin
    A <= (X_18, X_17, X_14, X_13, X_8, X_7, X_4, X_3);
    (X_19, X_16, X_15, X_12, X_9, X_6, X_5, X_2) <= Y after tPX;
    
    process(all) is
    begin
        if X_1 = '0' then
            Y <= (others => '0');
        elsif rising_edge(X_11) then
            Y <= A;
        end if;
    end process;
end architecture BEHAV;

-----------------------------------------------------------------------
-- SN74LS279N: Quad set/reset latch
--             Verified 18/12/2016
-----------------------------------------------------------------------
library ieee;
    use ieee.std_logic_1164.all;

    use work.LSTTL.all;
    use work.TTLPrivate.all;

entity SN74LS279N is
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
end entity SN74LS279N;

architecture BEHAV of SN74LS279N is
    signal R, S, Q : std_logic_vector(3 downto 0);
begin
    R  <= (X_15, X_12 and X_11, X_5, X_1);
    S  <= (X_14, X_10, X_6, X_3 and  X_2);
    (X_13, X_9, X_7, X_4) <= Q after tPX;
    
    process(all) is
        variable Z : std_logic_vector(1 downto 0);
    begin
        for i in Q'range loop
            Z := S(i) & R(i);
            case Z is
                when "11"   => null;
                when "01"   => Q(i) <= '1';
                when "10"   => Q(i) <= '0';
                when others => Q(i) <= 'X';
            end case;
        end loop;
    end process;
end architecture BEHAV;

-----------------------------------------------------------------------
-- SN74LS280N: 9-bit parity generator/checker
--             Verified 18/12/2016
-----------------------------------------------------------------------
library ieee;
    use ieee.std_logic_1164.all;
    use ieee.std_logic_misc.all;

    use work.LSTTL.all;
    use work.TTLPrivate.all;

entity SN74LS280N is
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
end entity SN74LS280N;

architecture BEHAV of SN74LS280N is
    signal A    : std_logic_vector(8 downto 0);
    signal Y, Z : std_logic;
begin
    A <= (X_4, X_2, X_1, X_13, X_12, X_11, X_10, X_9, X_8);
    Y <= xor_reduce(A);
    
    OD: TTLdelay
    generic map(
        tPLH => tPLH,
        tPHL => tPHL
    )
    port map(
        A => Y,
        B => Z
    );
    
    X_6 <= Z;
    X_5 <= not Z;
end architecture BEHAV;

-----------------------------------------------------------------------
-- SN74LS283N: 4-bit binary full adder (with fast carry)
--             Verified 06/06/2016
-----------------------------------------------------------------------
library ieee;
    use ieee.std_logic_1164.all;
    use ieee.numeric_std.all;

    use work.LSTTL.all;
    use work.TTLPrivate.all;

entity SN74LS283N is
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
end entity SN74LS283N;

architecture BEHAV of SN74LS283N is
    signal A, B, S : unsigned(4 downto 0);  -- S(4) = carry-out
    signal SUM     : unsigned(3 downto 0);
begin
    A <= ('0', X_12, X_14, X_3, X_5);
    B <= ('0', X_11, X_15, X_2, X_6);
    
    S <= A + B + X_7;

    G: for i in SUM'range generate
    begin
    DSM: TTLdelay 
        generic map(
            tPLH => tPLHS,
            tPHL => tPHLS
        )
        port map(
            A => S(i),
            B => SUM(i)
        );
    end generate;
    
    DCY: TTLdelay 
        generic map(
            tPLH => tPLHC,
            tPHL => tPHLC
        )
        port map(
            A => S(4),
            B => X_9
        );
    
    (X_10, X_13, X_1, X_4) <= SUM;
end architecture BEHAV;

-----------------------------------------------------------------------
-- SN74LS289N: 64-bit random access memory (open collector)
--             Verified 06/06/2016
-----------------------------------------------------------------------
library ieee;
    use ieee.std_logic_1164.all;
    use ieee.std_logic_misc.all;
    use ieee.numeric_std.all;

    use work.LSTTL.all;
    use work.TTLPrivate.all;

entity SN74LS289N is
generic(
    tPLC : time    := 10 ns;
    tPLA : time    := 37 ns;
    tSUD : time    := 25 ns;
    tSUA : time    := 10 ns
);
port(
    X_1  : in    std_logic;  -- A0
    X_2  : in    std_logic;  -- CS\
    X_3  : in    std_logic;  -- WE\
    X_4  : in    std_logic;  -- D1
    X_5  : out   std_logic;  -- Q1\
    X_6  : in    std_logic;  -- D2
    X_7  : out   std_logic;  -- Q2\
    X_8  : inout std_logic;  -- GND
    X_9  : out   std_logic;  -- Q3\
    X_10 : in    std_logic;  -- D3
    X_11 : out   std_logic;  -- Q4\
    X_12 : in    std_logic;  -- D4
    X_13 : in    std_logic;  -- A3
    X_14 : in    std_logic;  -- A2
    X_15 : in    std_logic;  -- A1
    X_16 : inout std_logic   -- Vcc
);
end entity SN74LS289N;

architecture BEHAV of SN74LS289N is
    signal  RE, WE   : std_logic := '1';
    signal  ia       : std_logic_vector(3 downto 0) := (others => '0');
    signal  D, QB, Q : std_logic_vector(3 downto 0);
begin
    RE <= not(    X_3 and not X_2);
    WE <= not(not X_3 and not X_2);
    ia <=    (X_13, X_14, X_15, X_1);
    D  <=    (X_12, X_10, X_6, X_4);
    (X_11, X_9, X_7, X_5) <= Q;
    
    MB: TTLramblock
    generic map(
        Omode => OpenColl,
        INVT  => '1',
        tPLC  => tPLC,
        tPLA  => tPLA,
        tSUD  => tSUD,
        tSUA  => tSUA
    )         
    port map( 
        RA    => ia,
        WA    => ia,
        D     => D,
        O     => Q,
        CE    => '0',
        RE    => RE,
        WE    => WE
    );    
end architecture BEHAV;

-----------------------------------------------------------------------
-- SN74LS290N: BCD decade counter
--             Verified 31/05/2016
-----------------------------------------------------------------------
library ieee;
    use ieee.std_logic_1164.all;

    use work.LSTTL.all;
    use work.TTLPrivate.all;

entity SN74LS290N is
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
end entity SN74LS290N;

architecture BEHAV of SN74LS290N is
    signal rst, set : std_logic;
    signal val      : std_logic_vector(3 downto 0);
begin
    rst <= not (X_12 and X_13);
    set <= not (X_1  and X_3 );
    (X_8, X_4, X_5, X_9) <= val;
    
    M1: TTLcount4
    generic map(
        tPLH0   => tPLH0,
        tPHL0   => tPHL0,
        tPLH1   => tPLH1,
        tPHL1   => tPHL1,
        tPLH2   => tPLH2,
        tPHL2   => tPHL2,
        tPLH3   => tPLH3,
        tPHL3   => tPHL3,
        modulus => 10
    )
    port map(
        ld   => '1',
        d    => (others => '0'),
        clka => X_10,
        clkb => X_11,
        rst  => rst,
        set  => set,
        val  => val
    );
end architecture BEHAV;

-----------------------------------------------------------------------
-- SN74LS293N: 4-bit binary counter
--             Verified 31/05/2016
-----------------------------------------------------------------------
library ieee;
    use ieee.std_logic_1164.all;

    use work.LSTTL.all;
    use work.TTLPrivate.all;

entity SN74LS293N is
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
end entity SN74LS293N;

architecture BEHAV of SN74LS293N is
    signal rst : std_logic;
    signal val : std_logic_vector(3 downto 0);
begin
    rst <= not (X_12 and X_13);
    (X_8, X_4, X_5, X_9) <= val;
    
    M1: TTLcount4
    generic map(
        tPLH0   => tPLH0,
        tPHL0   => tPHL0,
        tPLH1   => tPLH1,
        tPHL1   => tPHL1,
        tPLH2   => tPLH2,
        tPHL2   => tPHL2,
        tPLH3   => tPLH3,
        tPHL3   => tPHL3,
        modulus => 16
    )
    port map(
        ld   => '1',
        d    => (others => '0'),
        clka => X_10,
        clkb => X_11,
        rst  => rst,
        set  => '1',
        val  => val
    );
end architecture BEHAV;

-----------------------------------------------------------------------
-- SN74LS295AN: 4-bit shift register (3-state outputs)
--              Verified 18/12/2016
-----------------------------------------------------------------------
library ieee;
    use ieee.std_logic_1164.all;

    use work.LSTTL.all;
    use work.TTLPrivate.all;

entity SN74LS295AN is
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
end entity SN74LS295AN;

architecture BEHAV of SN74LS295AN is
    signal P, REG, Q : std_logic_vector(3 downto 0);
    
    alias CP  is X_9;
    alias PE  is X_6;
    alias DS  is X_1;
    alias OE  is X_8;
    
begin
    P <= (X_5, X_4, X_3, X_2);
    (X_10, X_11, X_12, X_13) <= Q;
    
    process(CP) is
    begin
        if falling_edge(CP) then
            if PE = '1' then            -- Load
                REG <= P;
            else
                REG <= REG(2 downto 0) & DS;
            end if;
        end if;
    end process;
    
    G: for i in REG'range generate
    begin
        OB: TTL3State    
        generic map(
            tPLH => tPLH,
            tPHL => tPHL,
            tPZH => tPZH,
            tPZL => tPZL,
            tPHZ => tPHZ,
            tPLZ => tPLZ
        )
        port map(
            A    => REG(i),
            E    => OE,
            Y    => Q(i)
        );
    end generate;
    
    DO: TTLdelays
    generic map(
        tPLH => tPLH,
        tPHL => tPHL
    )
    port map(
        A => REG,
        B => Q
    );
end architecture BEHAV;

-----------------------------------------------------------------------
-- SN74LS298N: Quad 2-port register (multiplexer with storage)
--             Verified 19/12/2016
-----------------------------------------------------------------------
library ieee;
    use ieee.std_logic_1164.all;

    use work.LSTTL.all;
    use work.TTLPrivate.all;

entity SN74LS298N is
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
end entity SN74LS298N;

architecture BEHAV of SN74LS298N is
    signal D    : TTLInputs(4 downto 1, 2 downto 1);
    signal R, Q : std_logic_vector(4 downto 1);
    signal C    : natural range 2 downto 1;

    alias CP is X_11;
    alias S  is X_10;
    
begin
    C <= 2 when To_bit(S) = '1' else 1;
    D <= ((X_6,  X_7), (X_5,  X_9), (X_1,  X_4), (X_2,  X_3));
    (X_12, X_13, X_14, X_15) <= Q;
    
    process(CP) is              -- Output register
    begin
        if falling_edge(CP) then
            for i in R'range loop
                R(i) <= D(i,C);
            end loop;
        end if;
    end process;

    OQ: TTLdelays 
    generic map(
        tPLH => tPLH,
        tPHL => tPHL
    )
    port map(
        A => R,
        B => Q
    );
end architecture BEHAV;

-----------------------------------------------------------------------
-- SN74LS299N: 8-bit universal shift/storage register
--             Verified 20/12/2016
-----------------------------------------------------------------------
library ieee;
    use ieee.std_logic_1164.all;
    use ieee.numeric_std.all;

    use work.LSTTL.all;
    use work.TTLPrivate.all;

entity SN74LS299N is
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
end entity SN74LS299N;

architecture BEHAV of SN74LS299N is
    signal D, Q, Z : std_logic_vector(0 to 7);  -- Internal register (NB direction)
    signal S   : unsigned(1 downto 0);
    signal OE  : std_logic;
              
    alias  MR  is X_9;
    alias  CP  is X_12;
    alias  DS0 is X_11;
    alias  DS7 is X_18;
    
begin
    S    <= (X_19, X_1);
    OE   <= not(X_2) and not(X_3) and not(X_1 and X_19);
    D    <= (X_7, X_13, X_6, X_14, X_5, X_15, X_4, X_16);   -- Parallel load
    X_8  <= Q(0);
    X_17 <= Q(7);
    (X_7, X_13, X_6, X_14, X_5, X_15, X_4, X_16) <= Z;      -- When driven
    
    G: for i in Q'range generate
    begin
        OB: TTL3State   
        generic map(
            tPLH => tPLH,
            tPHL => tPHL,
            tPZH => tPZH,
            tPZL => tPZL,
            tPHZ => tPHZ,
            tPLZ => tPLZ
        )
        port map(
            A    => Q(i),
            E    => OE,
            Y    => Z(i)
        );
    end generate;
    
    process(MR, CP) is                                  -- Main register
    begin
        if MR = '0' then
            Q <= (others => '0') after tRSD;            -- MR is slightly late
        elsif rising_edge(CP) then
            case S is
                when "01"   => Q <= DS0 & Q(0 to 6);    -- Shift right
                when "10"   => Q <= Q(1 to 7) & DS7;    -- Shift left
                when "11"   => Q <= D;                  -- Parallel load
                when others => null;                    -- "00" hold
            end case;
        end if;
    end process;
end architecture BEHAV;

-----------------------------------------------------------------------
-- SN74LS322N: 8-bit SIPO register (with sign extend)
--             Verified 21/12/2016
-----------------------------------------------------------------------
library ieee;
    use ieee.std_logic_1164.all;
    use ieee.numeric_std.all;

    use work.LSTTL.all;
    use work.TTLPrivate.all;

entity SN74LS322N is
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
end entity SN74LS322N;

architecture BEHAV of SN74LS322N is
    signal D,   Q,  Z : std_logic_vector(7 downto 0);  -- Internal register (NB direction)
    signal OEI, DI    : std_logic;
              
    alias  MR  is X_9;
    alias  CP  is X_11;
    alias  D0  is X_3;
    alias  D1  is X_17;
    alias  S   is X_19;
    alias  RE  is X_1;
    alias  SP  is X_2;
    alias  SE  is X_18;
    alias  OE  is X_8;
    alias  Q0  is Q(0);
    
begin
    OEI  <= (SP or RE) and not(OE);
    DI   <= D0 when S = '0' else D1;
    D    <= (X_4, X_16, X_5, X_15, X_6, X_14, X_7, X_13);   -- Parallel load
    X_12 <= Q0;
    (X_4, X_16, X_5, X_15, X_6, X_14, X_7, X_13) <= Z;      -- When driven
    
    G: for i in Q'range generate
    begin
        OB: TTL3State   
        generic map(
            tPLH => tPLH,
            tPHL => tPHL,
            tPZH => tPZH,
            tPZL => tPZL,
            tPHZ => tPHZ,
            tPLZ => tPLZ
        )
        port map(
            A    => Q(i),
            E    => OEI,
            Y    => Z(i)
        );
    end generate;
    
    process(MR, CP) is                                  -- Main register
        variable SEL : unsigned(2 downto 0);
    begin
        if MR = '0' then
            Q <= (others => '0') after tRSD;            -- MR is slightly late
        elsif rising_edge(CP) then
            SEL := RE & SP & SE;
            case SEL is
                when "011"  => Q <= DI   & Q(7 downto 1);   -- Shift right
                when "010"  => Q <= Q(7) & Q(7 downto 1);   -- Sign extend
                when "00-"  => Q <= D;                      -- Parallel load
                when others => null;                        -- Hold
            end case;
        end if;
    end process;
    
end architecture BEHAV;

-----------------------------------------------------------------------
-- SN74LS323N: 8-bit universal shift/storage register
--             Verified 21/12/2016
-----------------------------------------------------------------------
library ieee;
    use ieee.std_logic_1164.all;
    use ieee.numeric_std.all;

    use work.LSTTL.all;
    use work.TTLPrivate.all;

entity SN74LS323N is
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
end entity SN74LS323N;

architecture BEHAV of SN74LS323N is
    signal D, Q, Z : std_logic_vector(0 to 7);  -- Internal register (NB direction)
    signal OE  : std_logic;
              
    alias  SR  is X_9;
    alias  CP  is X_12;
    alias  DS0 is X_11;
    alias  DS7 is X_18;
    
begin
    OE   <= not(X_2) and not(X_3) and not(X_1 and X_19);
    D    <= (X_7, X_13, X_6, X_14, X_5, X_15, X_4, X_16);   -- Parallel load
    X_8  <= Q(0);
    X_17 <= Q(7);
    (X_7, X_13, X_6, X_14, X_5, X_15, X_4, X_16) <= Z;      -- When driven
    
    G: for i in Q'range generate
    begin
        OB: TTL3State   
        generic map(
            tPLH => tPLH,
            tPHL => tPHL,
            tPZH => tPZH,
            tPZL => tPZL,
            tPHZ => tPHZ,
            tPLZ => tPLZ
        )
        port map(
            A    => Q(i),
            E    => OE,
            Y    => Z(i)
        );
    end generate;
    
    process(CP) is                                          -- Main register
        variable S : unsigned(2 downto 0);
    begin
        if rising_edge(CP) then
            S := (SR, X_19, X_1);
            case S is
                when "0--"  => Q <= (others => '0');    -- Sync. reset
                when "101"  => Q <= DS0 & Q(0 to 6);    -- Shift right
                when "110"  => Q <= Q(1 to 7) & DS7;    -- Shift left
                when "111"  => Q <= D;                  -- Parallel load
                when others => null;                    -- Hold
            end case;
        end if;
    end process;
end architecture BEHAV;

-----------------------------------------------------------------------
-- SN74LS352N: Dual 4-input multiplexer
--             Verified 21/12/2016
-----------------------------------------------------------------------
library ieee;
    use ieee.std_logic_1164.all;
    use ieee.std_logic_misc.all;
    use ieee.numeric_std.all;

    use work.LSTTL.all;
    use work.TTLPrivate.all;

entity SN74LS352N is
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
end entity SN74LS352N;

architecture BEHAV of SN74LS352N is
    signal D : TTLInputs(2 downto 1, 4 downto 1);
    signal A : unsigned(2 downto 1);
    signal E : std_logic_vector(2 downto 1);        -- Enables: B:A channels
    signal Q : std_logic_vector(2 downto 1);
    signal C : natural range 4 downto 1;
    
begin
    A <= (X_2,  X_14);
    C <= 1+TTL_to_integer(A);
    E <= (X_15, X_1 );
    D <= ((X_13,  X_12,  X_11,  X_10), (X_3,  X_4,  X_5,  X_6));
    (X_9, X_7) <= Q;
    
    G: for i in E'range generate
        signal Z : std_logic;
    begin
        Z <= not((not E(i)) and D(i,C));
        
        OQ: TTLdelay 
        generic map(
            tPLH => tPLH,
            tPHL => tPHL
        )
        port map(
            A => Z,
            B => Q(i)
        );
    end generate;
end architecture BEHAV;

-----------------------------------------------------------------------
-- SN74LS353N: Dual 4-input multiplexer (3-state outputs)
--             Verified 21/12/2016
-----------------------------------------------------------------------
library ieee;
    use ieee.std_logic_1164.all;
    use ieee.std_logic_misc.all;
    use ieee.numeric_std.all;

    use work.LSTTL.all;
    use work.TTLPrivate.all;

entity SN74LS353N is
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
end entity SN74LS353N;

architecture BEHAV of SN74LS353N is
    signal D : TTLInputs(2 downto 1, 4 downto 1);
    signal A : unsigned(2 downto 1);
    signal E : std_logic_vector(2 downto 1);        -- Enables: B:A channels
    signal Q : std_logic_vector(2 downto 1);
    signal C : natural range 4 downto 1;
    
begin
    A <= (X_2,  X_14);
    C <= 1+TTL_to_integer(A);
    E <= (not X_15, not X_1 );                      -- Active high internally
    D <= ((X_13, X_12, X_11, X_10), (X_3, X_4, X_5, X_6));
    (X_9, X_7) <= Q;
    
    G: for i in E'range generate
        signal Z : std_logic;
    begin
        Z <= not D(i,C);
        OQ: TTL3State 
        generic map(
            tPLH => tPLH,
            tPHL => tPHL,
            tPZH => tPZX,
            tPZL => tPZX,
            tPHZ => tPXZ,
            tPLZ => tPXZ
        )
        port map(
            A => Z,
            E => E(i),
            Y => Q(i)
        );
    end generate;
end architecture BEHAV;

-----------------------------------------------------------------------
-- SN74LS365AN: Hex 3-state buffer
--             Verified 21/12/2016
-----------------------------------------------------------------------
library ieee;
    use ieee.std_logic_1164.all;
    use ieee.numeric_std.all;

    use work.LSTTL.all;
    use work.TTLPrivate.all;

entity SN74LS365AN is
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
end entity SN74LS365AN;

architecture BEHAV of SN74LS365AN is
    signal A, Z : std_logic_vector(5 downto 0);
    signal E    : std_logic;
begin
    E <= not(X_1 or X_15);
    A <= (X_14, X_12, X_10, X_6, X_4, X_2);
    (X_13, X_11, X_9, X_7, X_5, X_3) <= Z;
    
    G: for i in A'range generate
        signal B : std_logic;
    begin
        B <= A(i);
        TB: TTL3State   
        generic map(
            tPLH => tPLH,
            tPHL => tPHL,
            tPZH => tPZH,
            tPZL => tPZL,
            tPHZ => tPHZ,
            tPLZ => tPLZ
        )
        port map(
            A    => B,
            E    => E,
            Y    => Z(i)
        );
    end generate;
end architecture BEHAV;

-----------------------------------------------------------------------
-- SN74LS366AN: Hex 3-state inverter buffer
--             Verified 21/12/2016
-----------------------------------------------------------------------
library ieee;
    use ieee.std_logic_1164.all;
    use ieee.numeric_std.all;

    use work.LSTTL.all;
    use work.TTLPrivate.all;

entity SN74LS366AN is
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
end entity SN74LS366AN;

architecture BEHAV of SN74LS366AN is
    signal A, Z : std_logic_vector(5 downto 0);
    signal E    : std_logic;
begin
    E <= not(X_1 or X_15);
    A <= (X_14, X_12, X_10, X_6, X_4, X_2);
    (X_13, X_11, X_9, X_7, X_5, X_3) <= Z;
    
    G: for i in A'range generate
        signal B : std_logic;
    begin
        B <= not A(i);
        TB: TTL3State   
        generic map(
            tPLH => tPLH,
            tPHL => tPHL,
            tPZH => tPZH,
            tPZL => tPZL,
            tPHZ => tPHZ,
            tPLZ => tPLZ
        )
        port map(
            A    => B,
            E    => E,
            Y    => Z(i)
        );
    end generate;
end architecture BEHAV;

-----------------------------------------------------------------------
-- SN74LS367AN: Hex 3-state buffer (2 & 4-bit sections)
--              Verified 21/12/2016
-----------------------------------------------------------------------
library ieee;
    use ieee.std_logic_1164.all;
    use ieee.numeric_std.all;

    use work.LSTTL.all;
    use work.TTLPrivate.all;

entity SN74LS367AN is
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
end entity SN74LS367AN;

architecture BEHAV of SN74LS367AN is
    signal A, Z : std_logic_vector(5 downto 0);
begin
    A <= (X_14, X_12, X_10, X_6, X_4, X_2);
    (X_13, X_11, X_9, X_7, X_5, X_3) <= Z;
    
    G: for i in A'range generate
        signal B, E : std_logic;
    begin
        B <= A(i);
        E <= not X_15 when i > 3 else not X_1;
        TB: TTL3State   
        generic map(
            tPLH => tPLH,
            tPHL => tPHL,
            tPZH => tPZH,
            tPZL => tPZL,
            tPHZ => tPHZ,
            tPLZ => tPLZ
        )
        port map(
            A    => B,
            E    => E,
            Y    => Z(i)
        );
    end generate;
end architecture BEHAV;

-----------------------------------------------------------------------
-- SN74LS368AN: Hex 3-state inverter/buffer (2 & 4-bit sections)
--              Verified 21/12/2016
-----------------------------------------------------------------------
library ieee;
    use ieee.std_logic_1164.all;
    use ieee.numeric_std.all;

    use work.LSTTL.all;
    use work.TTLPrivate.all;

entity SN74LS368AN is
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
end entity SN74LS368AN;

architecture BEHAV of SN74LS368AN is
    signal A, Z : std_logic_vector(5 downto 0);
begin
    A <= (X_14, X_12, X_10, X_6, X_4, X_2);
    (X_13, X_11, X_9, X_7, X_5, X_3) <= Z;
    
    G: for i in A'range generate
        signal B, E : std_logic;
    begin
        B <= not A(i);
        E <= not X_15 when i > 3 else not X_1;
        TB: TTL3State   
        generic map(
            tPLH => tPLH,
            tPHL => tPHL,
            tPZH => tPZH,
            tPZL => tPZL,
            tPHZ => tPHZ,
            tPLZ => tPLZ
        )
        port map(
            A    => B,
            E    => E,
            Y    => Z(i)
        );
    end generate;
end architecture BEHAV;

-----------------------------------------------------------------------
-- SN74LS373N: Octal transparent latch (3-state outputs)
--             Verified 21/12/2016
-----------------------------------------------------------------------
library ieee;
    use ieee.std_logic_1164.all;

    use work.LSTTL.all;
    use work.TTLPrivate.all;

entity SN74LS373N is
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
end entity SN74LS373N;

architecture BEHAV of SN74LS373N is
    signal D, Q, Z : std_logic_vector(7 downto 0);
    signal LE, OE  : std_logic;
    
begin
    LE <= X_11;
    OE <= not X_1;
    D  <= (X_18, X_17, X_14, X_13, X_8, X_7, X_4, X_3);
    (X_19, X_16, X_15, X_12, X_9,  X_6, X_5, X_2) <= Z;
    
    process(all) is
    begin
        if LE = '1' then
            Q <= D;
        end if;
    end process;
    
    G: for i in D'range generate
    begin
        TB: TTL3State   
        generic map(
            tPLH => tPLH,
            tPHL => tPHL,
            tPZH => tPZH,
            tPZL => tPZL,
            tPHZ => tPHZ,
            tPLZ => tPLZ
        )
        port map(
            A    => Q(i),
            E    => OE,
            Y    => Z(i)
        );
    end generate;
end architecture BEHAV;

-----------------------------------------------------------------------
-- SN74LS374N: Octal D-flipflop (3-state outputs)
--             Verified 21/12/2016
-----------------------------------------------------------------------
library ieee;
    use ieee.std_logic_1164.all;

    use work.LSTTL.all;
    use work.TTLPrivate.all;

entity SN74LS374N is
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
end entity SN74LS374N;

architecture BEHAV of SN74LS374N is
    signal D, Q, Z : std_logic_vector(7 downto 0);
    signal CP, OE  : std_logic;
    
begin
    CP <= X_11;
    OE <= not X_1;
    D  <= (X_18, X_17, X_14, X_13, X_8, X_7, X_4, X_3);
    (X_19, X_16, X_15, X_12, X_9,  X_6, X_5, X_2) <= Z;
    
    process(CP) is
    begin
        if rising_edge(CP) then
            Q <= D;
        end if;
    end process;
    
    G: for i in D'range generate
    begin
        TB: TTL3State   
        generic map(
            tPLH => tPLH,
            tPHL => tPHL,
            tPZH => tPZH,
            tPZL => tPZL,
            tPHZ => tPHZ,
            tPLZ => tPLZ
        )
        port map(
            A    => Q(i),
            E    => OE,
            Y    => Z(i)
        );
    end generate;
end architecture BEHAV;

-----------------------------------------------------------------------
-- SN74LS375N: 4-bit latch
--             Verified 21/12/2016
-----------------------------------------------------------------------
library ieee;
    use ieee.std_logic_1164.all;

    use work.LSTTL.all;
    use work.TTLPrivate.all;

entity SN74LS375N is
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
end entity SN74LS375N;

-- '375 is just a '75 with the pins rearranged
architecture BEHAV of SN74LS375N is
begin
    D: SN74LS75N
    generic map(
        tSETUP => tSETUP,
        tPLHCP => tPLHCP,
        tPHLCP => tPHLCP
    )
    port map(
        X_1  => X_2,  -- Q1\
        X_2  => X_1,  -- D1
        X_3  => X_7,  -- D2
        X_4  => X_12, -- E34
        X_5  => open, -- Vcc
        X_6  => X_9,  -- D3
        X_7  => X_15, -- D4
        X_8  => X_14, -- Q4\
        X_9  => X_13, -- Q4
        X_10 => X_10, -- Q3\
        X_11 => X_11, -- Q3
        X_12 => open, -- GND
        X_13 => X_4,  -- E12
        X_14 => X_6,  -- Q2\
        X_15 => X_5,  -- Q2
        X_16 => X_3   -- Q1
    );
end architecture BEHAV;

-----------------------------------------------------------------------
-- SN74LS377N: Octal D-flipflop
--             Verified 21/12/2016
-----------------------------------------------------------------------
library ieee;
    use ieee.std_logic_1164.all;

    use work.LSTTL.all;
    use work.TTLPrivate.all;

entity SN74LS377N is
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
end entity SN74LS377N;

architecture BEHAV of SN74LS377N is
    signal D, R : std_logic_vector(7 downto 0);
    
    alias CP is X_11;
    alias E  is X_1;
    
begin
    D <= (X_18, X_17, X_14, X_13, X_8, X_7, X_4, X_3);
    (X_19, X_16, X_15, X_12, X_9, X_6, X_5, X_2) <= R after tPXX;
    
    process(CP) is
    begin
        if rising_edge(CP) then
            if E = '0' then
                R <= D;
            end if;
        end if;
    end process;
end architecture BEHAV;

-----------------------------------------------------------------------
-- SN74LS378N: 6-bit D register
--             Verified 21/12/2016
-----------------------------------------------------------------------
library ieee;
    use ieee.std_logic_1164.all;

    use work.LSTTL.all;
    use work.TTLPrivate.all;

entity SN74LS378N is
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
end entity SN74LS378N;

architecture BEHAV of SN74LS378N is
    signal D, R : std_logic_vector(5 downto 0);
    
    alias CP is X_9;
    alias E  is X_1;
    
begin
    D <= (X_14, X_13, X_11, X_6, X_4, X_3);
    (X_15, X_12, X_10, X_7, X_5, X_2) <= R after tPXX;
    
    process(CP) is
    begin
        if rising_edge(CP) then
            if E = '0' then
                R <= D;
            end if;
        end if;
    end process;
end architecture BEHAV;

-----------------------------------------------------------------------
-- SN74LS379N: 4-bit D register
--             Verified 21/12/2016
-----------------------------------------------------------------------
library ieee;
    use ieee.std_logic_1164.all;

    use work.LSTTL.all;
    use work.TTLPrivate.all;

entity SN74LS379N is
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
end entity SN74LS379N;

architecture BEHAV of SN74LS379N is
    signal D, R, N : std_logic_vector(3 downto 0);
    
    alias CP is X_9;
    alias E  is X_1;
    
begin
    D <= (X_13, X_12, X_5, X_4);
    (X_15, X_10, X_7, X_2) <= R after tPXX;
    N <= not R;
    (X_14, X_11, X_6, X_3) <= N after tPXX;
    
    
    process(CP) is
    begin
        if rising_edge(CP) then
            if E = '0' then
                R <= D;
            end if;
        end if;
    end process;
end architecture BEHAV;

-----------------------------------------------------------------------
-- SN74LS386N: Quad 2-input xor gate
--             Verified 30/05/2016
-----------------------------------------------------------------------
library ieee;
    use ieee.std_logic_1164.all;

    use work.LSTTL.all;
    use work.TTLPrivate.all;

entity SN74LS386N is
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
end entity SN74LS386N;

architecture BEHAV of SN74LS386N is
    signal A : TTLInputs (1 to 4, 1 to 2);
    signal Y : TTLOutputs(1 to 4);
  
begin
    A <= ( (X_1, X_2), (X_5, X_6), (X_8, X_9), (X_12, X_13) );
    
    (X_3, X_4, X_10, X_11) <= Y;
  
    G: TTLgate
    generic map(
        mode   => Zxor,     -- Zand, Zor, Zxor, Zbuf
        invert => '0',      -- '1' will invert the output
        ohigh  => '1',      -- '1' = normal, 'Z' = open collectors
        tPLH   => tPLH,
        tPHL   => tPHL
    )
    port map(
        ins   => A,
        outs  => Y
    );
  
end architecture BEHAV;

-----------------------------------------------------------------------
-- SN74LS390N: Dual decade counter
--             Verified 31/05/2016
-----------------------------------------------------------------------
library ieee;
    use ieee.std_logic_1164.all;

    use work.LSTTL.all;
    use work.TTLPrivate.all;

entity SN74LS390N is
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
end entity SN74LS390N;

architecture BEHAV of SN74LS390N is
begin
    C1: SN74LS90AN
    generic map(
        tPLH0 => tPLH0,
        tPHL0 => tPHL0,
        tPLH1 => tPLH1 - tPLH0,     -- Reduce, as CLK(3..1) is already delayed
        tPHL1 => tPHL1 - tPHL0,
        tPLH2 => tPLH2 - tPLH0,
        tPHL2 => tPHL2 - tPHL0,
        tPLH3 => tPLH3 - tPLH0,
        tPHL3 => tPHL3 - tPHL0
    )
    port map(
        X_1  => X_4,   -- CP1\
        X_2  => X_2,   -- MR1
        X_3  => X_2,   -- MR2
                       -- 
        X_5  => open,  -- Vcc
        X_6  => '0',   -- MS1
        X_7  => '0',   -- MS2
        X_8  => X_6,   -- Q2
        X_9  => X_5,   -- Q1
        X_10 => open,  -- GND
        X_11 => X_7,   -- Q3
        X_12 => X_3,   -- Q0
                       -- 
        X_14 => X_1    -- CP0\
    );

    C2: SN74LS90AN
    generic map(
        tPLH0 => tPLH0,
        tPHL0 => tPHL0,
        tPLH1 => tPLH1 - tPLH0,     -- Reduce, as CLK(3..1) is already delayed
        tPHL1 => tPHL1 - tPHL0,
        tPLH2 => tPLH2 - tPLH0,
        tPHL2 => tPHL2 - tPHL0,
        tPLH3 => tPLH3 - tPLH0,
        tPHL3 => tPHL3 - tPHL0
    )
    port map(
        X_1  => X_12,  -- CP1\
        X_2  => X_14,  -- MR1
        X_3  => X_14,  -- MR2
                       -- 
        X_5  => open,  -- Vcc
        X_6  => '0',   -- MS1
        X_7  => '0',   -- MS2
        X_8  => X_10,  -- Q2
        X_9  => X_11,  -- Q1
        X_10 => open,  -- GND
        X_11 => X_9,   -- Q3
        X_12 => X_13,  -- Q0
                       -- 
        X_14 => X_15   -- CP0\
    );

end architecture BEHAV;

-----------------------------------------------------------------------
-- SN74LS393N: Dual 4-bit binary counter
--             Verified 31/05/2016
-----------------------------------------------------------------------
library ieee;
    use ieee.std_logic_1164.all;

    use work.LSTTL.all;
    use work.TTLPrivate.all;

entity SN74LS393N is
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
end entity SN74LS393N;

architecture BEHAV of SN74LS393N is
    signal q0a,  q0b  : std_logic;
begin
    C1: SN74LS93N
    generic map(
        tPLH0 => tPLH0,
        tPHL0 => tPHL0,
        tPLH1 => tPLH1 - tPLH0,     -- Reduce, as CLK(3..1) is already delayed
        tPHL1 => tPHL1 - tPHL0,
        tPLH2 => tPLH2 - tPLH0,
        tPHL2 => tPHL2 - tPHL0,
        tPLH3 => tPLH3 - tPLH0,
        tPHL3 => tPHL3 - tPHL0
    )
    port map(
        X_1  => q0a,   -- CP1\
        X_2  => X_2,   -- MR1
        X_3  => X_2,   -- MR2
                       -- 
        X_5  => open,  -- Vcc
                       --
                       --
        X_8  => X_5,   -- Q2
        X_9  => X_4,   -- Q1
        X_10 => open,  -- GND
        X_11 => X_6,   -- Q3
        X_12 => q0a,   -- Q0
                       -- 
        X_14 => X_1    -- CP0\
    );
    X_3 <= q0a;

    C2: SN74LS93N
    generic map(
        tPLH0 => tPLH0,
        tPHL0 => tPHL0,
        tPLH1 => tPLH1 - tPLH0,     -- Reduce, as CLK(3..1) is already delayed
        tPHL1 => tPHL1 - tPHL0,
        tPLH2 => tPLH2 - tPLH0,
        tPHL2 => tPHL2 - tPHL0,
        tPLH3 => tPLH3 - tPLH0,
        tPHL3 => tPHL3 - tPHL0
    )
    port map(
        X_1  => q0b,   -- CP1\
        X_2  => X_12,  -- MR1
        X_3  => X_12,  -- MR2
                       -- 
        X_5  => open,  -- Vcc
                       --
                       --
        X_8  => X_9,   -- Q2
        X_9  => X_10,  -- Q1
        X_10 => open,  -- GND
        X_11 => X_8,   -- Q3
        X_12 => q0b,   -- Q0
                       -- 
        X_14 => X_13   -- CP0\
    );
    X_11 <= q0b;

end architecture BEHAV;

-----------------------------------------------------------------------
-- SN74LS395N: 4-bit shift register (3-state outputs)
--             Verified 22/12/2016
-----------------------------------------------------------------------
library ieee;
    use ieee.std_logic_1164.all;

    use work.LSTTL.all;
    use work.TTLPrivate.all;

entity SN74LS395N is
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
end entity SN74LS395N;

architecture BEHAV of SN74LS395N is
    signal D, R, Z : std_logic_vector(3 downto 0);
    signal OE      : std_logic;
    
    alias CP is X_10;
    alias S  is X_7;
    alias DS is X_2;
    alias MR is X_1;
    
begin
    OE <= not X_9;
    D  <= (X_6, X_5, X_4, X_3);
    (X_12, X_13, X_14, X_15) <= Z;
    
    OB3: TTLdelay 
    generic map(
        tPLH => tPLH,
        tPHL => tPHL
    )
    port map(
        A => R(3),
        B => X_11
    );
    
    G1: for i in R'range generate
    begin
        OBN: TTL3State    
        generic map(
            tPLH => tPLH,
            tPHL => tPHL,
            tPZH => tPZH,
            tPZL => tPZL,
            tPHZ => tPHZ,
            tPLZ => tPLZ
        )
        port map(
            A    => R(i),
            E    => OE,
            Y    => Z(i)
        );
    end generate;
    
    process(MR, CP) is
    begin
        if MR = '0' then
            R <= (others => '0');
        elsif falling_edge(CP) then
            if S = '0' then
                R <= R(2 downto 0) & DS;
            else
                R <= D;
            end if;
        end if;
    end process;
end architecture BEHAV;

-----------------------------------------------------------------------
-- SN74LS490N: Dual decade counter
--             Verified 31/05/2016
-----------------------------------------------------------------------
library ieee;
    use ieee.std_logic_1164.all;

    use work.LSTTL.all;
    use work.TTLPrivate.all;

entity SN74LS490N is
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
end entity SN74LS490N;

architecture BEHAV of SN74LS490N is
    signal Z : TTL2word;
    signal set, rst, clk : std_logic_vector(2 downto 1);
begin
    set <= (X_12, X_4);
    rst <= (X_14, X_2);
    clk <= (X_15, X_1);
    (X_9, X_10, X_11, X_13) <= Z(2);
    (X_7, X_6,  X_5,  X_3 ) <= Z(1);

    G1: for i in Z'range generate        
        signal X : TTLword;
        signal Y : std_logic_vector(3 downto 0);
    begin
        process(set(i), rst(i), clk(i)) is
        begin
            if    rst(i) = '1' then
                X <= "0000";
            elsif set(i) = '1' then
                X <= "1001";
            elsif clk(i)'event and clk(i) = '0' then
                X <= TTL490(Z(i));
            end if;
        end process;
        
        D3: TTLdelay
        generic map(
            tPLH => tPLH3,
            tPHL => tPHL3
        )
        port map(
            A => X(3),
            B => Y(3)
        );

        D2: TTLdelay
        generic map(
            tPLH => tPLH2,
            tPHL => tPHL2
        )
        port map(
            A => X(2),
            B => Y(2)
        );

        D1: TTLdelay
        generic map(
            tPLH => tPLH1,
            tPHL => tPHL1
        )
        port map(
            A => X(1),
            B => Y(1)
        );

        D0: TTLdelay
        generic map(
            tPLH => tPLH0,
            tPHL => tPHL0
        )
        port map(
            A => X(0),
            B => Y(0)
        );
        Z(i) <= TTLword(Y);
    end generate;

end architecture BEHAV;

-----------------------------------------------------------------------
-- SN74LS533N: Octal transparent latch (3-state inverting outputs)
--             Verified 22/12/2016
-----------------------------------------------------------------------
library ieee;
    use ieee.std_logic_1164.all;

    use work.LSTTL.all;
    use work.TTLPrivate.all;

entity SN74LS533N is
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
end entity SN74LS533N;

architecture BEHAV of SN74LS533N is
    signal D, Q, Z : std_logic_vector(7 downto 0);
    signal LE, OE  : std_logic;
    
begin
    LE <= X_11;
    OE <= not X_1;
    D  <= (X_18, X_17, X_14, X_13, X_8, X_7, X_4, X_3);
    (X_19, X_16, X_15, X_12, X_9,  X_6, X_5, X_2) <= Z;
    
    process(all) is
    begin
        if LE = '1' then
            Q <= not D;
        end if;
    end process;
    
    G: for i in D'range generate
    begin
        TB: TTL3State   
        generic map(
            tPLH => tPLH,
            tPHL => tPHL,
            tPZH => tPZH,
            tPZL => tPZL,
            tPHZ => tPHZ,
            tPLZ => tPLZ
        )
        port map(
            A    => Q(i),
            E    => OE,
            Y    => Z(i)
        );
    end generate;
end architecture BEHAV;

-----------------------------------------------------------------------
-- SN74LS534N: Octal D-flipflop (3-state outputs)
--             Verified 22/12/2016
-----------------------------------------------------------------------
library ieee;
    use ieee.std_logic_1164.all;

    use work.LSTTL.all;
    use work.TTLPrivate.all;

entity SN74LS534N is
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
end entity SN74LS534N;

architecture BEHAV of SN74LS534N is
    signal D, Q, Z : std_logic_vector(7 downto 0);
    signal CP, OE  : std_logic;
    
begin
    CP <= X_11;
    OE <= not X_1;
    D  <= (X_18, X_17, X_14, X_13, X_8, X_7, X_4, X_3);
    (X_19, X_16, X_15, X_12, X_9,  X_6, X_5, X_2) <= Z;
    
    process(CP) is
    begin
        if rising_edge(CP) then
            Q <= not D;
        end if;
    end process;
    
    G: for i in D'range generate
    begin
        TB: TTL3State   
        generic map(
            tPLH => tPLH,
            tPHL => tPHL,
            tPZH => tPZH,
            tPZL => tPZL,
            tPHZ => tPHZ,
            tPLZ => tPLZ
        )
        port map(
            A    => Q(i),
            E    => OE,
            Y    => Z(i)
        );
    end generate;
end architecture BEHAV;

-----------------------------------------------------------------------
-- SN74LS540N: Octal buffer/line driver (inverting 3-state outputs)
--             Verified 22/12/2016
-----------------------------------------------------------------------
library ieee;
    use ieee.std_logic_1164.all;

    use work.LSTTL.all;
    use work.TTLPrivate.all;

entity SN74LS540N is
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
end entity SN74LS540N;

architecture BEHAV of SN74LS540N is
    signal I, A, Y : std_logic_vector(7 downto 0);
    signal E       : std_logic;
    
begin
    E <= not(X_1 or X_19);
    I <= (X_9, X_8, X_7, X_6, X_5, X_4, X_3, X_2);
    A <= not I;
    (X_11, X_12, X_13, X_14, X_15, X_16, X_17, X_18) <= Y;
    
    G: for j in I'range generate
    begin
        B: TTL3State     
        generic map(
            tPLH => tPLH,
            tPHL => tPHL,
            tPZH => tPZH,
            tPZL => tPZL,
            tPHZ => tPHZ,
            tPLZ => tPLZ
        )
        port map(
            A    => A(j),
            E    => E,
            Y    => Y(j)
        );
    end generate;    
end architecture BEHAV;

-----------------------------------------------------------------------
-- SN74LS541N: Octal buffer/line driver (3-state outputs)
--             Verified 22/12/2016
-----------------------------------------------------------------------
library ieee;
    use ieee.std_logic_1164.all;

    use work.LSTTL.all;
    use work.TTLPrivate.all;

entity SN74LS541N is
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
end entity SN74LS541N;

architecture BEHAV of SN74LS541N is
    signal I, A, Y : std_logic_vector(7 downto 0);
    signal E       : std_logic;
    
begin
    E <= not(X_1 or X_19);
    I <= (X_9, X_8, X_7, X_6, X_5, X_4, X_3, X_2);
    A <= I;
    (X_11, X_12, X_13, X_14, X_15, X_16, X_17, X_18) <= Y;
    
    G: for j in I'range generate
    begin
        B: TTL3State     
        generic map(
            tPLH => tPLH,
            tPHL => tPHL,
            tPZH => tPZH,
            tPZL => tPZL,
            tPHZ => tPHZ,
            tPLZ => tPLZ
        )
        port map(
            A    => A(j),
            E    => E,
            Y    => Y(j)
        );
    end generate;
end architecture BEHAV;

-----------------------------------------------------------------------
-- SN74LS563N: Octal D-type latch (3-state outputs)
--             Verified 22/12/2016
-----------------------------------------------------------------------
library ieee;
    use ieee.std_logic_1164.all;

    use work.LSTTL.all;
    use work.TTLPrivate.all;

entity SN74LS563N is
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
end entity SN74LS563N;

architecture BEHAV of SN74LS563N is
    signal D, Q, Z : std_logic_vector(7 downto 0);
    signal LE, OE  : std_logic;
    
begin
    LE <= X_11;
    OE <= not X_1;
    D  <= (X_9, X_8, X_7, X_6, X_5, X_4, X_3, X_2);
    (X_12, X_13, X_14, X_15, X_16,  X_17, X_18, X_19) <= Z;
    
    process(all) is
    begin
        if LE = '1' then
            Q <= not D;
        end if;
    end process;
    
    G: for i in D'range generate
    begin
        TB: TTL3State   
        generic map(
            tPLH => tPLH,
            tPHL => tPHL,
            tPZH => tPZH,
            tPZL => tPZL,
            tPHZ => tPHZ,
            tPLZ => tPLZ
        )
        port map(
            A    => Q(i),
            E    => OE,
            Y    => Z(i)
        );
    end generate;
end architecture BEHAV;

-----------------------------------------------------------------------
-- SN74LS564N: Octal D-flipflop (3-state outputs)
--             Verified 22/12/2016
-----------------------------------------------------------------------
library ieee;
    use ieee.std_logic_1164.all;

    use work.LSTTL.all;
    use work.TTLPrivate.all;

entity SN74LS564N is
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
end entity SN74LS564N;

architecture BEHAV of SN74LS564N is
    signal D, Q, Z : std_logic_vector(7 downto 0);
    signal CP, OE  : std_logic;
    
begin
    CP <= X_11;
    OE <= not X_1;
    D  <= (X_9, X_8, X_7, X_6, X_5, X_4, X_3, X_2);
    (X_12, X_13, X_14, X_15, X_16,  X_17, X_18, X_19) <= Z;
    
    process(CP) is
    begin
        if rising_edge(CP) then
            Q <= not D;
        end if;
    end process;
    
    G: for i in D'range generate
    begin
        TB: TTL3State   
        generic map(
            tPLH => tPLH,
            tPHL => tPHL,
            tPZH => tPZH,
            tPZL => tPZL,
            tPHZ => tPHZ,
            tPLZ => tPLZ
        )
        port map(
            A    => Q(i),
            E    => OE,
            Y    => Z(i)
        );
    end generate;
end architecture BEHAV;

-----------------------------------------------------------------------
-- SN74LS573N: Octal D-type latch (3-state outputs)
--             Verified 21/12/2016
-----------------------------------------------------------------------
library ieee;
    use ieee.std_logic_1164.all;

    use work.LSTTL.all;
    use work.TTLPrivate.all;

entity SN74LS573N is
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
end entity SN74LS573N;

architecture BEHAV of SN74LS573N is
    signal D, Q, Z : std_logic_vector(7 downto 0);
    signal LE, OE  : std_logic;
    
begin
    LE <= X_11;
    OE <= not X_1;
    D  <= (X_9, X_8, X_7, X_6, X_5, X_4, X_3, X_2);
    (X_12, X_13, X_14, X_15, X_16,  X_17, X_18, X_19) <= Z;
    
    process(all) is
    begin
        if LE = '1' then
            Q <= D;
        end if;
    end process;
    
    G: for i in D'range generate
    begin
        TB: TTL3State   
        generic map(
            tPLH => tPLH,
            tPHL => tPHL,
            tPZH => tPZH,
            tPZL => tPZL,
            tPHZ => tPHZ,
            tPLZ => tPLZ
        )
        port map(
            A    => Q(i),
            E    => OE,
            Y    => Z(i)
        );
    end generate;
end architecture BEHAV;

-----------------------------------------------------------------------
-- SN74LS574N: Octal D-flipflop (3-state outputs)
--             Verified 21/12/2016
-----------------------------------------------------------------------
library ieee;
    use ieee.std_logic_1164.all;

    use work.LSTTL.all;
    use work.TTLPrivate.all;

entity SN74LS574N is
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
end entity SN74LS574N;

architecture BEHAV of SN74LS574N is
    signal D, Q, Z : std_logic_vector(7 downto 0);
    signal CP, OE  : std_logic;
    
begin
    CP <= X_11;
    OE <= not X_1;
    D  <= (X_9, X_8, X_7, X_6, X_5, X_4, X_3, X_2);
    (X_12, X_13, X_14, X_15, X_16,  X_17, X_18, X_19) <= Z;
    
    process(CP) is
    begin
        if rising_edge(CP) then
            Q <= D;
        end if;
    end process;
    
    G: for i in D'range generate
    begin
        TB: TTL3State   
        generic map(
            tPLH => tPLH,
            tPHL => tPHL,
            tPZH => tPZH,
            tPZL => tPZL,
            tPHZ => tPHZ,
            tPLZ => tPLZ
        )
        port map(
            A    => Q(i),
            E    => OE,
            Y    => Z(i)
        );
    end generate;
end architecture BEHAV;

-----------------------------------------------------------------------
-- SN74LS670N: 4 x 4 register file (3-state outputs)
--             Verified 21/12/2016
-----------------------------------------------------------------------
library ieee;
    use ieee.std_logic_1164.all;

    use work.LSTTL.all;
    use work.TTLPrivate.all;

entity SN74LS670N is
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
    X_6  : out   std_logic;  -- O4
    X_7  : out   std_logic;  -- O3
    X_8  : inout std_logic;  -- GND
    X_9  : out   std_logic;  -- O2
    X_10 : out   std_logic;  -- O1
    X_11 : in    std_logic;  -- OE\
    X_12 : in    std_logic;  -- WE\
    X_13 : in    std_logic;  -- WA1
    X_14 : in    std_logic;  -- WA0
    X_15 : in    std_logic;  -- D1
    X_16 : inout std_logic   -- Vcc
);
end entity SN74LS670N;

architecture BEHAV of SN74LS670N is
    signal  RE, WE   : std_logic := '1';
    signal  RA, WA   : std_logic_vector(1 downto 0) := (others => '0');
    signal  D,  Q    : std_logic_vector(3 downto 0);
begin
    RE <= X_11;
    WE <= X_12;
    RA <= (X_4, X_5);
    WA <= (X_13, X_14);
    D  <= (X_3, X_2, X_1, X_15);
    (X_6, X_7, X_9, X_10) <= Q;
    
    MB: TTLramblock
    generic map(
        Omode => TriState,
        INVT  => '0',
        tPLC  => tPLC,
        tPLA  => tPLA,
        tSUD  => tSUD,
        tSUA  => tSUA
    )         
    port map( 
        RA    => RA,
        WA    => WA,
        D     => D,
        O     => Q,
        CE    => '0',
        RE    => RE,
        WE    => WE
    );    
end architecture BEHAV;

