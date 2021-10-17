-----------------------------------------------------------------------
-- Bipolar TTL models (VHDL)                                         --
-- David R Brooks                                                    --
-- May, 2016.  Perth, Australia                                      --
-- Compliance: VHDL 2008                                             --
-- NB Simulation only: they are NOT synthesizable.                   --
-- Private package, used internally by the models.                   --
-----------------------------------------------------------------------

library ieee;
    use ieee.std_logic_1164.all;
    use ieee.std_logic_misc.all;
    use ieee.numeric_std.all;
    use ieee.std_logic_textio.all;
    
    use std.textio.all;
    

package TTLPrivate is

--                          For each gate      For each input
type    TTLInputs  is array(positive range <>, positive range <>) of std_logic;
type    TTLOutputs is array(positive range <>) of std_logic;
        
type    TTLMode    is (Zand, Zor, Zxor, Zbuf);      -- 'Z' so they aren't keywords
type    TTLSingle  is array(1 to 1) of std_logic;

subtype TTLword    is unsigned(3 downto 0);
type    TTL2word   is    array(2 downto 1) of TTLword;

subtype TTLquad    is std_logic_vector(4 downto 1);
type    TTLmem     is array(15 downto 0) of TTLquad;
subtype TTLaddr    is natural range 15 downto 0;

type    TTLmemop   is (Totem, OpenColl, TriState);  -- Memory-block outputs
type    TTLmemory  is array(natural range <>, natural range <>) of std_logic;
type    TTLmemptr  is access TTLmemory;

subtype TTLbyte    is integer range 0 to 255;       -- 8-bit integer
type    TTLline    is array(0 to 299) of TTLbyte;

-----------------------------------------------------------------------
-- Procedure: Initialise memory-block from a file (Intel format)
-----------------------------------------------------------------------
procedure TTL_mem_init(fname : in String; MA : inout TTLmemptr);

-----------------------------------------------------------------------
-- Function: "safe" conversion from unsigned to natural
-- Only "impure" because it references "now"   
-----------------------------------------------------------------------
impure function TTL_to_integer(i : unsigned) return natural;

-----------------------------------------------------------------------
-- Function: simulate open-collector outputs    
-----------------------------------------------------------------------
pure function TTL_OC(i : std_logic) return std_logic;

-----------------------------------------------------------------------
-- Function: successor fn. for LS490 & similar counters    
-----------------------------------------------------------------------
pure function TTL490(i : TTLword) return TTLword;

-----------------------------------------------------------------------
-- Function: "not", safe with 3-state signals
-----------------------------------------------------------------------
pure function notz(i : std_logic) return std_logic;

-----------------------------------------------------------------------
-- Function: "not", safe with 3-state signals
-----------------------------------------------------------------------
pure function notz(i : std_logic_vector) return std_logic_vector;

-----------------------------------------------------------------------
-- Function: reverse bit order
-----------------------------------------------------------------------
pure function TTL_REV(i : std_logic_vector) return std_logic_vector;
pure function TTL_REV(i : unsigned) return unsigned;
pure function TTL_REV(i : std_logic_vector) return unsigned;
pure function TTL_REV(i : unsigned) return std_logic_vector;

-----------------------------------------------------------------------
-- Standard testbench support
-----------------------------------------------------------------------
component TTLBench is
generic(
    StimClk   : std_logic      := '1';  -- Values after the relevant clock edge 
    CheckClk  : std_logic      := '0';
    Period    : time           := 50 ns;
    Finish    : time           := 20 us;
    SevLevel  : severity_level := failure
);
port(
    J    : out unsigned;
    B    : out unsigned;            -- Indefinite range
    CLK  : out std_logic;
    RS   : out std_logic;
    D    : in  std_logic_vector;
    E    : in  std_logic_vector;    -- Indefinite range
    ANS  : out std_logic            -- Result flag: view in waveforms, 'X' if fault
);
end component TTLBench;

-----------------------------------------------------------------------
-- Universal simple gate implementation
-----------------------------------------------------------------------
component TTLgate is
generic(
    mode   : TTLMode;       -- Zand, Zor, Zxor, Zbuf
    invert : std_logic;     -- '1' will invert the output
    ohigh  : std_logic;     -- '1' = normal, 'Z' = open collectors
    tPLH   : time := 10 ns;
    tPHL   : time := 10 ns
);
port(
    ins   : in  TTLInputs;
    outs  : out TTLOutputs
);
end component TTLgate;    

-----------------------------------------------------------------------
-- Asymmetric propagation delays
-----------------------------------------------------------------------
component TTLdelay is
generic(
    tPLH : time := 10 ns;
    tPHL : time := 10 ns
);
port(
    A : in  std_logic;
    B : out std_logic
);
end component TTLdelay;

component TTLdelays is     -- The same, for a vector
generic(
    tPLH : time := 10 ns;
    tPHL : time := 10 ns
);
port(
    A : in  std_logic_vector;
    B : out std_logic_vector
);
end component TTLdelays;

-----------------------------------------------------------------------
-- 3-state buffer with delays
-----------------------------------------------------------------------
component TTL3State is    
generic(
    tPLH : time :=  6.0 ns;
    tPHL : time :=  7.5 ns;
    tPZH : time := 19.5 ns;
    tPZL : time := 21.0 ns;
    tPHZ : time :=  8.5 ns;
    tPLZ : time := 14.0 ns
);
port(
    A    : in  std_logic;
    E    : in  std_logic;       -- Enable, active high
    Y    : out std_logic
);
end component TTL3State;

-----------------------------------------------------------------------
-- Basic monostable element
-----------------------------------------------------------------------
component TTLmonostable is
generic(
    pwidth        : time    := 100 us;  -- Triggered pulse width
    mintrig       : time    :=  50 ns;  -- Minimum trigger width
    retriggerable : boolean := true
);
port(
    trig  : in  std_logic;
    reset : in  std_logic;
    Q     : out std_logic
);
end component TTLmonostable;

