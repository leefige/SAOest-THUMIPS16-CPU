library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity IdExRegister is
    --ID/EX阶段寄存�
    port(
        clk : in std_logic;
        rst : in std_logic;
        WE  : in std_logic;
        Clear : in std_logic;

        --数据输入

        RegSrcA_i : in std_logic_vector(3 downto 0);
        RegSrcB_i : in std_logic_vector(3 downto 0);
        RegDst_i : in std_logic_vector(3 downto 0);
        ExRes_i : in std_logic_vector(2 downto 0);
        NPC_i : in std_logic_vector(15 downto 0);
        RPC_i : in std_logic_vector(15 downto 0);
        --信号输入

        TRegType_i : in std_logic;
        RegWrEn_i : in std_logic;
        MemWr_i : in std_logic;
        MemRd_i : in std_logic;
        WBSrc_i : in std_logic;
        JumpType_i : in std_logic_vector(2 downto 0);
        ALUOp_i : in std_logic_vector(3 downto 0);
        ALUSrc_i : in std_logic;
        RegDataA_i : in std_logic_vector(15 downto 0);
        RegDataB_i : in std_logic_vector(15 downto 0);
        Imme_i : in std_logic_vector(15 downto 0);

        --数据输出
        RegSrcA_o : out std_logic_vector(3 downto 0);
        RegSrcB_o : out std_logic_vector(3 downto 0);
        RegDst_o : out std_logic_vector(3 downto 0);
        ExRes_o : out std_logic_vector(2 downto 0);
        NPC_o : out std_logic_vector(15 downto 0);
        RPC_o : out std_logic_vector(15 downto 0);
        --信号输出
        TRegType_o : out std_logic;
        RegWrEn_o : out std_logic;
        MemWr_o : out std_logic;
        MemRd_o : out std_logic;
        WBSrc_o : out std_logic;
        JumpType_o : out std_logic_vector(2 downto 0);
        ALUOp_o : out std_logic_vector(3 downto 0);
        ALUSrc_o : out std_logic;
        RegDataA_o : out std_logic_vector(15 downto 0);
        RegDataB_o : out std_logic_vector(15 downto 0);
        Imme_o : out std_logic_vector(15 downto 0)
    );
end IdExRegister;

architecture Behavioral of IdExRegister is

begin
    process(rst, clk)
    begin
        if (rst = '0') then
            RegSrcA_o <= "1100";
            RegSrcB_o <= "1111";
            RegDst_o <= "1100";
            ExRes_o <= "11";
            NPC_o <= "0000000000000001";
            RPC_o <= "0000000000000010";

            TRegType_o <= '0';
            RegWrEn_o <= '1';
            MemWr_o <= '0';
            MemRd_o <= '0';
            WBSrc_o <= '1';
            JumpType_o <= "111";
            ALUOp_o <= "0101";
            ALUSrc_o <= '1';
            RegDataA_o <= (others => '0');
            RegDataB_o <= (others => '0');
            Imme_o <= (others => '0');


        elsif (clk'event and clk = '1') then
            if(Clear = '1') then
                RegSrcA_o <= "1100";
                RegSrcB_o <= "1111";
                RegDst_o <= "1100";
                ExRes_o <= "11";
                NPC_o <= "0000000000000001";
                RPC_o <= "0000000000000010";

                TRegType_o <= '0';
                RegWrEn_o <= '1';
                MemWr_o <= '0';
                MemRd_o <= '0';
                WBSrc_o <= '1';
                JumpType_o <= "111";
                ALUOp_o <= "0101";
                ALUSrc_o <= '1';
                RegDataA_o <= (others => '0');
                RegDataB_o <= (others => '0');
                Imme_o <= (others => '0');

            elsif(WE = '1') then
                RegSrcA_o <= RegSrcA_i;
                RegSrcB_o <= RegSrcB_i;
                RegDst_o <= RegDst_i;
                ExRes_o <= ExRes_i;
                NPC_o <= NPC_i;
                RPC_o <= RPC_i;

                TRegType_o <= TRegType_i;
                RegWrEn_o <= RegWrEn_i;
                MemWr_o <= MemWr_i;
                MemRd_o <= MemRd_i;
                WBSrc_o <= WBSrc_i;
                JumpType_o <= JumpType_i;
                ALUOp_o <= ALUOp_i;
                ALUSrc_o <= ALUSrc_i;
                RegDataA_o <= RegDataA_i ;
                RegDataB_o <= RegDataB_i;
                Imme_o <= Imme_i;
            end if;
        end if;
    end process;
end Behavioral;

