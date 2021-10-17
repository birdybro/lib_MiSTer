-----------------------------------------------------------------------
-- Bipolar TTL models (VHDL)                                         --
-- David R Brooks                                                    --
-- June, 2016.  Perth, Australia                                     --
-- Compliance: VHDL 2008                                             --
-- Testbench for SN74LS137N: 1-of-8 decoder/demux. (input latches)   --
-----------------------------------------------------------------------

library ieee;
    use ieee.std_logic_1164.all;
    use ieee.std_logic_misc.all;
    use ieee.numeric_std.all;
    use work.LSTTL.all;
    use work.TTLPrivate.all;
    
entity Testbench_137 is     -- Top-level bench
generic(
    StimClk  : std_logic      := '1'; 
    CheckClk : std_logic      := '0';
    Period   : time           := 100 ns;
    Finish   : time           :=  20 us;
    SevLevel : severity_level := failure
);
end entity;

architecture Test of Testbench_137 is
    signal J, B, Z : unsigned(5 downto 0);         -- Test stimuli
    signal D, E    : std_logic_vector(7 downto 0); -- Expected & actual results

    alias A  is Z(2 downto 0);
    alias LE is Z(3);
    alias E1 is Z(4);
    alias E2 is Z(5);
    
    begin
    Z <= not B;

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
    process(Z) is
        variable chn : natural range 7 downto 0;
    begin
        E <= (others => '1');
        
        if LE = '0' then
            chn := TTL_to_integer(A);
        end if;
        if (E2 and not E1) = '1' then
            E(chn) <= '0';
        end if; 
    end process;

    -----------------------------------------------------------------------
    -- Device Under Test...                        
    -----------------------------------------------------------------------
    DUT: SN74LS137N 
    port map(
    X_1  => A(0),  -- A0
    X_2  => A(1),  -- A1
    X_3  => A(2),  -- A2
    X_4  => LE,    -- LE\
    X_5  => E1,    -- E1\
    X_6  => E2,    -- E2
    X_7  => D(7),  -- O7\
    X_8  => open,  -- GND
    X_9  => D(6),  -- O6\
    X_10 => D(5),  -- O5\
    X_11 => D(4),  -- O4\
    X_12 => D(3),  -- O3\
    X_13 => D(2),  -- O2\
    X_14 => D(1),  -- O1\
    X_15 => D(0),  -- O0\
    X_16 => open   -- Vcc
);
end architecture Test;
