-----------------------------------------------------------------------
-- Bipolar TTL models (VHDL)                                         --
-- David R Brooks                                                    --
-- July, 2016.  Perth, Australia                                     --
-- Compliance: VHDL 2008                                             --
-- Testbench for SN74LS182N: Fast carry unit for 4 x LS181           --
-----------------------------------------------------------------------

library ieee;
    use ieee.std_logic_1164.all;
    use ieee.std_logic_misc.all;
    use ieee.numeric_std.all;
    use work.LSTTL.all;
    use work.TTLPrivate.all;
    
entity Testbench_182 is     -- Top-level bench
generic(
    StimClk  : std_logic      := '1'; 
    CheckClk : std_logic      := '1';
    Period   : time           := 50 ns;
    Finish   : time           := 30 us;
    SevLevel : severity_level := failure
);
end entity;

architecture Test of Testbench_182 is
    signal JC, BC : unsigned(8 downto 0);           -- Test stimuli
    signal D, E   : std_logic_vector(4 downto 0);   -- Expected & actual results
    
    alias Cn is JC(0);
    alias G0 is JC(1);
    alias G1 is JC(2);
    alias G2 is JC(3);
    alias G3 is JC(4);
    alias P0 is JC(5);
    alias P1 is JC(6);
    alias P2 is JC(7);
    alias P3 is JC(8);
    
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
    process(all) is
        variable L1  : std_logic;
        variable L2  : std_logic;
        variable L3  : std_logic;
        variable L4  : std_logic;
        variable L5  : std_logic;
        variable L6  : std_logic;
        variable L7  : std_logic;
        variable L8  : std_logic;
        variable L9  : std_logic;
        variable L10 : std_logic;
        variable L11 : std_logic;
        variable L12 : std_logic;
        variable L13 : std_logic;
        variable N1  : std_logic;
    begin
        N1   := NOT ( CN );
        L1   := ( G3 AND G2 AND G1 AND G0 );
        L2   := ( P1 AND G3 AND G2 AND G1 );
        L3   := ( P2 AND G3 AND G2 );
        L4   := ( P3 AND G3 );
        L5   := ( G2 AND G1 AND G0 AND N1 );
        L6   := ( P0 AND G2 AND G1 AND G0 );
        L7   := ( P1 AND G2 AND G1 );
        L8   := ( P2 AND G2 );
        L9   := ( G1 AND G0 AND N1 );
        L10  := ( P0 AND G1 AND G0 );
        L11  := ( P1 AND G1 );
        L12  := ( G0 AND N1 );
        L13  := ( P0 AND G0 );
        D(4) <= ( P3 OR P2 OR P1 OR P0 );
        D(3) <= ( L1 OR L2 OR L3 OR L4 );
        D(2) <= NOT ( L5 OR L6 OR L7 OR L8 );
        D(1) <= NOT ( L9 OR L10 OR L11 );
        D(0) <= NOT ( L12 OR L13 );
    end process;
    
    -----------------------------------------------------------------------
    -- Device Under Test...                        
    -----------------------------------------------------------------------
    DUT: SN74LS182N 
    port map(
        X_1  => G1,   -- G1
        X_2  => P1,   -- P1
        X_3  => G0,   -- G0
        X_4  => P0,   -- P0
        X_5  => G3,   -- G3
        X_6  => P3,   -- P3
        X_7  => E(4), -- P
        X_8  => open, -- GND
        X_9  => E(2), -- Cnz
        X_10 => E(3), -- G
        X_11 => E(1), -- Cny
        X_12 => E(0), -- Cnx
        X_13 => Cn,   -- Cn
        X_14 => G2,   -- G2
        X_15 => P2,   -- P2
        X_16 => open  -- Vcc
    );
end architecture Test;
