----------------------------------------------------------------------------------
-- Company:
-- Engineer: Li Yifei
--
-- Create Date:    15:05:47 11/26/2017
-- Design Name:
-- Module Name:    DataMem - Behavioral
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

entity Memory is
    Port ( Addr : in  STD_LOGIC_VECTOR (17 downto 0);
           DataIn : in  STD_LOGIC_VECTOR (15 downto 0);
           DataOut : out  STD_LOGIC_VECTOR (15 downto 0);
           WE : in STD_LOGIC;
           RE : in STD_LOGIC;

           -- connect to SRAM on board
           SRAM_EN : out  STD_LOGIC;
           SRAM_OE : out  STD_LOGIC;
           SRAM_WE : out  STD_LOGIC;
           SRAM_ADDR : out  STD_LOGIC_VECTOR (17 downto 0);
           SRAM_DATA : inout  STD_LOGIC_VECTOR (15 downto 0));
end Memory;

architecture Behavioral of Memory is

signal s_EN : STD_LOGIC;
signal s_Addr : STD_LOGIC_VECTOR (17 downto 0);
signal s_DataIn : STD_LOGIC_VECTOR (15 downto 0);
signal s_DataOut : STD_LOGIC_VECTOR (15 downto 0);

begin
    s_EN <= WE or RE;
    s_Addr <= Addr;
    DataOut <= s_DataOut;
    s_DataIn <= DataIn;

    -- control SRAM1 on board
    SRAM_EN <= not s_EN;
    SRAM_OE <= not RE;
    SRAM_WE <= not WE;
    SRAM_ADDR <= s_Addr;

    process (WE, RE)
    begin
        if (RE = '1') then  -- read
            s_DataOut <= SRAM_DATA;
        elsif (WE = '1') then   -- write
            SRAM_DATA <= s_DataIn;
            s_DataOut <= (others=>'Z');
        else    -- idle
            SRAM_DATA <= (others=>'Z');
            s_DataOut <= (others=>'Z');
        end if;
    end process;

end Behavioral;

