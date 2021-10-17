-----------------------------------------------------------------------
-- Bipolar TTL models (VHDL)                                         --
-- David R Brooks                                                    --
-- July, 2016.  Perth, Australia                                     --
-- Compliance: VHDL 2008                                             --
-- Testbench for SN74H183N: Dual high-speed adder                    --
-----------------------------------------------------------------------

library ieee;
    use ieee.std_logic_1164.all;
    use ieee.std_logic_misc.all;
    use ieee.numeric_std.all;
    use work.LSTTL.all;
    use work.TTLPrivate.all;
    
entity Testbench_183 is     -- Top-level bench
generic(
    StimClk  : std_logic      := '1'; 
    CheckClk : std_logic      := '1';
    Period   : time           := 25 ns;
    Finish   : time           :=  2 us;
    SevLevel : severity_level := failure
);
end entity;

architecture Test of Testbench_183 is
    subtype Pair   is std_logic_vector(1 downto 0);
    subtype Triple is std_logic_vector(2 downto 0);
    type    Table  is array(0 to 7) of Pair;
    
    signal JC, BC : unsigned(5 downto 0);           -- Test stimuli
    signal D, E   : std_logic_vector(3 downto 0);   -- Expected & actual results
    
    signal X, Y   : Pair;

    alias CIa is BC(0);
    alias Aa  is BC(1);
    alias Ba  is BC(2);
    alias CIb is BC(3);
    alias Ab  is BC(4);
    alias Bb  is BC(5);
    
    constant SUM   : natural := 1;
    constant CARRY : natural := 0;
    
    impure function Adder(A, B, C : std_logic) return Pair is   -- impure, as it calls "now"
        constant ANS : Table := (("00"), ("10"), ("10"), ("01"), ("10"), ("01"), ("01"), ("11"));
        variable Z   : unsigned(2 downto 0) := (others => '0');
        variable R   : natural range 7 downto 0 := 0;
    begin
        if now > 5 ns then      -- Avoid metavalues at T=0
            Z := A & B & C;
            R := to_integer(Z);
        end if;
        return ANS(R);
    end function;
    
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
    X <= Adder(Aa, Ba, CIa);
    Y <= Adder(Ab, Bb, CIb);
    D <= (Y(SUM), Y(CARRY), X(SUM), X(CARRY));
    
    -----------------------------------------------------------------------
    -- Device Under Test...                        
    -----------------------------------------------------------------------
    DUT: SN74H183N 
    port map(
        X_1  => Aa,    -- Aa
        X_3  => Ba,    -- Ba
        X_4  => CIa,   -- CIa
        X_5  => E(0),  -- COa
        X_6  => E(1),  -- Sa
        X_7  => open,  -- GND
        X_8  => E(3),  -- Sb
        X_10 => E(2),  -- COb
        X_11 => CIb,   -- CIb
        X_12 => Bb,    -- Bb
        X_13 => Ab,    -- Ab
        X_14 => open   -- Vcc
    );
end architecture Test;
