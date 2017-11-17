----------------------------------------------------------------------------------
-- Company:
-- Engineer:
--
-- Create Date:    21:45:27 11/17/2017
-- Design Name:
-- Module Name:    RegisterFile - Behavioral
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
use IEEE.numeric_std.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity RegisterFile is
    port(
        RegWrEn : in std_logic;
        RdRegA : in std_logic_vector(3 downto 0);
        RdRegB : in std_logic_vector(3 downto 0);
        WrReg : in std_logic_vector(3 downto 0);
        WrData : in std_logic_vector(15 downto 0);

        RegDataA : out std_logic_vector(15 downto 0);
        RegDataB : out std_logic_vector(15 downto 0)
    );
end RegisterFile;

architecture Behavioral of RegisterFile is

    type RegFile is array(0 to 15) of std_logic_vector(15 downto 0);
    signal regs : RegFile;

begin

    process(clk, rst)
    begin
        if (rst = '1') then
            reg <= (others => (others => '0'));
        end if;
    end process;

end Behavioral;
