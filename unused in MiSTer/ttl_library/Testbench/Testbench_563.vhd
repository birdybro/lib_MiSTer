-----------------------------------------------------------------------
-- Bipolar TTL models (VHDL)                                         --
-- David R Brooks                                                    --
-- December, 2016.  Perth, Australia                                 --
-- Compliance: VHDL 2008                                             --
-- Testbench for SN74LS563N: 8-bit transparent latch                 --
-----------------------------------------------------------------------

library ieee;
    use ieee.std_logic_1164.all;
    use ieee.std_logic_misc.all;
    use ieee.numeric_std.all;
    use work.LSTTL.all;
    use work.TTLPrivate.all;
    
entity Testbench_563 is     -- Top-level bench
generic(
    StimClk  : std_logic      := '1'; 
    CheckClk : std_logic      := '0';
    Period   : time           := 100 ns;
    Finish   : time           :=  20 us;
    SevLevel : severity_level := failure
);
end entity;

architecture Test of Testbench_563 is
    signal J, B : unsigned(7 downto 0);         -- Test stimuli
    signal D, E : std_logic_vector(7 downto 0); -- Expected & actual results
    signal R    : std_logic_vector(7 downto 0); -- Latch
    
    alias OE is J(0);
    alias LE is J(1);
    
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
    process(all) is
    begin
        if LE = '1' then 
            R <= std_logic_vector(B);
        end if;
    end process;
    
    D <= not R when OE = '0' else (others => 'Z');
    
    -----------------------------------------------------------------------
    -- Device Under Test...                        
    -----------------------------------------------------------------------
    DUT: SN74LS563N 
    port map(
        X_1  => OE,    -- OE\
        X_2  => B(0),  -- D0
        X_3  => B(1),  -- D1
        X_4  => B(2),  -- D2
        X_5  => B(3),  -- D3
        X_6  => B(4),  -- D4
        X_7  => B(5),  -- D5
        X_8  => B(6),  -- D6
        X_9  => B(7),  -- D7
        X_10 => open,  -- GND
        X_11 => LE,    -- LE
        X_12 => E(7),  -- O7\
        X_13 => E(6),  -- O6\
        X_14 => E(5),  -- O5\
        X_15 => E(4),  -- O4\
        X_16 => E(3),  -- O3\
        X_17 => E(2),  -- O2\
        X_18 => E(1),  -- O1\
        X_19 => E(0),  -- O0\
        X_20 => open   -- Vcc
    );
end architecture Test;
