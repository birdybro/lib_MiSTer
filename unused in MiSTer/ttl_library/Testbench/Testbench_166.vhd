-----------------------------------------------------------------------
-- Bipolar TTL models (VHDL)                                         --
-- David R Brooks                                                    --
-- June, 2016.  Perth, Australia                                     --
-- Compliance: VHDL 2008                                             --
-- Testbench for SN74LS166N: 8-bit PISO shift register               --
-----------------------------------------------------------------------

library ieee;
    use ieee.std_logic_1164.all;
    use ieee.std_logic_misc.all;
    use ieee.numeric_std.all;
    use work.LSTTL.all;
    use work.TTLPrivate.all;
    
entity Testbench_166 is     -- Top-level bench
generic(
    StimClk  : std_logic      := '1'; 
    CheckClk : std_logic      := '1';
    Period   : time           := 100 ns;
    Finish   : time           :=  20 us;
    SevLevel : severity_level := failure
);
end entity;

architecture Test of Testbench_166 is
    signal CLK, ICLK  : std_logic;
    signal JC, BC     : unsigned(9 downto 0);           -- Test stimuli
    signal D,  E      : std_logic_vector(0 downto 0);   -- Expected & actual results
    signal PL, RS     : std_logic;
    signal CP1, CP2   : std_logic;
    signal P1         : std_logic_vector(7 downto 0) := (others => '0');
    signal SR         : std_logic_vector(7 downto 0);
    
    alias DS : std_logic is BC(1);
    
    begin
    P1   <= std_logic_vector(BC(9 downto 2));
    ICLK <= CP1 or CP2;
    D(0) <= SR(7);
    
    process(CLK, RS) is
        variable X : unsigned(5 downto 0);
    begin
        if    RS = '0' then
            CP1 <= '0';
            CP2 <= '0';
            PL  <= '0';
        elsif rising_edge(CLK) then
            CP1 <= BC(0);
            CP2 <= not BC(0);
            X := BC(X'range);
            case X is
                when "000000" => PL <= '0';
                when others   => PL <= '1';
            end case;
        elsif falling_edge(CLK) then
            CP1 <= '0';
            CP2 <= '0';
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
    process(ICLK, RS) is
    begin
        if RS = '0' then           -- Asynchronous reset
            SR <= (others => '0');
        elsif rising_edge(ICLK) then
            if PL = '0' then
                SR <= P1;
            else
                SR <= SR(6 downto 0) & DS;
            end if;
        end if;
    end process;
    
    -----------------------------------------------------------------------
    -- Device Under Test...                        
    -----------------------------------------------------------------------
    DUT: SN74LS166N 
    port map(
    X_1  => DS,     -- DS
    X_2  => P1(0),  -- P0
    X_3  => P1(1),  -- P1
    X_4  => P1(2),  -- P2
    X_5  => P1(3),  -- P3
    X_6  => CP2,    -- CP2
    X_7  => CP1,    -- CP1
    X_8  => open,   -- GND
    X_9  => RS,     -- MR\
    X_10 => P1(4),  -- P4
    X_11 => P1(5),  -- P5
    X_12 => P1(6),  -- P6
    X_13 => E(0),   -- Q7
    X_14 => P1(7),  -- P7
    X_15 => PL,     -- PE\
    X_16 => open    -- Vcc
    );
end architecture Test;
