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

signal IsCOM : STD_LOGIC;
signal IsPS2 : STD_LOGIC;
signal IsInstMem : STD_LOGIC;
signal IsGraphicMem : STD_LOGIC;
signal IsDataMem : STD_LOGIC;
signal Slct : STD_LOGIC_VECTOR (4 downto 0); -- select
signal WillIO : STD_LOGIC;

begin

    IsCOM <= '1' when (AddrIn = x"BF00") else '0';    --  0XBF00
    IsPS2 <= '1' when (AddrIn = x"BF02") else '0';    --  0XBF02
    IsInstMem <= '1' when ((AddrIn >= x"4000") and (AddrIn < x"8000")) else '0';    -- [0X4000, 0X7FFF]
    IsGraphicMem <= '1' when ((AddrIn >= x"ED40") and (AddrIn < x"10000")) else '0';    -- [0XED40, 0XFFFF]
    IsDataMem <= '1' when (((AddrIn >= x"8000") and (AddrIn < x"BF00")) or ((AddrIn >= x"BF10") and (AddrIn < x"ED40"))) else '0';

    WillIO <= MemRd or MemWr;

    WillVisitInst <= IsInstMem and WillIO;

    Slct <= IsDataMem & IsGraphicMem & IsInstMem & IsCOM & IsPS2;  -- mem will be at most one of them, 0000 | 0001 | 0010 | 0100 | 1000

    process (Slct, WillIO)
    begin
        if (WillIO = '1') then
            case Slct is
                when "00100" =>      -- inst mem, special case
                    IOType <= "001";
                when "00010" =>      -- com
                    IOType <= "010";
                when "00001" =>      -- ps2
                    IOType <= "011";
                when "01000" =>      -- graphic mem
                    IOType <= "100";
                when "10000" =>      -- data mem
                    IOType <= "101";
                when others =>      -- don't need to disable sram1
                    IOType <= "111";
            end case;
        else
            IOType <= "111";        -- won't IO
        end if;
    end process;

end Behavioral;

