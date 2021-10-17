-----------------------------------------------------------------------
-- Bipolar TTL models (VHDL)                                         --
-- David R Brooks                                                    --
-- June, 2016.  Perth, Australia                                     --
-- Compliance: VHDL 2008                                             --
-- Testbench for SN74LS54N: 4-wide 2-input AOI gate (Pinout C)       --
-----------------------------------------------------------------------

library ieee;
    use ieee.std_logic_1164.all;
    use ieee.std_logic_misc.all;
    use ieee.numeric_std.all;
    use work.LSTTL.all;
    use work.TTLPrivate.all;
    
entity Testbench_54 is     -- Top-level bench
generic(
    StimClk  : std_logic      := '1'; 
    CheckClk : std_logic      := '0';
    Period   : time           := 50 ns;
    Finish   : time           := 20 us;
    SevLevel : severity_level := failure
);
end entity;

architecture Test of Testbench_54 is
    signal J, B : unsigned(9 downto 0);         -- Test stimuli
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
    D(0) <= not( (J(0) and J(1)) or (J(2) and J(3) and J(4)) or 
                 (J(8) and J(9)) or (J(5) and J(6) and J(7)) );

    -----------------------------------------------------------------------
    -- Device Under Test...                        
    -----------------------------------------------------------------------
    DUT: SN74LS54N 
    port map(
    X_1  => J(0),  -- 1A1
    X_2  => J(1),  -- 1A2
    X_3  => J(2),  -- 1B1
    X_4  => J(3),  -- 1B2
    X_5  => J(4),  -- 1B3
    X_6  => E(0),  -- 1Y\
    X_7  => open,  -- GND
                   -- 
    X_9  => J(5),  -- 1D3
    X_10 => J(6),  -- 1D2
    X_11 => J(7),  -- 1D1
    X_12 => J(8),  -- 1C2
    X_13 => J(9),  -- 1C1
    X_14 => open   -- Vcc
);
end architecture Test;
