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

        ALUFlag  : out std_logic_vector (3 downto 0);
        ALURes   : out std_logic_vector (15 downto 0);
    );
end ALU;

architecture Behavioral of ALU is

    signal outputRes : std_logic_vector (16 downto 0);

begin

    ALURes <= outputRes;

    process(ALUOp, InputA, InputB)
        variable tmpInputA : std_logic_vector (16 downto 0);
        variable tmpInputB : std_logic_vector (16 downto 0);
        variable result : std_logic_vector (16 downto 0);
    begin
        tmpInputA := InputA(15) & InputA;
        tmpInputB := InputB(15) & InputB;
        case ALUOp is
            when "0000" =>  -- Z
                result := (others => 'Z');
            when "0001" =>  -- ADD
                result := tmpInputA + tmpInputB;
            when "0010" =>  -- SUB
                result := tmpInputA - tmpInputB;
            when "0011" =>  -- AND
                result := tmpInputA and tmpInputB;
            when "0100" =>  -- OR
                result := tmpInputA or tmpInputB;
            when "0101" =>  -- SLL
                result := to_stdlogicvector(to_bitvector(tmpInputA) sll conv_integer(InputB));
            when "0110" =>  -- SRL
                result := '0' & to_stdlogicvector(to_bitvector(InputA) srl conv_integer(InputB));
            when "0111" =>  -- SRA
                result := to_stdlogicvector(to_bitvector(tmpInputA) sra conv_integer(InputB));
            when others =>
                result := (others => '0');
        end case;
        outputRes <= result;
        ALURes <= result(15 downto 0);
    end process;

    process(outputRes, ALUOp)
        variable output : std_logic_vector (15 downto 0);
    begin
        output := outputRes(15 downto 0);
        if (output = "0000000000000000") then
            ALUFlag(0) <= '1';
        else
            ALUFlag(0) <= '0';
        end if;
        ALUFlag(1) <= outputRes(15);

        case ALUOp is
            when "0001" =>  -- ADD
                ALUFlag(3) <=
                    ((not InputA(15)) and (not InputB(15)) and outputRes(15)) or  -- a > 0, b > 0, a + b < 0
                    (InputA(15) and InputB(15) and (not outputRes(15)));          -- a < 0, b < 0, a + b >= 0
                if (conv_integer(output) < conv_integer(InputA)) then
                    ALUFlag(2) <= '1';
                else
                    ALUFlag(2) <= '0';
                end if;
            when "0010" =>  -- SUB
                ALUFlag(3) <=
                    ((not InputA(15)) and InputB(15) and outputRes(15)) or        -- a > 0, b < 0, a - b < 0
                    (InputA(15) and (not InputB(15)) and (not outputRes(15)));    -- a < 0, b > 0, a - b >= 0
                ALUFlag(2) <= outputRes(16);
            when others =>
                ALUFlag(2) <= '0';
                ALUFlag(3) <= '0';
        end case;
    end process;
end Behavioral;