-----------------------------------------------------------------------
-- Elementary flipflop
-- A basic JK flipflop with resets. All active high
-----------------------------------------------------------------------
component TTLflipflop is
generic(
    tPLHCP  : time    := 20 ns;     -- Clock rising
    tPHLCP  : time    := 30 ns;     -- Clock falling
    tPLHSC  : time    := 20 ns;     -- S/C rising
    tPHLSC  : time    := 30 ns;     -- S/C falling
    tSETUP  : time    :=  0 ns;     -- Setup time before clock (0 = no test)
    Safeclk : boolean := false      -- Enforce stable inputs before active clock edge
);
port(
    J, K, C, S, R : in  std_logic;
    Q, QB         : out std_logic
);
end component TTLflipflop;

-----------------------------------------------------------------------
-- 1-bit & 3-bit counter with adjustable modulus
-- See 7490/92/93 & similar parts
-----------------------------------------------------------------------
component TTLcount4 is
generic(
    tPLH0   : time     := 16 ns;
    tPHL0   : time     := 18 ns;
    tPLH1   : time     := 16 ns;
    tPHL1   : time     := 21 ns;
    tPLH2   : time     := 32 ns;
    tPHL2   : time     := 35 ns;
    tPLH3   : time     := 32 ns;
    tPHL3   : time     := 35 ns;
    modulus : positive := 10        -- Legal values are 10,12,16
);
port(
    ld          : in  std_logic;
    d           : in  std_logic_vector(3 downto 0);
    clka, clkb  : in  std_logic;    -- Falling-edge clock
    rst, set    : in  std_logic;    -- Active-low reset, set
    val         : out std_logic_vector(3 downto 0) 
);
end component TTLcount4;

-----------------------------------------------------------------------
-- 4-bit synchronous counter with adjustable modulus
-- See 74160..3 & similar parts
-----------------------------------------------------------------------
component TTLsynccount is
generic(
    asyncreset : boolean := false;
    modulus    : natural := 10;     -- 10, 16 are legal
    tPLHT      : time    := 25 ns;
    tPHLT      : time    := 23 ns;
    tPLHQ      : time    := 24 ns;
    tPHLQ      : time    := 27 ns
);
port(
    PE, CP, CEP, CET, RST : in  std_logic;
    TC                    : out std_logic;
    P                     : in  std_logic_vector(3 downto 0);
    Q                     : out std_logic_vector(3 downto 0)    
);
end component TTLsynccount;

-----------------------------------------------------------------------
-- Synchronous bidirectional binary/decade bidirectional counter
-----------------------------------------------------------------------
component TTLbiCount is
generic(
    decade  : boolean := true;
    tPLHQ   : time    := 20 ns;
    tPHLQ   : time    := 20 ns;
    tPLHT   : time    := 30 ns;
    tPHLT   : time    := 30 ns;
    tSU     : time    := 15 ns;
    tSUPE   : time    := 20 ns
);
port(
    PE, CP, CEP, CET, U_D : in std_logic;
    P                     : in  std_logic_vector(3 downto 0);
    Q                     : out std_logic_vector(3 downto 0);
    TC                    : out std_logic    
);
end component TTLbiCount;

-----------------------------------------------------------------------
-- Generic RAM block with 3-wire asynchronous control
-- NB Control inputs are active low (as in physical chips)
-----------------------------------------------------------------------
component TTLramblock is
generic(
    fname : String    := "";        -- Name of initialisation file (if any)
    Omode : TTLmemop  := OpenColl;  -- Output mode
    INVT  : std_logic := '0';       -- '1' will invert outputs
    tPLC  : time      := 10 ns;
    tPLA  : time      := 37 ns;
    tSUD  : time      := 25 ns;
    tSUA  : time      := 10 ns
);        
port(     
    RA    : in    std_logic_vector;
    WA    : in    std_logic_vector;
    D     : in    std_logic_vector;
    O     : out   std_logic_vector;
    CE    : in    std_logic;
    RE    : in    std_logic;
    WE    : in    std_logic
);
end component TTLramblock;

-----------------------------------------------------------------------
-- Generic addressable latch
-----------------------------------------------------------------------
component TTLadLatch is
generic(
    ABits   : positive := 2;
    tPXDA   : time     := 30 ns;
    tPHLC   : time     := 18 ns
);
port(
    D   : in  std_logic;
    En  : in  std_logic;
    Cn  : in  std_logic;
    A   : in  unsigned(ABits-1 downto 0);
    Z   : out std_logic_vector(2**ABits-1 downto 0)
);
end component TTLadLatch;

-----------------------------------------------------------------------
-- Simple blocks used by testbenches
-----------------------------------------------------------------------
component TTLxcvr is
generic(
    INVT : boolean := false;
    tPLH : time    :=  6.0 ns;
    tPHL : time    :=  7.5 ns;
    tPZH : time    := 19.5 ns;
    tPZL : time    := 21.0 ns;
    tPHZ : time    :=  8.5 ns;
    tPLZ : time    := 14.0 ns
);
port(
    A, B : inout  std_logic_vector; -- Ports, indefinite width       
    EN   : in     std_logic;        -- Enable, active low
    A2B  : in     std_logic         -- Direction
);
end component TTLxcvr;

component TTL_FF is 
port(
    q   : out std_logic;
    d   : in  std_logic;
    clk : in  std_logic;
    cl  : in  std_logic
);
end component TTL_FF;

end package TTLPrivate;

--=====================================================================
package body TTLPrivate is
--=====================================================================

