library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity IfIdRegister is
    --EX/MEM阶段寄存�
    port(
        clk : in std_logic;
        rst : in std_logic;
        WE  : in std_logic;
        Clear : in std_logic;

        --数据输入
        NPC_i : in std_logic_vector(15 downto 0);
        RPC_i : in std_logic_vector(15 downto 0);
        --信号输入
        Inst_i : in std_logic_vector(15 downto 0);

        --数据输出
        NPC_o : out std_logic_vector(15 downto 0);
        RPC_o : out std_logic_vector(15 downto 0);
        --信号输出
        Inst_o : out std_logic_vector(15 downto 0)
    );
end IfIdRegister;

architecture Behavioral of IfIdRegister is

begin
    process(rst, clk)
    begin
        if (rst = '0') then
            NPC_o <= (others => '0');
            RPC_o <= (others => '0');
            Inst_o <= (others => '0');

        elsif (clk'event and clk = '1') then
            if(Clear = '1') then
                NPC_o <= (others => '0');
                RPC_o <= (others => '0');
                Inst_o <= (others => '0');
            elsif(WE = '1') then
                NPC_o <= NPC_i;
                RPC_o <= RPC_i;
                Inst_o <= Inst_i;
            end if;
        end if;
    end process;
end Behavioral;

