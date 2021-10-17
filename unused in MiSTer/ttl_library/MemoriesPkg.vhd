-----------------------------------------------------------------------
-- Static RAM models (VHDL)                                          --
-- David R Brooks                                                    --
-- December, 2016.  Perth, Australia                                 --
-- Compliance: VHDL 2008                                             --
-- NB Simulation only: they are NOT synthesizable.                   --
-- Based on: Manufacturers data sheets                               --
-- Pinouts & naming agree with Altium libraries & VHDL netlister.    --
-----------------------------------------------------------------------
library ieee;
    use ieee.std_logic_1164.all;

package MEMORIES is

-----------------------------------------------------------------------
-- Generic SRAM model, see https://tams.informatik.uni-hamburg.de/vhdl/models/sram/sram.html
-----------------------------------------------------------------------
component sram is
    generic (
        value_on_power_up    : std_logic := 'U';    -- Memory array is filled with this at start
        download_on_power_up : boolean   := TRUE;   -- if TRUE, RAM is downloaded at start of simulation 
        trace_ram_load       : boolean   := TRUE;   -- Echoes the data downloaded to the RAM on the screen
                                                    --   (included for debugging purposes)
        enable_nWE_only_control: boolean := TRUE;   -- Read-/write access controlled by nWE only
                                                    --   nOE may be kept active all the time
        -- READ-cycle timing parameters
        tAA_max     : TIME               := 20 NS;  -- Address Access Time
        tOHA_min    : TIME               :=  3 NS;  -- Output Hold Time
        tACE_max    : TIME               := 20 NS;  -- nCE/CE2 Access Time
        tDOE_max    : TIME               :=  8 NS;  -- nOE Access Time
        tLZOE_min   : TIME               :=  0 NS;  -- nOE to Low-Z Output
        tHZOE_max   : TIME               :=  8 NS;  --  OE to High-Z Output
        tLZCE_min   : TIME               :=  3 NS;  -- nCE/CE2 to Low-Z Output
        tHZCE_max   : TIME               := 10 NS;  --  CE/nCE2 to High Z Output
 
        -- WRITE-cycle timing parameters
        tWC_min     : TIME               := 20 NS;  -- Write Cycle Time
        tSCE_min    : TIME               := 18 NS;  -- nCE/CE2 to Write End
        tAW_min     : TIME               := 15 NS;  -- tAW Address Set-up Time to Write End
        tHA_min     : TIME               :=  0 NS;  -- tHA Address Hold from Write End
        tSA_min     : TIME               :=  0 NS;  -- Address Set-up Time
        tPWE_min    : TIME               := 13 NS;  -- nWE Pulse Width
        tSD_min     : TIME               := 10 NS;  -- Data Set-up to Write End
        tHD_min     : TIME               :=  0 NS;  -- Data Hold from Write End
        tHZWE_max   : TIME               := 10 NS;  -- nWE Low to High-Z Output
        tLZWE_min   : TIME               :=  0 NS   -- nWE High to Low-Z Output
    );

    port (
        nCE         : in    std_logic    := '1';    -- low-active Chip-Enable of the SRAM device; defaults to '1' (inactive)
        nOE         : in    std_logic    := '1';    -- low-active Output-Enable of the SRAM device; defaults to '1' (inactive)
        nWE         : in    std_logic    := '1';    -- low-active Write-Enable of the SRAM device; defaults to '1' (inactive)
        A           : in    std_logic_vector;       -- address bus of the SRAM device
        D           : in    std_logic_vector;       -- data bus to the SRAM device
        Q           : out   std_logic_vector;       -- data bus from the SRAM device
        CE2         : in    std_logic    := '1';    -- high-active Chip-Enable of the SRAM device; defaults to '1'  (active) 
        download    : in    boolean      := FALSE;  -- A FALSE-to-TRUE transition on this signal downloads the data
                                                    --   in file specified by download_filename to the RAM
        download_filename: in string := "sram_load.dat";  -- name of the download source file
                                                          --            Passing the filename via a port of type
                                                          -- ********** string may cause a problem with some
                                                          -- WATCH OUT! simulators. The string signal assigned
                                                          -- ********** to the port at least should have the
                                                          --            same length as the default value.
        dump        : in    boolean      := FALSE;  -- A FALSE-to-TRUE transition on this signal dumps
                                                    --   the current content of the memory to the file
                                                    --   specified by dump_filename.
        dump_start  : in    natural      := 0;      -- Written to the dump-file are the memory words from memory address 
        dump_end    : in    natural      := 0;      -- dump_start to address dump_end (default: all addresses)
        dump_filename:in    string := "sram_dump.dat"  -- name of the dump destination file
                                                       -- (See note at port  download_filename)
    );
end component sram;


