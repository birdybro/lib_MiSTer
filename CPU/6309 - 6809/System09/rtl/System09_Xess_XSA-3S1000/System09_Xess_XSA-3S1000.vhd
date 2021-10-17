--===========================================================================----
--
--  S Y N T H E Z I A B L E    System09 - SOC.
--
--  www.OpenCores.Org - February 2007
--  This core adheres to the GNU public license  
--
-- File name      : System09_Xess_XSA-3S1000.vhd
--
-- Purpose        : Top level file for 6809 compatible system on a chip
--                  Designed with Xilinx XC3S1000 Spartan 3 FPGA.
--                  Implemented With XESS XSA-3S1000 FPGA board.
--                  *** Note ***
--                  This configuration can run Flex9 however it only has
--                  32k bytes of user memory and the VDU is monochrome
--                  The design needs to be updated to use the SDRAM on 
--                  the XSA-3S1000 board.
--                  This configuration also lacks a DAT so cannot use
--                  the RAM Disk features of SYS09BUG.
--
-- Dependencies   : ieee.Std_Logic_1164
--                  ieee.std_logic_unsigned
--                  ieee.std_logic_arith
--                  ieee.numeric_std
--                  unisim.vcomponents
--
-- Uses           : mon_rom    (sys09bug_rom4k_b16.vhd) Sys09Bug Monitor ROM
--                  cpu09      (cpu09.vhd)          CPU core
--                  ACIA_6850  (ACIA_6850.vhd)      ACIA / UART
--                             (ACIA_RX.vhd)
--                             (ACIA_TX.vhd)
--                  ACIA_Clock (ACIA_Clock.vhd)      ACIA clock.
--                  keyboard   (keyboard.vhd)        PS/2 Keyboard interface
--                             (ps2_keyboard.vhd)
--                             (keymap_rom_slice.vhd) Key map table 
--                  vdu8_mono  (vdu8_mono.vhd)        Monochrome VDU
--                             (char_rom2k_b16.vhd)
--                             (ram2k_b16.vhd)
--                  timer      (timer.vhd)            Interrupt timer
--                  trap       (trap.vhd)             Bus condition trap logic
--                  flex_ram   (flex9_ram8k_b16.vhd)  Flex operating system
--                  ram_32K    (ram32k_b16.vhd)       32 KBytes of Block RAM
--                  
-- 
-- Author         : John E. Kent      
--                  dilbert57@opencores.org      
--
-- Memory Map     :
--
-- $0000 - User program RAM (32K Bytes)
-- $C000 - Flex Operating System memory (8K Bytes)
-- $E000 - ACIA (SWTPc)
-- $E010 - Reserved for FD1771 FDC (SWTPc)
-- $E020 - Keyboard
-- $E030 - VDU
-- $E040 - IDE / Compact Flash interface
-- $E050 - Timer
-- $E060 - Bus trap
-- $E070 - Reserced for Parallel I/O (B5-X300)
-- $E080 - Reserved for 6821 PIA (?) (SWTPc)
-- $E090 - Reserved for 6840 PTM (?) (SWTPc)
-- $F000 - Sys09Bug monitor Program (4K Bytes)
--
--===========================================================================----
--
-- Revision History:
--===========================================================================--
-- Version 0.1 - 20 March 2003
-- Version 0.2 - 30 March 2003
-- Version 0.3 - 29 April 2003
-- Version 0.4 - 29 June 2003
--
-- Version 0.5 - 19 July 2003
-- prints out "Hello World"
--
-- Version 0.6 - 5 September 2003
-- Runs SBUG
--
-- Version 1.0- 6 Sep 2003 - John Kent
-- Inverted SysClk
-- Initial release to Open Cores
--
-- Version 1.1 - 17 Jan 2004 - John Kent
-- Updated miniUart.
--
-- Version 1.2 - 25 Jan 2004 - John Kent
-- removed signals "test_alu" and "test_cc" 
-- Trap hardware re-instated.
--
-- Version 1.3 - 11 Feb 2004 - John Kent
-- Designed forked off to produce System09_VDU
-- Added VDU component
--	VDU runs at 25MHz and divides the clock by 2 for the CPU
-- UART Runs at 57.6 Kbps
--
-- Version 2.0 - 2 September 2004 - John Kent
-- ported to Digilent Xilinx Spartan3 starter board
--	removed Compact Flash and Trap Logic.
-- Replaced SBUG with KBug9s
--
-- Version 3.0 - 29th August 2006 - John Kent
-- Adapted to XSA-3S1000 board.
-- Removed DAT and miniUART.
-- Used 32KBytes of Block RAM.
--
-- Version 3.1 - 15th January 2007 - John Kent
-- Modified vdu8 interface
-- Added a clock divider
--
-- Version 3.2 - 25th February 2007 - John Kent
-- reinstated ACIA_6850 and ACIA_Clock
-- Updated VDU8 & Keyboard with generic parameters
-- Defined Constants for clock speed calculations
--
-- Version 3.3 - 1st July 2007 - John Kent
-- Made VDU mono to save on one RAMB16
-- Used distributed memory for Key Map ROM to save one RAMB16
-- Added Flex RAM at $C000 to $DFFF using 4 spare RAMB16s
-- Added timer and trap logic
-- Added IDE Interface for Compact Flash
-- Replaced KBug9s and stack with Sys09Bug.
--
--===========================================================================--
library ieee;
   use ieee.std_logic_1164.all;
   use IEEE.STD_LOGIC_ARITH.ALL;
   use IEEE.STD_LOGIC_UNSIGNED.ALL;
   use ieee.numeric_std.all;
