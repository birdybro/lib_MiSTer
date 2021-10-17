-----------------------------------------------------------------------
-- Bipolar TTL models (VHDL)                                         --
-- David R Brooks                                                    --
-- June, 2016.  Perth, Australia                                     --
-- Compliance: VHDL 2008                                             --
-- Testbench for SN74LS245N: Octal bus transceiver (3-state outputs) --
-----------------------------------------------------------------------

library ieee;
    use ieee.std_logic_1164.all;
    use ieee.std_logic_misc.all;
    use ieee.numeric_std.all;
    use work.LSTTL.all;
    use work.TTLPrivate.all;
    
entity Testbench_245 is     -- Top-level bench
generic(
    StimClk  : std_logic      := '1'; 
    CheckClk : std_logic      := '1';
    Period   : time           := 50 ns;
    Finish   : time           := 20 us;
    SevLevel : severity_level := failure
);
end entity;

architecture Test of Testbench_245 is
    signal RS       : std_logic;
    signal CLK      : std_logic;
    signal JC,  BC  : unsigned(7 downto 0);          -- Test stimuli
    signal D,   E   : std_logic_vector(15 downto 0); -- Expected & actual results
    signal A2B, ENB : std_logic;
    signal IA       : std_logic_vector(7 downto 0);
    
begin    
    IA  <= std_logic_vector(JC);
    
    A2B <= BC(0);
    ENB <= BC(1);
    
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
        CLK  => CLK,
        RS   => RS,
        D    => D,
        E    => E
    );
    
    -----------------------------------------------------------------------
    -- Generate expected results (with zero delays)
    -- Special version for bidirectional circuits
    -----------------------------------------------------------------------
    GG: process(all) is
    begin
        for j in IA'range loop
            D(j)   <= IA(j) when A2B = '0' else 'Z';
            D(j+8) <= IA(j) when A2B = '1' else 'Z';
            
            E(j)   <= IA(j) when A2B = '0' else 'Z';
            E(j+8) <= IA(j) when A2B = '1' else 'Z';
        end loop;
    end process;
    
    -----------------------------------------------------------------------
    -- Device Under Test...                        
    -----------------------------------------------------------------------
    DUT: SN74LS245N 
    port map(
        X_1  => A2B,   -- A2B
        X_2  => E(0),  -- A0
        X_3  => E(1),  -- A1
        X_4  => E(2),  -- A2
        X_5  => E(3),  -- A3
        X_6  => E(4),  -- A4
        X_7  => E(5),  -- A5
        X_8  => E(6),  -- A6
        X_9  => E(7),  -- A7
        X_10 => open,  -- GND
        X_11 => E(15), -- B7
        X_12 => E(14), -- B6
        X_13 => E(13), -- B5
        X_14 => E(12), -- B4
        X_15 => E(11), -- B3
        X_16 => E(10), -- B2
        X_17 => E(9),  -- B1
        X_18 => E(8),  -- B0
        X_19 => ENB,   -- E\
        X_20 => open   -- Vcc
    );
end architecture Test;
