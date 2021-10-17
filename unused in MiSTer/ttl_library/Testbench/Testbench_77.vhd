-----------------------------------------------------------------------
-- Bipolar TTL models (VHDL)                                         --
-- David R Brooks                                                    --
-- June, 2016.  Perth, Australia                                     --
-- Compliance: VHDL 2008                                             --
-- Testbench for SN74LS77N: Quad D-type latch                        --
-----------------------------------------------------------------------

library ieee;
    use ieee.std_logic_1164.all;
    use ieee.std_logic_misc.all;
    use ieee.numeric_std.all;
    use work.LSTTL.all;
    use work.TTLPrivate.all;
    
entity Testbench_77 is     -- Top-level bench
generic(
    StimClk  : std_logic      := '1'; 
    CheckClk : std_logic      := '0';
    Period   : time           := 100 ns;
    Finish   : time           :=  20 us;
    SevLevel : severity_level := failure
);
end entity;

architecture Test of Testbench_77 is
    signal J, B : unsigned(5 downto 0);         -- Test stimuli
    signal D, E : std_logic_vector(3 downto 0); -- Expected & actual results
    signal S    : std_logic_vector(3 downto 0);
    
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
    S <= (J(5), J(5), J(4), J(4));
    
    G1: for i in 3 downto 0 generate
    begin
        process(S, J) is
        begin
            if S(i) = '1' then
                D(i)   <= J(i);
            end if;
        end process;
    end generate;
    
    -----------------------------------------------------------------------
    -- Device Under Test...                        
    -----------------------------------------------------------------------
    DUT: SN74LS77N 
    port map(
    X_1  => J(0),  -- D1
    X_2  => J(1),  -- D2
    X_3  => J(5),  -- E34
    X_4  => open,  -- Vcc
    X_5  => J(2),  -- D3
    X_6  => J(3),  -- D4
                   -- 
    X_8  => E(3),  -- Q4
    X_9  => E(2),  -- Q3
                   -- 
    X_11 => open,  -- GND
    X_12 => J(4),  -- E12
    X_13 => E(1),  -- Q2
    X_14 => E(0)   -- Q1
);
end architecture Test;
