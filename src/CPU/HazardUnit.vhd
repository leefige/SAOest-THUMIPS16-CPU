----------------------------------------------------------------------------------
-- Company: SAOest
-- Engineer: 乔逸凡
--
-- Create Date:    20:57:19 11/24/2017
-- Design Name:
-- Module Name:    HazardUnit - Behavioral
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

entity HazardUnit is
    Port ( LastMemRd : in STD_LOGIC;
           LastRegDst : in STD_LOGIC_VECTOR(3 downto 0);
           RegSrcA : in STD_LOGIC_VECTOR(3 downto 0);
           RegSrcB : in STD_LOGIC_VECTOR(3 downto 0);
           WillHazard : out STD_LOGIC);
end HazardUnit;

architecture Behavioral of HazardUnit is
    begin

        if LastMemRd = '1' and (LastRegDst = RegSrcA or LastRegDst = RegSrcB) then
            WillHazard <= '1';
        else
            WillHazard <= '0';
        end if;

    end Behavioral;
