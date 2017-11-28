----------------------------------------------------------------------------------
-- Company:
-- Engineer: Li Yifei, Qiao Yifan
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
use ieee.std_logic_unsigned.all;
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
           IOType : out  STD_LOGIC_VECTOR(2 downto 0);
           Inst : in  STD_LOGIC_VECTOR (15 downto 0);
           IODataIn : in  STD_LOGIC_VECTOR (15 downto 0);
           InstAddr : out  STD_LOGIC_VECTOR (15 downto 0);
           IOAddr : out  STD_LOGIC_VECTOR (15 downto 0);
           IODataOut : out  STD_LOGIC_VECTOR (15 downto 0);
           Logger : out  STD_LOGIC_VECTOR (3 downto 0);
           Logger16 : out  STD_LOGIC_VECTOR (15 downto 0));

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

component BranchController is
    Port ( JumpType : in STD_LOGIC_VECTOR(2 downto 0);
    RegData : in STD_LOGIC_VECTOR(15 downto 0);
    WillBranch : out STD_LOGIC;
    PCSelect : out STD_LOGIC_VECTOR(1 downto 0));
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

component ExMemRegister is
    --EX/MEM阶段寄存�
    port(
        clk : in std_logic;
        rst : in std_logic;
        WE  : in std_logic;
        Clear : in std_logic;

        --数据输入
        RegDst_i : in std_logic_vector(3 downto 0);
        ExData_i : in std_logic_vector(15 downto 0);
        RegDataB_i : in std_logic_vector(15 downto 0); --供SW语句写内�

        --信号输入
        RegWrEn_i : in std_logic;
        MemWr_i : in std_logic;
        MemRd_i : in std_logic;
        WBSrc_i : in std_logic;
        IOType_i : in STD_LOGIC_VECTOR (2 downto 0);

        --数据输出
        RegDst_o : out std_logic_vector(3 downto 0);
        ExData_o : out std_logic_vector(15 downto 0);
        RegDataB_o : out std_logic_vector(15 downto 0); --供SW语句写内�

        --信号输出
        RegWrEn_o : out std_logic;
        MemWr_o : out std_logic;
        MemRd_o : out std_logic;
        WBSrc_o : out std_logic;
        IOType_o : out STD_LOGIC_VECTOR (2 downto 0)
    );
end component;

component Extender is
    Port (
        InstIn  : in  std_logic_vector (15 downto 0);
        ImmeOut : out std_logic_vector (15 downto 0)
    );
end component;

component ForwardUnit is
    Port ( RegSrcA : in STD_LOGIC_VECTOR(3 downto 0);
    RegSrcB : in STD_LOGIC_VECTOR(3 downto 0);
    EXMEMRegDst : in STD_LOGIC_VECTOR(3 downto 0);
    MEMWBRegDst : in STD_LOGIC_VECTOR(3 downto 0);
    SelectA : out STD_LOGIC_VECTOR(1 downto 0);
    SelectB : out STD_LOGIC_VECTOR(1 downto 0));
end component;

component HazardUnit is
    Port ( LastMemRd : in STD_LOGIC;
    LastRegDst : in STD_LOGIC_VECTOR(3 downto 0);
    RegSrcA : in STD_LOGIC_VECTOR(3 downto 0);
    RegSrcB : in STD_LOGIC_VECTOR(3 downto 0);
    WillHazard : out STD_LOGIC);
end component;

component IdExRegister is
    --ID/EX阶段寄存�
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

component IfIdRegister is
    --EX/MEM阶段寄存�
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
        Inst_o : out std_logic_vector(15 downto 0)
    );
end component;

