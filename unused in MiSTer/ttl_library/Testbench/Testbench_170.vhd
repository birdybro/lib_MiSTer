-----------------------------------------------------------------------
-- Bipolar TTL models (VHDL)                                         --
-- David R Brooks                                                    --
-- June, 2016.  Perth, Australia                                     --
-- Compliance: VHDL 2008                                             --
-- Testbench for SN74LS170N: 4 X 4 register file (open collector)    --
-----------------------------------------------------------------------

library ieee;
    use ieee.std_logic_1164.all;
    use ieee.std_logic_misc.all;
    use ieee.numeric_std.all;
    use work.LSTTL.all;
    use work.TTLPrivate.all;
    
entity Testbench_170 is     -- Top-level bench
generic(
    OC       : boolean        := true;
    StimClk  : std_logic      := '1'; 
    CheckClk : std_logic      := '1';
    Period   : time           := 100 ns;
    Finish   : time           :=  20 us;
    SevLevel : severity_level := failure
);
end entity;

architecture Test of Testbench_170 is
    subtype T_quad is std_logic_vector(4 downto 1);
    type    T_mem  is array(3 downto 0) of T_quad;
    subtype T_addr is natural range 3 downto 0;

    signal J, B      : unsigned(5 downto 0);         -- Unused
    signal D, E      : T_quad; -- Expected & actual results
    signal CLK, RS   : std_logic;
    signal RA, WA    : unsigned(1 downto 0) := (others => '0'); 
    signal DI        : unsigned(4 downto 0);
    signal RE, WE    : std_logic := '1';
    signal Phase     : natural;

    begin
    RA <= J(1 downto 0);
    WA <= B(1 downto 0);
    
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
        RS   => RS,
        D    => D,
        E    => E
    );
  
    -----------------------------------------------------------------------
    -- Generate RAM-specific stimuli
    -----------------------------------------------------------------------
    CLKX: process(CLK, RS) is
        variable ER : std_logic;
    begin
            ER := '1';
            WE <= '1';
        if RS = '0' then
            DI <= (others => '0');
        elsif rising_edge(CLK) then
            DI <= DI + 1;
            case to_integer(DI) is
                when  5 | 6 |  7 |  8 => WE <= '0' after 15 ns;
                when  9 |10 | 11 | 12 => ER := '0';
                when 16     => DI <= (others => '0');
                when others => null;
            end case;
            RE <= ER;
        end if;
    end process;
  
    -----------------------------------------------------------------------
    -- Generate expected results (with zero delays)
    -----------------------------------------------------------------------
    process(all) is
        variable mem    : T_mem;      -- Testbench memory
        variable AR, AW : natural;
        variable QI     : T_quad;
    begin
        AR := TTL_to_integer(RA);
        AW := TTL_to_integer(WA);
        D  <= (others => 'Z');
        
        if WE = '0' then
            mem(AW) := std_logic_vector(DI(3 downto 0));
        end if;
        
        if RE = '0' then
            QI := mem(AR);
            for i in D'range loop
                D(i) <= TTL_OC(QI(i));
            end loop;
        end if;
    end process;
    
    -----------------------------------------------------------------------
    -- Device Under Test...                        
    -----------------------------------------------------------------------
    DUT: SN74LS170N
    port map(
        X_1  => DI(1), -- D2
        X_2  => DI(2), -- D3
        X_3  => DI(3), -- D4
        X_4  => RA(1), -- RA1
        X_5  => RA(0), -- RA0
        X_6  => E(4),  -- Q4
        X_7  => E(3),  -- Q3
        X_8  => open,  -- GND
        X_9  => E(2),  -- Q2
        X_10 => E(1),  -- Q1
        X_11 => RE,    -- RE\
        X_12 => WE,    -- WE\
        X_13 => WA(1), -- WA1
        X_14 => WA(0), -- WA0
        X_15 => DI(0), -- D1
        X_16 => open   -- Vcc
    );
end architecture Test;
