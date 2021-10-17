-----------------------------------------------------------------------
-- Bipolar TTL models (VHDL)                                         --
-- David R Brooks                                                    --
-- June, 2016.  Perth, Australia                                     --
-- Compliance: VHDL 2008                                             --
-- Testbench for SN74178N: 4-bit shift register                      --
-- Note: 74178 is 74179 without MR\ & Q3\ pins                       --
-----------------------------------------------------------------------

library ieee;
    use ieee.std_logic_1164.all;
    use ieee.std_logic_misc.all;
    use ieee.numeric_std.all;
    use work.LSTTL.all;
    use work.TTLPrivate.all;
    
entity Testbench_178 is     -- Top-level bench
generic(
    StimClk  : std_logic      := '1'; 
    CheckClk : std_logic      := '1';
    Period   : time           := 100 ns;
    Finish   : time           :=  20 us;
    SevLevel : severity_level := failure
);
end entity;

architecture Test of Testbench_178 is
    signal RS, PE, SE : std_logic;
    signal CLK,DS     : std_logic;
    signal JC, BC     : unsigned(7 downto 0);           -- Test stimuli
    signal D,  E      : std_logic_vector(3 downto 0);   -- Expected & actual results
    signal P, REG     : std_logic_vector(3 downto 0);
    
    begin
        D(3 downto 0) <= REG;
        P             <= std_logic_vector(JC(3 downto 0));
        DS            <= JC(4);
        
    process(CLK, RS) is
        variable N : natural := 1;
    begin
        if    RS = '0' then
            N  :=  1;
            PE <= '0';
            SE <= '0';
        elsif falling_edge(CLK) then
            PE <= '0';
            SE <= '0';
            N  := N - 1;
            case N is
                when 1                 => PE <= '1';
                when 2 | 4 | 6 | 8 | 9 => SE <= '1';
                when 0                 => N  := 16;
                when others            => null;
            end case;
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
    process(CLK) is
    begin
        if falling_edge(CLK) then
            if SE    = '1' then
                REG <= REG(2 downto 0) & DS;
            elsif PE = '1' then
                REG <= P;
            end if;
        end if;
    end process;
    
    -----------------------------------------------------------------------
    -- Device Under Test...                        
    -----------------------------------------------------------------------
    DUT: SN74178N 
    port map(
        X_1  => P(1),  -- P1
        X_2  => P(0),  -- P0
        X_3  => DS,    -- DS
        X_4  => E(0),  -- Q0
        X_5  => CLK,    -- CP\
        X_6  => E(1),  -- Q1
        X_7  => open,  -- GND
        X_8  => E(2),  -- Q2
        X_9  => PE,    -- PE
        X_10 => E(3),  -- Q3
        X_11 => SE,    -- SE
        X_12 => P(3),  -- P3
        X_13 => P(2),  -- P2
        X_14 => open   -- Vcc
    );
end architecture Test;
