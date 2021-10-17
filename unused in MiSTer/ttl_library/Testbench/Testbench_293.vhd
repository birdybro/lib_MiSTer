-----------------------------------------------------------------------
-- Bipolar TTL models (VHDL)                                         --
-- David R Brooks                                                    --
-- June, 2016.  Perth, Australia                                     --
-- Compliance: VHDL 2008                                             --
-- Testbench for SN74LS293N: 4-bit binary counter                    --
-----------------------------------------------------------------------

library ieee;
    use ieee.std_logic_1164.all;
    use ieee.std_logic_misc.all;
    use ieee.numeric_std.all;
    use work.LSTTL.all;
    use work.TTLPrivate.all;
    
entity Testbench_293 is     -- Top-level bench
generic(
    StimClk  : std_logic      := '0'; 
    CheckClk : std_logic      := '1';
    Period   : time           := 150 ns;
    Finish   : time           :=  20 us;
    SevLevel : severity_level := failure
);
end entity;

architecture Test of Testbench_293 is
    signal RS, C0, NRS : std_logic;
    signal CLK         : std_logic;
    signal J,  B       : unsigned(1 downto 0);          -- Test stimuli
    signal D,  E       : std_logic_vector(3 downto 0);  -- Expected & actual results

    begin
    RS <= not NRS;
    
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
        J    => J, 
        B    => B,
        CLK  => CLK,
        RS   => NRS,
        D    => D,
        E    => E
    );
    
    -----------------------------------------------------------------------
    -- Generate expected results (with zero delays)
    -----------------------------------------------------------------------
    
    process(B, RS) is
        variable Q0 : std_logic;
    begin
        if    RS = '1' then
            Q0 := '0';
        elsif falling_edge(B(0)) then
            Q0 := not Q0;
        end if;
        D(0) <= Q0;
    end process;
    
    process(D, RS) is
        variable Q31 : unsigned(2 downto 0);
    begin
        if    RS = '1' then 
            Q31 := (others => '0');
        elsif falling_edge(D(0)) then
            Q31 := Q31 + 1;
        end if;
        D(3 downto 1) <= std_logic_vector(Q31);
    end process;
                
    -----------------------------------------------------------------------
    -- Device Under Test...                        
    -----------------------------------------------------------------------
    DUT: SN74LS293N 
    port map(
                   --
                   -- 
                   --
    X_4  => E(2),  -- Q2
    X_5  => E(1),  -- Q1
                   -- 
    X_7  => open,  -- GND
    X_8  => E(3),  -- Q3
    X_9  => C0,    -- Q0
    X_10 => B(0),  -- CP0\
    X_11 => C0,    -- CP1\
    X_12 => RS,    -- MR1
    X_13 => RS,    -- MR2
    X_14 => open   -- Vcc
);
    E(0) <= C0;
    
end architecture Test;
