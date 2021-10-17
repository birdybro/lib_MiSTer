-----------------------------------------------------------------------
-- Bipolar TTL models (VHDL)                                         --
-- David R Brooks                                                    --
-- June, 2016.  Perth, Australia                                     --
-- Compliance: VHDL 2008                                             --
-- Testbench for SN74LS490N: Dual decade counter                     --
-----------------------------------------------------------------------

library ieee;
    use ieee.std_logic_1164.all;
    use ieee.std_logic_misc.all;
    use ieee.numeric_std.all;
    use work.LSTTL.all;
    use work.TTLPrivate.all;
    
entity Testbench_490 is     -- Top-level bench
generic(
    StimClk  : std_logic      := '0'; 
    CheckClk : std_logic      := '1';
    Period   : time           := 120 ns;
    Finish   : time           :=  20 us;
    SevLevel : severity_level := failure
);
end entity;

architecture Test of Testbench_490 is
    signal RS, NRS, C0, C1 : std_logic;
    signal CLK             : std_logic;
    signal J,  B           : unsigned(1 downto 0);          -- Test stimuli
    signal D,  E           : std_logic_vector(7 downto 0);  -- Expected & actual results

    begin
    RS <= not NRS;
    
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
        CLK  => CLK,
        RS   => NRS,
        D    => D,
        E    => E
    );
    
    -----------------------------------------------------------------------
    -- Generate expected results (with zero delays)
    -----------------------------------------------------------------------
    
    CA: process(B, RS) is
        variable NA : natural;
    begin
        if    RS = '1' then
            NA := 0;
        elsif falling_edge(B(0)) then
            case NA is
                when 11 | 13 | 15 => NA := NA - 9;
                when others       => NA := NA + 1;
            end case;
        end if;
        D(3 downto 0) <= std_logic_vector(to_unsigned(NA, 4));
    end process;
                
    CB: process(B, RS) is
        variable NB : natural;
    begin
        if    RS = '1' then
            NB := 0;
        elsif falling_edge(B(1)) then
            case NB is
                when 11 | 13 | 15 => NB := NB - 9;
                when others       => NB := NB + 1;
            end case;
        end if;
        D(7 downto 4) <= std_logic_vector(to_unsigned(NB, 4));
    end process;
                
    -----------------------------------------------------------------------
    -- Device Under Test...                        
    -----------------------------------------------------------------------
    DUT: SN74LS490N 
    port map(
    X_1  => B(0),  -- CPA\
    X_2  => RS,    -- MRA
    X_3  => E(0),  -- Q0A
    X_4  => '0',   -- MSA
    X_5  => E(1),  -- Q1A
    X_6  => E(2),  -- Q2A
    X_7  => E(3),  -- Q3A
    X_8  => open,  -- GND
    X_9  => E(7),  -- Q3B
    X_10 => E(6),  -- Q2B
    X_11 => E(5),  -- Q1B
    X_12 => '0',   -- MSB
    X_13 => E(4),  -- Q0B
    X_14 => RS,    -- MRB
    X_15 => B(1),  -- CPB\
    X_16 => open   -- Vcc
);
    
end architecture Test;
