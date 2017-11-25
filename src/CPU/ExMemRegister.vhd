library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity ExMemRegister is
    --EX/MEM阶段寄存�
    port(
        clk : in std_logic;
        rst : in std_logic;
        WE  : in std_logic;
        Clear : in std_logic;

        --数据输入
        RegDst_i : in std_logic_vector(3 downto 0);
        ExData_i : in std_logic_vector(15 downto 0);
        RegDataB_i : in std_logic_vector(15 downto 0); --供SW语句写内�
        --信号输入
        RegWrEn_i : in std_logic;
        MemWr_i : in std_logic;
        MemRd_i : in std_logic;
        WBSrc_i : in std_logic;

        --数据输出
        RegDst_o : out std_logic_vector(3 downto 0);
        ExData_o : out std_logic_vector(15 downto 0);
        RegDataB_o : out std_logic_vector(15 downto 0); --供SW语句写内�
        --信号输出
        RegWrEn_o : out std_logic;
        MemWr_o : out std_logic;
        MemRd_o : out std_logic;
        WBSrc_o : out std_logic
    );
end ExMemRegister;

architecture Behavioral of ExMemRegister is

begin
    process(rst, clk)
    begin
        if (rst = '0') then
            RegDst_o <= "0000";
            ExData_o <= (others => '0');
            RegDataB_o <= (others => '0');

            RegWrEn_o <= '0';
            MemWr_o <= '0';
            MemRd_o <= '0';
            WBSrc_o <= '0';

        elsif (clk'event and clk = '1') then
            if(Clear = '1') then
                RegDst_o <= "0000";
                ExData_o <= (others => '0');
                RegDataB_o <= (others => '0');

                RegWrEn_o <= '0';
                MemWr_o <= '0';
                MemRd_o <= '0';
                WBSrc_o <= '0';
            elsif(WE = '1') then
                RegDst_o <= RegDst_i;
                ExData_o <= ExData_i;
                RegDataB_o <= RegDataB_i;

                RegWrEn_o <= RegWrEn_i;
                MemWr_o <= MemWr_i;
                MemRd_o <= MemRd_i;
                WBSrc_o <= WBSrc_i;
            end if;
        end if;
    end process;
end Behavioral;

