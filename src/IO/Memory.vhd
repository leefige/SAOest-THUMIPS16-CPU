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
           EN : in STD_LOGIC;
           clk : in STD_LOGIC;
           rst : in STD_LOGIC;

           -- connect to SRAM on board
           SRAM_EN : out  STD_LOGIC;
           SRAM_OE : out  STD_LOGIC;
           SRAM_WE : out  STD_LOGIC;
           SRAM_ADDR : out  STD_LOGIC_VECTOR (17 downto 0);
           SRAM_DATA : inout  STD_LOGIC_VECTOR (15 downto 0));
end Memory;

architecture Behavioral of Memory is

signal s_Addr : STD_LOGIC_VECTOR (17 downto 0);
signal s_DataIn : STD_LOGIC_VECTOR (15 downto 0);
signal s_DataOut : STD_LOGIC_VECTOR (15 downto 0);
signal MemState : STD_LOGIC_VECTOR (1 downto 0);

begin
    s_Addr <= Addr;
    DataOut <= s_DataOut;
    s_DataIn <= DataIn;

    -- control SRAM1 on board

    MemState <= (EN and WE) & (EN and RE);  -- w & r

    pre: process (clk, rst)
    begin
        if rst = '0' then
            SRAM_ADDR <= (others=>'Z');
            SRAM_EN <= '1';
            SRAM_OE <= '1';
            SRAM_WE <= '1';

        elsif clk'event and clk = '1' then  -- rising
            SRAM_EN <= not EN;
            SRAM_OE <= not RE;
            SRAM_WE <= not WE;
            SRAM_ADDR <= s_Addr;
        end if;
    end process;

    data: process (clk, rst)
    begin
        if rst = '0' then
            SRAM_DATA <= (others=>'Z');
            s_DataOut <= (others=>'Z');

        elsif clk'event and clk = '0' then  --falling
            case MemState is
                when "10" =>    -- write
                    SRAM_DATA <= s_DataIn;
                    s_DataOut <= (others=>'Z');
                when "01" =>    -- read
                    SRAM_DATA <= (others=>'Z');
                    s_DataOut <= SRAM_DATA;
                when others =>
                    SRAM_DATA <= (others=>'Z');
                    s_DataOut <= (others=>'Z');
            end case;
        end if;
    end process;

end Behavioral;

