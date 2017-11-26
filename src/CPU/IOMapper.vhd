----------------------------------------------------------------------------------
-- Company:
-- Engineer: Li Yifei
--
-- Create Date:    20:28:26 11/26/2017
-- Design Name:
-- Module Name:    IOMapper - Behavioral
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

entity IOMapper is
    Port ( MemWr : in  STD_LOGIC;
           MemRd : in  STD_LOGIC;
           AddrIn : in  STD_LOGIC_VECTOR (15 downto 0);
           WillWrInst : out  STD_LOGIC;
           IOType : out  STD_LOGIC_VECTOR (2 downto 0));
end IOMapper;

architecture Behavioral of IOMapper is

begin




end Behavioral;

