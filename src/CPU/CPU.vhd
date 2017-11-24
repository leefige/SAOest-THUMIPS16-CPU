----------------------------------------------------------------------------------
-- Company:
-- Engineer: 李逸飞
--
-- Create Date:    20:54:56 11/21/2017
-- Design Name:
-- Module Name:    CPU - Behavioral
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

entity CPU is
    Port ( clk : in  STD_LOGIC;
           rst : in  STD_LOGIC;
           IO_WE : out  STD_LOGIC;
           IO_RE : out  STD_LOGIC;
           Inst : in  STD_LOGIC_VECTOR (15 downto 0);
           IODataIn : in  STD_LOGIC_VECTOR (15 downto 0);
           InstAddr : out  STD_LOGIC_VECTOR (15 downto 0);
           IOAddr : out  STD_LOGIC_VECTOR (15 downto 0);
           IODataOut : out  STD_LOGIC_VECTOR (15 downto 0));

end CPU;

architecture Behavioral of CPU is

--------------component-----------------

component ALU is
    port(
        InputA   : in std_logic_vector (15 downto 0);
        InputB   : in std_logic_vector (15 downto 0);
        ALUOp    : in std_logic_vector (3 downto 0);

        ALUFlag  : out std_logic_vector (1 downto 0);
        ALURes   : out std_logic_vector (15 downto 0)
    );
end component;

component Controller is
    port(
        Inst     : in std_logic_vector (15 downto 0);

        TRegType : out std_logic;
        RegWrEn  : out std_logic;
        MemWr    : out std_logic;
        MemRd    : out std_logic;
        WBSrc    : out std_logic;
        JumpType : out std_logic_vector (2 downto 0);
        ALUop    : out std_logic_vector (3 downto 0);
        RegSrcA  : out std_logic_vector (3 downto 0);
        RegSrcB  : out std_logic_vector (3 downto 0);
        RegDst   : out std_logic_vector (3 downto 0);
        ExRes    : out std_logic_vector (2 downto 0);
        ALUSrc   : out std_logic
    );
end component;

component ExMemRegisters is
	--EX/MEM阶段寄存器
	port(
		clk : in std_logic;
		rst : in std_logic;
        WE  : in std_logic;
		Clear : in std_logic;

		--数据输入
		RegDst_i : in std_logic_vector(3 downto 0);
		ExData_i : in std_logic_vector(15 downto 0);
		RegDataB_i : in std_logic_vector(15 downto 0); --供SW语句写内存
		--信号输入
		RegWrEn_i : in std_logic;
		MemWr_i : in std_logic;
		MemRd_i : in std_logic;
		WBSrc_i : in std_logic;

		--数据输出
		RegDst_o : out std_logic_vector(3 downto 0);
		ExData_o : out std_logic_vector(15 downto 0);
		RegDataB_o : out std_logic_vector(15 downto 0); --供SW语句写内存
		--信号输出
		RegWrEn_o : out std_logic;
		MemWr_o : out std_logic;
		MemRd_o : out std_logic;
		WBSrc_o : out std_logic
	);
end component;

component IdExRegisters is
	--ID/EX阶段寄存器
	port(
		clk : in std_logic;
		rst : in std_logic;
        WE  : in std_logic;
		Clear : in std_logic;

		--数据输入

        RegSrcA_i : in std_logic_vector(3 downto 0);
        RegSrcB_i : in std_logic_vector(3 downto 0);
		RegDst_i : in std_logic_vector(3 downto 0);
		ExRes_i : in std_logic_vector(2 downto 0);
        NPC_i : in std_logic_vector(15 downto 0);
        RPC_i : in std_logic_vector(15 downto 0);
		--信号输入

        TRegType_i : in std_logic;
		RegWrEn_i : in std_logic;
		MemWr_i : in std_logic;
		MemRd_i : in std_logic;
		WBSrc_i : in std_logic;
        JumpType_i : in std_logic_vector(2 downto 0);
        ALUOp_i : in std_logic_vector(3 downto 0);
        ALUSrc_i : in std_logic;
        RegDataA_i : in std_logic_vector(15 downto 0);
        RegDataB_i : in std_logic_vector(15 downto 0);
        Imme_i : in std_logic_vector(15 downto 0);

		--数据输出
        RegSrcA_o : out std_logic_vector(3 downto 0);
        RegSrcB_o : out std_logic_vector(3 downto 0);
		RegDst_o : out std_logic_vector(3 downto 0);
		ExRes_o : out std_logic_vector(2 downto 0);
        NPC_o : out std_logic_vector(15 downto 0);
        RPC_o : out std_logic_vector(15 downto 0);
		--信号输出
		TRegType_o : out std_logic;
		RegWrEn_o : out std_logic;
		MemWr_o : out std_logic;
		MemRd_o : out std_logic;
		WBSrc_o : out std_logic;
        JumpType_o : out std_logic_vector(2 downto 0);
        ALUOp_o : out std_logic_vector(3 downto 0);
        ALUSrc_o : out std_logic;
        RegDataA_o : out std_logic_vector(15 downto 0);
        RegDataB_o : out std_logic_vector(15 downto 0);
        Imme_o : out std_logic_vector(15 downto 0)
	);
end component;

component IfIdRegisters is
	--EX/MEM阶段寄存器
	port(
		clk : in std_logic;
		rst : in std_logic;
        WE  : in std_logic;
		Clear : in std_logic;

		--数据输入
		NPC_i : in std_logic_vector(15 downto 0);
		RPC_i : in std_logic_vector(15 downto 0);
		--信号输入
		Inst_i : in std_logic_vector(15 downto 0);

		--数据输出
		NPC_o : out std_logic_vector(15 downto 0);
		RPC_o : out std_logic_vector(15 downto 0);
		--信号输出
        Inst_o : out std_logic_vector(15 downto 0);
	);
end component;

component MemWbRegisters is
	--EX/MEM阶段寄存器
	port(
		clk : in std_logic;
		rst : in std_logic;
        WE  : in std_logic;
		Clear : in std_logic;

		--数据输入
		RegDst_i : in std_logic_vector(3 downto 0);
		ExData_i : in std_logic_vector(15 downto 0);
		MemData_i : in std_logic_vector(15 downto 0);
		--信号输入
		RegWrEn_i : in std_logic;
		WBSrc_i : in std_logic;

		--数据输出
		RegDst_o : out std_logic_vector(3 downto 0);
		ExData_o : out std_logic_vector(15 downto 0);
		MemData_o : out std_logic_vector(15 downto 0);
		--信号输出
		RegWrEn_o : out std_logic;
		WBSrc_o : out std_logic
	);
end component;

component Extender is
    Port (
        InstIn  : in  std_logic_vector (15 downto 0);
        ImmeOut : out std_logic_vector (15 downto 0)
    );
end component;

component PCReg is
    port(
        clk   : in std_logic;
        rst   : in std_logic;

        clear : in std_logic;
        WE    : in std_logic;
        PC_i  : in std_logic_vector (15 downto 0);

        PC_o  : out std_logic_vector (15 downto 0)
    );
end component;

component RegisterFile is
    port(
        RegWrEn : in std_logic;
        RegSrcA  : in std_logic_vector(3 downto 0);
        RegSrcB  : in std_logic_vector(3 downto 0);
        RegDst   : in std_logic_vector(3 downto 0);
        RegWrData  : in std_logic_vector(15 downto 0);

        RegDataA : out std_logic_vector(15 downto 0);
        RegDataB : out std_logic_vector(15 downto 0)
    );
end component;

--------------signal--------------------

--------------process-------------------

begin

end Behavioral;

