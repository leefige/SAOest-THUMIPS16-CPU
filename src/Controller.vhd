----------------------------------------------------------------------------------
-- Company:
-- Engineer:
--
-- Create Date:    10:23:43 11/18/2017
-- Design Name:
-- Module Name:    Controller - Behavioral
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

entity Controller is
    port(
        Inst     : in std_logic_vector (15 downto 0);

        TRegType : out std_logic;
        RegWrEn  : out std_logic;
        MemWr    : out std_logic;
        MemRd    : out std_logic;
        WBSrc    : out std_logic_vector (1 downto 0);
        JumpType : out std_logic_vector (2 downto 0);
        MemSrc   : out std_logic;
        ALUop    : out std_logic_vector (3 downto 0);
        RegSrcA  : out std_logic_vector (3 downto 0);
        RegSrcB  : out std_logic_vector (3 downto 0);
        RegDst   : out std_logic_vector (3 downto 0);
        ExRes    : out std_logic_vector (1 downto 0);
        ALUSrc   : out std_logic
    );
end Controller;

architecture Behavioral of Controller is

    signal first5 : std_logic_vector (4 downto 0);
    signal first8 : std_logic_vector (4 downto 0);
    signal last8 : std_logic_vector (7 downto 0);
    signal last5 : std_logic_vector (4 downto 0);
    signal last2 : std_logic_vector (1 downto 0);

begin

    first5 <= Inst(15 downto 11);
    first8 <= Inst(15 downto 8);
    last2 <= Inst(1 downto 0);
    last5 <= Inst(4 downto 0);
    last8 <= Inst(7 downto 0);

    -------------------------------------------------------------------
    -- Controll Outputs For Each Instruction
    -------------------------------------------------------------------
    -- 算术
    if    (first5 = "01001") then                           -- ADDIU
    elsif (first5 = "01000") then                           -- ADDIU3
    elsif (first8 = "01100011") then                        -- ADDSP
    elsif (first5 = "11100" and last2 = "01") then          -- ADDU
    elsif (first5 = "11100" and last2 = "11") then          -- SUBU
    elsif (first5 = "11101" and last5 = "01011") then       -- NEG

    -- 逻辑
    elsif (first5 = "11101" and last2 = "01100") then       -- AND
    elsif (first5 = "11101" and last5 = "01101") then       -- OR

    -- 移位
    elsif (first5 = "00110" and last2 = "00") then          -- SLL
    elsif (first5 = "00110" and last2 = "11") then          -- SRA
    elsif (first5 = "00110" and last2 = "10") then          -- SRL

    -- 分支跳转
    elsif (first5 = "00010") then                           -- B
    elsif (first5 = "00100") then                           -- BEQZ
    elsif (first5 = "00101") then                           -- BNEZ
    elsif (first8 = "01100000") then                        -- BTEQZ
    elsif (first5 = "11101" and last8 = "00000000") then    -- JR
    elsif (first5 = "11101" and last8 = "11000000") then    -- JALR
    elsif (Inst = "1110100000100000") then                  -- JRRA

    -- 比较
    elsif (first5 = "11101" and last5 = "01010") then       -- CMP
    elsif (first5 = "11101" and last5 = "00010") then       -- SLT

    -- 特殊寄存器取/赋值
    elsif (first5 = "11110" and last8 = "00000000") then    -- MFIH
    elsif (first5 = "11101" and last8 = "01000000") then    -- MFPC
    elsif (first5 = "11110" and last8 = "00000001") then    -- MTIH
    elsif (first8 = "01100100" and last5 = "00000") then    -- MTSP

    -- 访存
    elsif (first5 = "01101") then                           -- LI
    elsif (first5 = "10011") then                           -- LW
    elsif (first5 = "10010") then                           -- LW_SP
    elsif (first5 = "11011") then                           -- SW
    elsif (first8 = "01100010") then                        -- SW_RS
    elsif (first5 = "11010") then                           -- SW_SP

    -- 空
    elsif (Inst = "0000100000000000") then                  -- NOP
    end if;

end Behavioral;
