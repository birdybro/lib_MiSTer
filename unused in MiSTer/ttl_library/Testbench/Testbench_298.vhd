-----------------------------------------------------------------------
-- Bipolar TTL models (VHDL)                                         --
-- David R Brooks                                                    --
-- December, 2016.  Perth, Australia                                 --
-- Compliance: VHDL 2008                                             --
-- Testbench for SN74LS298N: Quad 2-input mux. with register         --
-----------------------------------------------------------------------

library ieee;
    use ieee.std_logic_1164.all;
    use ieee.std_logic_misc.all;
    use ieee.numeric_std.all;
    use work.LSTTL.all;
    use work.TTLPrivate.all;
    
entity Testbench_298 is     -- Top-level bench
generic(
    StimClk  : std_logic      := '0'; 
    CheckClk : std_logic      := '0';
    Period   : time           :=  40 ns;
    Finish   : time           :=  50 us;
    SevLevel : severity_level := failure
);
end entity;

architecture Test of Testbench_298 is
    signal J,  B,  Y      : unsigned(9 downto 0);         -- Test stimuli
    signal D,  E          : std_logic_vector(3 downto 0); -- Expected & actual results
    signal CP, S, RS, CLK : std_logic;

begin
    CP <= B(1) or (CLK and not RS);
    Y  <= B after 10 ns;
    S  <= Y(0);
    
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
        J   => J,
        B   => B,
        CLK => CLK,
        RS  => RS,
        D   => D,
        E   => E
    );
    
    -----------------------------------------------------------------------
    -- Generate expected results (with zero delays)
    -----------------------------------------------------------------------
    process(CP) is
    begin
        if falling_edge(CP) then
            if S = '0' then
                D <= (Y(8), Y(6), Y(4), Y(2));
            else
                D <= (Y(9), Y(7), Y(5), Y(3));
            end if;
        end if;
    end process;
    
    -----------------------------------------------------------------------
    -- Device Under Test...                        
    -----------------------------------------------------------------------
    DUT: SN74LS298N 
    port map(
        X_1  => Y(5),  -- I1B
        X_2  => Y(3),  -- I1A
        X_3  => Y(2),  -- I0A
        X_4  => Y(4),  -- I0B
        X_5  => Y(7),  -- I1C
        X_6  => Y(9),  -- I1D
        X_7  => Y(8),  -- I0D
        X_8  => open,  -- GND
        X_9  => Y(6),  -- I0C
        X_10 => S,     -- S
        X_11 => CP,    -- CP\
        X_12 => E(3),  -- QD
        X_13 => E(2),  -- QC
        X_14 => E(1),  -- QB
        X_15 => E(0),  -- QA
        X_16 => open   -- Vcc
    );
end architecture Test;
