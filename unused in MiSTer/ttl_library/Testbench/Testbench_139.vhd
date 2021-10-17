-----------------------------------------------------------------------
-- Bipolar TTL models (VHDL)                                         --
-- David R Brooks                                                    --
-- June, 2016.  Perth, Australia                                     --
-- Compliance: VHDL 2008                                             --
-- Testbench for SN74LS139N: Dual 1-of-4 decoder                     --
-----------------------------------------------------------------------

library ieee;
    use ieee.std_logic_1164.all;
    use ieee.std_logic_misc.all;
    use ieee.numeric_std.all;
    use work.LSTTL.all;
    use work.TTLPrivate.all;
    
entity Testbench_139 is     -- Top-level bench
generic(
    StimClk  : std_logic      := '1'; 
    CheckClk : std_logic      := '0';
    Period   : time           := 100 ns;
    Finish   : time           :=  20 us;
    SevLevel : severity_level := failure
);
end entity;

architecture Test of Testbench_139 is
    signal J, B, Z : unsigned(5 downto 0);         -- Test stimuli
    signal D, E    : std_logic_vector(7 downto 0); -- Expected & actual results
    signal RS      : std_logic;
    
    begin
    Z <= (not B) when RS = '1' else (others => '1');     -- Should start with enables high
    
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
        J   => J,
        B   => B,
        CLK => open,
        RS  => RS,
        D   => D,
        E   => E
    );
    
    -----------------------------------------------------------------------
    -- Generate expected results (with zero delays)
    -----------------------------------------------------------------------
    
    process(Z) is
        variable N : natural range 3 downto 0;
    begin
        D <= (others => '1');
        
        if Z(0) = '0' then      -- EA
            N := TTL_to_integer(Z(5 downto 4));
            D(N) <= '0';
        end if; 
        
        if Z(1) = '0' then      -- EB
            N := TTL_to_integer(Z(3 downto 2));
            D(4+N) <= '0';
        end if;
    end process;

    -----------------------------------------------------------------------
    -- Device Under Test...                        
    -----------------------------------------------------------------------
    DUT: SN74LS139N 
    port map(
    X_1  => Z(0),  -- EA\
    X_2  => Z(4),  -- A0A
    X_3  => Z(5),  -- A1A
    X_4  => E(0),  -- O0A\
    X_5  => E(1),  -- O1A\
    X_6  => E(2),  -- O2A\
    X_7  => E(3),  -- O3A\
    X_8  => open,  -- GND
    X_9  => E(7),  -- O3B\
    X_10 => E(6),  -- O2B\
    X_11 => E(5),  -- O1B\
    X_12 => E(4),  -- O0B\
    X_13 => Z(3),  -- A1B
    X_14 => Z(2),  -- A0B
    X_15 => Z(1),  -- EB\
    X_16 => open   -- Vcc
);
end architecture Test;
