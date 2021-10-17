-----------------------------------------------------------------------
-- Static RAM models (VHDL)                                          --
-- David R Brooks                                                    --
-- December, 2016.  Perth, Australia                                 --
-- Compliance: VHDL 2008                                             --
-- NB Simulation only: they are NOT synthesizable.                   --
-- Based on: Manufacturers data sheets                               --
-- Pinouts & naming agree with Altium libraries & VHDL netlister.    --
-- See StaticRAM.vhd                                                 --
-----------------------------------------------------------------------

-- NB The Hamburg SRAM component has been altered, splitting the bidirectional
-- data bus into separate IN & OUT parts. This is needed so that the bidirectional
-- data bus can be exported from these wrapper components.

-----------------------------------------------------------------------
-- HM6116: 2K x 8 CMOS static RAM (70 ns)
--         Verified 28/12/2016
-----------------------------------------------------------------------
library ieee;
    use ieee.std_logic_1164.all;

    use work.LSTTL.all;
    use work.TTLPrivate.all;
    use work.Memories.all;

entity HM6116 is
generic(
    fname : String := "";           -- Name of initialisation file (if any)
    --               min    max
    tRC   : time   := 70        ns; -- Read cycle (not used)
    tAA   : time   :=        70 ns; -- Address access
    tACS  : time   :=        70 ns; -- Chip select access
    tAOE  : time   :=        30 ns; -- OE\ to output valid
    tCLZ  : time   :=  5        ns; -- CS\ to output valid
    tOLZ  : time   :=  5        ns; -- OE\ to output valid
    tCHZ  : time   :=        20 ns; -- CS  to output Hi-Z
    tOHZR : time   :=        20 ns; -- OE  to output Hi-Z
    tOH   : time   :=  3        ns; -- OP hold from addr change
    
    tWC   : time   := 70        ns; -- Write cycle
    tCW   : time   := 70        ns; -- CS to end of write
    tAW   : time   := 70        ns; -- Address valid to end of write
    tAS   : time   :=  0        ns; -- Address setup time
    tDS   : time   :=  0        ns; -- Data setup time
    tWP   : time   := 50        ns; -- Write pulse width
    tWR   : time   :=  0        ns; -- Write recovery time
    tDW   : time   := 30        ns; -- Data valid to end of write
    tDH   : time   :=  0        ns; -- Data hold from end of write
    tWHZ  : time   :=        25 ns; -- Write to OP Hi-Z
    tWLZ  : time   :=  5        ns; -- Write to OP Lo-Z     (not used)
    tOHZW : time   :=        30 ns; -- OE to OP Hi-Z
    tOW   : time   :=  5        ns  -- OP active from end of write
);
port(
    X_1   : in    std_logic;        -- A7
    X_2   : in    std_logic;        -- A6
    X_3   : in    std_logic;        -- A5
    X_4   : in    std_logic;        -- A4
    X_5   : in    std_logic;        -- A3
    X_6   : in    std_logic;        -- A2
    X_7   : in    std_logic;        -- A1
    X_8   : in    std_logic;        -- A0
    X_9   : inout std_logic;        -- IO0
    X_10  : inout std_logic;        -- IO1
    X_11  : inout std_logic;        -- IO2
    X_12  : inout std_logic;        -- GND
    X_13  : inout std_logic;        -- IO3
    X_14  : inout std_logic;        -- IO4 
    X_15  : inout std_logic;        -- IO5
    X_16  : inout std_logic;        -- IO6
    X_17  : inout std_logic;        -- IO7
    X_18  : in    std_logic;        -- CS\
    X_19  : in    std_logic;        -- A10
    X_20  : in    std_logic;        -- OE\
    X_21  : in    std_logic;        -- WE\
    X_22  : in    std_logic;        -- A9
    X_23  : in    std_logic;        -- A8
    X_24  : inout std_logic         -- Vcc
);
end entity HM6116;

architecture BEHAV of HM6116 is
    signal D, Q : std_logic_vector( 7 downto 0);
    signal A    : std_logic_vector(10 downto 0);
    
    alias nCE is X_18;
    alias nOE is X_20;
    alias nWE is X_21;
    
    constant finit : boolean := fname /= "";    -- Initialise at power-up, if file defined
    