component MemWbRegister is
    --EX/MEM阶段寄存�
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
        clk : in std_logic;
        rst : in std_logic;
        RegWrEn : in std_logic;
        RegSrcA  : in std_logic_vector(3 downto 0);
        RegSrcB  : in std_logic_vector(3 downto 0);
        RegDst   : in std_logic_vector(3 downto 0);
        RegWrData  : in std_logic_vector(15 downto 0);

        RegDataA : out std_logic_vector(15 downto 0);
        RegDataB : out std_logic_vector(15 downto 0)
    );
end component;

component StallController is
    Port ( WillHazard : in STD_LOGIC;
    WillBranch : in STD_LOGIC;
    WillVisitInst : in STD_LOGIC;

    WE_PC : out STD_LOGIC;
    WE_IFID : out STD_LOGIC;
    WE_IDEX : out STD_LOGIC;
    WE_EXMEM : out STD_LOGIC;
    WE_MEMWB : out STD_LOGIC;

    Clear_IFID : out STD_LOGIC;
    Clear_IDEX : out STD_LOGIC);
end component;

component TSetter is
    Port ( TRegType : in STD_LOGIC; -- 0 for cmp; 1 for slt
    Flag : in STD_LOGIC_VECTOR(1 downto 0); -- 0 for Z; 1 for S
    TOut : out STD_LOGIC_VECTOR(15 downto 0));
end component;

component IOMapper is
    Port ( MemWr : in  STD_LOGIC;
           MemRd : in  STD_LOGIC;
           AddrIn : in  STD_LOGIC_VECTOR (15 downto 0);
           WillVisitInst : out  STD_LOGIC;
           IOType : out  STD_LOGIC_VECTOR (2 downto 0));
end component;

component Mux2 is
    Port ( selector : in std_logic;
        inputA   : in std_logic_vector (15 downto 0);
        inputB   : in std_logic_vector (15 downto 0);
        res   : out std_logic_vector (15 downto 0));
end component;

component Mux3 is
    port ( selector : in std_logic_vector (1 downto 0);
    inputA   : in std_logic_vector (15 downto 0);
    inputB   : in std_logic_vector (15 downto 0);
    inputC   : in std_logic_vector (15 downto 0);
    res   : out std_logic_vector (15 downto 0));
end component Mux3;

component Mux4 is
    port ( selector : in std_logic_vector (1 downto 0);
    inputA   : in std_logic_vector (15 downto 0);
    inputB   : in std_logic_vector (15 downto 0);
    inputC   : in std_logic_vector (15 downto 0);
    inputD   : in std_logic_vector (15 downto 0);
    res   : out std_logic_vector (15 downto 0));
end component Mux4;

component Mux6 is
    port ( selector : in std_logic_vector (2 downto 0);
    inputA   : in std_logic_vector (15 downto 0);
    inputB   : in std_logic_vector (15 downto 0);
    inputC   : in std_logic_vector (15 downto 0);
    inputD   : in std_logic_vector (15 downto 0);
    inputE   : in std_logic_vector (15 downto 0);
    inputF   : in std_logic_vector (15 downto 0);
    res   : out std_logic_vector (15 downto 0));
end component Mux6;

--------------signal--------------------

-- Stall & Hazard & Forward --
signal WE_PC, WE_IFID, WE_IDEX, WE_EXMEM, WE_MEMWB : STD_LOGIC := '1';
signal Clear_IFPC, Clear_IFID, Clear_IDEX, Clear_EXMEM, Clear_MEMWB : STD_LOGIC := '0';
signal WillHazard, WillBranch, WillVisitInst : STD_LOGIC := '0';
signal ForwardSelectA, ForwardSelectB : STD_LOGIC_VECTOR(1 downto 0) := (others => '0');

-- IF --
signal if_PC, if_NPC, if_RPC, if_Inst, if_InstAddr : STD_LOGIC_VECTOR(15 downto 0) := (others => '0');

