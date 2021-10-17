-----------------------------------------------------------------------
-- Bipolar TTL models (VHDL)                                         --
-- David R Brooks                                                    --
-- December, 2016.  Perth, Australia                                 --
-- Compliance: VHDL 2008                                             --
-- Testbench for SN74LS395N: 4-bit shift/load register               --
-----------------------------------------------------------------------

library ieee;
    use ieee.std_logic_1164.all;
    use ieee.std_logic_misc.all;
    use ieee.numeric_std.all;
    use work.LSTTL.all;
    use work.TTLPrivate.all;
    
entity Testbench_395 is     -- Top-level bench
generic(
    StimClk  : std_logic      := '1'; 
    CheckClk : std_logic      := '1';
    Period   : time           :=  75 ns;
    Finish   : time           :=  20 us;
    SevLevel : severity_level := failure
);
end entity;

architecture Test of Testbench_395 is
    signal RS     : std_logic;
    signal CLK    : std_logic;
    signal JC, BC : unsigned(3 downto 0);           -- Test stimuli
    signal D,  E  : std_logic_vector(4 downto 0);   -- Expected & actual results
    signal R      : std_logic_vector(3 downto 0); 
    
    alias S  is JC(0);
    alias OE is JC(1);
    alias DS is JC(2);
    
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
        J    => JC, 
        B    => BC,
        CLK  => CLK,
        RS   => RS,
        D    => D,
        E    => E
    );
    
    -----------------------------------------------------------------------
    -- Generate expected results (with zero delays)
    -----------------------------------------------------------------------
    process(RS, CLK) is
    begin
        if RS = '0' then
            R <= (others => '0');
        elsif falling_edge(CLK) then
            if S = '0' then
                R <= R(2 downto 0) & DS;
            else
                R <= std_logic_vector(BC);
            end if;
        end if;
    end process;
    
    D(4) <= R(3);
    D(3 downto 0) <= R when OE = '0' else (others => 'Z');
    
    -----------------------------------------------------------------------
    -- Device Under Test...                        
    -----------------------------------------------------------------------
    DUT: SN74LS395N 
    port map(
        X_1  => RS,    -- MR\
        X_2  => DS,    -- DS
        X_3  => BC(0), -- P0
        X_4  => BC(1), -- P1
        X_5  => BC(2), -- P2
        X_6  => BC(3), -- P3
        X_7  => S,     -- S
        X_8  => open,  -- GND
        X_9  => OE,    -- OE\
        X_10 => CLK,   -- CP\
        X_11 => E(4),  -- Q3
        X_12 => E(3),  -- O3
        X_13 => E(2),  -- O2
        X_14 => E(1),  -- O1
        X_15 => E(0),  -- O0
        X_16 => open   -- Vcc
    );
end architecture Test;