begin
    D <= (X_17, X_16, X_15, X_14, X_13, X_11, X_10, X_9);
    (X_17, X_16, X_15, X_14, X_13, X_11, X_10, X_9) <= Q;
    A <= (X_19, X_22, X_23, X_1, X_2, X_3, X_4, X_5, X_6, X_7, X_8);
    
    MB: sram
    generic map(
        value_on_power_up       => 'U',     -- Memory array is filled with this at start
        download_on_power_up    => finit,   -- if TRUE, RAM is downloaded at start of simulation 
        trace_ram_load          => FALSE,   -- Echoes the data downloaded to the RAM on the screen
        enable_nWE_only_control => FALSE,   -- Read-/write access controlled by nWE only

        -- READ-cycle timing parameters
        tAA_max                 => tAA,     -- Address Access Time
        tOHA_min                => tOH,     -- Output Hold Time
        tACE_max                => tACS,    -- nCE/CE2 Access Time
        tDOE_max                => tAOE,    -- nOE Access Time
        tLZOE_min               => tOLZ,    -- nOE to Low-Z Output
        tHZOE_max               => tOHZW,   --  OE to High-Z Output
        tLZCE_min               => tCLZ,    -- nCE/CE2 to Low-Z Output
        tHZCE_max               => tCHZ,    --  CE/nCE2 to High Z Output
 
        -- WRITE-cycle timing parameters
        tWC_min                 => tWC,     -- Write Cycle Time
        tSCE_min                => tCW,     -- nCE/CE2 to Write End
        tAW_min                 => tAW,     -- tAW Address Set-up Time to Write End
        tHA_min                 => tWR,     -- tHA Address Hold from Write End
        tSA_min                 => tAS,     -- Address Set-up Time
        tPWE_min                => tWP,     -- nWE Pulse Width
        tSD_min                 => tDW,     -- Data Set-up to Write End
        tHD_min                 => tDH,     -- Data Hold from Write End
        tHZWE_max               => tWHZ,    -- nWE Low to High-Z Output
        tLZWE_min               => tOW      -- nWE High to Low-Z Output
    )
    port map(
        nCE                     => nCE,     -- low-active Chip-Enable of the SRAM device; defaults to '1' (inactive)
        nOE                     => nOE,     -- low-active Output-Enable of the SRAM device; defaults to '1' (inactive)
        nWE                     => nWE,     -- low-active Write-Enable of the SRAM device; defaults to '1' (inactive)
        A                       => A,       -- address bus of the SRAM device
        D                       => D,       -- data bus to the SRAM device
        Q                       => Q,       -- data bus from the SRAM device
        CE2                     => '1',     -- high-active Chip-Enable of the SRAM device; defaults to '1'  (active) 
        download                => FALSE,   -- A FALSE-to-TRUE transition on this signal downloads the data
        download_filename       => fname,   -- name of the download source file
        dump                    => FALSE,   -- A FALSE-to-TRUE transition on this signal dumps data
        dump_start              => 0,       -- Written to the dump-file are the memory words from memory address 
        dump_end                => 0,       -- dump_start to address dump_end (default: all addresses)
        dump_filename           => ""       -- name of the dump destination file
    );
end architecture BEHAV;
    
-----------------------------------------------------------------------
-- IS61C1024: 128K x 8 CMOS static RAM (ISSI) (20 ns)
--            Verified 28/12/2016
-----------------------------------------------------------------------
library ieee;
    use ieee.std_logic_1164.all;

    use work.LSTTL.all;
    use work.TTLPrivate.all;
    use work.Memories.all;

