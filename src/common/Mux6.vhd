----------------------------------------------------------------------------------
-- Company:
-- Engineer:
--
-- Create Date:    22:03:22 11/22/2017
-- Design Name:
-- Module Name:    Mux6 - Behavioral
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

entity Mux6 is
    port(
        selector : in std_logic_vector (2 downto 0);

        inputA   : in std_logic_vector (15 downto 0);
        inputB   : in std_logic_vector (15 downto 0);
        inputC   : in std_logic_vector (15 downto 0);
        inputD   : in std_logic_vector (15 downto 0);
        inputE   : in std_logic_vector (15 downto 0);
        inputF   : in std_logic_vector (15 downto 0);

        res   : out std_logic_vector (15 downto 0)
    );
end Mux6;

architecture Behavioral of Mux6 is

begin

    with selector select
        res <=
            inputA when "000",
            inputB when "001",
            inputC when "010",
            inputD when "011",
            inputD when "100",
            inputD when "101",
            (others => '0') when others;

end Behavioral;