library unisim;
   use unisim.vcomponents.all;

entity My_System09 is
  port(
    Clk100      : in  Std_Logic;  -- 100MHz Clock input
	 SW2_N       : in  Std_logic;  -- Master Reset input (active low)
	 SW3_N       : in  Std_logic;  -- Non Maskable Interrupt input (active low)

 	 -- PS/2 Keyboard
	 ps2_clk     : inout Std_logic;
	 ps2_dat     : inout Std_Logic;

	 -- CRTC output signals
	 vga_vsync_n : out Std_Logic;
    vga_hsync_n : out Std_Logic;
    vga_blue    : out std_logic_vector(2 downto 0);
    vga_green   : out std_logic_vector(2 downto 0);
    vga_red     : out std_logic_vector(2 downto 0);

    -- RS232 Port
	 RS232_RXD   : in  Std_Logic;
	 RS232_TXD   : out Std_Logic;
--  RS232_DCD   : in  Std_logic;
    RS232_CTS   : in  Std_Logic;
    RS232_RTS   : out Std_Logic;

	 -- LEDS & Switches
	 STATUS_LED  : out std_logic_vector(6 downto 0);

-- Compact Flash
--    ide_rst_n   : out std_logic;
	 ide_cs0_n   : out std_logic;
	 ide_cs1_n   : out std_logic;
    ide_ior_n    : out std_logic;
    ide_iow_n    : out std_logic;
--	 ide_cs16_n  : out std_logic;
    ide_a       : out std_logic_vector(2 downto 0);
    ide_d       : inout std_logic_vector(15 downto 0);
--    ide_d       : inout std_logic_vector(7 downto 0);
	 
	 ethernet_cs_n : out std_logic
	 );
end My_System09;

