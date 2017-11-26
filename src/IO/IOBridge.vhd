----------------------------------------------------------------------------------
-- Company:
-- Engineer: Li Yifei
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
    Port ( clk_PS2 : in STD_LOGIC;
           clk_VGA : in STD_LOGIC;

           IO_WE : in  STD_LOGIC;
           IO_RE : in  STD_LOGIC;

           InstAddr : in  STD_LOGIC_VECTOR (15 downto 0);
           InstOut : out  STD_LOGIC_VECTOR (15 downto 0);

           IOAddr : in  STD_LOGIC_VECTOR (15 downto 0);
           IODataIn : in  STD_LOGIC_VECTOR (15 downto 0);
           IODataOut : out  STD_LOGIC_VECTOR (15 downto 0);

           -- connect to instruments on board; just connect without change
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

component DataMem is
    Port ( Addr : in  STD_LOGIC_VECTOR (17 downto 0);
           DataIn : in  STD_LOGIC_VECTOR (15 downto 0);
           DataOut : out  STD_LOGIC_VECTOR (15 downto 0);
           WE : in STD_LOGIC;
           RE : in STD_LOGIC;

           -- connect to SRAM1 on board
           SRAM1_EN : out  STD_LOGIC;
           SRAM1_OE : out  STD_LOGIC;
           SRAM1_WE : out  STD_LOGIC;
           SRAM1_ADDR : out  STD_LOGIC_VECTOR (17 downto 0);
           SRAM1_DATA : inout  STD_LOGIC_VECTOR (15 downto 0));
end component;

--------------signal--------------------

type InstMemState is (RD_INST, WR_INST);          -- for inst mem, 2 state: normally read / write user's program
signal state_Inst : InstMemState := RD_INST;

signal s_InstAddrRd : STD_LOGIC_VECTOR (17 downto 0);
signal s_InstAddrWr : STD_LOGIC_VECTOR (17 downto 0);
signal s_InstDataIn : STD_LOGIC_VECTOR (15 downto 0);
signal s_InstDataOut : STD_LOGIC_VECTOR (15 downto 0);

signal s_IOAddr : STD_LOGIC_VECTOR (17 downto 0);
signal s_IODataIn : STD_LOGIC_VECTOR (15 downto 0);
signal s_IODataOut : STD_LOGIC_VECTOR (15 downto 0);

-- data mem (SRAM1)
signal s_DataMemWE : STD_LOGIC;   -- control bus: whether w/r dataMem (SRAM1)
signal s_DataMemRE : STD_LOGIC;
signal s_MemDataIn : STD_LOGIC_VECTOR (15 downto 0);
signal s_MemDataOut : STD_LOGIC_VECTOR (15 downto 0);

signal s_InstMemWE : STD_LOGIC;   -- control bus: whether w/r dataMem (SRAM1)
signal s_InstMemRE : STD_LOGIC;

begin

--------------linking-------------------

    -- SRAM2 will always be enabled
    SRAM2_EN <= '0';

    -- extend addr
    s_IOAddr <= "00" & IOAddr;
    s_InstAddrRd <= "00" & InstAddr;
    s_InstAddrWr <= "00" & IOAddr;

    -- signal for global IO data
    InstOut <= s_InstDataOut;
    IODataOut <= s_IODataOut;
    s_IODataIn <= IODataIn;
    s_InstDataIn <= IODataIn;

    -- DataMem
    c_DataMem: DataMem port map (
        Addr => s_IOAddr,
        DataIn => s_MemDataIn,
        DataOut => s_MemDataOut,
        WE => s_DataMemWE,
        RE => s_DataMemRE,

        -- connect to SRAM1 on board
        SRAM1_EN => SRAM1_EN,
        SRAM1_OE => SRAM1_OE,
        SRAM1_WE => SRAM1_WE,
        SRAM1_ADDR => SRAM1_ADDR,
        SRAM1_DATA => SRAM1_DATA
    );


--------------process-------------------


end Behavioral;

