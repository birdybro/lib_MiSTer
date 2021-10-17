-----------------------------------------------------------------------
-- Bipolar TTL models (VHDL)                                         --
-- David R Brooks                                                    --
-- June, 2016.  Perth, Australia                                     --
-- Compliance: VHDL 2008                                             --
-- Testbench for SN74100N: Dual 4-bit latch                          --
-----------------------------------------------------------------------

library ieee;
    use ieee.std_logic_1164.all;
    use ieee.std_logic_misc.all;
    use ieee.numeric_std.all;
    use work.LSTTL.all;
    use work.TTLPrivate.all;
    
entity Testbench_100 is     -- Top-level bench
generic(
    StimClk  : std_logic      := '1'; 
    CheckClk : std_logic      := '0';
    Period   : time           := 150 ns;
    Finish   : time           :=  20 us;
    SevLevel : severity_level := failure
);
end entity;

architecture Test of Testbench_100 is
    signal RS     : std_logic;
    signal CLK    : std_logic;
    signal JC, BC : unsigned(7 downto 0);           -- Test stimuli
    signal D,  E  : std_logic_vector(7 downto 0);   -- Expected & actual results
    
    subtype quad is std_logic_vector(4 downto 1);
    type  biquad is array(2 downto 1) of quad;
    
    signal R, Q, Z : biquad;
    signal G       : std_logic_vector(2 downto 1);
    
    begin
        E <= (Q(2), Q(1));
        D <= (Z(2), Z(1));
        R <= (quad(BC(7 downto 4)), quad(BC(3 downto 0)));
    
    process(CLK) is
        variable A, B : natural := 0;
    begin
        if rising_edge(CLK) then
            G <= (others => '0');   -- Default
            A := A + 1;
            B := B + 1;
            if (A = 5) then
                A := 0;
                G(2) <= '1';
            end if;
            if (B = 7) then
                B := 0;
                G(1) <= '1';
            end if;
        elsif falling_edge(CLK) then
            G <= (others => '0');
        end if;
    end process;
    
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
    process(all) is
    begin
        for i in G'range loop
            if G(i) = '1' then
                Z(i) <= R(i);
            end if;
        end loop;
    end process;
    
    -----------------------------------------------------------------------
    -- Device Under Test...                        
    -----------------------------------------------------------------------
    DUT: SN74100N 
    port map(
                     --
    X_2  => R(1)(1), -- 1D1
    X_3  => R(1)(2), -- 1D2
    X_4  => Q(1)(2), -- 1Q2
    X_5  => Q(1)(1), -- 1Q1
                     --
    X_7  => open,    -- GND
    X_8  => Q(2)(1), -- 2Q1
    X_9  => Q(2)(2), -- 2Q2
    X_10 => R(2)(2), -- 2D2
    X_11 => R(2)(1), -- 2D1
    X_12 => G(2),    -- 2G
                     -- 
                     -- 
    X_15 => R(2)(3), -- 2D3
    X_16 => R(2)(4), -- 2D4
    X_17 => Q(2)(4), -- 2Q4
    X_18 => Q(2)(3), -- 2Q3
    X_19 => Q(1)(3), -- 1Q3
    X_20 => Q(1)(4), -- 1Q4
    X_21 => R(1)(4), -- 1D4
    X_22 => R(1)(3), -- 1D3
    X_23 => G(1),    -- 1G
    X_24 => open     -- Vcc
    );
end architecture Test;
