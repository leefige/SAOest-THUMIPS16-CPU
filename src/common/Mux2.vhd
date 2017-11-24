----------------------------------------------------------------------------------
-- Company:
-- Engineer:
--
-- Create Date:    16:43:49 11/19/2017
-- Design Name:
-- Module Name:    Mux2 - Behavioral
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

entity Mux2 is
    port(
        selector : in std_logic;

        inputA   : in std_logic_vector (15 downto 0);
        inputB   : in std_logic_vector (15 downto 0);

        res   : out std_logic_vector (15 downto 0)
    );
end Mux2;

architecture Behavioral of Mux2 is

begin

    with selector select
        res <=
            inputA when '0',
            inputB when '1',
            (others => '0') when others;

end Behavioral;
