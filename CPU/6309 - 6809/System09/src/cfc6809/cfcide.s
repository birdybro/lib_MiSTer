; editor tab setting: 8
; CompactFlash Card via a CF Card to IDE disk interface to the 6809 Core + I/O Board
;
; History.
; This program was originally written to interface directly from the I/O Board to an
; IDE hard disk.  Initially the datapath was just 8-bit, which is fine for commands,
; but, after the "low-level" software operated, it was quite annoying that with the
; "Identify" command you only get half the information of the manufacturer of the disk.
; So, the datapath was "upgraded" to 16-bit.
; The "low-level" software (LVL-0 prompt of the test program) recognizes 5 commands:
;
;  C - Clear (initialise)
;  I - Identify
;  R - Read one sector
;  W - Write one sector
;  F - FAT16 tests
;
; With the "F" command the program prompt changes from "LVL-0" to "FAT16" test mode.
; "?" shows a (very) short list of the available commands in the current test mode.
; <ESC> terminates the program and control returns to the monitor.
; The following commands are available for FAT16 routines:
;
;  B - Bootsector information
;  D - Directory information
;  G - Get a file from disk
;  S - Save a file to disk (not yet implemented)
;  C - Change directory (not yet implemented)
;  L - LVL-0 tests
;
;
;
; pin #		name	IDE hard disk interface description
; -----------------------------------------------------------------------------------
;
;  1		RESET*	A low signal level on this pin will reset the device
;  2,19,22,24	GND	ground
;  26,30,40
;  3,5,7,9,11	D7..D0	low data bus, 3=D7 .. 17=D0. This part of the bus is used
;  13,15,17		for the command and parameter transfer. It is also used for
;			the low byte in 16-bits data transfers.
;  4,6,8,10	D8..D15	high data bus, 4=D8 .. 18=D15. This part of the bus is used
;  12,14,16,18		only for the 16-bits data transfer.
;  20		-	Key pin.
;  21		DMARQ	DMA request. Not used, pulled down to GND with resistor 10k.
;  23		WR*	Drive I/O Write, write strobe of the bus.
;  25		RD*	Drive I/O Read, read strobe of the bus.
;  27		IORDY*	I do not use or connect to this pin. It is used to slow down
;			a controller when it is going too fast for the bus.
;			The Core + I/O Board do not have that problem.
;  28		CSEL	Cable select. Not used.
;  29		DMACK	DMA acknowledge. Not used.
;  31		INTRQ	Drive interrupt, interrupt output from the IDE device.
;			This pin can be connected to the 6809 to generate interrupts
;			when a command is finished. Not used.
;  32		IOCS16	In AT, signal to enable the upper data bus drivers. Not used.
;  33		A1	Address line of the IDE bus. With this A1 (and A0, A2) you
;                       select which register of the IDE device you communicate with.
;  34		PDIAG*	Master/slave interface on the IDE bus itself.
;			Not used, pulled up with resistor of 10k (10000 Ohms) to +5 V.
;  35		A0	Address lines of the IDE bus. With these (and A1) you select
;  36           A2      which register  of the IDE device you communicate with.
;  37		CS0*	The two /CS signals of the IDE bus. Used in combination with
;  38		CS1*	the A0-A1-A2 lines to select the IDE register to access.
;  39		ACT*	A low level on this pin indicates that the IDE device is busy.
;		DASP*	You could connect 2 LED's gated with the RD* and WR* signal to
;			get the WR and RD lights on an RK05 drive. The software reads
;			the "drive busy" status from the IDE status register.
;
;
;  * OUTPUT only signals (from I/O Board to IDE disk)
;	A0, A1, A2, CS0*, CS1*, WR*, RD* and RESET*
;  * BI-DIRECTIONAL signals
;	Databus [D0:15]
;
;  * INPUT only signals (from IDE disk to I/O Board)
;	IRQ and ACT* (also called DASP*)
;	Connect a 10 KOhm pull-down resistor from the IRQ pin to ground.
;	ACT* can drive a LED (with a 330 Ohms series resistor) if you like.
;
;
;  IDE disk to I/O Board connection
; ----------------------------------
;
; The access to the IDE hard disk would be simple if the Core Board had a second, not
; used, PIA. A separate circuit board that piggy-backed the PIA on the Core Board
; and added one extra PIA would be a possible solution, but with software overhead
; it is possible to connect the IDE disk to the 8-bit buffers/latches on I/O Board.
; The 8 output only signals are directly tied to an output port of the I/O Board.
; The lower 8 databus bits [D0:D7] are connected to an output port *AND* an input
; port in parallel.  Since the output ports on the I/O Board are always enabled,
; a *patch* is required so that the output port can be set into 3-state mode so that
; reading data from the IDE disk is possible without shorting the databus against the
; output port.  The patch requires one bit from an extra output port; the OE* pin of
; the output latch used for the bi-directional databus is cut from its GND connection
; and it is wired to that single bit of the extra output port.
; IRQ, and ACT* are not tied to the I/O Board. The upper 8 databus bits [D8:15] is an
; option. Using only 8 bits means that half of the disk capacity will not be used,
; but who wants more than a few Mb's on a PDP8/e anyway ... Not using D8:15 saves one
; output port and one input port. The code has an assembly flag to select between
; 8/16 bit data transfers.
;
;
;   ==============                                ==========
;   #            #                                |        |--- 7  RST* ------+++
;   #            #                                |  OUT   |--- 6  RD* -------|||
;   #            #             control            |        |--- 5  WR* -------|||
;   #            #<<---------------------/--------| cntrl  |--- 4  CS1* ------||| C
;   #            #                       8        |        |--- 3  CS0* ------||| O
;   #            #                                |        |--- 2  A2 --------||| M
;   #            #                                |        |--- 1  A1 --------||| M
;   #    IDE     #                ==========      |WRide_c |--- 0  A0 --------||| O
;   #            #                |        |      ==========                  ||| N
;   #            #                |        |                                  |||
;   #   disk     #          (16)  |  OUT   |                                  |||
;   #   drive    #       +---/----|        |                                  ||| D
;   #            #       | +-/----|  data  |----------------------------------||| A
;   #            #       | | 8    |        |     +5                           ||| T
;   #            #       | |      |WRide_du|     |                            ||| A
;   #            #   (16)| |      |WRide_dl|    | |4700                       ||| B
;   #            #<<--/--+ |      ==========    |_|                           ||| U
;   #            #       | |        ^            |  =========                 ||| S
;   #            #<<--/----+        +--air-wire--+--|       |--- 7  HDdir ----|||
;   #            #    8  | |                        |  OUT  |                 |||
;   #            #       | |      ==========        |       |                 ||| t
;   #            #       | |      |        |        |       |                 ||| o
;   #            #       | |      |   IN   |        |       |                 |||
;   #            #       | |  8   |        |        |       |                 |||
;   #            #       | --/-->>|  data  |---+    |       |                 ||| P
;   #            #       +---/-->>|        |   |    |WRide_x|                 ||| I :
;   #            #          (16)  |        |   |    ---------                 ||| A :
;   #            #    :           |RDide_du|   |                              |||   :
;   #            #    :           |RDide_dl|   +------------------------------+++   :
;   ==============    :           ==========                                        :
;                     |                                                             |
;                     |__________________________________________I/O Board__________|
;
;
    ; OUTport #WRide_x

HDdirW	= 0x00		; bit 7 = "0" :: write to IDE disk 8/16 bit data
HDdirR	= 0x80		; bit 7 = "1" :: read from IDE disk lower 8/16 bit data
;
;			                 - 7 -- 6 -- 5 -- 4 -- 3 -- 2 -- 1 -- 0 -
RDide_dl	= 4	; INport  #4 :    D7   D6   D5   D4   D3   D2   D1   D0
WRide_dl	= 4	; outport #4 :    D7   D6   D5   D4   D3   D2   D1   D0
WRide_c		= 5	; outport #5 :    RST* RD*  WR* CS1* CS0*  A2   A1   A0
WRide_x		= 6	; outport #6 :    DDIR  -    -    -    -    -    -    -
;
;			                 - 7 -- 6 -- 5 -- 4 -- 3 -- 2 -- 1 -- 0 -
RDide_du	= 5	; INport  #5 :    D15  D14  D13  D12  D11  D10  D9   D8
WRide_du	= 7	; outport #7 :    D15  D14  D13  D12  D11  D10  D9   D8



; The approach of using the available I/O Board for interfacing the IDE disk needs
; some special attention for the software implementation. I try explain this here.
; The I/O Board is a resource of the system, and as such, needs controlled access.
; It must be prevented *at all time* that a currently executing disk access routine
; is *interrupted* by an FIRQ or IRQ routine *if* that interrupt routine will also
; access the hardware on the I/O Board!  That means that a simple interrupt routine
; that only changes the state of the RTS* pin of the ACIA (to blink the LED on the
; Core Board) poses no problem.
;
; Any disk task requested will need to change the I/O data transfer direction several
; times. For example: to *write* a command to the disk, the software must first check
; the disk's status by a *read* operation. After the command is written, again it is
; necessary to check the status (data request/available), etc.  To keep things simple
; all routines set the I/O data transfer direction explicit, but a flag indicates if
; the I/O data transfer direction change is required. The flag used is (idedir).
;
;
; Wiring from (my) IDE disk to I/O Board
;
;  ===========================================================================
;  |_____________________________ OUT56 connector ___________________________|
;  | pin# function     color code       | pin# function     color code       |
;  -------------------------------------|------------------------------------|
;  |  1    D4         white             |  2    D0         pink              |
;  |  3    D5         purple            |  4    D1         blue              |
;  |  5    D6         yellow            |  6    D2         brown             |
;  |  7    D7         grey              |  8    D3         green             |
;  |  9    CS1*       red               |  10   A0         white/beige       |
;  |  11   WR*        green/brown       |  12   A1         yellow/brown      |
;  |  13   RD*        green/white       |  14   A2         black             |
;  |  15   RST*       red/blue          |  16   CS0*       grey/pink         |
;  ===========================================================================
;
;
;  ===========================================================================
;  |_____________________________ OUT78 connector ___________________________|
;  | pin# function     color code       | pin# function     color code       |
;  -------------------------------------|------------------------------------|
;  |  1    -                            |  2    -                            |
;  |  3    -                            |  4    -                            |
;  |  5    -                            |  6    -                            |
;  |  7    DDIR       green             |  8    -                            |
;  |  9    D12        white             |  10   D8         pink              |
;  |  11   D13        purple            |  12   D9         blue              |
;  |  13   D14        yellow            |  14   D10        brown             |
;  |  15   D15        grey              |  16   D11        green             |
;  ===========================================================================
;
;
;  ===========================================================================
;  |______________________________ IN56 connector ___________________________|
;  | pin# function     color code       | pin# function     color code       |
;  -------------------------------------|------------------------------------|
;  |  1    D4         white             |  2    D0         pink              |
;  |  3    D5         purple            |  4    D1         blue              |
;  |  5    D6         yellow            |  6    D2         brown             |
;  |  7    D7         grey              |  8    D3         green             |
;  |  9    D12        white             |  10   D8         pink              |
;  |  11   D13        purple            |  12   D9         blue              |
;  |  13   D14        yellow            |  14   D10        brown             |
;  |  15   D15        grey              |  16   D11        green             |
;  ===========================================================================
;
;    NOTE 1:	INport #7 not used (for now).
;    NOTE 2:	OE* (pin #1) of OUTport #6 (IC7) is *not* in the IC socket
;		which means not connected to GND, but is connected literally
;		by an "air wire" to pin #19 of OUTport #5 (IC6).
;		To pull-up the signal voltage, a 4700 Ohms resistor is wired
;		from the OE* (pin #1) to +5 V. (pin #20).
;    NOTE 3:	If you decide to go for 16 bit data transfers, you must add
;		an extra output and input port. The extra output port´s OE*
;		must *** ALSO *** be connected to the air wire !!
;
;
;
;  IDE read/write and register description
; -----------------------------------------
; The IDE disk appears to the IDE bus as a set of registers. The register selection
; is done with the CS[0:1]* and A[0:2] lines. Reading/writing is done with the RD*
; and WR* signals.
;
;  * READ CYCLE
;    1. disable the data output port (set to 3-state).
;    2. set up an address, CS0* and CS1* signals on the control output port.
;    3. activate the RD* of the IDE disk.		\
;    4. read the data from the data input port.		 > repeat for each byte/word
;    5. deactivate the RD* signal.			/
;
;  * WRITE CYCLE
;    1. enable the data output port.
;    2. set up an address, CS0* and CS1* signals on the control output port.
;    3. write a data byte on the data output port.	\
;    4. activate the WR* of the IDE disk.		 > repeat for each byte/word
;    5. deactivate the WR* signal.			/
;
; ===================================================================================
; CS1* CS0*  A2  A1  A0
; -----------------------------------------------------------------------------------
;  1    0    0   0   0		RD/WR: data I/O register (16-bits)
;			    This is the only 16-bits wide register of the entire IDE
;			    interface. Used for all data block transfers from and to
;			    the IDE disk, but here only the lower 8 databits are used
;  1    0    0   0   1		RD: error information register
;				WR: write precompensation register
;			    Read this register when an error is indicated in the IDE
;			    status register (see below for the IDE status register).
;			    The write precompensation is not used.
;  1    0    0   1   0		Sector counter register
;			    This register can be used to do multi-sector transfers.
;			    You must write the number of sectors to transfer in this
;			    register.   I use one-sector only transfers, so in the
;			    code only 0x01 is written into this register.
;			    The register is also used to pass the parameter timeout
;			    for the idle mode command.
;  1    0    0   1   1		Start sector register
;			    Holds the start sector of the current track to start the
;			    read or write operation from.   For each transfer the
;			    start sector is written in this register.
;			    Note: the sector count starts at 1 and runs up to 256,
;				  so writing 0x00 results in sector number 256.
;			    If LBA is used, this register holds LBA bits [7:0].
;  1    0    1   0   0		Low byte of the cylinder number
;			    This register holds the low byte of the cylinder number
;			    for a disk data transfer.
;			    If LBA is used, this register holds LBA bits [15:8].
;  1    0    1   0   1		High two bits of the cylinder number
;			    The traditional IDE spec allows only cylinder numbers in
;			    the range 0..1023. This register gets the two upper bits.
;			    The cylinder number's upper 2 bits are written into this
;			    register before each transfer.
;			    If LBA is used, this register holds LBA bits [23:16].
;  1    0    1   1   0		Head and device select register
;			    Bits [3:0] of this register hold the head number (0..15)
;			    for a transfer. Bit [4] is to be written 0 for access to
;			    the IDE master device, 1 for access to the slave device.
;			    Bits [7:5] set the addressing mode to be used.
;				"101" = Cylinder/Head/Sector addressing mode
;				"111" = Logical Block Addressing mode is used.
;			    If LBA is used, this register holds LBA bits [27:24].
;  1    0    1   1   1		WR: Command register
;				RD: Status register
;			    When written the IDE disk regards the data written as a
;			    command. When read you get the status of the IDE disk.
;			    Reading this register also clears any interrupts from the
;			    IDE disk to the 6809 (not used / connected).
;  0    1    1   1   0		WR: interrupt and reset register
;				RD: 2nd status register
;			    When read this register gives you the same status byte as
;			    the primary (CS0*=0, CS1*=1, A[2:0]=111) status register.
;			    The only difference is that reading this register does
;			    not clear the interrupt from the IDE disk when read. When
;			    written you can enable/disable the interrupts the disk
;			    generates. Also used to give the disk a software reset.
;  0    1    1   1   1		active status of the IDE disk
;			    In this read-only register you can see if the IDE master
;			    or slave is currently active and find the currently
;			    selected head number. This register is not used.
; ___________________________________________________________________________________
;
;
;  Register bit specifications
; -----------------------------
;
;  * head and device register
;	A write register that sets the master/slave selection and the head number.
;		bits 3..0: head number [0..15]
;		bit  4   : master/slave select: 0=master, 1=slave
;		bits 7..5: fixed at '101' (512 bytes/sector, that's IDE)
;
;   * status register
;	Both the primary and secondary status register use the same bit coding.
;	The register is a read register.
;		bit 0    : error bit. If this bit is set then an error has occurred
;			   while executing the latest command. The error status
;			   itself is to be found in the error register.
;		bit 1    : index pulse. Each revolution of the disk this bit is
;			   pulsed to '1' once.
;		bit 2    : ECC bit. if this bit is set then an ECC correction on
;			   the data was executed. This bit is ignored here.
;		bit 3    : DRQ bit. If this bit is set then the disk either wants
;			   data (disk write) or has data for you (disk read).
;		bit 4    : SKC bit. Indicates that a seek has been executed with
;			   success. This bit is also ignored here.
;		bit 5    : WFT bit. indicates a write error has happened. Not used.
;		bit 6    : RDY bit. indicates that the disk has finished its power
;			   up. Wait for this bit to be active before doing any
;			   action (execpt reset) with the disk.
;		bit 7    : BSY bit. Bit is set when the disk is doing something
;			   for you. You must wait for this bit to clear before you
;			   can send any command to the disk.
;
;   * interrupt and reset register
;	This register has only two bits that do something. It is a write register.
;		bit 1    : IRQ enable. If this bit is '0' the disk will give an
;			   interrupt when it has finished executing a command. When
;			   it is '1' the disk will not generate interrupts.
;		bit 2    : RESET bit. If you pulse this bit to '1' the disk will
;			   execute a software reset. The bit is normally '0'. It is
;			   not used because there is full software control of the
;			   hardware RESET* line.
;
;   * active status register
;	This is a read register. Ignored because only one IDE disk is connected.
;		bit 0    : master active. If this bit is set then the master IDE
;			   disk is active.
;		bit 1    : slave active. If this bit is set then the slave IDE
;			   disk is active.
;		bits 5..2: complement of the currently active disk head.
;		bit 6    : write bit. This bit is set when the device is writing.
;		bit 7    : in a PC environment this bit indicates if a floppy is
;			   present in the floppy drive. Here it has no meaning.
;
;   * error register
;	The error register indicates what went wrong when a command execution
;	results in an error. The fact that an error has occurred is indicated in
;	the status register, the explanation is given in the error register.
;	This is a read register.
;		bit 0    : AMNF bit. Indicates that an address mark was not found.
;		bit 1    : TK0NF bit. When this bit is set the drive was not able
;			   to find track 0 of the device. I think you will have to
;			   throw away the disk if this happens.
;		bit 2    : ABRT bit. This bit is set when you have given a wrong
;			   command to the disk. Mostly wrong parameters (wrong head
;			   number etc..) cause the disk to respond with error flag
;			   in the status bit set and the ABRT bit set.
;		bit 3    : MCR bit. Indicates that a media change was requested.
;			   Ignored this bit; media change ...?
;		bit 4    : IDNF bit. Means that a sector ID was not found.
;			   It means that a non-existing sector is requested.
;		bit 5    : MC bit. Indicates that the media has been changed.
;			   This bit is ignored.
;		bit 6    : UNC bit. Indicates that an uncorrectable data error has
;			   occurred. Some read or write errors could cause this.
;		bit 7    : reserved.
;
;
;  Some historical points
; ------------------------
; At first (MSDOS versions till 3.3) the disk interface was not able to access more
; than 32MB on one volume. That was a imitation of the MSDOS file system rather than
; of the disk interface. The limit came from the fact that each disk sector
; (512 bytes) was registered in the FAT in a 16-bits word. The total partition size
; was limited by the fact that only 65536 sectors could be addressed. The partition
; size was thus limited to 65536 x 512 bytes = 32 MBytes.
;
; Later -as the disks became larger- the disk interface itself ran into its limits.
; The interface described here has room for 16 heads, 256 sectors per track and only
; 1024 cylinders. With the standard sector size of 512 bytes that leaves you a max
; disk size of 16 x 256 x 1024 x 512 = 2048 MBytes. That is a real limitation of the
; IDE interface decribed here. It can not access more than 2 Gb of disk space.
;
; This was overcome by introducing the so-called LBA modus. In LBA modus the sectors
; are simply numbered from 0 to -big-.  The lowest byte of the LBA sector number is
; written into the sector number register, the middle 16 bits of the LBA sector
; number are written in the cylinder number registers (low and high, all 16 bits are
; used). The highest 4 bits of the LBA sector number are written in the head and
; device register. That gives you 28 bits of LBA sector number.  The sector size was
; again fixed at 512 bytes, so in LBA modus you have access to: 2^28 x 512 = 1.37e11
; (some 128 Gb) of disk space.
; If you want to connect a disk larger than 2 GBytes to this IDE interface you must
; use the LBA modus.  How to do that: the bit 6 of the head and device register is
; set to indicate that LBA modus is used (the fixed pattern of '101' in the bits
; 7..5 of the head and device register is changed to '111').
; All other manipulation of the IDE interface is the same for Sector/Head/Cylinder
; mode and LBA mode.
;
;
;  IDE registers usage
; ---------------------
; 1) Before doing anything with a device you have to wait till it indicates that it
;    is ready (RDY bit in the status register)
; 2) Next load the parameters of a command into the appropriate registers.
;    For read/write commands, that comes down to writing the cylinder/head/sector
;    numbers or LBA value into the registers.
; 3) Issue a read or write command.
; 4) Wait till the device signals that it is ready for data transfer
;    (DRQ in the status register).
; 5) Feed the device data (for write) or get the data from the device (for read).
;    In case of a write you could wait for the operation to complete and read the
;    status register to find out what has become of your data.
;
;  IDE commands
; --------------
; Here is the *used* command set described. See the ATA-3 spec for full details.
; Remember, when giving a command you first have to wait for device ready, next put
; the command parameters in the registers and only then can you give a command (by
; writing a command byte to the command register). The disk will start executing
; the command right after you've written the command into the command register.
;
;   IDE
; command	description
; -----------------------------------------------------------------------------------
;   0x1*	recalibrate the disk. Remark: the '*' means that the lower nibble of
;		the command byte is a don't care. All commands 0x10 ..0x1F will cause
;		a recalibrate disk command being executed.
;		This command has no parameters. You simply write the command code to
;		the command register and wait for ready status to turn active again.
;   0x20	Read sector with retry. Remark: 0x21 is read sector without retry.
;		For this command you must load the cylinder/head/sector first. When
;		the command completes (DRQ goes active) you can read 256 words
;		(16-bits) from the disk's data register.
;   0x30	Write sector (with retry; 0x31 is without retry).  Again, you must
;		load the cylinder/head/sector data. Then wait for DRQ to turn active.
;		Feed the disk 256 words of data in the data register. Next the disk
;		starts writing. When BSY goes not active you can read the status from
;		the status register.
;   0x7*	Seek. This normally does nothing on modern IDE drives. Modern drives
;		do not position the head if you do not command a read or write.
;   0xEC	Identify drive. This command prepares a buffer (256 words) with
;		information about the drive. To use it simply give the command, wait
;		for DRQ and read the 256 words from the drive.  Use the parameters
;		reported to autoconfig the interface to match the disk configuration.
;   0xE0	Spins down the drive at once. No parameters.
;   0xE1	Spins up the drive again.
;   0xE2, 0xE3	Auto-powerdown the disk. Write in the sector count register the time
;		(5 seconds units) of non-activity after which the disk spins down.
;		Write the command to the command register and the disk is set in an
;		auto-power-save modus. The disk will automatically spin-up again when
;		you issue read/write commands. 0xE2 will spin-down, 0xE3 will keep
;		the disk spinning after the command has been given.
;		Example: write 0x10 in the sector count register, give command 0xE2
;		and the disk will spin-down after 80 seconds of non-activity. BTW:
;   0xF2, 0xF3	The same as 0xE2 and 0xE3, only the unit in the sector count register
;		is interpreted as 0.1 sec units. Not tested.
;
; ===================================================================================

	.module	cfc
	.radix	d
	.area	WORKPG	(PAG)
	.setdp	0,WORKPG


