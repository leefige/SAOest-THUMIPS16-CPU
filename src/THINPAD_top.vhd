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
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity THINPAD_top is
    Port ( clk_manual : in STD_LOGIC;
           clk_11M : in  STD_LOGIC;
           clk_PS2 : in  STD_LOGIC;
           clk_50M : in STD_LOGIC;
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

           FlashByte : out std_logic;
           FlashVpen : out std_logic;
           FlashCE : out std_logic;
           FlashOE : out std_logic;
           FlashWE : out std_logic;
           FlashRP : out std_logic;
           FlashAddr : out std_logic_vector(22 downto 0);
           FlashData : inout STD_LOGIC_VECTOR(15 downto 0);

           PS2_DATA : in  STD_LOGIC);

end THINPAD_top;

architecture Behavioral of THINPAD_top is

--------------component-----------------

component CPU
    Port (
           clk : in  STD_LOGIC;
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
           Logger16_1 : out  STD_LOGIC_VECTOR (15 downto 0);
           Logger16_2 : out  STD_LOGIC_VECTOR (15 downto 0);
           Logger16_3 : out  STD_LOGIC_VECTOR (15 downto 0);
           Logger16_4 : out  STD_LOGIC_VECTOR (15 downto 0);
           Logger16_5 : out  STD_LOGIC_VECTOR (15 downto 0);
           Logger16_6 : out  STD_LOGIC_VECTOR (15 downto 0);
           Logger16_7 : out  STD_LOGIC_VECTOR (15 downto 0);
           Logger16_8 : out  STD_LOGIC_VECTOR (15 downto 0);
           Logger16_9 : out  STD_LOGIC_VECTOR (15 downto 0);
           Logger16_10 : out  STD_LOGIC_VECTOR (15 downto 0);
           Logger16_11 : out  STD_LOGIC_VECTOR (15 downto 0)
    );
end component;

component IOBridge
    Port (
        clk_PS2 : in  STD_LOGIC;
        clk_IO : in STD_LOGIC;
		clk_50M : in STD_LOGIC;
        rst : in  STD_LOGIC;

        clk_CPU : out STD_LOGIC;

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

        PS2_DATA : in  STD_LOGIC
        );
end component;

component Digit7 is
    Port ( num : in  STD_LOGIC_VECTOR (3 downto 0);
           seg : out  STD_LOGIC_VECTOR (6 downto 0));
end component;

COMPONENT ClockGen
	PORT(
		CLKIN_IN : IN std_logic;
		RST_IN : IN std_logic;
		CLKFX_OUT : OUT std_logic;
		CLKIN_IBUFG_OUT : OUT std_logic;
		CLK0_OUT : OUT std_logic
		);
END COMPONENT;

--------------signal--------------------

signal s_DebugNum1 : STD_LOGIC_VECTOR (3 downto 0);
signal s_DebugNum2 : STD_LOGIC_VECTOR (3 downto 0);

signal s_Logger1 : STD_LOGIC_VECTOR (3 downto 0);
signal s_Logger2 : STD_LOGIC_VECTOR (3 downto 0);
signal s_Logger16_1 : STD_LOGIC_VECTOR (15 downto 0);
signal s_Logger16_2 : STD_LOGIC_VECTOR (15 downto 0);
signal s_Logger16_3 : STD_LOGIC_VECTOR (15 downto 0);
signal s_Logger16_4 : STD_LOGIC_VECTOR (15 downto 0);
signal s_Logger16_5 : STD_LOGIC_VECTOR (15 downto 0);
signal s_Logger16_6 : STD_LOGIC_VECTOR (15 downto 0);
signal s_Logger16_7 : STD_LOGIC_VECTOR (15 downto 0);
signal s_Logger16_8 : STD_LOGIC_VECTOR (15 downto 0);
signal s_Logger16_9 : STD_LOGIC_VECTOR (15 downto 0);
signal s_Logger16_10 : STD_LOGIC_VECTOR (15 downto 0);
signal s_Logger16_11 : STD_LOGIC_VECTOR (15 downto 0);
signal s_Logger16_12 : STD_LOGIC_VECTOR (15 downto 0);

