----------------------------------------------------------------------------------
-- Company:
-- Engineer:
--
-- Create Date:    19:06:57 11/22/2017
-- Design Name:
-- Module Name:    ALU - Behavioral
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

entity ALU is
    port(
        InputA   : in std_logic_vector (15 downto 0);
        InputB   : in std_logic_vector (15 downto 0);
        ALUOp    : in std_logic_vector (3 downto 0);

        ALUFlag  : out std_logic_vector (1 downto 0);
        ALURes   : out std_logic_vector (15 downto 0)
    );
end ALU;

architecture Behavioral of ALU is

    signal tmpInputA : std_logic_vector (16 downto 0);
    signal tmpInputB : std_logic_vector (16 downto 0);
    signal result : std_logic_vector (16 downto 0);

    signal sll_buf : std_logic_vector (16 downto 0);
    signal sra_buf : std_logic_vector (16 downto 0);
    signal sra_res : std_logic_vector (16 downto 0);
    signal srl_buf : std_logic_vector (16 downto 0);


begin

    tmpInputA <= InputA(15) & InputA;
    tmpInputB <= InputB(15) & InputB;

    with InputB(2 downto 0) select
        sll_buf <=  tmpInputA(15 downto 0) & '0' when "001",
                    tmpInputA(14 downto 0) & "00" when "010",
                    tmpInputA(13 downto 0) & "000" when "011",
                    tmpInputA(12 downto 0) & "0000" when "100",
                    tmpInputA(11 downto 0) & "00000" when "101",
                    tmpInputA(10 downto 0) & "000000" when "110",
                    tmpInputA(9 downto 0) & "0000000" when "111",
                    tmpInputA(8 downto 0) & "00000000" when "000",
                    tmpInputA when others;

    with InputB(2 downto 0) select
        srl_buf <=  '0' & tmpInputA(16 downto 1) when "001",
                    "00" & tmpInputA(16 downto 2) when "010",
                    "000" & tmpInputA(16 downto 3) when "011",
                    "0000" & tmpInputA(16 downto 4) when "100",
                    "00000" & tmpInputA(16 downto 5) when "101",
                    "000000" & tmpInputA(16 downto 6) when "110",
                    "0000000" & tmpInputA(16 downto 7) when "111",
                    "00000000" & tmpInputA(16 downto 8) when "000",
                    tmpInputA when others;

    with InputB(2 downto 0) select
        sra_buf <=  '1' & tmpInputA(16 downto 1) when "001",
                    "11" & tmpInputA(16 downto 2) when "010",
                    "111" & tmpInputA(16 downto 3) when "011",
                    "1111" & tmpInputA(16 downto 4) when "100",
                    "11111" & tmpInputA(16 downto 5) when "101",
                    "111111" & tmpInputA(16 downto 6) when "110",
                    "1111111" & tmpInputA(16 downto 7) when "111",
                    "11111111" & tmpInputA(16 downto 8) when "000",
                    tmpInputA when others;

    with InputA(15) select
        sra_res <=  srl_buf when '0',
                    sra_buf when others;

    with ALUOp select
        result <=   (others => 'Z') when "0000",
                    tmpInputA + tmpInputB when "0001",
                    tmpInputA - tmpInputB when "0010",
                    tmpInputA and tmpInputB when "0011",
                    tmpInputA or tmpInputB when "0100",
                    sll_buf when "0101",
                    srl_buf when "0110",
                    sra_res when "0111",
                    (others => '0') when others;

    ALURes <= result(15 downto 0);

    ALUFlag(0) <= '1' when result = (16 downto 0 => '0')
                      else '0';

    ALUFlag(1) <= result(16);

end Behavioral;
