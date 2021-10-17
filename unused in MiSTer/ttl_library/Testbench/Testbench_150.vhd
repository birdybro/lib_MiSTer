-----------------------------------------------------------------------
-- Bipolar TTL models (VHDL)                                         --
-- David R Brooks                                                    --
-- June, 2016.  Perth, Australia                                     --
-- Compliance: VHDL 2008                                             --
-- Testbench for SN74150N: 16-input multiplexer                      --
-----------------------------------------------------------------------

library ieee;
    use ieee.std_logic_1164.all;
    use ieee.std_logic_misc.all;
    use ieee.numeric_std.all;
    use work.LSTTL.all;
    use work.TTLPrivate.all;
    
entity Testbench_150 is     -- Top-level bench
generic(
    StimClk  : std_logic      := '1'; 
    CheckClk : std_logic      := '1';
    Period   : time           :=  50 ns;
    Finish   : time           := 100 ms;
    SevLevel : severity_level := failure
);
end entity;

architecture Test of Testbench_150 is
    signal J, B : unsigned(20 downto 0);         -- Test stimuli
    signal D, E : std_logic_vector(0 downto 0); -- Expected & actual results
    signal A    : unsigned(3 downto 0);
    signal chn  : natural range 15 downto 0;
    
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
    A    <= B(4 downto 1);
    chn  <= TTL_to_integer(A);
    D(0) <= B(0) or B(5+chn);

    -----------------------------------------------------------------------
    -- Device Under Test...                        
    -----------------------------------------------------------------------
    DUT: SN74150N 
    port map(
    X_1  => B(12), -- I7
    X_2  => B(11), -- I6
    X_3  => B(10), -- I5
    X_4  => B(9),  -- I4
    X_5  => B(8),  -- I3
    X_6  => B(7),  -- I2
    X_7  => B(6),  -- I1
    X_8  => B(5),  -- I0
    X_9  => B(0),  -- E\
    X_10 => E(0),  -- Z\
    X_11 => B(4),  -- S3
    X_12 => open,  -- GND
    X_13 => B(3),  -- S2
    X_14 => B(2),  -- S1
    X_15 => B(1),  -- S0
    X_16 => B(20), -- I15
    X_17 => B(19), -- I14
    X_18 => B(18), -- I13
    X_19 => B(17), -- I12
    X_20 => B(16), -- I11
    X_21 => B(15), -- I10
    X_22 => B(14), -- I9
    X_23 => B(13), -- I8
    X_24 => open   -- Vcc
);
end architecture Test;
