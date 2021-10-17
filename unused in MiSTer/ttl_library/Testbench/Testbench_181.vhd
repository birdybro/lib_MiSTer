-----------------------------------------------------------------------
-- Bipolar TTL models (VHDL)                                         --
-- David R Brooks                                                    --
-- July, 2016.  Perth, Australia                                     --
-- Compliance: VHDL 2008                                             --
-- Testbench for SN74LS181N: 4-bit arithmetic/logic unit             --
-----------------------------------------------------------------------

library ieee;
    use ieee.std_logic_1164.all;
    use ieee.std_logic_misc.all;
    use ieee.numeric_std.all;
    use work.LSTTL.all;
    use work.TTLPrivate.all;
    
entity Testbench_181 is     -- Top-level bench
generic(
    StimClk  : std_logic      := '1'; 
    CheckClk : std_logic      := '1';
    Period   : time           :=  100 ns;
    Finish   : time           := 1600 us;
    SevLevel : severity_level := failure
);
end entity;

architecture Test of Testbench_181 is
    signal JC, BC : unsigned(13 downto 0);          -- Test stimuli
    signal D,  E  : std_logic_vector(7 downto 0);   -- Expected & actual results
    
    signal A,  B,  F, S : unsigned(3 downto 0);
    signal CI, M        : std_logic;
    signal CO, EQ, P, G : std_logic;
    
    constant M1 : unsigned(3 downto 0) := (others => '1');
    
    begin
    S  <= BC( 3 downto 0);
    A  <= BC( 7 downto 4);
    B  <= BC(11 downto 8);
    CI <= BC(12);
    M  <= BC(13);
    
    D  <= CO & EQ & P & G & std_logic_vector(F);
    
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
    process(all) is
        variable  BB, XX, YY, ZZ, FF, LL : unsigned(3 downto 0);
        variable  MB : std_logic;        
        variable L01 : std_logic;
        variable L02 : std_logic;
        variable L03 : std_logic;
        variable L04 : std_logic;
        variable L05 : std_logic;
        variable L06 : std_logic;
        variable L07 : std_logic;
        variable L08 : std_logic;
        variable L09 : std_logic;
        variable L10 : std_logic;
        variable L11 : std_logic;
        variable L12 : std_logic;
        variable L13 : std_logic;
        variable L14 : std_logic;
        variable L15 : std_logic;
        
    begin
        MB    := not ( M );
        BB    := not B;
        
        for i in A'range loop
            YY(i) := not ( ( B(i) and S(3) and A(i) ) or ( A(i) and S(2) and BB(i) ) );
            XX(i) := not ( ( BB(i) and S(1) ) or ( S(0) and B(i) ) or A(i) );
        end loop;
        
        ZZ    :=  XX xor YY;
        L15   := ( XX(3) );
        L11   := ( YY(3) and XX(2) );
        L12   := ( YY(3) and YY(2) and XX(1) );
        L13   := ( YY(3) and YY(2) and YY(1) and XX(0) );
        L01   := not ( YY(3) and YY(2) and YY(1) and YY(0) and CI );
        L02   := ( CI and YY(0) and YY(1) and YY(2) and MB );
        L03   := ( YY(1) and YY(2) and XX(0) and MB );
        L04   := ( YY(2) and XX(1) and MB );
        L05   := ( XX(2) and MB );
        L06   := ( CI and YY(0) and YY(1) and MB );
        L07   := ( YY(1) and XX(0) and MB );
        L08   := ( XX(1) and MB );
        L09   := ( CI and YY(0) and MB );
        L10   := ( XX(0) and MB );
        LL(0) := not ( CI and MB );
        LL(3) := not ( L02 or L03 or L04 or L05 );
        LL(2) := not ( L06 or L07 or L08 );
        LL(1) := not ( L09 or L10 );
        L14   := not ( L15 or L11 or L12 or L13 );
        FF    := LL xor ZZ;
        G     <= L14;
        CO    <= not ( L14 and L01 );
        P     <= nand_reduce(std_logic_vector(YY));
        EQ    <= and_reduce(std_logic_vector(FF));
        F     <= FF;
    end process;

    -----------------------------------------------------------------------
    -- Device Under Test...                        
    -----------------------------------------------------------------------
    DUT: SN74LS181N 
    port map(
        X_1  => B(0), -- B(0)\
        X_2  => A(0), -- A(0)\
        X_3  => S(3), -- S(3)
        X_4  => S(2), -- S(2)
        X_5  => S(1), -- S(1)
        X_6  => S(0), -- S(0)
        X_7  => CI,   -- Cn
        X_8  => M,    -- M
        X_9  => E(0), -- F(0)\
        X_10 => E(1), -- F(1)\
        X_11 => E(2), -- F(2)\
        X_12 => open, -- GND
        X_13 => E(3), -- F(3)\
        X_14 => E(6), -- A=B
        X_15 => E(5), -- P\
        X_16 => E(7), -- Cn+4
        X_17 => E(4), -- G\
        X_18 => B(3), -- B(3)\
        X_19 => A(3), -- A(3)\
        X_20 => B(2), -- B(2)\
        X_21 => A(2), -- A(2)\
        X_22 => B(1), -- B(1)\
        X_23 => A(1), -- A(1)\
        X_24 => open  -- Vcc
    );
end architecture Test;
