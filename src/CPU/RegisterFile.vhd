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
        clk : in std_logic;
        rst : in std_logic;
        RegWrEn : in std_logic;
        RegSrcA  : in std_logic_vector(3 downto 0);
        RegSrcB  : in std_logic_vector(3 downto 0);
        RegDst   : in std_logic_vector(3 downto 0);
        RegWrData  : in std_logic_vector(15 downto 0);

        RegDataA : out std_logic_vector(15 downto 0);
        RegDataB : out std_logic_vector(15 downto 0);
        r0 : out std_logic_vector(15 downto 0);
        r1 : out std_logic_vector(15 downto 0);
        r2 : out std_logic_vector(15 downto 0);
        r3 : out std_logic_vector(15 downto 0);
        r4 : out std_logic_vector(15 downto 0);
        r5 : out std_logic_vector(15 downto 0);
        r6 : out std_logic_vector(15 downto 0);
        r7 : out std_logic_vector(15 downto 0);
        RA : out std_logic_vector(15 downto 0);
        Tdata : out std_logic_vector(15 downto 0);
        SPdata : out std_logic_vector(15 downto 0);
        IHdata : out std_logic_vector(15 downto 0)
    );
end RegisterFile;

architecture Behavioral of RegisterFile is

    type RegFile is array(0 to 15) of std_logic_vector(15 downto 0);
    signal regs : RegFile;

begin
    -- Consider read and write at the same time
    -- if (RegDst = RegSrcA) then
    --     RegDataA <= RegWrData;
    -- else
    --     RegDataA <= regs[RegSrcA];
    -- end if;

    -- if (RegDst = RegSrcB) then
    --     RegDataB <= RegWrData;
    -- else
    --     RegDataB <= regs[RegSrcB];
    -- end if;

    -- Faster way, but may cause some conflict if controller's delay is not enough
    RegDataA <= regs(to_integer(unsigned(RegSrcA))) when RegSrcA /= RegDst
                else RegWrData;
    RegDataB <= regs(to_integer(unsigned(RegSrcB))) WHEN RegSrcB /= RegDst
                else RegWrData;

    r0 <= regs(0);
    r1 <= regs(1);
    r2 <= regs(2);
    r3 <= regs(3);
    r4 <= regs(4);
    r5 <= regs(5);
    r6 <= regs(6);
    r7 <= regs(7);
    RA <= regs(11);
    Tdata <= regs(8);
    SPdata <= regs(10);
    IHdata <= regs(9);


    process(clk, rst)
    begin
        if (rst = '0') then
            regs <= (others => (others => '0'));
        elsif (clk'event and clk = '1') then
            if (RegWrEn = '1') then
                regs(to_integer(unsigned(RegDst))) <= RegWrData;
            end if;
        end if;
    end process;

end Behavioral;