dbgCode	=	1	; 1 :: generate debug prints  // 0 :: disabled  
TstWire	=	0	; 1 :: include wire test code // 0 :: don't include it!
ifc8bit	=	0	; 1 :: 8-bit data bus to disk // 0 :: 16-bit data bus
useLBA	=	1	; 1 :: LBA access mode	      // 0 :: CHS access mode
			;      (IDEHd0: 111*)	      //      (IDEHd0: 101*)


    ; 6809 monitor I/O routines & hardware address locations

docrlf	=	0xC02D		; output CR/LF to console
ino	=	0xC00C		; input character (8 bits)
inch	=	0xC009		; get keyboard entry in [A], no echo
IN2HBO	=	0xC003		; input two hex char in one byte [A]
INCHNB	=	0xC00F		; input char, non-blocking, convert to uppercase
BADDRO	=	0xC018		; input hex (4-byte) address in [X]
OUTB2O	=	0xC021		; print data in [A] as 2 hexadecimal digits
outch	=	0xC024		; print character in [A] - not destroyed
OUTABT	=	0xC030		; print character in [A], [B] times repeated
OUT2CH	=	0xC027		; output 2 chars [A] then [B]
OUT2HS	=	0xC036		; print [X] as 2 hex followed by one space
OUT4HS	=	0xC039		; print [X] as 4 hex followed by one space

.firq	=	0x21F6		; FIRQ vector location in monitor RAM
.irq	=	0x21F8		; IRQ vector
.swi	=	0x21FA		; SWI vector
.nmi	=	0x21FC		; NMI vector

    ; serial port (MC6850, ACIA)

ACIACS	=	0x00F0		; ACIA control & status
ACIADA	=	ACIACS+1	; ACIA data I/O
ACIANI	=	0b00010001	; /16, 8N2, receiver IRQ disabled
ACIAI	=	0b10010001	; /16, 8N2, receiver IRQ enabled
RTSBIT	=	0b01000000	; RTS off / on bit  

   ; parallel ports (MC6821, PIA)

PIADA	=	0x00E0		; PIA data A register
PIACA	=	PIADA+1		;     control A register
PIADB	=	PIADA+2		;     data B register
PIACB	=	PIADA+3		;     control B register

   ; PIA [port A] ConTroL register bitmask
   ; - during execution reconfigured to input/output port
   ; - CA2=output, IRQ on CA1 enabled/disabled

PACTLI	=	0b00111100	; CA2="1", buffer LS245 -> input
PACTLJ	=	0b00111101	; as PACTLI, but CA1 irq enabled
PACTLO	=	0b00110100	; CA2="0", buffer LS245 -> output
PACTLQ	=	0b00110101	; as PACTLO, but CA1 irq enabled
DIRBIT	=	0b00000100	; access data-in/out or data-dir
CA2BIT	=	0b00001000	; CA2 bit: 245-buffer ctrl in/out
				; 0 :: output, 1 :: input
IOADDR	=	0b00111111	; bit [5:0] - board & port select address bits
RDWR  	=	0b01000000	; bit [6] - RD/WR direction:  0::read   // 1::write
DIS3S 	=	0b10000000	; bit [7] - LS138's control:  0::enable // 1::disable

   ; PIA [port B] ConTroL register bitmask
   ; - always configured as output port
   ; - CB2=output set to "0" (buffer LS245 -> output)
   ; - IRQ on CB1 disabled/enabled

PBCTLO	=	0b00110100	; CB1 irq disabled
PBCTLQ	=	0b00110101	; CB1 irq enabled


    ; ASCII constants

CR	=	0x0D		; Carriage return
LF	=	0x0A		; Line feed
CtrlC	=	0x03		; Control C
Space	=	0x20		; Space
BS	=	0x08		; Backspace
XON	=	0x11		; Data link "on"  prompt (DC1 or ^Q)
XOFF	=	0x13		; Data link "off" prompt (DC3 or ^S)
ESC	=	0x1B		; Escape


; ===================================================================================

    ; bits of the control byte on OUTport #WRide_c

DCNop	=	0b11111000	; nothing on IDE control bus
DCRes	=	0b10000000	; bit  [7]  = RST* bit
DCIor	=	0b01000000	; bit  [6]  = RD* bit
DCIow	=	0b00100000	; bit  [5]  = WR* bit
DCCs1	=	0b00010000	; bit  [4]  = CS1* bit
DCCs0	=	0b00001000	; bit  [3]  = CS0* bit
DCAd2	=	0b00000100	; bit  [2]  = A2 bit
DCAd1	=	0b00000010	; bit  [1]  = A1 bit
DCAd0	=	0b00000001	; bit  [0]  = A0 bit
DCAdr	=	0b00000111	; bit [2:0] = address mask bits

    ; IDE register addresses (RESET*,RD*, and WR* inactive)

IDECmd	=	0b11110111	; command (WR)
IDESts	=	0b11110111	; status register (RD)
IDEHd	=	0b11110110	; head number
IDEcylH	=	0b11110101	; cylinder number high
IDEcylL	=	0b11110100	; cylinder number low
IDEsec	=	0b11110011	; sector number
IDEnum	=	0b11110010	; number of sectors
IDEErr	=	0b11110001	; error register
IDEData	=	0b11110000	; data bus
IDEDvc	=	0b11101110	; drive control (WR)
IDEAlt	=	0b11101110	; alternate status (RD)

    ; head number (0..F) also has the mask for master/slave
    ; Hard-coded to 'master' as I will not use a second drive.

IDEHdA	=	0b00001111	; head number "AND" mask
	.if	useLBA
IDEHd0	=	0b11100000	; head number "OR" mask: drive #0, use LBA
	.else
IDEHd0	=	0b10100000	; head number "OR" mask: drive #0, use C/H/S
	.endif

    ; bits from Device control register - IDEDvc

IDERes	=	0b00000100	; Soft Reset bit
IDEIrq	=	0b00000010	; 0 :: IRQ active

    ; bits from Status Register - IDESts

StsBsy	=	0b10000000	; busy flag
StsRdy	=	0b01000000	; ready flag
StsWft	=	0b00100000	; Write error
StsSkc	=	0b00010000	; seek complete
StsDrq	=	0b00001000	; Data Request
StsCorr	=	0b00000100	; ECC executed
StsIdx	=	0b00000010	; Index found
StsErr	=	0b00000001	; error flag

    ; IDE disk Command opcodes