entity IS61C1024 is
generic(
    fname  : String := "";               -- Name of initialisation file (if any)
    -- Read Cycle     Min.  Max. Unit    Parameter                       
    tRC    : time :=  20         ns;     -- Read Cycle Time                
    tAA    : time :=        20   ns;     -- Address Access Time            
    tOHA   : time :=   3         ns;     -- Output Hold Time               
    tACE1  : time :=        20   ns;     -- CE1 Access Time                
    tACE2  : time :=        20   ns;     -- CE2 Access Time                
    tDOE   : time :=         9   ns;     -- Access Time                    
    tLZOE  : time :=   0         ns;     -- OE to Low-Z Output             
    tHZOE  : time :=         7   ns;     -- OE to High-Z Output            
    tLZCE1 : time :=   3         ns;     -- CE1 to Low-Z Output            
    tLZCE2 : time :=   3         ns;     -- CE2 to Low-Z Output            
    tHZCE  : time :=         9   ns;     -- CE1 or CE2 to High-Z Output    
    tPU    : time :=   0         ns;     -- CE1 or CE2 to Power-Up         
    tPD    : time :=        18   ns;     -- CE1 or CE2 to Power-Down       
                            
    -- Write Cycle    Min.  Max. Unit    Parameter                       
    tWC    : time :=  20         ns;     -- Write Cycle Time               
    tSCE1  : time :=  15         ns;     -- CE1 to Write End               
    tSCE2  : time :=  15         ns;     -- CE2 to Write End               
    tAW    : time :=  15         ns;     -- Address Setup Time to Write End
    tHA    : time :=   0         ns;     -- Address Hold from Write End    
    tSA    : time :=   0         ns;     -- Address Setup Time             
    tPWE   : time :=  12         ns;     -- WE Pulse Width                 
    tSD    : time :=  10         ns;     -- Data Setup to Write End        
    tHD    : time :=   0         ns;     -- Data Hold from Write End       
    tHZWE  : time :=        10   ns;     -- WE LOW to High-Z Output        
    tLZWE  : time :=   2         ns      -- WE HIGH to Low-Z Output        
);
port(
--  X_1
    X_2  : in    std_logic;  -- A16
    X_3  : in    std_logic;  -- A14
    X_4  : in    std_logic;  -- A12
    X_5  : in    std_logic;  -- A7
    X_6  : in    std_logic;  -- A6
    X_7  : in    std_logic;  -- A5
    X_8  : in    std_logic;  -- A4
    X_9  : in    std_logic;  -- A3
    X_10 : in    std_logic;  -- A2
    X_11 : in    std_logic;  -- A1
    X_12 : in    std_logic;  -- A0
    X_13 : inout std_logic;  -- IO0
    X_14 : inout std_logic;  -- IO1 
    X_15 : inout std_logic;  -- IO2
    X_16 : inout std_logic;  -- GND
    X_17 : inout std_logic;  -- IO3
    X_18 : inout std_logic;  -- IO4
    X_19 : inout std_logic;  -- IO5
    X_20 : inout std_logic;  -- IO6
    X_21 : inout std_logic;  -- IO7
    X_22 : in    std_logic;  -- CE1\
    X_23 : in    std_logic;  -- A10
    X_24 : in    std_logic;  -- OE\
    X_25 : in    std_logic;  -- A11
    X_26 : in    std_logic;  -- A9
    X_27 : in    std_logic;  -- A8
    X_28 : in    std_logic;  -- A13
    X_29 : in    std_logic;  -- WE\
    X_30 : in    std_logic;  -- CE2
    X_31 : in    std_logic;  -- A15
    X_32 : inout std_logic   -- Vcc
);
end entity IS61C1024;
    
architecture BEHAV of IS61C1024 is
    signal D, Q : std_logic_vector( 7 downto 0);
    signal A    : std_logic_vector(16 downto 0);
    
    alias nCE1 is X_22;
    alias CE2  is X_30;
    alias nOE  is X_24;
    alias nWE  is X_29;
    
    constant finit : boolean := fname /= "";    -- Initialise at power-up, if file defined
    