signal s_Inst : STD_LOGIC_VECTOR (15 downto 0);
signal s_InstAddr : STD_LOGIC_VECTOR (15 downto 0);
signal s_IOType : STD_LOGIC_VECTOR (2 downto 0);

signal s_IOAddr : STD_LOGIC_VECTOR (15 downto 0);
signal s_IODataCPU2Bridge : STD_LOGIC_VECTOR (15 downto 0);
signal s_IODataBridge2CPU : STD_LOGIC_VECTOR (15 downto 0);

signal s_IO_WE : STD_LOGIC;
signal s_IO_RE : STD_LOGIC;

signal s_clk_IO : STD_LOGIC;
signal s_clk_CPU : STD_LOGIC;

signal s_clk_div : STD_LOGIC;
signal clk_origin : STD_LOGIC;
signal clk_fx : STD_LOGIC;
signal clk_bufg : STD_LOGIC;

signal clk_auto : STD_LOGIC;
signal clk_ori_dbl : STD_LOGIC;

-- signal counter : INTEGER range 0 to 1024000 := 0;
-- signal FreqDiv : INTEGER range 0 to 1024000 := 0;

signal FlashBootMemAddr : STD_LOGIC_VECTOR(15 downto 0);

shared variable FlashTimer : integer := 0;
signal FlashReadData : STD_LOGIC_VECTOR(15 downto 0);

signal FlashIOType : STD_LOGIC_VECTOR(2 downto 0);
signal FlashIO_WE : STD_LOGIC;
signal FlashIO_RE : STD_LOGIC;
signal Flash_clk_IO : STD_LOGIC;
signal rst_manual : STD_LOGIC := '0';

signal clk_selector : STD_LOGIC := '0';

signal current_addr : STD_LOGIC_VECTOR(15 downto 0) := (others => '0');	--flash当前要读的地址

