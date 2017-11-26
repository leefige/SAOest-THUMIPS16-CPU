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

begin

    tmpInputA <= InputA(15) & InputA;
    tmpInputB <= InputB(15) & InputB;

    result <= (others => 'Z') when ALUOp = "0000"
        else tmpInputA + tmpInputB when ALUOp = "0001"
        else tmpInputA - tmpInputB when ALUOp = "0010"
        else tmpInputA and tmpInputB when ALUOp = "0011"
        else tmpInputA or tmpInputB when ALUOp = "0100"
        else to_stdlogicvector(to_bitvector(tmpInputA) sll conv_integer(InputB)) when ALUOp = "0101"
        else '0' & to_stdlogicvector(to_bitvector(InputA) srl conv_integer(InputB)) when ALUOp = "0110"
        else to_stdlogicvector(to_bitvector(tmpInputA) sra conv_integer(InputB)) when ALUOp = "0111"
        else (others => '0');

    ALURes <= result(15 downto 0);

    -- if (result = "00000000000000000") then
    --     ALUFlag(0) <= '1';
    -- else
    --     ALUFlag(0) <= '0';
    -- end if;

    ALUFlag(0) <= '1' when result = (16 downto 0 => '0')
                      else '0';
    ALUFlag(1) <= result(16);

end Behavioral;
