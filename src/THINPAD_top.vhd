----------------------------------------------------------------------------------
-- Company:
-- Engineer: Li Yifei
--
-- Create Date:    21:26:09 11/21/2017
-- Design Name:
-- Module Name:    THINPAD_top - Behavioral
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

entity THINPAD_top is
    Port ( clk_top : in  STD_LOGIC;
           clk_PS2 : in  STD_LOGIC;
           clk_VGA : in STD_LOGIC;
           rst : in  STD_LOGIC;

           Switch : in  STD_LOGIC_VECTOR (15 downto 0);
           Light : out  STD_LOGIC_VECTOR (15 downto 0);
           DYP1 : out  STD_LOGIC_VECTOR (6 downto 0);
           DYP2 : out  STD_LOGIC_VECTOR (6 downto 0);

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

end THINPAD_top;

architecture Behavioral of THINPAD_top is

--------------component-----------------

component CPU
    Port ( clk : in  STD_LOGIC;
           rst : in  STD_LOGIC;

           IO_WE : out  STD_LOGIC;
           IO_RE : out  STD_LOGIC;
           IOType : out  STD_LOGIC_VECTOR(2 downto 0);

           Inst : in  STD_LOGIC_VECTOR (15 downto 0);
           InstAddr : out  STD_LOGIC_VECTOR (15 downto 0);

           IOAddr : out  STD_LOGIC_VECTOR (15 downto 0);
           IODataIn : in  STD_LOGIC_VECTOR (15 downto 0);
           IODataOut : out  STD_LOGIC_VECTOR (15 downto 0);
           Logger1 : out  STD_LOGIC_VECTOR (3 downto 0);
           Logger2 : out  STD_LOGIC_VECTOR (3 downto 0);
           Logger16 : out  STD_LOGIC_VECTOR (15 downto 0)
    );
end component;

component IOBridge
    Port ( clk_PS2 : in  STD_LOGIC;
           clk_VGA : in  STD_LOGIC;

           IOType : in  STD_LOGIC_VECTOR (2 downto 0);

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
end component;

component Digit7 is
    Port ( num : in  STD_LOGIC_VECTOR (3 downto 0);
           seg : out  STD_LOGIC_VECTOR (6 downto 0));
end component;

--------------signal--------------------

signal s_DebugNum1 : STD_LOGIC_VECTOR (3 downto 0);
signal s_DebugNum2 : STD_LOGIC_VECTOR (3 downto 0);

signal s_Logger1 : STD_LOGIC_VECTOR (3 downto 0);
signal s_Logger2 : STD_LOGIC_VECTOR (3 downto 0);
signal s_Logger16 : STD_LOGIC_VECTOR (15 downto 0);

signal s_Inst : STD_LOGIC_VECTOR (15 downto 0);
signal s_InstAddr : STD_LOGIC_VECTOR (15 downto 0);
signal s_IOType : STD_LOGIC_VECTOR (2 downto 0);

signal s_IOAddr : STD_LOGIC_VECTOR (15 downto 0);
signal s_IODataCPU2Bridge : STD_LOGIC_VECTOR (15 downto 0);
signal s_IODataBridge2CPU : STD_LOGIC_VECTOR (15 downto 0);

signal s_IO_WE : STD_LOGIC;
signal s_IO_RE : STD_LOGIC;

--------------process-------------------

begin

	c_DYP1 : Digit7 port map (
		num => s_DebugNum1,
        seg => DYP1
    );

    c_DYP2: Digit7 port map (
		num => s_DebugNum2,
        seg => DYP2
	);

    c_CPU : CPU port map (
        clk => clk_top,
        rst => rst,

        IO_RE => s_IO_RE,
        IO_WE => s_IO_WE,
        IOType => s_IOType,

        Inst => s_Inst,
        InstAddr => s_InstAddr,

        IOAddr => s_IOAddr,
        IODataIn => s_IODataBridge2CPU,
        IODataOut => s_IODataCPU2Bridge,
        Logger1 => s_Logger1,
        Logger2 => s_Logger2,
        Logger16 => s_Logger16
    );

    c_IOBridge : IOBridge port map (
        clk_PS2 => clk_PS2,
        clk_VGA => clk_VGA,

        IOType => s_IOType,
        IO_WE => s_IO_WE,
        IO_RE => s_IO_RE,

        InstAddr => s_InstAddr,
        InstOut => s_Inst,

        IOAddr => s_IOAddr,
        IODataIn => s_IODataCPU2Bridge,
        IODataOut => s_IODataBridge2CPU,

        SRAM1_EN => SRAM1_EN,
        SRAM1_OE => SRAM1_OE,
        SRAM1_WE => SRAM1_WE,
        SRAM1_ADDR => SRAM1_ADDR,
        SRAM1_DATA => SRAM1_DATA,

        SRAM2_EN => SRAM2_EN,
        SRAM2_OE => SRAM2_OE,
        SRAM2_WE => SRAM2_WE,
        SRAM2_ADDR => SRAM2_ADDR,
        SRAM2_DATA  => SRAM2_DATA,

        COM_rdn => COM_rdn,
        COM_wrn => COM_wrn,
        COM_data_ready => COM_data_ready,
        COM_tbre => COM_tbre,
        COM_tsre => COM_tsre,

        VGA_R => VGA_R,
        VGA_G => VGA_G,
        VGA_B => VGA_B,
        VGA_HS => VGA_HS,
        VGA_VS => VGA_VS,

        PS2_DATA => PS2_DATA
    );

	-- DYP2 <= (others=>'0');

	-- Light <= s_InstAddr;
	Light <= s_Logger16;

    s_DebugNum1 <= s_Logger1;
    s_DebugNum2 <= s_Logger2;

end Behavioral;