-------------------------------------------------------------------------------
-- Architecture for System09
-------------------------------------------------------------------------------
architecture rtl of My_System09 is

  -----------------------------------------------------------------------------
  -- constants
  -----------------------------------------------------------------------------
  constant SYS_Clock_Frequency  : integer := 50000000;  -- FPGA System Clock
  constant PIX_Clock_Frequency  : integer := 25000000;  -- VGA Pixel Clock
  constant CPU_Clock_Frequency  : integer := 25000000;  -- CPU Clock
  constant BAUD_Rate            : integer := 57600;	  -- Baud Rate
  constant ACIA_Clock_Frequency : integer := BAUD_Rate * 16;

  type hold_state_type is ( hold_release_state, hold_request_state );

  -----------------------------------------------------------------------------
  -- Signals
  -----------------------------------------------------------------------------
  signal rst_n          :  Std_logic;  -- Master Reset input (active low)
  signal nmi_n          :  Std_logic;  -- Non Maskable Interrupt input (active low)

  -- BOOT ROM
  signal rom_cs         : Std_logic;
  signal rom_data_out   : Std_Logic_Vector(7 downto 0);

  -- Flex Memory & Monitor Stack
  signal flex_cs        : Std_logic;
  signal flex_data_out  : Std_Logic_Vector(7 downto 0);

  -- ACIA/UART Interface signals
  signal uart_data_out  : Std_Logic_Vector(7 downto 0);  
  signal uart_cs        : Std_Logic;
  signal uart_irq       : Std_Logic;
  signal uart_clk       : Std_Logic;
  signal rxd            : Std_Logic;
  signal txd            : Std_Logic;
  signal DCD_n          : Std_Logic;
  signal RTS_n          : Std_Logic;
  signal CTS_n          : Std_Logic;

  -- keyboard port
  signal keyboard_data_out : std_logic_vector(7 downto 0);
  signal keyboard_cs       : std_logic;
  signal keyboard_irq      : std_logic;

  -- RAM
  signal ram_cs         : std_logic; -- memory chip select
  signal ram_data_out   : std_logic_vector(7 downto 0);

  -- CPU Interface signals
  signal cpu_reset      : Std_Logic;
  signal cpu_clk        : Std_Logic;
  signal cpu_rw         : std_logic;
  signal cpu_vma        : std_logic;
  signal cpu_halt       : std_logic;
  signal cpu_hold       : std_logic;
  signal cpu_firq       : std_logic;
  signal cpu_irq        : std_logic;
  signal cpu_nmi        : std_logic;
  signal cpu_addr       : std_logic_vector(15 downto 0);
  signal cpu_data_in    : std_logic_vector(7 downto 0);
  signal cpu_data_out   : std_logic_vector(7 downto 0);

  -- Video Display Unit
  signal vdu_cs         : std_logic;
  signal vdu_data_out   : std_logic_vector(7 downto 0);
  signal vga_red_o      : std_logic;
  signal vga_green_o    : std_logic;
  signal vga_blue_o     : std_logic;

  -- timer
  signal timer_data_out : std_logic_vector(7 downto 0);
  signal timer_cs       : std_logic;
  signal timer_irq      : std_logic;
  signal timer_out      : std_logic;

  -- trap
  signal trap_cs        : std_logic;
  signal trap_data_out  : std_logic_vector(7 downto 0);
  signal trap_irq       : std_logic;

  -- compact flash port
  signal ide_data_out   : std_logic_vector(7 downto 0);
  signal ide_cs         : std_logic;
  signal ide_ior        : std_logic;
  signal ide_iow        : std_logic;
  signal ide_hold       : std_logic;
  signal ide_release    : std_logic;
  signal ide_count      : std_logic_vector(3 downto 0);
  signal ide_hold_state : hold_state_type;

--  signal BaudCount    : std_logic_vector(5 downto 0);
  signal CountL         : std_logic_vector(23 downto 0);
  signal clk_count      : std_logic_vector(1 downto 0);
  signal Clk50          : std_logic;
  signal Clk25          : std_logic;
  signal SysClk         : std_logic; -- buffered 50 MHz clock
  signal pix_clk        : std_logic;

-----------------------------------------------------------------
--
-- CPU09 CPU core
--
-----------------------------------------------------------------

component cpu09
  port (    
	 clk:	     in	std_logic;
    rst:      in	std_logic;
    rw:	     out	std_logic;		-- Asynchronous memory interface
    vma:	     out	std_logic;
    address:  out	std_logic_vector(15 downto 0);
    data_in:  in	std_logic_vector(7 downto 0);
	 data_out: out std_logic_vector(7 downto 0);
	 halt:     in  std_logic;
	 hold:     in  std_logic;
	 irq:      in  std_logic;
	 nmi:      in  std_logic;
	 firq:     in  std_logic
  );
end component;


----------------------------------------
--
-- 4K Block RAM Monitor ROM
--
----------------------------------------
component mon_rom
    Port (
       clk   : in  std_logic;
		 rst   : in  std_logic;
		 cs    : in  std_logic;
		 rw    : in  std_logic;
       addr  : in  std_logic_vector (11 downto 0);
       rdata : out std_logic_vector (7 downto 0);
       wdata : in  std_logic_vector (7 downto 0)
    );
end component;


----------------------------------------
--
-- 8KBytes Block RAM for FLEX9
-- $C000 - $DFFF
--
----------------------------------------
component flex_ram
  Port (
    clk      : in  std_logic;
    rst      : in  std_logic;
    cs       : in  std_logic;
    rw       : in  std_logic;
    addr     : in  std_logic_vector (12 downto 0);
    rdata    : out std_logic_vector (7 downto 0);
    wdata    : in  std_logic_vector (7 downto 0)
    );
