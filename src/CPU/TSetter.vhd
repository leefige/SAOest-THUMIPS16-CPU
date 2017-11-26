----------------------------------------------------------------------------------
-- Company: SAOest
-- Engineer: 乔逸凡
--
-- Create Date:    19:59:56 11/24/2017
-- Design Name:
-- Module Name:    TSetter - Behavioral
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

entity TSetter is
    Port ( TRegType : in STD_LOGIC; -- 0 for cmp; 1 for slt
           Flag : in STD_LOGIC_VECTOR(1 downto 0); -- 0 for Z; 1 for S
           TOut : out STD_LOGIC_VECTOR(15 downto 0));
end TSetter;

architecture Behavioral of TSetter is
begin

    TOut <= (others => '0') when (TRegType = '0' and Flag(0) = '1') or (TRegType = '1' and Flag(1) = '0')
        else (others => '1');

end Behavioral;
