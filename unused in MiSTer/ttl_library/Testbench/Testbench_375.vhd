-----------------------------------------------------------------------
-- Bipolar TTL models (VHDL)                                         --
-- David R Brooks                                                    --
-- December, 2016.  Perth, Australia                                 --
-- Compliance: VHDL 2008                                             --
-- Testbench for SN74LS375N: 4-bit bistable latch                    --
-----------------------------------------------------------------------

library ieee;
    use ieee.std_logic_1164.all;
    use ieee.std_logic_misc.all;
    use ieee.numeric_std.all;
    use work.LSTTL.all;
    use work.TTLPrivate.all;
    
entity Testbench_375 is     -- Top-level bench
generic(
    StimClk  : std_logic      := '1'; 
    CheckClk : std_logic      := '0';
    Period   : time           := 100 ns;
    Finish   : time           :=  20 us;
    SevLevel : severity_level := failure
);
end entity;

architecture Test of Testbench_375 is
    signal CLK      : std_logic;
    signal J, B     : unsigned(5 downto 0);         -- Test stimuli
    signal D, E     : std_logic_vector(7 downto 0); -- Expected & actual results
    signal S        : std_logic_vector(3 downto 0);
    signal E12, E34 : std_logic;
    
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
        if falling_edge(CLK) then
            E12 <= J(4), '0' after 45 ns;
            E34 <= J(5), '0' after 45 ns;
        end if;
    end process;
    
    S <= (E34, E34, E12, E12);
    
    G1: for i in 3 downto 0 generate
    begin
        process(S, J) is
        begin
            if S(i) = '1' then
                D(i)   <= J(i);
                D(i+4) <= not J(i);
            end if;
        end process;
    end generate;
    
    -----------------------------------------------------------------------
    -- Device Under Test...                        
    -----------------------------------------------------------------------
    DUT: SN74LS375N 
--    port map(
--        X_1  => E(4),  -- Q1\
--        X_2  => J(0),  -- D1
--        X_3  => J(1),  -- D2
--        X_4  => E34,   -- E34
--        X_5  => open,  -- Vcc
--        X_6  => J(2),  -- D3
--        X_7  => J(3),  -- D4
--        X_8  => E(7),  -- Q4\
--        X_9  => E(3),  -- Q4
--        X_10 => E(6),  -- Q3\
--        X_11 => E(2),  -- Q3
--        X_12 => open,  -- GND
--        X_13 => E12,   -- E12
--        X_14 => E(5),  -- Q2\
--        X_15 => E(1),  -- Q2
--        X_16 => E(0)   -- Q1
--    );
    port map(
        X_1  => J(0),  -- D1
        X_2  => E(4),  -- Q1\
        X_3  => E(0),  -- Q1
        X_4  => E12,   -- E12
        X_5  => E(1),  -- Q2
        X_6  => E(5),  -- Q2\
        X_7  => J(1),  -- D2
        X_8  => open,  -- GND
        X_9  => J(2),  -- D3
        X_10 => E(6),  -- Q3\
        X_11 => E(2),  -- Q3
        X_12 => E34,   -- E34
        X_13 => E(3),  -- Q4
        X_14 => E(7),  -- Q4\
        X_15 => J(3),  -- D4
        X_16 => open   -- Vcc
    );
end architecture Test;