end component;

-----------------------------------------------------------------
--
-- 6850 Compatible ACIA / UART
--
-----------------------------------------------------------------

component ACIA_6850
  port (
     clk      : in  Std_Logic;  -- System Clock
     rst      : in  Std_Logic;  -- Reset input (active high)
     cs       : in  Std_Logic;  -- miniUART Chip Select
     rw       : in  Std_Logic;  -- Read / Not Write
     irq      : out Std_Logic;  -- Interrupt
     Addr     : in  Std_Logic;  -- Register Select
     DataIn   : in  Std_Logic_Vector(7 downto 0); -- Data Bus In 
     DataOut  : out Std_Logic_Vector(7 downto 0); -- Data Bus Out
     RxC      : in  Std_Logic;  -- Receive Baud Clock
     TxC      : in  Std_Logic;  -- Transmit Baud Clock
     RxD      : in  Std_Logic;  -- Receive Data
     TxD      : out Std_Logic;  -- Transmit Data
     DCD_n    : in  Std_Logic;  -- Data Carrier Detect
     CTS_n    : in  Std_Logic;  -- Clear To Send
     RTS_n    : out Std_Logic );  -- Request To send
end component;


-----------------------------------------------------------------
--
-- ACIA Clock divider
--
-----------------------------------------------------------------

component ACIA_Clock
  generic (
     SYS_Clock_Frequency  : integer :=  SYS_Clock_Frequency;
	  ACIA_Clock_Frequency : integer := ACIA_Clock_Frequency
  );   
  port (
     clk      : in  Std_Logic;  -- System Clock Input
	  ACIA_clk : out Std_logic   -- ACIA Clock output
  );
end component;


----------------------------------------
--
-- PS/2 Keyboard
--
----------------------------------------

component keyboard
  generic(
  KBD_Clock_Frequency : integer := CPU_Clock_Frequency
  );
  port(
  clk             : in    std_logic;
  rst             : in    std_logic;
  cs              : in    std_logic;
  rw              : in    std_logic;
  addr            : in    std_logic;
  data_in         : in    std_logic_vector(7 downto 0);
  data_out        : out   std_logic_vector(7 downto 0);
  irq             : out   std_logic;
  kbd_clk         : inout std_logic;
  kbd_data        : inout std_logic
  );
end component;

----------------------------------------
--
-- Video Display Unit.
--
----------------------------------------
component vdu8_mono
      generic(
        VDU_CLOCK_FREQUENCY    : integer := CPU_Clock_Frequency; -- HZ
        VGA_CLOCK_FREQUENCY    : integer := PIX_Clock_Frequency; -- HZ
	     VGA_HOR_CHARS          : integer := 80; -- CHARACTERS
	     VGA_VER_CHARS          : integer := 25; -- CHARACTERS
	     VGA_PIXELS_PER_CHAR    : integer := 8;  -- PIXELS
	     VGA_LINES_PER_CHAR     : integer := 16; -- LINES
	     VGA_HOR_BACK_PORCH     : integer := 40; -- PIXELS
	     VGA_HOR_SYNC           : integer := 96; -- PIXELS
	     VGA_HOR_FRONT_PORCH    : integer := 24; -- PIXELS
	     VGA_VER_BACK_PORCH     : integer := 13; -- LINES
	     VGA_VER_SYNC           : integer := 1;  -- LINES
	     VGA_VER_FRONT_PORCH    : integer := 36  -- LINES
      );
      port(
		-- control register interface
      vdu_clk      : in  std_logic;	 -- CPU Clock - 12.5MHz
      vdu_rst      : in  std_logic;
		vdu_cs       : in  std_logic;
		vdu_rw       : in  std_logic;
		vdu_addr     : in  std_logic_vector(2 downto 0);
      vdu_data_in  : in  std_logic_vector(7 downto 0);
      vdu_data_out : out std_logic_vector(7 downto 0);

      -- vga port connections
		vga_clk      : in  std_logic;	-- VGA Pixel Clock - 25 MHz
      vga_red_o    : out std_logic;
      vga_green_o  : out std_logic;
      vga_blue_o   : out std_logic;
      vga_hsync_o  : out std_logic;
      vga_vsync_o  : out std_logic
   );
