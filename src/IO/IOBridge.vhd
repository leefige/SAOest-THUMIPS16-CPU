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
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity IOBridge is
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
end IOBridge;

architecture Behavioral of IOBridge is

--------------component-----------------

component Memory is
    Port ( Addr : in  STD_LOGIC_VECTOR (17 downto 0);
           DataIn : in  STD_LOGIC_VECTOR (15 downto 0);
           DataOut : out  STD_LOGIC_VECTOR (15 downto 0);
           WE : in STD_LOGIC;
           RE : in STD_LOGIC;
           EN : in STD_LOGIC;

           -- connect to SRAM on board
           SRAM_EN : out  STD_LOGIC;
           SRAM_OE : out  STD_LOGIC;
           SRAM_WE : out  STD_LOGIC;
           SRAM_ADDR : out  STD_LOGIC_VECTOR (17 downto 0);
           SRAM_DATA : inout  STD_LOGIC_VECTOR (15 downto 0));
end component;

--------------signal--------------------

signal s_IOAddr : STD_LOGIC_VECTOR (17 downto 0);       -- extended addr
signal s_InstAddr : STD_LOGIC_VECTOR (17 downto 0);

signal s_Inst : STD_LOGIC_VECTOR (15 downto 0);

signal s_IODataIn : STD_LOGIC_VECTOR (15 downto 0);
signal s_IODataOut : STD_LOGIC_VECTOR (15 downto 0);
signal s_IODataOut_buffer : STD_LOGIC_VECTOR (15 downto 0);

-- data mem (SRAM1)
signal s_DataMemWE : STD_LOGIC;   -- control bus: whether w/r dataMem (SRAM1)
signal s_DataMemRE : STD_LOGIC;
signal s_DataMemEN : STD_LOGIC;
signal s_MemDataIn : STD_LOGIC_VECTOR (15 downto 0);
signal s_MemDataOut : STD_LOGIC_VECTOR (15 downto 0);

-- instruction mem (SRAM2)
signal s_InstMemWE : STD_LOGIC;   -- control whether w/r instMem (SRAM2)
signal s_InstMemRE : STD_LOGIC;
signal s_InstMemEN : STD_LOGIC;
signal s_InstDataIn : STD_LOGIC_VECTOR (15 downto 0);
signal s_InstDataOut : STD_LOGIC_VECTOR (15 downto 0);

-- com & PS2
signal BF01 : STD_LOGIC_VECTOR (15 downto 0);
signal BF03 : STD_LOGIC_VECTOR (15 downto 0);

signal s_PS2_data_ready : std_logic;
signal s_PS2_wrn : std_logic;

--------------process-------------------

begin

    -- DataMem, SRAM1
    c_DataMem: Memory port map (
        Addr => s_IOAddr,
        DataIn => s_MemDataIn,
        DataOut => s_MemDataOut,
        WE => s_DataMemWE,
        RE => s_DataMemRE,
        EN => s_DataMemEN,

        -- connect to SRAM1 on board
        SRAM_EN => SRAM1_EN,
        SRAM_OE => SRAM1_OE,
        SRAM_WE => SRAM1_WE,
        SRAM_ADDR => SRAM1_ADDR,
        SRAM_DATA => SRAM1_DATA
    );

    -- InstMem, SRAM2
    c_InstMem: Memory port map (
        Addr => s_InstAddr,
        DataIn => s_InstDataIn,
        DataOut => s_InstDataOut,
        WE => s_InstMemWE,
        RE => s_InstMemRE,
        EN => s_InstMemEN,

        -- connect to SRAM1 on board
        SRAM_EN => SRAM2_EN,
        SRAM_OE => SRAM2_OE,
        SRAM_WE => SRAM2_WE,
        SRAM_ADDR => SRAM2_ADDR,
        SRAM_DATA => SRAM2_DATA
    );

    -----------------------------------------------

    -- signals for global IO data
    InstOut <= s_Inst;
    IODataOut <= s_IODataOut;
    s_IODataIn <= IODataIn;

    --------------------SRAM EN--------------------

    -- SRAM2 will always be enabled
    s_InstMemEN <= '1';

    -- disable SRAM1 when visiting UART
    with IOType select
        s_DataMemEN <=  '0' when "001" | "010" | "011", -- inst & COM & ps2
                        '1' when others;

    -------------------------PORT CONTROL------------------------

    --------------------------IO OUT------------------------

    -- extend io addr
    s_IOAddr <= "00" & IOAddr;

    -- select io data out
    s_IODataOut_buffer <=   s_InstDataOut when (IOType = "001") else   -- rd inst
                            "00000000" & SRAM1_DATA(7 downto 0) when (IOAddr = x"BF00") else
                            BF01 when (IOAddr = x"BF01") else
                            -- TODO
                            (others=>'Z') when (IOAddr = x"BF02") else
                            BF03 when (IOAddr = x"BF03") else
                            s_MemDataOut;
    with IO_RE select
        s_IODataOut <=  s_IODataOut_buffer when '1',   -- rd
                        (others=>'Z') when others;

    ------------------------INST OUT-----------------------------

    -- select inst out
    with IOType select
        s_Inst <=   "0000100000000000" when "001",   -- nop
                    s_InstDataOut when others;    -- normally IF

    --==================================================================---


    ------------------------INST MEM CONTROL-----------------------------

    -- select inst addr
    with IOType select
        s_InstAddr <=   "00" & IOAddr when "001",   -- IO will visit inst mem
                        "00" & InstAddr when others;    -- normally IF

    -- select inst data in
    with IOType select
        s_InstDataIn <= s_IODataIn when "001",   -- IO will visit inst mem
                        (others=>'Z') when others;    -- normally IF

    -- select inst data RE, be 0 only when wr inst mem
    s_InstMemRE <= '0' when ((IOType = "001") and (IO_WE = '1')) else '1';

    -- select inst data WE, be 1 only when wr inst mem
    s_InstMemWE <= '1' when ((IOType = "001") and (IO_WE = '1')) else '0';

    ------------------------DATA MEM CONTROL-----------------------------

    -- select data mem data in
    s_MemDataIn <= s_IODataIn;

    -- select DATA data RE, let it be io_re
    -- since en has been controlled
    s_DataMemRE <= IO_RE;

    -- select DATA data WE
    s_DataMemWE <= IO_WE;

    ------------------------COM-----------------------------

    BF01(0) <= COM_tsre and COM_tbre;
	BF01(1) <= COM_data_ready;
	BF01(15 downto 2) <= "00000000000000";

    COM_wrn <= not IO_WE when (IOAddr = x"BF00") else '1';
	COM_rdn <= not IO_RE when (IOAddr = x"BF00") else '1';

    ------------------------PS2-----------------------------

	BF03(0) <= s_PS2_data_ready;
	BF03(15 downto 1) <= "000000000000000";
	s_PS2_wrn <= IO_RE when (IOAddr = x"BF02") else '0';

end Behavioral;

