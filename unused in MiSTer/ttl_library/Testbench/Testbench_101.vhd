-----------------------------------------------------------------------
-- Bipolar TTL models (VHDL)                                         --
-- David R Brooks                                                    --
-- June, 2016.  Perth, Australia                                     --
-- Compliance: VHDL 2008                                             --
-- Testbench for SN74H101N: JK edge-triggered flipflop: AND-OR input --
-----------------------------------------------------------------------

library ieee;
    use ieee.std_logic_1164.all;
    use ieee.std_logic_misc.all;
    use ieee.numeric_std.all;
    use work.LSTTL.all;
    use work.TTLPrivate.all;
    
entity Testbench_101 is     -- Top-level bench
generic(
    StimClk  : std_logic      := '1'; 
    CheckClk : std_logic      := '1';
    Period   : time           := 120 ns;
    Finish   : time           :=  20 us;
    SevLevel : severity_level := failure
);
end entity;

architecture Test of Testbench_101 is
    signal PS, J, K : std_logic;
    signal CLK      : std_logic;
    signal JC, BC   : unsigned(7 downto 0);         -- Test stimuli
    signal D,  E    : std_logic_vector(1 downto 0); -- Expected & actual results

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
        CLK  => CLK,
        RS   => PS,
        D    => D,
        E    => E
    );
    
    -----------------------------------------------------------------------
    -- Generate expected results (with zero delays)
    -----------------------------------------------------------------------
    
    SIM: process(CLK, PS) is
        variable JK : std_logic_vector(1 downto 0);
    begin
        if    PS = '0' then     -- Here, set
            D(0) <= '1';
        elsif falling_edge(CLK) then
            JK := J & K;
            case JK is
                when "00"   => null;
                when "01"   => D(0) <= '0';
                when "10"   => D(0) <= '1';
                when "11"   => D(0) <= not D(0);
                when others => null;
            end case;
        end if;
    end process;
    
    D(1) <= not D(0);
    
    J <= (BC(0) and BC(1)) or (BC(2) and BC(3));
    K <= (BC(4) and BC(5)) or (BC(6) and BC(7));
    
    -----------------------------------------------------------------------
    -- Device Under Test...                        
    -----------------------------------------------------------------------
    DUT: SN74H101N 
    port map(
    X_1  => BC(0),   -- J1A
    X_2  => BC(1),   -- J1B
    X_3  => BC(2),   -- J2A
    X_4  => BC(3),   -- J2B
    X_5  => PS,      -- SD\
    X_6  => E(0),    -- Q
    X_7  => open,    -- GND
    X_8  => E(1),    -- Q\
    X_9  => BC(4),   -- K1A
    X_10 => BC(5),   -- K1B
    X_11 => BC(6),   -- K2A
    X_12 => BC(7),   -- K2B
    X_13 => CLK,     -- CP
    X_14 => open     -- Vcc
);
end architecture Test;