begin
         (X_21, X_20, X_19, X_18, X_17, X_15, X_14, X_13) <= Q;  -- Bidirectional bus
    D <= (X_21, X_20, X_19, X_18, X_17, X_15, X_14, X_13);
    A <= (X_2, X_31, X_3, X_28, X_4, X_25, X_23, X_26, X_27, X_5, X_6, X_7, X_8, X_9, X_10, X_11, X_12);
    
    MB: sram
    generic map(
        value_on_power_up       => 'U',     -- Memory array is filled with this at start
        download_on_power_up    => finit,   -- if TRUE, RAM is downloaded at start of simulation 
        trace_ram_load          => FALSE,   -- Echoes the data downloaded to the RAM on the screen
        enable_nWE_only_control => FALSE,   -- Read-/write access controlled by nWE only

        -- READ-cycle timing parameters
        tAA_max                 => tAA,     -- Address Access Time
        tOHA_min                => tOHA,    -- Output Hold Time
        tACE_max                => tACE1,   -- nCE/CE2 Access Time
        tDOE_max                => tDOE,    -- nOE Access Time
        tLZOE_min               => tLZOE,   -- nOE to Low-Z Output
        tHZOE_max               => tHZOE,   --  OE to High-Z Output
        tLZCE_min               => tLZCE1,  -- nCE/CE2 to Low-Z Output
        tHZCE_max               => tHZCE,   --  CE/nCE2 to High Z Output
 
        -- WRITE-cycle timing parameters
        tWC_min                 => tWC,     -- Write Cycle Time
        tSCE_min                => tSCE1,   -- nCE/CE2 to Write End
        tAW_min                 => tAW,     -- tAW Address Set-up Time to Write End
        tHA_min                 => tHA,     -- tHA Address Hold from Write End
        tSA_min                 => tSA,     -- Address Set-up Time
        tPWE_min                => tPWE,    -- nWE Pulse Width
        tSD_min                 => tSD,     -- Data Set-up to Write End
        tHD_min                 => tHD,     -- Data Hold from Write End
        tHZWE_max               => tHZWE,   -- nWE Low to High-Z Output
        tLZWE_min               => tLZWE    -- nWE High to Low-Z Output
    )
    port map(
        nCE                     => nCE1,    -- low-active Chip-Enable of the SRAM device; defaults to '1' (inactive)
        nOE                     => nOE,     -- low-active Output-Enable of the SRAM device; defaults to '1' (inactive)
        nWE                     => nWE,     -- low-active Write-Enable of the SRAM device; defaults to '1' (inactive)
        A                       => A,       -- address bus of the SRAM device
        D                       => D,       -- data bus to the SRAM device
        Q                       => Q,       -- data bus from the SRAM device
        CE2                     => CE2,     -- high-active Chip-Enable of the SRAM device; defaults to '1'  (active) 
        download                => FALSE,   -- A FALSE-to-TRUE transition on this signal downloads the data
        download_filename       => fname,   -- name of the download source file
        dump                    => FALSE,   -- A FALSE-to-TRUE transition on this signal dumps data
        dump_start              => 0,       -- Written to the dump-file are the memory words from memory address 
        dump_end                => 0,       -- dump_start to address dump_end (default: all addresses)
        dump_filename           => ""       -- name of the dump destination file
    );
end architecture BEHAV;
    
-----------------------------------------------------------------------
-- MB84256A-10LL : 32K x 8 CMOS static RAM (Fujitsu)
--            Verified 28/12/2016
-----------------------------------------------------------------------
library ieee;
    use ieee.std_logic_1164.all;

    use work.LSTTL.all;
    use work.TTLPrivate.all;
    use work.Memories.all;

