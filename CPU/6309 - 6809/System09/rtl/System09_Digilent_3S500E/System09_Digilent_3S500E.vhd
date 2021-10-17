-- $Id$
--===========================================================================----
--
--  S Y N T H E Z I A B L E    System09 - SOC.
--
--  This core adheres to the GNU public license  
--
-- File name      : System09.vhd
--
-- Purpose        : Top level file for 6809 compatible system on a chip
--                  Designed with Xilinx XC3S500E Spartan 3E FPGA.
--                  Implemented With Digilent Xilinx Starter FPGA board,
--
-- Dependencies   : ieee.Std_Logic_1164
--                  ieee.std_logic_unsigned
--                  ieee.std_logic_arith
--                  ieee.numeric_std
--
-- Uses           : mon_rom  (kbug_rom2k.vhd)       Monitor ROM
--                  cpu09    (cpu09.vhd)      CPU core
--                  miniuart (minitUART3.vhd) ACIA / MiniUART
--                           (rxunit3.vhd)
--                           (tx_unit3.vhd)
-- 
-- Author         : John E. Kent      
--                  dilbert57@opencores.org      
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
-- Inverted CLK_50MHZ
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
--	removed Compaact Flash and Trap Logic.
-- Replaced SBUG with KBug9s
--
-- Version 3.0 - 22 April 2006 - John Kent
-- Port to Digilent Spartan 3E Starter board
-- Removed keyboard, vdu, timer, and trap logic
-- added PIA with counters attached.
-- Uses 32Kbytes of internal Block RAM
--===========================================================================--
library ieee;
   use ieee.std_logic_1164.all;
   use IEEE.STD_LOGIC_ARITH.ALL;
   use IEEE.STD_LOGIC_UNSIGNED.ALL;
   use ieee.numeric_std.all;

entity My_System09 is
  port(
    CLK_50MHZ     : in  Std_Logic;  -- System Clock input
    BTN_SOUTH     : in  Std_Logic;

	 -- Uart Interface
	 RS232_DCE_RXD : in  std_logic;
    RS232_DCE_TXD : out std_logic;
	 
	 -- LEDS & Switches
	 LED           : out std_logic_vector(7 downto 0)
	 );
end My_System09;

-------------------------------------------------------------------------------
-- Architecture for System09
-------------------------------------------------------------------------------
architecture my_computer of My_System09 is
  -----------------------------------------------------------------------------
  -- Signals
  -----------------------------------------------------------------------------
  -- BOOT ROM
  signal rom_cs        : Std_logic;
  signal rom_data_out  : Std_Logic_Vector(7 downto 0);

  -- UART Interface signals
  signal uart_data_out : Std_Logic_Vector(7 downto 0);  
  signal uart_cs       : Std_Logic;
  signal uart_irq      : Std_Logic;
  signal baudclk       : Std_Logic;
  signal DCD_n         : Std_Logic;
  signal RTS_n         : Std_Logic;
  signal CTS_n         : Std_Logic;

  -- PIA Interface signals
  signal pia_data_out  : Std_Logic_Vector(7 downto 0);  
  signal pia_cs        : Std_Logic;
  signal pia_irq_a     : Std_Logic;
  signal pia_irq_b     : Std_Logic;

  -- RAM
  signal ram_cs       : std_logic; -- memory chip select
  signal ram_data_out : std_logic_vector(7 downto 0);

  -- CPU Interface signals
  signal cpu_reset    : Std_Logic;
  signal cpu_clk      : Std_Logic;
  signal cpu_rw       : std_logic;
  signal cpu_vma      : std_logic;
  signal cpu_halt     : std_logic;
  signal cpu_hold     : std_logic;
  signal cpu_firq     : std_logic;
  signal cpu_irq      : std_logic;
  signal cpu_nmi      : std_logic;
  signal cpu_addr     : std_logic_vector(15 downto 0);
  signal cpu_data_in  : std_logic_vector(7 downto 0);
  signal cpu_data_out : std_logic_vector(7 downto 0);

  signal BaudCount    : std_logic_vector(6 downto 0);
  signal CountL       : std_logic_vector(23 downto 0);
  -- CLK_50MHZ clock divide by 4
  signal prescale     : std_logic_vector(1 downto 0);
  
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
-- Block RAM Monitor ROM
--
----------------------------------------
component rom_8k
    Port (
       clk   : in  std_logic;
		 rst   : in  std_logic;
		 cs    : in  std_logic;
		 rw    : in  std_logic;
       addr  : in  std_logic_vector (12 downto 0);
       rdata : out std_logic_vector (7 downto 0);
       wdata : in  std_logic_vector (7 downto 0)
    );
end component;

----------------------------------------
--
-- Block RAM Monitor
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

-----------------------------------------------------------------
--
-- 6822 compatible PIA with counters
--
-----------------------------------------------------------------

component pia_timer
	port (	
	 clk       : in    std_logic;
    rst       : in    std_logic;
    cs        : in    std_logic;
    rw        : in    std_logic;
    addr      : in    std_logic_vector(1 downto 0);
    data_in   : in    std_logic_vector(7 downto 0);
	 data_out  : out   std_logic_vector(7 downto 0);
	 irqa      : out   std_logic;
	 irqb      : out   std_logic
	 );
