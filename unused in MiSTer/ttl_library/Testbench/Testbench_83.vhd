-----------------------------------------------------------------------
-- Bipolar TTL models (VHDL)                                         --
-- David R Brooks                                                    --
-- June, 2016.  Perth, Australia                                     --
-- Compliance: VHDL 2008                                             --
-- Testbench for SN74LS83AN: 4-bit binary full adder (fast carry)    --
-----------------------------------------------------------------------

library ieee;
    use ieee.std_logic_1164.all;
    use ieee.std_logic_misc.all;
    use ieee.numeric_std.all;
    use work.LSTTL.all;
    use work.TTLPrivate.all;
    
entity Testbench_83 is     -- Top-level bench
generic(
    StimClk  : std_logic      := '1'; 
    CheckClk : std_logic      := '1';
    Period   : time           := 50 ns;
    Finish   : time           := 20 us;
    SevLevel : severity_level := failure
);
end entity;

architecture Test of Testbench_83 is
    signal JC, BC : unsigned(8 downto 0);         -- Test stimuli
    signal D,  E  : std_logic_vector(4 downto 0); -- Expected & actual results
    
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
        variable X, Y, Z : natural := 0;
    begin
        if now > 1 ns then      -- Meaningless to run at T=0
            X := TTL_to_integer(JC(7 downto 4));
            Y := TTL_to_integer(JC(3 downto 0));
            Z := TTL_to_integer(JC(8 downto 8));
            
            Z := Z + X + Y;
        end if;
        D <= std_logic_vector(to_unsigned(Z, D'length));
    end process;

    -----------------------------------------------------------------------
    -- Device Under Test...                        
    -----------------------------------------------------------------------
    DUT: SN74LS83AN 
    port map(
    X_1  => JC(3),  -- A3
    X_2  => E(2),   -- S2
    X_3  => JC(2),  -- A2
    X_4  => JC(6),  -- B2
    X_5  => open,   -- Vcc
    X_6  => E(1),   -- S1
    X_7  => JC(5),  -- B1
    X_8  => JC(1),  -- A1
    X_9  => E(0),   -- S0
    X_10 => JC(0),  -- A0
    X_11 => JC(4),  -- B0
    X_12 => open,   -- GND
    X_13 => JC(8),  -- C0
    X_14 => E(4),   -- C4
    X_15 => E(3),   -- S3
    X_16 => JC(7)   -- B3
);
end architecture Test;
