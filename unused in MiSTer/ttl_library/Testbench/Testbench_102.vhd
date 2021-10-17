-----------------------------------------------------------------------
-- Bipolar TTL models (VHDL)                                         --
-- David R Brooks                                                    --
-- June, 2016.  Perth, Australia                                     --
-- Compliance: VHDL 2008                                             --
-- Testbench for SN74H102N: JK edge-triggered flipflop (AND inputs)  --
-----------------------------------------------------------------------

library ieee;
    use ieee.std_logic_1164.all;
    use ieee.std_logic_misc.all;
    use ieee.numeric_std.all;
    use work.LSTTL.all;
    use work.TTLPrivate.all;
    
entity Testbench_102 is     -- Top-level bench
generic(
    StimClk  : std_logic      := '1'; 
    CheckClk : std_logic      := '1';
    Period   : time           := 120 ns;
    Finish   : time           :=  20 us;
    SevLevel : severity_level := failure
);
end entity;

architecture Test of Testbench_102 is
    signal RS, J, K : std_logic;
    signal CLK      : std_logic;
    signal JC, BC   : unsigned(5 downto 0);         -- Test stimuli
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
        RS   => RS,
        D    => D,
        E    => E
    );
    
    -----------------------------------------------------------------------
    -- Generate expected results (with zero delays)
    -----------------------------------------------------------------------
    
    SIM: process(CLK, RS) is
        variable JK : std_logic_vector(1 downto 0);
    begin
        if    RS = '0' then
            D(0) <= '0';
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
    
    J <= JC(0) and JC(1) and JC(2);
    K <= JC(3) and JC(4) and JC(5);
    
    -----------------------------------------------------------------------
    -- Device Under Test...                        
    -----------------------------------------------------------------------
    DUT: SN74H102N 
    port map(
                   -- 
    X_2  => RS,    -- CD\
    X_3  => JC(0), -- J1
    X_4  => JC(1), -- J2
    X_5  => JC(2), -- J3
    X_6  => E(1),  -- Q\
    X_7  => open,  -- GND
    X_8  => E(0),  -- Q
    X_9  => JC(3), -- K1
    X_10 => JC(4), -- K2
    X_11 => JC(5), -- K3
    X_12 => CLK,   -- CP\
    X_13 => '1',   -- SD\
    X_14 => open   -- Vcc
);
end architecture Test;
