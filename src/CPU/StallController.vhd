----------------------------------------------------------------------------------
-- Company: SAOest
-- Engineer: 乔逸凡
--
-- Create Date:    21:18:42 11/24/2017
-- Design Name:
-- Module Name:    StallController - Behavioral
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

entity StallController is
    Port ( WillHazard : in STD_LOGIC;
           WillBranch : in STD_LOGIC;
           WillVisitInst : in STD_LOGIC;

           WE_PC : out STD_LOGIC;
           WE_IFID : out STD_LOGIC;
           WE_IDEX : out STD_LOGIC;
           WE_EXMEM : out STD_LOGIC;
           WE_MEMWB : out STD_LOGIC;

           Clear_IFID : out STD_LOGIC;
           Clear_IDEX : out STD_LOGIC);
end StallController;

architecture Behavioral of StallController is
begin

    -- if WillHazard = '1' then
    --     WE_PC <= '1'; -- hold
    --     WE_IFID <= '1'; -- hold
    --     WE_IDEX <= '0';
    --     WE_EXMEM <= '0';
    --     WE_MEMWB <= '0';
    --     Clear_IFID <= '0';
    --     Clear_IDEX <= '1'; -- clear
    -- elsif WillBranch = '1' then
    --     Clear_IDEX <= '0'; -- if there's no delay slot, need set clear to 1
    --     WE_PC <= '0';
    --     WE_IFID <= '0';
    --     WE_EXMEM <= '0';
    --     WE_MEMWB <= '0';
    --     Clear_IFID <= '0';
    --     Clear_IDEX <= '0';
    -- else
    --     Clear_IDEX <= '0';
    --     WE_PC <= '0';
    --     WE_IFID <= '0';
    --     WE_EXMEM <= '0';
    --     WE_MEMWB <= '0';
    --     Clear_IFID <= '0';
    --     Clear_IDEX <= '0';
    -- end if; -- There's no chance that WillHazard = 1 and WillBranch = 1 at the same time

    WE_PC <= '1' when WillHazard = '1' else '0';
    WE_IFID <= '1' when WillHazard = '1' else '0';
    Clear_IDEX <= '1' when WillHazard = '1' else '0';
    WE_EXMEM <= '0';
    WE_MEMWB <= '0';
    Clear_IFID <= '0';

end Behavioral;