end component;

-----------------------------------------------------------------
--
-- 6850 compatible UART (ACIA)
--
-----------------------------------------------------------------

component miniUART
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


component BUFG 
port (
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

my_rom : rom_8k port map (
       clk   => cpu_clk,
		 rst   => cpu_reset,
		 cs    => rom_cs,
		 rw    => '1',
       addr  => cpu_addr(12 downto 0),
       rdata => rom_data_out,
       wdata => cpu_data_out
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

my_pia  : pia_timer port map (
	 clk	     => cpu_clk,
	 rst       => cpu_reset,
    cs        => pia_cs,
	 rw        => cpu_rw,
    addr      => cpu_addr(1 downto 0),
	 data_in   => cpu_data_out,
	 data_out  => pia_data_out,
    irqa      => pia_irq_a,
    irqb      => pia_irq_b
	 );

my_uart  : miniUART port map (
	 clk	     => cpu_clk,
	 rst       => cpu_reset,
    cs        => uart_cs,
	 rw        => cpu_rw,
    irq       => uart_irq,
    Addr      => cpu_addr(0),
	 Datain    => cpu_data_out,
	 DataOut   => uart_data_out,
	 RxC       => baudclk,
	 TxC       => baudclk,
	 RxD       => RS232_DCE_RXD,
	 TxD       => RS232_DCE_TXD,
	 DCD_n     => dcd_n,
	 CTS_n     => cts_n,
	 RTS_n     => rts_n
	 );


clk_buffer : BUFG port map(
    i => prescale(1),
	 o => cpu_clk
    );	 
	 
----------------------------------------------------------------------
--
-- Process to decode memory map
--
----------------------------------------------------------------------

mem_decode: process( cpu_clk, BTN_SOUTH,
                     cpu_addr, cpu_rw, cpu_vma,
					      rom_data_out,
							ram_data_out,
						   uart_data_out,
                     pia_data_out )
begin
    case cpu_addr(15 downto 14) is
	   --
		-- Monitor ROM $C000 - $FFFF
		--
		when "11" => -- $C000 - $FFFF
		   cpu_data_in <= rom_data_out;
			rom_cs      <= cpu_vma;
			ram_cs      <= '0';
			uart_cs     <= '0';
			pia_cs      <= '0';
      --
		-- IO Devices $8000 - $BFFF
		--
		when "10" => -- $8000 - $BFFF
			rom_cs    <= '0';
			ram_cs    <= '0';
		   case cpu_addr(3 downto 2) is
			--
			-- PIA TIMER $8004
			--
			when "01" => -- $8004
		     cpu_data_in <= pia_data_out;
			  uart_cs     <= '0';
           pia_cs      <= cpu_vma;
			--
			-- UART / ACIA $8008
			--
			when "10" => -- $8008
		     cpu_data_in <= uart_data_out;
			  uart_cs     <= cpu_vma;
           pia_cs      <= '0';

			when others =>
           cpu_data_in <= "11111111";
			  uart_cs     <= '0';
           pia_cs      <= '0';
		   end case;
		--
		-- Everything else is RAM
		--
		when others =>
		  cpu_data_in <= ram_data_out;
		  rom_cs      <= '0';
		  ram_cs      <= cpu_vma;
		  uart_cs     <= '0';
        pia_cs      <= '0';
	 end case;
end process;

--
-- Interrupts and other bus control signals
--
interrupts : process( BTN_SOUTH, uart_irq,
                      pia_irq_a, pia_irq_b
							 )
begin
 	 cpu_reset <= BTN_SOUTH; -- CPU reset is active high
    cpu_irq   <= uart_irq;
	 cpu_nmi   <= pia_irq_a;
	 cpu_firq  <= pia_irq_b;
	 cpu_halt  <= '0';
    cpu_hold  <= '0';
end process;

my_cpu_clock: process( CLK_50MHZ, prescale )
begin
    if(CLK_50MHZ'event and CLK_50MHZ = '0') then
		   prescale <= prescale + "01";
    end if;
end process;

--
-- Baud rate clock
-- 50 MHz / 81.38 = ~614.4 KHz (38400 * 16)
--
my_baud: process( CLK_50MHZ )
begin
    if(CLK_50MHZ'event and CLK_50MHZ = '0') then
		if( BaudCount = 81 )	then
		   BaudCount <= "0000000";
			baudclk <= '0';
		else
		   BaudCount <= BaudCount + 1;
			if BaudCount = 40 then
			   baudclk <= '1';
         else
			   baudclk <= baudclk;
         end if;
		end if;			 
    end if;
end process;

--
--
my_led_flasher: process( CLK_50MHZ, BTN_SOUTH, CountL )
begin
    if BTN_SOUTH = '1' then
		   CountL <= "000000000000000000000000";
    elsif(CLK_50MHZ'event and CLK_50MHZ = '0') then
		   CountL <= CountL + 1;
    end if;
	 LED(7 downto 0) <= CountL(23 downto 16);
end process;

DCD_n <= '0';
CTS_n <= '0';

end my_computer; --===================== End of architecture =======================--

