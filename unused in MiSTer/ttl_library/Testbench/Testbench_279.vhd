-----------------------------------------------------------------------
-- Bipolar TTL models (VHDL)                                         --
-- David R Brooks                                                    --
-- December, 2016.  Perth, Australia                                 --
-- Compliance: VHDL 2008                                             --
-- Testbench for SN74LS279N: 4-bit S-R latch                         --
-----------------------------------------------------------------------

library ieee;
    use ieee.std_logic_1164.all;
    use ieee.std_logic_misc.all;
    use ieee.numeric_std.all;
    use work.LSTTL.all;
    use work.TTLPrivate.all;
    
entity Testbench_279 is     -- Top-level bench
generic(
    StimClk  : std_logic      := '1'; 
    CheckClk : std_logic      := '0';
    Period   : time           := 100 ns;
    Finish   : time           :=  20 us;
    SevLevel : severity_level := warning
);
end entity;

architecture Test of Testbench_279 is
    signal J, B    : unsigned(11 downto 0);         -- Test stimuli
    signal D, E    : std_logic_vector(3 downto 0);  -- Expected & actual results
    signal X       : std_logic_vector(11 downto 0); -- Shortened R-X-S pulses
    signal CLK, RS : std_logic;
    
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
    
    process(CLK, RS) is                     -- Generate short R-S pulses
        variable Y : std_logic_vector(11 downto 0);
    begin
        if RS = '0' then
            X <= "011011011011";            -- General reset
        elsif rising_edge(CLK) then
            Y := std_logic_vector(J);
            Y(9) := Y(9) or not Y(11);      -- Reset dominates, all cases
            Y(6) := Y(6) or not (Y(7) and Y(8));
            Y(3) := Y(3) or not Y(5);
            Y(1) := Y(1) or not Y(2);
            Y(0) := Y(0) or not Y(2);
            X <= Y, (others => '1') after Period / 2;
        end if;
    end process;
    
    -----------------------------------------------------------------------
    -- Generate expected results (with zero delays)
    -----------------------------------------------------------------------
    process(all) is
        variable R, S : std_logic_vector(3 downto 0);
        variable Z    : std_logic_vector(1 downto 0);
    begin
        R := (X(11), X(8) and X(7), X(5), X(2));
        S := (X(9), X(6), X(3), X(1) and X(0));
        
        for i in R'range loop
            Z := S(i) & R(i);
            case Z is
                when "11"   => null;
                when "01"   => D(i) <= '1';
                when "10"   => D(i) <= '0';
                when others => D(i) <= 'X';
            end case;
        end loop;
    end process;
    
    -----------------------------------------------------------------------
    -- Device Under Test...                        
    -----------------------------------------------------------------------
    DUT: SN74LS279N 
    port map(
        X_1  => X(2),  -- 1R\
        X_2  => X(1),  -- 1S1\
        X_3  => X(0),  -- 1S2\
        X_4  => E(0),  -- 1Q
        X_5  => X(5),  -- 2R\
        X_6  => X(3),  -- 2S\
        X_7  => E(1),  -- 2Q
        X_8  => open,  -- GND
        X_9  => E(2),  -- 3Q
        X_10 => X(6),  -- 3S\
        X_11 => X(7),  -- 3R1\
        X_12 => X(8),  -- 3R2\
        X_13 => E(3),  -- 4Q
        X_14 => X(9),  -- 4S\
        X_15 => X(11), -- 4R\
        X_16 => open   -- Vcc
    );
end architecture Test;
