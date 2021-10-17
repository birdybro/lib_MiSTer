-----------------------------------------------------------------------
-- Bipolar TTL models (VHDL)                                         --
-- David R Brooks                                                    --
-- August, 2016.  Perth, Australia                                   --
-- Compliance: VHDL 2008                                             --
-- Testbench for SN74LS199N: 8-bit parallel IO shift register        --
-----------------------------------------------------------------------

library ieee;
    use ieee.std_logic_1164.all;
    use ieee.std_logic_misc.all;
    use ieee.numeric_std.all;
    use work.LSTTL.all;
    use work.TTLPrivate.all;
    
entity Testbench_199 is     -- Top-level bench
generic(
    StimClk  : std_logic      := '1'; 
    CheckClk : std_logic      := '1';
    Period   : time           := 50 ns;
    Finish   : time           := 50 us;
    SevLevel : severity_level := failure
);
end entity;

architecture Test of Testbench_199 is
    signal CLK, RS  : std_logic;
    signal JC,  BC  : unsigned(7 downto 0);       -- Test stimuli
    signal D,   E   : std_logic_vector(0 to 7);   -- Expected & actual results
    signal P,   Q   : std_logic_vector(0 to 7);
    signal J, KB, CP1, CP2, PE, CP, I : std_logic;
    signal JKB      : std_logic_vector(1 downto 0);
    

    begin
    P <= std_logic_vector(BC(7 downto 0)) after 1 ns;   -- Be sure CP evaluates first
    (J, KB, PE) <= JC(2 downto 0) after 1 ns;
    CP1 <= CLK;
    CP2 <= '1', '0' after 288 ns;
    
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
    CP  <= CP1 or CP2;
    JKB <= J & KB;
    
    with JKB select I <=
        '0'      when "00",
        not Q(0) when "10",
        '1'      when "11",
        Q(0)     when others;
    
    process(RS, CP) is
    begin
        if RS = '0' then
            Q <= (others => '0');
        elsif rising_edge(CP) then
            if PE <= '0' then
                Q <= P;
            else
                Q <= I & Q(0 to 6);
            end if;
        end if;
    end process;
    
    D <= (Q(0), Q(1), Q(2), Q(3), Q(4), Q(5), Q(6), Q(7));

    
    -----------------------------------------------------------------------
    -- Device Under Test...                        
    -----------------------------------------------------------------------
    DUT: SN74LS199N 
    port map(
        X_1  => KB,   -- in     KB\
        X_2  => J,    -- in     J
        X_3  => P(0), -- in     P0
        X_4  => E(0), -- out    Q0
        X_5  => P(1), -- in     P1
        X_6  => E(1), -- out    Q1
        X_7  => P(2), -- in     P2
        X_8  => E(2), -- out    Q2
        X_9  => P(3), -- in     P3
        X_10 => E(3), -- out    Q3
        X_11 => CP1,  -- in     CP1
        X_12 => open, -- inout  GND
        X_13 => CP2,  -- in     CP2
        X_14 => RS,   -- in     MR\
        X_15 => E(4), -- out    Q4
        X_16 => P(4), -- in     P4
        X_17 => E(5), -- out    Q5
        X_18 => P(5), -- in     P5
        X_19 => E(6), -- out    Q6
        X_20 => P(6), -- in     P6
        X_21 => E(7), -- out    Q7
        X_22 => P(7), -- in     P7
        X_23 => PE,   -- in     PE\
        X_24 => open  -- inout  Vcc
   );
end architecture Test;
