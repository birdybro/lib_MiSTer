-----------------------------------------------------------------------
-- Bipolar TTL models (VHDL)                                         --
-- David R Brooks                                                    --
-- June, 2016.  Perth, Australia                                     --
-- Compliance: VHDL 2008                                             --
-- Testbench for SN74LS69N: Dual 4-bit binary counter                --
-----------------------------------------------------------------------

library ieee;
    use ieee.std_logic_1164.all;
    use ieee.std_logic_misc.all;
    use ieee.numeric_std.all;
    use work.LSTTL.all;
    use work.TTLPrivate.all;
    
entity Testbench_69 is     -- Top-level bench
generic(
    StimClk  : std_logic      :=  '0'; 
    CheckClk : std_logic      :=  '0';
    Period   : time           := 120 ns;
    Finish   : time           :=  20 us;
    SevLevel : severity_level := failure
);
end entity;

architecture Test of Testbench_69 is
    signal RS, C0 : std_logic;
    signal CLK    : std_logic;
    signal J,  B  : unsigned(1 downto 0);           -- Test stimuli
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
        J   => J,
        B   => B,
        CLK => CLK,
        RS  => RS,
        D   => D,
        E   => E
    );
    
    -----------------------------------------------------------------------
    -- Generate expected results (with zero delays)
    -----------------------------------------------------------------------
    
    -- Low bits: the 2+8 counter
    process(B, RS) is
        variable Q0 : std_logic;
    begin
        if    RS = '0' then
            Q0 := '0';
        elsif falling_edge(B(0)) then
            Q0 := not Q0;
        end if;
        D(0) <= Q0;
    end process;
    
    process(D, RS) is
        variable Q31 : unsigned(2 downto 0);
    begin
        if    RS = '0' then 
            Q31 := (others => '0');
        elsif falling_edge(D(0)) then
            Q31 := Q31 + 1;
        end if;
        D(3 downto 1) <= std_logic_vector(Q31);
    end process;
                
    -- High bits: straight binary counter
    process(B, RS) is
        variable Q30 : unsigned(3 downto 0);
    begin
        if    RS = '0' then
            Q30 := (others => '0');
        elsif falling_edge(B(1)) then
            Q30 := Q30 + 1;
        end if;
        D(7 downto 4) <= std_logic_vector(Q30);
    end process;
    
    -----------------------------------------------------------------------
    -- Device Under Test...                        
    -----------------------------------------------------------------------
    DUT: SN74LS69N 
    port map(
    X_1  => B(0),  -- 1CLKA
    X_2  => E(1),  -- 1QB
    X_3  => E(3),  -- 1QD
    X_4  => RS,    -- \1CLR
    X_5  => E(6),  -- 2QC
                   -- 
    X_7  => E(4),  -- 2QA
    X_8  => open,  -- GND
    X_9  => B(1),  -- 2CLK
    X_10 => E(5),  -- 2QB
    X_11 => RS,    -- \2CLR
    X_12 => E(7),  -- 2QD
    X_13 => E(2),  -- 1QC
    X_14 => C0,    -- 1QA
    X_15 => C0,    -- 1CLKB
    X_16 => open   -- Vcc
);
    E(0) <= C0;
    
end architecture Test;
