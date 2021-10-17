-----------------------------------------------------------------------
-- Bipolar TTL models (VHDL)                                         --
-- David R Brooks                                                    --
-- June, 2016.  Perth, Australia                                     --
-- Compliance: VHDL 2008                                             --
-- Testbench for SN74LS30N: 8-input NAND gate (Pinout A)             --
-----------------------------------------------------------------------

library ieee;
    use ieee.std_logic_1164.all;
    use ieee.std_logic_misc.all;
    use ieee.numeric_std.all;
    use work.LSTTL.all;
    use work.TTLPrivate.all;
    
entity Testbench_30 is     -- Top-level bench
generic(
    StimClk  : std_logic      := '1'; 
    CheckClk : std_logic      := '0';
    Period   : time           := 50 ns;
    Finish   : time           := 20 us;
    SevLevel : severity_level := failure
);
end entity;

architecture Test of Testbench_30 is
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
    D(0) <= nand_reduce(std_logic_vector(J(7 downto 0)));

    -----------------------------------------------------------------------
    -- Device Under Test...                        
    -----------------------------------------------------------------------
    DUT: SN74LS30N 
    port map(
    X_1  => J(0),  -- 1A
    X_2  => J(1),  -- 1B
    X_3  => J(2),  -- 1C
    X_4  => J(3),  -- 1D
    X_5  => J(4),  -- 1E
    X_6  => J(5),  -- 1F
    X_7  => open,  -- GND
    X_8  => E(0),  -- 1Y\
                   -- 
                   -- 
    X_11 => J(6),  -- 1G
    X_12 => J(7),  -- 1H
                   --
    X_14 => open   -- Vcc
);
end architecture Test;
