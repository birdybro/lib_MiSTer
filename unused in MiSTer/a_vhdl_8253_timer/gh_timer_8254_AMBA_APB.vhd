-----------------------------------------------------------------------------
--	Filename:	gh_timer_8254_AMBA_APB.vhd
--
--	Description:
--		a VHDL version of the 8254 Timer
--
--	Copyright (c) 2008 by H LeFevre 
--		A VHDL 8254 Timer core
--		an OpenCores.org Project
--		free to use, but see documentation for conditions 
--
--	Revision 	History:
--	Revision 	Date       	Author    	Comment
--	-------- 	---------- 	---------	-----------
--	1.0      	08/16/08  	H LeFevre	Initial revision
--
-----------------------------------------------------------------------------
library ieee ;
use ieee.std_logic_1164.all ;

entity gh_timer_8254_AMBA_APB is
	GENERIC(mux0_same_clk: boolean := false; -- true, if same clock is used for bus and counter
	        mux1_same_clk: boolean := false; 
	        mux2_same_clk: boolean := false;
	        mux0_sync_clk: boolean := false; -- true, if bus and counter clocks are synchronous
	        mux1_sync_clk: boolean := false;
	        mux2_sync_clk: boolean := false);
	port(	  
	-------- AMBA_APB signals ------------
		PCLK      : in std_logic;
		PRESETn   : in std_logic;
		PSEL      : in std_logic;
		PENABLE   : in std_logic;
		PWRITE    : in std_logic;
		PADDR     : in std_logic_vector(1 downto 0);
		PWDATA    : in std_logic_vector(7 downto 0);
		
		PREADY    : out std_logic;
		PRDATA    : out std_logic_vector(7 downto 0);
	----------------------------------------------------
	------ other I/O -----------------------------------	
		
		clk0     : in std_logic;
		gate0    : in std_logic;
		out0     : out std_logic;
		
		clk1     : in std_logic;
		gate1    : in std_logic;
		out1     : out std_logic;
		
		clk2     : in std_logic;
		gate2    : in std_logic;
		out2     : out std_logic
		);
end entity;

architecture a of gh_timer_8254_AMBA_APB is

COMPONENT gh_edge_det is
	PORT(	
		clk : in STD_LOGIC;
		rst : in STD_LOGIC;
		D   : in STD_LOGIC;
		re  : out STD_LOGIC; -- rising edge (need sync source at D)
		fe  : out STD_LOGIC; -- falling edge (need sync source at D)
		sre : out STD_LOGIC; -- sync'd rising edge
		sfe : out STD_LOGIC  -- sync'd falling edge
		);
END COMPONENT;

COMPONENT gh_register_ce is
	GENERIC (size: INTEGER := 8);
	PORT(	
		clk : IN		STD_LOGIC;
		rst : IN		STD_LOGIC; 
		CE  : IN		STD_LOGIC; -- clock enable
		D   : IN		STD_LOGIC_VECTOR(size-1 DOWNTO 0);
		Q   : OUT		STD_LOGIC_VECTOR(size-1 DOWNTO 0)
		);
END COMPONENT;

COMPONENT gh_counter_control is
	GENERIC(same_clk: boolean := false;
	        sync_clk: boolean := false);
	port(	  
	-------- data control signals ------------
		clk_i  : in std_logic;
		rst    : in std_logic;
		ics    : in std_logic;
		dwr    : in std_logic;
		iA     : in std_logic_vector(1 downto 0);
		iD     : in std_logic_vector(7 downto 0);
		dat_o  : out std_logic_vector(7 downto 0);
	----------------------------------------------------
	------ other I/O -----------------------------------	
		
		clk     : in std_logic;
		rd_busy : out std_logic;
		gate    : in std_logic;
		Cout    : out std_logic
		);
END COMPONENT;

	signal iRD       : std_logic_vector(7 downto 0);
	signal iD        : std_logic_vector(7 downto 0);
	signal iD0       : std_logic_vector(7 downto 0);
	signal iD1       : std_logic_vector(7 downto 0);
	signal iD2       : std_logic_vector(7 downto 0);
	signal iA        : std_logic_vector(1 downto 0);
	signal iA0       : std_logic_vector(1 downto 0);
	signal iA1       : std_logic_vector(1 downto 0);
	signal iA2       : std_logic_vector(1 downto 0);
	signal CS        : std_logic;
	signal iCS       : std_logic;
	signal iiCS      : std_logic;
	signal iiCS0     : std_logic;
	signal iiCS1     : std_logic;
	signal iiCS2     : std_logic;
	signal dwr       : std_logic;
	
	signal rdCS     : std_logic;
	signal rd_busy  : std_logic;
	signal rd_busy0 : std_logic;
	signal rd_busy1 : std_logic;
	signal rd_busy2 : std_logic;
							 
	signal rDO0      : std_logic_vector(7 downto 0);
	signal rDO1      : std_logic_vector(7 downto 0);
	signal rDO2      : std_logic_vector(7 downto 0);
	
	signal rst       : std_logic;

	
begin
 
	rst <= (not PRESETn);

