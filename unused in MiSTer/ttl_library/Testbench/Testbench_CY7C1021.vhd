-----------------------------------------------------------------------
-- Basic SRAM models (VHDL)                                          --
-- David R Brooks                                                    --
-- December, 2016.  Perth, Australia                                 --
-- Compliance: VHDL 2008                                             --
-- Testbench for CY7C1021: 64k x 16 SRAM (Cypress, 10 ns)            --
-----------------------------------------------------------------------

library ieee;
    use ieee.std_logic_1164.all;
    use ieee.std_logic_misc.all;
    use ieee.numeric_std.all;

    use work.TTLPrivate.all;
    use work.Memories.all;
    
entity Testbench_CY7C1021 is     -- Top-level bench
generic(
    OC       : boolean        := false;
    StimClk  : std_logic      := '1'; 
    CheckClk : std_logic      := '1';
    Period   : time           := 100 ns;
    Finish   : time           :=  30 ms;
    SevLevel : severity_level := failure
);
end entity;

architecture Test of Testbench_CY7C1021 is
    subtype  TDATA   is std_logic_vector(15 downto 0);
    subtype  TADDR   is unsigned(15 downto 0);
    constant KADTOP  :  natural := (2**(TADDR'high+1))-1;
    subtype  TADNUM  is natural range KADTOP downto 0;
    type     TMEM    is array(KADTOP downto 0) of TDATA;

    signal J, B      : unsigned(10 downto 0);           -- Unused
    signal D, E      : TDATA;                           -- Expected & actual results
    signal CLK, RS   : std_logic;
    signal CS,  WR   : std_logic := '1';
    signal AD        : TADDR := (others => '0'); 
    signal DI        : TDATA;
    signal W         : std_logic;
    signal Phase     : natural;    
    signal OE        : std_logic;
    signal BHE, BLE  : std_logic;
    
    constant AD1     : TADDR := (others => '1');
    constant ID1     : unsigned(TDATA'range) := "0000000000000010";
    
    begin
        BHE <= '0';
        BLE <= '0';
        
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
            OE    <= '1';
        elsif rising_edge(CLK) then
            case Phase is
                when 0      => CS <= '0';             Phase <= 1;   OE <= '1';
                when 1      =>             WR <=  W;  Phase <= 2;   OE <= not W;
                when 2      =>             WR <= '1'; Phase <= 3;   OE <= '1';
                when others => CS <= '1';  WR <= '1'; Phase <= 0;   OE <= '1';
            end case;
        end if;
    end process;
    
    UPDATE: process(CLK, RS) is
        variable TD : unsigned(TDATA'range);
    begin
        if RS = '0' then
            W  <= '0';
            AD <= (others => '0');
            TD := ID1;
        elsif rising_edge(CLK) and Phase = 3 then
            if AD = AD1 then
                W <= not W;         -- Alternate read/write cycles
            end if;
            AD <= AD + 1;
            TD := TD + 1;
        end if;
        DI <= TDATA(TD);
    end process;
  
    -----------------------------------------------------------------------
    -- Generate expected results (with zero delays)
    -----------------------------------------------------------------------    
    process(all) is
        variable mem    : TMEM;             -- Testbench memory
        variable adr    : TADNUM;
        variable QI     : TDATA;
    begin
        D <= E;                             -- Default, if not active
        
        if CS = '0' then                    -- Device active
            adr := TTL_to_integer(AD);
            if rising_edge(WR) then         -- Rising (ie trailing) edge
                mem(adr) := DI;
            end if;
            
            if OE = '0' then                -- Reading
                QI := mem(adr);
            else
                QI := (others => 'Z');
            end if;
            
            if OC then                      -- Simulate open collector
                for i in D'range loop
                    D(i) <= TTL_OC(QI(i));
                end loop;
            else
                D <= QI;
            end if;
        end if;
    end process;
    
    process(CLK) is                         -- During writes, mimic the data
    begin
        if falling_edge(CLK) then
            if W = '0' then
                case Phase is
                    when 1 | 2  => D <= E;
                    when others => D <= (others => 'Z');
                end case;
            end if;
        end if;
    end process;
    
    E <= DI when (W = '0') and (Phase = 1 or Phase = 2) else (others => 'Z');
    
    -----------------------------------------------------------------------
    -- Device Under Test...                        
    -----------------------------------------------------------------------
    DUT: CY7C1021
generic map(
    fnevn => "",            -- Name of even-byte initialisation file (if any)
    fnodd => ""             -- Name of odd-byte  initialisation file (if any)
)
port map(
    X_1  => AD(4),  -- A4
    X_2  => AD(3),  -- A3
    X_3  => AD(2),  -- A2
    X_4  => AD(1),  -- A1
    X_5  => AD(0),  -- A0
    X_6  => CS,     -- CE\
    X_7  => E(0),   -- IO0
    X_8  => E(1),   -- IO1
    X_9  => E(2),   -- IO2
    X_10 => E(3),   -- IO3
    X_11 => open,   -- Vcc
    X_12 => open,   -- GND
    X_13 => E(4),   -- IO4
    X_14 => E(5),   -- IO5 
    X_15 => E(6),   -- IO6
    X_16 => E(7),   -- IO7
    X_17 => WR,     -- WE\
    X_18 => AD(15), -- A15
    X_19 => AD(14), -- A14
    X_20 => AD(13), -- A13
    X_21 => AD(12), -- A12
--  X_22
--  X_23
    X_24 => AD(11), -- A11
    X_25 => AD(10), -- A10
    X_26 => AD(9),  -- A9
    X_27 => AD(8),  -- A8
--  X_28
    X_29 => E(8),   -- IO8
    X_30 => E(9),   -- IO9
    X_31 => E(10),  -- IO10
    X_32 => E(11),  -- IO11
    X_33 => open,   -- VCC
    X_34 => open,   -- GND 
    X_35 => E(12),  -- IO12
    X_36 => E(13),  -- IO13
    X_37 => E(14),  -- IO14
    X_38 => E(15),  -- IO15
    X_39 => BLE,    -- BLE\
    X_40 => BHE,    -- BHE\
    X_41 => OE,     -- OE\
    X_42 => AD(7),  -- A7
    X_43 => AD(6),  -- A6
    X_44 => AD(5)   -- A5
);
end architecture Test;
