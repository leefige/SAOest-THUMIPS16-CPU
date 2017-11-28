----------------------------------------------------------------------------------
-- Company:
-- Engineer:
--
-- Create Date:    16:23:13 10/20/2017
-- Design Name:
-- Module Name:    digit7 - Behavioral
-- Project Name:
-- Target Devices:
-- Tool versions:
-- Description:
--
-- Dependencies:
--
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Digit7 is
    Port ( num : in  STD_LOGIC_VECTOR (3 downto 0);
           seg : out  STD_LOGIC_VECTOR (6 downto 0));
end Digit7;

architecture Behavioral of Digit7 is

begin

	process(num)	begin
		case num is
			when "0000" => seg <= "0111111";
			when "0001" => seg <= "0000110";
			when "0010" => seg <= "1011011";
			when "0011" => seg <= "1001111";
			when "0100" => seg <= "1100110";
			when "0101" => seg <= "1101101";
			when "0110" => seg <= "1111101";
			when "0111" => seg <= "0000111";
			when "1000" => seg <= "1111111";
			when "1001" => seg <= "1101111";
			when "1010" => seg <= "1110111";
			when "1011" => seg <= "0011111";
			when "1100" => seg <= "1001110";
			when "1101" => seg <= "0111101";
			when "1110" => seg <= "1001111";
			when "1111" => seg <= "1000111";
			when others => seg <= "1111111";
		end case;
	end process;

end Behavioral;

