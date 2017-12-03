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
        WBSrc    : out std_logic;
        JumpType : out std_logic_vector (2 downto 0);
        ALUop    : out std_logic_vector (3 downto 0);
        RegSrcA  : out std_logic_vector (3 downto 0);
        RegSrcB  : out std_logic_vector (3 downto 0);
        RegDst   : out std_logic_vector (3 downto 0);
        ExRes    : out std_logic_vector (2 downto 0);
        ALUSrc   : out std_logic
    );
end Controller;

architecture Behavioral of Controller is

    signal first5 : std_logic_vector (4 downto 0);
    signal first8 : std_logic_vector (7 downto 0);
    signal last8 : std_logic_vector (7 downto 0);
    signal last5 : std_logic_vector (4 downto 0);
    signal last2 : std_logic_vector (1 downto 0);
    signal rx : std_logic_vector (2 downto 0);
    signal ry : std_logic_vector (2 downto 0);

begin

    process (Inst)
    begin

        first5 <= Inst(15 downto 11);
        first8 <= Inst(15 downto 8);
        last2 <= Inst(1 downto 0);
        last5 <= Inst(4 downto 0);
        last8 <= Inst(7 downto 0);
        rx <= Inst(10 downto 8);
        ry <= Inst(7 downto 5);

        -------------------------------------------------------------------
        -- Controll Outputs For Each Instruction
        -------------------------------------------------------------------
        -- 算术

        if (first5 = "01001") then                           -- ADDIU
            TRegType  <= '0';
            RegWrEn <= '1';
            MemWr <= '0';
            MemRd <= '0';
            WBSrc <= '1';
            JumpType <= "111";
            ALUop <= "0001"; -- plus
            RegSrcA <= '0' & Inst(10 downto 8);
            RegSrcB <= (others => '1');
            RegDst <= '0' & Inst(10 downto 8);
            ExRes <= "011"; -- 3 stands for ExData get data from ALURes
            ALUSrc <= '1'; -- imme

        elsif (first5 = "01000") then                           -- ADDIU3
            TRegType  <= '0';
            RegWrEn <= '1';
            MemWr <= '0';
            MemRd <= '0';
            WBSrc <= '1';
            JumpType <= "111";
            ALUOp <= "0001";
            RegSrcA <= '0' & Inst(10 downto 8);
            RegSrcB <= (others => '1');
            RegDst <= '0' & Inst(7 downto 5);
            ExRes <= "011";
            ALUSrc <= '1';

        elsif (first8 = "01100011") then                        -- ADDSP
            TRegType  <= '0';
            RegWrEn <= '1';
            MemWr <= '0';
            MemRd <= '0';
            WBSrc <= '1';
            JumpType <= "111";
            ALUOp <= "0001";
            RegSrcA <= "1010";
            RegSrcB <= (others => '1');
            RegDst <= "1010";
            ExRes <= "011";
            ALUSrc <= '1';

        elsif (first5 = "11100" and last2 = "01") then          -- ADDU
            TRegType  <= '0';
            RegWrEn <= '1';
            MemWr <= '0';
            MemRd <= '0';
            WBSrc <= '1';
            JumpType <= "111";
            ALUOp <= "0001";
            RegSrcA <= '0' & Inst(10 downto 8);
            RegSrcB <= '0' & Inst(7 downto 5);
            RegDst <= '0' & Inst(4 downto 2);
            ExRes <= "011";
            ALUSrc <= '0'; -- regB

        elsif (first5 = "11100" and last2 = "11") then          -- SUBU
            TRegType  <= '0';
            RegWrEn <= '1';
            MemWr <= '0';
            MemRd <= '0';
            WBSrc <= '1';
            JumpType <= "111";
            ALUOp <= "0010";
            RegSrcA <= '0' & Inst(10 downto 8);
            RegSrcB <= '0' & Inst(7 downto 5);
            RegDst <= '0' & Inst(4 downto 2);
            ExRes <= "011";
            ALUSrc <= '0'; -- regB

        elsif (first5 = "11101" and last5 = "01011") then       -- NEG
            TRegType  <= '0';
            RegWrEn <= '1';
            MemWr <= '0';
            MemRd <= '0';
            WBSrc <= '1';
            JumpType <= "111";
            ALUOp <= "0010";
            RegSrcA <= "1100"; -- zero
            RegSrcB <= '0' & Inst(7 downto 5);
            RegDst <= '0' & Inst(10 downto 8);
            ExRes <= "011";
            ALUSrc <= '0'; -- regB

        -- 逻辑

        elsif (first5 = "11101" and last5 = "01100") then       -- AND
            TRegType  <= '0';
            RegWrEn   <= '1';
            MemWr     <= '0';
            MemRd     <= '0';
            WBSrc     <= '1';
            JumpType  <= "111";
            ALUOp     <= "0011";
            RegSrcA   <= '0' & rx;
            RegSrcB   <= '0' & ry;
            RegDst    <= '0' & rx;
            ExRes     <= "011";
            ALUSrc    <= '0';
        elsif (first5 = "11101" and last5 = "01101") then       -- OR
            TRegType  <= '0';
            RegWrEn   <= '1';
            MemWr     <= '0';
            MemRd     <= '0';
            WBSrc     <= '1';
            JumpType  <= "111";
            ALUOp     <= "0100";
            RegSrcA   <= '0' & rx;
            RegSrcB   <= '0' & ry;
            RegDst    <= '0' & rx;
            ExRes     <= "011";
            ALUSrc    <= '0';

        -- 移位

        elsif (first5 = "00110" and last2 = "00") then          -- SLL
            TRegType  <= '0';
            RegWrEn   <= '1';
            MemWr     <= '0';
            MemRd     <= '0';
            WBSrc     <= '1';
            JumpType  <= "111";
            ALUOp     <= "0101";
            RegSrcA   <= '0' & ry;
            RegSrcB   <= (others => '1');
            RegDst    <= '0' & rx;
            ExRes     <= "011";
            ALUSrc    <= '1';
        elsif (first5 = "00110" and last2 = "11") then          -- SRA
            TRegType  <= '0';
            RegWrEn   <= '1';
            MemWr     <= '0';
            MemRd     <= '0';
            WBSrc     <= '1';
            JumpType  <= "111";
            ALUOp     <= "0111";
            RegSrcA   <= '0' & ry;
            RegSrcB   <= (others => '1');
            RegDst    <= '0' & rx;
            ExRes     <= "011";
            ALUSrc    <= '1';
        elsif (first5 = "00110" and last2 = "10") then          -- SRL
            TRegType  <= '0';
            RegWrEn   <= '1';
            MemWr     <= '0';
            MemRd     <= '0';
            WBSrc     <= '1';
            JumpType  <= "111";
            ALUOp     <= "0110";
            RegSrcA   <= '0' & ry;
            RegSrcB   <= (others => '1');
            RegDst    <= '0' & rx;
            ExRes     <= "011";
            ALUSrc    <= '1';

        -- 分支跳转

        elsif (first5 = "00010") then                           -- B
            TRegType  <= '0';
            RegWrEn <= '0';
            MemWr <= '0';
            MemRd <= '0';
            WBSrc <= '1';
            JumpType <= "000";
            ALUOp <= "0000";
            RegSrcA <= "1111";
            RegSrcB <= "1111";
            RegDst <= "1111"; -- No use
            ExRes     <= "011";
            ALUSrc    <= '1';

        elsif (first5 = "00100") then                           -- BEQZ
            TRegType  <= '0';
            RegWrEn <= '0';
            MemWr <= '0';
            MemRd <= '0';
            WBSrc <= '1';
            JumpType <= "001";
            ALUOp <= "0000";
            RegSrcA <= '0' & Inst(10 downto 8);
            RegSrcB <= "1111";
            RegDst <= "1111";
            ExRes     <= "011";
            ALUSrc    <= '1';

        elsif (first5 = "00101") then                           -- BNEZ
            TRegType  <= '0';
            RegWrEn <= '0';
            MemWr <= '0';
            MemRd <= '0';
            WBSrc <= '1';
            JumpType <= "010";
            ALUOp <= "0000";
            RegSrcA <= '0' & Inst(10 downto 8);
            RegSrcB <= "1111";
            RegDst <= "1111";
            ExRes     <= "011";
            ALUSrc    <= '1';

        elsif (first8 = "01100000") then                        -- BTEQZ
            TRegType  <= '0';
            RegWrEn <= '0';
            MemWr <= '0';
            MemRd <= '0';
            WBSrc <= '1';
            JumpType <= "011";
            ALUOp <= "0000";
            RegSrcA <= "1000"; -- T
            RegSrcB <= "1111";
            RegDst <= "1111";
            ExRes     <= "011";
            ALUSrc    <= '1';

        elsif (first5 = "11101" and last8 = "00000000") then    -- JR
            TRegType  <= '0';
            RegWrEn <= '0';
            MemWr <= '0';
            MemRd <= '0';
            WBSrc <= '1';
            JumpType <= "100";
            ALUOp <= "0000";
            RegSrcA <= '0' & Inst(10 downto 8);
            RegSrcB <= "1111";
            RegDst <= "1111";
            ExRes     <= "011";
            ALUSrc    <= '1';

        elsif (first5 = "11101" and last8 = "11000000") then    -- JALR
            TRegType  <= '0';
            RegWrEn <= '1';
            MemWr <= '0';
            MemRd <= '0';
            WBSrc <= '1';
            JumpType <= "101";
            ALUOp <= "0000";
            RegSrcA <= '0' & Inst(10 downto 8);
            RegSrcB <= "1111";
            RegDst <= "1011"; -- RA
            ExRes <= "010"; -- RPC
            ALUSrc    <= '1';

        elsif (Inst = "1110100000100000") then                  -- JRRA
            TRegType  <= '0';
            RegWrEn <= '0';
            MemWr <= '0';
            MemRd <= '0';
            WBSrc <= '1';
            JumpType <= "110";
            ALUOp <= "0000";
            RegSrcA <= "1011"; -- RA
            RegSrcB <= "1111";
            RegDst <= "1111";
            ExRes     <= "011";
            ALUSrc    <= '1';

        -- 比较

        elsif (first5 = "11101" and last5 = "01010") then       -- CMP
            TRegType  <= '0';
            RegWrEn   <= '1';
            MemWr     <= '0';
            MemRd     <= '0';
            WBSrc     <= '1';
            JumpType  <= "111";
            ALUOp     <= "0010";
            RegSrcA   <= '0' & rx;
            RegSrcB   <= '0' & ry;
            RegDst    <= "1000";
            ExRes     <= "000";
            ALUSrc    <= '0';

        elsif (first5 = "11101" and last5 = "00010") then       -- SLT
            TRegType  <= '1';
            RegWrEn   <= '1';
            MemWr     <= '0';
            MemRd     <= '0';
            WBSrc     <= '1';
            JumpType  <= "111";
            ALUOp     <= "0010";
            RegSrcA   <= '0' & rx;
            RegSrcB   <= '0' & ry;
            RegDst    <= "1000";
            ExRes     <= "000";
            ALUSrc    <= '0';

        -- 特殊寄存器取/赋�

        elsif (first5 = "11110" and last8 = "00000000") then    -- MFIH
            TRegType  <= '0';
            RegWrEn   <= '1';
            MemWr     <= '0';
            MemRd     <= '0';
            WBSrc     <= '1';
            JumpType  <= "111";
            ALUOp     <= "0000";
            RegSrcA   <= "1001";
            RegSrcB   <= (others => '1');
            RegDst    <= '0' & rx;
            ExRes     <= "100";
            ALUSrc    <= '1';

        elsif (first5 = "11101" and last8 = "01000000") then    -- MFPC
            TRegType  <= '0';
            RegWrEn   <= '1';
            MemWr     <= '0';
            MemRd     <= '0';
            WBSrc     <= '1';
            JumpType  <= "111";
            ALUOp     <= "0000";
            RegSrcA   <= (others => '1');
            RegSrcB   <= (others => '1');
            RegDst    <= '0' & rx;
            ExRes     <= "001";
            ALUSrc    <= '1';

        elsif (first5 = "11110" and last8 = "00000001") then    -- MTIH
            TRegType  <= '0';
            RegWrEn   <= '1';
            MemWr     <= '0';
            MemRd     <= '0';
            WBSrc     <= '1';
            JumpType  <= "111";
            ALUOp     <= "0000";
            RegSrcA   <= '0' & rx;
            RegSrcB   <= (others => '1');
            RegDst    <= "1001";
            ExRes     <= "100";
            ALUSrc    <= '1';

        elsif (first8 = "01100100" and last5 = "00000") then    -- MTSP
            TRegType  <= '0';
            RegWrEn   <= '1';
            MemWr     <= '0';
            MemRd     <= '0';
            WBSrc     <= '1';
            JumpType  <= "111";
            ALUOp     <= "0000";
            RegSrcA   <= '0' & ry;
            RegSrcB   <= (others => '1');
            RegDst    <= "1010";
            ExRes     <= "100";
            ALUSrc    <= '1';

        -- 访存

        elsif (first5 = "01101") then                           -- LI
            TRegType  <= '0';
            RegWrEn   <= '1';
            MemWr     <= '0';
            MemRd     <= '0';
            WBSrc     <= '1';
            JumpType  <= "111";
            ALUOp     <= "0000";
            RegSrcA   <= (others => '1');
            RegSrcB   <= (others => '1');
            RegDst    <= '0' & rx;
            ExRes     <= "101";
            ALUSrc    <= '1';

        elsif (first5 = "10011") then                           -- LW
            TRegType  <= '0';
            RegWrEn   <= '1';
            MemWr     <= '0';
            MemRd     <= '1';
            WBSrc     <= '0';
            JumpType  <= "111";
            ALUOp     <= "0001";
            RegSrcA   <= '0' & rx;
            RegSrcB   <= (others => '1');
            RegDst    <= '0' & ry;
            ExRes     <= "011";
            ALUSrc    <= '1';

        elsif (first5 = "10010") then                           -- LW_SP
            TRegType  <= '0';
            RegWrEn   <= '1';
            MemWr     <= '0';
            MemRd     <= '1';
            WBSrc     <= '0';
            JumpType  <= "111";
            ALUOp     <= "0001";
            RegSrcA   <= "1010";
            RegSrcB   <= (others => '1');
            RegDst    <= '0' & rx;
            ExRes     <= "011";
            ALUSrc    <= '1';

        elsif (first5 = "11011") then                           -- SW
            TRegType  <= '0';
            RegWrEn   <= '0';
            MemWr     <= '1';
            MemRd     <= '0';
            WBSrc     <= '1';
            JumpType  <= "111";
            ALUOp     <= "0001";
            RegSrcA   <= '0' & rx;
            RegSrcB   <= '0' & ry;
            RegDst    <= "1111";
            ExRes     <= "011";
            ALUSrc    <= '1';

        elsif (first8 = "01100010") then                        -- SW_RS
            TRegType  <= '0';
            RegWrEn   <= '0';
            MemWr     <= '1';
            MemRd     <= '0';
            WBSrc     <= '1';
            JumpType  <= "111";
            ALUOp     <= "0001";
            RegSrcA   <= "1010";
            RegSrcB   <= "1011";
            RegDst   <= "1111";
            ExRes     <= "011";
            ALUSrc    <= '1';

        elsif (first5 = "11010") then                           -- SW_SP
            TRegType  <= '0';
            RegWrEn   <= '0';
            MemWr     <= '1';
            MemRd     <= '0';
            WBSrc     <= '1';
            JumpType  <= "111";
            ALUOp     <= "0001";
            RegSrcA   <= "1010";
            RegSrcB   <= '0' & rx;
            RegDst    <= "1111";
            ExRes     <= "011";
            ALUSrc    <= '1';

        elsif (Inst = "0000100000000000") then                  -- NOP
            TRegType  <= '0';
            RegWrEn   <= '1';
            MemWr     <= '0';
            MemRd     <= '0';
            WBSrc     <= '1';
            JumpType  <= "111";
            ALUOp     <= "0101";
            RegSrcA   <= "1100";
            RegSrcB   <= (others => '1');
            RegDst    <= "1100";
            ExRes     <= "011";
            ALUSrc    <= '1';

        else                                    -- want it to be nop, but changed regdst to 1111(no use)
            TRegType  <= '0';
            RegWrEn   <= '1';
            MemWr     <= '0';
            MemRd     <= '0';
            WBSrc     <= '1';
            JumpType  <= "111";
            ALUOp     <= "0101";
            RegSrcA   <= "1100";
            RegSrcB   <= (others => '1');
            RegDst    <= "1111";
            ExRes     <= "011";
            ALUSrc    <= '1';
        end if;
    end process;

end Behavioral;
