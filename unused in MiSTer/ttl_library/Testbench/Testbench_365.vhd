-----------------------------------------------------------------------
-- Bipolar TTL models (VHDL)                                         --
-- David R Brooks                                                    --
-- December, 2016.  Perth, Australia                                 --
-- Compliance: VHDL 2008                                             --
-- Testbench for SN74LS365N: Hex 3-state buffer                      --
-----------------------------------------------------------------------

library ieee;
    use ieee.std_logic_1164.all;
    use ieee.std_logic_misc.all;
    use ieee.numeric_std.all;
    use work.LSTTL.all;
    use work.TTLPrivate.all;
    
entity Testbench_365 is     -- Top-level bench
generic(
    StimClk  : std_logic      := '1'; 
    CheckClk : std_logic      := '1';
    Period   : time           :=  50 ns;
    Finish   : time           := 200 us;
    SevLevel : severity_level := failure
);
end entity;

architecture Test of Testbench_365 is
    signal J, B : unsigned(5 downto 0);         -- Test stimuli
    signal D, E : std_logic_vector(5 downto 0); -- Expected & actual results
    signal EN   : std_logic;
    
    begin
        EN <= not(J(1) or J(0));
    
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
        J   => J,
        B   => B,
        CLK => open,
        RS  => open,
        D   => D,
        E   => E
    );
    
    -----------------------------------------------------------------------
    -- Generate expected results (with zero delays)
    -----------------------------------------------------------------------
    D <= std_logic_vector(B) when EN = '1' else (others => 'Z');
    
    -----------------------------------------------------------------------
    -- Device Under Test...                        
    -----------------------------------------------------------------------
    DUT: SN74LS365AN 
    port map(
        X_1  => J(0),  -- E1\
        X_2  => B(0),  -- A1
        X_3  => E(0),  -- Y1
        X_4  => B(1),  -- A2
        X_5  => E(1),  -- Y2
        X_6  => B(2),  -- A3
        X_7  => E(2),  -- Y3
        X_8  => open,  -- GND
        X_9  => E(3),  -- Y4
        X_10 => B(3),  -- A4
        X_11 => E(4),  -- Y5
        X_12 => B(4),  -- A5
        X_13 => E(5),  -- Y6
        X_14 => B(5),  -- A6
        X_15 => J(1),  -- E2\
        X_16 => open   -- Vcc
);
end architecture Test;
