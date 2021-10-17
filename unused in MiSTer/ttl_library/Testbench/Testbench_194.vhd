-----------------------------------------------------------------------
-- Bipolar TTL models (VHDL)                                         --
-- David R Brooks                                                    --
-- August, 2016.  Perth, Australia                                   --
-- Compliance: VHDL 2008                                             --
-- Testbench for SN74LS194N: 4-bit bidirectional shift register      --
-----------------------------------------------------------------------

library ieee;
    use ieee.std_logic_1164.all;
    use ieee.std_logic_misc.all;
    use ieee.numeric_std.all;
    use work.LSTTL.all;
    use work.TTLPrivate.all;
    
entity Testbench_194 is     -- Top-level bench
generic(
    StimClk  : std_logic      := '1'; 
    CheckClk : std_logic      := '1';
    Period   : time           := 100 ns;
    Finish   : time           :=  15 us;
    SevLevel : severity_level := failure
);
end entity;

architecture Test of Testbench_194 is
    signal JC, BC  : unsigned(7 downto 0);           -- Test stimuli
    signal D,  E   : std_logic_vector(3 downto 0);   -- Expected & actual results
    
    signal P       : unsigned(3 downto 0);
    signal CLK, RS : std_logic;
    signal S       : std_logic_vector(1 downto 0);
    signal DR, DL  : std_logic;
    
    -- NB Q3 is considered the rightmost bit (see data sheet)
    signal M, R, Q : unsigned(0 to 3);   
    
    
    begin
    (DR, DL, P) <= BC(5 downto 0);
    S(0)        <= and_reduce(std_logic_vector(JC(4 downto 0)));
    S(1)        <= nor_reduce(std_logic_vector(JC(4 downto 0)));
    
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
    M <= P(3) & P(2) & P(1) & P(0);
        
    with S select R <=
        M              when "11",   -- Load
        Q(1 to 3) & DL when "10",   -- Left
        DR & Q(0 to 2) when "01",   -- Right
        Q              when others; -- Hold
    
    process(CLK, RS) is
    begin
        if RS = '0' then
            Q <= (others => '0');
        elsif rising_edge(CLK) then
            Q <= R;
        end if;
    end process;
    
    (D(3), D(2), D(1), D(0)) <= Q;
    
    -----------------------------------------------------------------------
    -- Device Under Test...                        
    -----------------------------------------------------------------------
    DUT: SN74LS194N 
    port map(
        X_1  => RS,   -- MR\
        X_2  => DR,   -- DSR
        X_3  => P(0), -- P0
        X_4  => P(1), -- P1
        X_5  => P(2), -- P2
        X_6  => P(3), -- P3
        X_7  => DL,   -- DSL
        X_8  => open, -- GND
        X_9  => S(0), -- S(0)
        X_10 => S(1), -- S(1)
        X_11 => CLK,  -- CP
        X_12 => E(3), -- Q3
        X_13 => E(2), -- Q2
        X_14 => E(1), -- Q1
        X_15 => E(0), -- Q0
        X_16 => open  -- Vcc
   );
end architecture Test;
