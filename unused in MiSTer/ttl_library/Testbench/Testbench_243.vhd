-----------------------------------------------------------------------
-- Bipolar TTL models (VHDL)                                         --
-- David R Brooks                                                    --
-- June, 2016.  Perth, Australia                                     --
-- Compliance: VHDL 2008                                             --
-- Testbench for SN74LS243N: Quad bus transceiver (3-state outputs)  --
-----------------------------------------------------------------------

library ieee;
    use ieee.std_logic_1164.all;
    use ieee.std_logic_misc.all;
    use ieee.numeric_std.all;
    use work.LSTTL.all;
    use work.TTLPrivate.all;
    
entity Testbench_243 is     -- Top-level bench
generic(
    StimClk  : std_logic      := '1'; 
    CheckClk : std_logic      := '1';
    Period   : time           := 50 ns;
    Finish   : time           := 20 us;
    SevLevel : severity_level := failure
);
end entity;

architecture Test of Testbench_243 is
    signal RS       : std_logic;
    signal CLK      : std_logic;
    signal JC,  BC  : unsigned(7 downto 0);         -- Test stimuli
    signal D,   E   : std_logic_vector(8 downto 1); -- Expected & actual results
    signal A2B, B2A : std_logic;
    signal IA       : std_logic_vector(4 downto 1);
    
begin    
    IA  <= std_logic_vector(JC(3 downto 0));
    
    A2B <= BC(0);
    B2A <= BC(0);
    
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
            D(j)   <= IA(j);
            D(j+4) <= IA(j);
            
            E(j)   <= IA(j) when A2B = '0' else 'Z';
            E(j+4) <= IA(j) when B2A = '1' else 'Z';
        end loop;
    end process;
    
    -----------------------------------------------------------------------
    -- Device Under Test...                        
    -----------------------------------------------------------------------
    DUT: SN74LS243N 
    port map(
        X_1  => A2B,  --  A2B\
                      --
        X_3  => E(1), --  A1
        X_4  => E(2), --  A2
        X_5  => E(3), --  A3
        X_6  => E(4), --  A4
        X_7  => open, --  GND
        X_8  => E(8), --  B4\
        X_9  => E(7), --  B3\
        X_10 => E(6), --  B2\
        X_11 => E(5), --  B1\
                      --
        X_13 => B2A,  --  B2A
        X_14 => open  --  Vcc
    );
end architecture Test;
