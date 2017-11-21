----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    21:04:27 11/21/2017 
-- Design Name: 
-- Module Name:    IOBridge - Behavioral 
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

entity IOBridge is
    Port ( clk_Bridge : in  STD_LOGIC;
           rst : in  STD_LOGIC;
           clk_CPU : out  STD_LOGIC;
		   
		   IO_WE : in  STD_LOGIC;
		   IO_RE : in  STD_LOGIC;
		   
           InstAddr : in  STD_LOGIC_VECTOR (15 downto 0);
		   InstOut : out  STD_LOGIC_VECTOR (15 downto 0);

           IOAddr : in  STD_LOGIC_VECTOR (15 downto 0);
           IODataIn : in  STD_LOGIC_VECTOR (15 downto 0);
           IODataOut : out  STD_LOGIC_VECTOR (15 downto 0);
		   
		   SRAM1_EN : out  STD_LOGIC;
           SRAM1_OE : out  STD_LOGIC;
           SRAM1_WE : out  STD_LOGIC;
           SRAM1_ADDR : out  STD_LOGIC_VECTOR (17 downto 0);
           SRAM1_DATA : inout  STD_LOGIC_VECTOR (15 downto 0);
		   
		   SRAM2_EN : out  STD_LOGIC;
           SRAM2_OE : out  STD_LOGIC;
           SRAM2_WE : out  STD_LOGIC;
           SRAM2_ADDR : out  STD_LOGIC_VECTOR (17 downto 0);
           SRAM2_DATA : inout  STD_LOGIC_VECTOR (15 downto 0);
		   
		   COM_rdn : out  STD_LOGIC;
           COM_wrn : out  STD_LOGIC;
           COM_data_ready : in  STD_LOGIC;
           COM_tbre : in  STD_LOGIC;
           COM_tsre : in  STD_LOGIC;
		   
           VGA_R : out  STD_LOGIC_VECTOR (2 downto 0);
           VGA_G : out  STD_LOGIC_VECTOR (2 downto 0);
           VGA_B : out  STD_LOGIC_VECTOR (2 downto 0);
           VGA_HS : out  STD_LOGIC;
           VGA_VS : out  STD_LOGIC;
		   
           PS2_DATA : in  STD_LOGIC);
end IOBridge;

architecture Behavioral of IOBridge is

begin


end Behavioral;

