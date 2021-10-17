-----------------------------------------------------------------------
-- Bipolar TTL models (VHDL)                                         --
-- David R Brooks                                                    --
-- June, 2016.  Perth, Australia                                     --
-- Compliance: VHDL 2008                                             --
-- Testbench for SN74LS89N: 64-bit RAM (open collector)              --
-----------------------------------------------------------------------

library ieee;
    use ieee.std_logic_1164.all;
    use ieee.std_logic_misc.all;
    use ieee.numeric_std.all;
    use work.LSTTL.all;
    use work.TTLPrivate.all;
    
entity Testbench_89 is     -- Top-level bench
generic(
    OC       : boolean        := true;
    StimClk  : std_logic      := '1'; 
    CheckClk : std_logic      := '1';
    Period   : time           := 120 ns;
    Finish   : time           :=  20 us;
    SevLevel : severity_level := failure
);
end entity;

architecture Test of Testbench_89 is
    signal J, B      : unsigned(5 downto 0);         -- Unused
    signal D, E      : std_logic_vector(3 downto 0); -- Expected & actual results
    signal CLK, RS   : std_logic;
    signal CS,  WR   : std_logic := '1';
    signal AD        : TTLword   := (others => '0'); 
    signal DI, Q, QQ : TTLquad;
    signal CE, WE    : std_logic;

    signal W         : std_logic;
    signal Phase     : natural;

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
    begin
        if RS = '0' then
            Phase <=  0;
            CS    <= '1';
            WR    <= '1';
        elsif rising_edge(CLK) then
            case Phase is
                when 0      => CS <= '0';             Phase <= 1;
                when 1      =>             WR <=  W;  Phase <= 2;
                when 2      =>             WR <= '1'; Phase <= 3;
                when others => CS <= '1';  WR <= '1'; Phase <= 0;
            end case;
        end if;
    end process;
    
    UPDATE: process(CLK, RS) is
        variable TD : unsigned(3 downto 0);
    begin
        if RS = '0' then
            W  <= '0';
            AD <= (others => '0');
            TD := "0110";
        elsif rising_edge(CLK) and Phase = 3 then
            if AD = "1111" then
                W <= not W;         -- Alternate read/write cycles
            end if;
            AD <= AD + 1;
            TD := TD + 1;
        end if;
        for i in TD'range loop
            DI(i+1) <= TD(i);
        end loop;
    end process;
  
    -----------------------------------------------------------------------
    -- Generate expected results (with zero delays)
    -----------------------------------------------------------------------
    CE <= WR and not CS;
    WE <= not(WR or CS);
    
    process(CE, WE, AD, DI) is
        variable mem : TTLmem;      -- Testbench memory
        variable adr : TTLaddr;
        variable QI  : TTLquad;
    begin
        adr := TTL_to_integer(AD);
        if WE'event and WE = '1' then
            mem(adr) := not DI;     -- Data is output inverted
        end if;
        
        if CE = '1' then
            QI := mem(adr);
        else
            QI := (others => 'Z');
        end if;
        if OC then
            for i in Q'range loop
                Q(i) <= TTL_OC(QI(i));
            end loop;
        else
            Q <= QI;
        end if;
    end process;
    
    D <= Q;
    E <= QQ;

    -----------------------------------------------------------------------
    -- Device Under Test...                        
    -----------------------------------------------------------------------
    DUT: SN74LS89N
    port map(
        X_1  => AD(0),  -- A0
        X_2  => CS,     -- CS\
        X_3  => WR,     -- WE\
        X_4  => DI(1),  -- D1
        X_5  => QQ(1),  -- Q1\
        X_6  => DI(2),  -- D2
        X_7  => QQ(2),  -- Q2\
        X_8  => open,   -- GND
        X_9  => QQ(3),  -- Q3\
        X_10 => DI(3),  -- D3
        X_11 => QQ(4),  -- Q4\
        X_12 => DI(4),  -- D4
        X_13 => AD(3),  -- A3
        X_14 => AD(2),  -- A2
        X_15 => AD(1),  -- A1
        X_16 => open    -- Vcc
    );
end architecture Test;