type STATE_TYPE is (BOOT, BOOT_START, BOOT_FLASH, BOOT_FLASH2, BOOT_FLASH3, BOOT_FLASH4, BOOT_RAM, BOOT_COMPLETE);
signal state : STATE_TYPE;

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

	c_ClockGen: ClockGen PORT MAP(
		CLKIN_IN => clk_50M,
		RST_IN => not rst,
		CLKFX_OUT => clk_fx,
		CLKIN_IBUFG_OUT => clk_bufg,
		CLK0_OUT => clk_origin
	);

    -- clk_origin <= clk_50M;

    c_CPU : CPU port map (
        clk => s_clk_CPU,
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
        Logger16_1 => s_Logger16_1,
        Logger16_2 => s_Logger16_2,
        Logger16_3 => s_Logger16_3,
        Logger16_4 => s_Logger16_4,
        Logger16_5 => s_Logger16_5,
        Logger16_6 => s_Logger16_6,
        Logger16_7 => s_Logger16_7,
        Logger16_8 => s_Logger16_8,
        Logger16_9 => s_Logger16_9,
        Logger16_10 => s_Logger16_10,
        Logger16_11 => s_Logger16_11
    );

    c_IOBridge : IOBridge port map (
        clk_IO => Flash_clk_IO,
		clk_50M => clk_origin,
        clk_PS2 => clk_PS2,
        clk_CPU => s_clk_CPU,

        rst => rst,

        -- IOType => s_IOType,
        -- IO_WE => s_IO_WE,
        -- IO_RE => s_IO_RE,
        IOType => FlashIOType,
        IO_WE => FlashIO_WE,
        IO_RE => FlashIO_RE,

        InstAddr => s_InstAddr,
        InstOut => s_Inst,

        IOAddr => FlashBootMemAddr,
        IODataIn => FlashReadData,
        --IOAddr => s_IOAddr,
        --IODataIn => s_IODataCPU2Bridge,
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

    with Switch (7 downto 0) select
    Light <= s_InstAddr when "00000000",
             s_Inst when "00000001",
             s_IOAddr when "00000010",
             s_IODataCPU2Bridge when "00000011",
             s_IODataBridge2CPU when "00000100",
             s_Logger16_1 when "00000101",
             s_Logger16_2 when "00000110",
             s_Logger16_3 when "00000111",
             s_Logger16_4 when "00001000",
             s_Logger16_5 when "00001001",
             s_Logger16_6 when "00001010",
             s_Logger16_7 when "00001011",
             s_Logger16_8 when "00001100",
             s_Logger16_9 when "00001101",
             s_Logger16_10 when "00001110",
             FlashReadData when "11111111",
			 (others=>'0') when others;

    with Switch (15) select
    s_clk_IO <=  clk_auto when '1',
				clk_manual when '0',
                '0' when others;

    with Switch (14) select
    clk_auto <=  clk_ori_dbl when '1',
				clk_fx when '0',
                '0' when others;

    with Switch (13) select
    clk_ori_dbl <=  clk_11M when '1',
				clk_origin when '0',
                '0' when others;

    s_DebugNum1 <= '0' & FlashIOType;

    with clk_selector select
        Flash_clk_IO <= clk_11M when '0',
                        s_clk_IO when others;

    flash_boot: process(Flash_clk_IO, rst)
    begin
        if(rst_manual = '1') then
           FlashIOType <= s_IOType;
           FlashIO_WE <= s_IO_WE;
           FlashIO_RE <= s_IO_RE;
           FlashBootMemAddr <= s_IOAddr;
           FlashReadData <= s_IODataCPU2Bridge;
           clk_selector <= '1';
        elsif (rst = '0') then
            state <= BOOT_START;
            s_DebugNum2 <= "0000";
            clk_selector <= '0';
        elsif (Flash_clk_IO'event and Flash_clk_IO = '1') then
        if(FlashTimer = 1000) then
            FlashTimer := 0;
            case state is
                when BOOT =>
                    clk_selector <= '1';
					state <= BOOT;
                    s_DebugNum2 <= "1000";
				when BOOT_START =>
                    current_addr <= (others => '0');
                    FlashWE <= '0';
                    FlashOE <= '1';

                    FlashByte <= '1';
                    FlashVpen <= '1';
                    FlashRP <= '1';
                    FlashCE <= '0';

                    state <= BOOT_FLASH;
            s_DebugNum2 <= "0001";

				when BOOT_FLASH =>
					FlashData <= x"00FF";
                    state <= BOOT_FLASH2;
            s_DebugNum2 <= "0010";

                when BOOT_FLASH2 =>
                    FlashWE <= '1';
                    state <= BOOT_FLASH3;
            s_DebugNum2 <= "0011";

                when BOOT_FLASH3 =>
                    FlashAddr <= "000000" & current_addr & '0';
					FlashData <= (others => 'Z');
					FlashOE <= '0';
                    state <= BOOT_FLASH4;
            s_DebugNum2 <= "0100";

                when BOOT_FLASH4 =>
                    FlashReadData <= FlashData;
                    FlashBootMemAddr <= current_addr;
                    FlashIOType <= "001";
                    FlashIO_WE <= '1';
                    FlashIO_RE <= '0';
                    state <= BOOT_RAM;
            s_DebugNum2 <= "0101";

				when BOOT_RAM =>
                    FlashIO_WE <= '0';
                    FlashIO_RE <= '0';
					if (current_addr < x"0FFF") then
						state <= BOOT_FLASH;
					else
						state <= BOOT_COMPLETE;
					end if;
                    current_addr <= current_addr + 1;
            s_DebugNum2 <= "0110";

				when BOOT_COMPLETE =>
                    rst_manual <= '1';
					state <= BOOT;
            s_DebugNum2 <= "0111";

                when others =>
					state <= BOOT;
            end case;
            elsif (FlashTimer < 1000) then
                FlashTimer := FlashTimer + 1;
            end if;
        end if;
    end process;

end Behavioral;

