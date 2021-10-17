-----------------------------------------------------------------------
-- Bipolar TTL models (VHDL)                                         --
-- David R Brooks                                                    --
-- December, 2016.  Perth, Australia                                 --
-- Compliance: VHDL 2008                                             --
-- Testbench for SN74LS374N: 8-bit D flipflop                        --
-----------------------------------------------------------------------

library ieee;
    use ieee.std_logic_1164.all;
    use ieee.std_logic_misc.all;
    use ieee.numeric_std.all;
    use work.LSTTL.all;
    use work.TTLPrivate.all;
    
entity Testbench_374 is     -- Top-level bench
generic(
    StimClk  : std_logic      := '1'; 
    CheckClk : std_logic      := '0';
    Period   : time           := 100 ns;
    Finish   : time           :=  20 us;
    SevLevel : severity_level := failure
);
end entity;

architecture Test of Testbench_374 is
    signal J, B : unsigned(7 downto 0);         -- Test stimuli
    signal D, E : std_logic_vector(7 downto 0); -- Expected & actual results
    signal R    : std_logic_vector(7 downto 0); -- Latch
    signal CLK  : std_logic;
    
    alias OE is J(0);
    
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
        CLK  => CLK,
        RS   => open,
        D    => D,
        E    => E
    );
    
    -----------------------------------------------------------------------
    -- Generate expected results (with zero delays)
    -----------------------------------------------------------------------
    process(CLK) is
    begin
        if rising_edge(CLK) then 
            R <= std_logic_vector(B);
        end if;
    end process;
    
    D <= R when OE = '0' else (others => 'Z');
    
    -----------------------------------------------------------------------
    -- Device Under Test...                        
    -----------------------------------------------------------------------
    DUT: SN74LS374N 
    port map(
        X_1  => OE,    -- OE\
        X_2  => E(0),  -- Q0
        X_3  => B(0),  -- D0
        X_4  => B(1),  -- D1
        X_5  => E(1),  -- Q1
        X_6  => E(2),  -- Q2
        X_7  => B(2),  -- D2
        X_8  => B(3),  -- D3
        X_9  => E(3),  -- Q3
        X_10 => open,  -- GND
        X_11 => CLK,   -- CP
        X_12 => E(4),  -- Q4
        X_13 => B(4),  -- D4
        X_14 => B(5),  -- D5
        X_15 => E(5),  -- Q5
        X_16 => E(6),  -- Q6
        X_17 => B(6),  -- D6
        X_18 => B(7),  -- D7
        X_19 => E(7),  -- Q7
        X_20 => open   -- Vcc
);
end architecture Test;