u1 : gh_register_ce 
	generic map (8)
	port map(
		clk => PCLK,
		rst => rst,
		ce => rdCS,
		D => iRD,
		Q => PRDATA
		);
	
	rdCS <= iCS or rd_busy;
	
 --------------------------------------------------

U2 : gh_edge_det 
	PORT MAP (
		clk => PCLK,
		rst => rst,
		d => CS,
		re => iCS,
		sre => iiCS);
		
	CS <= '1' when ((PSEL = '1') and (PENABLE = '0')) else
	      '0';
		  
process (PCLK,rst)
begin
	if (rst = '1') then
		PREADY <= '0';
		dwr <= '0';
		rd_busy <= '0';
	elsif (rising_edge(PCLK)) then
		dwr <= PWRITE;
		if 	((PWRITE = '0') and (PADDR = "00") and (rd_busy0 = '1')) then
			PREADY <= '0';
			rd_busy <= '1';
		elsif ((PWRITE = '0') and (PADDR = "01") and (rd_busy1 = '1')) then
			PREADY <= '0';
			rd_busy <= '1';
		elsif ((PWRITE = '0') and (PADDR = "10") and (rd_busy2 = '1')) then
			PREADY <= '0';
			rd_busy <= '1';
		else
			PREADY <= '1'; 
			rd_busy <= '0';
		end if;
	end if;
end process;

--------------------------------------------------------------

u3 : gh_register_ce 
	generic map (8)
	port map(
		clk => PCLK,
		rst => rst,
		ce => iCS,
		D => PWDATA,
		Q => iD
		);
		
u4 : gh_register_ce 
	generic map (2)
	port map(
		clk => PCLK,
		rst => rst,
		ce => iCS,
		D => PADDR,
		Q => iA
		);
 
----------------------------------------------------

	iRD <= rDO0 when (PADDR = "00") else
		   rDO1 when (PADDR = "01") else
	       rDO2;

		
--------------------------			  

	iA0 <= iA; -- each counter thinks it is counter 0
	iA1 <= "11" when (iA = "11") else
	       "00" when (iA = "01") else
	       "10";
	iA2 <= "11" when (iA = "11") else
	       "00" when (iA = "10") else
	       "10";

	iD0 <= iD; -- for read back commands
	iD1 <= ("00" & iD(5 downto 0)) when ((iA = "11") and (iD(7 downto 6) = "01")) else
	       ("11" & iD(5 downto 4) & "00" & iD(2) & '0') when ((iA = "11") and (iD(7 downto 6) = "11")) else
	       iD;
	iD2 <= ("00" & iD(5 downto 0)) when ((iA = "11") and (iD(7 downto 6) = "10")) else
	       ("11" & iD(5 downto 4) & "00" & iD(3) & '0') when ((iA = "11") and (iD(7 downto 6) = "11")) else
	       iD;	   

	iiCS0 <= iiCS when ((iA = "11") and (iD(7 downto 6) = "00")) else
	         iiCS when ((iA = "11") and (iD(7 downto 6) = "11")) else
	         iiCS when (iA = "00") else
	         '0';

	iiCS1 <= iiCS when ((iA = "11") and (iD(7 downto 6) = "01")) else
	         iiCS when ((iA = "11") and (iD(7 downto 6) = "11")) else
	         iiCS when (iA = "01") else
	         '0';		   
				 

	iiCS2 <= iiCS when ((iA = "11") and (iD(7 downto 6) = "10")) else
	         iiCS when ((iA = "11") and (iD(7 downto 6) = "11")) else
	         iiCS when (iA = "10") else
	         '0';
				 
U5 : gh_counter_control
	GENERIC MAP(same_clk => mux0_same_clk,
	            sync_clk => mux0_sync_clk)
	PORT MAP (
		clk_i   => PCLK,
		clk     => clk0,
		rst     => rst,
		ics     => iiCS0,
		dwr     => dwr,
		iA      => iA0,
		iD      => iD0,
		dat_o	=> rDO0,
		rd_busy => rd_busy0,
		gate    => gate0,
		Cout    => out0
		);

U6 : gh_counter_control
	GENERIC MAP(same_clk => mux1_same_clk,
	            sync_clk => mux1_sync_clk)
	PORT MAP (
		clk_i   => PCLK,
		clk     => clk1,
		rst     => rst,
		ics     => iiCS1,
		dwr     => dwr,
		iA      => iA1,
		iD      => iD1,
		dat_o	=> rDO1,
		rd_busy => rd_busy1,
		gate    => gate1,
		Cout    => out1
		);
		
U7 : gh_counter_control
	GENERIC MAP(same_clk => mux2_same_clk,
	            sync_clk => mux2_sync_clk)
	PORT MAP (
		clk_i   => PCLK,
		clk     => clk2,
		rst     => rst,
		ics     => iiCS2,
		dwr     => dwr,
		iA      => iA2,
		iD      => iD2,
		dat_o	=> rDO2,
		rd_busy => rd_busy2,
		gate    => gate2,
		Cout    => out2
		);

end a;
