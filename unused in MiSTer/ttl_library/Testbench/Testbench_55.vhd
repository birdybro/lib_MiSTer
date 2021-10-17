-----------------------------------------------------------------------
-- Bipolar TTL models (VHDL)                                         --
-- David R Brooks                                                    --
-- June, 2016.  Perth, Australia                                     --
-- Compliance: VHDL 2008                                             --
-- Testbench for SN74LS55N: 2-wide 4-input AOI gate (Pinout B)       --
-----------------------------------------------------------------------

library ieee;
    use ieee.std_logic_1164.all;
    use ieee.std_logic_misc.all;
    use ieee.numeric_std.all;
    use work.LSTTL.all;
    use work.TTLPrivate.all;
    
entity Testbench_55 is     -- Top-level bench
generic(
    StimClk  : std_logic      := '1'; 
    CheckClk : std_logic      := '0';
    Period   : time           := 50 ns;
    Finish   : time           := 20 us;
    SevLevel : severity_level := failure
);
end entity;

architecture Test of Testbench_55 is
    signal J, B : unsigned(7 downto 0);         -- Test stimuli
    signal D, E : std_logic_vector(0 downto 0); -- Expected & actual results

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
    D(0) <= not( (J(0) and J(1) and J(2) and J(3)) or 
                 (J(4) and J(5) and J(6) and J(7)) );

    -----------------------------------------------------------------------
    -- Device Under Test...                        
    -----------------------------------------------------------------------
    DUT: SN74LS55N 
    port map(
    X_1  => J(0),  -- 1A1
    X_2  => J(1),  -- 1A2
    X_3  => J(2),  -- 1A3
    X_4  => J(3),  -- 1A4
                   -- 
                   -- 
    X_7  => open,  -- GND
    X_8  => E(0),  -- 1Y\
                   -- 
    X_10 => J(4),  -- 1B4
    X_11 => J(5),  -- 1B3
    X_12 => J(6),  -- 1B2
    X_13 => J(7),  -- 1B1
    X_14 => open   -- Vcc
);
end architecture Test;
