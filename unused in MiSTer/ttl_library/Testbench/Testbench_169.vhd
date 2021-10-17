-----------------------------------------------------------------------
-- Bipolar TTL models (VHDL)                                         --
-- David R Brooks                                                    --
-- June, 2016.  Perth, Australia                                     --
-- Compliance: VHDL 2008                                             --
-- Testbench for SN74LS169N: Synch. bidirectional 4-bit binary ctr   --
-----------------------------------------------------------------------

library ieee;
    use ieee.std_logic_1164.all;
    use ieee.std_logic_misc.all;
    use ieee.numeric_std.all;
    use work.LSTTL.all;
    use work.TTLPrivate.all;
    
entity Testbench_169 is     -- Top-level bench
generic(
    StimClk  : std_logic      := '1'; 
    CheckClk : std_logic      := '1';
    Period   : time           := 100 ns;
    Finish   : time           :=  20 us;
    SevLevel : severity_level := failure
);
end entity;

architecture Test of Testbench_169 is
    signal RS      : std_logic;
    signal CLK     : std_logic;
    signal J,  B   : unsigned(6 downto 0);          -- Test stimuli
    signal D,  E   : std_logic_vector(4 downto 0);  -- Expected & actual results
    signal PE      : std_logic := '1';
    signal CEP     : std_logic := '1';
    signal CET     : std_logic := '1';
    signal UD      : std_logic := '1';
    signal X, Y, Z : std_logic;
    signal W       : std_logic_vector(3 downto 0);

    alias  P       : unsigned(3 downto 0) is B(3 downto 0);
    alias  CP      : std_logic is CLK;
    
    constant modulus  : natural := 10;
    constant limit    : unsigned(3 downto 0) := to_unsigned(modulus-1, 4);
    constant decade   : boolean := false;

    begin
    CEP <= J(0);
    CET <= J(1);
    X <= and_reduce(W) and not CET;
    Y <= nor_reduce(W) and not CET;
    Z <= not X when UD = '1' else not Y;
    D <= Z & W;
    
    process(CP, RS) is     -- Generate control signals
        variable T2, T3 : natural := 0;
    begin
        if    RS = '0' then
            PE <= '0';
        elsif rising_edge(CP) then
            if T2 = 37 then
                PE <= '0';
                T2 := 0;
            else 
                PE <= '1';
                T2 := T2 + 1;
            end if;
            
            if T3 = 41 then
                UD <= not UD;
                T3 := 0;
            else 
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
        RS   => RS,
        D    => D,
        E    => E
    );
    
    -----------------------------------------------------------------------
    -- Generate expected results (with zero delays)
    -----------------------------------------------------------------------
    
    process(CP) is
        variable SW : std_logic_vector(3 downto 0);
        variable R  : unsigned(3 downto 0);
    begin
        if CP'event and CP = '1' then       -- Everything is synchronous
            SW := (PE, CEP, CET, UD);
            case SW is
                when "0000" | "0001" | "0010" | "0011" |
                     "0100" | "0101" | "0110" | "0111"=>              -- Load
                    R := unsigned(P);
                when "1001" =>              -- Count up
                    if decade then
                        case R is
                            when "1001" => R := "0000";
                            when "1011" => R := "0100";
                            when "1101" => R := "0100";
                            when others => R := R + 1;
                        end case;
                    else
                        R := R + 1;
                    end if;
                when "1000" =>              -- Count down
                    if decade then
                        case R is
                            when "0000" => R := "1001";
                            when "1010" => R := "0001";
                            when "1100" => R := "0011";
                            when "1110" => R := "0101";
                            when others => R := R - 1;
                        end case;
                    else
                        R := R - 1;
                    end if;
                when others =>              -- No change
                    null;
            end case;
        end if;
        W <= std_logic_vector(R);
    end process;
                
    -----------------------------------------------------------------------
    -- Device Under Test...                        
    -----------------------------------------------------------------------
    DUT: SN74LS169N 
    port map(
    X_1  => UD,    -- U_D\
    X_2  => CP,    -- CP
    X_3  => B(0),  -- P0
    X_4  => B(1),  -- P1
    X_5  => B(2),  -- P2
    X_6  => B(3),  -- P3
    X_7  => CEP,   -- CEP\
    X_8  => open,  -- GND
    X_9  => PE,    -- PE\
    X_10 => CET,   -- CET\
    X_11 => E(3),  -- Q3
    X_12 => E(2),  -- Q2
    X_13 => E(1),  -- Q1
    X_14 => E(0),  -- Q0
    X_15 => E(4),  -- TC\
    X_16 => open   -- Vcc
);   
    
end architecture Test;
