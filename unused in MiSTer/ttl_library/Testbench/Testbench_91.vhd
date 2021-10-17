-----------------------------------------------------------------------
-- Bipolar TTL models (VHDL)                                         --
-- David R Brooks                                                    --
-- June, 2016.  Perth, Australia                                     --
-- Compliance: VHDL 2008                                             --
-- Testbench for SN74LS91AN: 8-bit shift register (Pinout A)         --
-----------------------------------------------------------------------

library ieee;
    use ieee.std_logic_1164.all;
    use ieee.std_logic_misc.all;
    use ieee.numeric_std.all;
    use work.LSTTL.all;
    use work.TTLPrivate.all;
    
entity Testbench_91 is     -- Top-level bench
generic(
    StimClk  : std_logic      := '1'; 
    CheckClk : std_logic      := '1';
    Period   : time           := 120 ns;
    Finish   : time           :=  20 us;
    SevLevel : severity_level := failure
);
end entity;

architecture Test of Testbench_91 is
    signal RS     : std_logic;
    signal CLK    : std_logic;
    signal JC, BC : unsigned(2 downto 0);           -- Test stimuli
    signal D,  E  : std_logic_vector(1 downto 0);   -- Expected & actual results

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
    process(CLK) is
        variable SR : std_logic_vector(7 downto 0) := (others => 'U');
    begin
        if rising_edge(CLK) then
            SR := SR(6 downto 0) & nand_reduce(std_logic_vector(JC(1 downto 0)));
            D(0) <= SR(7);
            D(1) <= not SR(7);
        end if;
    end process;
    
    -----------------------------------------------------------------------
    -- Device Under Test...                        
    -----------------------------------------------------------------------
    DUT: SN74LS91AN 
    port map(
                   -- 
                   -- 
                   -- 
                   -- 
    X_5  => open,  -- Vcc
                   -- 
                   -- 
                   -- 
    X_9  => CLK,   -- CP
    X_10 => open,  -- GND
    X_11 => JC(1), -- B
    X_12 => JC(0), -- A
    X_13 => E(0),  -- Q
    X_14 => E(1)   -- Q\
    );
end architecture Test;
