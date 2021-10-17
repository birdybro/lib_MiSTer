-----------------------------------------------------------------------
-- Bipolar TTL models (VHDL)                                         --
-- David R Brooks                                                    --
-- June, 2016.  Perth, Australia                                     --
-- Compliance: VHDL 2008                                             --
-- Testbench for SN74LS96N: 5-bit shift register                     --
-----------------------------------------------------------------------

library ieee;
    use ieee.std_logic_1164.all;
    use ieee.std_logic_misc.all;
    use ieee.numeric_std.all;
    use work.LSTTL.all;
    use work.TTLPrivate.all;
    
entity Testbench_96 is     -- Top-level bench
generic(
    StimClk  : std_logic      := '1'; 
    CheckClk : std_logic      := '1';
    Period   : time           := 120 ns;
    Finish   : time           :=  20 us;
    SevLevel : severity_level := failure
);
end entity;

architecture Test of Testbench_96 is
    signal RS, RSX : std_logic;
    signal CLK     : std_logic;
    signal JC, BC  : unsigned(7 downto 0);           -- Test stimuli
    signal D,  E   : std_logic_vector(4 downto 0);   -- Expected & actual results
    signal L       : std_logic := '0';
    signal P       : std_logic_vector(4 downto 0);
    
    alias DS is BC(0);
    
    begin
    P   <= std_logic_vector(BC(4 downto 0));
    
    process(RS, CLK) is
        variable X : unsigned(5 downto 0);
    begin
        if RS = '0' then
            RSX <= '0';
            L   <= '0';
        elsif falling_edge(CLK) then
            X := BC(5 downto 0);
            case X is
                when "000010" => RSX <= '1';
                when "001111" => RSX <= '0', '1' after 50 ns;
                when "010011" => L   <= '1', '0' after 50 ns;     -- Just a short pulse
                when others   => null;
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
    process(CLK, RSX, L) is
        variable SR : std_logic_vector(4 downto 0);
    begin
        if    RSX = '0' then
            SR := (others => '0');
        elsif L = '1' then           -- Asynchronous load
            SR := SR or P;
        elsif rising_edge(CLK) then
            SR := SR(3 downto 0) & DS;
        end if;
        D <= SR;
    end process;
    
    -----------------------------------------------------------------------
    -- Device Under Test...                        
    -----------------------------------------------------------------------
    DUT: SN74LS96N 
    port map(
    X_1  => CLK,   -- CP
    X_2  => P(0),  -- P0
    X_3  => P(1),  -- P1
    X_4  => P(2),  -- P2
    X_5  => open,  -- Vcc
    X_6  => P(3),  -- P3
    X_7  => P(4),  -- P4
    X_8  => L,     -- PL
    X_9  => DS,    -- DS
    X_10 => E(4),  -- Q4
    X_11 => E(3),  -- Q3
    X_12 => open,  -- GND
    X_13 => E(2),  -- Q2
    X_14 => E(1),  -- Q1
    X_15 => E(0),  -- Q0
    X_16 => RSX    -- CL\
    );
end architecture Test;
