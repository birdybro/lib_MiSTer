-----------------------------------------------------------------------
-- Bipolar TTL models (VHDL)                                         --
-- David R Brooks                                                    --
-- June, 2016.  Perth, Australia                                     --
-- Compliance: VHDL 2008                                             --
-- Testbench for SN74154N: 1-of-16 decoder/demultiplexer             --
-----------------------------------------------------------------------

library ieee;
    use ieee.std_logic_1164.all;
    use ieee.std_logic_misc.all;
    use ieee.numeric_std.all;
    use work.LSTTL.all;
    use work.TTLPrivate.all;
    
entity Testbench_154 is     -- Top-level bench
generic(
    StimClk  : std_logic      := '1'; 
    CheckClk : std_logic      := '0';
    Period   : time           := 100 ns;
    Finish   : time           :=  20 us;
    SevLevel : severity_level := failure
);
end entity;

architecture Test of Testbench_154 is
    signal J, B : unsigned(5 downto 0);         -- Test stimuli
    signal D, E : std_logic_vector(15 downto 0); -- Expected & actual results
    
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
    process(B) is
        variable chn : natural range 15 downto 0;
        variable EN  : std_logic;
    begin
        chn := TTL_to_integer(B(5 downto 2));
        EN  := B(1) or B(0);
        E   <= (others => '1');
        E(chn) <= EN;
    end process;

    -----------------------------------------------------------------------
    -- Device Under Test...                        
    -----------------------------------------------------------------------
    DUT: SN74154N 
    port map(
    X_1  => D(0),  -- O0\
    X_2  => D(1),  -- O1\
    X_3  => D(2),  -- O2\
    X_4  => D(3),  -- O3\
    X_5  => D(4),  -- O4\
    X_6  => D(5),  -- O5\
    X_7  => D(6),  -- O6\
    X_8  => D(7),  -- O7\
    X_9  => D(8),  -- O8\
    X_10 => D(9),  -- O9\
    X_11 => D(10), -- O10\
    X_12 => open,  -- GND
    X_13 => D(11), -- O11\
    X_14 => D(12), -- O12\
    X_15 => D(13), -- O13\
    X_16 => D(14), -- O14\
    X_17 => D(15), -- O15\
    X_18 => B(0),  -- E0\
    X_19 => B(1),  -- E1\
    X_20 => B(5),  -- A3
    X_21 => B(4),  -- A2
    X_22 => B(3),  -- A1
    X_23 => B(2),  -- A0
    X_24 => open   -- Vcc
);
end architecture Test;
