-----------------------------------------------------------------------
-- Bipolar TTL models (VHDL)                                         --
-- David R Brooks                                                    --
-- June, 2016.  Perth, Australia                                     --
-- Compliance: VHDL 2008                                             --
-- Testbench for SN7480N: Gated full adder (Pinout A)                --
-----------------------------------------------------------------------

library ieee;
    use ieee.std_logic_1164.all;
    use ieee.std_logic_misc.all;
    use ieee.numeric_std.all;
    use work.LSTTL.all;
    use work.TTLPrivate.all;
    
entity Testbench_80 is     -- Top-level bench
generic(
    StimClk  : std_logic      := '1'; 
    CheckClk : std_logic      := '1';
    Period   : time           := 100 ns;
    Finish   : time           :=  20 us;
    SevLevel : severity_level := failure
);
end entity;

architecture Test of Testbench_80 is
    signal JC, BC : unsigned(6 downto 0);         -- Test stimuli
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
        variable AX, BX, A, B : std_logic;
        variable IP           : std_logic_vector(2 downto 0);
    begin
        AX := not (BC(3) and BC(4));
        BX := not (BC(5) and BC(6));
        A  := not (AX    and BC(1));
        B  := not (BX    and BC(2));
        IP := (BC(0), B, A);
        case IP is
            when "000"  => D(2) <= '1'; D(1) <= '1'; D(0) <= '0';
            when "001"  => D(2) <= '1'; D(1) <= '0'; D(0) <= '1';
            when "010"  => D(2) <= '1'; D(1) <= '0'; D(0) <= '1';
            when "011"  => D(2) <= '0'; D(1) <= '1'; D(0) <= '0';
            when "100"  => D(2) <= '0'; D(1) <= '0'; D(0) <= '1';
            when "101"  => D(2) <= '1'; D(1) <= '1'; D(0) <= '0';
            when "110"  => D(2) <= '1'; D(1) <= '1'; D(0) <= '0';
            when "111"  => D(2) <= '0'; D(1) <= '0'; D(0) <= '1';
            when others => D <= (others => 'X');
        end case;
    end process;
    
    -----------------------------------------------------------------------
    -- Device Under Test...                        
    -----------------------------------------------------------------------
    DUT: SN7480N 
    port map(
                    -- BX
    X_2  => BC(2),  -- BC
    X_3  => BC(0),  -- CN
    X_4  => E(2),   -- CNP1\
    X_5  => E(0),   -- S
    X_6  => E(1),   -- S\
    X_7  => open,   -- GND
    X_8  => BC(3),  -- A1
    X_9  => BC(4),  -- A2
                    -- AX
    X_11 => BC(1),  -- AC
    X_12 => BC(5),  -- B1
    X_13 => BC(6),  -- B2
    X_14 => open    -- Vcc
);
end architecture Test;
