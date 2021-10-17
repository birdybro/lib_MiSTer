-----------------------------------------------------------------------
-- Bipolar TTL models (VHDL)                                         --
-- David R Brooks                                                    --
-- June, 2016.  Perth, Australia                                     --
-- Compliance: VHDL 2008                                             --
-- Testbench for SN74LS160N: Synchronous presettable BCD decade ctr  --
-----------------------------------------------------------------------

library ieee;
    use ieee.std_logic_1164.all;
    use ieee.std_logic_misc.all;
    use ieee.numeric_std.all;
    use work.LSTTL.all;
    use work.TTLPrivate.all;
    
entity Testbench_160 is     -- Top-level bench
generic(
    StimClk  : std_logic      := '1'; 
    CheckClk : std_logic      := '1';
    Period   : time           :=  30 ns;
    Finish   : time           :=  20 us;
    SevLevel : severity_level := failure
);
end entity;

architecture Test of Testbench_160 is
    signal RS, NRS : std_logic;
    signal CLK, R  : std_logic;
    signal J,  B   : unsigned(6 downto 0);          -- Test stimuli
    signal D,  E   : std_logic_vector(4 downto 0);  -- Expected & actual results
    signal PE      : std_logic := '1';
    signal CEP     : std_logic := '1';
    signal CET     : std_logic := '1';

    alias  P       : unsigned(3 downto 0) is B(3 downto 0);
    alias  CP      : std_logic is CLK;
    
    constant modulus  : natural := 10;
    constant asyncrst : boolean := true;
    constant limit    : unsigned(3 downto 0) := to_unsigned(modulus-1, 4);

    begin
    RS  <= NRS and R;
    CEP <= J(0);
    CET <= J(1);
    
    process(CLK) is     -- Generate control signals
        variable T2, T3 : natural := 0;
    begin
        if rising_edge(CLK) then
            if T2 = 37 then
                PE <= '0';
                T2 := 0;
            else 
                PE <= '1';
                T2 := T2 + 1;
            end if;
            
            if T3 = 41 then
                R  <= '0';
                T3 := 0;
            else 
                R  <= '1';
                T3 := T3 + 1;
            end if;
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
    
    process(CP, RS) is
        variable N : unsigned(3 downto 0);
    begin
        if asyncrst and (RS = '0') then
            N := (others => '0');
        elsif rising_edge(CP) then
            if RS = '0' then
                N := (others => '0');
            elsif PE = '0' then
                N := unsigned(P);
            elsif (CEP and CET) = '1' then
                if modulus = 16 then     -- Simple binary count
                    N := N + 1;
                else                     -- Decade count, cover illegal cases
                    case N is
                        when "1001"          => N := "0000";
                        when "1011" | "1101" => N := "0100";
                        when "1111"          => N := "1000";
                        when others          => N := N + 1;
                    end case;
                end if;
            end if;
        end if;
        
        D(3 downto 0) <= std_logic_vector(N);        -- Export results
        if now > 1 ns and N = limit then
            D(4) <= CET;
        else
            D(4) <= '0';
        end if;
    end process;
                
    -----------------------------------------------------------------------
    -- Device Under Test...                        
    -----------------------------------------------------------------------
    DUT: SN74LS160N 
    port map(
    X_1  => RS,    -- R\
    X_2  => CP,    -- CP
    X_3  => B(0),  -- P0
    X_4  => B(1),  -- P1
    X_5  => B(2),  -- P2
    X_6  => B(3),  -- P3
    X_7  => CEP,   -- CEP
    X_8  => open,  -- GND
    X_9  => PE,    -- PE\
    X_10 => CET,   -- CET
    X_11 => E(3),  -- Q3
    X_12 => E(2),  -- Q2
    X_13 => E(1),  -- Q1
    X_14 => E(0),  -- Q0
    X_15 => E(4),  -- TC
    X_16 => open   -- Vcc
);   
    
end architecture Test;
