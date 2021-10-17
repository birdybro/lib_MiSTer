-----------------------------------------------------------------------
-- Bipolar TTL models (VHDL)                                         --
-- David R Brooks                                                    --
-- December, 2016.  Perth, Australia                                 --
-- Compliance: VHDL 2008                                             --
-- Testbench for SN74256N: Dual 4-bit addressable latch              --
-----------------------------------------------------------------------

library ieee;
    use ieee.std_logic_1164.all;
    use ieee.std_logic_misc.all;
    use ieee.numeric_std.all;
    use work.LSTTL.all;
    use work.TTLPrivate.all;
    
entity Testbench_256 is     -- Top-level bench
generic(
    StimClk  : std_logic      := '1'; 
    CheckClk : std_logic      := '0';
    Period   : time           := 150 ns;
    Finish   : time           :=  20 us;
    SevLevel : severity_level := failure
);
end entity;

architecture Test of Testbench_256 is
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
        N := to_integer(unsigned(BC(2 downto 1)));
        if RS = '0' then
            D <= (others => '0');
        elsif EN = '0' then
            D(N)   <= BC(3);
            D(4+N) <= BC(4);
        end if;    
    end process;
    
    -----------------------------------------------------------------------
    -- Device Under Test...                        
    -----------------------------------------------------------------------
    DUT: SN74LS256N 
    port map(
        X_1  => BC(1),  -- A0
        X_2  => BC(2),  -- A1
        X_3  => BC(3),  -- DA
        X_4  => E(0),   -- O0A
        X_5  => E(1),   -- O1A
        X_6  => E(2),   -- O2A
        X_7  => E(3),   -- O3A
        X_8  => open,   -- GND
        X_9  => E(4),   -- O0B
        X_10 => E(5),   -- O1B
        X_11 => E(6),   -- O2B
        X_12 => E(7),   -- O3B
        X_13 => BC(4),  -- DB
        X_14 => EN,     -- E\
        X_15 => RS,     -- CL\
        X_16 => open    -- Vcc
    );
end architecture Test;
