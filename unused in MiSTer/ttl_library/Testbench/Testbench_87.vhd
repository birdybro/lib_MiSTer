-----------------------------------------------------------------------
-- Bipolar TTL models (VHDL)                                         --
-- David R Brooks                                                    --
-- June, 2016.  Perth, Australia                                     --
-- Compliance: VHDL 2008                                             --
-- Testbench for SN74H87N: 4-bit true/complement, zero-one element   --
-----------------------------------------------------------------------

library ieee;
    use ieee.std_logic_1164.all;
    use ieee.std_logic_misc.all;
    use ieee.numeric_std.all;
    use work.LSTTL.all;
    use work.TTLPrivate.all;
    
entity Testbench_87 is     -- Top-level bench
generic(
    StimClk  : std_logic      := '1'; 
    CheckClk : std_logic      := '0';
    Period   : time           := 100 ns;
    Finish   : time           :=  20 us;
    SevLevel : severity_level := failure
);
end entity;

architecture Test of Testbench_87 is
    signal J, B : unsigned(5 downto 0);         -- Test stimuli
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
        J    => J, 
        B    => B,
        CLK  => open,
        RS   => open,
        D    => D,
        E    => E
    );
    
    -----------------------------------------------------------------------
    -- Generate expected results (with zero delays)
    -----------------------------------------------------------------------
    process(J) is
        variable S1, S2 : std_logic;
    begin
        S1 := not J(0);
        S2 := J(1);
        for i in E'range loop
            D(i) <= S2 xor (not(S1 and J(i+2)));
        end loop;
    end process;

    -----------------------------------------------------------------------
    -- Device Under Test...                        
    -----------------------------------------------------------------------
    DUT: SN74H87N 
    port map(
    X_1  => J(1),  -- S2
    X_2  => J(2),  -- I1
    X_3  => E(0),  -- Q1
                   -- 
    X_5  => J(3),  -- I2
    X_6  => E(1),  -- Q2
    X_7  => open,  -- GND
    X_8  => J(0),  -- S1
    X_9  => E(2),  -- Q3
    X_10 => J(4),  -- I3
                   --
    X_12 => E(3),  -- Q4
    X_13 => J(5),  -- I4
    X_14 => open   -- Vcc
);
end architecture Test;
