-----------------------------------------------------------------------
-- Bipolar TTL models (VHDL)                                         --
-- David R Brooks                                                    --
-- June, 2016.  Perth, Australia                                     --
-- Compliance: VHDL 2008                                             --
-- Testbench for SN74180N: 8-bit parity generator/checker            --
-----------------------------------------------------------------------

library ieee;
    use ieee.std_logic_1164.all;
    use ieee.std_logic_misc.all;
    use ieee.numeric_std.all;
    use work.LSTTL.all;
    use work.TTLPrivate.all;
    
entity Testbench_180 is     -- Top-level bench
generic(
    StimClk  : std_logic      := '1'; 
    CheckClk : std_logic      := '1';
    Period   : time           := 200 ns;
    Finish   : time           :=  20 us;
    SevLevel : severity_level := failure
);
end entity;

architecture Test of Testbench_180 is
    signal RS, I  : std_logic;
    signal CLK    : std_logic;
    signal JC, BC : unsigned(9 downto 0);           -- Test stimuli
    signal D,  E  : std_logic_vector(1 downto 0);   -- Expected & actual results
    signal EI, OI : std_logic;
    
    constant SO : natural := 0;
    constant SE : natural := 1;
    
    begin
    I <= xnor_reduce(std_logic_vector(JC(7 downto 0)));
    EI <= JC(8);
    OI <= not JC(9);

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
    process(all) is
        variable K : std_logic_vector(1 downto 0);
    begin
        K := EI & OI;
        D(SE) <= EI xnor I;
        D(SO) <= OI xnor I;
        case K is
            when "00"   => D(SE) <= '1'; D(SO) <= '1';
            when "01"   => null; 
            when "10"   => null;
            when others => D(SE) <= '0'; D(SO) <= '0';
        end case;
    end process;
    
    -----------------------------------------------------------------------
    -- Device Under Test...                        
    -----------------------------------------------------------------------
    DUT: SN74180N 
    port map(
        X_1  => JC(6), -- I6
        X_2  => JC(7), -- I7
        X_3  => EI,    -- EI
        X_4  => OI,    -- OI
        X_5  => E(SE), -- SE
        X_6  => E(SO), -- SO
        X_7  => open,  -- GND
        X_8  => JC(0), -- I0
        X_9  => JC(1), -- I1
        X_10 => JC(2), -- I2
        X_11 => JC(3), -- I3
        X_12 => JC(4), -- I4
        X_13 => JC(5), -- I5
        X_14 => open   -- Vcc
    );
end architecture Test;
