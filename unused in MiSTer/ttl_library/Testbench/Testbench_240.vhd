-----------------------------------------------------------------------
-- Bipolar TTL models (VHDL)                                         --
-- David R Brooks                                                    --
-- June, 2016.  Perth, Australia                                     --
-- Compliance: VHDL 2008                                             --
-- Testbench for SN74LS240N: Octal buffer/line driver (3-state ops)  --
-----------------------------------------------------------------------

library ieee;
    use ieee.std_logic_1164.all;
    use ieee.std_logic_misc.all;
    use ieee.numeric_std.all;
    use work.LSTTL.all;
    use work.TTLPrivate.all;
    
entity Testbench_240 is     -- Top-level bench
generic(
    StimClk  : std_logic      := '1'; 
    CheckClk : std_logic      := '1';
    Period   : time           := 50 ns;
    Finish   : time           := 20 us;
    SevLevel : severity_level := failure
);
end entity;

architecture Test of Testbench_240 is
    signal RS       : std_logic;
    signal CLK      : std_logic;
    signal JC, BC   : unsigned(9 downto 0);       -- Test stimuli
    signal D,  E    : std_logic_vector(7 downto 0);   -- Expected & actual results
    signal OEA, OEB : std_logic;
    signal IA,  IB  : std_logic_vector(3 downto 0);
begin    
    OEA <= JC(9);
    OEB <= JC(8);
    IA  <= std_logic_vector(BC(4 downto 1));
    IB  <= std_logic_vector(BC(3 downto 0));
    
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
    
    GG: for j in IA'range generate
    begin
        D(j)   <= not IA(j) when OEA = '0' else 'Z';
        D(j+4) <= not IB(j) when OEB = '0' else 'Z';
    end generate;
    
    -----------------------------------------------------------------------
    -- Device Under Test...                        
    -----------------------------------------------------------------------
    DUT: SN74LS240N 
    port map(
        X_1  => OEA,   -- OEA\
        X_2  => IA(0), -- IA0
        X_3  => E(4),  -- YB0\
        X_4  => IA(1), -- IA1
        X_5  => E(5),  -- YB1\
        X_6  => IA(2), -- IA2
        X_7  => E(6),  -- YB2\
        X_8  => IA(3), -- IA3
        X_9  => E(7),  -- YB3\
        X_10 => open,  -- GND
        X_11 => IB(3), -- IB3
        X_12 => E(3),  -- YA3\
        X_13 => IB(2), -- IB2
        X_14 => E(2),  -- YA2\
        X_15 => IB(1), -- IB1
        X_16 => E(1),  -- YA1\
        X_17 => IB(0), -- IB0
        X_18 => E(0),  -- YA0\
        X_19 => OEB,   -- OEB\
        X_20 => open   -- Vcc
    );
end architecture Test;
