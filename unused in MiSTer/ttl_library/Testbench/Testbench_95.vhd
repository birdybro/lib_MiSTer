-----------------------------------------------------------------------
-- Bipolar TTL models (VHDL)                                         --
-- David R Brooks                                                    --
-- June, 2016.  Perth, Australia                                     --
-- Compliance: VHDL 2008                                             --
-- Testbench for SN74LS95N: 4-bit right/left shift register          --
-----------------------------------------------------------------------

library ieee;
    use ieee.std_logic_1164.all;
    use ieee.std_logic_misc.all;
    use ieee.numeric_std.all;
    use work.LSTTL.all;
    use work.TTLPrivate.all;
    
entity Testbench_95 is     -- Top-level bench
generic(
    StimClk  : std_logic      := '1'; 
    CheckClk : std_logic      := '1';
    Period   : time           :=  50 ns;
    Finish   : time           :=  20 us;
    SevLevel : severity_level := failure
);
end entity;

architecture Test of Testbench_95 is
    signal RS               : std_logic;
    signal CLK              : std_logic;
    signal JC, BC           : unsigned(3 downto 0);           -- Test stimuli
    signal D,  E            : std_logic_vector(3 downto 0);   -- Expected & actual results
    signal P                : std_logic_vector(3 downto 0);
    signal CP1, CP2, PE, DS : std_logic := '1';
    
    begin
    P  <= std_logic_vector(JC(3 downto 0));
    DS <= JC(1);
    
    process(CLK, RS) is     -- Generate special clocks, etc.
        variable X   : unsigned(3 downto 0);
        variable IPE, IC1, IC2 : std_logic := '1';
    begin
        if rising_edge(CLK) then
            CP1 <= IC1;
            CP2 <= IC2;
            IC1 := '1';
            IC2 := '1';
            X   := BC(X'range);
            if (X = "1000") or (RS = '0') then
                IPE := '1'; 
                IC2 := '0';  -- Load
            else
                IPE := '0';
                IC1 := '0';  -- Shift
            end if;
        elsif falling_edge(CLK) then
            CP1 <= '1';
            CP2 <= '1';
            PE  <= IPE;
        end if;
    end process;
    
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
    process(CP1, CP2) is
    begin
        if    falling_edge(CP1) and PE = '0' then
            D <= D(2 downto 0) & DS;
        elsif falling_edge(CP2) and PE = '1' then
            D <= P;
        end if;            
    end process;
    
    -----------------------------------------------------------------------
    -- Device Under Test...                        
    -----------------------------------------------------------------------
    DUT: SN74LS95N 
    port map(
    X_1  => DS,  -- DS
    X_2  => P(0),  -- P0
    X_3  => P(1),  -- P1
    X_4  => P(2),  -- P2
    X_5  => P(3),  -- P3
    X_6  => PE,  -- PE
    X_7  => open,  -- GND
    X_8  => CP2,  -- CP2\
    X_9  => CP1,  -- CP1\
    X_10 => E(3),  -- Q3
    X_11 => E(2),  -- Q2
    X_12 => E(1),  -- Q1
    X_13 => E(0),  -- Q0
    X_14 => open   -- Vcc
    );
end architecture Test;
