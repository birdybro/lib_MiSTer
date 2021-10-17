-----------------------------------------------------------------------
-- Bipolar TTL models (VHDL)                                         --
-- David R Brooks                                                    --
-- June, 2016.  Perth, Australia                                     --
-- Compliance: VHDL 2008                                             --
-- Testbench for SN74LS174N: Hex D-flipflop                          --
-----------------------------------------------------------------------

library ieee;
    use ieee.std_logic_1164.all;
    use ieee.std_logic_misc.all;
    use ieee.numeric_std.all;
    use work.LSTTL.all;
    use work.TTLPrivate.all;
    
entity Testbench_174 is     -- Top-level bench
generic(
    StimClk  : std_logic      := '1'; 
    CheckClk : std_logic      := '1';
    Period   : time           := 100 ns;
    Finish   : time           :=  20 us;
    SevLevel : severity_level := failure
);
end entity;

architecture Test of Testbench_174 is
    signal RS         : std_logic;
    signal CLK        : std_logic;
    signal JC, BC     : unsigned(5 downto 0);           -- Test stimuli
    signal D,  E      : std_logic_vector(5 downto 0);   -- Expected & actual results
    signal R          : std_logic_vector(5 downto 0);   -- Input
    
    begin
    R <= std_logic_vector(JC);
    
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
    process(CLK, RS) is
    begin
        if RS = '0' then 
            D <= (others => '0');
        elsif rising_edge(CLK) then
            D <= R;
        end if;
    end process;
    
    -----------------------------------------------------------------------
    -- Device Under Test...                        
    -----------------------------------------------------------------------
    DUT: SN74LS174N 
    port map(
        X_1  => RS,   -- MR\
        X_2  => E(0), -- Q0
        X_3  => R(0), -- D0
        X_4  => R(1), -- D1
        X_5  => E(1), -- Q1
        X_6  => R(2), -- D2
        X_7  => E(2), -- Q2
        X_8  => open, -- GND
        X_9  => CLK,  -- CP
        X_10 => E(3), -- Q3
        X_11 => R(3), -- D3
        X_12 => E(4), -- Q4
        X_13 => R(4), -- D4
        X_14 => R(5), -- D5
        X_15 => E(5), -- Q5
        X_16 => open  -- Vcc
    );
end architecture Test;
