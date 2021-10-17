-----------------------------------------------------------------------
-- Bipolar TTL models (VHDL)                                         --
-- David R Brooks                                                    --
-- June, 2016.  Perth, Australia                                     --
-- Compliance: VHDL 2008                                             --
-- Testbench for SN74LS85N: 4-bit magnitude comparator               --
-----------------------------------------------------------------------

library ieee;
    use ieee.std_logic_1164.all;
    use ieee.std_logic_misc.all;
    use ieee.numeric_std.all;
    use work.LSTTL.all;
    use work.TTLPrivate.all;
    
entity Testbench_85 is     -- Top-level bench
generic(
    StimClk  : std_logic      := '1'; 
    CheckClk : std_logic      := '1';
    Period   : time           := 100 ns;
    Finish   : time           :=  20 us;
    SevLevel : severity_level := failure
);
end entity;

architecture Test of Testbench_85 is
    signal JC, BC : unsigned(10 downto 0);        -- Test stimuli
    signal D,  E  : std_logic_vector(2 downto 0); -- Expected & actual results
    
    alias inLT is JC(10);
    alias inEQ is JC( 9);
    alias inGT is JC( 8);
    alias A    is JC(7 downto 4);
    alias B    is JC(3 downto 0);
    
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
        J    => JC, 
        B    => BC,
        CLK  => open,
        RS   => open,
        D    => D,
        E    => E
    );
    
    -----------------------------------------------------------------------
    -- Generate expected results (with zero delays)
    -----------------------------------------------------------------------
    process(JC) is
        variable LT, EQ, GT : std_logic;
        variable INCOND     : std_logic_vector(2 downto 0);
    begin
        LT := '0';
        EQ := '0';
        GT := '0';
        
        if    A < B then LT := '1';
        elsif A > B then GT := '1';
        else
            INCOND := inGT & inLT & inEQ;
            case INCOND is
                when "100"  => GT := '1';
                when "010"  => LT := '1';
                when "000"  => GT := '1'; LT := '1';
                when "110"  => null;
                when others => EQ := '1';
            end case;
        end if;
        D <= (LT, EQ, GT);
    end process;

    -----------------------------------------------------------------------
    -- Device Under Test...                        
    -----------------------------------------------------------------------
    DUT: SN74LS85N 
    port map(
    X_1  => JC(3),  -- B3
    X_2  => inLT,   -- IA<B
    X_3  => inEQ,   -- IA=B
    X_4  => inGT,   -- IA>B
    X_5  => E(0),   -- OA>B
    X_6  => E(1),   -- OA=B
    X_7  => E(2),   -- OA<B
    X_8  => open,   -- GND
    X_9  => JC(0),  -- B0
    X_10 => JC(4),  -- A0
    X_11 => JC(1),  -- B1
    X_12 => JC(5),  -- A1
    X_13 => JC(6),  -- A2
    X_14 => JC(2),  -- B2
    X_15 => JC(7),  -- A3
    X_16 => open    -- Vcc
);
end architecture Test;
