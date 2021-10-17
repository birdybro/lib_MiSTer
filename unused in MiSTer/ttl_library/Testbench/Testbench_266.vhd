-----------------------------------------------------------------------
-- Bipolar TTL models (VHDL)                                         --
-- David R Brooks                                                    --
-- June, 2016.  Perth, Australia                                     --
-- Compliance: VHDL 2008                                             --
-- Testbench for SN74LS266N: Quad 2-input XNOR gate (open collector) --
-----------------------------------------------------------------------

library ieee;
    use ieee.std_logic_1164.all;
    use ieee.std_logic_misc.all;
    use ieee.numeric_std.all;
    use work.LSTTL.all;
    use work.TTLPrivate.all;
    
entity Testbench_266 is     -- Top-level bench
generic(
    StimClk  : std_logic      := '1'; 
    CheckClk : std_logic      := '0';
    Period   : time           := 100 ns;
    Finish   : time           :=  20 us;
    SevLevel : severity_level := failure
);
end entity;

architecture Test of Testbench_266 is
    signal J, B : unsigned(7 downto 0);         -- Test stimuli
    signal D, E : std_logic_vector(3 downto 0); -- Expected & actual results

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
        J    => J, 
        B    => B,
        CLK  => open,
        RS   => open,
        D    => D,
        E    => E
    );
    
    -----------------------------------------------------------------------
    -- Generate expected results (with zero delays)
    -----------------------------------------------------------------------
    D(0) <= TTL_OC( not ( J(0) xor J(1) ) );
    D(1) <= TTL_OC( not ( J(2) xor J(3) ) );
    D(2) <= TTL_OC( not ( J(4) xor J(5) ) );
    D(3) <= TTL_OC( not ( J(6) xor J(7) ) );

    -----------------------------------------------------------------------
    -- Device Under Test...                        
    -----------------------------------------------------------------------
    DUT: SN74LS266N 
    port map(
    X_1  => J(0),  -- 1A
    X_2  => J(1),  -- 1B
    X_3  => E(0),  -- 1Y\
    X_4  => E(1),  -- 2Y\
    X_5  => J(2),  -- 2A
    X_6  => J(3),  -- 2B
    X_7  => open,  -- GND
    X_8  => J(4),  -- 3B
    X_9  => J(5),  -- 3A
    X_10 => E(2),  -- 3Y\
    X_11 => E(3),  -- 4Y\
    X_12 => J(6),  -- 4B
    X_13 => J(7),  -- 4A
    X_14 => open   -- Vcc 
);
end architecture Test;