end component;


----------------------------------------
--
-- Timer module
--
----------------------------------------

component timer
  port (
     clk       : in std_logic;
     rst       : in std_logic;
     cs        : in std_logic;
     rw        : in std_logic;
     addr      : in std_logic;
     data_in   : in std_logic_vector(7 downto 0);
	  data_out  : out std_logic_vector(7 downto 0);
	  irq       : out std_logic;
     timer_in  : in std_logic;
	  timer_out : out std_logic
	  );
end component;

------------------------------------------------------------
--
-- Bus Trap logic
--
------------------------------------------------------------

component trap
	port (	
	 clk        : in  std_logic;
    rst        : in  std_logic;
    cs         : in  std_logic;
    rw         : in  std_logic;
    vma        : in  std_logic;
    addr       : in  std_logic_vector(15 downto 0);
    data_in    : in  std_logic_vector(7 downto 0);
	 data_out   : out std_logic_vector(7 downto 0);
	 irq        : out std_logic
  );
end component;

----------------------------------------
--
-- Block RAM program Memory
--
----------------------------------------
component ram_32k
    Port (
       clk   : in  std_logic;
		 rst   : in  std_logic;
		 cs    : in  std_logic;
		 rw    : in  std_logic;
       addr  : in  std_logic_vector (14 downto 0);
       rdata : out std_logic_vector (7 downto 0);
       wdata : in  std_logic_vector (7 downto 0)
    );
end component;

--
-- Clock buffer
--
component BUFG 
   Port (
     i: in std_logic;
	  o: out std_logic
  );
end component;

begin
  -----------------------------------------------------------------------------
  -- Instantiation of internal components
  -----------------------------------------------------------------------------

my_cpu : cpu09  port map (    
	 clk	     => cpu_clk,
    rst       => cpu_reset,
    rw	     => cpu_rw,
    vma       => cpu_vma,
    address   => cpu_addr(15 downto 0),
    data_in   => cpu_data_in,
	 data_out  => cpu_data_out,
	 halt      => cpu_halt,
	 hold      => cpu_hold,
	 irq       => cpu_irq,
	 nmi       => cpu_nmi,
	 firq      => cpu_firq
  );

my_rom : mon_rom port map (
       clk   => cpu_clk,
		 rst   => cpu_reset,
		 cs    => rom_cs,
		 rw    => '1',
       addr  => cpu_addr(11 downto 0),
       wdata => cpu_data_out,
       rdata => rom_data_out
    );

my_flex : flex_ram port map (
    clk       => cpu_clk,
    rst       => cpu_reset,
	 cs        => flex_cs,
	 rw        => cpu_rw,
    addr      => cpu_addr(12 downto 0),
    rdata     => flex_data_out,
    wdata     => cpu_data_out
    );

my_uart  : ACIA_6850 port map (
	 clk	     => cpu_clk,
	 rst       => cpu_reset,
    cs        => uart_cs,
	 rw        => cpu_rw,
    irq       => uart_irq,
    Addr      => cpu_addr(0),
	 Datain    => cpu_data_out,
	 DataOut   => uart_data_out,
	 RxC       => uart_clk,
	 TxC       => uart_clk,
	 RxD       => rxd,
	 TxD       => txd,
	 DCD_n     => dcd_n,
	 CTS_n     => cts_n,
	 RTS_n     => rts_n
	 );


my_ACIA_Clock : ACIA_Clock
  generic map(
    SYS_Clock_Frequency  => SYS_Clock_Frequency,
	 ACIA_Clock_Frequency => ACIA_Clock_Frequency
  ) 
  port map(
    clk        => SysClk,
    acia_clk   => uart_clk
  ); 

----------------------------------------
--
-- PS/2 Keyboard Interface
--
----------------------------------------
my_keyboard : keyboard
   generic map (
	KBD_Clock_Frequency => CPU_Clock_frequency
	) 
   port map(
	clk          => cpu_clk,
	rst          => cpu_reset,
	cs           => keyboard_cs,
	rw           => cpu_rw,
	addr         => cpu_addr(0),
	data_in      => cpu_data_out(7 downto 0),
	data_out     => keyboard_data_out(7 downto 0),
	irq          => keyboard_irq,
	kbd_clk      => ps2_clk,
	kbd_data     => ps2_dat
	);

