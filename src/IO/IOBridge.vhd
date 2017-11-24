----------------------------------------------------------------------------------
-- Company:
-- Engineer: 李逸飞
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

--------------component-----------------

--------------signal--------------------

type InstMemState is (RD_INST, WR_INST);          -- for inst mem, 2 state: normally read / write user's program
signal state_Inst : InstMemState := RD_INST;


signal s_InstAddr : STD_LOGIC_VECTOR (17 downto 0);
signal s_InstData : STD_LOGIC_VECTOR (15 downto 0);

signal s_BUS_Addr : STD_LOGIC_VECTOR (17 downto 0);
signal s_BUS_Data : STD_LOGIC_VECTOR (15 downto 0);



begin

--------------linking-------------------

-- -- we won't use SRAM1
-- SRAM1_EN <= '1';
-- SRAM1_OE <= '1';
-- SRAM1_WE <= '1';

-- SRAM2 will always be enabled
SRAM2_EN <= '0';

-- connect bus to SRAM1_ADDR/DATA
SRAM1_ADDR <= s_BUS_Addr;
SRAM2_DATA <= s_BUS_Data;
-- extend addr currently; may be changed when using VGAs
s_BUS_Addr <= "00" & IOAddr;

-- inst
s_InstAddr <= "00" & InstAddr;
InstOut <= s_InstData;

with state_Inst select
    clk_CPU <= '1' when RD_INST, '0' when others;   -- something wrong, need fix

--------------process-------------------








end Behavioral;

