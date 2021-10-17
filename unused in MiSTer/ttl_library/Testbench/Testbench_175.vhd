-----------------------------------------------------------------------
-- Bipolar TTL models (VHDL)                                         --
-- David R Brooks                                                    --
-- June, 2016.  Perth, Australia                                     --
-- Compliance: VHDL 2008                                             --
-- Testbench for SN74LS175N: Quad D-flipflop                         --
-----------------------------------------------------------------------

library ieee;
    use ieee.std_logic_1164.all;
    use ieee.std_logic_misc.all;
    use ieee.numeric_std.all;
    use work.LSTTL.all;
    use work.TTLPrivate.all;
    
entity Testbench_175 is     -- Top-level bench
generic(
    StimClk  : std_logic      := '1'; 
    CheckClk : std_logic      := '1';
    Period   : time           := 100 ns;
    Finish   : time           :=  20 us;
    SevLevel : severity_level := failure
);
end entity;

architecture Test of Testbench_175 is
    signal RS         : std_logic;
    signal CLK        : std_logic;
    signal JC, BC     : unsigned(3 downto 0);           -- Test stimuli
    signal D,  E      : std_logic_vector(7 downto 0);   -- Expected & actual results
    signal R          : std_logic_vector(3 downto 0);   -- Input
    
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
            D(3 downto 0) <= (others => '0');
            D(7 downto 4) <= (others => '1');
        elsif rising_edge(CLK) then
            for i in R'range loop
                D(i)   <= R(i);
                D(4+i) <= not R(i);
            end loop;
        end if;
    end process;
    
    -----------------------------------------------------------------------
    -- Device Under Test...                        
    -----------------------------------------------------------------------
    DUT: SN74LS175N 
    port map(
        X_1  => RS,   -- MR\
        X_2  => E(0), -- Q0
        X_3  => E(4), -- Q0\
        X_4  => R(0), -- D0
        X_5  => R(1), -- D1
        X_6  => E(5), -- Q1\
        X_7  => E(1), -- Q1
        X_8  => open, -- GND
        X_9  => CLK,  -- CP
        X_10 => E(2), -- Q2
        X_11 => E(6), -- Q2\
        X_12 => R(2), -- D2
        X_13 => R(3), -- D3
        X_14 => E(7), -- Q3\
        X_15 => E(3), -- Q3
        X_16 => open  -- Vcc
    );
end architecture Test;