----------------------------------------
--
-- Video Display Unit instantiation
--
----------------------------------------
my_vdu : vdu8_mono 
  generic map(
      VDU_CLOCK_FREQUENCY    => CPU_Clock_Frequency, -- HZ
      VGA_CLOCK_FREQUENCY    => PIX_Clock_Frequency, -- HZ
	   VGA_HOR_CHARS          => 80, -- CHARACTERS
	   VGA_VER_CHARS          => 25, -- CHARACTERS
	   VGA_PIXELS_PER_CHAR    => 8,  -- PIXELS
	   VGA_LINES_PER_CHAR     => 16, -- LINES
	   VGA_HOR_BACK_PORCH     => 40, -- PIXELS
	   VGA_HOR_SYNC           => 96, -- PIXELS
	   VGA_HOR_FRONT_PORCH    => 24, -- PIXELS
	   VGA_VER_BACK_PORCH     => 13, -- LINES
	   VGA_VER_SYNC           => 1,  -- LINES
	   VGA_VER_FRONT_PORCH    => 36  -- LINES
  )
  port map(

		-- Control Registers
		vdu_clk       => cpu_clk,					 -- 12.5 MHz System Clock in
      vdu_rst       => cpu_reset,
		vdu_cs        => vdu_cs,
		vdu_rw        => cpu_rw,
		vdu_addr      => cpu_addr(2 downto 0),
		vdu_data_in   => cpu_data_out,
		vdu_data_out  => vdu_data_out,

      -- vga port connections
      vga_clk       => pix_clk,					 -- 25 MHz VDU pixel clock
      vga_red_o     => vga_red_o,
      vga_green_o   => vga_green_o,
      vga_blue_o    => vga_blue_o,
      vga_hsync_o   => vga_hsync_n,
      vga_vsync_o   => vga_vsync_n
   );

----------------------------------------
--
-- Timer Module
--
----------------------------------------
my_timer  : timer port map (
    clk       => cpu_clk,
	 rst       => cpu_reset,
    cs        => timer_cs,
	 rw        => cpu_rw,
    addr      => cpu_addr(0),
	 data_in   => cpu_data_out,
	 data_out  => timer_data_out,
    irq       => timer_irq,
	 timer_in  => CountL(5),
	 timer_out => timer_out
    );

----------------------------------------
--
-- Bus Trap Interrupt logic
--
----------------------------------------
my_trap : trap port map (	
	 clk        => cpu_clk,
    rst        => cpu_reset,
    cs         => trap_cs,
    rw         => cpu_rw,
	 vma        => cpu_vma,
    addr       => cpu_addr,
    data_in    => cpu_data_out,
	 data_out   => trap_data_out,
	 irq        => trap_irq
    );

my_ram : ram_32k port map (
       clk   => cpu_clk,
		 rst   => cpu_reset,
		 cs    => ram_cs,
		 rw    => cpu_rw,
       addr  => cpu_addr(14 downto 0),
       rdata => ram_data_out,
       wdata => cpu_data_out
    );

sys_clk_buffer : BUFG port map(
    i => Clk50,
	 o => SysClk
    );	 

cpu_clk_buffer : BUFG port map(
    i => Clk25,
	 o => cpu_clk
    );	 

pix_clk_buffer : BUFG port map(
    i => Clk25,
	 o => pix_clk
    );	 
	 
----------------------------------------------------------------------
--
-- Process to decode memory map
--
----------------------------------------------------------------------

mem_decode: process( cpu_clk,
                     cpu_addr, cpu_rw, cpu_vma,
					      rom_data_out,
							flex_data_out,
						   uart_data_out,
							keyboard_data_out,
							vdu_data_out,
							ide_data_out,
							timer_data_out,
							trap_data_out,
							ram_data_out
							)
