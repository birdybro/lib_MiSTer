-----------------------------------------------------------------------
-- Bipolar TTL models (VHDL)                                         --
-- David R Brooks                                                    --
-- June, 2016.  Perth, Australia                                     --
-- Compliance: VHDL 2008                                             --
-- Testbench for SN74LS155N: Dual 1-of-4 decoder/demultiplexer       --
-----------------------------------------------------------------------

library ieee;
    use ieee.std_logic_1164.all;
    use ieee.std_logic_misc.all;
    use ieee.numeric_std.all;
    use work.LSTTL.all;
    use work.TTLPrivate.all;
    
entity Testbench_155 is     -- Top-level bench
generic(
    StimClk  : std_logic      := '1'; 
    CheckClk : std_logic      := '1';
    Period   : time           :=  50 ns;
    Finish   : time           :=  20 us;
    SevLevel : severity_level := failure
);
end entity;

architecture Test of Testbench_155 is
    signal J, B : unsigned(5 downto 0);         -- Test stimuli
    signal D, E : std_logic_vector(7 downto 0); -- Expected & actual results
    
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
        variable N      : natural range 3 downto 0;
        variable EA, EB : std_logic;
    begin
        N  := TTL_to_integer(B(5 downto 4));
        EA := B(0) and not B(1);
        EB := not(B(2) or B(3));
    
        D <= (others => '1');
        D(N+4) <= not EB;
        D(N)   <= not EA;
    end process;

    -----------------------------------------------------------------------
    -- Device Under Test...                        
    -----------------------------------------------------------------------
    DUT: SN74LS155N 
    port map(
    X_1  => B(0),  -- EA
    X_2  => B(1),  -- EA\
    X_3  => B(5),  -- A1
    X_4  => E(3),  -- O3A\
    X_5  => E(2),  -- O2A\
    X_6  => E(1),  -- O1A\
    X_7  => E(0),  -- O0A\
    X_8  => open,  -- GND
    X_9  => E(4),  -- O0B\
    X_10 => E(5),  -- O1B\
    X_11 => E(6),  -- O2B\
    X_12 => E(7),  -- O3B\
    X_13 => B(4),  -- A0
    X_14 => B(3),  -- EB2\
    X_15 => B(2),  -- EB1\
    X_16 => open   -- Vcc
);
end architecture Test;