-- ID --
signal id_NPC, id_RPC, id_Inst, id_Imme : STD_LOGIC_VECTOR(15 downto 0) := (others => '0');
signal id_TRegType, id_RegWrEn, id_MemWr, id_MemRd, id_WBSrc, id_ALUSrc : STD_LOGIC := '0';
signal id_JumpType, id_ExRes : STD_LOGIC_VECTOR(2 downto 0) := (others => '0');
signal id_ALUOp, id_RegSrcA, id_RegSrcB, id_RegDst : STD_LOGIC_VECTOR(3 downto 0) := (others => '0');
signal id_RegDataA, id_RegDataB : STD_LOGIC_VECTOR(15 downto 0) := (others => '0');

-- EX --
signal ex_TRegType, ex_RegWrEn, ex_MemWr, ex_MemRd, ex_WBSrc, ex_ALUSrc : STD_LOGIC := '0';
signal ex_JumpType, ex_ExRes : STD_LOGIC_VECTOR(2 downto 0) := (others => '0');
signal ex_ALUOp, ex_RegSrcA, ex_RegSrcB, ex_RegDst : STD_LOGIC_VECTOR(3 downto 0) := (others => '0');
signal ex_NPC, ex_RPC, ex_RegDataA, ex_RegDataB, ex_Imme : STD_LOGIC_VECTOR(15 downto 0) := (others => '0');

signal ex_DataA, ex_DataBTemp, ex_DataB : STD_LOGIC_VECTOR(15 downto 0) := (others => '0');

signal ex_ALUFlag : STD_LOGIC_VECTOR(1 downto 0) := (others => '0');
signal ex_ALURes, ex_TOut, ex_DataOut : STD_LOGIC_VECTOR(15 downto 0) := (others => '0');

signal ex_PCOffset : STD_LOGIC_VECTOR(15 downto 0) := (others => '0');
signal ex_PCSelect : STD_LOGIC_VECTOR(1 downto 0) := "01";

signal ex_IOType : STD_LOGIC_VECTOR(2 downto 0) := (others => '0');

-- MEM --
signal mem_RegWrEn, mem_MemWr, mem_MemRd, mem_WBSrc : STD_LOGIC := '0';
signal mem_RegDst : STD_LOGIC_VECTOR(3 downto 0) := (others => '0');
signal mem_ExData, mem_RegDataB, mem_Data : STD_LOGIC_VECTOR(15 downto 0) := (others => '0');
signal mem_IOType : STD_LOGIC_VECTOR(2 downto 0) := (others => '0');

-- WB --
signal wb_RegWrEn, wb_WBSrc : STD_LOGIC := '0';
signal wb_RegDst : STD_LOGIC_VECTOR(3 downto 0) := (others => '0');
signal wb_Data, wb_MemData, wb_ExData : STD_LOGIC_VECTOR(15 downto 0) := (others => '0');

--------------process-------------------

