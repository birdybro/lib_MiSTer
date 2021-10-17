-----------------------------------------------------------------------
-- Bipolar TTL models (VHDL)                                         --
-- David R Brooks                                                    --
-- June, 2016.  Perth, Australia                                     --
-- Compliance: VHDL 2008                                             --
-- Testbench for SN74S134N: 12-input NAND gate (3-state output)      --
-----------------------------------------------------------------------

library ieee;
    use ieee.std_logic_1164.all;
    use ieee.std_logic_misc.all;
    use ieee.numeric_std.all;
    use work.LSTTL.all;
    use work.TTLPrivate.all;
    
entity Testbench_134 is     -- Top-level bench
generic(
    StimClk  : std_logic      := '1'; 
    CheckClk : std_logic      := '0';
    Period   : time           := 100 ns;
    Finish   : time           :=  20 us;
    SevLevel : severity_level := failure
);
end entity;

architecture Test of Testbench_134 is
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
    D(0) <= nand_reduce(std_logic_vector(J(12 downto 1))) when J(0) = '0'
                                                          else 'Z';

    -----------------------------------------------------------------------
    -- Device Under Test...                        
    -----------------------------------------------------------------------
    DUT: SN74S134N 
    port map(
    X_1  => J(1),  -- 1A
    X_2  => J(2),  -- 1B
    X_3  => J(3),  -- 1C
    X_4  => J(4),  -- 1D
    X_5  => J(5),  -- 1E
    X_6  => J(6),  -- 1F
    X_7  => J(7),  -- 1G
    X_8  => open,  -- GND
    X_9  => E(0),  -- 1Y\
    X_10 => J(8),  -- 1H
    X_11 => J(9),  -- 1J
    X_12 => J(10), -- 1K
    X_13 => J(11), -- 1L
    X_14 => J(12), -- 1M
    X_15 => J(0),  -- EB
    X_16 => open   -- Vcc
);
end architecture Test;