entity MB84256 is
generic(
    fname   : String := "";             -- Name of initialisation file (if any)
    -- Read Cycle     Min   Max
    tRC     : time := 100       ns;     -- Read cycle time
    tAA     : time :=       100 ns;     -- Address access time
    tACS    : time :=       100 ns;     -- nCS1 access time
    tOE     : time :=        40 ns;     -- Output enable to output valid
    tOH     : time :=  20       ns;     -- Output hold from address change
    tCLZ    : time :=  10       ns;     -- Chip select to output Lo-Z
    tOLZ    : time :=   5       ns;     -- Output enable to output Lo-Z
    tCHZ    : time :=        40 ns;     -- Chip select to output Hi-Z
    tOHZ    : time :=        40 ns;     -- Output enable to output Hi-Z
    -- Write Cycle    Min   Max
    tWC     : time := 100       ns;     -- Write cycle time
    tAW     : time :=  80       ns;     -- Address valid to end of write
    tCW     : time :=  80       ns;     -- Chip select to end of write
    tDW     : time :=  40       ns;     -- Data valid to end of write
    tDH     : time :=   0       ns;     -- Data hold time
    tWP     : time :=  60       ns;     -- Write pulse width
    tAS     : time :=   0       ns;     -- Address setup time
    tWR     : time :=   5       ns;     -- Write recovery time
    tWLZ    : time :=   5       ns;     -- nWE to output Lo-Z
    tWHZ    : time :=        40 ns      -- nWE to output Hi-Z
);
port(
    X_1  : in    std_logic;  -- A14
    X_2  : in    std_logic;  -- A12
    X_3  : in    std_logic;  -- A7
    X_4  : in    std_logic;  -- A6
    X_5  : in    std_logic;  -- A5
    X_6  : in    std_logic;  -- A4
    X_7  : in    std_logic;  -- A3
    X_8  : in    std_logic;  -- A2
    X_9  : in    std_logic;  -- A1
    X_10 : in    std_logic;  -- A0
    X_11 : inout std_logic;  -- IO0
    X_12 : inout std_logic;  -- IO1
    X_13 : inout std_logic;  -- IO2
    X_14 : inout std_logic;  -- GND
    X_15 : inout std_logic;  -- IO3
    X_16 : inout std_logic;  -- IO4 
    X_17 : inout std_logic;  -- IO5
    X_18 : inout std_logic;  -- IO6
    X_19 : inout std_logic;  -- IO7
    X_20 : in    std_logic;  -- CS\
    X_21 : in    std_logic;  -- A10
    X_22 : in    std_logic;  -- OE\
    X_23 : in    std_logic;  -- A11
    X_24 : in    std_logic;  -- A9
    X_25 : in    std_logic;  -- A8
    X_26 : in    std_logic;  -- A13
    X_27 : in    std_logic;  -- WE\
    X_28 : inout std_logic   -- Vcc
);
end entity MB84256;

architecture BEHAV of MB84256 is
    signal D, Q : std_logic_vector( 7 downto 0);
    signal A    : std_logic_vector(14 downto 0);
    
    alias nCS is X_20;
    alias nOE is X_22;
    alias nWE is X_27;
    
    constant finit : boolean := fname /= "";    -- Initialise at power-up, if file defined
    
begin
          (X_19, X_18, X_17, X_16, X_15, X_13, X_12, X_11) <= Q;   -- Bidirectional bus
    D  <= (X_19, X_18, X_17, X_16, X_15, X_13, X_12, X_11);
    A  <= (X_1, X_26, X_2, X_23, X_21, X_24, X_25, X_3, X_4, X_5, X_6, X_7, X_8, X_9, X_10);
    
    MB: sram
    generic map(
        value_on_power_up       => 'U',     -- Memory array is filled with this at start
        download_on_power_up    => finit,   -- if TRUE, RAM is downloaded at start of simulation 
        trace_ram_load          => FALSE,   -- Echoes the data downloaded to the RAM on the screen
        enable_nWE_only_control => FALSE,   -- Read-/write access controlled by nWE only

        -- READ-cycle timing parameters
        tAA_max                 => tAA,     -- Address Access Time
        tOHA_min                => tOH,     -- Output Hold Time
        tACE_max                => tACS,    -- nCE/CE2 Access Time
        tDOE_max                => tOE,     -- nOE Access Time
        tLZOE_min               => tOLZ,    -- nOE to Low-Z Output
        tHZOE_max               => tOHZ,    --  OE to High-Z Output
        tLZCE_min               => tCLZ,    -- nCE/CE2 to Low-Z Output
        tHZCE_max               => tCHZ,    --  CE/nCE2 to High Z Output
 
        -- WRITE-cycle timing parameters
        tWC_min                 => tWC,     -- Write Cycle Time
        tSCE_min                => tCW,     -- nCE/CE2 to Write End
        tAW_min                 => tAW,     -- tAW Address Set-up Time to Write End
        tHA_min                 => tWR,     -- tHA Address Hold from Write End
        tSA_min                 => tAS,     -- Address Set-up Time
        tPWE_min                => tWP,     -- nWE Pulse Width
        tSD_min                 => tDW,     -- Data Set-up to Write End
        tHD_min                 => tDH,     -- Data Hold from Write End
        tHZWE_max               => tWHZ,    -- nWE Low to High-Z Output
        tLZWE_min               => tWLZ     -- nWE High to Low-Z Output
    )
    port map(
        nCE                     => nCS,     -- low-active Chip-Enable of the SRAM device; defaults to '1' (inactive)
        nOE                     => nOE,     -- low-active Output-Enable of the SRAM device; defaults to '1' (inactive)
        nWE                     => nWE,     -- low-active Write-Enable of the SRAM device; defaults to '1' (inactive)
        A                       => A,       -- address bus of the SRAM device
        D                       => D,       -- data bus to the SRAM device
        Q                       => Q,       -- data bus from the SRAM device
        CE2                     => '1',     -- high-active Chip-Enable of the SRAM device; defaults to '1'  (active) 
        download                => FALSE,   -- A FALSE-to-TRUE transition on this signal downloads the data
        download_filename       => fname,   -- name of the download source file
        dump                    => FALSE,   -- A FALSE-to-TRUE transition on this signal dumps data
        dump_start              => 0,       -- Written to the dump-file are the memory words from memory address 
        dump_end                => 0,       -- dump_start to address dump_end (default: all addresses)
        dump_filename           => ""       -- name of the dump destination file
    );