CmdRecal	=	0x10	; recalibrate disk
CmdRead		=	0x20	; read sector(s)
CmdWrite	=	0x30	; write sector(s)
CmdDiag		=	0x90	; execute diagnostics
CmdStop		=	0xE0	; stop disk
CmdStrt		=	0xE1	; start disk
CmdIdent	=	0xEC	; identify disk


    ; In the default state the control is inactive: RESET*, RD* and WR* signals
    ; are set to "1", CS1* and CS0* are set to "1", and A[2-1-0] = "000" (#DCNop).
    ; I use a memory command packet to pass parameters to the disk.
    ; Packet description:

SDA	=	0	; offset src/dest address in memory for the operation
LBA3	=	2	; offset LBA
LBA2	=	3	;  :
LBA1	=	4	;  : 32-bits number for a disk of max 2.1E12 bytes !
LBA0	=	5	;  :


    ; Lineair Block Access (LBA) is used ** ALL THE TIME **.
    ;
    ; For disks that do not support LBA by itself, a routine called SetLBA
    ; is available to convert the LBA to a CHS configuration.
    ; 2 parameters are used to describe the disk geometry:
    ;    - the number of blocks per cylinder; in CHS terms this is HxS
    ;    - the number of blocks per track; in CHS terms this is S
    ; From these two parameters, conversion of LBA to CHS is done.
    ; They are defined by the following two words.

	.if	useLBA
	.else

    ; Quantum ProDrive LPS420 with specified CHS: 1010/16/51

SPC	=	1010	; 420 MB disk - #Sectors per Cylinder
SPT	=	51	; 420 MB disk - #Sectors per track

    ; Quantum Fireball 640AT with specified CHS: 1244/16/63

; SPC	=	1244	; 420 MB disk - #Sectors per Cylinder
; SPT	=	63	; 420 MB disk - #Sectors per track

	.endif


     ; storage in WORKPG

idedir:	.rmb	1	; indicator: PIA [port A] current data direction
idectl:	.rmb	1	; current written IDE control byte
iodatd:	.rmb	1	; current I/O databus active data direction
sav1:	.rmb	1	; byte scratch (-local- inside subroutine!)
sav2:	.rmb	2	; word scratch (-local- inside subroutine!)
savpsb:	.rmb	1	; save location for processor status byte [EFHINZVC]
rtssts:	.rmb	1	; RTS* pin status of ACIA
timcnt:	.rmb	1	; time-out interval setpoint value
timer:	.rmb	1	; running time-out interval value
prgmod:	.rmb	1	; program mode: $00 = "level-0" // $FF = "FAT-16"
CmdPkt:	.rmb	2	; source/destination data buffer address
	.rmb	4	; LBA

	.if	useLBA
	.else
seccyl:	.rmb	2	; disk parameter: # sectors / cylinder
sectrk:	.rmb	2	; disk parameter: # sectors / track
	.endif

;
	.if	TstWire
idedat:	.rmb	1	; current written IDE data byte
ioport:	.rmb	1	; inport / outport number used for test
dtmska:	.rmb	1	; active AND mask to clear the bit position
dtmsko:	.rmb	1	; active OR mask to set the bit position
	.endif

	.if	dbgCode
trace:	.rmb	2
	.endif



	.area	DATAPG

    ; disk data buffer and stack space

	.if	ifc8bit
IDEbuf:	.rmb	256		; room for 256 bytes
	.else
IDEbuf:	.rmb	512		; room for 256 words
	.endif

IDEstk	=	0xBF00		; start of stack (top of RAM - grows downward)




	.area	IDE	(ABS,OVR)

	; IDE hard disk test program

X_IDE:	lds	#IDEstk		; init stack pointer

	.if	dbgCode
	ldx	#IDEstk-80	; erase stack area
10$:	clr	,x+		; surrounding initial SP
	cmpx	#IDEstk+16
	bne	10$
	.endif

	ldd	#WORKPG		; set all var's in "zero-page"
	tfr	a,dp
	ldx	#CFCmsg		; issue identification message
	jsr	pdatao
	jsr	HWinit		; initialise the I/O Board - 6821 PIA

	.if	TstWire
	jsr	ChkHw		; check hardware wiring
	.endif

	jsr	IDEini		; initialise IDE hardware and disk
	ldx	#999$
	jsr	pdatao		; print "CF Card access init done" message
	clr	*prgmod		; program mode := "level-0"
	bra	xcmd1
;
999$:	.fcb	CR,LF
	.fcc	"   CompactFlash Card initialisation & access completed"
	.fcb	CR,LF,0


x_cmd:	ldx	#HlpTx0		; assume level-0 test mode
	tst	*prgmod
	beq	10$
	ldx	#HlpTx1		; nope - FAT-16 test mode
10$:	jsr	pdatao		; print available commands list
;
xcmd1:	ldx	#prmpt0
	tst	*prgmod
	beq	10$
	ldx	#prmpt1
10$:	jsr	pdatao		; issue correct prompt
;
xcmd2:	jsr	inch		; await command letter, no echo
	cmpa	#'?		; show available commands again?
	bne	10$
	jsr	outch		; y - display "?"
	bra	x_cmd		;     and output list
10$:	cmpa	#ESC		; terminate program ?
	bne	20$
	jmp	0xC04A		; y - warm jump to CORESYS09 monitor
;
20$:	anda	#0x5F		; force uppercase
	cmpa	#'z
	bhi	xcmd5		; restrict entry to printable ASCII (0-z)
	cmpa	#'0
	blo	xcmd5
	ldx	#cmdtb0		; set correct command lookup table
	tst	*prgmod
	beq	xcmd3
	ldx	#cmdtb1
xcmd3:	ldb	,x		; end of table ?
	beq	xcmd5		; y - bad command
	cmpa	,x+		; match entry with table
	beq	xcmd4
	leax	2,x		; n - move to next entry in table
	bra	xcmd3
xcmd4:	jsr	outch		; y - print entered character
	ldx	,x		;     get routine address
	jsr	,x		;     execute requested function
	bra	xcmd1
xcmd5:	ldx	#illcmd		; print "command not recognized"
	jsr	pdatao
	bra	xcmd1
;
selFAT:	clr	*prgmod
	com	*prgmod		; select FAT-16 test routines
	rts
selLV0:	clr	*prgmod		; select level-0 test routines
	rts
;
;
cmdtb0:	.fcc	'I'		; Identify
	.fdb	DIdent
	.fcc	'R'		; Read sector
	.fdb	DRead
	.fcc	'W'		; Write sector
	.fdb	DWrite
	.fcc	'C'		; 'Clear' disk (initialize)
	.fdb	IDEini
	.fcc	'F'		; goto FAT-16 test routines
	.fdb	selFAT
	.fcb	0		; end of level-0 command table
;
;
cmdtb1:	.fcc	'B'		; Boot sector information
	.fdb	fatsc1
	.fcc	'D'		; Directory of root
	.fdb	fatsc2
	.fcc	'G'		; Get file from disk
	.fdb	fatsc3
	.fcc	'S'		; Save file to disk
	.fdb	fatsc4
	.fcc	'C'		; Change directory
	.fdb	fatsc5
	.fcc	'L'		; goto LEVEL-0 test routines
	.fdb	selLV0
	.fcb	0		; end of FAT-16 command table



HlpTx0:	.fcb	CR,LF
	.fcc	"basic I/O:  C=Clear (initialize)   R=Read sector"
	.fcb	CR,LF
	.fcc	"            I=Identify CF media    W=Write sector   F=FAT16 I/O"
	.fcb	CR,LF,0
HlpTx1:	.fcb	CR,LF
	.fcc	"FAT16 I/O:  B=Bootsector   D=Directory   C=Change directory"
	.fcb	CR,LF
	.fcc	"            S=Save file    G=Get file    L=basic I/O"
	.fcb	CR,LF,0

prmpt0:	.fcb	CR,LF
	.asciz	".BIO [CIRWF?]-> "
prmpt1:	.fcb	CR,LF
	.asciz	".FAT [BDCGSL?]-> "

illcmd:	.asciz	"! - command not recognized"




	.if	dbgCode
DbgPrt:	jsr	docrlf
	jmp	pdatao
	.endif




;	***-----------------------------------------***
;	***   LEVEL-0 action routine : "IDENTIFY"   ***
;	***-----------------------------------------***

DIdent:	ldx	#CmdPkt		; set pointer to command packet
	ldd	#IDEbuf
	std	,x		; load data buffer address
	clra
	clrb
	std	2,x		; load LBA = 0
	std	4,x
	jsr	IdDisk		; retrieve data from disk
	bcc	99$
	jmp	DskErr		; error occurred -> report and RTS
99$:	jmp	IdRprt		; OK - display information and RTS





;	***--------------------------------------------***
;	***   LEVEL-0 action routine : "READ SECTOR"   ***
;	***--------------------------------------------***

DRead:	ldu	#rdtxt
	bsr	SolDat		; sollicit for required data
	bcs	99$		; - aborted
	ldx	#CmdPkt		; set pointer to command packet
	jsr	rdDsec		; read sector
	bcc	98$
	jmp	DskErr		; error occurred -> report it and RTS
98$:	ldx	*CmdPkt		; OK - get memory start address
	jsr	bufdmp		;      display some contents
99$:	rts



;	***---------------------------------------------***
;	***   LEVEL-0 action routine : "WRITE SECTOR"   ***
;	***---------------------------------------------***

DWrite:	ldu	#wrtxt
	bsr	SolDat		; sollicit for required data
	bcs	99$		; - aborted
	ldx	#CmdPkt		; set pointer to command packet
	jsr	wrDsec		; write sector
	bcc	98$
	jmp	DskErr		; error occurred -> report it and RTS
98$:	ldx	*CmdPkt		; OK - get memory start address
	jsr	bufdmp		;      display some contents
99$:	rts




;  SolDat - sollicit for data
;
;  call   : [U] - pointer to set of text strings
;  return : cC=0  -> command complete
;		     CmdPkt parameters loaded
;	    cC=1  -> command aborted

SolDat:	jsr	pdatu		; prompt for 8 digit sector#
	jsr	BADDRO		; get msb 4 digits
	stx	*CmdPkt+2
	jsr	BADDRO		; get lsb 4 digits
	stx	*CmdPkt+4
	jsr	pdatu		; prompt for 4 digit memory address
	jsr	BADDRO
	stx	*CmdPkt
	jsr	pdatu		; sure to execute command ?
10$:	jsr	inch
	anda	#0x5F		; make entry uppercase
	cmpa	#'N
	beq	20$
	cmpa	#'Y
	bne	10$
	jsr	outch		; print "Y"
	andcc	#0xFE		; cC = 0
	rts
20$:	ldx	#SolAbt
	jsr	pdatao		; print "N" and 'command aborted'
	orcc	#0x01		; cC=1
	rts


   ; formatted text: keep "rdtxt" and "wrtxt" in this order !!

rdtxt:	.fcb	CR,LF
	.asciz	"   > enter 8 hex digit sector number : $"
	.fcb	CR,LF
	.asciz	"   > enter 4 hex digit write-to address : $"
	.fcb	CR,LF
	.asciz	"   > EXECUTE READ SECTOR COMMAND [y/n] --> "

wrtxt:	.fcb	CR,LF
	.asciz	"   > enter 8 hex digit sector number : $"
	.fcb	CR,LF
	.asciz	"   > enter 4 hex digit read-from address : $"
	.fcb	CR,LF
	.asciz	"   > EXECUTE WRITE SECTOR COMMAND [y/n] --> "

SolAbt:	.fcc	"N  --> command aborted"
	.fcb	CR,LF,0






;  HWinit - initialize Core and I/O hardware
;
;  * must be called -before- the initialization of the IDE 'hardware'.
;    HWinit also sets a dummy IRQ vector.
;
;    call   : [DP] - set to correct "zero-page" for program variable storage
;    return : 6821 PIA I/O initialized for I/O Board connection
;	      FIRQ vector set to flash Core monitor LED
;	      FIRQ enabled on 6809.  IRQ, SWI, NMI set to dummy routine.

HWinit:	orcc	#0x50		; make sure 6809 FIRQ and IRQ are disabled
	lda	#ACIANI
	sta	ACIACS
	sta	*rtssts
	lda	ACIADA		; clear ACIA

	ldx	#FIRQld
	stx	.firq		; load FastIRQ destination vector
	lda	#25
	sta	*timcnt		; set flash rate approx 2 Hz.
	ldx	#dumirq
	stx	.nmi		; load NMI destination vector
; ---	stx	.swi		; load SWI destination vector
	stx	.irq		; load IRQ destination vector (ACIA)

	clra			; configure PIA port A & B
	sta	PIACA		; access data direction reg A
	sta	PIADA		; default: port A == input
	ldb	#PACTLJ		; control mask set for direction: input
	stb	PIACA		; access data reg A
	stb	*idedir		; set flag: port A set to "INPUT"
	sta	PIACB		; access data direction reg B
	coma
	sta	PIADB		; always: port B == output
	ldb	#PBCTLO		; control mask set for direction: output
	stb	PIACB		; access data reg B
	andcc	#0b10111111	; enable 6809-FIRQ
	ldx	#999$
	jsr	pdatao		; print "hardware init done" message
	rts

999$:	.fcc	"   Core & I/O Board hardware initialisation completed"
	.fcb	CR,LF,0




;  IDEini - initialize the IDE disk
;
;  call   : I/O Board - 6821 PIA and interrupt mask (IRQ,FIRQ) must be initialized
;  return : (iodatd) initialised = IDE I/O data direction
;	    (idectl) initialised
;	    IDE disk reset

	.if	dbgCode
IDEi0:	.asciz	"   IDE device initialization"
IDEi1:	.asciz	"   1. issue CmdDiag command"
IDEi2:	.asciz	"   2. clear SoftReset bit"
IDEi3:	.asciz	"   3. select head number #0"
IDEi4:	.asciz	"   4. issue ReCal command"
	.endif

IDEini:	.if	dbgCode
	ldx	#IDEi0
	jsr	DbgPrt
	.endif

	tfr	cc,a		; copy current IRQ/FIRQ bits
	pshs	a
	orcc	#0x50		; disable FIRQ and IRQ
	lda	#HDdirR		; data direction := INPUT
	sta	*iodatd		; set I/O data direction = read
	ldb	#WRide_x	; get port with DDIR bit
	jsr	IO_WRT		; and set I/O data direction

	.if	useLBA
	.else
	ldd	#SPC
	std	*seccyl		; set up #Sectors per Cylinder
	ldd	#SPT
	std	*sectrk		; set up #Sectors per track
	.endif

	lda	#DCNop		; set control: all signals inactive
	sta	*idectl		; store active IDE control byte
	ldb	#WRide_c	; get IDE control output port #
	jsr	IO_WRT		; write control byte to IDE control
	lda	#DCNop-DCRes
	jsr	IO_WRT		; assert RESET*
	clra
10$:	deca			; pulse width > 25 uSec (spec)
	bne	10$
	lda	#DCNop		; negate RESET*
	jsr	IO_WRT

	.if	dbgCode
	ldx	#IDEi1
	jsr	DbgPrt
	.endif

	lda	#CmdDiag	; execute drive diagnostics
	jsr	wrtCmd
	jsr	WtNbsy		; wait for drive not busy status
	jsr	WtDrdy		; wait for drive ready status

    ; ATA spec requires that SoftReset bit must be written to 0

	.if	dbgCode
	ldx	#IDEi2
	jsr	DbgPrt
	.endif

	lda	#IDEDvc
	jsr	SetAdr		; select device control register
	lda	#IDEIrq		; [IRQenable] = disabled
;	anda	#IDERes^0xFF	; [SoftReset] = 0
	jsr	wrbyte
	jsr	WtNbsy		; wait for drive not busy status
	jsr	WtDrdy		; wait for drive ready status

    ; select the disk device, I use "select head number #0"

	.if	dbgCode
	ldx	#IDEi3
	jsr	DbgPrt
	.endif

	lda	#IDEHd
	jsr	SetAdr
	lda	#IDEHd0		; use C/H/S or LBA format, drive #0, head #0
	jsr	wrbyte
	jsr	WtNbsy		; wait for disk not busy
	jsr	WtDrdy		; wait for drive ready status

	.if	dbgCode
	ldx	#IDEi4
	jsr	DbgPrt
	.endif

	lda	#CmdRecal
	jsr	wrtCmd		; issue the recalibrate command
	jsr	WtNbsy		; and wait until command executed
	jsr	WtDrdy		; wait for drive ready status
	puls	a
	tfr	a,cc		; restore FIRQ/IRQ flags
	rts







  ;  ***************==============    FIRQ  routine    ==============***************

  ; The interrupt is based on a timer event that triggers the CA1 pin of the PIA.
  ; The following processes are executed inside the interrupt routine:
  ; 1. the IRQ flag of the PIA is cleared
  ; 2. <timer> is decremented. On reaching $00 the following actions are done:
  ;    - <timer> is reloaded with <timcnt>
  ;    - <rtssts> is tested/changed and the monitor LED (at the RTS pin) is toggled

FIRQld:	pshs	d
	lda	PIADA		; dummy read: clear IRQ flag
	lda	*timer		; source == PIA [port A] - CA1 (timer)
	deca			; adjust/check monitor LED interval elapsed ?
	sta	*timer
	bne	pirq2
				; y - perform monitor LED update
pirq1:	lda	*timcnt		; reload interval time
	sta	*timer
	ldb	*rtssts		; toggle monitor LED on/off
	bitb	#RTSBIT
	beq	pirq1a
	andb	#RTSBIT^0xFF	; RTS:=1, LED on
	bra	pirq1b
pirq1a:	orb	#RTSBIT		; RTS:=0, LED off
pirq1b:	stb	ACIACS
	stb	*rtssts
pirq2:	puls	d
dumirq:	rti







; ###################################################################################
; ##										   ##
; ##		Status reporting : Disk error formatting and display		   ##
; ##		Disk Identification summary display				   ##
; ##										   ##
; ###################################################################################



;  DskErr - give extensive error reporting for disk errors
;
;  call   : [X] - pointer to command packet
;		[0:1] = buffer (data information) address
;  return : error messages about what went wrong with a disk access
;	    (sav2) used for temporary local storage

DskErr:	tfr	cc,a		; copy current IRQ/FIRQ bits
	pshs	a
	orcc	#0x50		; disable FIRQ and IRQ
	stx	*sav2		; save pointer to LBA
	ldx	#ErrDsk		; print general error message & error status text
	jsr	pdatao
	lda	#IDESts		; - IDE status register
	jsr	rdDreg
	jsr	OUTB2O
	jsr	pdatao		; print error bits text
	lda	#IDEErr		; - error bits
	jsr	rdDreg
	jsr	OUTB2O
	jsr	pdatao		; print LBA where error occurred
	ldx	*sav2
	ldd	LBA3,x
	jsr	OUTB2O
	tfr	b,a
	jsr	OUTB2O
	ldd	LBA1,x
	jsr	OUTB2O
	tfr	b,a
	jsr	OUTB2O

	.if	useLBA
	ldx	#ErrLBA		; print LBA where it happened
	jsr	pdatao
	lda	#IDEHd
	jsr	rdDreg
	anda	#0b00001111	; LBA[27:24]
	jsr	OUTB2O
	lda	#IDEcylH
	jsr	rdDreg
	jsr	OUTB2O		; LBA[23:16]
	lda	#IDEcylL
	jsr	rdDreg
	jsr	OUTB2O		; LBA[15:8]
	lda	#IDEsec
	jsr	rdDreg
	jsr	OUTB2O		; LBA[7:0]
	jsr	docrlf
	puls	a
	tfr	a,cc		; restore FIRQ/IRQ flags
	rts

	.else
	ldx	#ErrCHS		; print CHS where it happened
	jsr	pdatao
	lda	#IDEcylH
	jsr	rdDreg
	jsr	OUTB2O
	lda	#IDEcylL
	jsr	rdDreg
	jsr	OUTB2O
	bsr	slash
	lda	#IDEHd
	jsr	rdDreg
	jsr	OUTB2O
	bsr	slash
	lda	#IDEsec
	jsr	rdDreg
	jsr	OUTB2O
	jsr	docrlf
	puls	a
	tfr	a,cc		; restore FIRQ/IRQ flags
	rts

slash:	lda	#'/
	jmp	outch		; print "/" and RTS

	.endif


;  IdRprt - give extensive disk identification report
;
;  call   : [X] - pointer to command packet
;		[0:1] = buffer (data destination) address
;		buffer data contains IdDisk routine result
;		** remark: this is in LOW-HIGH word format (Intel)
;  return : disk identification information printed on screen
;	    (sav2) used for temporary local storage

IdRprt:	pshs	d,x
	ldx	SDA,x		; [X] -> ident data
	stx	*sav2
	ldx	#IDModel	; print model name
	jsr	pdatao
	ldx	*sav2
	ldb	#54		; start in SDA block
	abx
	ldb	#20		; 20 words
	tst	1,x		; see if any name there
	beq	20$
10$:	lda	1,x		; yep - get 2 bytes (LOW-HIGH)
	jsr	outch		;       and print them
	lda	,x
	jsr	outch
	leax	2,x
	decb
	bne	10$
	bra	30$
20$:	ldx	#IDNoMod	; nope - tell so
	jsr	pdatao

30$:	ldx	*sav2
	ldx	#IdAta		; print ATA/ATAPI mode
	jsr	pdatao
	ldx	*sav2
	lda	1,x		; get ATA/ATAPI status
	ldx	#IdmAta		; assume it is an ATA device
	anda	#0b10000000
	beq	40$		; - ATA
	ldx	#IdmAtapi	; - ATAPI
40$:	jsr	pdatao		; print the device type

	ldx	*sav2
	lda	,x		; check drive type: removable/fixed
	ldx	#IDRem		; assume it is a removable disk
	anda	#0b01000000
	beq	50$		; - removable disk
	ldx	#IDFix		; - fixed disk
50$:	jsr	pdatao

	ldx	#IDtCHS
	ldb	#2		; print # of cylinders
	bsr	pr4hex
	ldb	#6		; print # of heads
	bsr	pr4hex
	ldb	#12		; print # of sectors
	bsr	pr4hex
	ldx	#iddump
	jsr	pdatao		; "first 63 words sector dump"
	ldx	*sav2
	ldb	#8
	stb	*sav1		; 8 lines output of 8 words each
60$:	ldb	#8		; 8 words per line
	jsr	docrlf
61$:	lda	,x+
	jsr	OUTB2O		; print 1st byte hex
	lda	,x+
	jsr	OUTB2O		; print 2nd byte hex
	lda	#Space
	jsr	outch		; print 2 separator spaces
	jsr	outch
	decb			; 8 words done on this line ?
	bne	61$		; n -
	dec	*sav1		; y - 8 lines done (64 words) ?
	bne	60$		;     n -
	jsr	docrlf		;     y - print extra blank line
	puls	d,x,pc



;  pr4hex - print 4 hex digits (2 bytes in INTEL format)
;
;  call   : [X]    - ptr to text string to print
;	    (sav2) - ptr to base of dump
;	    [B]    - offset to LOW byte
;  return : [X] and (sav2) not changed

pr4hex:	bsr	pdatao		; print text string
	pshs	x
	ldx	*sav2
	abx
	lda	1,x		; print HIGH byte
	jsr	OUTB2O
	lda	,x		; print LOW byte
	jsr	OUTB2O
	puls	x,pc



;  pdatcr - print CR/LF, then string, NULL ended
;  pdatao - print text string, NULL ended
;
;  call   : [X] = pointer to start of string, string ended by *NULL* token
;  return : [X] points to the byte following the NULL character
;	    no other registers changed

pdatcr:	jsr	docrlf		; print new line
pdatao:	pshs	a
	lda	,x+		; get char
	beq	pdatax		; done -
pdata:	jsr	outch
	lda	,x+
	bne	pdata
pdatax:	puls	a,pc




;  bufdmp - dump buffer in hex bytes and (printable) ASCII
;
;  call   : [X] = pointer to start of buffer
;	    after a dump of 8 lines (16 bytes) a continuation is asked
;  return : [X,Y,D] not changed
;	    (sav1) destroyed

	.if	ifc8bit
DMPRPT	=	2		; dump repeat = 2 x 8 lines of 16 bytes (= 256)
	.else
DMPRPT	=	4		; dump repeat = 4 x 8 lines of 16 bytes (= 512)
	.endif

bufdmp:	pshs	x,y,d
	pshs	x
	ldx	#888$
	bsr	pdatao
	puls	x		; dump from start of buffer
	lda	#DMPRPT		; # repeats
	sta	*sav1
;
9$:	ldy	#8		; 8 lines of 16 bytes
10$:	jsr	docrlf		; start with new line
	ldb	#16
20$:	jsr	OUT2HS		; print byte as 2 hex plus a space
	decb			; 16 bytes printed in hex format ?
	bne	20$		; n -
	lda	#Space		; y - first print 2 extra spaces
	jsr	outch
	jsr	outch
	ldb	#16
	leax	-16,x		;     put pointer back
30$:	lda	,x+		;     print as ASCII (if printable)
	cmpa	#0x20
	bls	35$
	cmpa	#0x7E
	bls	40$
35$:	lda	#Space		;     not-printable: print a space
40$:	jsr	outch
	decb			;     16 bytes printed as ASCII ?
	bne	30$
	leay	-1,y		;     y - all lines printed ?
	bne	10$		;	  n -
;
	dec	*sav1		; # repeats now zero?
	beq	70$		; y - dump done
	pshs	x
	ldx	#999$
	bsr	pdatao
	puls	x
50$:	jsr	inch		; n - await continuation entry
	anda	#0x5F		;     make entry uppercase
	cmpa	#'N
	beq	60$
	cmpa	#'Y
	bne	50$
	jsr	outch		; print "Y" entry
	bra	9$		;       and dump next block
60$:	jsr	outch		; print "N" entry
70$:	jsr	docrlf
	puls	x,y,d,pc

888$:	.fcb	CR,LF
	.asciz	"-- buffer contents:"
999$:	.fcb	CR,LF
	.asciz	"-- continue? [y/n] : "







; ########################################################################
; ##									##
; ##	LEVEL-0 commands - actual execution action routines		##
; ##									##
; ##		=  retrieve disk identification information		##
; ##		=  read and write ONE sector (256/512) bytes		##
; ##		=  translate LBA to CHS and load parameters		##
; ##									##
; ########################################################################



;  IdDisk - get the disk's parameters from the disk itself
;
;  call   : [X] - pointer to command packet
;		[0:1] = buffer (data destination) address
;		[2:5] = LBA ($00000000)
;  return : cC=1  -> error occurred
;	    cC=0  -> identification data read into the supplied buffer

IdDisk:	tfr	cc,a		; copy current IRQ/FIRQ bits
	pshs	a
	orcc	#0x50		; disable FIRQ and IRQ
	jsr	WtNbsy		; wait till disk ready
	lda	#CmdIdent	; issue Ident command
	jsr	wrtCmd
	jsr	WtNbsy		; wait for busy gone
	jsr	rdDsts		; test for errors - get status byte
	bita	#StsErr		; check error bit
	beq	idget1
	puls	a
	tfr	a,cc		; restore FIRQ/IRQ flags
	orcc	#0x01		; error -> cC=1
	rts
idget1: jsr	WtDdrq		; wait for DRQ
	pshs	x		; transport the data block to destination
	ldx	SDA,x		; set destination address
	jsr	rddata		; get the information
	puls	x
	puls	a
	tfr	a,cc		; restore FIRQ/IRQ flags
	andcc	#0xFE		; cC=0 -> all OK
	rts



;  rdDsec - reads one sector from the IDE disk
;
;  call   : [X] - pointer to command packet
;		[0:1] = buffer (data destination) address
;		[2:5] = LBA3:LBA0
;  return : cC=1 -> error occurred
;	    cC=0 -> data read into the supplied buffer

rdDsec:	tfr	cc,a		; copy current IRQ/FIRQ bits
	pshs	a
	orcc	#0x50		; disable FIRQ and IRQ
	jsr	WtNbsy		; wait for busy bit cleared (disk ready)
	lda	#IDEHd		; select disk 0
	jsr	SetAdr
	lda	#IDEHd0		; format: use C/H/S or LBA, drive #0
;	anda	#IDEHdA		; select head #0
	jsr	wrbyte
				; load parameters
	jsr	SetLBA		; set address
	lda	#CmdRead	; issue read command
	jsr	wrtCmd
	jsr	WtNbsy		; and wait for busy gone
				; check for errors
	jsr	rdDsts		; get status byte
	bita	#StsErr		; test error bit
	beq	rdsec1
	puls	a
	tfr	a,cc		; restore FIRQ/IRQ flags
	orcc	#0x01		; error -> cC=1
	rts
rdsec1: jsr	WtDdrq		; wait for DRQ
	pshs	x		; transport the data block to destination
	ldx	SDA,x		; get destination address
	bsr	rddata		; get the data
	puls	x
	puls	a
	tfr	a,cc		; restore FIRQ/IRQ flags
	andcc	#0xFE		; cC=0 -> all ok
	rts



;  rddata - read one block from the IDE disk
;
;  call   : [X] - pointer to 256/512 bytes buffer
;	    all disk parameters (C/H/S or LBA) loaded into drive's registers
;	    Data_Request is active (been awaited by routine that calls this function)
;  return : supplied buffer holds 256 bytes/words from specified (preloaded) sector

rddata:	pshs	d,x,y
	lda	#IDEData
	jsr	SetAdr		; select Data Register
	jsr	SetIn
	ldy	#256		; set 256 read operations counter
rdblk:	ldb	#WRide_c	; set IDE control OUTPUT port #
	lda	*idectl		; get current active IDE control byte
	anda	#DCIor^0xFF	; assert RD*
	jsr	IO_WRT
	ldb	#RDide_dl	;    set IDE data INPUT port #
	jsr	IO_RD		;    get data byte
	sta	,x+

	.if	ifc8bit
	.else
	ldb	#RDide_du	;    set IDE data INPUT port #
	jsr	IO_RD		;    get data byte
	sta	,x+
	.endif

	ldb	#WRide_c	; set IDE control OUTPUT port #
	lda	*idectl		; negate RD*
	jsr	IO_WRT
	leay	-1,y
	bne	rdblk		; until all read operations done
	puls	d,x,y,pc



;  wrDsec - writes one sector to the IDE disk
;
;  call   : [X] - pointer to command packet
;		[0:1] = buffer (data source) address
;		[2:4] = LBA High, Middle, Low
;  return : cC=1 -> error occurred
;	    cC=0 -> data written to the disk OK

wrDsec:	tfr	cc,a		; copy current IRQ/FIRQ bits
	pshs	a
	orcc	#0x50		; disable FIRQ and IRQ
	jsr	WtNbsy		; wait for busy bit cleared (disk ready)
	lda	#IDEHd		; select disk 0
	jsr	SetAdr
	lda	#IDEHd0		; format: use C/H/S, drive #0
;	anda	#IDEHdA		; select head # 0
	jsr	wrbyte
	bsr	SetLBA		; set address
	lda	#CmdWrite	; issue write command
	jsr	wrtCmd
	jsr	WtNbsy		; wait till command ready
				; check for errors
	jsr	rdDsts		; get status byte
	bita	#StsErr		; test error bit
	beq	wrsec1		; no error -> continue
	puls	a
	tfr	a,cc		; restore FIRQ/IRQ flags
	orcc	#0x01		; error -> cC=1
	rts
wrsec1:	jsr	WtDdrq		; wait for DRQ
	pshs	x		; transport the data block
	ldx	SDA,x		; get source address
	bsr	wrdata		; save the data to disk
	puls	x
	puls	a
	tfr	a,cc		; restore FIRQ/IRQ flags
	andcc	#0xFE		; cC=0 -> all ok / enable FIRQ
	rts



;  wrdata - write one block of data to the IDE disk
;
;  call   : [X] - pointer to 256/512 bytes data buffer
;	    all disk parameters (C/H/S) loaded into drive's registers
;	    Data_Request is active (been awaited by routine that calls this function)
;  return : supplied buffer written to specified (preloaded) sector
;	    local variable (sav1) = $00

wrdata:	pshs	d,x
	jsr	SetOut		; set I/O databus to output
	lda	#IDEData
	jsr	SetAdr		; select Data Register
	clr	*sav1		; set 256 write operations counter
wrblk:	ldb	#WRide_dl	; set IDE data OUTPUT port #
	lda	,x+
	jsr	IO_WRT		; write data byte
	.if	ifc8bit
	.else
	ldb	#WRide_du	; set IDE data OUTPUT port #
	lda	,x+
	jsr	IO_WRT		; write data byte
	.endif
	ldb	#WRide_c	; set IDE control OUTPUT port #
	lda	*idectl		; get current active IDE control byte
	anda	#DCIow^0xFF	; assert WR*
	jsr	IO_WRT
	lda	*idectl		; negate WR*
	jsr	IO_WRT
	dec	*sav1
	bne	wrblk		; until 256 write operations done
	puls	d,x,pc




;  SetLBA - sets the LBA for the next transfer
;
;  call   : [X] - pointer to command packet
;		[1:0] = buffer address (not used, not changed)
;		[2:5] = LBA3:LBA0
;  return : registers of the IDE disk loaded
;  remark : only -ONE- sector is processed
;
; In LBA modus the sectors are simply numbered from 0 to -big-.
; The lowest byte of the LBA sector number is written into the sector number
; register, the middle 16 bits of the LBA sector number are written in the cylinder
; number registers (low and high, all 16 bits are used). The highest 4 bits of the
; LBA sector number are written in the head and device register. That gives you 28
; bits of LBA sector number.
;
	.if	useLBA

SetLBA:	lda	#IDEsec
	bsr	SetAdr
	lda	LBA0,x		; LBA[7:0]
	bsr	wrbyte
	lda	#IDEcylL
	bsr	SetAdr
	lda	LBA1,x
	bsr	wrbyte		; LBA[15:8]
	lda	#IDEcylH
	bsr	SetAdr
	lda	LBA2,x
	bsr	wrbyte		; LBA[23:16]
	lda	#IDEHd
	bsr	SetAdr
	lda	LBA3,x
	anda	#IDEHdA		; isolate low nibble == most significant 4 bits
	ora	#IDEHd0		; format: use LBA, drive #0
	bsr	wrbyte		; LBA[27:24]
	lda	#IDEnum
	bsr	SetAdr
	lda	#1		; set up for ONE sector transfer
	bra	wrbyte		; and RTS

	.else

;    a stack frame is built to make the conversion
;    these are the offsets in the stack frame (after TSX, relative to X)
;    NOTE: this code is used with the physical IDE hard disk drives indicated
;	   at the SPC (#Sectors per Cylinder) and SPT (#Sectors per Track) EQUs
;	   but has not extensively been tested ...!!
;
LBS3	=	0	; stack frame LBAS
LBS2	=	1	;
LBS1	=	2	;
LBS0	=	3	; cylinder high

SetLBA:	pshs	x		; save X, and load input data onto stack
	lda	LBA0,x
	pshs	a		; - 3
	lda	LBA1,x
	pshs	a		; - 2
	lda	LBA2,x
	pshs	a		; - 1
	lda	LBA3,x
	pshs	a		; - 0
	tfr	s,x		; setup [X] as stack frame pointer

    ; init for divide by sectors/cylinder to get the cylinder number.
    ; Result will fit in 16 bits, so 16 bits result is enough.

	ldb	#16		; 16 divide loops
	stb	*sav1
lbac1:	asl	LBS0,x		; shift divident
	rol	LBS1,x
	rol	LBS2,x
	rol	LBS3,x
	ldd	LBS3,x		; get high word
	subd	*seccyl		; test if divisor subtraction fits
	bcs	lbac2		; n - next loop again
	std	LBS3,x		; y - set lower cylinder bit, store result
	inc	LBS0,x
lbac2:	dec	*sav1
	bne	lbac1
				; write result to disk registers
	lda	#IDEcylL
	bsr	SetAdr
	lda	LBS0,x
	bsr	wrbyte		; 8 low bits of Cylinder #
	lda	#IDEcylH
	bsr	SetAdr
	lda	LBS1,x
	bsr	wrbyte		; 2 high bits of Cylinder #
				; see about Head number
	lda	#0		; simple substract will do the work
	sta	LBS0,x		; max #Head times ...
	ldd	LBS3,x		; get remaining blocks count
				; test if one head more
lbac3:	subd	*sectrk		; minus one track's sectors
	bcs	lbac4		; result negative ?
	inc	LBS0,x		; n - one more head
	bra	lbac3
lbac4:	addd	*sectrk		; y - but gone one too far
	addd	#1		; sector count starts at 1 !
	std	LBS3,x		; save Sector#
				; write to disk registers
	lda	#IDEHd		; Head is special
	bsr	SetAdr
	lda	LBS0,x
	anda	#IDEHdA		; isolate the HS3,HS2,HS1,HS0 bits
	ora	#IDEHd0		; format: use C/H/S, drive #0
	bsr	wrbyte		; write Head #
	lda	#IDEsec
	bsr	SetAdr
	lda	LBS2,x		; low byte only as Sector #
	bsr	wrbyte
	lda	#IDEnum		; set address for sector count
	bsr	SetAdr
	lda	#1		; set up for ONE sector transfer
	bsr	wrbyte
	leas	4,s		; clean up the stack - 4 bytes LBA
	puls	x,pc
	.endif







; ########################################################################
; ##									##
; ##	hardware abstraction between IDE interface and I/O Board	##
; ##									##
; ##		= set device register address				##
; ##		= read status / read register / read byte		##
; ##		= test/check READY, BUSY, DATA-REQ status		##
; ##									##
; ########################################################################



;  wrtCmd - write one command to the IDE disk
;
;  call   : [A] - command
;  return : command written in command register of IDE drive
;	    no other registers changed
;	    current I/O (IDE) databus direction = WRITE

wrtCmd:	pshs	a
	lda	#IDECmd
	bsr	SetAdr		; select Command Register
	puls	a
;	bra	wrbyte		; issue command and RTS <fall through >



;  wrbyte - write one byte to the IDE disk
;
;  call   : [A] - byte to write
;	    command to IDE drive has been issued (idectl)
;  return : no other registers changed
;	    current I/O (IDE) databus direction = WRITE

wrbyte:	pshs	d
	jsr	SetOut		; set I/O databus to output
	ldb	#WRide_dl	; set IDE data OUTPUT port #
	jsr	IO_WRT		; write data byte
	ldb	#WRide_c	; set IDE control OUTPUT port #
	lda	*idectl		; get current active IDE control byte
	anda	#DCIow^0xFF	; assert WR*
	jsr	IO_WRT
	lda	*idectl		; negate WR*, latch data into drive's register
	jsr	IO_WRT
	puls	d,pc



;  SetAdr - set an address on the IDE disk
;
;  call   : [A] - device register address [CS1*,CS0*,A2,A1,A0]
;  return : IDE control bit CS1*,CS0*,A2,A1,A0 written
;			bit RST*,RD*,WR* set (inactive state)
;	    (idectl) - current written IDE control byte
;	    no other registers changed
;	    current I/O (IDE) databus direction not changed

SetAdr:	sta	*idectl		; save active IDE control byte
	ldb	#WRide_c	; set IDE control output port #
	jmp	IO_WRT		; write to IDE control and RTS



;  rdDreg - read register (byte) from the IDE disk
;
;  call   : [A] - IDE device register address
;  return : [A] - data read from specified register
;	    no other registers changed
;	    current I/O (IDE) databus direction = READ

rdDreg:	bsr	SetAdr		; setup requested register
	bra	rdbyte		; read byte of register and RTS



;  rdDsts - get status of the IDE disk
;
;  call   : -
;  return : [A] - IDE drive status register info
;	    no other registers changed
;	    current I/O (IDE) databus direction = READ

rdDsts:	lda	#IDESts		; address = status register
	bsr	SetAdr
;	bra	rdbyte		; get the status and RTS <fall through>



;  rdbyte - read one byte from the IDE disk
;
;  call   : command to IDE drive has been issued (idectl)
;  return : [A] = byte read
;	    no other registers changed
;	    current I/O (IDE) databus direction = READ

rdbyte:	pshs	b
	jsr	SetIn		; set I/O databus to input
	ldb	#WRide_c	; set IDE control OUTPUT port #
	lda	*idectl		; get current active IDE control byte
	anda	#DCIor^0xFF	; assert RD*
	jsr	IO_WRT
	ldb	#RDide_dl	;    set IDE data INPUT port #
	jsr	IO_RD		;    get data byte
	pshs	a
	ldb	#WRide_c	; set IDE control OUTPUT port #
	lda	*idectl		; negate RD*, latch drive's data register
	jsr	IO_WRT
	puls	a
	puls	b,pc




;  WtDrdy - wait till the drive indicates ready status
;
;  call   : -
;  return : when RDY bit of IDE drive is set
;	    no registers changed
;	    current I/O (IDE) databus direction = READ

WtDrdy:	pshs	d
10$:	bsr	rdDsts		; get status
	anda	#StsRdy		; ready ?
	beq	10$		; n - BUSY WAIT
	puls	d,pc




;  WtDdrq - wait till the drive indicates "ready for data" status
;
;  call   : -
;  return : when DRQ bit of IDE drive is set
;	    no registers changed
;	    current I/O (IDE) databus direction = READ

WtDdrq:	pshs	d
10$:	bsr	rdDsts		; get status
	anda	#StsDrq		; ready for data ?
	beq	10$		; n - BUSY WAIT
	puls	d,pc




;  WtNbsy - wait till the drive indicates ready status
;
;  call   : -
;  return : when BSY bit of IDE drive is clear
;	    no registers changed
;	    current I/O (IDE) databus direction = READ

WtNbsy:	pshs	d
10$:	bsr	rdDsts		; get status
	anda	#StsBsy		; still busy ?
	bne	10$		; y - BUSY WAIT
	puls	d,pc





;  SetIn - set data I/O port to INPUT (read data) from the IDE disk
;
;  call   : -
;  return : *all* bits of port WRide_x written
;	    no registers changed
;	    (iodatd) reflects current I/O (IDE) databus direction

SetIn:	pshs	d
	lda	#HDdirR		; data direction := INPUT
	bra	setdir



;  SetOut - set data D[7:0] I/O port to OUTPUT (write data) to the IDE disk
;
;  call   : -
;  return : *all* bits of port WRide_x written
;	    no registers changed
;	    (iodatd) reflects current I/O (IDE) databus direction

SetOut:	pshs	d
	lda	#HDdirW		; data direction := OUTPUT
setdir:	cmpa	*iodatd		; current I/O data direction == requested ?
	beq	10$
	ldb	#WRide_x	; n - port with DDIR bit
	sta	*iodatd		;
	bsr	IO_WRT		;     set requested I/O data direction
10$:	puls	d,pc







; ################################################################
; ##								##
; ##		access to physical I/O Board ports		##
; ##								##
; ################################################################


;  IO_WRT - write to physical output port
;
;  call   - [B] = I/O Board number , port number
;           [A] = data byte
;  return - no registers changed
;	    (idedir) reflects current I/O - Core Board communication direction

IO_WRT:	pshs	a		; set data output port == OUTPUT (if needed)
	lda	*idedir		; was direction already "OUTPUT" ?
	bita	#CA2BIT
	beq	iowrt		; y - no action needed
	anda	#0xFF-CA2BIT	; n - switch to "OUTPUT"
	sta	PIACA		; 1. only the 245 buffer (prevent short-circuit)
	sta	*idedir		; set flag: port A set to "OUTPUT"
	anda	#0xFF-DIRBIT	; 2. access data direction reg A
	sta	PIACA
	lda	#0xFF
	sta	PIADA		;    and set port A == output
	lda	*idedir
	sta	PIACA		; 3. access data output reg A
iowrt:	puls	a
	sta	PIADA		; load data
	nop
	orb	#0xFF-IOADDR	; negate DIS3S control bit
;	orb	#RDWR		; direction: WRITE: enable "write" LS138
	stb	PIADB		; setup correct output latch "address"
	andb	#0xFF-DIS3S
	stb	PIADB		; assert DIS3S: enable LS138 decoders
	nop			; hardware settle delay
	orb	#DIS3S
	stb	PIADB		; negate DIS3S: disable LS138 decoders
	andb	#IOADDR		; restore original I/O Board & port number
	rts



;  IO_RD - read from physical input port
;
;  call   - [B] = I/O Board number , port number
;  return - [A] = data byte
;           all other registers not changed
;	    (idedir) reflects current I/O - Core Board communication direction

IO_RD:	lda	*idedir		; was direction already "INPUT" ?
	bita	#CA2BIT
	bne	iord		; y - no action needed
	anda	#0xFF-DIRBIT	; n - switch to "INPUT"
	sta	PIACA		;     1. access data direction reg A
	clra
	sta	PIADA		;        and set port A == input
	lda	*idedir		;     2. now set buffer-74245 to input
	ora	#CA2BIT+DIRBIT	;        (prevent short-circuit moment
	sta	PIACA		;         between buffer-74245 and PIA)
	sta	*idedir		;     3. set flag: port A set to "INPUT"
iord:	orb	#0xFF-IOADDR-RDWR  ; negate DIS3S control
;	andb	#0xFF-RDWR	   ; direction: READ: enable "read" LS138
				   ; read physical port data
	stb	PIADB		   ; > setup correct input latch "address"
	andb	#0xFF-DIS3S
	stb	PIADB		   ; > enable LS138 decoders
	nop			   ; > hardware settle delay
	lda	PIADA		   ; > read switch/toggle selected input port
	orb	#DIS3S
	stb	PIADB		   ; > disable LS138 decoders
	andb	#IOADDR		   ; restore original I/O Board & port number
	rts




    ; identification message strings

IDModel:	.fcb	CR,LF
		.asciz	"Device name : "
IDNoMod:	.asciz	"not specified"

IdAta:		.fcb	CR,LF
		.asciz	"Device type : "
IdmAta:		.asciz	"ATA - "
IdmAtapi:	.asciz	"ATAPI - "
IDFix:		.asciz	"fixed"
IDRem:		.asciz	"removable"
IDtCHS:		.fcb	CR,LF
		.asciz	"Cylinders : "
		.asciz	"   Heads : "
		.asciz	"   Sectors : "
iddump:		.fcb	CR,LF,CR,LF
		.asciz	"----  raw dump of first 64 words of data  ----"


    ; disk error message strings
    ; formatted text: keep in this order!

ErrDsk:	.fcb	CR,LF
	.fcc	">>> Disk Error Occurred <<<"
	.fcb	CR,LF
	.asciz	"   Status :"
	.fcb	CR,LF
	.asciz	"   Error  :"
	.fcb	CR,LF
	.asciz	"   LBA    :"

	.if	useLBA
ErrLBA:	.fcb	CR,LF
	.asciz	"   LBA dsk:"
	.else
ErrCHS:	.fcb	CR,LF
	.asciz	"   CHS dsk:"
	.endif






















; #############################################################################
; ##									     ##
; ##	    FFFFFFF    AAAAAA     TTTTTTTT           1111      666666	     ##
; ##	    FF        AA    AA       TT             11 11     66	     ##
; ##	    FF        AA    AA       TT                11     66	     ##
; ##	    FFFF      AAAAAAAA       TT     XXXXXX     11     6666666	     ##
; ##	    FF        AA    AA       TT                11     66    66	     ##
; ##	    FF        AA    AA       TT                11     66    66	     ##
; ##	    FF        AA    AA       TT              111111    666666	     ##
; ##									     ##
; #############################################################################



BPBdat:	.rmb	16		; BIOS Parameter Block data
secfil:	.rmb	2		; # sectors from boot sector to FAT file directory
secdat:	.rmb	2		; # sectors from boot sector to file data area

filsiz:	.rmb	2		; size of file in # bytes (file < 64k)

CLLSTL	=	128		; # cluster entries !!! limits the file size to 64k bytes
				; 		    !!! (if 1 cluster :: 512 bytes) !!!!!
CLLSIZ	=	2+CLLSTL*2	; cluster list size, +2 bytes for EOC (End Of Cluster) token
clus_l:	.rmb	CLLSIZ




; ======================================================================================
;    read boot sector and display retrieved/stored data
; ======================================================================================

fatsc1:	jsr	opnBPB		; read 1st sector (512 bytes)
	bcc	bootsc		; - OK, "small" FAT16
	ldx	#TOOBIG		; - FAT32 or "too big" FAT16
	jmp	pdatao		;   print message and RTS
;
bootsc:	tfr	u,x		; pointer to BIOS Parameter Block
	ldu	#DSKINF		; pointer to text strings

; bytes/sector  = 0200   sectors/cluster = 01     reserved sectors = 0002
; # FAT tables  = 02     entries in root = 0200   # sectors/FAT    = 00F3
; tot # sectors = F500   # sectors/track = 003F   # sides          = 00FF
; file system   = FAT16  volume   = 12345678901   OEM name = MSDOS5.0
; -----------------------------------------------------------------------

	bsr	pdatu
	bsr	pr4byt		; Bytes per sector
	bsr	pdatu
	bsr	pr2byt		; Sectors per cluster
	bsr	pdatu
	bsr	pr4byt		; reserved sector count
	bsr	pdatu
	bsr	pr2byt		; Number of FAT tables
	bsr	pdatu
	bsr	pr4byt		; # directory entries in root
	bsr	pdatu
	bsr	pr4byt		; # Sectors for one FAT
	bsr	pdatu
	bsr	pr4byt		; total # sectors
	bsr	pdatu
	bsr	pr4byt		; # sectors/track
	bsr	pdatu
	bsr	pr4byt		; # heads (surfaces)
;
	bsr	pdatu
	ldx	#IDEbuf
	leax	54,x		; point to BS_FilSysType (FAT16)
;---	leax	82,x		; point to BS_FilSysType (FAT32)
	ldb	#5		; print just first 5 characters
	bsr	prasci		; print file system "name"
	bsr	pdatu
	ldx	#IDEbuf
	leax	43,x		; point to BS_VolLab (FAT16)
;---	leax	71,x		; point to BS_VolLab (FAT32)
	ldb	#11
	bsr	prasci		; print volume name
	bsr	pdatu
	ldx	#IDEbuf
	leax	3,x		; point to BS_OEMName
	ldb	#8
	bsr	prasci		; print OEM "name"
	bsr	pdatu
	lda	#'-
	ldb	#71
	jmp	OUTABT		; print separator line  & RTS
pr2byt:	jmp	OUT2HS
pr4byt:	jmp	OUT4HS


;  print text string [U]

pdatu:	pshs	x
	tfr	u,x
	jsr	pdatao		; print string
	tfr	x,u
	puls	x,pc


; print [B] characters, pointed by [X] if printable as ASCII, else print a space

prasci:	lda	,x+
	cmpa	#0x20
	bls	10$
	cmpa	#0x7E
	bls	20$
10$:	lda	#Space
20$:	jsr	outch
	decb
	bne	prasci
	rts



; * opnBPB - open BIOS Parameter Block
;
;   call   : -
;   return : BPB copied from CF Card to BPBdat
;	     [X,U,D]  ::  destroyed
;	     cC == 0  --> FAT16 structure and total # sectors less than 65535
;			  secdat = # sectors from boot sector to file data area
;			  secfil = # sectors from boot sector to FAT file directory
;			  [U] - pointer to BPBdat base address
;	     cC == 1  --> FAT16 and total # sectors > 65535
;			  FAT32

opnBPB:	ldx	#CmdPkt		; set pointer to command packet
	ldd	#IDEbuf
	std	,x		; load memory buffer address
	clra
	clrb
	std	2,x		; set first sector: LBA = 0
	std	4,x
	jsr	rdDsec		; read boot sector
	bcc	9$
	jmp	DskErr		; error occurred -> report it and RTS
9$:
;
;   BIOS Parameter Block (on disk)
;   - note 1: indicated values are the values read from a 32 Mb CF Card!
;   - note 2: multi-byte values are in little endian notation !!
;
;  ------------------------------------------------------------------------------------
;  | name           | offset | size | used | description                              |
;  ------------------------------------------------------------------------------------
;  | BS_jmpBoot     |    0   |   3  |  n   | x86 jump instruction to boot code        |
;  | BS_OEMName     |    3   |   8  |  n   | "MSDOS5.0" or MSWIN4.1" or ...           |
;  | BPB_BytsPerSec |   11   |   2  |  y   | bytes per sector                         |
;  | BPB_SecPerClus |   13   |   1  |  y   | # sectors per allocation unit            |
;  | BPB_RsvdSecCnt |   14   |   2  |  y   | reserved sectors (boot sector)           |
;  | BPB_NumFATs    |   16   |   1  |  y   | # FAT data structures on disk            |
;  | BPB_RootEntCnt |   17   |   2  |  y   | FAT12/16: # 32-byte directory entries    |
;  |                |        |      |      |           in root                        |
;  |                |        |      |      | FAT32   : always zero                    |
;  | BPB_TotSec16   |   19   |   2  |  y   | FAT12/16: total count of all sectors on  |
;  |                |        |      |      |           disk or zero if total number   |
;  |                |        |      |      |           > 0x10000, then the total      |
;  |                |        |      |      |           number is in BPB_TotSec32      |
;  |                |        |      |      | FAT32   : always zero (see BPB_TotSec32) |
;  | BPB_Media      |   21   |   1  |  n   | fixed/removable media indicator          |
;  | BPB_FATSz16    |   22   |   2  |  y   | FAT12/16: # sectors for one FAT table    |
;  |                |        |      |      | FAT32   : always zero (see BPB_FATSz32)  |
;  | BPB_SecPerTrk  |   24   |   2  |  n   | # sectors per track for INT13            |
;  | BPB_NumHeads   |   26   |   2  |  n   | # of heads (sides on disk) for INT13     |
;  | BPB_HiddSec    |   28   |   4  |  n   | # of hidden sectors                      |
;  | BPB_TotSec32   |   32   |   4  |  y   | FAT12/16: zero or > 0x10000              |
;  |                |        |      |      |           (see BPB_TotSec16)             |
;  |                |        |      |      | FAT32   : # sectors                      |
;  ------------------------------------------------------------------------------------
;
;
;
;   **** FAT12 and FAT16 starting at offset 36 ****
;
;  ------------------------------------------------------------------------------------
;  | BS_DrvNum      |   36   |   1  |  n   | INT13 drive number                       |
;  | BS_Reserved1   |   37   |   1  |  n   | reserved (used by Windows NT)            |
;  | BS_BootSig     |   38   |   1  |  n   | extended boot signature                  |
;  | BS_VolID       |   39   |   4  |  n   | volume serial number                     |
;  | BS_VolLab      |   43   |  11  |  n   | volume label                             |
;  | BS_FilSysType  |   54   |   8  |  n   | "FAT12   " or "FAT16   "                 |
;  ====================================================================================
;
;
;
;   **** FAT32 starting at offset 36 ****
;
;  ------------------------------------------------------------------------------------
;  | BPB_FATSz32    |   36   |   4  |  n   | # sectors for one FAT table              |
;  |                |        |      |      |   (BPB_FATSz16 must be zero)             |
;  | BPB_ExtFlags   |   40   |   2  |  n   | [3:0] - zero-based # of active FAT (only |
;  |                |        |      |      |         valid if mirroring is disabled.  |
;  |                |        |      |      | [6:4] - reserved                         |
;  |                |        |      |      | [7]   - "0" : mirrored at runtime to all |
;  |                |        |      |      |               FATs                       |
;  |                |        |      |      |         "1" : only one FAT active,       |
;  |                |        |      |      |               referenced by bits [3:0]   |
;  |                |        |      |      | [15:8]  reserved                         |
;  | BPB_FSVer      |   42   |   2  |  n   | revision number                          |
;  | BPB_RootClus   |   44   |   4  |  n   | cluster number of first cluster of the   |
;  |                |        |      |      | root directory                           |
;  | BPB_FSInfo     |   48   |   2  |  n   | sector number of FSINFO in reserved area |
;  | BPB_BkBootSec  |   50   |   2  |  n   | if not zero, the sector number of copy   |
;  |                |        |      |      | of boot record                           |
;  | BPB_Reserved   |   52   |  12  |  n   | reserved                                 |
;  | BS_DrvNum      |   64   |   1  |  n   | INT13 drive number                       |
;  | BS_Reserved1   |   65   |   1  |  n   | reserved (used by Windows NT)            |
;  | BS_BootSig     |   66   |   1  |  n   | extended boot signature                  |
;  | BS_VolID       |   67   |   4  |  n   | volume serial number                     |
;  | BS_VolLab      |   71   |  11  |  n   | volume label                             |
;  | BS_FilSysType  |   82   |   8  |  n   | "FAT32   "                               |
;  ====================================================================================
;
;
;   index in BPBdat table (note: multi-byte values are stored in *big* endian notation !!)

BPBBPS	=	0		; (2) - bytes per sector
BPBSPC	=	2		; (1) - sectors per cluster
BPBRSC	=	3		; (2) - # reserved sectors (boot sector)
BPBFAT	=	5		; (1) - # FAT data structures on disk
BPBREC	=	6		; (2) - # 32-byte directory entries in root
BPBFSZ	=	8		; (2) - # sectors for one FAT table
BPBTSC	=	10		; (2) - total # of sectors on disk
BPBSPT	=	12		; (2) - # sectors/track
BPBSID	=	14		; (2) - # heads (surfaces)
;
;
	ldx	*CmdPkt		; get memory buffer start address
	ldu	#BPBdat		; get the BPB information (in little endian!)
	ldd	11,x		; and store it for later use (in big endian!)
	exg	a,b
	std	BPBBPS,u	; # bytes per sector
	lda	13,x
	sta	BPBSPC,u	; # sectors per cluster
	ldd	14,x
	exg	a,b
	std	BPBRSC,u	; # reserved sectors (boot sector)
	lda	16,x
	sta	BPBFAT,u	; # FAT data structures on disk
	ldd	22,x
	beq	10$		; -> FAT32 structure, not implemented (yet)
	exg	a,b
	std	BPBFSZ,u	; # sectors for one FAT table
	ldd	24,x
	exg	a,b
	std	BPBSPT,u	; # sectors per track for INT13
	ldd	26,x
	exg	a,b
	std	BPBSID,u	; # heads (surfaces)

;   FAT12 / FAT16 specific !!   (not correct for FAT32)

	ldd	17,x
	beq	10$		; -> FAT32 structure, not implemented (yet)
	exg	a,b
	std	BPBREC,u	; # 32-byte directory entries in root
	ldd	19,x
	beq	10$		; -> FAT32 or "too big" FAT16, not implemented (yet)
	exg	a,b
	std	BPBTSC,u	; total # sectors on disk
	ldd	32,x
	bne	10$		; must be zero for FAT16 with less than 65536 sectors
	ldd	34,x
	beq	20$
10$:	orcc	#1		; FAT32 or "too big" FAT16 - cC := 1
	rts
;
;   calculate the sector offset from the boot sector to
;   - the FAT file directory  ==> secfil
;   - the file data area      ==> secdat
;   This calculation is needed only once, after the boot sector is read.
;   First, calculate total number of sectors used by all FATs (BPBFSZ * BPBFAT)
;   As BPBFAT is a small number, the multiplication is done as a repeated addition.
;
20$:	ldx	#0		; clear upper 16 bit of 32-bit result
	lda	BPBFAT,u	; get # FAT tables
	pshs	a		; multiplier = # FAT tables (on stack)
	ldd	BPBFSZ,u	; multiplicant = # sectors for one FAT table
22$:	dec	,s		; adjust multiplier
	beq	24$
	addd	BPBFSZ,u
	bcc	22$
	leax	1,x		; propagate carry to upper 16-bit of result
	bra	22$
24$:	leas	1,s		; clean up stack
;
	addd	BPBRSC,u	; plus # reserved sectors (boot sectors)
	bcc	26$
	leax	1,x		; [X,D] :: total # sectors BPB + FAT_sector area
26$:	cmpx	#0
	bne	10$		; must be zero for FAT16
	std	secfil		; sector offset boot sector to FAT file directory
	ldd	BPBREC,u	; max # file directory entries in FAT table
	lsra			; one entry = 32 bytes
	rorb			; # sectors = max # entries / 16
	lsra			;   16 entries of 32-bytes fit in one sector of 512 bytes
	rorb
	lsra			;   *** it is ASSUMED that a sector is 512 bytes !!
	rorb
	lsra
	rorb
	addd	secfil
	std	secdat		; sector offset boot sector to file data area
	andcc	#0xFE		; all OK - cC := 0
	rts





; ======================================================================================
;    display disk information and file directory
; ======================================================================================

	.if	dbgCode
fsc21:	.asciz	"    start fatsc2 routine"
fsc22:	.asciz	"      sector read, start search [X] = $"
fsc23:	.asciz	"      scanning entry, ptr [X] = $"
fsc24:	.asciz	"      no match, to next entry in this sector"
fsc25:	.asciz	"    leave fatsc2 routine"
	.endif

fatsc2:
	.if	dbgCode
	ldx	#fsc21
	jsr	DbgPrt
	.endif

	jsr	opnBPB		; read BIOS Parameter Block from disk
	ldy	#0
	ldu	secfil		; [Y,U] = sector # of 1st FAT file directory sector
;
;   read FAT file directory sector(s)
;
10$:	ldx	#CmdPkt		; set pointer to command packet
	ldd	#IDEbuf
	std	,x		; load memory buffer address
	sty	2,x		; set FAT file directory LBA
	stu	4,x
	jsr	rdDsec		; read file directory sector
	bcc	11$
	jmp	DskErr		; error occurred -> report it and RTS
11$:
	ldx	#IDEbuf		; holds 32-byte directory entries

	.if	dbgCode
	pshs	x
	ldx	#fsc22
	jsr	DbgPrt
	puls	x
	pshs	x
	stx	*trace
	ldx	#trace
	jsr	OUT4HS
	puls	x
	.endif

	ldb	#16		; max entries = 512 bytes_per_sector / 32 bytes
20$:	pshs	b

	.if	dbgCode
	pshs	x
	ldx	#fsc23
	jsr	DbgPrt
	puls	x
	pshs	x
	stx	*trace
	ldx	#trace
	jsr	OUT4HS
	puls	x
	.endif

	lda	,x		; get first byte of name
	beq	99$		; $00 -> entry free, and all following too: done
	cmpa	#0xE5
	beq	30$		; $E5 -> this entry is free
	bsr	Ffinfo		; print FAT file info (name, attribs, size, date, time)
30$:	ldb	#32
	abx			; to next entry

	.if	dbgCode
	pshs	x
	ldx	#fsc24
	jsr	DbgPrt
	puls	x
	.endif

	puls	b
	decb			; check if still in the read-in buffer data!
	bne	20$
;
;    End not reached, there are possibly more files.
;    Must read next FAT file directory sector first.
;
	tfr	u,d		; retrieve current sector #
	addd	#1		; set next sector #
	tfr	d,u
	bcc	10$
	leay	1,y
	bra	10$
;
99$:
	.if	dbgCode
	pshs	x
	ldx	#fsc25
	jsr	DbgPrt
	puls	x
	.endif

	jsr	docrlf
	puls	b,pc		; clean up stack  & RTS



; * prtBch - print [B] characters
;
;   call   : [B] = # characters to print
;	     [X] = pointer to character string
;   return : [A], [B], [X] destroyed

prtBch:	lda	,x+
	jsr	outch		; print character
	decb			; until all done
	bne	prtBch
	rts




; * Ffinfo - print FAT file information
;
;   call   : [X] = pointer to FAT directory entry base address
;   return : 1. new line
;	     2. name printed in "8.3" notation
;	     3. 3 spaces followed by the file attribute flags
;	     4. 3 spaces followed by the file size
;		if D attribute is set "<dir> " printed
;		if V attribute is set "      " printed
;	     5. 3 spaces followed by the file date
;	     6. 2 spaces followed by the file time
;	     no registers changed

Ffinfo:	pshs	d,u
	pshs	x		; save pointer to FAT dir entry base
	tfr	x,u		; keep copy to check for Volume attribute
	jsr	docrlf		; start with new line
	ldb	#8
	bsr	prtBch		; print name 8 char
	lda	11,u		; get attribute flags
	bita	#0x08		; Volume ID?
	bne	5$		; y - do not print dot separator
	lda	#'.
	jsr	outch		; print dot separator
5$:	ldb	#3
	bsr	prtBch		; print extension 3 char
	puls	x		; restore pointer
	ldb	#3		; print 3 leading spaces
	lda	11,x		; get attribute flags again
	bita	#0x08		; was Volume ID attribute set?
	beq	6$		; n - spacing in print-out OK
	incb			; y - correct for omitted dot separator
6$:	lda	#Space
	jsr	OUTABT
	ldu	#atttbl		; base of attributes letter/bit mask table
10$:	ldb	6,u		; get bit mask
	beq	20$		; 0 - all attribute flags processed
	lda	#'-		; assume attrib flag clear: print a dash
	bitb	11,x		; check attrib flag with attribute byte
	beq	15$		; yep -
	lda	,u		; no, bit set: print attribute letter
15$:	jsr	outch
	leau	1,u
	bra	10$
20$:	lda	#Space
	ldb	#3		; print 3 leading spaces
	jsr	OUTABT
	ldb	11,x		; get attributes byte
	bitb	#0x10		; check Directory attribute flag
	beq	30$
	pshs	x
	ldx	#dirtxt		; D flag set: print "<dir> "
	bra	33$
30$:	bitb	#0x08		; check Volume ID attribute flag
	beq	35$
	pshs	x
	ldx	#voltxt		; V flag set: print "      "
33$:	jsr	pdatao
	puls	x
	bra	40$
35$:	lda	30,x		; get msb word lo-byte
	jsr	OUTB2O
	lda	29,x		; get lsb word hi-byte
	jsr	OUTB2O
	lda	28,x		; get lsb word lo-byte
	jsr	OUTB2O

;    print file date  (stored in word [24:25] - little endian!)
;
;	        word [25]			    word [24]
;
;    --7---6---5---4---3---2---1---0--   --7---6---5---4---3---2---1---0--
;    |___|___|___|___|___|___|___|___|   |___|___|___|___|___|___|___|___|
;
;     +--- year (since 1980) ---+ +----- month -----+ +------ day ------+
;
;    date printed in format dd-MMM-yyyy with leading 3 spaces

40$:	lda	#Space
	ldb	#3
	jsr	OUTABT		; print 3 leading spaces
	ldb	24,x		; get "day" byte
	andb	#0b00011111	; isolate day
	jsr	pr10_1		; print "tens" and "units"
	lda	#'-		; print "-"
	jsr	outch
	lda	25,x		; get month number
	ldb	24,x
	lsra
	rorb
	lsrb
	lsrb
	lsrb
	lsrb
	andb	#0b00001111
	pshs	x
	ldx	#months
	abx
	abx
	abx
	ldb	#3
	jsr	prtBch		; print month mnemonic
	lda	#'-		; print "-"
	jsr	outch
	puls	x
	ldb	25,x		; get year number
	lsrb
	clra
	addd	#1980		; add offset
	cmpd	#1999
	bls	1000$
	subd	#2000
	pshs	d
	lda	#'2
	bra	1001$
1000$:	subd	#1000
	pshs	d
	lda	#'1
1001$:	jsr	outch		; print "thousands"
	ldu	#0x0030		; load ASCII "0"
	puls	d
100$:	subd	#100
	bmi	101$
	leau	1,u
	bra	100$
101$:	addd	#100		; correction
	pshs	b		; save tens and units
	tfr	u,d
	tfr	b,a
	jsr	outch		; print "hundreds"
	puls	b
	bsr	pr10_1		; print "tens" and "units"

;    print file time  (time is stored in word [22:23] - little endian!)
;
;	        word [23]			    word [22]
;
;    --7---6---5---4---3---2---1---0--   --7---6---5---4---3---2---1---0--
;    |___|___|___|___|___|___|___|___|   |___|___|___|___|___|___|___|___|
;
;     +----- hours -----+ +-------- minutes --------+ +-- seconds/2 ----+
;
;    time printed (hh:mm:ss) with leading 2 spaces

	lda	#Space
	ldb	#2
	jsr	OUTABT		; print 2 leading spaces
	ldb	23,x		; get "hours" bits
	lsrb			; isolate hours
	lsrb
	lsrb
	bsr	pr10_1		; print "tens" and "units" of hours
	lda	#':		; print ":"
	jsr	outch
	lda	23,x
	ldb	22,x		; get "minutes" bits
	lsra
	rorb
	lsra
	rorb
	lsra
	rorb
	lsrb
	lsrb
	bsr	pr10_1		; print "tens" and "units" of minutes
	lda	#':		; print ":"
	jsr	outch
	ldb	22,x		; get "seconds" bits
	aslb			; multiply by 2
	andb	#0b00111110
	bsr	pr10_1		; print "tens" and "units" of seconds
	puls	d,u,pc



; * pr10_1 - print tens,units
;
;   call   : [B] = hex value between 0x00 - 0x3F
;   return : value printed (with leading 0 if number < 10)
;	     [A] and [B] destroyed
;
pr10_1:	lda	#'0		; determine "tens"
10$:	subb	#10
	bmi	20$
	inca
	bra	10$
20$:	addb	#'0+10		; correction + ASCII base "0"
	jmp	OUT2CH		; print "tens" and "units" and RTS



atttbl:	.ascii	"RHSVDA"		; Read Hidden System Volume Directory Archive
	.fcb	1,2,4,8,0x10,0x20,0	; mask bit for attribute (0 is end of table)
dirtxt:	.asciz	"<dir> "
voltxt:	.asciz	"      "

months:	.ascii	"xxx"	; 0  ?
	.ascii	"JAN"	; 1
	.ascii	"FEB"	; 2
	.ascii	"MRT"	; 3
	.ascii	"APR"	; 4
	.ascii	"MAY"	; 5
	.ascii	"JUN"	; 6
	.ascii	"JUL"	; 7
	.ascii	"AUG"	; 8
	.ascii	"SEP"	; 9
	.ascii	"OCT"	; 10
	.ascii	"NOV"	; 11
	.ascii	"DEC"	; 12
	.ascii	"xxx"	; 13 ?
	.ascii	"xxx"	; 14 ?
	.ascii	"xxx"	; 15 ?







; ======================================================================================
;    get a file from disk
; ======================================================================================


fatsc3:	jsr	getnam		; ask for a filename
				; [Y] = pointer to 11-character file name
	ldx	#gettxt
	jsr	pdatao		; prompt for 4 digit memory load address for "file"
	jsr	BADDRO
	stx	stradr		; save start address
	stx	tfrptr		; init "DMA transfer" pointer
;
	jsr	fndent		; find the requested entry
	bvc	20$
	jmp	DskErr		; error occurred -> do some reporting and RTS
;
20$:	bcs	30$
	ldx	#notfnd		; file not found: issue message
	jsr	pdatcr
	rts
;
;   * check file attributes and file size.
;     - if attribute Directory or Volume-id, report and done
;     - if file, but file size is 0 bytes, report and done
;     - If (file size/1024) > cluster list space, the list will overflow!
;       Solution: either increase cluster list to max possible FAT_sector size
;		  or report "file too big to read", or do a "2-pass" read op.
;
30$:	ldb	11,x		; get attribute flags
	ldu	#dirent		; assume name is a directory entry
	bitb	#0x10
	bne	63$		; y - report it
	ldu	#volent		; assume name is a volume-ID entry
	bitb	#0x08
	bne	63$		; y - report it
	ldu	#empfil		; assume file is empty (0 bytes)
	ldd	28,x		; get lsb word
	bne	68$		; not 0 ->
	ldd	30,x		; get msb word
	bne	68$		; not 0 ->
63$:	ldx	#rptent		; report entry "file name is "
	jsr	pdatcr
	tfr	u,x
	jmp	pdatao		; and what's it all about  & return
;
;	31,x / 30,x  = upper word (little endian!)
;	29,x / 28,x  = lower word (little endian!)
;
68$:	ldd	30,x		; if upper word != $0000 => file size > 64k
	addd	#0
	beq	69$		; <64k - file clusters will fit in list
	ldx	#clus2s		; >64k - print message cluster list too small
	jmp	pdatao		;	 and RTS
;
69$:	jsr	bldcll		; build logical cluster numbers list
;
;   get file data clusters from disk
;
	ldx	#clus_l		; start of logical cluster numbers list
70$:	ldd	,x++
	cmpd	#0xFFFF		; end of logical cluster numbers list ?
	beq	80$		; y - complete file is retrieved
	jsr	rdclus		; read cluster
;
	pshs	x
	ldx	stradr
	jsr	bufdmp		; for now: show some data
	puls	x
;
	bra	70$
80$:	rts




;  * fndent - find a specified entry (name) in the directory
;
;    call   : [Y] = pointer to name (text)
;    return : ccV = 1 -> error occurred reading directory sector
;			 [X] = pointer to info (for DskErr routine)
;	      ccV = 0 -> ccC = 0 -> entry (name) not found
;			 ccC = 1 -> entry (name) found
;				    [X] = pointer to 32-byte directory entry

	.if	dbgCode
fnd1:	.asciz	"    start fndent routine"
fnd2:	.asciz	"      ptr [Y] to search name: $"
fnd3:	.asciz	"      sector read, start search [X] = $"
fnd4:	.asciz	"      scanning entry, ptr [X] = $"
fnd5:	.asciz	"      no match, to next entry in this sector"
fnd6:	.asciz	"    leave fndent routine"
	.endif

fndent:
	.if	dbgCode
	pshs	x
	ldx	#fnd1
	jsr	DbgPrt
	ldx	#fnd2
	jsr	DbgPrt
	sty	*trace
	ldx	#trace
	jsr	OUT4HS
	puls	x
	.endif

	jsr	opnBPB		; read BIOS Parameter Block from disk
	ldd	BPBREC,u	; save max # of directory entries in root
	pshs	d
	ldx	#0
	ldd	secfil		; sector # of 1st FAT file directory sector
	pshs	x
	pshs	d
;
;   read FAT file directory sector(s)
;
10$:	ldx	#CmdPkt		; set pointer to command packet
	ldd	#IDEbuf
	std	,x		; load memory buffer address
	ldd	2,s
	std	2,x		; set FAT file directory LBA
	ldd	,s
	std	4,x
	jsr	rdDsec		; read file directory sector
	bcc	11$
	leas	6,s		; clean up stack
	orcc	#2		; ccV := 1
	rts
11$:	ldx	#IDEbuf		; holds 32-byte directory entries

	.if	dbgCode
	pshs	x
	ldx	#fnd3
	jsr	DbgPrt
	puls	x
	pshs	x
	stx	*trace
	ldx	#trace
	jsr	OUT4HS
	puls	x
	.endif
;
;   IDEbuf now holds 32-byte directory entries (max 512/32=16 entries)
;   * search buffer for specified file name and extension
;   * if entry not found: read next FAT_directory sector
;   * if all FAT directory sectors are read: display "file not found".
;
	ldb	#16		; # entries in IDEbuf to match
20$:	pshs	b		; save entry count to match

	.if	dbgCode
	pshs	x
	ldx	#fnd4
	jsr	DbgPrt
	puls	x
	pshs	x
	stx	*trace
	ldx	#trace
	jsr	OUT4HS
	puls	x
	.endif

	lda	,x
	beq	50$		; $00 -> entry free, and all following too: done
	cmpa	#0xE5
	beq	40$		; $E5 -> this entry is free
;
30$:	clrb			; match file name, [Y] = ptr to requested file name
31$:	lda	b,x
	cmpa	b,y		; match characters
	bne	40$		; no match, to next entry
	incb			; ok so far
	cmpb	#11		; all characters matched ?
	blo	31$		; n -
	bra	60$		; y - [X] := 32-byte entry (:: search result)
;
;   no match: to next entry
;
40$:
	.if	dbgCode
	pshs	x
	ldx	#fnd5
	jsr	DbgPrt
	puls	x
	.endif

	ldb	#32
	abx			; to next entry
	puls	b
	decb			; still in the read-in buffer data ?
	bne	20$		; y -
	ldd	4,s		; update directory max entry count total
	subd	#16
	bls	51$		; scanned all entries -> file not found
	std	4,s
;
	ldd	,s		; set next sector #
	ldu	2,s
	addd	#1
	std	,s
	lbcc	10$
	leau	1,u
	stu	2,s
	jmp	10$
;
50$:	leas	1,s		; remove entry count from stack
51$:	leas	6,s		; clean up stack
	andcc	#0xFC		; ccV = 0 , ccC = 0 -> not found
	rts
;
60$:	leas	7,s		; clean up stack

	.if	dbgCode
	pshs	x
	ldx	#fnd6
	jsr	DbgPrt
	puls	x
	.endif

	andcc	#0xFD		; ccV = 0
	orcc	#1		; ccC = 1 -> found
	rts







; * bldcll - build logical cluster numbers list
;
;   call   : [X] = pointer to FAT file directory entry base address
;   return : logical clusters list build to retrieve the file from disk
;	     filsiz = total # of bytes in this file
;	     [X], [U], [Y] and [D] destroyed

bldcll:	ldb	28,x		; copy file size (little endian!)
	lda	29,x
	std	filsiz		; and store in big endian format!
	ldd	26,x		; get file data start cluster
	exg	a,b		; little endian !
	pshs	d		; save it
;
	ldu	#BPBdat
	ldd	BPBRSC,u	; # reserved sectors (boot sectors)
	ldy	BPBFSZ,u	; # sectors for one FAT table
	ldu	#clus_l		; start of cluster list
;
;   read cluster chain table sector(s) // one sector at a time
;
10$:	ldx	#CmdPkt		; set pointer to command packet
	std	4,x		; set sector # LBA
	clra
	clrb
	std	2,x
	ldd	#IDEbuf
	std	,x		; load memory buffer address
	jsr	rdDsec		; read FAT cluster chain sector
	bcc	15$
	leas	2,s		; clean up stack
	jmp	DskErr		; error occurred -> report it and RTS
15$:	leay	-1,y		; remaining # sectors to read of FAT
;
	ldx	#IDEbuf		; start of chain sector read from disk
	puls	d		; restore start cluster #
;
20$:	std	,u		; store cluster # in list
	cmpd	#0xFFFF		; EOC (end of cluster chain) ?
	beq	40$		; y -
	addd	,u++		; n - multiply cluster # by 2 (for FAT16)
;
;  ***
;  *** todo: check if [D] < sector size (else we must read next sector first !)
;  ***
;
	ldd	d,x		;     get cluster location for this cluster #
	exg	a,b		;     little endian !
	bra	20$
;
;   file cluster chain complete
;
40$:	ldu	#clus_l
50$:	ldd	,u		; correct list to logical cluster location #
	cmpd	#0xFFFF		; end of list ?
	beq	60$
	subd	#2		; n - apply correction
	std	,u++
	bra	50$
60$:	rts




; * rdclus - read cluster
;
;   call   : [D] = logical sector number (from "clus_l" list)
;	     secdat = sector offset from boot sector to file data area
;	     filsiz = # of bytes remaining to be read for this file
;	     tfrptr = pointer to destination memory
;	     BPBdat information is loaded
;   return : sector(s) of cluster transfered to destination (tfrptr)
;	     tfrptr updated to memory location for next transfer
;	     filsiz updated (decremented with #bytes read, if all read filsiz == 0)

rdclus:	pshs	x
	addd	secdat		; data sector # on disk
	ldx	#CmdPkt		; set pointer to command packet
	std	4,x		; set sector LBA
	clra
	clrb
	std	2,x
	ldd	#IDEbuf
	std	,x		; load memory buffer address
	jsr	rdDsec		; read file data sector
	bcc	10$
	leas	2,s		; clean up stack
	jmp	DskErr		; error occurred -> report it and RTS
10$:	bsr	dmaout		; transfer read data to destination
;
	lda	BPBdat+BPBSPC	; get # sectors per cluster
	pshs	a		; save # sectors to read
20$:	ldd	filsiz
	cmpd	#512
	bhi	25$
	clra			; all data bytes read: filsiz := 0
	clrb
	std	filsiz
	bra	50$		; and all done
25$:	subd	#512
	std	filsiz		; there is more: update #bytes still to read
	dec	,s		; all sectors of one cluster read ?
	beq	50$		; y - all data read (cluster == 1 sector)
	ldu	#CmdPkt		; n- get pointer to command packet
	ldy	2,u		;    get 4-byte LBA number
	ldx	4,u
	leax	1,x		;    increment by 1
	bne	30$
	leay	1,y
30$:	sty	2,u
	stx	4,u
	tfr	u,x
	jsr	rdDsec		;    read next file data sector
	bcc	40$
	leas	3,s		;    error -> clean up stack
	jmp	DskErr		;	   -> report it and RTS
40$:	bsr	dmaout		;    transfer read data to destination
	bra	20$
;
50$:	puls	a		; clean up stack
	puls	x,pc



dmaout:	pshs	u,y		; transfer read data
	ldx	#IDEbuf		; from buffer
	ldu	tfrptr		; to destination
	ldy	#512
10$:	lda	,x+
	sta	,u+
	leay	-1,y
	bne	10$
	stu	tfrptr
	puls	u,y,pc


clus2s:	.fcb	CR,LF
	.asciz	"  ! not enough room in cluster list (file > 64k)"




; * getnam - get file specification
;
;   The filename entry is 1 to 8 characters filename,
;   optionally followed by a dot, and 0 to 3 characters extension
;   A CR character ends the entry.
;   Note: all characters "lower than" $7E and "higher than" $20 are accepted,
;	  several 'special' characters are not allowed in the 8.3 filename,
;	  but are not checked here!
;
;   call   : -
;   return : [Y] = ptr to filename entry 8+3 (without 'dot')
;	     [X], [U], [D] not changed

name:	.rmb	8+1+3		; buffer for file name.ext entry
chrix:	.rmb	1		; index to last entered character

getnam:	pshs	d,x,u
10$:	ldx	#filnam		; sollicit for filename
	jsr	pdatcr
	clrb			; init character counter
	ldy	#name		; and pointer
	lda	#Space
15$:	sta	b,y		; fill field with spaces
	incb
	cmpb	#12
	bne	15$
	clrb
20$:	jsr	inch		; get character
	cmpa	#CtrlC
	beq	10$		; ^C -> typo error, try again
	cmpa	#CR
	beq	35$		; CR -> end of entry
	cmpa	#Space
	bls	20$		; rudimentary check for valid characters
	cmpa	#0x7E
	bhi	20$
	sta	b,y		; accept character, store
	jsr	outch		; and print
	incb
	cmpb	#12		; entry = 8+3 characters and dot
	blo	20$
30$:	jsr	inch		; await end of entry CR
	cmpa	#CtrlC
	beq	10$		; ^C -> typo error, try again
	cmpa	#CR
	bne	30$		; ignore if not CR
;
35$:	stb	chrix		; remember # entered characters
	beq	10$		; no entry, just CR: try again
	clrb
37$:	lda	b,y		; search for the DOT sparator
	cmpa	#'.
	beq	40$		; y - there is an extension
	cmpb	#12		; n - checked complete entry?
	beq	50$
	incb			;     n - continue
	bra	37$
;
;  found DOT extension , [B] = index to DOT position
;
40$:	cmpb	#8		; file name not too long?
	bhi	10$		; y - try again!
	leax	b,y		; n - save possible extension
	leax	1,x
	ldu	,x++
	ldx	,x
	lda	#Space		; fill filename to 8 chars (add spaces)
41$:	cmpb	#8
	beq	42$
	sta	b,y
	incb
	bra	41$
42$:	stu	b,y		; and put in extension
	addb	#2
	stx	b,y
	puls	d,x,u,pc
;
;  no DOT extension , [chrix] = index to last entered char
;
50$:	ldb	chrix		; check length of file name entry
	cmpb	#8
	bhi	10$		; file name > 8 char  --> error, try again!
	puls	d,x,u,pc




rptent:	.asciz	"file is "
dirent:	.asciz	"a directory"
volent:	.asciz	"a volume ID"
empfil:	.asciz	"empty (0 bytes)"

filnam:	.asciz	"  enter 11 character file name (8.3): "
gettxt:	.fcb	CR,LF
	.asciz	"  enter 4 digit memory load address : $"
notfnd:	.asciz	"  ! requested name not found"
notdir:	.asciz	"  ! name is not a directory"





; ======================================================================================
;    change directory
; ======================================================================================

	.if	dbgCode
fsc5_0:	.asciz	"enter fatsc5 routine"
fsc5_1:	.asciz	"    requested name found"
fsc5_x:	.asciz	"leave fatsc5 routine"
	.endif

fatsc5:	.if	dbgCode
	ldx	#fsc5_0
	jsr	DbgPrt
	.endif

	jsr	getnam		; ask for a filename
				; [Y] = pointer to 11-character file name
	jsr	fndent		; find the requested entry
	bvc	20$
	jmp	DskErr		; error occurred -> do some reporting and RTS
;
20$:	bcs	30$
	ldx	#notfnd		; file not found: issue message
	jsr	pdatcr
	rts
;
30$:
	.if	dbgCode
	pshs	x
	ldx	#fsc5_1
	jsr	DbgPrt
	puls	x
	.endif

	ldb	11,x		; get attribute flags: must be Directory
	bitb	#0x10		; is it a "directory" entry ?
	bne	40$		; y -
35$:	ldx	#notdir		; report entry "name is not directory"
	jmp	pdatcr		; and what's it all about  & return
;
40$:	ldd	28,x		; get lsb word of size (must be 0 for "directory")
	bne	35$		; not 0 ->
	ldd	30,x		; get msb word
	bne	35$		; not 0 ->
;
;
	.if	dbgCode
	pshs	x
	ldx	#fsc5_x
	jsr	DbgPrt
	puls	x
	.endif

	rts






; ======================================================================================
;    save a file to disk
; ======================================================================================

stradr:	.rmb	2		; start address in memory (get/save)
endadr:	.rmb	2		; end address in memory (save)
tfrptr:	.rmb	2		; data transfer pointer (updated)


fatsc4:	jsr	getnam		; ask for a filename
				; [Y] = pointer to 11-character file name
	ldx	#savtx1
	jsr	pdatao		; prompt for 4 digit start address of "file"
	jsr	BADDRO
	stx	stradr
	ldx	#savtx2
	jsr	pdatao		; prompt for 4 digit end address of "file"
	jsr	BADDRO
	stx	endadr
	ldx	#savtx3
	jsr	pdatao		; prompt for confirmation
20$:	jsr	inch
	anda	#0x5F		; make entry uppercase
	cmpa	#'N
	bne	25$
	ldx	#SolAbt
	jmp	pdatao		; print "N" , 'command aborted' and return
25$:	cmpa	#'Y
	bne	20$
	jsr	outch		; print "Y"
;
;   open file directory of the disk
;   search for specified filename
;   if filename found in directory -> error, file already exists
;
	jsr	opnBPB		; read BIOS Parameter Block from disk
	ldd	BPBREC,u	; save max # of directory entries in root
	pshs	d
	ldx	#0
	ldd	secdat
	pshs	x
	pshs	d
;
;   read FAT file directory sector(s)
;
30$:	ldx	#CmdPkt		; set pointer to command packet
	ldd	#IDEbuf
	std	,x		; load memory buffer address
	ldd	2,s
	std	2,x		; set FAT file directory LBA
	ldd	,s
	std	4,x
	jsr	rdDsec		; read file directory sector
	bcc	31$
	leas	6,s		; clean up stack
	jmp	DskErr		; error occurred -> do some reporting and RTS
31$:
	ldx	#IDEbuf		; holds 32-byte directory entries
;
;   IDEbuf now holds 32-byte directory entries (max 512/32=16 entries)
;   * search buffer for specified file name and extension
;   * if entry not found: read next FAT_directory sector
;   * if all FAT directory sectors are read: display "file not found".
;
	ldb	#16		; # entries in IDEbuf to match
40$:	pshs	b		; save entry count to match
	lda	,x
	beq	70$		; $00 -> entry free, and all following too: done
	cmpa	#0xE5
	beq	60$		; $E5 -> this entry is free
;
50$:	clrb			; match file name, [Y] = ptr to requested file name
51$:	lda	b,x
	cmpa	b,y		; match characters
	bne	60$		; no match, to next entry
	incb			; ok so far
	cmpb	#11		; all characters matched ?
	blo	51$		; n -
	bra	80$		; y - [X] := 16-bit hex entry (:: search result)
;
;   no match: to next entry
;
60$:	ldb	#32
	abx			; to next entry
	puls	b
	decb			; still in the read-in buffer data ?
	bne	40$		; y -
	ldd	4,s		; update directory max entry count total
	subd	#16
	bls	71$		; scanned all entries -> file not found
	std	4,s
;
	ldd	,s		; set next sector #
	ldu	2,s
	addd	#1
	std	,s
	bcc	30$
	leau	1,u
	stu	2,s
	bra	30$
;
70$:	leas	1,s		; remove entry count from stack
71$:	ldx	#filfnd		; file found: issue message
	jsr	pdatcr
	leas	6,s		; clean up stack and return
	rts
;
;   filename not found:
;   - find first free entry in file directory
;   - generate the directory entry * do not save yet! *
;   - find free entries in cluster list and build cluster list
;   - save the file data, using the cluster list
;   - save the updated cluster list
;   - save the file directory entry
;
80$:	leas	7,s		; clean up stack
;
;
	rts



savtx1:	.fcb	CR,LF
	.asciz	"   > enter 4 hex digit start address : $"
savtx2:	.fcb	CR,LF
	.asciz	"   > enter 4 hex digit end address   : $"
savtx3:	.fcb	CR,LF
	.asciz	"   > EXECUTE SAFE FILE TO DISK [y/n] > "
filfnd:	.asciz	"  ! file already exists"




; * mult16 - 16-bit * 16-bit -> 32-bit (unsigned) result   *** NOT TESTED ***
;
;   call   : [D] = multiplier (16-bit unsigned number)
;	     [X] = multiplicant (16-bit unsigned number)
;   return : [X,D] = 32-bit unsigned result
;	     no other registers changed
;   usage  : 8 bytes on stack
;   remark : number between ( and ) are example data

mult16:	pshs	x,d		; save copy of [X] (2710) and [D] (7530)
	ldd	#0
	pshs	d		; clear 32-bit result on stack
	pshs	d
	lda	6,s
	ldb	4,s
	mul			; (10 * 30) = (0300)
	std	,s
	lda	7,s
	ldb	4,s
	mul			; (27 * 30) = (0750)
	addd	1,s		; add shifted 8 bits
	std	1,s
	lda	#0
	adca	3,s
	sta	3,s
	lda	6,s
	ldb	5,s
	mul			; (75 * 10) = (0750)
	addd	1,s		; add shifted 8 bits
	std	1,s
	lda	#0
	adca	3,s
	sta	3,s
	lda	7,s
	ldb	5,s
	mul			; (75 * 27) = (11D3)
	addd	2,s		; add shifted 16 bit
	std	2,s
	puls	d		; load 32-bit result from stack
	puls	x		; = (11E1A300)
	leas	4,s
	rts




TOOBIG:	.fcb	CR,LF
	.fcc	"*** disk is FAT32 or FAT16 (with > 65535 sectors) : not supported ***"
	.fcb	CR,LF,0
DSKINF:	.fcb	CR,LF
	.asciz	"  bytes/sector  = "
	.asciz	"  sectors/cluster = "
	.asciz	"    reserved sectors = "
	.fcb	CR,LF
	.asciz	"  # FAT tables  = "
	.asciz	"    entries in root = "
	.asciz	"  # sectors/FAT    = "
	.fcb	CR,LF
	.asciz	"  tot # sectors = "
	.asciz	"  # sectors/track = "
	.asciz	"  # sides          = "
	.fcb	CR,LF
	.asciz	"  file system   = "
	.asciz	"  volume   = "
	.asciz	"   OEM name = "
	.fcb	CR,LF
	.asciz	"  "





; ===================================================================================
	.if	TstWire

; This code is added to check the hardware: the wiring from the I/O Board to the
; IDE hard disk 40-pin connector. Each wire is tested. The software mentions the
; signal to be tested, the pin# on the IDE connector and the current state (0/1).
; Pre-requisite: the Core - I/O Board connection (PIA data-path and control-path)
; is initialised.
; REMARK: the messages assume the use if inport/outport as coded in this file!
;
; TEST START CONDITION:
;   IDE disk drive is NOT connected to the 40-pin connector
;
; WORKING METHOD:
;   - first, a message is printed explaining what is going to be tested.
;   - the a line is displayed showing the current state of the wire (0/1)
;     note: depending the signal, 0 can mean active OR not-active!
;   - the following characters are accepted for OUTPUT tests from the keyboard:
;     "1" - change the signal/wire to +5 V. (make logic "1")
;     "0" - change the signal/wire to +0 V. (make logic "0")
;     CR  - skip to next test; signal is left in its current state (0 or 1)
;     ESC - skip (abort) hardware test program
;   - the following characters are accepted for INPUT tests from the keyboard:
;     CR  - skip to next test
;     ESC - skip (abort) hardware test program

ChkHw:	ldx	#tstmsg		; print header test code identification
	jsr	pdatao
	lda	#'-
	ldb	#79
	jsr	OUTABT		; print separator line
	lda	#HDdirR		; data direction := INPUT
	sta	*iodatd		; set I/O data direction = read
	ldb	#WRide_x	; get port with DDIR bit(s)
	jsr	IO_WRT		; and set I/O data direction

	jsr	pdatao		; "hardware wire patch - bit 7"
10$:	lda	*iodatd		; get current I/O data direction
	bita	#HDdirR
	bne	11$
	jsr	logic0		; enabled: print "0"
	bra	12$
11$:	jsr	logic1		; disabled: print "1"
12$:	jsr	testin		; await keyboard entry
	bcs	14$		; - CR/ESC
	cmpa	#'0
	bne	13$
	jsr	SetOut		; - "0" -> I/O direction := write
	bra	10$
13$:	jsr	SetIn		; - "1" -> I/O direction := read
	bra	10$
14$:	lbvs	ChkDon		; -> ESC

   ; next test group: control wires

ctltst:	lda	#DCNop		; set initial control: all signals inactive
	sta	*idectl		; store initial active IDE control byte
	ldb	#WRide_c	; get IDE control output port #
	jsr	IO_WRT		; write control byte to IDE control
	ldy	#ctlwire	; table with control bits [7:0]
10$:	lda	,y+		; get control bit
	beq	datot0		; done -
	jsr	pdatao		; "control wires test"
	jsr	tstcXo
	bvs	ChkDon		; -> ESC
	bra	10$

   ; next test group: data[7:0] wires OUTPUT mode

datot0:	clra			; set initial data out: all zero
	sta	*idedat		; store initial active IDE data byte
	ldb	#WRide_dl	; get IDE data output port #
	jsr	IO_WRT		; write data byte to IDE control
	jsr	SetOut		; set I/O data direction = OUTPUT
	ldy	#datwire	; table with data bits [7:0]
10$:	lda	,y+		; get data bit
	beq	out1in		; done -
	jsr	pdatao		; "data output wires test"
	ldb	#WRide_dl
	jsr	tstdXo
	bvs	ChkDon		; -> ESC
	bra	10$
out1in:

	.if	ifc8bit
	.else

   ; next test group: data[15:8] wires OUTPUT mode

datot8:	clra			; set initial data out: all zero
	sta	*idedat		; store initial active IDE data byte
	ldb	#WRide_du	; get IDE data output port #
	jsr	IO_WRT		; write data byte to IDE control
	jsr	SetOut		; set I/O data direction = OUTPUT
	ldy	#datwire	; table with data bits [15:8]
10$:	lda	,y+		; get data bit
	beq	datit0		; done -
	jsr	pdatao		; "data output wires test"
	ldb	#WRide_du
	bsr	tstdXo
	bvs	ChkDon		; -> ESC
	bra	10$
	.endif

   ; next/last group: data[7:0] wires INPUT mode

datit0:	jsr	SetIn		; set I/O data direction = INPUT
	ldy	#datwire	; table with data bits [7:0]
10$:	lda	,y+		; get data bit
	beq	in1don		; done -
	jsr	pdatao
	ldb	#RDide_dl
	jsr	tstdXi
	bvs	ChkDon		; -> ESC
	bra	10$
in1don:

	.if	ifc8bit
	.else

   ; last group: data[15:8] wires INPUT mode

datit8:	jsr	SetIn		; set I/O data direction = INPUT
	ldy	#datwire	; table with data bits [15:8]
10$:	lda	,y+		; get data bit
	beq	ChkDon		; done -
	jsr	pdatao
	ldb	#RDide_du
	jsr	tstdXi
	bvs	ChkDon		; -> ESC
	bra	10$
	.endif

ChkDon:	ldx	#tstdon
	jsr	pdatao
	swi



;  **-----------------------------------**
;  ** hardware testing support routines **
;  **-----------------------------------**


  ; testin - await keyboard entry and validate
  ;
  ; return : cC = 0		-> [A] and [B] hold ASCII "0" or "1"
  ;	     cC = 1 , cV = 0	-> <CR> entered
  ;	     cC = 1 , cV = 1	-> <ESC> entered

testin:	jsr	inch	; get char, no echo
	cmpa	#'0
	beq	testok
	cmpa	#'1
	bne	test1
testok:	tfr	a,b
	andcc	#0xFE	; cC = 0
	rts
test1:	cmpa	#CR
	bne	test2
	orcc	#0x01	; cC = 1
	andcc	#0xFD	; cV = 0
	rts
test2:	cmpa	#ESC
	bne	testin
	orcc	#0x03	; cC = 1 / cV = 1
	rts



  ; tstcXo - test control bit output
  ;
  ; call   : [A] = active bit position to test
  ;	     (idectl) = current control byte value
  ; return : cC = 1 , cV = 0	-> <CR> entered
  ;	     cC = 1 , cV = 1	-> <ESC> entered

tstcXo:	sta	*dtmsko		; store OR bit mask (set bit)
	coma
	sta	*dtmska		; store AND bit mask (clear bit)
1$:	bsr	testin		; await keyboard entry
	bcc	10$
	rts			; exit, entry was CR/ESC
10$:	lda	*idectl		; get current control byte value
	cmpb	#'0
	bne	11$
	bsr	logic0
	anda	*dtmska		; control bit X := "0"
	bra	111$
11$:	ora	*dtmsko		; control bit X := "1"
	bsr	logic1
111$:	sta	*idectl
	ldb	#WRide_c	; set IDE control output port #
	jsr	IO_WRT		; write control byte to IDE control
	bra	1$



  ; tstdXo - test data bit *output*
  ;
  ; call   : [A] = active bit position to test
  ;	     [B] = outport number used for test
  ;	     (idedat) = current data byte value
  ; return : cC = 1 , cV = 0	-> <CR> entered
  ;	     cC = 1 , cV = 1	-> <ESC> entered

tstdXo:	sta	*dtmsko		; store OR bit mask (set bit)
	coma
	sta	*dtmska		; store AND bit mask (clear bit)
	stb	*ioport		; store outport # used in test
1$:	bsr	testin		; await keyboard entry
	bcc	10$
	rts			; exit, entry was CR/ESC
10$:	lda	*idedat		; get current data byte value
	cmpb	#'0
	bne	11$
	bsr	logic0
	anda	*dtmska		; data bit X := "0"
	bra	111$
11$:	ora	*dtmsko		; data bit X := "1"
	bsr	logic1
111$:	sta	*idedat
	ldb	*ioport		; get IDE data output port #
	jsr	IO_WRT		; write data byte to IDE data
	bra	1$



   ; print logic "0" / "1"

logic0:	pshs	d
	lda	#8	; - backspace
	ldb	#'0	; - ASCII zero
	jsr	OUT2CH
	puls	d,pc
logic1:	pshs	d
	lda	#8	; - backspace
	ldb	#'1	; - ASCII one
	jsr	OUT2CH
	puls	d,pc



  ; tstdXi - test data bit *input*
  ;
  ; call   : [B] = outport number used for test
  ;	     (dtmsko) = active BIT test mask to set the bit position
  ; return : cV = 0  -> <CR> entered
  ;	     cV = 1  -> <ESC> entered

tstdXi:	sta	*dtmsko		; store test bit mask
	stb	*ioport		; store inport # used in test
1$:	ldb	*ioport		; get IDE data input port #
	jsr	IO_RD		; read data byte from IDE data
	bita	*dtmsko		; test data bit X
	bne	11$
	bsr	logic0		; print "0"
	bra	111$
11$:	bsr	logic1		; print "1"
111$:	jsr	INCHNB		; (non-blocking) keyboard entry ?
	bcc	1$		; n -
	cmpa	#CR		; y - check it
	beq	20$
	cmpa	#ESC
	bne	1$
	orcc	#0x02		; ESC - cV=1
	rts
20$:	andcc	#0xFD		; CR  - cV=0
	rts



;  hardware test messages
;  note: keep these texts in this order - software assumes this!

tstmsg:	.fcb	CR,LF
	.fcc	"    ***  IDE - I/O Board wiring CAT  ***"
	.fcb	CR,LF,0,CR,LF
	.fcc	"<T> hardware wire patch for outport 3-state control"
	.fcb	CR,LF
	.if	ifc8bit
	.fcc	"    connect DC voltmeter to IO-DIR[7] (IC7#19 // IC5#1)"
	.else
	.fcc	"    connect DC voltmeter to IO-DIR[7] (IC7#19 // IC5#1 // IC8#1)"
	.endif
	.fcb	CR,LF
	.asciz	"    current state = ."

	.fcb	CR,LF
	.fcc	"<T> IDE control wires test"
	.fcb	CR,LF
	.fcc	"    signal IC6#  IDE#  state"
	.fcb	CR,LF
	.asciz	"    RST*    19     1     ."
	.fcb	CR,LF
	.asciz	"    RD*     16    25     ."
	.fcb	CR,LF
	.asciz	"    WR*     15    23     ."
	.fcb	CR,LF
	.asciz	"    CS1*    12    38     ."
	.fcb	CR,LF
	.asciz	"    CS0*     9    37     ."
	.fcb	CR,LF
	.asciz	"    A2       6    36     ."
	.fcb	CR,LF
	.asciz	"    A1       5    33     ."
	.fcb	CR,LF
	.asciz	"    A0       2    35     ."

	.fcb	CR,LF
	.fcc	"<T> IDE data[7:0] output wires test"
	.fcb	CR,LF
	.fcc	"    signal IC5#  IDE#  state"
	.fcb	CR,LF
	.asciz	"    D[7]    19     3     ."
	.fcb	CR,LF
	.asciz	"    D[6]    16     5     ."
	.fcb	CR,LF
	.asciz	"    D[5]    15     7     ."
	.fcb	CR,LF
	.asciz	"    D[4]    12     9     ."
	.fcb	CR,LF
	.asciz	"    D[3]     9    11     ."
	.fcb	CR,LF
	.asciz	"    D[2]     6    13     ."
	.fcb	CR,LF
	.asciz	"    D[1]     5    15     ."
	.fcb	CR,LF
	.asciz	"    D[0]     2    17     ."

	.if	ifc8bit
	.else
	.fcb	CR,LF
	.fcc	"<T> IDE data[15:8] output wires test"
	.fcb	CR,LF
	.fcc	"    signal IC8#  IDE#  state"
	.fcb	CR,LF
	.asciz	"    D[15]   19    18     ."
	.fcb	CR,LF
	.asciz	"    D[14]   16    16     ."
	.fcb	CR,LF
	.asciz	"    D[13]   15    14     ."
	.fcb	CR,LF
	.asciz	"    D[12]   12    12     ."
	.fcb	CR,LF
	.asciz	"    D[11]    9    10     ."
	.fcb	CR,LF
	.asciz	"    D[10]    6     8     ."
	.fcb	CR,LF
	.asciz	"    D[9]     5     6     ."
	.fcb	CR,LF
	.asciz	"    D[8]     2     4     ."
	.endif

	.fcb	CR,LF
	.fcc	"<T> IDE data[7:0] input wires test (use pulse button)"
	.fcb	CR,LF
	.fcc	"    signal IC15#  IDE#  state"
	.fcb	CR,LF
	.asciz	"    D[7]    18      3     ."
	.fcb	CR,LF
	.asciz	"    D[6]    17      5     ."
	.fcb	CR,LF
	.asciz	"    D[5]    14      7     ."
	.fcb	CR,LF
	.asciz	"    D[4]    13      9     ."
	.fcb	CR,LF
	.asciz	"    D[3]     8     11     ."
	.fcb	CR,LF
	.asciz	"    D[2]     7     13     ."
	.fcb	CR,LF
	.asciz	"    D[1]     4     15     ."
	.fcb	CR,LF
	.asciz	"    D[0]     3     17     ."

	.if	ifc8bit
	.else
	.fcb	CR,LF
	.fcc	"<T> IDE data[15:8] input wires test (use pulse button)"
	.fcb	CR,LF
	.fcc	"    signal IC16#  IDE#  state"
	.fcb	CR,LF
	.asciz	"    D[15]   18     18     ."
	.fcb	CR,LF
	.asciz	"    D[14]   17     16     ."
	.fcb	CR,LF
	.asciz	"    D[13]   14     14     ."
	.fcb	CR,LF
	.asciz	"    D[12]   13     12     ."
	.fcb	CR,LF
	.asciz	"    D[11]    8     10     ."
	.fcb	CR,LF
	.asciz	"    D[10]    7      8     ."
	.fcb	CR,LF
	.asciz	"    D[9]     4      6     ."
	.fcb	CR,LF
	.asciz	"    D[8]     3      4     ."
	.endif

tstdon:	.fcb	CR,LF
	.fcc	"<!> hardware test stopped."
	.fcb	CR,LF,0


ctlwire:	.fcb	DCRes,DCIor,DCIow,DCCs1,DCCs0,DCAd2,DCAd1,DCAd0,0
datwire:	.fcb	0x80,0x40,0x20,0x10,0x08,0x04,0x02,0x01,0

	.endif


    ; CFC test driver ID message

CFCmsg:	.fcb	CR,LF
	.fcc	"** CompactFlash Card low-level I/O and FAT-16 access program v0.2 - 05apr2007"
	.fcb	CR,LF
	.if	ifc8bit
	.fcc	"   - 8 bits data interface enabled"
	.else
	.fcc	"   - 16 bits data interface enabled"
	.endif
	.fcb	CR,LF,0

	.end
