-----------------------------------------------------------------------
-- Bipolar TTL models (VHDL)                                         --
-- David R Brooks                                                    --
-- December, 2016.  Perth, Australia                                 --
-- Compliance: VHDL 2008                                             --
-- Testbench for SN74LS257N: Quad 2-input mux. (3-state outputs)      --
-----------------------------------------------------------------------

library ieee;
    use ieee.std_logic_1164.all;
    use ieee.std_logic_misc.all;
    use ieee.numeric_std.all;
    use work.LSTTL.all;
    use work.TTLPrivate.all;
    
entity Testbench_257 is     -- Top-level bench
generic(
    StimClk  : std_logic      := '1'; 
    CheckClk : std_logic      := '1';
    Period   : time           :=  50 ns;
    Finish   : time           :=  20 us;
    SevLevel : severity_level := failure
);
end entity;

architecture Test of Testbench_257 is
    signal J, B : unsigned(9 downto 0);         -- Test stimuli
    signal D, E : std_logic_vector(3 downto 0); -- Expected & actual results
    
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
    process(B) is
    begin
        if B(0) = '1' then
            D <= (others => 'Z');
        elsif B(1) = '0' then
            D <= (B(8), B(6), B(4), B(2));
        else
            D <= (B(9), B(7), B(5), B(3));
        end if;
    end process;
    
    -----------------------------------------------------------------------
    -- Device Under Test...                        
    -----------------------------------------------------------------------
    DUT: SN74LS257N 
    port map(
    X_1  => B(1),  -- S
    X_2  => B(2),  -- I0A
    X_3  => B(3),  -- I1A
    X_4  => E(0),  -- ZA
    X_5  => B(4),  -- I0B
    X_6  => B(5),  -- I1B
    X_7  => E(1),  -- ZB
    X_8  => open,  -- GND
    X_9  => E(3),  -- ZD
    X_10 => B(9),  -- I1D
    X_11 => B(8),  -- I0D
    X_12 => E(2),  -- ZC
    X_13 => B(7),  -- I1C
    X_14 => B(6),  -- I0C
    X_15 => B(0),  -- E\
    X_16 => open   -- Vcc
);
end architecture Test;
