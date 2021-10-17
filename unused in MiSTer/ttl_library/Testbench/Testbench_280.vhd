-----------------------------------------------------------------------
-- Bipolar TTL models (VHDL)                                         --
-- David R Brooks                                                    --
-- December, 2016.  Perth, Australia                                 --
-- Compliance: VHDL 2008                                             --
-- Testbench for SN74LS280N: 9-bit parity generator/checker          --
-----------------------------------------------------------------------

library ieee;
    use ieee.std_logic_1164.all;
    use ieee.std_logic_misc.all;
    use ieee.numeric_std.all;
    use work.LSTTL.all;
    use work.TTLPrivate.all;
    
entity Testbench_280 is     -- Top-level bench
generic(
    StimClk  : std_logic      := '1'; 
    CheckClk : std_logic      := '0';
    Period   : time           := 50 ns;
    Finish   : time           := 20 us;
    SevLevel : severity_level := failure
);
end entity;

architecture Test of Testbench_280 is
    signal J, B : unsigned(8 downto 0);         -- Test stimuli
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
    D(0) <= xnor_reduce(std_logic_vector(J));
    D(1) <= xor_reduce(std_logic_vector(J));

    -----------------------------------------------------------------------
    -- Device Under Test...                        
    -----------------------------------------------------------------------
    DUT: SN74LS280N 
    port map(
        X_1  => J(6),  -- I6
        X_2  => J(7),  -- I7
                       -- 
        X_4  => J(8),  -- I8
        X_5  => E(0),  -- SE
        X_6  => E(1),  -- SO
        X_7  => open,  -- GND
        X_8  => J(0),  -- I0
        X_9  => J(1),  -- I1
        X_10 => J(2),  -- I2
        X_11 => J(3),  -- I3
        X_12 => J(4),  -- I4
        X_13 => J(5),  -- I5
        X_14 => open   -- Vcc
    );
end architecture Test;
