-----------------------------------------------------------------------
-- Bipolar TTL models (VHDL)                                         --
-- David R Brooks                                                    --
-- December, 2016.  Perth, Australia                                 --
-- Compliance: VHDL 2008                                             --
-- Testbench for SN74LS322N: 8 bit ser/par register + sign extend    --
-----------------------------------------------------------------------

library ieee;
    use ieee.std_logic_1164.all;
    use ieee.std_logic_misc.all;
    use ieee.numeric_std.all;
    use work.LSTTL.all;
    use work.TTLPrivate.all;
    
entity Testbench_322 is     -- Top-level bench
generic(
    StimClk  : std_logic      := '1'; 
    CheckClk : std_logic      := '1';
    Period   : time           := 40 ns;
    Finish   : time           := 50 us;
    SevLevel : severity_level := failure
);
end entity;

architecture Test of Testbench_322 is
    signal J,  B     : unsigned(14 downto 0);        -- Test stimuli
    signal D,  E     : std_logic_vector(8 downto 0); -- Expected & actual results
    signal RS, CLK   : std_logic;
    signal OEI, DIN  : std_logic;
    signal DI, R, DT : std_logic_vector(7 downto 0);
    
    alias  RE  is J(8);
    alias  SP  is J(9);
    alias  D0  is J(10);
    alias  D1  is J(11);
    alias  OE  is J(12);
    alias  SE  is J(13);
    alias  S   is J(14);

begin
    OEI  <= (SP or RE) and not(OE);
    DIN  <= D0 when S = '0' else D1;
    DI   <= std_logic_vector(J(7 downto 0)) when OE  = '1' else (others => 'Z');
    E    <= "Z" & DI;
    DT   <= std_logic_vector(J(7 downto 0)) when OE  = '1' else
            R                               when OEI = '1' else
            (others => 'Z');
    D    <= R(0) & DT;
    
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
        variable SEL : unsigned(2 downto 0);
    begin
        if RS = '0' then
            R <= (others => '0');
        elsif rising_edge(CLK) then
            SEL := RE & SP & SE;
            case SEL is
                when "011"   => R <= DIN  & R(7 downto 1);  -- Shift right
                when "010"   => R <= R(7) & R(7 downto 1);  -- Shift left
                when "00-"   => R <= DT;                    -- Parallel load
                when others  => null;                       -- Hold
            end case;
        end if;
    end process;
    
    -----------------------------------------------------------------------
    -- Device Under Test...                        
    -----------------------------------------------------------------------
    DUT: SN74LS322N 
    port map(
        X_1  => RE,    -- RE\
        X_2  => SP,    -- S/P\
        X_3  => D0,    -- D0
        X_4  => DI(7), -- IO7
        X_5  => DI(5), -- IO5
        X_6  => DI(3), -- IO3
        X_7  => DI(1), -- IO1
        X_8  => OE,    -- OE\
        X_9  => RS,    -- MR\
        X_10 => open,  -- GND
        X_11 => CLK,   -- CP
        X_12 => E(8),  -- Q0
        X_13 => DI(0), -- IO0
        X_14 => DI(2), -- IO2
        X_15 => DI(4), -- IO4
        X_16 => DI(6), -- IO6
        X_17 => D1,    -- D1
        X_18 => SE,    -- SE\
        X_19 => S,     -- S
        X_20 => open   -- Vcc
    );
end architecture Test;
