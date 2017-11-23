----------------------------------------------------------------------------------
-- Company:
-- Engineer:
--
-- Create Date:    16:35:38 11/19/2017
-- Design Name:
-- Module Name:    Mux3 - Behavioral
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

entity Mux3 is
    port(
        selector : in std_logic_vector (1 downto 0);

        inputA   : in std_logic_vector (15 downto 0);
        inputB   : in std_logic_vector (15 downto 0);
        inputC   : in std_logic_vector (15 downto 0);

        output   : out std_logic_vector (15 downto 0)
    );
end Mux3;

architecture Behavioral of Mux3 is

begin

    with selector select
        output <=
            inputA when "00",
            inputB when "01",
            inputC when "10",
            (others => '0') when others;

end Behavioral;
