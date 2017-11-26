----------------------------------------------------------------------------------
-- Company: SAOest
-- Engineer: 乔逸凡
--
-- Create Date:    20:14:11 11/24/2017
-- Design Name:
-- Module Name:    BranchController - Behavioral
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

entity BranchController is
    Port ( JumpType : in STD_LOGIC_VECTOR(2 downto 0);
           RegData : in STD_LOGIC_VECTOR(15 downto 0);
           WillBranch : out STD_LOGIC;
           PCSelect : out STD_LOGIC_VECTOR(1 downto 0));
end BranchController;

architecture Behavioral of BranchController is
begin
    -- if JumpType = "000" then -- B
    --     WillBranch <= '1';
    --     PCSelect <= "10"; -- PCOffset

    -- elsif (JumpType = "001" or JumpType = "011") and RegData = (others => '0') then -- BEQZ & BTEQZ
    --     WillBranch <= '1';
    --     PCSelect <= "10"; -- PCOffset

    -- elsif JumpType = "010" and RegData != (others => '0') then -- BNEZ
    --     WillBranch <= '1';
    --     PCSelect <= "10"; -- PCOffset

    -- elsif JumpType = "100" then -- JR
    --     WillBranch <= '1';
    --     PCSelect <= "00"; -- FromReg

    -- elsif JumpType = "101" then -- JALR
    --     WillBranch <= '1';
    --     PCSelect <= "00"; -- FromReg

    -- elsif JumpType = "110" then -- JRRA
    --     WillBranch <= '1';
    --     PCSelect <= "00"; -- FromReg

    -- else
    --     WillBranch <= '0';
    --     PCSelect <= "01"; -- NPC

    -- end if;

    WillBranch <= '1' when JumpType = "000" or ((JumpType = "001" or JumpType = "011") and RegData = (others => '0'))
                            or (JumpType = "010" and RegData /= (others => '0'))
                            or JumpType = "100" or JumpType = "101" or JumpType = "110"
                      else '0';
    PCSelect <= "10" when JumpType = "000" or ((JumpType = "001" or JumpType = "011") and RegData = (others => '0'))
                            or (JumpType = "010" and RegData /= (others => '0'))
                      else "00" when JumpType = "100" or JumpType = "101" or JumpType = "110"
                      else "01";

end Behavioral;
