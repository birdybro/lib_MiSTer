-----------------------------------------------------------------------
-- Bipolar TTL models (VHDL)                                         --
-- David R Brooks                                                    --
-- June, 2016.  Perth, Australia                                     --
-- Compliance: VHDL 2008                                             --
-- Testbench for SN74LS260N: Dual 5-input NOR gate                   --
-----------------------------------------------------------------------

library ieee;
    use ieee.std_logic_1164.all;
    use ieee.std_logic_misc.all;
    use ieee.numeric_std.all;
    use work.LSTTL.all;
    use work.TTLPrivate.all;
    
entity Testbench_260 is     -- Top-level bench
generic(
    StimClk  : std_logic      := '1'; 
    CheckClk : std_logic      := '0';
    Period   : time           := 50 ns;
    Finish   : time           := 20 us;
    SevLevel : severity_level := failure
);
end entity;

architecture Test of Testbench_260 is
    signal J, B : unsigned(9 downto 0);         -- Test stimuli
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
    D(0) <= not( J(0) or J(1) or J(2) or J(3) or J(4) );
    D(1) <= not( J(5) or J(6) or J(7) or J(8) or J(9) );

    -----------------------------------------------------------------------
    -- Device Under Test...                        
    -----------------------------------------------------------------------
    DUT: SN74LS260N 
    port map(
    X_1  => J(0),  -- I1A
    X_2  => J(1),  -- I2A
    X_3  => J(2),  -- I3A
    X_4  => J(5),  -- I1B
    X_5  => E(0),  -- ZA\
    X_6  => E(1),  -- ZB\
    X_7  => open,  -- GND
    X_8  => J(6),  -- I2B
    X_9  => J(7),  -- I3B
    X_10 => J(8),  -- I4B
    X_11 => J(9),  -- I5B
    X_12 => J(3),  -- I4A
    X_13 => J(4),  -- I5A
    X_14 => open   -- Vcc
);
end architecture Test;
