-----------------------------------------------------------------------
-- Bipolar TTL models (VHDL)                                         --
-- David R Brooks                                                    --
-- December, 2016.  Perth, Australia                                 --
-- Compliance: VHDL 2008                                             --
-- Testbench for SN74LS540N: Octal buffer/line driver (3-state ops)  --
-----------------------------------------------------------------------

library ieee;
    use ieee.std_logic_1164.all;
    use ieee.std_logic_misc.all;
    use ieee.numeric_std.all;
    use work.LSTTL.all;
    use work.TTLPrivate.all;
    
entity Testbench_540 is     -- Top-level bench
generic(
    StimClk  : std_logic      := '1'; 
    CheckClk : std_logic      := '1';
    Period   : time           := 50 ns;
    Finish   : time           := 20 us;
    SevLevel : severity_level := failure
);
end entity;

architecture Test of Testbench_540 is
    signal RS, OE   : std_logic;
    signal CLK      : std_logic;
    signal JC, BC   : unsigned(9 downto 0);       -- Test stimuli
    signal D,  E    : std_logic_vector(7 downto 0);   -- Expected & actual results
    signal I        : std_logic_vector(7 downto 0);
    
    alias OEA is JC(9);
    alias OEB is JC(8);
    
begin    
    I  <= std_logic_vector(BC(7 downto 0));
    OE <= not(OEA or OEB);
    
    -----------------------------------------------------------------------
    -- Standard testbench components
    -----------------------------------------------------------------------
    TB: TTLBench
    generic map(
        StimClk  => StimClk, 
        CheckClk => CheckClk,
        Period   => Period,
        Finish   => Finish,
        SevLevel => SevLevel
    )
    port map(
        J    => JC, 
        B    => BC,
        CLK  => CLK,
        RS   => RS,
        D    => D,
        E    => E
    );
    
    -----------------------------------------------------------------------
    -- Generate expected results (with zero delays)
    -----------------------------------------------------------------------
    D <= not I when OE = '1' else (others => 'Z');
    
    -----------------------------------------------------------------------
    -- Device Under Test...                        
    -----------------------------------------------------------------------
    DUT: SN74LS540N 
    port map(
        X_1  => OEA,   -- E1\
        X_2  => I(0),  -- A0
        X_3  => I(1),  -- A1
        X_4  => I(2),  -- A2
        X_5  => I(3),  -- A3
        X_6  => I(4),  -- A4
        X_7  => I(5),  -- A5
        X_8  => I(6),  -- A6
        X_9  => I(7),  -- A7
        X_10 => open,  -- GND
        X_11 => E(7),  -- Y7\
        X_12 => E(6),  -- Y6\
        X_13 => E(5),  -- Y5\
        X_14 => E(4),  -- Y4\
        X_15 => E(3),  -- Y3\
        X_16 => E(2),  -- Y2\
        X_17 => E(1),  -- Y1\
        X_18 => E(0),  -- Y0\
        X_19 => OEB,   -- E2\
        X_20 => open   -- Vcc            
    );
end architecture Test;
