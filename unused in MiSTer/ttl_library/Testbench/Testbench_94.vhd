-----------------------------------------------------------------------
-- Bipolar TTL models (VHDL)                                         --
-- David R Brooks                                                    --
-- June, 2016.  Perth, Australia                                     --
-- Compliance: VHDL 2008                                             --
-- Testbench for SN74LS94N: 4-bit shift register                     --
-----------------------------------------------------------------------

library ieee;
    use ieee.std_logic_1164.all;
    use ieee.std_logic_misc.all;
    use ieee.numeric_std.all;
    use work.LSTTL.all;
    use work.TTLPrivate.all;
    
entity Testbench_94 is     -- Top-level bench
generic(
    StimClk  : std_logic      := '1'; 
    CheckClk : std_logic      := '1';
    Period   : time           := 100 ns;
    Finish   : time           :=  20 us;
    SevLevel : severity_level := failure
);
end entity;

architecture Test of Testbench_94 is
    signal RS, RSH    : std_logic;
    signal CLK        : std_logic;
    signal JC, BC     : unsigned(7 downto 0);           -- Test stimuli
    signal D,  E      : std_logic_vector(0 downto 0);   -- Expected & actual results
    signal L1, L2     : std_logic;
    signal P1, P2, LR : std_logic_vector(3 downto 0);
    
    alias DS is BC(0);
    
    begin
    RSH <= not RS;
    P1  <= std_logic_vector(BC(3 downto 0));
    P2  <= std_logic_vector(BC(7 downto 4));
    
    process(RS, CLK) is
        variable X : unsigned(5 downto 0);
    begin
        if RSH = '1' then
            L1 <= '0';
            L2 <= '0';
        elsif falling_edge(CLK) then    -- Inactive clock edge
            X := BC(5 downto 0);
            case X is
                when "010101" => L1 <= '1';
                when "101010" => L2 <= '1';
                when others   => L1 <= '0'; L2 <= '0';
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
    process(CLK, RS, L1, L2) is
        variable SR : std_logic_vector(3 downto 0);
    begin
        if    RS = '0' then
            SR := (others => '0');
        elsif (L1 or L2) = '1' then           -- Asynchronous load
            for i in SR'range loop
                SR(i) := SR(i) or (L1 and P1(i)) or (L2 and P2(i));
            end loop;
        elsif rising_edge(CLK) then
            SR := SR(2 downto 0) & DS;
        end if;
            D(0) <= SR(3);
            LR   <= SR;                 -- Visibility
    end process;
    
    -----------------------------------------------------------------------
    -- Device Under Test...                        
    -----------------------------------------------------------------------
    DUT: SN74LS94N 
    port map(
    X_1  => P1(0),  -- P1A
    X_2  => P1(1),  -- P1B
    X_3  => P1(2),  -- P1C
    X_4  => P1(3),  -- P1D
    X_5  => open,   -- Vcc
    X_6  => L1,     -- PL1
    X_7  => DS,     -- DS
    X_8  => CLK,    -- CP
    X_9  => E(0),   -- QD
    X_10 => RSH,    -- CL
    X_11 => P2(3),  -- P2D
    X_12 => open,   -- GND
    X_13 => P2(2),  -- P2C
    X_14 => P2(1),  -- P2B
    X_15 => L2,     -- PL2
    X_16 => P2(0)   -- P2A
    );
end architecture Test;
