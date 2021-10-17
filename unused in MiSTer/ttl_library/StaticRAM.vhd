-- ======================================================================================
--       A generic VHDL entity for a typical SRAM with complete timing parameters
--
--                   Static memory,  version 1.3     9. August 1996
--                                   Changes by D. R. Brooks, see below
-- ======================================================================================
--
-- (C) Andre' Klindworth, Dept. of Computer Science
--                        University of Hamburg
--                        Vogt-Koelln-Str. 30
--                        22527 Hamburg
--                        klindwor@informatik.uni-hamburg.de
--
-- This VHDL code may be freely copied as long as the copyright note isn't removed from 
-- its header. Full affiliation of anybody modifying this file shall be added to the
-- header prior to further distribution.
-- The download procedure originates from DLX memory-behaviour.vhdl: 
--                    Copyright (C) 1993, Peter J. Ashenden
--                    Mail:       Dept. Computer Science
--                                University of Adelaide, SA 5005, Australia
--                    e-mail:     petera@cs.adelaide.edu.au
--
-- Changes by D. R. Brooks, Perth, Australia.  <daveb@iinet.net.au>
--   1. Changed file statements to suit VHDL-2008
--   2. Removed references to obsolete package "IEEE.std_logic_unsigned"
--   3. Array initialisation is by specifying the value, not a boolean.
--   4. Cleaned up tabbing.
--   5. Array size is inferred from the connected address & data busses.
--   6. IO is split into IN & OUT ports, to facilitate higher-level connections.
-- 
-- Features:
--
--  o  generic memory size, width and timing parameters
--
--  o  18 typical SRAM timing parameters supported
--
--  o  clear-on-power-up and/or download-on-power-up if requested by generic
--
--  o  RAM dump into or download from an ASCII-file at any time possible 
--     (requested by signal)
--   
--  o  pair of active-low and active-high Chip-Enable signals 
--
--  o  nWE-only memory access control
--
--  o  many (but not all) timing and access control violations reported by assertions
-- 
--
--
-- RAM data file format:
--
-- The format of the ASCII-files for RAM download or dump is very simple:
-- Each line of the file consists of the memory address (given as a decimal number).
-- and the corresponding RAM data at this address (given as a binary number).
-- Any text in a line following the width-th digit of the binary number is ignored.
-- Please notice that address and data have to be seperated by a SINGLE blank,
-- that the binary number must have as many digits as specified by the generic  width,
-- and that no additional blanks or blank lines are tolerated. Example:
--                
--            0 0111011010111101 This text is interpreted as a comment
--            1 1011101010110010 
--            17 0010001001000100
--
--
-- Hints & traps:
--
-- If you have problems using this model, please feel free to to send me an e-mail.
-- Here are some potential problems which have been reported to me:
--
--    o There's a potential problem with passing the filenames for RAM download or
--      dump via port signals of type string. E.g. for Synopsys VSS, the string
--      assigned to a filename-port should have the same length as its default value.
--      If you are sure that you need a download or dump only once during a single
--      simulation run, you may remove the filename-ports from the interface list
--      and replace the constant string in the corresponding file declarations.
--
--    o Some simulators do not implement all of the standard TEXTIO-functions as
--      specified by the IEEE Std 1076-87 and IEEE Std 1076-93. Check it out.
--      If any of the (multiple overloaded) writeline, write, readline or
--      read functions that are used in this model is missing, you have to
--      write your own version and you should complain at your simulator tool
--      vendor for this deviation from the standard.
--
--    o If you are about to simulate a large RAM e.g. 4M * 32 Bit, representing
--      the RAM with a static array variable of 4 * 32 std_logic values uses a large 
--      amount of memory and may result in an out-of-memory error. A potential remedy 
--      for this is to use a dynamic data type, allocating memory for small blocks of
--      RAM data (e.g. a single word) only if they are actually referenced during a 
--      simulation run. A version of the SRAM model with dynamic memory allocation
--      shall be available at the same WWW-site were you obtained this file or at:
--        http://tech-www.informatik.uni-hamburg.de/vhdl/models/sram/sram.html
--      
--
-- Bugs:
--
--   No severe bugs have been found so far. Please report any bugs:
--   e-mail: klindwor@informatik.uni-hamburg.de
--
--   Bug Observed: ModelSim SE-64 vcom 10.1c crashes with Code 211 (segmentation fault), when
--     'DELAYED is applied to a std_logic_vector. 'DELAYED works on single std_logic, but
--     fails when used on an array element (Attribute "DELAYED" requires a static signal prefix).
--
   
   
library ieee;
    use ieee.std_logic_1164.all;
    use ieee.numeric_std.all;
    
