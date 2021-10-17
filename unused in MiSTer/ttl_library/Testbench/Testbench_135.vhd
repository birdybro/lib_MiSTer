-----------------------------------------------------------------------
-- Bipolar TTL models (VHDL)                                         --
-- David R Brooks                                                    --
-- June, 2016.  Perth, Australia                                     --
-- Compliance: VHDL 2008                                             --
-- Testbench for SN74S135N: Quad XOR/NOR gate                        --
-----------------------------------------------------------------------

library ieee;
    use ieee.std_logic_1164.all;
    use ieee.std_logic_misc.all;
    use ieee.numeric_std.all;
    use work.LSTTL.all;
    use work.TTLPrivate.all;
    
entity Testbench_135 is     -- Top-level bench
generic(
    StimClk  : std_logic      := '1'; 
    CheckClk : std_logic      := '0';
    Period   : time           := 100 ns;
    Finish   : time           :=  20 us;
    SevLevel : severity_level := failure
);
end entity;

architecture Test of Testbench_135 is
    signal J, B : unsigned(9 downto 0);         -- Test stimuli
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
    D(0) <= J(0) xor J(1) xor J(8);
    D(1) <= J(2) xor J(3) xor J(8);
    D(2) <= J(4) xor J(5) xor J(9);
    D(3) <= J(6) xor J(7) xor J(9);

    -----------------------------------------------------------------------
    -- Device Under Test...                        
    -----------------------------------------------------------------------
    DUT: SN74S135N 
    port map(
    X_1  => J(0),  -- A1
    X_2  => J(1),  -- B1
    X_3  => E(0),  -- Y1
    X_4  => J(8),  -- C12
    X_5  => J(2),  -- A2
    X_6  => J(3),  -- B2
    X_7  => E(1),  -- Y2
    X_8  => open,  -- GND
    X_9  => E(2),  -- Y3
    X_10 => J(4),  -- B3
    X_11 => J(5),  -- A3
    X_12 => J(9),  -- C34
    X_13 => E(3),  -- Y4
    X_14 => J(6),  -- B4
    X_15 => J(7),  -- A4
    X_16 => open   -- Vcc
);
end architecture Test;
