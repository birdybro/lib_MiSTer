-----------------------------------------------------------------------
-- Bipolar TTL models (VHDL)                                         --
-- David R Brooks                                                    --
-- June, 2016.  Perth, Australia                                     --
-- Compliance: VHDL 2008                                             --
-- Testbench for SN7482N: 2-bit full adder                           --
-----------------------------------------------------------------------

library ieee;
    use ieee.std_logic_1164.all;
    use ieee.std_logic_misc.all;
    use ieee.numeric_std.all;
    use work.LSTTL.all;
    use work.TTLPrivate.all;
    
entity Testbench_82 is     -- Top-level bench
generic(
    StimClk  : std_logic      := '1'; 
    CheckClk : std_logic      := '1';
    Period   : time           := 100 ns;
    Finish   : time           :=  20 us;
    SevLevel : severity_level := failure
);
end entity;

architecture Test of Testbench_82 is
    signal JC, BC : unsigned(4 downto 0);         -- Test stimuli
    signal D,  E  : std_logic_vector(2 downto 0); -- Expected & actual results
    
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
    process(BC) is
        variable A, B, C : unsigned(2 downto 0);
    begin
        A := ('0', BC(1), BC(3));
        B := ('0', BC(0), BC(2));
        C := A + B + BC(4);
        
        (D(2), D(0), D(1)) <= C;
    end process;

    -----------------------------------------------------------------------
    -- Device Under Test...                        
    -----------------------------------------------------------------------
    DUT: SN7482N 
    port map(
    X_1  => E(1),  -- S1
    X_2  => BC(3), -- A1
    X_3  => BC(2), -- B1
    X_4  => open,  -- Vcc
    X_5  => BC(4), -- CIN
                   -- 
                   -- 
                   -- 
                   -- 
    X_10 => E(2),  -- C2
    X_11 => open,  -- GND
    X_12 => E(0),  -- S2
    X_13 => BC(0), -- B2
    X_14 => BC(1)  -- A2
);
end architecture Test;
