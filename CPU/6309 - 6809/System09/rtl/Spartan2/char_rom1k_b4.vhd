--
-- 1KB Character Generator ROM
-- Using 2 x RAMB4_S8 Block RAMs.
--
library IEEE;
	use IEEE.STD_LOGIC_1164.ALL;
	use IEEE.STD_LOGIC_ARITH.ALL;
	use IEEE.STD_LOGIC_UNSIGNED.ALL;
library unisim;
	use unisim.vcomponents.all;

entity char_rom is
    Port (
       clk   : in  std_logic;
       rst   : in  std_logic;
       cs    : in  std_logic;
       rw    : in  std_logic;
       addr  : in  std_logic_vector (9 downto 0);
       wdata : in  std_logic_vector (7 downto 0);
       rdata : out std_logic_vector (7 downto 0)
    );
end char_rom;

architecture rtl of char_rom is

   signal we       : std_logic;
   signal reset    : std_logic;
   signal rdata0   : std_logic_vector (7 downto 0);
   signal rdata1   : std_logic_vector (7 downto 0);
   signal ena0     : std_logic;
   signal ena1     : std_logic;


begin

  CH_ROM0 : RAMB4_S8
    generic map ( 
INIT_00 => x"000000FF0000001010101010101010003E1C7F7F3E1C08000000FF0000000000",
INIT_01 => x"202020202020200000FF0000000000000000000000FF000000000000FF000000",
INIT_02 => x"0000E0100808080000000304080808080810E000000000040404040404040420",
INIT_03 => x"808080808080FF80402010080402010102040810204080FF8080808080808000",
INIT_04 => x"081C3E7F7F7F3600FF000000000000003C7E7E7E7E3C0001010101010101FF80",
INIT_05 => x"3C424242423C0081422418182442810808040300000000404040404040404000",
INIT_06 => x"0808FF0808080800081C3E7F3E1C0802020202020202020008082A772A1C0800",
INIT_07 => x"03070F1F3F7FFF001414543E010000080808080808080850A050A050A050A008",
INIT_08 => x"24247E247E242400000000002424240008000008080808000000000000000000",
INIT_09 => x"00000000100804003A444A30484830004626100864620000083C0A1C281E0800",
INIT_0A => x"0008083E08080000082A1C3E1C2A080020100808081020000408101010080400",
INIT_0B => x"402010080402000018180000000000000000007E000000100808000000000000",
INIT_0C => x"3C42021C02423C007E40300C02423C003E080808281808003C42625A46423C00",
INIT_0D => x"1010100804427E003C42427C40201C003844020478407E0004047E24140C0400",
INIT_0E => x"080800000800000000080000080000003804023E42423C003C42423C42423C00",
INIT_0F => x"1000100C02423C0070180C060C18700000007E007E0000000E18306030180E10"
    )

    port map ( 
		clk => clk,
		en  => ena0,
		we  => we,
		rst => reset,
		addr(8 downto 0) => addr(8 downto 0),
		di(7 downto 0)   => wdata(7 downto 0),
		do(7 downto 0)   => rdata0(7 downto 0)
	);

  CH_ROM1 : RAMB4_S8
    generic map ( 

INIT_00 => x"001C22404040221C007C22223C22227C004242427E422418001E204C564A221C",
INIT_01 => x"001C22424E40221C004040407840407E007E40407840407E0078242222222478",
INIT_02 => x"0042444870484442003844040404040E001C08080808081C004242427E424242",
INIT_03 => x"0018244242422418004242464A526242004242425A5A6642007E404040404040",
INIT_04 => x"003C42023C40423C004244487C42427C001A244A42422418004040407C42427C",
INIT_05 => x"0042665A5A4242420018182424424242003C424242424242000808080808083E",
INIT_06 => x"003C20202020203C007E40201804027E000808081C2222220042422418244242",
INIT_07 => x"0010207F20100000080808082A1C0800003C04040404043C006E70103C10100C",
INIT_08 => x"003C4240423C0000005C6242625C4040003A443C04380000001E204C564A221C",
INIT_09 => x"3C023A46463A0000001010107C10120C003C407E423C0000003A4642463A0202",
INIT_0A => x"004468504844404038440404040C0004001C08080818000800424242625C4040",
INIT_0B => x"003C4242423C000000424242625C00000049494949760000001C080808080818",
INIT_0C => x"007C023C403E000000404040625C000002023A46463A000040405C62625C0000",
INIT_0D => x"00364949494100000018244242420000003A464242420000000C1210107C1010",
INIT_0E => x"003C20202020203C007E2018047E00003C023A46424200000042241824420000",
INIT_0F => x"0010207F20100000080808082A1C0800003C04040404043C006E70103C10100C"
    )

    port map ( 
		clk => clk,
		en  => ena1,
		we  => we,
		rst => reset,
		addr(8 downto 0) => addr(8 downto 0),
		di(7 downto 0)   => wdata(7 downto 0),
		do(7 downto 0)   => rdata1(7 downto 0)
	);

my_chargen : process ( clk, rst, cs, rw, rdata0, rdata1 )
begin
	case addr(9) is
	when '0' =>
		ena0  <= cs;
		ena1  <= '0';
		rdata <= rdata0;
	when '1' =>
		ena0  <= '0';
		ena1  <= cs;
		rdata <= rdata1;
	when others =>
		null;
	end case;

	we    <= not rw;
	reset <= rst;

end process;

end;
