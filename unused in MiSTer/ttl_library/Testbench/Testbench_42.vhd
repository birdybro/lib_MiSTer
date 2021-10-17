-----------------------------------------------------------------------
-- Bipolar TTL models (VHDL)                                         --
-- David R Brooks                                                    --
-- June, 2016.  Perth, Australia                                     --
-- Compliance: VHDL 2008                                             --
-- Testbench for SN74LS42N: 1-of-10 decoder                          --
-----------------------------------------------------------------------

library ieee;
    use ieee.std_logic_1164.all;
    use ieee.std_logic_misc.all;
    use ieee.numeric_std.all;
    use work.LSTTL.all;
    use work.TTLPrivate.all;
    
entity Testbench_42 is     -- Top-level bench
generic(
    StimClk  : std_logic      := '1'; 
    CheckClk : std_logic      := '0';
    Period   : time           := 100 ns;
    Finish   : time           :=  20 us;
    SevLevel : severity_level := failure
);
end entity;

architecture Test of Testbench_42 is
    signal J, B : unsigned(3 downto 0);         -- Test stimuli
    signal D, E : std_logic_vector(9 downto 0); -- Expected & actual results

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
    process(J) is
        variable N : natural;
    begin
        D <= (others => '1');       -- Default
        N := TTL_to_integer(J(3 downto 0));
        if N < 10 then
            D(N) <= '0';
        end if;
    end process;        

    -----------------------------------------------------------------------
    -- Device Under Test...                        
    -----------------------------------------------------------------------
    DUT: SN74LS42N 
    port map(
    X_1  => E(0),  -- Q0\
    X_2  => E(1),  -- Q1\
    X_3  => E(2),  -- Q2\
    X_4  => E(3),  -- Q3\
    X_5  => E(4),  -- Q4\
    X_6  => E(5),  -- Q5\
    X_7  => E(6),  -- Q6\
    X_8  => open,  -- GND
    X_9  => E(7),  -- Q7\
    X_10 => E(8),  -- Q8\
    X_11 => E(9),  -- Q9\
    X_12 => J(3),  -- A3
    X_13 => J(2),  -- A2
    X_14 => J(1),  -- A1
    X_15 => J(0),  -- A0
    X_16 => open   -- Vcc
);
end architecture Test;
