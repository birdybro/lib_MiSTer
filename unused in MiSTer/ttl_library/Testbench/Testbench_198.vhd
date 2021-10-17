-----------------------------------------------------------------------
-- Bipolar TTL models (VHDL)                                         --
-- David R Brooks                                                    --
-- December, 2016.  Perth, Australia                                 --
-- Compliance: VHDL 2008                                             --
-- Testbench for SN74LS198N: 8-bit right/left shift register         --
-----------------------------------------------------------------------

library ieee;
    use ieee.std_logic_1164.all;
    use ieee.std_logic_misc.all;
    use ieee.numeric_std.all;
    use work.LSTTL.all;
    use work.TTLPrivate.all;
    
entity Testbench_198 is     -- Top-level bench
generic(
    StimClk  : std_logic      := '1'; 
    CheckClk : std_logic      := '1';
    Period   : time           := 50 ns;
    Finish   : time           := 50 us;
    SevLevel : severity_level := failure
);
end entity;

architecture Test of Testbench_198 is
    signal CLK, RS  : std_logic;
    signal JC,  BC  : unsigned(9 downto 0);       -- Test stimuli
    signal D,   E   : std_logic_vector(0 to 7);   -- Expected & actual results
    signal S        : std_logic_vector(1 downto 0);
    signal P,   Q   : std_logic_vector(0 to 7);
    signal DSR, DSL : std_logic;
    
    signal L1 : std_logic;
    signal L2 : std_logic;
    signal L3 : std_logic;
    signal L4 : std_logic;
    signal N0 : std_logic;
    
    signal T1, T2, T3, T4 : std_logic_vector(0 to 7);


    begin
    P    <= std_logic_vector(JC(7 downto 0));
    DSR  <= JC(8);
    DSL  <= JC(9);
    S    <= std_logic_vector(BC(5 downto 4));
    
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
    L1 <= not S(1);
    L2 <= not S(0);
    L3 <= L1 and L2;
    L4 <= not(L1 or L2);
    N0 <= CLK or L3;
    
    T1(0) <= DSR and L1;
    T3(7) <= L2 and DSL;
    
    G1: for i in 1 to 7 generate
    begin
        T1(i) <=  (Q(i-1) and L1);
    end generate;
    
    G2: for i in 0 to 6 generate
    begin
        T3(i) <= L2 and Q(i+1);
    end generate;
    
    G3: for i in 0 to 7 generate
    begin
        T2(i) <= L4 and P(i);
        T4(i) <= T1(i) or T2(i) or T3(i);
        DQ : TTL_FF port map(q=>Q(i), d=>T4(i), clk=>N0, cl=>RS);
    end generate;
    
    D <= Q;
    
    -----------------------------------------------------------------------
    -- Device Under Test...                        
    -----------------------------------------------------------------------
    DUT: SN74LS198N 
    port map(
        X_1  => S(0),  --  S(0)
        X_2  => DSR,   --  DSR
        X_3  => P(0),  --  P0
        X_4  => E(0),  --  Q0
        X_5  => P(1),  --  P1
        X_6  => E(1),  --  Q1
        X_7  => P(2),  --  P2
        X_8  => E(2),  --  Q2
        X_9  => P(3),  --  P3
        X_10 => E(3),  --  Q3
        X_11 => CLK,   --  CP
        X_12 => open,  --  GND
        X_13 => RS,    --  MR\
        X_14 => E(4),  --  Q4
        X_15 => P(4),  --  P4
        X_16 => E(5),  --  Q5
        X_17 => P(5),  --  P5
        X_18 => E(6),  --  Q6
        X_19 => P(6),  --  P6
        X_20 => E(7),  --  Q7
        X_21 => P(7),  --  P7
        X_22 => DSL,   --  DSL
        X_23 => S(1),  --  S(1)
        X_24 => open   --  Vcc
   );
end architecture Test;
