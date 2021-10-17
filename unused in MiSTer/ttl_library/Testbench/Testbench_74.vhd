-----------------------------------------------------------------------
-- Bipolar TTL models (VHDL)                                         --
-- David R Brooks                                                    --
-- June, 2016.  Perth, Australia                                     --
-- Compliance: VHDL 2008                                             --
-- Testbench for SN74LS74N: Dual D-type +ve edge-triggered flipflop  --
-----------------------------------------------------------------------

library ieee;
    use ieee.std_logic_1164.all;
    use ieee.std_logic_misc.all;
    use ieee.numeric_std.all;
    use work.LSTTL.all;
    use work.TTLPrivate.all;
    
entity Testbench_74 is     -- Top-level bench
generic(
    StimClk  : std_logic      := '1'; 
    CheckClk : std_logic      := '0';
    Period   : time           := 120 ns;
    Finish   : time           :=  20 us;
    SevLevel : severity_level := failure
);
end entity;

architecture Test of Testbench_74 is
    signal RS     : std_logic;
    signal CLK    : std_logic;
    signal JC, BC : unsigned(1 downto 0);           -- Test stimuli
    signal D,  E  : std_logic_vector(3 downto 0);   -- Expected & actual results

    begin
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
    
    G: for i in 1 downto 0 generate
    begin
        SIM: process(CLK, RS) is
        begin
            if    RS = '0' then
                D(i) <= '0';
            elsif rising_edge(CLK) then
                D(i) <= BC(i);
            end if;
        end process;
        D(i+2) <= not D(i);
    end generate;   
    
    -----------------------------------------------------------------------
    -- Device Under Test...                        
    -----------------------------------------------------------------------
    DUT: SN74LS74N 
    port map(
    X_1  => RS,    -- CD1\
    X_2  => BC(0), -- D1
    X_3  => CLK,   -- CP1
    X_4  => '1',   -- SD1\
    X_5  => E(0),  -- Q1
    X_6  => E(2),  -- Q1\
    X_7  => open,  -- GND
    X_8  => E(3),  -- Q2\
    X_9  => E(1),  -- Q2
    X_10 => '1',   -- SD2\
    X_11 => CLK,   -- CP2
    X_12 => BC(1), -- D2
    X_13 => RS,    -- CD2\
    X_14 => open   -- Vcc
);
end architecture Test;