begin

    Logger <= "0" & ex_IOType;
    Logger16 <= id_JumpType;

    ----- Stall & Hazard & Forward ----

    Stall: StallController port map (
        WillHazard => WillHazard,
        WillBranch => WillBranch,
        WillVisitInst => WillVisitInst,
        WE_PC => WE_PC,
        WE_IFID => WE_IFID,
        WE_IDEX => WE_IDEX,
        WE_EXMEM => WE_EXMEM,
        WE_MEMWB => WE_MEMWB,
        Clear_IFID => Clear_IFID,
        Clear_IDEX => Clear_IDEX
    );

    Hazard: HazardUnit port map (
        LastMemRd => ex_MemRd,
        LastRegDst => ex_RegDst,
        RegSrcA => id_RegSrcA,
        RegSrcB => id_RegSrcB,
        WillHazard => WillHazard
    );

    Forward: ForwardUnit port map (
        RegSrcA => ex_RegSrcA,
        RegSrcB => ex_RegSrcB,
        EXMEMRegDst => mem_RegDst,
        MEMWBRegDst => wb_RegDst,
        SelectA => ForwardSelectA,
        SelectB => ForwardSelectB
    );

    --------------- IF ----------------

    IF_PCReg: PCReg port map (
        clk => clk,
        rst => rst,
        clear => Clear_IFPC,
        WE => WE_PC,
        PC_i => if_PC,
        PC_o => if_InstAddr
    );

    InstAddr <= if_InstAddr;
    if_Inst <= Inst;

    IF_Mux3: MUX3 port map (
        InputA => ex_DataA,
        InputB => if_NPC,
        InputC => ex_PCOffset,
        res => if_PC,
        selector => ex_PCSelect
    );

    if_NPC <= if_InstAddr + 1;
    if_RPC <= if_InstAddr + 2;

    ----------------- IFID ----------------------

    IFID: IfIdRegister port map (
        clk => clk,
        rst => rst,
        WE => WE_IFID,
        Clear => Clear_IFID,
        NPC_i => if_PC,
        RPC_i => if_RPC,
        Inst_i => if_Inst,
        NPC_o => id_NPC,
        RPC_o => id_RPC,
        Inst_o => id_Inst
    );

    ------------- ID --------------

    ID_Controller: Controller port map (
        Inst => id_Inst,
        TRegType => id_TRegType,
        RegWrEn => id_RegWrEn,
        MemWr => id_MemWr,
        MemRd => id_MemRd,
        WBSrc => id_WBSrc,
        JumpType => id_JumpType,
        ALUop => id_ALUOp,
        RegSrcA => id_RegSrcA,
        RegSrcB => id_RegSrcB,
        RegDst => id_RegDst,
        ExRes => id_ExRes,
        ALUSrc => id_ALUSrc
    );

    ID_RegisterFile: RegisterFile port map (
        clk => clk,
        rst => rst,
        RegWrEn => wb_RegWrEn,
        RegSrcA => id_RegSrcA,
        RegSrcB => id_RegSrcB,
        RegDst => wb_RegDst,
        RegWrData => wb_Data,
        RegDataA => id_RegDataA,
        RegDataB => id_RegDataB
    );

    ID_Extender: Extender port map (
        InstIn => id_Inst,
        ImmeOut => id_Imme
    );

    ------------------- IDEX -----------------------

    IDEX: IdExRegister port map (
        clk => clk,
        rst => rst,
        WE => WE_IDEX,
        Clear => Clear_IDEX,
        RegSrcA_i => id_RegSrcA,
        RegSrcB_i => id_RegSrcB,
        RegDst_i => id_RegDst,
        ExRes_i => id_ExRes,
        NPC_i => id_NPC,
        RPC_i => id_RPC,
        TRegType_i => id_TRegType,
        RegWrEn_i => id_RegWrEn,
        MemWr_i => id_MemWr,
        MemRd_i => id_MemRd,
        WBSrc_i => id_WBSrc,
        JumpType_i => id_JumpType,
        ALUOp_i => id_ALUOp,
        ALUSrc_i => id_ALUSrc,
        RegDataA_i => id_RegDataA,
        RegDataB_i => id_RegDataB,
        Imme_i => id_Imme,
        RegSrcA_o => ex_RegSrcA,
        RegSrcB_o => ex_RegSrcB,
        RegDst_o => ex_RegDst,
        ExRes_o => ex_ExRes,
        NPC_o => ex_NPC,
        RPC_o => ex_RPC,
        TRegType_o => ex_TRegType,
        RegWrEn_o => ex_RegWrEn,
        MemWr_o => ex_MemWr,
        MemRd_o => ex_MemRd,
        WBSrc_o => ex_WBSrc,
        JumpType_o => ex_JumpType,
        ALUOp_o => ex_ALUOp,
        ALUSrc_o => ex_ALUSrc,
        RegDataA_o => ex_RegDataA,
        RegDataB_o => ex_RegDataB,
        Imme_o => ex_Imme
    );

    ------------------ EX -------------------

    EX_MUXA: Mux3 port map (
        selector => ForwardSelectA,
        inputA => ex_RegDataA,
        inputB => mem_ExData,
        inputC => wb_Data,
        res => ex_DataA
    );

    EX_MUXB: Mux3 port map (
        selector => ForwardSelectB,
        inputA => ex_RegDataB,
        inputB => mem_ExData,
        inputC => wb_Data,
        res => ex_DataBTemp
    );

    ex_PCOffset <= ex_Imme + ex_NPC;

    EX_MUXBImme: Mux2 port map (
        selector => ex_ALUSrc,
        inputA => ex_DataBTemp,
        inputB => ex_Imme,
        res => ex_DataB
    );

    EX_ALU: ALU port map (
        InputA => ex_DataA,
        InputB => ex_DataB,
        ALUOp => ex_ALUOp,
        ALUFlag => ex_ALUFlag,
        ALURes => ex_ALURes
    );

    EX_TSetter: TSetter port map (
        TRegType => ex_TRegType,
        Flag => ex_ALUFlag,
        TOut => ex_TOut
    );

    EX_IOMapper: IOMapper port map (
        MemWr => ex_MemWr,
        MemRd => ex_MemRd,
        AddrIn => ex_DataOut,
        WillVisitInst => WillVisitInst,
        IOType => ex_IOType
    );

    EX_MUX: Mux6 port map (
        selector => ex_ExRes,
        inputA => ex_TOut,
        inputB => ex_NPC,
        inputC => ex_RPC,
        inputD => ex_ALURes,
        inputE => ex_DataA,
        inputF => ex_DataB,
        res => ex_DataOut
    );

    EX_BranchController: BranchController port map (
        JumpType => ex_JumpType,
        RegData => ex_DataA,
        WillBranch => WillBranch,
        PCSelect => ex_PCSelect
    );


    ---------------- EXMEM -----------------

    EXMEM: ExMemRegister port map (
        clk => clk,
        rst => rst,
        WE => WE_EXMEM,
        Clear => Clear_EXMEM,
        RegDst_i => ex_RegDst,
        ExData_i => ex_DataOut,
        RegDataB_i => ex_DataBTemp,
        RegWrEn_i => ex_RegWrEn,
        MemWr_i => ex_MemWr,
        MemRd_i => ex_MemRd,
        WBSrc_i => ex_WBSrc,
        IOType_i => ex_IOType,
        RegDst_o => mem_RegDst,
        ExData_o => mem_ExData,
        RegDataB_o => mem_RegDataB,
        RegWrEn_o => mem_RegWrEn,
        MemWr_o => mem_MemWr,
        MemRd_o => mem_MemRd,
        WBSrc_o => mem_WBSrc,
        IOType_o => mem_IOType
    );

    --------------- MEM ------------------

    IOType <= mem_IOType;
    IO_WE <= mem_MemWr;
    IO_RE <= mem_MemRd;
    IOAddr <= mem_ExData;
    IODataOut <= mem_RegDataB;
    mem_Data <= IODataIn;

    --------------- MEMWB -----------------

    MEMWB: MemWbRegister port map (
        clk => clk,
        rst => rst,
        WE => WE_MEMWB,
        Clear => Clear_MEMWB,
        RegDst_i => mem_RegDst,
        ExData_i => mem_ExData,
        MemData_i => mem_Data,
        RegWrEn_i => mem_RegWrEn,
        WBSrc_i => mem_WBSrc,
        RegDst_o => wb_RegDst,
        ExData_o => wb_ExData,
        MemData_o => wb_MemData,
        RegWrEn_o => wb_RegWrEn,
        WBSrc_o => wb_WBSrc
    );

    ------------- WB --------------

    WB_MUX: Mux2 port map (
        selector => wb_WBSrc,
        inputA => wb_MemData,
        inputB => wb_ExData,
        res => wb_Data
    );

end Behavioral;