begin
    case cpu_addr(15 downto 12) is
	   --
		-- Sys09Bug Monitor ROM $F000 - $FFFF
		--
		when "1111" => -- $F800 - $FFFF
		   cpu_data_in <= rom_data_out;
			rom_cs      <= cpu_vma;
			flex_cs     <= '0';
			uart_cs     <= '0';
			keyboard_cs <= '0';
			vdu_cs      <= '0';
			ide_cs      <= '0';
			timer_cs    <= '0';
			trap_cs     <= '0';
			ram_cs      <= '0';

      --
		-- IO Devices $E000 - $E7FF
		--
		when "1110" => -- $E000 - $E7FF
			rom_cs    <= '0';
			flex_cs   <= '0';
			ram_cs    <= '0';
		   case cpu_addr(7 downto 4) is
			--
			-- UART / ACIA $E000
			--
			when "0000" => -- $E000
		     cpu_data_in <= uart_data_out;
			  uart_cs     <= cpu_vma;
			  keyboard_cs <= '0';
			  vdu_cs      <= '0';
			  ide_cs      <= '0';
			  timer_cs    <= '0';
			  trap_cs     <= '0';

         --
         -- Reserved
			-- Floppy Disk Controller port $E010 - $E01F
			--
			when "0001" => -- $E010
           cpu_data_in <= "00000000";
			  uart_cs     <= '0';
			  keyboard_cs <= '0';
			  vdu_cs      <= '0';
			  ide_cs      <= '0';
			  timer_cs    <= '0';
			  trap_cs     <= '0';

         --
         -- Keyboard port $E020 - $E02F
			--
			when "0010" => -- $E020
           cpu_data_in <= keyboard_data_out;
			  uart_cs     <= '0';
			  keyboard_cs <= cpu_vma;
			  vdu_cs      <= '0';
			  ide_cs      <= '0';
			  timer_cs    <= '0';
			  trap_cs     <= '0';

         --
         -- VDU port $E030 - $E03F
			--
			when "0011" => -- $E030
           cpu_data_in <= vdu_data_out;
			  uart_cs     <= '0';
			  keyboard_cs <= '0';
			  vdu_cs      <= cpu_vma;
			  ide_cs      <= '0';
			  timer_cs    <= '0';
			  trap_cs     <= '0';

         --
			-- Compact Flash $E040 - $E04F
			--
			when "0100" => -- $E040
           cpu_data_in <= ide_data_out;
			  uart_cs     <= '0';
			  keyboard_cs <= '0';
			  vdu_cs      <= '0';
           ide_cs      <= cpu_vma;
			  timer_cs    <= '0';
			  trap_cs     <= '0';

         --
         -- Timer $E050 - $E05F
			--
			when "0101" => -- $E050
           cpu_data_in <= timer_data_out;
			  uart_cs     <= '0';
			  keyboard_cs <= '0';
			  vdu_cs      <= '0';
			  ide_cs      <= '0';
           timer_cs    <= cpu_vma;
			  trap_cs     <= '0';

         --
         -- Bus Trap Logic $E060 - $E06F
			--
			when "0110" => -- $E060
           cpu_data_in <= trap_data_out;
			  uart_cs     <= '0';
			  keyboard_cs <= '0';
			  vdu_cs      <= '0';
			  ide_cs      <= '0';
           timer_cs    <= '0';
			  trap_cs     <= cpu_vma;

			when others => -- $E070 to $E7FF
           cpu_data_in <= "00000000";
			  uart_cs     <= '0';
			  keyboard_cs <= '0';
			  vdu_cs      <= '0';
			  ide_cs      <= '0';
			  timer_cs    <= '0';
			  trap_cs     <= '0';
		   end case;

		--
		-- Flex RAM $C000 - $DFFF
		--
		when "1100" | "1101" => -- $C000 - $DFFF
		   cpu_data_in <= rom_data_out;
			rom_cs      <= '0';
			flex_cs     <= cpu_vma;
			uart_cs     <= '0';
			keyboard_cs <= '0';
			vdu_cs      <= '0';
         ide_cs      <= '0';
         timer_cs    <= '0';
         trap_cs     <= '0';
			ram_cs      <= '0';
		--
		-- Everything else is RAM
		--
		when others =>
		  cpu_data_in <= ram_data_out;
		  rom_cs      <= '0';
		  flex_cs     <= '0';
		  uart_cs     <= '0';
		  keyboard_cs <= '0';
		  vdu_cs      <= '0';
        ide_cs      <= '0';
        timer_cs    <= '0';
        trap_cs     <= '0';
		  ram_cs      <= cpu_vma;
	 end case;
end process;


--
-- Compact Flash Control
--
compact_flash: process(
                 cpu_addr, cpu_rw, cpu_vma, cpu_data_out,
					  ide_cs, ide_ior, ide_iow, ide_d )
