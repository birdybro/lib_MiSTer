-----------------------------------------------------------------------
-- Bipolar TTL models (VHDL)                                         --
-- David R Brooks                                                    --
-- June, 2016.  Perth, Australia                                     --
-- Compliance: VHDL 2008                                             --
-- Testbench for SN74H103N: Dual JK edge-triggered flipflop          --
-----------------------------------------------------------------------

library ieee;
    use ieee.std_logic_1164.all;
    use ieee.std_logic_misc.all;
    use ieee.numeric_std.all;
    use work.LSTTL.all;
    use work.TTLPrivate.all;
    
entity Testbench_103 is     -- Top-level bench
generic(
    StimClk  : std_logic      := '1'; 
    CheckClk : std_logic      := '1';
    Period   : time           := 120 ns;
    Finish   : time           :=  20 us;
    SevLevel : severity_level := failure
);
end entity;

architecture Test of Testbench_103 is
    signal RS     : std_logic;
    signal CLK    : std_logic;
    signal JC, BC : unsigned(3 downto 0);           -- Test stimuli
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
            variable JK : std_logic_vector(1 downto 0);
        begin
            if    RS = '0' then
                D(i) <= '0';
            elsif falling_edge(CLK) then
                JK := BC(i) & BC(2+i);
                case JK is
                    when "00"   => null;
                    when "01"   => D(i) <= '0';
                    when "10"   => D(i) <= '1';
                    when "11"   => D(i) <= not D(i);
                    when others => null;
                end case;
            end if;
        end process;
        D(i+2) <= not D(i);
    end generate;   
    
    -----------------------------------------------------------------------
    -- Device Under Test...                        
    -----------------------------------------------------------------------
    DUT: SN74H103N 
    port map(
    X_1  => CLK,   -- CP1\ 
    X_2  => RS,    -- CD1\
    X_3  => BC(2), -- K1
    X_4  => open,  -- Vcc
    X_5  => CLK,   -- CP2\
    X_6  => RS,    -- CD2\
    X_7  => BC(1), -- J2
    X_8  => E(3),  -- Q2\
    X_9  => E(1),  -- Q2
    X_10 => BC(3), -- K2
    X_11 => open,  -- GND
    X_12 => E(0),  -- Q1
    X_13 => E(2),  -- Q1\
    X_14 => BC(0)  -- J1
);
end architecture Test;
