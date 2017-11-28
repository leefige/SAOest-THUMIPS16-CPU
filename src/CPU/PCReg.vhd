----------------------------------------------------------------------------------
-- Company:
-- Engineer:
--
-- Create Date:    14:23:12 11/19/2017
-- Design Name:
-- Module Name:    PCReg - Behavioral
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

entity PCReg is
    port(
        clk   : in std_logic;
        rst   : in std_logic;

        clear : in std_logic;
        WE    : in std_logic;
        PC_i  : in std_logic_vector (15 downto 0);

        PC_o  : out std_logic_vector (15 downto 0)
    );
end PCReg;

architecture Behavioral of PCReg is

    signal pc : std_logic_vector (15 downto 0);

begin

    PC_o <= pc;

    process(clk, rst)
    begin
        if (rst = '0') then
            pc <= "0000000000000000";
        elsif (clk'event and clk = '1') then
            if (clear = '1') then
                pc <= "0000000000000000";
            elsif (WE = '1') then
                pc <= PC_i;
            end if;
        end if;
    end process;

end Behavioral;