-----------------------------------------------------------------------
-- HM6116, TMM2016 : 2K x 8 CMOS static RAM (HMI, Texas)
-----------------------------------------------------------------------
component HM6116 is
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
    tWLZ  : time   :=  5        ns; -- Write to OP Lo-Z (not used)
    tOHZW : time   :=        30 ns; -- OE to OP Hi-Z
    tOW   : time   :=  5        ns  -- OP active from end of write
);
port(
    X_1  : in    std_logic;  -- A7
    X_2  : in    std_logic;  -- A6
    X_3  : in    std_logic;  -- A5
    X_4  : in    std_logic;  -- A4
    X_5  : in    std_logic;  -- A3
    X_6  : in    std_logic;  -- A2
    X_7  : in    std_logic;  -- A1
    X_8  : in    std_logic;  -- A0
    X_9  : inout std_logic;  -- IO0
    X_10 : inout std_logic;  -- IO1
    X_11 : inout std_logic;  -- IO2
    X_12 : inout std_logic;  -- GND
    X_13 : inout std_logic;  -- IO3
    X_14 : inout std_logic;  -- IO4 
    X_15 : inout std_logic;  -- IO5
    X_16 : inout std_logic;  -- IO6
    X_17 : inout std_logic;  -- IO7
    X_18 : in    std_logic;  -- CS\
    X_19 : in    std_logic;  -- A10
    X_20 : in    std_logic;  -- OE\
    X_21 : in    std_logic;  -- WE\
    X_22 : in    std_logic;  -- A9
    X_23 : in    std_logic;  -- A8
    X_24 : inout std_logic   -- Vcc
);
end component HM6116;

-----------------------------------------------------------------------
-- IS61C1024-20: 128K x 8 CMOS static RAM (ISSI)
-----------------------------------------------------------------------
component IS61C1024 is
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
end component IS61C1024;

-----------------------------------------------------------------------
-- MB84256A-10LL : 2K x 8 CMOS static RAM (Fujitsu, 100 ns)
-----------------------------------------------------------------------
component MB84256 is
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
    X_26 : inout std_logic;  -- A13
    X_27 : in    std_logic;  -- WE\
    X_28 : inout std_logic   -- Vcc
);
end component MB84256;

-----------------------------------------------------------------------
-- CY7C1021-V33: 64K x 16 CMOS static RAM (Cypress)
-----------------------------------------------------------------------
component CY7C1021 is
generic(
    fnevn : String := "";           -- Name of even-byte initialisation file (if any)
    fnodd : String := "";           -- Name of odd-byte  initialisation file (if any)
    --               min    max
    tRC   : time   := 20        ns; -- Read cycle
    tAA   : time   :=        20 ns; -- Address access
    tACS  : time   :=        20 ns; -- Chip select access
    tAOE  : time   :=         9 ns; -- OE\ to output valid
    tCLZ  : time   :=  5        ns; -- CS\ to output valid
    tOLZ  : time   :=  5        ns; -- OE\ to output valid
    tCHZ  : time   :=        20 ns; -- CS  to output Hi-Z
    tOHZR : time   :=        20 ns; -- OE  to output Hi-Z
    tOH   : time   :=  3        ns; -- OP hold from addr change
    
    tWC   : time   := 20        ns; -- Write cycle
    tCW   : time   := 15        ns; -- CS to end of write
--    tAW   : time   := 70        ns; -- Address valid to end of write
    tAS   : time   := 15        ns; -- Address setup time
    tDS   : time   := 10        ns; -- Data setup time
    tWP   : time   := 12        ns; -- Write pulse width
    tWR   : time   :=  0        ns; -- Write recovery time
    tDW   : time   := 30        ns; -- Data valid to end of write
    tDH   : time   :=  0        ns; -- Data hold from end of write
    tWHZ  : time   :=        25 ns; -- Write to OP Hi-Z
--  tWLZ  : time   :=  5        ns; -- Write to OP Lo-Z    
    tOHZW : time   :=        30 ns; -- OE to OP Hi-Z
    tOW   : time   :=  5        ns  -- OP active from end of write
);
port(
    X_1  : in    std_logic;  -- A4
    X_2  : in    std_logic;  -- A3
    X_3  : in    std_logic;  -- A2
    X_4  : in    std_logic;  -- A1
    X_5  : in    std_logic;  -- A0
    X_6  : in    std_logic;  -- CE\
    X_7  : inout std_logic;  -- IO0
    X_8  : inout std_logic;  -- IO1
    X_9  : inout std_logic;  -- IO2
    X_10 : inout std_logic;  -- IO3
    X_11 : inout std_logic;  -- Vcc
    X_12 : inout std_logic;  -- GND
    X_13 : inout std_logic;  -- IO4
    X_14 : inout std_logic;  -- IO5 
    X_15 : inout std_logic;  -- IO6
    X_16 : inout std_logic;  -- IO7
    X_17 : in    std_logic;  -- WE\
    X_18 : inout std_logic;  -- A15
    X_19 : inout std_logic;  -- A14
    X_20 : inout std_logic;  -- A13
    X_21 : inout std_logic;  -- A12
--  X_22
--  X_23
    X_24 : in    std_logic;  -- A11
    X_25 : in    std_logic;  -- A10
    X_26 : in    std_logic;  -- A9
    X_27 : in    std_logic;  -- A8
--  X_28
    X_29 : inout std_logic;  -- IO8
    X_30 : inout std_logic;  -- IO9
    X_31 : inout std_logic;  -- IO10
    X_32 : inout std_logic;  -- IO11
    X_33 : inout std_logic;  -- VCC
    X_34 : inout std_logic;  -- GND 
    X_35 : inout std_logic;  -- IO12
    X_36 : inout std_logic;  -- IO13
    X_37 : inout std_logic;  -- IO14
    X_38 : inout std_logic;  -- IO15
    X_39 : in    std_logic;  -- BLE\
    X_40 : in    std_logic;  -- BHE\
    X_41 : in    std_logic;  -- OE\
    X_42 : in    std_logic;  -- A7
    X_43 : in    std_logic;  -- A6
    X_44 : in    std_logic   -- A5
);
end component CY7C1021;

end package MEMORIES;
