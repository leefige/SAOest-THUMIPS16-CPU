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
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

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
           WillVisitInst : out  STD_LOGIC;
           IOType : out  STD_LOGIC_VECTOR (2 downto 0));
end IOMapper;

architecture Behavioral of IOMapper is

signal s_IOType : STD_LOGIC_VECTOR (2 downto 0);
signal IsCOM : STD_LOGIC;
signal IsPS2 : STD_LOGIC;
signal IsInstMem : STD_LOGIC;
signal Slct : STD_LOGIC_VECTOR (2 downto 0); -- select

begin

    IsCOM <= '1' when ((AddrIn = x"BF00") or (AddrIn = x"BF01")) else '0';
    IsPS2 <= '1' when ((AddrIn = x"BF02") or (AddrIn = x"BF03")) else '0';
    IsInstMem <= '1' when ((AddrIn >= x"4000") and (AddrIn < x"8000")) else '0';

    WillVisitInst <= IsInstMem;

    Slct <= IsInstMem & IsCOM & IsPS2;  -- mem will be at most one of them, 000 | 001 | 010 | 100

    with Slct select
        s_IOType <= "001" when "100",  -- inst mem, special case
                    "010" when "010",  -- com
                    "011" when "001",  -- ps2
                    "000" when others;   -- don't need to disable sram1

end Behavioral;

