-----------------------------------------------------------------------
-- Bipolar TTL models (VHDL)                                         --
-- David R Brooks                                                    --
-- December, 2016.  Perth, Australia                                 --
-- Compliance: VHDL 2008                                             --
-- Testbench for SN74LS379N: 4-bit D flipflop                        --
-----------------------------------------------------------------------

library ieee;
    use ieee.std_logic_1164.all;
    use ieee.std_logic_misc.all;
    use ieee.numeric_std.all;
    use work.LSTTL.all;
    use work.TTLPrivate.all;
    
entity Testbench_379 is     -- Top-level bench
generic(
    StimClk  : std_logic      := '1'; 
    CheckClk : std_logic      := '0';
    Period   : time           := 100 ns;
    Finish   : time           :=  20 us;
    SevLevel : severity_level := failure
);
end entity;

architecture Test of Testbench_379 is
    signal J, B : unsigned(3 downto 0);         -- Test stimuli
    signal D, E : std_logic_vector(7 downto 0); -- Expected & actual results
    signal R, N : std_logic_vector(3 downto 0); -- Register
    signal CLK  : std_logic;
    
    alias EN is J(0);
    
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
            if EN = '0' then
                R <= std_logic_vector(B);
            end if;
        end if;
    end process;
    
    N <= not R;
    D <= N & R;
    
    -----------------------------------------------------------------------
    -- Device Under Test...                        
    -----------------------------------------------------------------------
    DUT: SN74LS379N 
    port map(
        X_1  => EN,  -- E\
        X_2  => E(0),  -- Q0
        X_3  => E(4),  -- Q0\
        X_4  => B(0),  -- D0
        X_5  => B(1),  -- D1
        X_6  => E(5),  -- Q1\
        X_7  => E(1),  -- Q1
        X_8  => open, -- GND
        X_9  => CLK,  -- CP
        X_10 => E(2),  -- Q2
        X_11 => E(6),  -- Q2\
        X_12 => B(2),  -- D2
        X_13 => B(3),  -- D3
        X_14 => E(7),  -- Q3\
        X_15 => E(3),  -- Q3
        X_16 => open  -- Vcc
    );

end architecture Test;
