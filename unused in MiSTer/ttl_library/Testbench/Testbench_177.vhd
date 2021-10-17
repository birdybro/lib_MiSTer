-----------------------------------------------------------------------
-- Bipolar TTL models (VHDL)                                         --
-- David R Brooks                                                    --
-- June, 2016.  Perth, Australia                                     --
-- Compliance: VHDL 2008                                             --
-- Testbench for SN74177N: Presettable binary counter                --
-----------------------------------------------------------------------

library ieee;
    use ieee.std_logic_1164.all;
    use ieee.std_logic_misc.all;
    use ieee.numeric_std.all;
    use work.LSTTL.all;
    use work.TTLPrivate.all;
    
entity Testbench_177 is     -- Top-level bench
generic(
    StimClk  : std_logic      := '0'; 
    CheckClk : std_logic      := '1';
    Period   : time           := 160 ns;
    Finish   : time           :=  20 us;
    SevLevel : severity_level := failure
);
end entity;

architecture Test of Testbench_177 is
    signal RS,  PL     : std_logic;
    signal CLK, C0, C1 : std_logic;
    signal J,  B       : unsigned(3 downto 0);          -- Test stimuli
    signal D,  E,  R   : std_logic_vector(3 downto 0);  -- Expected & actual results

    begin
    C0 <= CLK;
    R  <= std_logic_vector(J);
    C1 <= D(0);    
    
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
        RS   => RS,
        D    => D,
        E    => E
    );
    
    -----------------------------------------------------------------------
    -- Generate irregular LD signal
    -----------------------------------------------------------------------
    process(RS, CLK) is
        variable N : natural;
    begin
        if RS = '0' then
            N  := 1;
            PL <= '1';
        elsif rising_edge(CLK) then
            if N >= 23 then
                N := 1;
                PL <= '0', '1' after 30 ns;
            else
                N := N + 1;
            end if;
        end if;
    end process;
    
    -----------------------------------------------------------------------
    -- Generate expected results (with zero delays)
    -----------------------------------------------------------------------
    
    process(C0, PL, RS, R) is
        variable Q0 : std_logic;
    begin
        if    RS = '0' then
            Q0 := '0';
        elsif PL = '0' then
            Q0 := R(0);
        elsif falling_edge(C0) then
            Q0 := not Q0;
        end if;
        D(0) <= Q0;
    end process;
    
    process(C1, PL, RS, R) is
        variable Q31 : unsigned(2 downto 0);
    begin
        if    RS = '0' then 
            Q31 := (others => '0');
        elsif PL = '0' then
            Q31 := unsigned(R(3 downto 1));
        elsif falling_edge(C1) then
            Q31 := Q31 + 1;
        end if;
        D(3 downto 1) <= std_logic_vector(Q31);
    end process;
                
    -----------------------------------------------------------------------
    -- Device Under Test...                        
    -----------------------------------------------------------------------
    DUT: SN74177N 
    port map(
        X_1  => PL,   -- PL\
        X_2  => E(2), -- Q2
        X_3  => R(2), -- P2
        X_4  => R(0), -- P0
        X_5  => E(0), -- Q0
        X_6  => C1,   -- CP1\
        X_7  => open, -- GND
        X_8  => C0,   -- CP0\
        X_9  => E(1), -- Q1
        X_10 => R(1), -- P1
        X_11 => R(3), -- P3
        X_12 => E(3), -- Q3
        X_13 => RS,   -- MR\
        X_14 => open  -- Vcc
    );
    
end architecture Test;