end architecture BEHAV;
    
-----------------------------------------------------------------------
-- CY7C1021-V33: 64K x 16 CMOS static RAM (Cypress)
-----------------------------------------------------------------------
library ieee;
    use ieee.std_logic_1164.all;

    use work.LSTTL.all;
    use work.TTLPrivate.all;
    use work.Memories.all;

entity CY7C1021 is
generic(
    fnevn : String := "";           -- Name of even-byte initialisation file (if any)
    fnodd : String := "";           -- Name of odd-byte  initialisation file (if any)
    -- READ CYCLE     Min  Max
    tRC    : time :=   10      ns;  -- Read Cycle Time              
    tAA    : time :=        10 ns;  -- Address to Data Valid        
    tOHA   : time :=    3      ns;  -- Data Hold from Address Change
    tACE   : time :=        10 ns;  -- CE LOW to Data Valid         
    tDOE   : time :=         5 ns;  -- OE LOW to Data Valid         
    tLZOE  : time :=    0      ns;  -- OE LOW to Low Z              
    tHZOE  : time :=         5 ns;  -- OE HIGH to High Z            
    tLZCE  : time :=    3      ns;  -- CE LOW to Low Z              
    tHZCE  : time :=         5 ns;  -- CE HIGH to High Z            
    tPU    : time :=    0      ns;  -- CE LOW to Power-Up           
    tPD    : time :=        10 ns;  -- CE HIGH to Power-Down        
    tDBE   : time :=         5 ns;  -- Byte Enable to Data Valid    
    tLZBE  : time :=    0      ns;  -- Byte Enable to Low Z         
    tHZBE  : time :=         5 ns;  -- Byte Disable to High Z       
    -- WRITE CYCLE 
    tWC    : time :=   10      ns;  -- Write Cycle Time             
    tSCE   : time :=    8      ns;  -- CE LOW to Write End          
    tAW    : time :=    7      ns;  -- Address Set-Up to Write End  
    tHA    : time :=    0      ns;  -- Address Hold from Write End  
    tSA    : time :=    0      ns;  -- Address Set-Up to Write Start
    tPWE   : time :=    7      ns;  -- WE Pulse Width               
    tSD    : time :=    5      ns;  -- Data Set-Up to Write End     
    tHD    : time :=    0      ns;  -- Data Hold from Write End     
    tLZWE  : time :=    3      ns;  -- WE HIGH to Low Z             
    tHZWE  : time :=         5 ns;  -- WE LOW to High Z             
    tBW    : time :=    7      ns   -- Byte Enable to End of Write  
);
port(
    X_1    : in    std_logic;       -- A4
    X_2    : in    std_logic;       -- A3
    X_3    : in    std_logic;       -- A2
    X_4    : in    std_logic;       -- A1
    X_5    : in    std_logic;       -- A0
    X_6    : in    std_logic;       -- CE\
    X_7    : inout std_logic;       -- IO0
    X_8    : inout std_logic;       -- IO1
    X_9    : inout std_logic;       -- IO2
    X_10   : inout std_logic;       -- IO3
    X_11   : inout std_logic;       -- Vcc
    X_12   : inout std_logic;       -- GND
    X_13   : inout std_logic;       -- IO4
    X_14   : inout std_logic;       -- IO5 
    X_15   : inout std_logic;       -- IO6
    X_16   : inout std_logic;       -- IO7
    X_17   : in    std_logic;       -- WE\
    X_18   : inout std_logic;       -- A15
    X_19   : inout std_logic;       -- A14
    X_20   : inout std_logic;       -- A13
    X_21   : inout std_logic;       -- A12
--  X_22                            
--  X_23                            
    X_24   : in    std_logic;       -- A11
    X_25   : in    std_logic;       -- A10
    X_26   : in    std_logic;       -- A9
    X_27   : in    std_logic;       -- A8
--  X_28                            
    X_29   : inout std_logic;       -- IO8
    X_30   : inout std_logic;       -- IO9
    X_31   : inout std_logic;       -- IO10
    X_32   : inout std_logic;       -- IO11
    X_33   : inout std_logic;       -- VCC
    X_34   : inout std_logic;       -- GND 
    X_35   : inout std_logic;       -- IO12
    X_36   : inout std_logic;       -- IO13
    X_37   : inout std_logic;       -- IO14
    X_38   : inout std_logic;       -- IO15
    X_39   : in    std_logic;       -- BLE\
    X_40   : in    std_logic;       -- BHE\
    X_41   : in    std_logic;       -- OE\
    X_42   : in    std_logic;       -- A7
    X_43   : in    std_logic;       -- A6
    X_44   : in    std_logic        -- A5
);
end entity CY7C1021;

