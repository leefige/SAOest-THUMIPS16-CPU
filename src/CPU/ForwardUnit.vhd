----------------------------------------------------------------------------------
-- Company: SAOest
-- Engineer: 乔逸凡
--
-- Create Date:    22:04:24 11/24/2017
-- Design Name:
-- Module Name:    ForwardUnit - Behavioral
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

entity ForwardUnit is
    Port ( RegSrcA : in STD_LOGIC_VECTOR(3 downto 0);
           RegSrcB : in STD_LOGIC_VECTOR(3 downto 0);
           EXMEMRegDst : in STD_LOGIC_VECTOR(3 downto 0);
           MEMWBRegDst : in STD_LOGIC_VECTOR(3 downto 0);
           SelectA : out STD_LOGIC_VECTOR(1 downto 0);
           SelectB : out STD_LOGIC_VECTOR(1 downto 0));
end ForwardUnit;

architecture Behavioral of ForwardUnit is
begin

    SelectA <= "01" when EXMEMRegDst = RegSrcA else
               "10" when MEMWBRegDst = RegSrcA else
               "00";

    SelectB <= "01" when EXMEMRegDst = RegSrcB else
               "10" when MEMWBRegDst = RegSrcB else
               "00";

end Behavioral;
