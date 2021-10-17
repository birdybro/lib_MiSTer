-----------------------------------------------------------------------
-- Bipolar TTL models (VHDL)                                         --
-- David R Brooks                                                    --
-- December, 2016.  Perth, Australia                                 --
-- Compliance: VHDL 2008                                             --
-- Testbench for SN74LS352N: Dual 4-input mux. (common selects)      --
-----------------------------------------------------------------------

library ieee;
    use ieee.std_logic_1164.all;
    use ieee.std_logic_misc.all;
    use ieee.numeric_std.all;
    use work.LSTTL.all;
    use work.TTLPrivate.all;
    
entity Testbench_352 is     -- Top-level bench
generic(
    StimClk  : std_logic      := '1'; 
    CheckClk : std_logic      := '1';
    Period   : time           :=  50 ns;
    Finish   : time           := 200 us;
    SevLevel : severity_level := failure
);
end entity;

architecture Test of Testbench_352 is
    signal J, B : unsigned(7 downto 0);         -- Test stimuli
    signal D, E : std_logic_vector(1 downto 0); -- Expected & actual results
    signal A    : unsigned(1 downto 0);
    signal chn  : natural range 3 downto 0;
    
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
    A    <= B(3 downto 2);
    chn  <= TTL_to_integer(A);
    
    D(0) <= not((not B(0)) and B(7-chn));
    D(1) <= not((not B(1)) and B(chn+4));
    
    -----------------------------------------------------------------------
    -- Device Under Test...                        
    -----------------------------------------------------------------------
    DUT: SN74LS352N 
    port map(
    X_1  => B(0),  -- EA\
    X_2  => B(3),  -- S1
    X_3  => B(4),  -- I3A
    X_4  => B(5),  -- I2A
    X_5  => B(6),  -- I1A
    X_6  => B(7),  -- I0A
    X_7  => E(0),  -- ZA\
    X_8  => open,  -- GND
    X_9  => E(1),  -- ZB\
    X_10 => B(4),  -- I0B
    X_11 => B(5),  -- I1B
    X_12 => B(6),  -- I2B
    X_13 => B(7),  -- I3B
    X_14 => B(2),  -- S0
    X_15 => B(1),  -- EB\
    X_16 => open   -- Vcc
);
end architecture Test;
