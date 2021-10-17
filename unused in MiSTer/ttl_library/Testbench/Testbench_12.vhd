-----------------------------------------------------------------------
-- Bipolar TTL models (VHDL)                                         --
-- David R Brooks                                                    --
-- June, 2016.  Perth, Australia                                     --
-- Compliance: VHDL 2008                                             --
-- Testbench for SN74LS12N: Triple 3-input NAND gate (open collector)--
-----------------------------------------------------------------------

library ieee;
    use ieee.std_logic_1164.all;
    use ieee.std_logic_misc.all;
    use ieee.numeric_std.all;
    use work.LSTTL.all;
    use work.TTLPrivate.all;
    
entity Testbench_12 is     -- Top-level bench
generic(
    StimClk  : std_logic      := '1'; 
    CheckClk : std_logic      := '0';
    Period   : time           := 50 ns;
    Finish   : time           := 20 us;
    SevLevel : severity_level := failure
);
end entity;

architecture Test of Testbench_12 is
    signal J, B : unsigned(8 downto 0);         -- Test stimuli
    signal D, E : std_logic_vector(2 downto 0); -- Expected & actual results

    begin    
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
        J   => J,
        B   => B,
        CLK => open,
        RS  => open,
        D   => D,
        E   => E
    );
    
    -----------------------------------------------------------------------
    -- Generate expected results (with zero delays)
    -----------------------------------------------------------------------
    D(0) <= TTL_OC(not((J(0) and J(1) and J(2))));
    D(1) <= TTL_OC(not((J(3) and J(4) and J(5))));
    D(2) <= TTL_OC(not((J(6) and J(7) and J(8))));

    -----------------------------------------------------------------------
    -- Device Under Test...                        
    -----------------------------------------------------------------------
    DUT: SN74LS12N 
    port map(
    X_1  => J(0),  -- 1A
    X_2  => J(1),  -- 1B
    X_3  => J(3),  -- 2A
    X_4  => J(4),  -- 2B
    X_5  => J(5),  -- 2C
    X_6  => E(1),  -- 2Y\
    X_7  => open,  -- GND
    X_8  => E(2),  -- 3Y\
    X_9  => J(6),  -- 3C
    X_10 => J(7),  -- 3B
    X_11 => J(8),  -- 3A
    X_12 => E(0),  -- 1Y\
    X_13 => J(2),  -- 1C
    X_14 => open   -- Vcc
);
end architecture Test;
