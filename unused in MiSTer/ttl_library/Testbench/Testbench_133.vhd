-----------------------------------------------------------------------
-- Bipolar TTL models (VHDL)                                         --
-- David R Brooks                                                    --
-- June, 2016.  Perth, Australia                                     --
-- Compliance: VHDL 2008                                             --
-- Testbench for SN74LS133N: 13-input NAND gate                      --
-----------------------------------------------------------------------

library ieee;
    use ieee.std_logic_1164.all;
    use ieee.std_logic_misc.all;
    use ieee.numeric_std.all;
    use work.LSTTL.all;
    use work.TTLPrivate.all;
    
entity Testbench_133 is     -- Top-level bench
generic(
    StimClk  : std_logic      := '1'; 
    CheckClk : std_logic      := '0';
    Period   : time           := 100 ns;
    Finish   : time           :=  20 us;
    SevLevel : severity_level := failure
);
end entity;

architecture Test of Testbench_133 is
    signal J, B : unsigned(12 downto 0);        -- Test stimuli
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
    D(0) <= nand_reduce(std_logic_vector(J));

    -----------------------------------------------------------------------
    -- Device Under Test...                        
    -----------------------------------------------------------------------
    DUT: SN74LS133N 
    port map(
    X_1  => J(0),  -- 1A
    X_2  => J(1),  -- 1B
    X_3  => J(2),  -- 1C
    X_4  => J(3),  -- 1D
    X_5  => J(4),  -- 1E
    X_6  => J(5),  -- 1F
    X_7  => J(6),  -- 1G
    X_8  => open,  -- GND
    X_9  => E(0),  -- 1Y\
    X_10 => J(7),  -- 1H
    X_11 => J(8),  -- 1J
    X_12 => J(9),  -- 1K
    X_13 => J(10), -- 1L
    X_14 => J(11), -- 1M
    X_15 => J(12), -- 1N
    X_16 => open   -- Vcc
);
end architecture Test;
