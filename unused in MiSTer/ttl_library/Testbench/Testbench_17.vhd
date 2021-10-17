-----------------------------------------------------------------------
-- Bipolar TTL models (VHDL)                                         --
-- David R Brooks                                                    --
-- June, 2016.  Perth, Australia                                     --
-- Compliance: VHDL 2008                                             --
-- Testbench for SN7417N: Hex buffer/driver (HV open collector)      --
-----------------------------------------------------------------------

library ieee;
    use ieee.std_logic_1164.all;
    use ieee.std_logic_misc.all;
    use ieee.numeric_std.all;
    use work.LSTTL.all;
    use work.TTLPrivate.all;
    
entity Testbench_17 is     -- Top-level bench
generic(
    StimClk  : std_logic      := '1'; 
    CheckClk : std_logic      := '0';
    Period   : time           := 50 ns;
    Finish   : time           := 20 us;
    SevLevel : severity_level := failure
);
end entity;

architecture Test of Testbench_17 is
    signal J, B : unsigned(5 downto 0);         -- Test stimuli
    signal D, E : std_logic_vector(5 downto 0); -- Expected & actual results

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
    D(0) <= TTL_OC( J(0) );
    D(1) <= TTL_OC( J(1) );
    D(2) <= TTL_OC( J(2) );
    D(3) <= TTL_OC( J(3) );
    D(4) <= TTL_OC( J(4) );
    D(5) <= TTL_OC( J(5) );
    
    -----------------------------------------------------------------------
    -- Device Under Test...                        
    -----------------------------------------------------------------------
    DUT: SN7417N 
    port map(
    X_1  => J(0),  -- 1A
    X_2  => E(0),  -- 1Y\
    X_3  => J(1),  -- 2A
    X_4  => E(1),  -- 2Y\
    X_5  => J(2),  -- 3A
    X_6  => E(2),  -- 3Y\
    X_7  => open,  -- GND
    X_8  => E(3),  -- 4Y\
    X_9  => J(3),  -- 4A
    X_10 => E(4),  -- 5Y\
    X_11 => J(4),  -- 5A
    X_12 => E(5),  -- 6Y\
    X_13 => J(5),  -- 6A
    X_14 => open   -- Vcc
);
end architecture Test;
