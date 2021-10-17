-----------------------------------------------------------------------
-- Bipolar TTL models (VHDL)                                         --
-- David R Brooks                                                    --
-- June, 2016.  Perth, Australia                                     --
-- Compliance: VHDL 2008                                             --
-- Testbench for SN74LS173N: 4-bit D-type register (3-state outputs) --
-----------------------------------------------------------------------

library ieee;
    use ieee.std_logic_1164.all;
    use ieee.std_logic_misc.all;
    use ieee.numeric_std.all;
    use work.LSTTL.all;
    use work.TTLPrivate.all;
    
entity Testbench_173 is     -- Top-level bench
generic(
    StimClk  : std_logic      := '1'; 
    CheckClk : std_logic      := '1';
    Period   : time           := 100 ns;
    Finish   : time           :=  20 us;
    SevLevel : severity_level := failure
);
end entity;

architecture Test of Testbench_173 is
    signal RS, RSH    : std_logic;
    signal CLK        : std_logic;
    signal JC, BC     : unsigned(7 downto 0);           -- Test stimuli
    signal D,  E      : std_logic_vector(3 downto 0);   -- Expected & actual results
    signal SR, DI     : std_logic_vector(3 downto 0);
    signal DIX        : unsigned(4 downto 0);
    signal IE1, IE2, OE1, OE2 : std_logic;
    
    begin
    RSH <= not RS;
    
    IE1 <= BC(0);
    IE2 <= BC(1);
    OE1 <= BC(2);
    OE2 <= BC(3);

    DI <= std_logic_vector(DIX(3 downto 0));
   
    
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
    process(CLK, RSH) is
    begin
        if RSH = '1' then 
            SR  <= (others => '0');
            DIX <= (others => '0');
        elsif rising_edge(CLK) then
            if to_integer(DIX) = 4 then
                DIX <= (others => '0');
            else
                DIX <= DIX + 1;
            end if;
            
            if (IE1 or IE2) = '0' then
                SR <= DI;
            end if;
        end if;
    end process;
    
    D <= SR when (OE1 or OE2) = '0' else (others => 'Z');
    
    -----------------------------------------------------------------------
    -- Device Under Test...                        
    -----------------------------------------------------------------------
    DUT: SN74LS173N 
    port map(
        X_1  => OE1,   --  OE1\
        X_2  => OE2,   --  OE2\
        X_3  => E(0),  --  Q0
        X_4  => E(1),  --  Q1
        X_5  => E(2),  --  Q2
        X_6  => E(3),  --  Q3
        X_7  => CLK,   --  CP
        X_8  => open,  --  GND
        X_9  => IE1,   --  IE1\
        X_10 => IE2,   --  IE2\
        X_11 => DI(3), --  D3
        X_12 => DI(2), --  D2
        X_13 => DI(1), --  D1
        X_14 => DI(0), --  D0
        X_15 => RSH,   --  MR
        X_16 => open   --  Vcc
    );
end architecture Test;
