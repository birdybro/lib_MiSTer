-----------------------------------------------------------------------
-- Bipolar TTL models (VHDL)                                         --
-- David R Brooks                                                    --
-- August, 2016.  Perth, Australia                                   --
-- Compliance: VHDL 2008                                             --
-- Testbench for SN74LS192N: Up/down decade counter                  --
-----------------------------------------------------------------------

library ieee;
    use ieee.std_logic_1164.all;
    use ieee.std_logic_misc.all;
    use ieee.numeric_std.all;
    use work.LSTTL.all;
    use work.TTLPrivate.all;
    
entity Testbench_192 is     -- Top-level bench
generic(
    StimClk  : std_logic      := '1'; 
    CheckClk : std_logic      := '1';
    Period   : time           := 100 ns;
    Finish   : time           :=  15 us;
    SevLevel : severity_level := failure
);
end entity;

architecture Test of Testbench_192 is
    signal JC, BC : unsigned(6 downto 0);           -- Test stimuli
    signal D, E   : std_logic_vector(5 downto 0);   -- Expected & actual results
    
    signal P             : unsigned(3 downto 0);
    signal CLK, CPU, CPD : std_logic;
    signal MR,  RS,  PL  : std_logic;
    signal Q, QB         : unsigned(3 downto 0);
    
    signal T1,  T2, T3, T4, T5,
           T6,  T7, T8, T9, T10,
           T11, T12       : std_logic;
    signal CX, CL, PR, CC : std_logic_vector(3 downto 0);

    
    begin
    P  <= JC(6 downto 3);
    MR <= not RS;       -- Active high
    
    process(CLK) is
    begin
        if rising_edge(CLK) then
            PL  <= nand_reduce(std_logic_vector(BC(4 downto 0))) after 10 ns, '1' after 80 ns;
            CPU <= BC(5);
            CPD <= not BC(5);
        elsif falling_edge(CLK) then    -- NB Inactive clock should be high
            CPU <= '1';
            CPD <= '1';
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
    T1    <= not (CPD);
    T2    <= not (CPU);
    T3    <= not (QB(1) and QB(2) and QB(3));
    T4    <= T1 and QB(0) and T3;
    T5    <= Q(0) and QB(3) and T2;
    T6    <= T3 and T1 and QB(0) and QB(1);
    T7    <= Q(0) and Q(1) and T2;
    T8    <= T1 and QB(0) and QB(1) and QB(2);
    T9    <= Q(0) and Q(3) and T2;
    T10   <= Q(0) and Q(1) and Q(2) and T2;
    T11   <= not (MR);
    T12   <= not (PL);
    CX(0) <= not (T1 or T2);
    CX(1) <= not (T4 or T5);
    CX(2) <= not (T6 or T7);
    CX(3) <= not (T8 or T9 or T10);
    
    G: for i in CX'range generate
    begin
        PR(i) <= not (P(i) and T12 and T11);
        CC(i) <= not (PR(i) and T12);
        CL(i) <= (T11 and CC(i));
        
        process(CX, PR, CL) is      -- A 'T' flipflop
        begin
            if CL(i) = '0' then
                Q(i) <= '0';
            elsif PR(i) = '0' then
                Q(i) <= '1';
            elsif rising_edge(CX(i)) then
                Q(i) <= not Q(i);
            end if;
        end process;        
    end generate;
    
    QB <= not Q;
    D(3 downto 0) <= std_logic_vector(Q);
    D(4) <= not (Q(0) and Q(3) and T2);
    D(5) <= not (T1 and QB(0) and QB(1) and QB(2) and QB(3));
    
    -----------------------------------------------------------------------
    -- Device Under Test...                        
    -----------------------------------------------------------------------
    DUT: SN74LS192N 
    port map(
        X_1  => P(1), --  P1
        X_2  => E(1), --  Q1
        X_3  => E(0), --  Q0
        X_4  => CPD,  --  CPD
        X_5  => CPU,  --  CPU
        X_6  => E(2), --  Q2
        X_7  => E(3), --  Q3
        X_8  => open, --  GND
        X_9  => P(3), --  P3
        X_10 => P(2), --  P2
        X_11 => PL,   --  PL\
        X_12 => E(4), --  TCU\
        X_13 => E(5), --  TCD\
        X_14 => MR,   --  MR
        X_15 => P(0), --  P0
        X_16 => open  --  Vcc
   );
end architecture Test;
