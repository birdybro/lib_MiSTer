-----------------------------------------------------------------------
-- Bipolar TTL models (VHDL)                                         --
-- David R Brooks                                                    --
-- June, 2016.  Perth, Australia                                     --
-- Compliance: VHDL 2008                                             --
-- Testbench for SN74121N: Monostable multivibrator                  --
-----------------------------------------------------------------------

library ieee;
    use ieee.std_logic_1164.all;
    use ieee.std_logic_misc.all;
    use ieee.numeric_std.all;
    use work.LSTTL.all;
    use work.TTLPrivate.all;
    
entity Testbench_121 is     -- Top-level bench
end entity;

architecture Test of Testbench_121 is
    signal S, Q : std_logic;    -- Trigger & output
    signal W, N : std_logic;    -- Wide & narrow windows
    begin    
    S <= '0',
         '1' after   250 ns,  '0' after   350 ns,   -- Trigger, let it time out
         '1' after 15000 ns,  '0' after 15100 ns,   -- Trigger again
         '1' after 16000 ns,  '0' after 16100 ns;   -- Should NOT retrigger
         
    -----------------------------------------------------------------------
    -- Generate expected results (with zero delays)
    -----------------------------------------------------------------------
    W <= '0',
         '1' after   320 ns, '0' after 10330 ns,
         '1' after 15060 ns, '0' after 25080 ns;
         
    N <= '0',
         '1' after   350 ns, '0' after 10280 ns,
         '1' after 15090 ns, '0' after 25030 ns;

    -----------------------------------------------------------------------
    -- Validate the results                        
    -----------------------------------------------------------------------
    process(W, N, Q) is
    begin
        if (rising_edge(W)  and Q = '1') or     -- W must rise before Q
           (rising_edge(N)  and Q = '0') or     -- Q must rise before N
           (falling_edge(N) and Q = '0') or     -- N must fall before Q
           (falling_edge(W) and Q = '1') then   -- Q must fall before W
           assert false
                  report "Bad monostable pulse"
                  severity failure;
        end if;
    end process;
    
    -----------------------------------------------------------------------
    -- Device Under Test...                        
    -----------------------------------------------------------------------
    DUT: SN74121N 
    generic map(
        W => 10 us      -- Pulse width
    )
    port map(
    X_1  => open,  -- Q\
                   -- 
    X_3  => '0',   -- A1\
    X_4  => '0',   -- A2\
    X_5  => S,     -- B
    X_6  => Q,     -- Q
    X_7  => open,  -- GND
                   -- 
    X_9  => open,  -- Rint (open for simulation)
    X_10 => open,  -- Cx
    X_11 => open,  -- RxCx
                   -- 
                   -- 
    X_14 => open   -- Vcc
);
end architecture Test;