architecture BEHAV of CY7C1021 is
    signal D1, Q1, D2, Q2 : std_logic_vector( 7 downto 0);
    signal AD             : std_logic_vector(15 downto 0);
    signal CE1, CE2       : std_logic;

    constant finitE : boolean := fnevn /= "";    -- Initialise at power-up, if file defined
    constant finitO : boolean := fnodd /= "";
    
    alias nCE  is X_6;
    alias nWE  is X_17;
    alias nBLE is X_39;
    alias nBHE is X_40;
    alias nOE  is X_41;
    
begin
          (X_16, X_15, X_14, X_13, X_10, X_9,  X_8,  X_7 ) <= Q1;  -- Bidirectional bus
    D1 <= (X_16, X_15, X_14, X_13, X_10, X_9,  X_8,  X_7 );
          (X_38, X_37, X_36, X_35, X_32, X_31, X_30, X_29) <= Q2;  -- Bidirectional bus
    D2 <= (X_38, X_37, X_36, X_35, X_32, X_31, X_30, X_29);
    AD <= (X_18, X_19, X_20, X_21, X_24, X_25, X_26, X_27, 
             X_42, X_43, X_44, X_1,  X_2,  X_3,  X_4,  X_5 );
    CE1 <= not nBLE;
    CE2 <= not nBHE;
    
    LB: sram         -- Generic RAM component
    generic map(
        value_on_power_up    => 'U',        -- Memory array is filled with this at start
        download_on_power_up => finitE,     -- if TRUE, RAM is downloaded at start of simulation 
        trace_ram_load       => false,      -- Echoes the data downloaded to the RAM on the screen
        enable_nWE_only_control => false,   -- Read-/write access controlled by nWE only
        -- READ-cycle timing parameters
        tAA_max           => tAA,           -- Address Access Time
        tOHA_min          => tOHA,          -- Output Hold Time
        tACE_max          => tACE,          -- nCE/CE2 Access Time
        tDOE_max          => tDOE,          -- nOE Access Time
        tLZOE_min         => tLZOE,         -- nOE to Low-Z Output
        tHZOE_max         => tHZOE,         --  OE to High-Z Output
        tLZCE_min         => tLZCE,         -- nCE/CE2 to Low-Z Output
        tHZCE_max         => tHZCE,         --  CE/nCE2 to High Z Output
 
        -- WRITE-cycle timing parameters
        tWC_min           => tWC,           -- Write Cycle Time
        tSCE_min          => tSCE,          -- nCE/CE2 to Write End
        tAW_min           => tAW,           -- tAW Address Set-up Time to Write End
        tHA_min           => tHA,           -- tHA Address Hold from Write End
        tSA_min           => tSA,           -- Address Set-up Time
        tPWE_min          => tPWE,          -- nWE Pulse Width
        tSD_min           => tSD,           -- Data Set-up to Write End
        tHD_min           => tHD,           -- Data Hold from Write End
        tHZWE_max         => tHZWE,         -- nWE Low to High-Z Output
        tLZWE_min         => tLZWE          -- nWE High to Low-Z Output
    )
    port map(
        nCE               => nCE,           -- low-active Chip-Enable of the SRAM device; defaults to '1' (inactive)
        nOE               => nOE,           -- low-active Output-Enable of the SRAM device; defaults to '1' (inactive)
        nWE               => nWE,           -- low-active Write-Enable of the SRAM device; defaults to '1' (inactive)
        A                 => AD,            -- address bus of the SRAM device
        D                 => D1,            -- data bus to the SRAM device
        Q                 => Q1,            -- data bus from the SRAM device
        CE2               => CE1,           -- high-active Chip-Enable of the SRAM device; defaults to '1'  (active) 
        download          => false,         -- A FALSE-to-TRUE transition on this signal downloads the data
        download_filename => "fnevn"        -- name of the download source file
    );

    HB: sram         -- Generic RAM component
    generic map(
        value_on_power_up       => 'U',     -- Memory array is filled with this at start
        download_on_power_up    => finitO,  -- if TRUE, RAM is downloaded at start of simulation 
        trace_ram_load          => false,   -- Echoes the data downloaded to the RAM on the screen
        enable_nWE_only_control => false,   -- Read-/write access controlled by nWE only
        -- READ-cycle timing parameters
        tAA_max           => tAA,           -- Address Access Time
        tOHA_min          => tOHA,          -- Output Hold Time
        tACE_max          => tACE,          -- nCE/CE2 Access Time
        tDOE_max          => tDOE,          -- nOE Access Time
        tLZOE_min         => tLZOE,         -- nOE to Low-Z Output
        tHZOE_max         => tHZOE,         --  OE to High-Z Output
        tLZCE_min         => tLZCE,         -- nCE/CE2 to Low-Z Output
        tHZCE_max         => tHZCE,         --  CE/nCE2 to High Z Output
 
        -- WRITE-cycle timing parameters
        tWC_min           => tWC,           -- Write Cycle Time
        tSCE_min          => tSCE,          -- nCE/CE2 to Write End
        tAW_min           => tAW,           -- tAW Address Set-up Time to Write End
        tHA_min           => tHA,           -- tHA Address Hold from Write End
        tSA_min           => tSA,           -- Address Set-up Time
        tPWE_min          => tPWE,          -- nWE Pulse Width
        tSD_min           => tSD,           -- Data Set-up to Write End
        tHD_min           => tHD,           -- Data Hold from Write End
        tHZWE_max         => tHZWE,         -- nWE Low to High-Z Output
        tLZWE_min         => tLZWE          -- nWE High to Low-Z Output
    )
    port map(
        nCE               => nCE,           -- low-active Chip-Enable of the SRAM device; defaults to '1' (inactive)
        nOE               => nOE,           -- low-active Output-Enable of the SRAM device; defaults to '1' (inactive)
        nWE               => nWE,           -- low-active Write-Enable of the SRAM device; defaults to '1' (inactive)
        A                 => AD,            -- address bus of the SRAM device
        D                 => D2,            -- data bus to the SRAM device
        Q                 => Q2,            -- data bus from the SRAM device
        CE2               => CE2,           -- high-active Chip-Enable of the SRAM device; defaults to '1'  (active) 
        download          => false,         -- A FALSE-to-TRUE transition on this signal downloads the data
        download_filename => "fnodd"        -- name of the download source file
    );
end architecture BEHAV;  
