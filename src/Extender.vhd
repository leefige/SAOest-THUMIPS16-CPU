----------------------------------------------------------------------------------
-- Company:
-- Engineer:
--
-- Create Date:    21:44:54 11/17/2017
-- Design Name:
-- Module Name:    Extender - Behavioral
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Extender is
    Port (
        InstIn  : in  std_logic_vector (15 downto 0);
        ImmeOut : out std_logic_vector (15 downto 0)
    );
end Extender;

architecture Behavioral of Extender is

    signal first5   : std_logic_vector(4 downto 0);
    signal first8   : std_logic_vector(7 downto 0);

    signal from7to0 : std_logic_vector(7 downto 0);
    signal from10to0: std_logic_vector(10 downto 0);
    signal from3to0 : std_logic_vector(3 downto 0);
    signal from4to0 : std_logic_vector(4 downto 0);
    signal from4to2 : std_logic_vector(2 downto 0);

begin

    first5    <= InstIn(15 downto 11);
    first8    <= InstIn(15 downto  8);

    from7to0  <= InstIn(7  downto  0);
    from10to0 <= InstIn(10 downto  0);
    from3to0  <= InstIn(3  downto  0);
    from4to0  <= InstIn(4  downto  0);
    from4to2  <= InstIn(4  downto  2);

    ImmeOut <=
        SXT(from7to0, ImmeOut'length) when first5 = "01001"     -- ADDIU
                                        or first5 = "00101"     -- BEQZ
                                        or first5 = "00101"     -- BNEZ
                                        or first5 = "11010"     -- SW_SP
                                      else
        SXT(from3to0, ImmeOut'length) when first5 = "01000"     -- ADDIU3
                                      else
        SXT(from4to0, ImmeOut'length) when first5 = "10011"     -- LW
                                        or first5 = "11011"     -- SW
                                      else
        SXT(from7to0, ImmeOut'length) when first5 = "10010"     -- LW_SP
                                      else
        SXT(from7to0, ImmeOut'length) when first8 = "01100011"  -- ADDSP
                                        or first8 = "01100000"  -- BTEQZ
                                      else
        SXT(from10to0, ImmeOut'length) when first5 = "00010"    -- B
                                      else
        EXT(from4to2, ImmeOut'length) when first5 = "00110"     -- SLL + SRA + SRL
                                      else
        EXT(from7to0, ImmeOut'length) when first5 = "01101"     -- LI
                                      else
        (others => 'Z');

end Behavioral;