use std.textio.all;

ENTITY sram IS
    GENERIC (
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
    PORT (
        nCE         : IN    std_logic    := '1';    -- low-active Chip-Enable of the SRAM device; defaults to '1' (inactive)
        nOE         : IN    std_logic    := '1';    -- low-active Output-Enable of the SRAM device; defaults to '1' (inactive)
        nWE         : IN    std_logic    := '1';    -- low-active Write-Enable of the SRAM device; defaults to '1' (inactive)
        A           : IN    std_logic_vector;       -- address bus of the SRAM device
        D           : IN    std_logic_vector;       -- data bus to the SRAM device
        Q           : OUT   std_logic_vector;       -- data bus from the SRAM device
        CE2         : IN    std_logic    := '1';    -- high-active Chip-Enable of the SRAM device; defaults to '1'  (active) 
        download    : IN    boolean      := FALSE;  -- A FALSE-to-TRUE transition on this signal downloads the data
                                                    --   in file specified by download_filename to the RAM
        download_filename: IN string := "sram_load.dat";  -- name of the download source file
                                                          --            Passing the filename via a port of type
                                                          -- ********** string may cause a problem with some
                                                          -- WATCH OUT! simulators. The string signal assigned
                                                          -- ********** to the port at least should have the
                                                          --            same length as the default value.
        dump        : IN    boolean      := FALSE;  -- A FALSE-to-TRUE transition on this signal dumps
                                                    --   the current content of the memory to the file
                                                    --   specified by dump_filename.
        dump_start  : IN    natural      := 0;      -- Written to the dump-file are the memory words from memory address 
        dump_end    : IN    natural      := 0;      -- dump_start to address dump_end (default: all addresses)
        dump_filename:IN    string := "sram_dump.dat"  -- name of the dump destination file
                                                       -- (See note at port  download_filename)
    );
END entity sram;


ARCHITECTURE behavior OF sram IS
    subtype ibyte    is integer range 0 to 255;       -- 8-bit integer
    type    iline    is array(0 to 299) of ibyte;
    
    constant dwidth : positive := D'length;
    constant awidth : positive := A'length;
    constant nwords : positive := 2**awidth;

    -----------------------------------------------------------------------
    -- Return TRUE if all bits are '0' or '1'
    -----------------------------------------------------------------------
    FUNCTION Check_For_Valid_Data (a: std_logic_vector) RETURN BOOLEAN IS
        VARIABLE result: BOOLEAN;
    BEGIN
        result := TRUE;
        FOR i IN a'RANGE LOOP
            result := (a(i) = '0') OR (a(i) = '1');
            IF NOT result THEN 
                EXIT;
            END IF;
        END LOOP;
    RETURN result;
    END Check_For_Valid_Data;

    -----------------------------------------------------------------------
    -- Return TRUE if all bits are 'Z'
    -----------------------------------------------------------------------
    FUNCTION Check_For_Tristate (a: std_logic_vector) RETURN BOOLEAN IS
        VARIABLE result: BOOLEAN;
    BEGIN
        result := TRUE;
        FOR i IN a'RANGE LOOP
            result := (a(i) = 'Z');
            IF NOT result THEN 
                EXIT;
            END IF;
        END LOOP;
    RETURN result;
    END Check_For_Tristate;
 
    -----------------------------------------------------------------------
    -- Global signals
    -----------------------------------------------------------------------
    constant tristate_vec   : std_logic_vector(D'RANGE) := (others=> 'Z');
    constant undef_vec      : std_logic_vector(D'RANGE) := (others=> 'X');
    constant init_vec       : std_logic_vector(D'RANGE) := (others=> value_on_power_up);
    constant undef_adr_vec  : std_logic_vector(A'RANGE) := (others=> 'X');
    
    SIGNAL read_active      : BOOLEAN   := FALSE;           -- Indicates whether the SRAM is sending on the D bus
    SIGNAL read_valid       : BOOLEAN   := FALSE;           -- If TRUE, the data output by the RAM is valid
    SIGNAL read_data        : std_logic_vector(D'RANGE);    -- content of the memory location addressed by A
    SIGNAL do_write         : std_logic := '0';             --   A '0'->'1' transition on this signal marks
                                                            --   the moment when the data on D is stored in the
                                                            --   addressed memory location
    SIGNAL adr_setup        : std_logic_vector(A'RANGE);    -- delayed value of A to model the Address Setup Time
    SIGNAL adr_hold         : std_logic_vector(A'RANGE);    -- delayed value of A to model the Address Hold Time
    SIGNAL valid_adr        : std_logic_vector(A'RANGE);    -- valid memory address derived from A after
                                                            --   considering Address Setup and Hold Times

    signal DD1, DD2         : std_logic_vector(D'range);    -- Delayed versions of D
    
BEGIN

    -- vsim fails on std_logic_vector'DELAYED, so create explicit delayed versions here
    -- See body of process "memory"
    DD1 <= D;                   -- D'DELAYED
    DD2 <= D after tHD_min;     -- D'DELAYED(tHD_min)

    -----------------------------------------------------------------------
    -- The main task. The memory array is a private variable of this
    -- process.
    -----------------------------------------------------------------------
    memory: PROCESS
        CONSTANT low_address    : natural := 0;
        CONSTANT high_address   : natural := nwords -1; 

        TYPE memory_array IS
            ARRAY (natural RANGE low_address TO high_address) OF std_logic_vector(D'range);
            
        type     memptr is access memory_array;
        variable memp           : memptr := null;           -- Ptr. to memory array
        VARIABLE address        : natural;
        VARIABLE write_data     : std_logic_vector(D'range);
        
        -------------------------------------------------------------------
        -- Initialise array at start: this happens before any file-load
        -------------------------------------------------------------------
        PROCEDURE power_up (memp: inout memptr) IS
        BEGIN
            if memp = null then
                memp := new memory_array;
            end if;
            FOR add IN memp.all'range LOOP
                memp.all(add) := init_vec;
            END LOOP; 
        END power_up;

        -------------------------------------------------------------------
        -- Load binary file (see above for format) into array
        -------------------------------------------------------------------
        PROCEDURE load (memp: INOUT memptr; download_filename: IN string) IS
            FILE     source          : text;
            VARIABLE inline, outline : line;
            VARIABLE add             : natural;
            VARIABLE c               : character;
            VARIABLE source_line_nr  : integer   := 1;
            VARIABLE init_value      : std_logic := 'U';
        BEGIN
            write(output, string'("Loading SRAM from file ") & download_filename & string'(" ... ") );
            file_open(source, download_filename, READ_MODE);
            WHILE NOT endfile(source) LOOP
                readline(source, inline);
                read(inline, add);
                read(inline, c); 
                IF (c /= ' ') THEN
                    write(outline, string'("Syntax error in file '"));
                    write(outline, download_filename);
                    write(outline, string'("', line "));
                    write(outline, source_line_nr);
                    writeline(output, outline);
                    ASSERT FALSE
                        REPORT "RAM loader aborted."
                        SEVERITY FAILURE;
                END IF;
                FOR i IN D'range LOOP
                    read(inline, c);
                    case c is
                        when '0'    => memp.all(add)(i) := '0';
                        when '1'    => memp.all(add)(i) := '1';
                        when others =>
                            write(outline, string'("-W- Invalid character '"));
                            write(outline, c);
                            write(outline, string'("' in Bitstring in '"));
                            write(outline, download_filename);
                            write(outline, '(');
                            write(outline, source_line_nr);
                            write(outline, string'(") is set to '0'"));
                            writeline(output, outline);
                            memp.all(add)(i) := '0';
                    end case;
                END LOOP;
                IF (trace_ram_load) THEN
                    write(outline, string'("RAM["));
                    write(outline, add);
                    write(outline, string'("] :=  "));
                    write(outline, memp.all(add));
                    writeline(output, outline );
                END IF;
                source_line_nr := source_line_nr +1;
            END LOOP; -- WHILE
        file_close(source);
        END PROCEDURE load; 

        -------------------------------------------------------------------
        -- Write out the array (see above for format)
        -------------------------------------------------------------------
        PROCEDURE do_dump (memp: INOUT memptr; 
                        dump_start, dump_end: IN natural; 
                        dump_filename: IN string) IS
            FILE     dest   : text;
            VARIABLE l      : line;
            VARIABLE c      : character;
            variable d_top  : natural;
        BEGIN
            if dump_end = 0 then
                d_top := nwords-1;
            else
                d_top := dump_end;
            end if;
            IF (dump_start > d_top) OR (d_top >= nwords) THEN
                ASSERT FALSE
                    REPORT "Invalid addresses for memory dump. Cancelled."
                    SEVERITY ERROR;
            ELSE
                file_open(dest, dump_filename, READ_MODE);
                FOR add IN dump_start TO d_top LOOP
                    write(l, add);
                    write(l, ' ');
                    FOR i IN D'range LOOP
                        write(l, memp.all(add)(i));
                    END LOOP;
                    writeline(dest, l);
                END LOOP;
                file_close(dest);
            END IF;
        END PROCEDURE do_dump; 

    -----------------------------------------------------------------------
    -- Main process body
    -----------------------------------------------------------------------
    BEGIN
        power_up(memp);
        IF download_on_power_up THEN 
            load(memp, download_filename);
        END IF;
        LOOP    -- Forever (see WAIT at the end)
            IF do_write'EVENT and (do_write = '1') then     -- End of write: latch in the data
                IF NOT Check_For_Valid_Data(D) THEN
    -- D'DELAYED crashes VSIM (Code 211): apparently 'DELAYED only works on a single signal,
    -- not a vector (although it compiles OK.)
    -- So delayed versions of D are explicitly created, & used for these checks.
                    IF D'EVENT AND Check_For_Valid_Data(DD1) THEN   -- should be D'DELAYED
                        write(output, "-W- Data changes exactly at end-of-write to SRAM.");
                        write_data := DD1;                          -- should be D'delayed
                    ELSE
                        write(output, "-E- Data not valid at end-of-write to SRAM.");
                        write_data := undef_vec;
                    END IF;
                ELSIF NOT DD2'STABLE(tSD_min) THEN                  -- should be D'DELAYED(tHD_min)
    -- End of failing block
                   write(output, "-E- tSD violation: Data input changes within setup-time at end-of-write to SRAM.");
                   write_data := undef_vec;
                ELSIF NOT D'STABLE(tHD_min) THEN
                    write(output, "-E- tHD violation: Data input changes within hold-time at end-of-write to SRAM.");
                    write_data := undef_vec;
                ELSIF nWE'DELAYED(tHD_min)'STABLE(tPWE_min) THEN
                    write(output, "-E- tPWE violation: Pulse width of nWE too short at SRAM.");
                    write_data := undef_vec;
                ELSE 
                    write_data := D;
                END IF;
                memp.all(TO_INTEGER(unsigned(valid_adr))) := write_data;
            END IF;
            IF Check_For_Valid_Data(valid_adr) THEN
                read_data <= memp.all(TO_INTEGER(unsigned(valid_adr)));
            ELSE
                read_data <= undef_vec;
            END IF;
            IF dump AND dump'EVENT THEN 
                do_dump(memp, dump_start, dump_end, dump_filename);
            END IF;
            IF download AND download'EVENT THEN 
                load(memp, download_filename);
            END IF;
            WAIT ON do_write, valid_adr, dump, download;
        END LOOP;
    END PROCESS memory;

    -----------------------------------------------------------------------
    -- Signal delays
    -----------------------------------------------------------------------
  adr_setup <= TRANSPORT A AFTER tAA_max;
  adr_hold  <= TRANSPORT A AFTER tOHA_min;

  valid_adr   <= adr_setup WHEN Check_For_Valid_Data(adr_setup)
                                AND (adr_setup = adr_hold) 
                                AND adr_hold'STABLE(tAA_max - tOHA_min) ELSE
               undef_adr_vec;

  read_active <= ((nOE = '0') AND (nOE'DELAYED(tLZOE_min) = '0') AND nOE'STABLE(tLZOE_min) 
                   AND ((nWE = '1') OR (nWE'DELAYED(tHZWE_max) = '0'))
                   AND (nCE = '0') AND (CE2 = '1') AND nCE'STABLE(tLZCE_min) AND CE2'STABLE(tLZCE_min))
                 OR (read_active AND (nOE'DELAYED(tHZOE_max) = '0') 
                                 AND (nWE'DELAYED(tHZWE_max) = '1')
                                 AND (nCE'DELAYED(tHZCE_max) = '0') AND (CE2'DELAYED(tHZCE_max) = '1'));

  read_valid  <= ((nOE = '0') AND nOE'STABLE(tDOE_max) 
                   AND (nWE = '1') AND (nWE'DELAYED(tHZWE_max) = '1')
                   AND (nCE = '0') AND (CE2 = '1') AND nCE'STABLE(tACE_max) AND CE2'STABLE(tACE_max))
                 OR (read_valid AND read_active);

  Q           <= read_data WHEN read_valid and read_active ELSE
                 undef_vec WHEN not read_valid and read_active ELSE
                 tristate_vec;
       
    -----------------------------------------------------------------------
    -- Decode write command
    -----------------------------------------------------------------------
    PROCESS (nWE, nCE, CE2) 
    BEGIN
        IF  ((nCE = '1') OR (nWE = '1') OR (CE2 = '0'))
            AND (nCE'DELAYED = '0') AND (CE2'DELAYED = '1') AND (nWE'DELAYED = '0') -- End of Write
        THEN 
            do_write <= '1' AFTER tHD_min;
        ELSE 
            IF (Now > 10 NS) AND (nCE = '0') AND (CE2 = '1') AND (nWE = '0') -- Start of Write
            THEN            
                ASSERT Check_For_Valid_Data(A)
                    REPORT "Address not valid at start-of-write to RAM."
                    SEVERITY FAILURE;
                
                ASSERT A'STABLE(tSA_min)
                    REPORT "tSA violation: Address changed within setup-time at start-of-write to SRAM."
                    SEVERITY ERROR;
        
                ASSERT enable_nWE_only_control OR ((nOE = '1') AND nOE'STABLE(tSA_min))
                    REPORT "tSA violation: nOE not inactive at start-of-write to RAM."
                    SEVERITY ERROR;
            END IF;
            do_write <= '0';
        END IF;
    END PROCESS;

    -----------------------------------------------------------------------
    -- The following processes check for validity of the control signals at the
    -- SRAM interface. Removing them to speed up simulation will not affect the
    -- functionality of the SRAM model.      
    -----------------------------------------------------------------------
    -- Checks that an address change is allowed
    -----------------------------------------------------------------------
    PROCESS (A)
    BEGIN
        IF (Now > 0 NS) THEN  -- suppress obsolete error message at time 0
            ASSERT (nCE = '1') OR (CE2 = '0') OR (nWE = '1')
                REPORT "Address not stable while write-to-SRAM active"
                SEVERITY FAILURE;
        
            ASSERT (nCE = '1') OR (CE2 = '0') OR (nWE = '1')
                    OR (nCE'DELAYED(tHA_min) = '1') OR (CE2'DELAYED(tHA_min) = '0')
                    OR (nWE'DELAYED(tHA_min) = '1')
                REPORT "tHA violation: Address changed within hold-time at end-of-write to SRAM."
                SEVERITY FAILURE;
        END IF;
    END PROCESS;

    -----------------------------------------------------------------------
    -- Checks that control signals at RAM are valid all the time
    -----------------------------------------------------------------------
    PROCESS (nOE, nWE, nCE, CE2)
    BEGIN
        IF (Now > 0 NS) AND (nCE /= '1') AND (CE2 /= '0') THEN
            IF (nCE = '0') AND (CE2 = '1') THEN
                ASSERT (nWE = '0') OR (nWE = '1')
                    REPORT "Invalid nWE-signal at SRAM while nCE is active"
                    SEVERITY WARNING;
            ELSE
                IF (nCE /= '0') THEN  
                    ASSERT (nOE = '1')  
                        REPORT "Invalid nCE-signal at SRAM while nOE not inactive"
                        SEVERITY WARNING;
                
                    ASSERT (nWE = '1')
                        REPORT "Invalid nCE-signal at SRAM while nWE not inactive"
                        SEVERITY ERROR;
                END IF;
                IF (CE2 /= '1') THEN  
                    ASSERT (nOE = '1')  
                        REPORT "Invalid CE2-signal at SRAM while nOE not inactive"
                        SEVERITY WARNING;
                
                    ASSERT (nWE = '1')
                        REPORT "Invalid CE2-signal at SRAM while nWE not inactive"
                        SEVERITY ERROR;
                END IF;
            END IF;
        END IF;
    END PROCESS;

END behavior;