-----------------------------------------------------------------------
-- Procedure: Initialise memory-block from a file (Intel format)
-----------------------------------------------------------------------
procedure TTL_mem_init(fname : in String; MA : inout TTLmemptr) is
    file     fptr   : text;                                 -- Source file, Intel hex format
    variable lptr   : line;                                 -- Line from file
    variable data   : TTLline;                              -- Ditto, converted to bytes
    variable lsize  : integer;                              -- Line size
    variable stchar : character;                            -- Start char. - ':'
    variable valid  : boolean;                              -- Result of "read"
    variable abyte  : std_logic_vector(7 downto 0);         -- Byte, read by hread
    variable sum    : TTLbyte;                              -- Intel-hex checksum
    variable adbase : natural;                              -- MS 16 bits of load address
    variable addr   : natural;                              -- Current load address
    variable word   : std_logic_vector(MA.all'range(2));    -- 1 word of memory
    variable nwrds  : natural;                              -- No. of words in the line
    variable bptr   : natural;                              -- Byte pointer
    variable linum  : natural := 0;                         -- Source line number (for messages)
    
    constant nbytes : natural := (MA.all'length(2) / 8);    -- No. of bytes per memory word
    
begin
    if fname /= "" then             -- If no file, skip initialisation
        assert MA.all'length(2) mod 8 = 0
            report "Memory <" & fname & "> memory width /= 8*N"
            severity failure;       -- Loads 8-bit bytes
            
        file_open(fptr, fname, READ_MODE);
        adbase := 0;                -- Default address-base
        while not endfile(fptr) loop
            readline(fptr, lptr);
            linum := linum + 1;
            read(lptr, stchar, valid);
            assert valid and stchar = ':'
                report "Memory <" & fname & "> line " & natural'image(linum) 
                                  & ": bad start"
                severity failure;   -- Line should start with ':'
            hread(lptr, abyte);     -- Read 1st byte
            data(0) := to_integer(unsigned(abyte));
            sum     := data(0);
            lsize   := sum + 4;     -- Total record length (excl. length byte)
            for i in 1 to lsize loop
                hread(lptr, abyte);
                data(i) := to_integer(unsigned(abyte));
                sum     := (sum + data(i)) mod 256;
            end loop;
            assert sum = 0          -- Line checksum
                report "Memory <" & fname & "> line " & natural'image(linum) 
                                  & ": bad checksum: " & natural'image(sum)
                severity failure;
                
            case data(3) is         -- Record type...
                when 0      =>          -- Data
                    assert data(0) mod nbytes = 0
                        report "Memory <" & fname & "> line " & natural'image(linum) 
                                          & ": line length not an exact number of words"
                        severity failure;
                    addr := adbase + (data(1) * 2**8) + data(2);
                    assert addr mod nbytes = 0
                        report "Memory <" & fname & "> line " & natural'image(linum) 
                                          & ": line not word aligned"
                        severity failure;
                    addr  := addr / nbytes;             -- Make a word address
                    nwrds := data(0) / nbytes;          -- No. of words, this line
                    bptr  := 4;                         -- 1st data byte
                    for j in 0 to nwrds-1 loop
                        word := (others => '0');    
                        for i in 0 to nbytes-1 loop     -- Assemble 1 memory word
                            word := word(word'left-8 downto 0) 
                                    & std_logic_vector(to_unsigned(data(bptr), 8));
                            bptr := bptr + 1;
                        end loop;
                        for i in word'range loop
                            MA.all(addr,i) := word(i);  -- Load, bit by bit
                        end loop;
                        addr := addr + 1;
                    end loop;
                    
                when 1      =>          -- End of file
                    exit;
                    
                when 4      =>          -- Extended linear address
                    adbase := (data(4) * 2**24) + (data(5) * 2**16);
                    
                when others =>          -- Garbage
                    assert false
                        report "Memory <" & fname & "> line " & natural'image(linum) 
                                          & ": bad record type"
                        severity failure;
            end case;
        end loop;
        file_close(fptr);
    end if;
end TTL_mem_init;

-----------------------------------------------------------------------
-- Function: "safe" conversion from unsigned to natural   
-- Only "impure" because it references "now"   
-----------------------------------------------------------------------
impure function TTL_to_integer(i : unsigned) return natural is
begin
    if now < 1 ns then          -- Suppress bad values at start-up
        return 0;
    else
        return to_integer(i);
    end if;
end function TTL_to_integer;

-----------------------------------------------------------------------
-- Function: simulate open-collector outputs    
-----------------------------------------------------------------------
pure function TTL_OC(i : std_logic) return std_logic is
begin
    if i = '1' then return 'Z';
               else return i;
    end if;
end function TTL_OC;  

-----------------------------------------------------------------------
-- Function: successor fn. for LS490 & similar counters    
-----------------------------------------------------------------------
pure function TTL490(i : TTLword) return TTLword is
begin
    case to_integer(i) is
        when 11 | 13 | 15 => return i - 9;
        when others       => return i + 1;
    end case;
end function TTL490;

-----------------------------------------------------------------------
-- Function: "not", safe with 3-state signals
-----------------------------------------------------------------------
pure function notz(i : std_logic) return std_logic is
begin
    case i is
        when 'Z'    => return 'Z';  -- IEEE "not" would return 'X'
        when others => return not i;
    end case;
end function notz;

-----------------------------------------------------------------------
-- Function: "not", safe with 3-state signals
-----------------------------------------------------------------------
pure function notz(i : std_logic_vector) return std_logic_vector is
    variable k : std_logic_vector(i'range);
begin
    for j in i'range loop
        case i(j) is
            when 'Z'    => k(j) := 'Z';  -- IEEE "not" would return 'X'
            when others => k(j) := not i(j);
        end case;
    end loop;
    return k;
end function notz;

-----------------------------------------------------------------------
-- Function: reverse bit order
-----------------------------------------------------------------------
pure function TTL_REV(i : std_logic_vector) return std_logic_vector is
    variable result: std_logic_vector(i'RANGE);
    alias aa: std_logic_vector(i'REVERSE_RANGE) is i;
begin
    for i in aa'RANGE loop
        result(i) := aa(i);
    end loop;
    return result;
end function TTL_REV;

pure function TTL_REV(i : unsigned) return unsigned is
    variable result: unsigned(i'RANGE);
    alias aa: unsigned(i'REVERSE_RANGE) is i;
begin
    for i in aa'RANGE loop
        result(i) := aa(i);
    end loop;
    return result;
end function TTL_REV;

pure function TTL_REV(i : std_logic_vector) return unsigned is
    variable result: unsigned(i'RANGE);
    alias aa: std_logic_vector(i'REVERSE_RANGE) is i;
begin
    for i in aa'RANGE loop
        result(i) := aa(i);
    end loop;
    return result;
end function TTL_REV;

pure function TTL_REV(i : unsigned) return std_logic_vector is
    variable result: std_logic_vector(i'RANGE);
    alias aa: unsigned(i'REVERSE_RANGE) is i;
begin
    for i in aa'RANGE loop
        result(i) := aa(i);
    end loop;
    return result;
end function TTL_REV;



--=====================================================================
end package body TTLPrivate;
--=====================================================================

-----------------------------------------------------------------------
-- Standard testbench support
-----------------------------------------------------------------------
library ieee;
    use ieee.std_logic_1164.all;
    use ieee.numeric_std.all;
    use work.TTLPrivate.all;
    
entity TTLBench is
generic(
    StimClk   : std_logic      := '1';  -- Values after the relevant clock edge 
    CheckClk  : std_logic      := '0';
    Period    : time           := 50 ns;
    Finish    : time           := 20 us;
    SevLevel  : severity_level := failure
);
port(
    J    : out unsigned;
    B    : out unsigned;            -- Indefinite range
    CLK  : out std_logic;
    RS   : out std_logic;
    D    : in  std_logic_vector;
    E    : in  std_logic_vector;    -- Indefinite range
    ANS  : out std_logic            -- Result flag: view in waveforms, 'X' if fault
);
end entity;

architecture Test of TTLBench is
    signal JI, BI : unsigned(J'length-1 downto 0) := (others => '0');
    signal CLKI   : std_logic := not StimClk;
    signal RSI    : std_logic;

begin
    J   <= JI;
    B   <= BI;
    CLK <= CLKI;
    RS  <= RSI;

    -----------------------------------------------------------------------
    -- Test-Pattern Generators                        
    -----------------------------------------------------------------------
    process is                              -- Generate clock, until we stop
    begin
        if now > Finish then
            wait;
        else
            wait for Period / 2;
            CLKI <= not CLKI;
        end if;
    end process;
    
    -- To ensure things really do reset, ensure an active transition of RS
    -- after the simulation initialises.
    RSI <= '1', '0' after 5 ns, '1' after Period * 1.25;            -- Active-low reset
    
    process(CLKI) is
        variable MLS : unsigned(32 downto 0) := (others => '1');
    begin
        if CLKI'event and CLKI = StimClk then
            MLS := MLS(31 downto 0) & (MLS(32) xor MLS(12));        -- Max-length sequence
            JI  <= MLS(JI'range);
            BI <= BI + 1;                                           -- Binary counter
        end if;
    end process;
    
    -----------------------------------------------------------------------
    -- Validate the results
    -- Test patterns change on CLK active, check on CLK inactive
    -----------------------------------------------------------------------
    process(CLKI) is
    begin
        if CLKI'event and CLKI = CheckClk then
            if D /= E then          -- Verify failed
                ANS <= 'X';
                assert RSI = '0'    -- Don't check during initialisation
                    report "Verify failed: Exp """ & to_string(D) & """" &
                                         " Rcv """ & to_string(E) & """" &
                                            " at " & time'image(now)
                    severity SevLevel;
            else
                ANS <= '0';
            end if;    
        end if;
    end process;

end architecture Test;

-----------------------------------------------------------------------
-- Universal simple gate implementation
-----------------------------------------------------------------------
library ieee;
    use ieee.std_logic_1164.all;
    use ieee.std_logic_misc.all;
    use work.TTLPrivate.all;

entity TTLgate is
generic(
    mode   : TTLMode;
    invert : std_logic;     -- '1' will invert the output
    ohigh  : std_logic;     -- '1' = normal, 'Z' = open collectors
    tPLH   : time := 10 ns;
    tPHL   : time := 10 ns
);
port(
    ins   : in  TTLInputs;
    outs  : out TTLOutputs
);
end entity TTLgate; 

architecture BEHAV of TTLgate is
    signal Y, Z : TTLOutputs(outs'range);
begin
    process(ins) is
        variable X : std_logic_vector(ins'range(2));
    begin
        for i in outs'range loop
            for j in ins'range(2) loop
                X(j) := ins(i,j);   -- Extract column into a slv
            end loop;
            
            case mode is            -- The gate function
                when Zand   => Y(i) <= and_reduce(X);
                when Zor    => Y(i) <= or_reduce(X);
                when Zxor   => Y(i) <= xor_reduce(X);
                when others => Y(i) <= X(1);  -- Just a 1-input buffer
            end case;
        end loop;
    end process;
    G1: for i in outs'range generate
    begin
                                    -- Output inverted & open collector, as reqd.
        Z(i) <= '0' when Y(i) = invert else ohigh;

        OP: TTLdelay                -- Apply gate delays
        generic map(
            tPLH => tPLH,
            tPHL => tPHL
        )
        port map(
            A => Z(i),
            B => outs(i)
        );
    end generate;
end architecture BEHAV;  

-----------------------------------------------------------------------
-- Apply asymmetric propagation delays
-----------------------------------------------------------------------
library ieee;
    use ieee.std_logic_1164.all;

entity TTLdelay is
generic(
    tPLH : time := 10 ns;
    tPHL : time := 10 ns
);
port(
    A : in  std_logic;
    B : out std_logic := 'U'
);
end entity TTLdelay;

architecture BEHAV of TTLdelay is
begin
    process(A) is
    begin
        if    rising_edge(A) then
            B <= 'X', A after tPLH;     -- Rising delay
        elsif falling_edge(A) then
            B <= 'X', A after tPHL;     -- Falling delay
        else
            B <= A;                     -- 'Z', or bad value
        end if;
    end process;
end architecture BEHAV;

library ieee;
    use ieee.std_logic_1164.all;
    use work.TTLPrivate.all;

entity TTLdelays is     -- The same, for a vector
generic(
    tPLH : time := 10 ns;
    tPHL : time := 10 ns
);
port(
    A : in  std_logic_vector;
    B : out std_logic_vector
);
end entity TTLdelays;

architecture BEHAV of TTLdelays is
begin
    G: for i in A'range generate
        DO: TTLdelay
        generic map(
            tPLH => tPLH,
            tPHL => tPHL
        )
        port map(
            A => A(i),
            B => B(i)
        );
    end generate;
end architecture BEHAV;

-----------------------------------------------------------------------
-- 3-state buffer with delays
-----------------------------------------------------------------------
library ieee;
    use ieee.std_logic_1164.all;
    
entity TTL3State is    
generic(
    tPLH : time :=  6.0 ns;
    tPHL : time :=  7.5 ns;
    tPZH : time := 19.5 ns;
    tPZL : time := 21.0 ns;
    tPHZ : time :=  8.5 ns;
    tPLZ : time := 14.0 ns
);
port(
    A    : in  std_logic;
    E    : in  std_logic;       -- Enable, active high
    Y    : out std_logic
);
end entity TTL3State;
    
architecture BEHAV of TTL3State is
begin
    process(A, E) is
        variable tPD, tPZX, tPXZ : time;
    begin
        if A = '1' then
            tPD  := tPLH;
            tPZX := tPZH;
            tPXZ := tPHZ;
        else
            tPD  := tPHL;
            tPZX := tPZL;
            tPXZ := tPLZ;
        end if;
    
        if    rising_edge(E)      then  -- Enable
            Y <= A after tPZX;
        elsif falling_edge(E)     then  -- Disable
            Y <= 'Z' after tPXZ;
        elsif A'event and E = '1' then  -- Data change (& enabled)
            Y <= A after tPD;
        else
            Y <= 'Z';                   -- Correct? (or null)
        end if;
    end process;
end architecture BEHAV;

-----------------------------------------------------------------------
-- 3-state transceiver with delays
-----------------------------------------------------------------------
library ieee;
    use ieee.std_logic_1164.all;

entity TTLxcvr is    
generic(
    INVT : boolean := false;
    tPLH : time    :=  6.0 ns;
    tPHL : time    :=  7.5 ns;
    tPZH : time    := 19.5 ns;
    tPZL : time    := 21.0 ns;
    tPHZ : time    :=  8.5 ns;
    tPLZ : time    := 14.0 ns
);
port(
    A, B : inout  std_logic_vector; -- Ports, indefinite width       
    EN   : in     std_logic;        -- Enable, active low
    A2B  : in     std_logic         -- Direction
);
end entity TTLxcvr;

architecture BEHAV of TTLxcvr is
begin
    assert A'left = B'left and A'right = B'right report "Range mismatch" severity failure;
    
    process(all) is
        variable STATE   : std_logic_vector(3 downto 0);
        variable OUTPUTS : std_logic_vector(1 downto 0);
    begin
        for i in A'range loop
            STATE := (EN, A2B, A(i), B(i));
            if INVT then
                STATE := STATE xor "0011";
            end if;
            
            case STATE is
                when "X---" => OUTPUTS := "XX";     -- Bad controls
                when "-X--" => OUTPUTS := "XX";
                when "00-0" => OUTPUTS := "0Z";     -- Drive B -> A
                when "00-1" => OUTPUTS := "1Z";
                when "00-X" => OUTPUTS := "XZ";
                when "010-" => OUTPUTS := "Z0";     -- Drive A -> B
                when "011-" => OUTPUTS := "Z1";
                when "01X-" => OUTPUTS := "ZX";
                when others => OUTPUTS := "ZZ";     -- Disable
            end case;
            A(i) <= OUTPUTS(1);
            B(i) <= OUTPUTS(0);
        end loop;
    end process;
    
end architecture BEHAV;
    
-----------------------------------------------------------------------
-- Basic monostable element
-----------------------------------------------------------------------
library ieee;
    use ieee.std_logic_1164.all;

entity TTLmonostable is
generic(
    pwidth        : time    := 100 us;  -- Triggered pulse width
    mintrig       : time    :=  50 ns;  -- Minimum trigger width
    retriggerable : boolean := true
);
port(
    trig  : in  std_logic;
    reset : in  std_logic;
    Q     : out std_logic
);
end entity TTLmonostable;

architecture BEHAV of TTLmonostable is
  constant resolution : positive := pwidth / mintrig;

  signal clk : std_logic := '0';
  signal ctr : natural   :=  0;
begin
    osc: process is                     -- "Clock oscillator"
    begin
        if ctr /= 0 then
            wait for mintrig / 2;
            clk <= not clk;             -- <resolution> clocks = width
        else
            wait on ctr;
        end if;
    end process;

    tim: process(all) is                -- The timer proper
    begin
        if reset = '1' then
            ctr <= 0;
        elsif rising_edge(trig) and (ctr = 0 or retriggerable) then
            ctr <= 1;                   -- Start (or restart) a cycle
        elsif rising_edge(clk) and ctr > 0 then
            if ctr = resolution then
                ctr <= 0;               -- Cycle completed
            else
                ctr <= ctr + 1;         -- Advance count
            end if;
        end if;
    end process;
    
    Q <= '0' when ctr = 0 else '1';     -- '1' while time runs
    
end architecture BEHAV;

-----------------------------------------------------------------------
-- Elementary TTLflipflop
-- A basic JK TTLflipflop with resets. All active high
--
-- NB This package models gate delay variation by setting outputs to
--    'X' during the uncertain period. If such an output is used as a
--    clock, the active edge will transition from 'X' to the active
--    level. This will NOT trigger the rising/falling_edge() functions,
--    so this model uses the (CLK'event and CLK='1') paradigm.
-----------------------------------------------------------------------
library ieee;
    use ieee.std_logic_1164.all;
    
entity TTLflipflop is
generic(
    tPLHCP  : time    := 20 ns;     -- Clock rising
    tPHLCP  : time    := 30 ns;     -- Clock falling
    tPLHSC  : time    := 20 ns;     -- S/C rising
    tPHLSC  : time    := 30 ns;     -- S/C falling
    tSETUP  : time    :=  0 ns;     -- Setup time before clock (0 = no test)
    Safeclk : boolean := false      -- Enforce stable inputs over inactive clock edge
);
port(
    J, K, C, S, R : in  std_logic;
    Q, QB         : out std_logic
);
end entity TTLflipflop;

architecture BEHAV of TTLflipflop is
    signal qi : std_logic := 'X';
begin
    VV: process(J, K) is            -- Verify data is stable before active clock edge
    begin
        if J'event or K'event then                  -- Either is unstable
            if Safeclk and ((R or S) = '0') then    -- Test requested, & not defeated by reset/set
                assert C = '1' report "Data unstable" severity error;
            end if;
        end if;
    end process;

    FF: process(C, S, R) is         -- The flipflop proper
        variable ip : std_logic_vector(1 downto 0);
        variable qt : std_logic;
        variable dl : time;
    begin
        if    R = '1' then
            if qi /= '0' then               -- Only apply delays if state is changed
                qi <= 'X', '0' after tPHLSC;
            end if;
        elsif S = '1' then
            if qi /= '1' then
                qi <= 'X', '1' after tPLHSC;
            end if;
        elsif C'event and C = '1' then      -- Don't use "rising_edge": unsafe with 'X' values
            if tSETUP > 0 ns then
                assert J'stable(tSETUP) and K'stable(tSETUP)
                    report "Setup time violation"
                    severity warning;
            end if;
            ip := J & K;
            case ip is
                when "00"   => 
                    qt := qi;           -- Hold
                    dl := 0 ns;
                when "01"   => 
                    qt := '0';          -- Reset
                    dl := tPHLCP;
                when "10"   => 
                    qt := '1';          -- Set
                    dl := tPLHCP;
                when "11"   =>         
                    if    qi = '0' then -- Toggle
                        qt := '1';
                        dl := tPLHCP;
                    elsif qi = '1' then
                        qt := '0';
                        dl := tPHLCP;
                    end if;
                when others => 
                    qt := 'X';          -- Illegal
                    dl := tPLHCP;
            end case;
            if qt /= qi then            -- Only apply delays if state is changed
                qi <= 'X', qt after dl;
            end if;
        end if;
    end process;
    
    Q  <= qi;
    QB <= not qi;
end architecture BEHAV;

---------------------------------------------------------------
-- 1-bit & 3-bit counter with adjustable modulus
--         See 7490/92/93 & similar parts
-- NB Don't use "falling_edge" for clocks: the drivers model delays,
--    & set 'X' during the delay period. So a clock goes '1' - 'X' - '0'
--    This must read as a valid edge.
-----------------------------------------------------------------------
library ieee;
    use ieee.std_logic_1164.all;
    use ieee.numeric_std.all;
    use work.TTLPrivate.all;
    
entity TTLcount4 is
generic(
    tPLH0   : time     := 16 ns;
    tPHL0   : time     := 18 ns;
    tPLH1   : time     := 16 ns;
    tPHL1   : time     := 21 ns;
    tPLH2   : time     := 32 ns;
    tPHL2   : time     := 35 ns;
    tPLH3   : time     := 32 ns;
    tPHL3   : time     := 35 ns;
    modulus : positive := 10        -- Legal values are 10,12,16
);
port(
    ld          : in  std_logic;
    d           : in  std_logic_vector(3 downto 0);
    clka, clkb  : in  std_logic;    -- Falling-edge clock
    rst, set    : in  std_logic;    -- Active-low reset / set
    val         : out std_logic_vector(3 downto 0) 
);
end entity TTLcount4;

architecture BEHAV of TTLcount4 is
    type tval is array(0 to 7) of natural;      -- Next counter values
    -- Current count value: 0 1 2 3 4 5 6 7
    constant D5 : tval :=  (1,2,3,4,0,1,2,3);   -- For the 3 moduli
    constant D6 : tval :=  (1,2,4,0,5,6,0,0);   -- A "bi-ternary" count
    constant D8 : tval :=  (1,2,3,4,5,6,7,0);
    
    signal q   : natural := 100;  -- Use 100 as "undefined"
    signal q0  : std_logic;
    signal q31 : std_logic_vector(3 downto 1);
    
begin
    process(ld, clka, rst, set) is
    begin
        if    rst = '0' then
            q0 <= '0';
        elsif ld  = '0' then
            q0 <= d(0);
        elsif set = '0' then
            q0 <= '1';
        elsif clka'event and clka = '0' then
            q0 <= not q0;
        end if;
    end process;
    
    process(ld, clkb, rst, set) is
    begin
        if    rst = '0' then
            q <= 0;
        elsif ld  = '0' then
            q <= to_integer(unsigned(d(3 downto 1)));
        elsif set = '0' then
            case modulus is
                when 10     => q <= 4;
                when 16     => q <= 7;
                when others => assert false report "Illegal modulus" severity failure;
            end case;
        elsif clkb'event and clkb = '0' and q < 8 then
            case modulus is
                when 10     => q <= D5(q);
                when 12     => q <= D6(q);
                when 16     => q <= D8(q);
                when others => assert false report "Illegal modulus" severity failure;
            end case;
        end if;
    end process;
    
    process(all) is
    begin
        if q < 8 then
            q31 <= std_logic_vector(to_unsigned(q, q31'length));
        else
            q31 <= (others => 'X');
        end if;
--        val <= q31 & q0;
    end process;
    
    
    D0: TTLdelay
    generic map(
        tPLH => tPLH0,
        tPHL => tPHL0
    )
    port map(
        A => q0,
        B => val(0)
    );

    D1: TTLdelay
    generic map(
        tPLH => tPLH1,
        tPHL => tPHL1
    )
    port map(
        A => q31(1),
        B => val(1)
    );

    D2: TTLdelay
    generic map(
        tPLH => tPLH2,
        tPHL => tPHL2
    )
    port map(
        A => q31(2),
        B => val(2)
    );

    D3: TTLdelay
    generic map(
        tPLH => tPLH3,
        tPHL => tPHL3
    )
    port map(
        A => q31(3),
        B => val(3)
    );
end architecture BEHAV;

-----------------------------------------------------------------------
-- 4-bit synchronous counter with adjustable modulus
-- See 74160..3 & similar parts
-----------------------------------------------------------------------
library ieee;
    use ieee.std_logic_1164.all;
    use ieee.numeric_std.all;
    use work.TTLPrivate.all;
    
entity TTLsynccount is
generic(
    asyncreset : boolean := false;
    modulus    : natural := 10;     -- 10, 16 are legal
    tPLHT      : time    := 25 ns;
    tPHLT      : time    := 23 ns;
    tPLHQ      : time    := 24 ns;
    tPHLQ      : time    := 27 ns
);
port(
    PE, CP, CEP, CET, RST : in  std_logic;
    TC                    : out std_logic;
    P                     : in  std_logic_vector(3 downto 0);
    Q                     : out std_logic_vector(3 downto 0)   
);
end entity TTLsynccount;

architecture BEHAV of TTLsynccount is
    signal Z   : std_logic_vector(3 downto 0);
    signal TCI : std_logic;
begin
    process(RST, CP, CET) is
        variable N : unsigned(3 downto 0);
    begin
        if asyncreset and (RST = '0') then
            N := (others => '0');
        elsif CP'event and CP = '1' then
            if RST = '0' then
                N := (others => '0');
            elsif PE = '0' then
                N := unsigned(P);
            elsif (CEP and CET) = '1' then
                if modulus = 16 then        -- Simple binary count
                    N := N + 1;
                else                        -- Decade count, cover illegal cases
                    case N is
                        when "1001"          => N := "0000";
                        when "1011" | "1101" => N := "0100";
                        when "1111"          => N := "1000";
                        when others          => N := N + 1;
                    end case;
                end if;
            end if;
        end if;
        Z <= std_logic_vector(N);           -- Export results
        if TTL_to_integer(N) = modulus-1 then
            TCI <= CET;
        else
            TCI <= '0';
        end if;
    end process;

    OQ: TTLdelays 
    generic map(
        tPLH => tPLHQ,
        tPHL => tPHLQ
    )
    port map(
        A => Z,
        B => Q
    );

    OT: TTLdelay 
    generic map(
        tPLH => tPLHT,
        tPHL => tPHLT
    )
    port map(
        A => TCI,
        B => TC
    );
end architecture BEHAV;

-----------------------------------------------------------------------
-- Synchronous bidirectional binary/decade bidirectional counter
-----------------------------------------------------------------------
library ieee;
    use ieee.std_logic_1164.all;
    use ieee.std_logic_misc.all;
    use ieee.numeric_std.all;

    use work.LSTTL.all;
    use work.TTLPrivate.all;

entity TTLbiCount is
generic(
    decade  : boolean := true;
    tPLHQ   : time    := 20 ns;
    tPHLQ   : time    := 20 ns;
    tPLHT   : time    := 30 ns;
    tPHLT   : time    := 30 ns;
    tSU     : time    := 15 ns;
    tSUPE   : time    := 20 ns
);
port(
    PE, CP, CEP, CET, U_D : in std_logic;
    P                     : in  std_logic_vector(3 downto 0);
    Q                     : out std_logic_vector(3 downto 0);
    TC                    : out std_logic    
);
end entity TTLbiCount;

architecture BEHAV of TTLbiCount is
    signal R       : unsigned(3 downto 0);
    signal CEN     : std_logic;
    signal X, Y, Z : std_logic;
    signal W       : std_logic_vector(3 downto 0);
    
begin
    X <= R(0) and R(3) and not CET when decade else and_reduce(std_logic_vector(R)) and not CET;
    Y <= nor_reduce(std_logic_vector(R)) and not CET;
    Z <= not X when U_D = '1' else not Y;
    W <= std_logic_vector(R);

    process(CP) is
        variable SW : std_logic_vector(3 downto 0);
    begin
        if CP'event and CP = '1' then       -- Everything is synchronous
            assert PE'stable(tSUPE) report "PE setup violation"  severity failure;
            assert CEP'stable(tSU)  report "CEP setup violation" severity failure;
            assert CET'stable(tSU)  report "CET setup violation" severity failure;
            SW := (PE, CEP, CET, U_D);
            case SW is
                when "0000" | "0001" | "0010" | "0011" |
                     "0100" | "0101" | "0110" | "0111"=>              -- Load
                    assert P'stable(tSU) report "P setup violation" severity failure;
                    R <= unsigned(P);
                when "1001" =>              -- Count up
                    if decade then
                        case R is
                            when "1001" => R <= "0000";
                            when "1011" => R <= "0100";
                            when "1101" => R <= "0100";
                            when others => R <= R + 1;
                        end case;
                    else
                        R <= R + 1;
                    end if;
                when "1000" =>              -- Count down
                    if decade then
                        case R is
                            when "0000" => R <= "1001";
                            when "1010" => R <= "0001";
                            when "1100" => R <= "0011";
                            when "1110" => R <= "0101";
                            when others => R <= R - 1;
                        end case;
                    else
                        R <= R - 1;
                    end if;
                when others =>              -- No change
                    null;
            end case;
        end if;
    end process;
    
    OQ: TTLdelays 
    generic map(
        tPLH => tPLHQ,
        tPHL => tPHLQ
    )
    port map(
        A => W,
        B => Q
    );

    OT: TTLdelay 
    generic map(
        tPLH => tPLHT,
        tPHL => tPHLT
    )
    port map(
        A => Z,
        B => TC
    );
end architecture BEHAV;

-----------------------------------------------------------------------
-- Generic RAM block with 3-wire asynchronous control
-- NB Control inputs are active low (as in physical chips)
-----------------------------------------------------------------------
library ieee;
    use ieee.std_logic_1164.all;
    use ieee.std_logic_misc.all;
    use ieee.numeric_std.all;

    use work.LSTTL.all;
    use work.TTLPrivate.all;

entity TTLramblock is
generic(
    fname : String    := "";        -- Name of initialisation file (if any)
    Omode : TTLmemop  := OpenColl;  -- Output mode
    INVT  : std_logic := '0';       -- '1' will invert outputs
    tPLC  : time      := 10 ns;
    tPLA  : time      := 37 ns;
    tSUD  : time      := 25 ns;
    tSUA  : time      := 10 ns
);        
port(     
    RA    : in    std_logic_vector;
    WA    : in    std_logic_vector;
    D     : in    std_logic_vector;
    O     : out   std_logic_vector;
    CE    : in    std_logic;
    RE    : in    std_logic;
    WE    : in    std_logic
);
end entity TTLramblock;

architecture BEHAV of TTLramblock is
    subtype  T_word  is std_logic_vector(O'range);
    constant C_size  :  positive := 2**RA'length;
    
    signal   RP, WP     : natural;
    signal   CI, RI, WI : std_logic;

begin
    assert RA'left = WA'left and RA'right = WA'right report "Address range mismatch" severity failure;
    assert  D'left =  O'left and  D'right =  O'right report "Data range mismatch"    severity failure;
    
    VR: process(all) is
    begin
        if WA'event or D'event then
            assert WE = '1' report "Address or data changed during write" severity failure;
        end if;
        if WE'event and WE = '0' then
            assert WA'stable(tSUA) report "Address setup violation" severity failure;
            assert D'stable(tSUD)  report "Data setup violation" severity failure;
        end if;
    end process;

    RP <= to_integer(unsigned(RA)) after tPLA;
    WP <= to_integer(unsigned(WA)) after tPLA;
    CI <= CE after tPLC;
    RI <= RE after tPLC;
    WI <= WE after tPLC;
    
    RM: process(all) is
        variable QQ : std_logic;
        variable MA : TTLmemptr := null;
    begin
        if MA = null then               -- Create the memory array, once only
            MA := new TTLmemory(C_size-1 downto 0, O'range);
            TTL_mem_init(fname, MA);    -- Initialise from file, if given
        end if;
    
        for i in O'range loop           -- Can't use "others" with unconstrained array
            O(i) <= 'Z';                -- Deselected, or not reading
        end loop;
                
        if CI = '0' then
            if WI = '0' then
                for i in O'range loop
                    MA.all(WP,i) := D(i);
                end loop;
            end if;    
        
            if RI = '0' then
                for i in O'range loop
                    QQ := MA.all(RP,i) xor INVT;
                    case Omode is
                        when Totem    => O(i) <= QQ;
                        when OpenColl => O(i) <= TTL_OC(QQ);
                        when TriState => O(i) <= QQ;
                        when others => null;
                    end case;
                end loop;
                
            end if;
        end if;
    end process;
end architecture BEHAV;

-----------------------------------------------------------------------
-- Generic addressable latch
-----------------------------------------------------------------------
library ieee;
    use ieee.std_logic_1164.all;
    use ieee.std_logic_misc.all;
    use ieee.numeric_std.all;

    use work.LSTTL.all;
    use work.TTLPrivate.all;

entity TTLadLatch is
generic(
    ABits   : positive := 2;        -- No. of address bits (so no. of latches)
    tPXDA   : time     := 30 ns;
    tPHLC   : time     := 18 ns
);
port(
    D   : in  std_logic;
    En  : in  std_logic;
    Cn  : in  std_logic;
    A   : in  unsigned(ABits-1 downto 0);
    Z   : out std_logic_vector(2**ABits-1 downto 0)
);
end entity TTLadLatch;

architecture BEHAV of TTLadLatch is
--    signal latch : std_logic_vector(2**ABits-1 downto 0);
    signal addr  : natural;
begin
--    Z    <= latch;                  -- Export the latch
--    addr <= to_integer(A);
    
    process(all)
    begin
        if falling_edge(Cn) then 
            Z <= (others => '0') after tPHLC;
        elsif Cn = '1' then
            if En = '0' then
                Z(to_integer(A)) <= D after tPXDA;
            end if;
        end if;
    end process;
end architecture BEHAV;

-----------------------------------------------------------------------
-- Simple blocks used by testbenches
-----------------------------------------------------------------------
library ieee;
    use ieee.std_logic_1164.all;
    use ieee.std_logic_misc.all;
    use ieee.numeric_std.all;

    use work.LSTTL.all;
    use work.TTLPrivate.all;

entity TTL_FF is 
port(
    q   : out std_logic;
    d   : in  std_logic;
    clk : in  std_logic;
    cl  : in  std_logic
);
end entity TTL_FF;

architecture BEHAV of TTL_FF is
begin
    process(clk, cl) is
    begin
        if cl = '0' then
            q <= '0';
        elsif rising_edge(clk) then
            q <= d;
        end if;
    end process;
end architecture BEHAV;
    
