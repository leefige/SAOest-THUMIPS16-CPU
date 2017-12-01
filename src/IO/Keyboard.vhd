library ieee;
use ieee.std_logic_1164.all;
USE ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;

entity Keyboard is
port (
	datain, clkin : in std_logic ; -- PS2 clk and data
	fclk, rst : in std_logic ;  -- filter clock
	key : out std_logic_vector(68 downto 0) ;  -- data output enable signal
	rstk : out std_logic;
	scancode : out std_logic_vector(7 downto 0) -- scan code signal output
	) ;
end Keyboard ;

architecture rtl of Keyboard is
type state_type is (delay, start, d0, d1, d2, d3, d4, d5, d6, d7, parity, stop, finish) ;
signal data, clk, clk1, clk2, odd, fok : std_logic ; -- ë�̴����ڲ��ź�, oddΪ��żУ��
signal code : std_logic_vector(7 downto 0) ;
signal state : state_type ;
signal break: std_logic := '1';
begin
	clk1 <= clkin when rising_edge(fclk) ;
	clk2 <= clk1 when rising_edge(fclk) ;
	clk <= (not clk1) and clk2 ;

	data <= datain when rising_edge(fclk) ;

	odd <= code(0) xor code(1) xor code(2) xor code(3)
		xor code(4) xor code(5) xor code(6) xor code(7) ;

	scancode <= code when fok = '1' ;

	process(fok)
	begin
		if (fok'event and fok = '1') then
			case code is
				when x"F0" =>
					break <= '0';
				when x"76" => --esc
					key(0) <= break;
					break <= '1';
				when x"05" => --f1
					key(1) <= break;
					break <= '1';
				when x"06" => --f2
					key(2) <= break;
					break <= '1';
				when x"04" => --f3
					key(3) <= break;
					break <= '1';
				when x"0C" => --f4
					key(4) <= break;
					break <= '1';
				when x"03" => --f5
					key(5) <= break;
					break <= '1';
				when x"0B" => --f6
					key(6) <= break;
					break <= '1';
				when x"83" => --f7
					key(7) <= break;
					break <= '1';
				when x"0A" => --f8
					key(8) <= break;
					break <= '1';
				when x"01" => --f9
					key(9) <= break;
					break <= '1';
				when x"09" => --f10
					key(10) <= break;
					break <= '1';
				when x"78" => --f11
					key(11) <= break;
					break <= '1';
				when x"07" => --f12
					key(12) <= break;
					break <= '1';
				when x"0E" => --~
					key(13) <= break;
					break <= '1';
				when x"16" => --1
					key(14) <= break;
					break <= '1';
				when x"1E" => --2
					key(15) <= break;
					break <= '1';
				when x"26" => --3
					key(16) <= break;
					break <= '1';
				when x"25" => --4
					key(17) <= break;
					break <= '1';
				when x"2E" => --5
					key(18) <= break;
					break <= '1';
				when x"36" => --6
					key(19) <= break;
					break <= '1';
				when x"3D" => --7
					key(20) <= break;
					break <= '1';
				when x"3E" => --8
					key(21) <= break;
					break <= '1';
				when x"46" => --9
					key(22) <= break;
					break <= '1';
				when x"45" => --0
					key(23) <= break;
					break <= '1';
				when x"4E" => ---
					key(24) <= break;
					break <= '1';
				when x"55" => --+
					key(25) <= break;
					break <= '1';
				when x"5D" => --\
					key(26) <= break;
					break <= '1';
				when x"66" => --backspace
					key(27) <= break;
					break <= '1';
				when x"0D" => --tab
					key(28) <= break;
					break <= '1';
				when x"15" => --q
					key(29) <= break;
					break <= '1';
				when x"1D" => --W
					key(30) <= break;
					break <= '1';
				when x"24" => --e
					key(31) <= break;
					break <= '1';
				when x"2D" => --r
					key(32) <= break;
					break <= '1';
				when x"2C" => --t
					key(33) <= break;
					break <= '1';
				when x"35" => --y
					key(34) <= break;
					break <= '1';
				when x"3C" => --u
					key(35) <= break;
					break <= '1';
				when x"43" => --i
					key(36) <= break;
					break <= '1';
				when x"44" => --o
					key(37) <= break;
					break <= '1';
				when x"4D" => --p
					key(38) <= break;
					break <= '1';
				when x"54" => --[
					key(39) <= break;
					break <= '1';
				when x"5B" => --]
					key(40) <= break;
					break <= '1';
				when x"58" => --caps
					key(41) <= break;
					break <= '1';
				when x"1C" => --a
					key(42) <= break;
					break <= '1';
				when x"1B" => --s
					key(43) <= break;
					break <= '1';
				when x"23" => --d
					key(44) <= break;
					break <= '1';
				when x"2B" => --f
					key(45) <= break;
					break <= '1';
				when x"34" => --g
					key(46) <= break;
					break <= '1';
				when x"33" => --h
					key(47) <= break;
					break <= '1';
				when x"3B" => --j
					key(48) <= break;
					break <= '1';
				when x"42" => --k
					key(49) <= break;
					break <= '1';
				when x"4B" => --l
					key(50) <= break;
					break <= '1';
				when x"4C" => --;
					key(51) <= break;
					break <= '1';
				when x"52" => --'
					key(52) <= break;
					break <= '1';
				when x"5A" => --enter
					key(53) <= break;
					break <= '1';
				when x"12" => --shift
					key(54) <= break;
					break <= '1';
				when x"1A" => --z
					key(55) <= break;
					break <= '1';
				when x"22" => --x
					key(56) <= break;
					break <= '1';
				when x"21" => --c
					key(57) <= break;
					break <= '1';
				when x"2A" => --v
					key(58) <= break;
					break <= '1';
				when x"32" => --b
					key(59) <= break;
					break <= '1';
				when x"31" => --n
					key(60) <= break;
					break <= '1';
				when x"3A" => --m
					key(61) <= break;
					break <= '1';
				when x"41" => --,
					key(62) <= break;
					break <= '1';
				when x"49" => --.
					key(63) <= break;
					break <= '1';
				when x"4A" => --/
					key(64) <= break;
					break <= '1';
				when x"59" => --rightshift
					key(65) <= break;
					break <= '1';
				when x"14" => --ctrl
					key(66) <= break;
					break <= '1';
				when x"11" => --alt
					key(67) <= break;
					break <= '1';
				when x"29" => --space
					key(68) <= break;
					break <= '1';
				when others => break <= '1';
			end case;
		end if;
	end process;

	process(rst, fclk)
	begin
		if rst = '1' then
			state <= delay ;
			code <= (others => '0') ;
			fok <= '0' ;
		elsif rising_edge(fclk) then
			fok <= '0' ;
			case state is
				when delay =>
					state <= start ;
				when start =>
					if clk = '1' then
						if data = '0' then
							state <= d0 ;
						else
							state <= delay ;
						end if ;
					end if ;
				when d0 =>
					if clk = '1' then
						code(0) <= data ;
						state <= d1 ;
					end if ;
				when d1 =>
					if clk = '1' then
						code(1) <= data ;
						state <= d2 ;
					end if ;
				when d2 =>
					if clk = '1' then
						code(2) <= data ;
						state <= d3 ;
					end if ;
				when d3 =>
					if clk = '1' then
						code(3) <= data ;
						state <= d4 ;
					end if ;
				when d4 =>
					if clk = '1' then
						code(4) <= data ;
						state <= d5 ;
					end if ;
				when d5 =>
					if clk = '1' then
						code(5) <= data ;
						state <= d6 ;
					end if ;
				when d6 =>
					if clk = '1' then
						code(6) <= data ;
						state <= d7 ;
					end if ;
				when d7 =>
					if clk = '1' then
						code(7) <= data ;
						state <= parity ;
					end if ;
				WHEN parity =>
					IF clk = '1' then
						if (data xor odd) = '1' then
							state <= stop ;
						else
							state <= delay ;
						end if;
					END IF;

				WHEN stop =>
					IF clk = '1' then
						if data = '1' then
							state <= finish;
						else
							state <= delay;
						end if;
					END IF;

				WHEN finish =>
					state <= delay ;
					fok <= '1' ;
				when others =>
					state <= delay ;
			end case ;
		end if ;
	end process ;
end rtl ;
