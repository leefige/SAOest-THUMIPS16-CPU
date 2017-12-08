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

    signal result : std_logic_vector (15 downto 0);

    signal sll_buf : std_logic_vector (15 downto 0);
    signal sra_buf : std_logic_vector (15 downto 0);
    signal sra_res : std_logic_vector (15 downto 0);
    signal srl_buf : std_logic_vector (15 downto 0);


begin


    with InputB(2 downto 0) select
        sll_buf <=  InputA(14 downto 0) & '0' when "001",
                    InputA(13 downto 0) & "00" when "010",
                    InputA(12 downto 0) & "000" when "011",
                    InputA(11 downto 0) & "0000" when "100",
                    InputA(10 downto 0) & "00000" when "101",
                    InputA(9 downto 0) & "000000" when "110",
                    InputA(8 downto 0) & "0000000" when "111",
                    InputA(7 downto 0) & "00000000" when "000",
                    InputA when others;

    with InputB(2 downto 0) select
        srl_buf <=  '0' & InputA(15 downto 1) when "001",
                    "00" & InputA(15 downto 2) when "010",
                    "000" & InputA(15 downto 3) when "011",
                    "0000" & InputA(15 downto 4) when "100",
                    "00000" & InputA(15 downto 5) when "101",
                    "000000" & InputA(15 downto 6) when "110",
                    "0000000" & InputA(15 downto 7) when "111",
                    "00000000" & InputA(15 downto 8) when "000",
                    InputA when others;

    with InputB(2 downto 0) select
        sra_buf <=  '1' & InputA(15 downto 1) when "001",
                    "11" & InputA(15 downto 2) when "010",
                    "111" & InputA(15 downto 3) when "011",
                    "1111" & InputA(15 downto 4) when "100",
                    "11111" & InputA(15 downto 5) when "101",
                    "111111" & InputA(15 downto 6) when "110",
                    "1111111" & InputA(15 downto 7) when "111",
                    "11111111" & InputA(15 downto 8) when "000",
                    InputA when others;

    with InputA(15) select
        sra_res <=  srl_buf when '0',
                    sra_buf when others;

    with ALUOp select
        result <=   (others => 'Z') when "0000",
                    InputA + InputB when "0001",
                    InputA - InputB when "0010",
                    InputA and InputB when "0011",
                    InputA or InputB when "0100",
                    sll_buf when "0101",
                    srl_buf when "0110",
                    sra_res when "0111",
                    (others => '0') when others;

    ALURes <= result;

    ALUFlag(0) <= '1' when result = (15 downto 0 => '0')
                      else '0';

    ALUFlag(1) <= result(15);

end Behavioral;
