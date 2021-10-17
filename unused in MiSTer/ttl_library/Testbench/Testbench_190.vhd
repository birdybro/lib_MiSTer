-----------------------------------------------------------------------
-- Bipolar TTL models (VHDL)                                         --
-- David R Brooks                                                    --
-- August, 2016.  Perth, Australia                                   --
-- Compliance: VHDL 2008                                             --
-- Testbench for SN74LS190N: Up/down decade counter                  --
-----------------------------------------------------------------------

library ieee;
    use ieee.std_logic_1164.all;
    use ieee.std_logic_misc.all;
    use ieee.numeric_std.all;
    use work.LSTTL.all;
    use work.TTLPrivate.all;
    
entity Testbench_190 is     -- Top-level bench
generic(
    StimClk  : std_logic      := '1'; 
    CheckClk : std_logic      := '1';
    Period   : time           := 100 ns;
    Finish   : time           :=  15 us;
    SevLevel : severity_level := failure
);
end entity;

architecture Test of Testbench_190 is
    signal JC, BC : unsigned(6 downto 0);           -- Test stimuli
    signal D, E   : std_logic_vector(5 downto 0);   -- Expected & actual results
    
    signal P      : unsigned(3 downto 0);
    signal CP     : std_logic;
    signal RS, PL : std_logic;
    signal CE, UD : std_logic;
    
    signal T1,  T2,  T3,  T4,  T5,
           T6,  T7,  T8,  T9,  T10,
           T11, T12, T13, T14, T15,
           T16      : std_logic;

    signal Q, QB, X : unsigned(3 downto 0);
    
    
    begin
    P  <= JC(6 downto 3);
    CE <= BC(6);
    
    process(CP) is
    begin
        if rising_edge(CP) then
            PL <= RS and nand_reduce(std_logic_vector(BC(4 downto 0))) after 10 ns, '1' after 80 ns;
            UD <= BC(5);
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
        CLK  => CP,
        RS   => RS,
        D    => D,
        E    => E
   );
    
    -----------------------------------------------------------------------
    -- Generate expected results (with zero delays)
    -----------------------------------------------------------------------
    T1   <= not (UD);
    T2   <= not (UD or CE);
    T3   <= not (CE or T1);
    T4   <= not (QB(1) and QB(2) and QB(3));
    T5   <= T3 and QB(0) and T4;
    T6   <= Q(0) and QB(3) and T2;
    T7   <= T4 and T3 and QB(0) and QB(1);
    T8   <= Q(0) and Q(1) and T2;
    T9   <= T3 and QB(0) and QB(1) and QB(2);
    T10  <= Q(0) and Q(3) and T2;
    T11  <= Q(0) and Q(1) and Q(2) and T2;
    X(0) <= not (CE);
    X(1) <= T5 or T6;
    X(2) <= T7 or T8;
    X(3) <= T9 or T10 or T11;
        
    process(CP, PL) is 
    begin
        if PL = '0' then 
            Q <= P;
        elsif rising_edge(CP) and (CE = '0') then
            Q <= Q xor X;       -- 'T' flipflops
        end if;
    end process;
    
    QB  <= not Q;
    
    T15  <= (T1 and Q(0) and Q(3));   -- True for count = 9, 11, 13, 15
    T16  <= (UD and QB(0) and QB(1) and QB(2) and QB(3));
    T12  <= (T15 or T16);
    
    T13  <= not (CP);
    T14  <= not (CE);
    
    D(3 downto 0) <= std_logic_vector(Q);
    D(4) <=  T12;
    D(5) <= not (T13 and T14 and T12);
    
    -----------------------------------------------------------------------
    -- Device Under Test...                        
    -----------------------------------------------------------------------
    DUT: SN74LS190N 
    port map(
        X_1  => P(1), --  P1
        X_2  => E(1), --  Q1
        X_3  => E(0), --  Q0
        X_4  => CE,   --  CE\
        X_5  => UD,   --  U\/D
        X_6  => E(2), --  Q2
        X_7  => E(3), --  Q3
        X_8  => open, --  GND
        X_9  => P(3), --  P3
        X_10 => P(2), --  P2
        X_11 => PL,   --  PL\
        X_12 => E(4), --  TC
        X_13 => E(5), --  RC\
        X_14 => CP,   --  CP
        X_15 => P(0), --  P0
        X_16 => open  --  Vcc
   );
end architecture Test;
