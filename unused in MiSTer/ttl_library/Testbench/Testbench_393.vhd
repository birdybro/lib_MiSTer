-----------------------------------------------------------------------
-- Bipolar TTL models (VHDL)                                         --
-- David R Brooks                                                    --
-- June, 2016.  Perth, Australia                                     --
-- Compliance: VHDL 2008                                             --
-- Testbench for SN74LS393N: Dual 4-bit binary counter               --
-----------------------------------------------------------------------

library ieee;
    use ieee.std_logic_1164.all;
    use ieee.std_logic_misc.all;
    use ieee.numeric_std.all;
    use work.LSTTL.all;
    use work.TTLPrivate.all;
    
entity Testbench_393 is     -- Top-level bench
generic(
    StimClk  : std_logic      := '0'; 
    CheckClk : std_logic      := '1';
    Period   : time           := 120 ns;
    Finish   : time           :=  20 us;
    SevLevel : severity_level := failure
);
end entity;

architecture Test of Testbench_393 is
    signal RS, NRS : std_logic;
    signal CLK     : std_logic;
    signal J,  B   : unsigned(1 downto 0);          -- Test stimuli
    signal D,  E   : std_logic_vector(7 downto 0);  -- Expected & actual results

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
                when 15     => NA := 0;
                when others => NA := NA + 1;
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
                when 15     => NB := 0;
                when others => NB := NB + 1;
            end case;
        end if;
        D(7 downto 4) <= std_logic_vector(to_unsigned(NB, 4));
    end process;
                
    -----------------------------------------------------------------------
    -- Device Under Test...                        
    -----------------------------------------------------------------------
    DUT: SN74LS393N 
    port map(
    X_1  => B(0),  -- CPA\
    X_2  => RS,    -- MRA
    X_3  => E(0),  -- Q0A
    X_4  => E(1),  -- Q1A
    X_5  => E(2),  -- Q2A
    X_6  => E(3),  -- Q3A
    X_7  => open,  -- GND
    X_8  => E(7),  -- Q3B
    X_9  => E(6),  -- Q2B
    X_10 => E(5),  -- Q1B
    X_11 => E(4),  -- Q0B
    X_12 => RS,    -- MRB
    X_13 => B(1),  -- CPB\
    X_14 => open   -- Vcc
);
    
end architecture Test;
