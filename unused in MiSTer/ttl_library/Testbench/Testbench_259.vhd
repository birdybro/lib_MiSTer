-----------------------------------------------------------------------
-- Bipolar TTL models (VHDL)                                         --
-- David R Brooks                                                    --
-- December, 2016.  Perth, Australia                                 --
-- Compliance: VHDL 2008                                             --
-- Testbench for SN74259N: 8-bit addressable latch                   --
-----------------------------------------------------------------------

library ieee;
    use ieee.std_logic_1164.all;
    use ieee.std_logic_misc.all;
    use ieee.numeric_std.all;
    use work.LSTTL.all;
    use work.TTLPrivate.all;
    
entity Testbench_259 is     -- Top-level bench
generic(
    StimClk  : std_logic      := '1'; 
    CheckClk : std_logic      := '0';
    Period   : time           := 150 ns;
    Finish   : time           :=  20 us;
    SevLevel : severity_level := failure
);
end entity;

architecture Test of Testbench_259 is
    signal RS     : std_logic;
    signal CLK    : std_logic;
    signal EN     : std_logic;
    signal JC, BC : unsigned(4 downto 0);           -- Test stimuli
    signal D,  E  : std_logic_vector(7 downto 0);   -- Expected & actual results    
    
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
    
    process(all) is
    begin
        if falling_edge(BC(0)) then
            EN <= '0' after 20 ns, '1' after 100 ns;
        end if;
    end process;
    
    -----------------------------------------------------------------------
    -- Generate expected results (with zero delays)
    -----------------------------------------------------------------------
    process(all) is
        variable N : natural;
    begin
        N := to_integer(unsigned(BC(3 downto 1)));
        if RS = '0' then
            D <= (others => '0');
        elsif EN = '0' then
            D(N) <= BC(4);
        end if;    
    end process;
    
    -----------------------------------------------------------------------
    -- Device Under Test...                        
    -----------------------------------------------------------------------
    DUT: SN74LS259N 
    port map(
        X_1  => BC(1),  -- A0
        X_2  => BC(2),  -- A1
        X_3  => BC(3),  -- A2
        X_4  => E(0),   -- Q0
        X_5  => E(1),   -- Q1
        X_6  => E(2),   -- Q2
        X_7  => E(3),   -- Q3
        X_8  => open,   -- GND
        X_9  => E(4),   -- Q4
        X_10 => E(5),   -- Q5
        X_11 => E(6),   -- Q6
        X_12 => E(7),   -- Q7
        X_13 => BC(4),  -- D
        X_14 => EN,     -- E\
        X_15 => RS,     -- CL\
        X_16 => open    -- Vcc
    );
end architecture Test;
