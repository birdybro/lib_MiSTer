-----------------------------------------------------------------------
-- Bipolar TTL models (VHDL)                                         --
-- David R Brooks                                                    --
-- June, 2016.  Perth, Australia                                     --
-- Compliance: VHDL 2008                                             --
-- Testbench for SN74LS164N: SIPO shift register                     --
-----------------------------------------------------------------------

library ieee;
    use ieee.std_logic_1164.all;
    use ieee.std_logic_misc.all;
    use ieee.numeric_std.all;
    use work.LSTTL.all;
    use work.TTLPrivate.all;
    
entity Testbench_164 is     -- Top-level bench
generic(
    StimClk  : std_logic      := '1'; 
    CheckClk : std_logic      := '1';
    Period   : time           := 100 ns;
    Finish   : time           :=  20 us;
    SevLevel : severity_level := failure
);
end entity;

architecture Test of Testbench_164 is
    signal RS, RSH : std_logic;
    signal CLK     : std_logic;
    signal JC, BC  : unsigned(7 downto 0);           -- Test stimuli
    signal D,  E   : std_logic_vector(7 downto 0);   -- Expected & actual results
    
    alias CP : std_logic is CLK;
    alias A  : std_logic is JC(1);
    alias B  : std_logic is JC(2);
    alias MR : std_logic is RS;
    
    begin
    RS <= RSH;
        
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
        J    => JC, 
        B    => BC,
        CLK  => CLK,
        RS   => RSH,
        D    => D,
        E    => E
    );
    
    -----------------------------------------------------------------------
    -- Generate expected results (with zero delays)
    -----------------------------------------------------------------------
    process(CP, MR) is
        variable N : std_logic_vector(7 downto 0);
    begin
        if MR = '0' then
            N := (others => '0');
        elsif rising_edge(CP) then
            N := N(6 downto 0) & (A and B);
        end if;
        D <= N;
    end process;
    
    -----------------------------------------------------------------------
    -- Device Under Test...                        
    -----------------------------------------------------------------------
    DUT: SN74LS164N 
    port map(
    X_1  => A,     -- A
    X_2  => B,     -- B
    X_3  => E(0),  -- Q0
    X_4  => E(1),  -- Q1
    X_5  => E(2),  -- Q2
    X_6  => E(3),  -- Q3
    X_7  => open,  -- GND
    X_8  => CP,    -- CP
    X_9  => MR,    -- MR\
    X_10 => E(4),  -- Q4
    X_11 => E(5),  -- Q5
    X_12 => E(6),  -- Q6
    X_13 => E(7),  -- Q7
    X_14 => open   -- Vcc
    );
end architecture Test;
