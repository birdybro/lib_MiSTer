-----------------------------------------------------------------------
-- Bipolar TTL models (VHDL)                                         --
-- David R Brooks                                                    --
-- December, 2016.  Perth, Australia                                 --
-- Compliance: VHDL 2008                                             --
-- Testbench for SN74LS323N: 8 bit universal shift/storage register  --
-----------------------------------------------------------------------

library ieee;
    use ieee.std_logic_1164.all;
    use ieee.std_logic_misc.all;
    use ieee.numeric_std.all;
    use work.LSTTL.all;
    use work.TTLPrivate.all;
    
entity Testbench_323 is     -- Top-level bench
generic(
    StimClk  : std_logic      := '1'; 
    CheckClk : std_logic      := '1';
    Period   : time           :=  40 ns;
    Finish   : time           :=  50 us;
    SevLevel : severity_level := failure
);
end entity;

architecture Test of Testbench_323 is
    signal J,  B     : unsigned(13 downto 0);        -- Test stimuli
    signal D,  E     : std_logic_vector(9 downto 0); -- Expected & actual results
    signal RS, CLK   : std_logic;
    signal OE        : std_logic;
    signal DI, R, DT : std_logic_vector(0 to 7);
    
    alias  S0  is J(8);
    alias  S1  is J(9);
    alias  OE1 is J(10);
    alias  OE2 is J(11);
    alias  DS0 is J(12);
    alias  DS7 is J(13);

begin
    OE <= not((S1 and S0) or OE1 or OE2);
    DI <= TTL_REV(J(7 downto 0)) when OE = '0' else (others => 'Z');
    E  <= "ZZ" & TTL_REV(DI);
    DT <= TTL_REV(J(7 downto 0)) when OE = '0' else R;
    D  <= R(7) & R(0) & TTL_REV(DT);
    
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
    process(RS, CLK) is
        variable S : unsigned(2 downto 0);
    begin
        if rising_edge(CLK) then
            S := (RS, S1, S0);
            case S is
                when "0--"  => R <= (others => '0');    -- Sync. reset
                when "101"  => R <= DS0 & R(0 to 6);    -- Shift right
                when "110"  => R <= R(1 to 7) & DS7;    -- Shift left
                when "111"  => R <= DT;                 -- Parallel load
                when others => null;                    -- "00" hold
            end case;
        end if;
    end process;
    
    -----------------------------------------------------------------------
    -- Device Under Test...                        
    -----------------------------------------------------------------------
    DUT: SN74LS323N 
    port map(
        X_1  => S0,    -- S0
        X_2  => OE1,   -- OE1\
        X_3  => OE2,   -- OE2\
        X_4  => DI(6), -- IO6
        X_5  => DI(4), -- IO4
        X_6  => DI(2), -- IO2
        X_7  => DI(0), -- IO0
        X_8  => E(8),  -- Q0
        X_9  => RS,    -- SR\
        X_10 => open,  -- GND
        X_11 => DS0,   -- DS0
        X_12 => CLK,   -- CP
        X_13 => DI(1), -- IO1
        X_14 => DI(3), -- IO3
        X_15 => DI(5), -- IO5
        X_16 => DI(7), -- IO7
        X_17 => E(9),  -- Q7
        X_18 => DS7,   -- DS7
        X_19 => S1,    -- S1
        X_20 => open   -- Vcc
    );
end architecture Test;
