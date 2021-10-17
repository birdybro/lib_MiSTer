-----------------------------------------------------------------------
-- Bipolar TTL models (VHDL)                                         --
-- David R Brooks                                                    --
-- December, 2016.  Perth, Australia                                 --
-- Compliance: VHDL 2008                                             --
-- Testbench for SN74LS195N: Universal 4-bit shift register          --
-----------------------------------------------------------------------

library ieee;
    use ieee.std_logic_1164.all;
    use ieee.std_logic_misc.all;
    use ieee.numeric_std.all;
    use work.LSTTL.all;
    use work.TTLPrivate.all;
    
entity Testbench_195 is     -- Top-level bench
generic(
    StimClk  : std_logic      := '1'; 
    CheckClk : std_logic      := '1';
    Period   : time           := 100 ns;
    Finish   : time           :=  15 us;
    SevLevel : severity_level := failure
);
end entity;

architecture Test of Testbench_195 is
    signal JC, BC    : unsigned(7 downto 0);           -- Test stimuli
    signal D,  E     : std_logic_vector(4 downto 0);   -- Expected & actual results
                     
    signal P         : unsigned(3 downto 0);
    signal CLK, RS   : std_logic;
    signal J, KB, PE : std_logic;
    
    signal L1  : std_logic;
    signal L2  : std_logic;
    signal L3  : std_logic;
    signal L4  : std_logic;
    signal L5  : std_logic;
    signal L6  : std_logic;
    signal L7  : std_logic;
    signal L8  : std_logic;
    signal L9  : std_logic;
    signal L10 : std_logic;
    signal L11 : std_logic;
    signal L12 : std_logic;
    signal L13 : std_logic;
    signal L14 : std_logic;
    signal N1  : std_logic;
    signal N2  : std_logic;
    signal N3  : std_logic;
    signal N4  : std_logic;
    signal N5  : std_logic;
    signal N6  : std_logic;
    
    begin
    (J, KB, P) <= BC(5 downto 0);
    PE         <= and_reduce(std_logic_vector(JC(5 downto 0)));
    
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
    N1  <= not (PE);
    N2  <= PE;
    L1  <= not (N3);
    L2  <= L1 and J and N2;
    L3  <= N2 and KB and N3;
    L4  <= N1 and P(0);
    L5  <= L2 or L3 or L4;
    L6  <= N3 and N2;
    L7  <= N1 and P(1);
    L8  <= L6 or L7;
    L9  <= N4 and N2;
    L10 <= N1 and P(2);
    L11 <= L9 or L10;
    L12 <= N5 and N2;
    L13 <= N1 and P(3);
    L14 <= L12 or L13;
    D38 : TTL_FF port map(q=>N3, d=>L5,  clk=>CLK, cl=>RS);
    D39 : TTL_FF port map(q=>N4, d=>L8,  clk=>CLK, cl=>RS);
    D40 : TTL_FF port map(q=>N5, d=>L11, clk=>CLK, cl=>RS);
    D41 : TTL_FF port map(q=>N6, d=>L14, clk=>CLK, cl=>RS);
    D(0) <= N3;
    D(1) <= N4;
    D(2) <= N5;
    D(3) <= N6;
    D(4) <= not (N6);
    
    -----------------------------------------------------------------------
    -- Device Under Test...                        
    -----------------------------------------------------------------------
    DUT: SN74LS195N 
    port map(
        X_1  => RS,   --  MR\
        X_2  => J,    --  J
        X_3  => KB,   --  K\
        X_4  => P(0), --  P0
        X_5  => P(1), --  P1
        X_6  => P(2), --  P2
        X_7  => P(3), --  P3
        X_8  => open, --  GND
        X_9  => PE,   --  PE\
        X_10 => CLK,  --  CP
        X_11 => E(4), --  Q3\
        X_12 => E(3), --  Q3
        X_13 => E(2), --  Q2
        X_14 => E(1), --  Q1
        X_15 => E(0), --  Q0
        X_16 => open  --  Vcc
  );
end architecture Test;
