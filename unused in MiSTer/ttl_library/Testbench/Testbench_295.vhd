-----------------------------------------------------------------------
-- Bipolar TTL models (VHDL)                                         --
-- David R Brooks                                                    --
-- December, 2016.  Perth, Australia                                 --
-- Compliance: VHDL 2008                                             --
-- Testbench for SN74LS295AN: 4-bit shift register (3-state outputs) --
-----------------------------------------------------------------------

library ieee;
    use ieee.std_logic_1164.all;
    use ieee.std_logic_misc.all;
    use ieee.numeric_std.all;
    use work.LSTTL.all;
    use work.TTLPrivate.all;
    
entity Testbench_295 is     -- Top-level bench
generic(
    StimClk  : std_logic      := '0'; 
    CheckClk : std_logic      := '0';
    Period   : time           :=  50 ns;
    Finish   : time           :=  20 us;
    SevLevel : severity_level := failure
);
end entity;

architecture Test of Testbench_295 is
    signal RS             : std_logic;
    signal CLK            : std_logic;
    signal JC, BC         : unsigned(3 downto 0);           -- Test stimuli
    signal D,  E          : std_logic_vector(3 downto 0);   -- Expected & actual results
    signal P,  Q          : std_logic_vector(3 downto 0);
    signal CP, OE, PE, DS : std_logic := '1';
    
    begin
    P  <= std_logic_vector(JC(3 downto 0));
    DS <= JC(1);
    CP <= CLK;
    PE <= '1' when ((BC = "1000") or (RS = '0')) else '0';
    
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
    process(CP) is
    begin
        if falling_edge(CP) then
            if PE = '0' then
                Q <= Q(2 downto 0) & DS;
            else
                Q <= P;
            end if; 
        end if;
    end process;
    
    D <= Q when OE = '1' else (others => 'Z');
    
    -----------------------------------------------------------------------
    -- Device Under Test...                        
    -----------------------------------------------------------------------
    DUT: SN74LS295AN 
    port map(
        X_1  => DS,    -- DS
        X_2  => P(0),  -- P0
        X_3  => P(1),  -- P1
        X_4  => P(2),  -- P2
        X_5  => P(3),  -- P3
        X_6  => PE,    -- PE
        X_7  => open,  -- GND
        X_8  => OE,    -- OE
        X_9  => CP,    -- CP\
        X_10 => E(3),  -- Q3
        X_11 => E(2),  -- Q2
        X_12 => E(1),  -- Q1
        X_13 => E(0),  -- Q0
        X_14 => open   -- Vcc
    );
end architecture Test;
