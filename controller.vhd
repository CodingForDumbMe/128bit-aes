library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity controller is
	port (key: in std_logic_vector(127 downto 0); inp: in std_logic_vector(127 downto 0); outp:out std_logic_vector (127 downto 0));
end controller;

architecture behav of controller is
	component keyexp is
		port (key: in std_logic_vector(127 downto 0); outp:out std_logic_vector (1407 downto 0));
	end component keyexp;

	function subbytes(inp : std_logic_vector(127 downto 0))
              return std_logic_vector is
				type Byte_Array is array (255 downto 0) of std_logic_vector(7 downto 0);
				variable outp : std_logic_vector(127 downto 0);
				constant lookup : Byte_Array := ("01100011",	"01111100",	"01110111",	"01111011",	"11110010",	"01101011",	"01101111",	"11000101",	"00110000",	"00000001",	"01100111",	"00101011",	"11111110",	"11010111",	"10101011",	"01110110",
											 "11001010",	"10000010",	"11001001",	"01111101",	"11111010",	"01011001",	"01000111",	"11110000",	"10101101",	"11010100",	"10100010",	"10101111",	"10011100",	"10100100",	"01110010",	"11000000",
											 "10110111",	"11111101",	"10010011",	"00100110",	"00110110",	"00111111",	"11110111",	"11001100",	"00110100",	"10100101",	"11100101",	"11110001",	"01110001",	"11011000",	"00110001",	"00010101",
											 "00000100",	"11000111",	"00100011",	"11000011",	"00011000",	"10010110",	"00000101",	"10011010",	"00000111",	"00010010",	"10000000",	"11100010",	"11101011",	"00100111",	"10110010",	"01110101",
										  	 "00001001",	"10000011",	"00101100",	"00011010",	"00011011",	"01101110",	"01011010",	"10100000",	"01010010",	"00111011",	"11010110",	"10110011",	"00101001",	"11100011",	"00101111",	"10000100",
											 "01010011",	"11010001",	"00000000",	"11101101",	"00100000",	"11111100",	"10110001",	"01011011",	"01101010",	"11001011",	"10111110",	"00111001",	"01001010",	"01001100",	"01011000",	"11001111",
											 "11010000",	"11101111",	"10101010",	"11111011",	"01000011",	"01001101",	"00110011",	"10000101",	"01000101",	"11111001",	"00000010",	"01111111",	"01010000",	"00111100",	"10011111",	"10101000",
											 "01010001",	"10100011",	"01000000",	"10001111",	"10010010",	"10011101",	"00111000",	"11110101",	"10111100",	"10110110",	"11011010",	"00100001",	"00010000",	"11111111",	"11110011",	"11010010",
											 "11001101",	"00001100",	"00010011",	"11101100",	"01011111",	"10010111",	"01000100",	"00010111",	"11000100",	"10100111",	"01111110",	"00111101",	"01100100",	"01011101",	"00011001",	"01110011",
											 "01100000",	"10000001",	"01001111",	"11011100",	"00100010",	"00101010",	"10010000",	"10001000",	"01000110",	"11101110",	"10111000",	"00010100",	"11011110",	"01011110",	"00001011",	"11011011",
											 "11100000",	"00110010",	"00111010",	"00001010",	"01001001",	"00000110",	"00100100",	"01011100",	"11000010",	"11010011",	"10101100",	"01100010",	"10010001",	"10010101",	"11100100",	"01111001",
											 "11100111",	"11001000",	"00110111",	"01101101",	"10001101",	"11010101",	"01001110",	"10101001",	"01101100",	"01010110",	"11110100",	"11101010",	"01100101",	"01111010",	"10101110",	"00001000",
											 "10111010",	"01111000",	"00100101",	"00101110",	"00011100",	"10100110",	"10110100",	"11000110",	"11101000",	"11011101",	"01110100",	"00011111",	"01001011",	"10111101",	"10001011",	"10001010",
											 "01110000",	"00111110",	"10110101",	"01100110",	"01001000",	"00000011",	"11110110",	"00001110",	"01100001",	"00110101",	"01010111",	"10111001",	"10000110",	"11000001",	"00011101",	"10011110",
											 "11100001",	"11111000",	"10011000",	"00010001",	"01101001",	"11011001",	"10001110",	"10010100",	"10011011",	"00011110",	"10000111",	"11101001",	"11001110",	"01010101",	"00101000",	"11011111",
											 "10001100",	"10100001",	"10001001",	"00001101",	"10111111",	"11100110",	"01000010",	"01101000",	"01000001",	"10011001",	"00101101",	"00001111",	"10110000",	"01010100",	"10111011",	"00010110"); 
	begin
		for i in 0 to 15 loop
			outp(8*i + 7 downto 8*i) := lookup(to_integer(unsigned(inp(8*i + 7 downto 8*i) xor "11111111")));
		end loop;
		return outp;
	end subbytes;
	
	function twox(inbyte : std_logic_vector(7 downto 0))
		return std_logic_vector is
		variable outp, temp, mod_vec : std_logic_vector (7 downto 0);
	begin
		temp := "00011011";
		for i in 0 to 7 loop
			mod_vec(i) := temp(i) and inbyte(7);
		end loop;
		for i in 0 to 7 loop 
			if i = 0 then
				outp(i) := '0' xor mod_vec(i);
			else
				outp(i) :=inbyte(i-1) xor mod_vec(i);
			end if;
		end loop;
		return outp;
	end twox;
	
	function mixcolumns(inp : std_logic_vector(31 downto 0))
		return std_logic_vector is
		variable outp : std_logic_vector(31 downto 0);
		variable outs, mult, mult3: std_logic_vector (31 downto 0);

	begin
			mult3 := mult xor inp;
		for i in 0 to 3 loop
			mult(8*i + 7 downto 8*i) := twox(inp(8*i + 7 downto 8*i));
		end loop;
		outp(7 downto 0)   := mult(7 downto 0) xor mult3(15 downto 8) xor inp(23 downto 16) xor inp(31 downto 24);
		outp(15 downto 8)  := mult(15 downto 8) xor mult3(23 downto 16) xor inp(31 downto 24) xor inp(7 downto 0);
		outp(23 downto 16) := mult(23 downto 16) xor mult3(31 downto 24) xor inp(7 downto 0) xor inp(15 downto 8);
		outp(31 downto 24) := mult(31 downto 24) xor mult3(7 downto 0) xor inp(15 downto 8) xor inp(23 downto 16);
		return outp;
	end mixcolumns;
	
	
	function addroundkey(inp : std_logic_vector(127 downto 0); w : std_logic_vector(127 downto 0))
		return std_logic_vector is
		variable outp : std_logic_vector(127 downto 0);
	begin
		outp := inp xor w;
		return outp;
	end addroundkey;

	
	function shiftrows(inp : std_logic_vector(127 downto 0))
		return std_logic_vector is
		variable outp : std_logic_vector(127 downto 0);
		variable loc: INTEGER := 0;
		variable column: INTEGER := 0;
	begin
			for i in 0 to 15 loop 
				if (i < 4) then
					column:= 0;
				elsif (i < 8) then
					column:= 1;
				elsif (i < 12) then
					column:= 2;
				else 
					column:= 3;
				end if;
				loc := ((i rem 4)*5 + 4*column)rem 16;
				outp(8*i+7 downto 8*i) := inp(8*loc + 7 downto 8*loc);
			end loop;
		return outp;
	end shiftrows;
	type thing is array (0 to 40) of std_logic_vector(127 downto 0);
	signal state : thing;
	signal w : std_logic_vector(1407 downto 0);
begin
	expand_key: keyexp port map (key, w);
	ctrl: process(inp, w)
	begin
		state(0) <= inp;
		state(1) <= addroundkey(state(0), w(127 downto 0));
		for round in 1 to 9 loop
			state(4*(round-1)+2) <= subbytes(state(4*(round-1)+1)); 
			state(4*(round-1)+3) <= shiftrows(state(4*(round-1)+2));
			for l in 0 to 3 loop
				state(4*(round-1)+4)(32*(l+1)-1 downto 32*l) <= mixcolumns(state(4*(round-1)+3)(32*(l+1)-1 downto 32*l));
			end loop;
			state(4*(round-1)+5) <= addroundkey(state(4*(round-1)+4), w((round+1)*4*32-1 downto round*4*32));
		end loop;
		state(38) <= SubBytes(state(1));
		state(39) <= ShiftRows(state(38));
		state(40) <= AddRoundKey(state(39), w(44*32-1 downto 40*32));
		outp <= state(40);
	end process;
end behav;
 
