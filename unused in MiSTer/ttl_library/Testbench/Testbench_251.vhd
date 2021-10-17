-----------------------------------------------------------------------
-- Bipolar TTL models (VHDL)                                         --
-- David R Brooks                                                    --
-- December, 2016.  Perth, Australia                                 --
-- Compliance: VHDL 2008                                             --
-- Testbench for SN74LS251N: 8-input multiplexer (3-state outputs)   --
-----------------------------------------------------------------------

library ieee;
    use ieee.std_logic_1164.all;
    use ieee.std_logic_misc.all;
    use ieee.numeric_std.all;
    use work.LSTTL.all;
    use work.TTLPrivate.all;
    
entity Testbench_251 is     -- Top-level bench
generic(
    StimClk  : std_logic      := '1'; 
    CheckClk : std_logic      := '1';
    Period   : time           :=  75 ns;
    Finish   : time           := 200 us;
    SevLevel : severity_level := failure
);
end entity;

architecture Test of Testbench_251 is
    signal J, B : unsigned(11 downto 0);         -- Test stimuli
    signal D, E : std_logic_vector(1 downto 0); -- Expected & actual results
    signal A    : unsigned(2 downto 0);
    signal chn  : natural range 7 downto 0;
    
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
    A    <= B(3 downto 1);
    chn  <= TTL_to_integer(A);
    D(1) <= not B(4+chn) when B(0) = '0' else 'Z';
    D(0) <= notz(D(1));

    -----------------------------------------------------------------------
    -- Device Under Test...                        
    -----------------------------------------------------------------------
    DUT: SN74LS251N 
    port map(
        X_1  => B(7),  -- I3
        X_2  => B(6),  -- I2
        X_3  => B(5),  -- I1
        X_4  => B(4),  -- I0
        X_5  => E(0),  -- Z
        X_6  => E(1),  -- Z\
        X_7  => B(0),  -- E\
        X_8  => open,  -- GND
        X_9  => B(3),  -- S2
        X_10 => B(2),  -- S1
        X_11 => B(1),  -- S0
        X_12 => B(11), -- I7
        X_13 => B(10), -- I6
        X_14 => B(9),  -- I5
        X_15 => B(8),  -- I4
        X_16 => open   -- Vcc
    );
end architecture Test;
