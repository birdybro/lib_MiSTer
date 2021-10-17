-----------------------------------------------------------------------
-- Bipolar TTL models (VHDL)                                         --
-- David R Brooks                                                    --
-- August, 2016.  Perth, Australia                                   --
-- Compliance: VHDL 2008                                             --
-- Testbench for SN74LS221N: Dual monostable multivibrator           --
-----------------------------------------------------------------------

library ieee;
    use ieee.std_logic_1164.all;
    use ieee.std_logic_misc.all;
    use ieee.numeric_std.all;
    use work.LSTTL.all;
    use work.TTLPrivate.all;
    
entity Testbench_221 is     -- Top-level bench
end entity;

architecture Test of Testbench_221 is
    signal S, Q : std_logic_vector(1 downto 0);    -- Triggers & outputs
    signal W, N : std_logic_vector(1 downto 0);    -- Wide & narrow windows
    begin    
    S(0) <= '0',
            '1' after   250 ns,  '0' after   350 ns,   -- Trigger, let it time out
            '1' after 15000 ns,  '0' after 15100 ns,   -- Trigger again
            '1' after 16000 ns,  '0' after 16100 ns;   -- This should retrigger
         
    S(1) <= '0',
            '1' after   250 ns,  '0' after   350 ns,   -- Trigger, let it time out
            '1' after 15000 ns,  '0' after 15100 ns,   -- Trigger again
            '1' after 16000 ns,  '0' after 16100 ns;   -- This should retrigger
         
    -----------------------------------------------------------------------
    -- Generate expected results (with zero delays)
    -----------------------------------------------------------------------
    W(0) <= '0',
            '1' after   220 ns, '0' after  9330 ns,
            '1' after 15020 ns, '0' after 25080 ns;
         
    N(0) <= '0',
            '1' after   350 ns, '0' after  9250 ns,
            '1' after 15090 ns, '0' after 25000 ns;

    W(1) <= '0',
            '1' after   220 ns, '0' after 10330 ns,
            '1' after 15020 ns, '0' after 26080 ns;
         
    N(1) <= '0',
            '1' after   350 ns, '0' after 10250 ns,
            '1' after 15090 ns, '0' after 26000 ns;

    -----------------------------------------------------------------------
    -- Validate the results                        
    -----------------------------------------------------------------------
    G: for i in Q'range generate
    begin
        process(W(i), N(i), Q(i)) is
        begin
            if (rising_edge(W(i))  and Q(i) = '1') or     -- W must rise before Q
               (rising_edge(N(i))  and Q(i) = '0') or     -- Q must rise before N
               (falling_edge(N(i)) and Q(i) = '0') or     -- N must fall before Q
               (falling_edge(W(i)) and Q(i) = '1') then   -- Q must fall before W
               assert false
                      report "Bad monostable pulse"
                      severity warning;
            end if;
        end process;
    end generate;
    
    -----------------------------------------------------------------------
    -- Device Under Test...                        
    -----------------------------------------------------------------------
    DUT: SN74LS221N 
    generic map(
        W1   => 10 us, -- Pulse widths
        W2   =>  9 us
    )
    port map(
        X_1  => '0',   -- A1\
        X_2  => S(0),  -- B1
        X_3  => '1',   -- CD1\
        X_4  => open,  -- Q1\
        X_5  => Q(1),  -- Q2
        X_6  => open,  -- Cx2
        X_7  => open,  -- Rx2Cx2
        X_8  => open,  -- GND
        X_9  => '0',   -- A2\
        X_10 => S(1),  -- B2
        X_11 => '1',   -- CD2\
        X_12 => open,  -- Q2\
        X_13 => Q(0),  -- Q1
        X_14 => open,  -- Cx1
        X_15 => open,  -- Rx1Cx1
        X_16 => open   -- Vcc
    );
end architecture Test;
