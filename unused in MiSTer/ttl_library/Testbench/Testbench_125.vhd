-----------------------------------------------------------------------
-- Bipolar TTL models (VHDL)                                         --
-- David R Brooks                                                    --
-- June, 2016.  Perth, Australia                                     --
-- Compliance: VHDL 2008                                             --
-- Testbench for SN74LS125N: Quad bus buffer (3-state outputs)       --
-----------------------------------------------------------------------

library ieee;
    use ieee.std_logic_1164.all;
    use ieee.std_logic_misc.all;
    use ieee.numeric_std.all;
    use work.LSTTL.all;
    use work.TTLPrivate.all;
    
entity Testbench_125 is     -- Top-level bench
generic(
    StimClk  : std_logic      := '1'; 
    CheckClk : std_logic      := '0';
    Period   : time           := 150 ns;
    Finish   : time           :=  20 us;
    SevLevel : severity_level := failure
);
end entity;

architecture Test of Testbench_125 is
    signal RS     : std_logic;
    signal CLK    : std_logic;
    signal JC, BC : unsigned(7 downto 0);           -- Test stimuli
    signal D,  E  : std_logic_vector(3 downto 0);   -- Expected & actual results
    
    subtype quad is std_logic_vector(3 downto 0);
    signal  I, G : quad;
    
begin    
    I <= quad(BC(7 downto 4));
    G <= quad(BC(3 downto 0));
    
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
    
    GG: for j in G'range generate
    begin
        D(j) <= I(j) when G(j) = '0' else 'Z';
    end generate;
    
    -----------------------------------------------------------------------
    -- Device Under Test...                        
    -----------------------------------------------------------------------
    DUT: SN74LS125N 
    port map(
    X_1  => G(0),  -- E1\
    X_2  => I(0),  -- D1
    X_3  => E(0),  -- Q1
    X_4  => G(1),  -- E2\
    X_5  => I(1),  -- D2
    X_6  => E(1),  -- Q2
    X_7  => open,  -- GND
    X_8  => E(2),  -- Q3
    X_9  => I(2),  -- D3
    X_10 => G(2),  -- E3\
    X_11 => E(3),  -- Q4
    X_12 => I(3),  -- D4
    X_13 => G(3),  -- E4\
    X_14 => open   -- Vcc
    );
end architecture Test;
