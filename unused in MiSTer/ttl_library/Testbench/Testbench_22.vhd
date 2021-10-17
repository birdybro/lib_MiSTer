-----------------------------------------------------------------------
-- Bipolar TTL models (VHDL)                                         --
-- David R Brooks                                                    --
-- June, 2016.  Perth, Australia                                     --
-- Compliance: VHDL 2008                                             --
-- Testbench for SN74LS22N: Dual 4-input NAND gate (o/c) (Pinout A)  --
-----------------------------------------------------------------------

library ieee;
    use ieee.std_logic_1164.all;
    use ieee.std_logic_misc.all;
    use ieee.numeric_std.all;
    use work.LSTTL.all;
    use work.TTLPrivate.all;
    
entity Testbench_22 is     -- Top-level bench
generic(
    StimClk  : std_logic      := '1'; 
    CheckClk : std_logic      := '0';
    Period   : time           := 50 ns;
    Finish   : time           := 20 us;
    SevLevel : severity_level := failure
);
end entity;

architecture Test of Testbench_22 is
    signal J, B : unsigned(7 downto 0);         -- Test stimuli
    signal D, E : std_logic_vector(1 downto 0); -- Expected & actual results

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
    D(0) <= TTL_OC( not( J(0) and J(1) and J(2) and J(3) ) );
    D(1) <= TTL_OC( not( J(4) and J(5) and J(6) and J(7) ) );

    -----------------------------------------------------------------------
    -- Device Under Test...                        
    -----------------------------------------------------------------------
    DUT: SN74LS22N 
    port map(
    X_1  => J(0),  -- 1A
    X_2  => J(1),  -- 1B
                   -- 
    X_4  => J(2),  -- 1C
    X_5  => J(3),  -- 1D
    X_6  => E(0),  -- 1Y\
    X_7  => open,  -- GND
    X_8  => E(1),  -- 2Y\
    X_9  => J(4),  -- 2D
    X_10 => J(5),  -- 2C
                   -- 
    X_12 => J(6),  -- 2B
    X_13 => J(7),  -- 2A
    X_14 => open   -- Vcc
);
end architecture Test;