begin
--	 ide_rst_n  <= rst_n;
	 ide_cs0_n  <= not( ide_cs ) or cpu_addr(3);
	 ide_cs1_n  <= not( ide_cs and cpu_addr(3));
--	 ide_cs16_n <= '1';
	 ide_iow     <= ide_cs and (not cpu_rw);
	 ide_ior    <= ide_cs and cpu_rw;
	 ide_iow_n  <= not ide_iow;
	 ide_ior_n  <= not ide_ior;
	 ide_a      <= cpu_addr(2 downto 0);
	 if ide_iow = '1' then
	   ide_d(7 downto 0) <= cpu_data_out;
	 else
	   ide_d(7 downto 0) <= "ZZZZZZZZ";
	 end if;
	 ide_data_out <= ide_d(7 downto 0);
	 ide_d(15 downto 8) <= "ZZZZZZZZ";
end process;

--
-- Hold CF access	for a few cycles
--
ide_hold_proc: process( cpu_clk, rst_n )
begin
    if rst_n = '0' then
		 ide_release    <= '0';
		 ide_count      <= "0000";
	    ide_hold_state <= hold_release_state;
	 elsif cpu_clk'event and cpu_clk='0' then
	    case ide_hold_state is
		 when hold_release_state =>
          ide_release <= '0';
		    if ide_cs = '1' then
			    ide_count      <= "0011";
				 ide_hold_state <= hold_request_state;
			 end if;

		 when hold_request_state =>
		    ide_count <= ide_count - "0001";
			 if ide_count = "0000" then
             ide_release    <= '1';
				 ide_hold_state <= hold_release_state;
			 end if;
       when others =>
		    null;
       end case;
	 end if;
end process;

--
-- Interrupts and other bus control signals
--
interrupts : process( rst_n, 
							 ide_cs, ide_hold, ide_release,
                      uart_irq, 
							 keyboard_irq, 
							 trap_irq, 
							 timer_irq
							 )
begin
    ide_hold   <= ide_cs and (not ide_release);
 	 cpu_reset <= not rst_n; -- CPU reset is active high
    cpu_irq   <= uart_irq or keyboard_irq;
	 cpu_nmi   <= trap_irq or not( nmi_n );
	 cpu_firq  <= timer_irq;
	 cpu_halt  <= '0';
	 cpu_hold  <= ide_hold;
end process;


--
-- Flash 7 segment LEDS
--
my_led_flasher: process( SysClk, rst_n, CountL )
begin
    if rst_n = '0' then
		   CountL <= "000000000000000000000000";
    elsif(SysClk'event and SysClk = '0') then
		   CountL <= CountL + 1;
    end if;
	 STATUS_LED(6 downto 0) <= CountL(23 downto 17);
end process;

--
-- Generate a 50 MHz Clock from 100 MHz
--
my_prescaler : process( Clk100, clk_count )
begin
  if Clk100'event and Clk100 = '0' then
    clk_count <= clk_count + "01";
  end if;
  Clk50 <= clk_count(0);
  Clk25 <= clk_count(1);
end process;

--
-- Push buttons
--
my_switch_assignments : process( SW2_N, SW3_N )
begin
  rst_n    <= SW2_N;
  nmi_n    <= SW3_N;
  --
  -- Disable the ethernet controller
  --
  ethernet_cs_n <= '1';
end process;

--
-- RS232 signals:
--
my_uart_assignments : process( RS232_RXD, RS232_CTS, rxd, rts_n )
begin
  rxd       <= RS232_RXD;
  cts_n     <= RS232_CTS;
  dcd_n     <= '0';
  RS232_TXD <= txd;
  RS232_RTS <= rts_n;
end process;

--
-- VGA ouputs
--
my_vga_assignments : process( vga_red_o, vga_green_o, vga_blue_o )
begin
  VGA_red(0)   <= vga_red_o;
  VGA_red(1)   <= vga_red_o;
  VGA_red(2)   <= vga_red_o;
  VGA_green(0) <= vga_green_o;
  VGA_green(1) <= vga_green_o;
  VGA_green(2) <= vga_green_o;
  VGA_blue(0)  <= vga_blue_o;
  VGA_blue(1)  <= vga_blue_o;
  VGA_blue(2)  <= vga_blue_o;
end process;


end rtl; --===================== End of architecture =======================--

