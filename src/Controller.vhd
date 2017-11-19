----------------------------------------------------------------------------------
-- Company:
-- Engineer:
--
-- Create Date:    10:23:43 11/18/2017
-- Design Name:
-- Module Name:    Controller - Behavioral
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

entity Controller is
    port(
        Inst     : in std_logic_vector (15 downto 0);

        TRegWr   : out std_logic;
        RegWrEn  : out std_logic;
        MemWr    : out std_logic;
        MemRd    : out std_logic;
        WBSrc    : out std_logic_vector (1 downto 0);
        JumpType : out std_logic_vector (2 downto 0);
        MemSrc   : out std_logic;
        ALUop    : out std_logic_vector (3 downto 0);
        RegSrcA  : out std_logic_vector (3 downto 0);
        RegSrcB  : out std_logic_vector (3 downto 0);
        RegDst   : out std_logic_vector (3 downto 0);
        ExRes    : out std_logic_vector (1 downto 0);
        ALUSrc   : out std_logic
    );
end Controller;

architecture Behavioral of Controller is


begin

end Behavioral;
