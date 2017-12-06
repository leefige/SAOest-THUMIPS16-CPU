library	ieee;
use		ieee.std_logic_1164.all;
use		ieee.std_logic_unsigned.all;
use		ieee.std_logic_arith.all;
use 	ieee.numeric_std;

entity VGA_640480 is
	 port(
			rst :  in  STD_LOGIC;
			clk :  in std_logic; --25M clk
			VGA_Data :  in STD_LOGIC_VECTOR(8 downto 0);
			VGA_Addr :  out STD_LOGIC_VECTOR(12 downto 0);

            VGA_HS :  out STD_LOGIC; -- hsync
            VGA_VS :  out STD_LOGIC; -- vsync
			VGA_R,VGA_G,VGA_B :  out STD_LOGIC_vector(2 downto 0)
	  );
end VGA_640480;

architecture behavior of VGA_640480 is

	signal r1,g1,b1 : std_logic_vector(2 downto 0);
	signal hs1,vs1 : std_logic;

	signal vector_x : std_logic_vector(9 downto 0);		-- X position
	signal vector_y : std_logic_vector(8 downto 0);		-- Y position

    signal s_VGA_Data : STD_LOGIC_VECTOR(8 downto 0);

	signal unsignedA : unsigned(6 downto 0);
	signal unsignedB : unsigned(5 downto 0);
    signal result : unsigned(12 downto 0);
    signal const80 : std_logic_vector(6 downto 0);

begin

    s_VGA_Data <= VGA_Data;

    const80 <= "1010000";

    process(clk, rst)	-- set vector_x
    begin
        if rst='0' then
            vector_x <= (others=>'0');
        elsif (clk'event and clk='1') then
            if vector_x=799 then
                vector_x <= (others=>'0');
            else
                vector_x <= vector_x + 1;
            end if;
        end if;
    end process;

    process(clk, rst)	-- set vector_y
    begin
        if rst='0' then
            vector_y <= (others=>'0');
        elsif (clk'event and clk='1') then
            if vector_x=799 then
                if vector_y=524 then
                    vector_y <= (others=>'0');
                else
                    vector_y <= vector_y + 1;
                end if;
            end if;
        end if;
    end process;

  -----------------------------------------------------------------------
    process(clk, rst) -- gen h sync��ͬ�����96��ǰ��16��set hs1
    begin
        if rst='0' then
            hs1 <= '1';
        elsif (clk'event and clk='1') then
            if (vector_x>=656 and vector_x<752) then
                hs1 <= '0';
            else
                hs1 <= '1';
            end if;
        end if;
    end process;

    process(clk, rst) -- gen v sync��ͬ�����2��ǰ��10�� set vs1
    begin
        if rst='0' then
            vs1 <= '1';
        elsif (clk'event and clk='1') then
            if (vector_y>=490 and vector_y<492) then
                vs1 <= '0';
            else
                vs1 <= '1';
            end if;
        end if;
    end process;
 -----------------------------------------------------------------------

    process(clk, rst) -- output VGA_VS
    begin
        if rst='0' then
            VGA_VS <= '0';
        elsif (clk'event and clk='1') then
            VGA_VS <=  vs1;
        end if;
    end process;

    process(clk, rst) -- output VGA_HS
    begin
        if rst='0' then
            VGA_HS <= '0';
        elsif (clk'event and clk='1') then
            VGA_HS <=  hs1;
        end if;
    end process;

 -----------------------------------------------------------------------
    process (hs1, vs1, r1, g1, b1)	-- output R, G, B
	begin
		if (hs1 = '1' and vs1 = '1') then
			VGA_R	<= r1;
			VGA_G	<= g1;
			VGA_B	<= b1;
		else
			VGA_R	<= (others => '0');
			VGA_G	<= (others => '0');
			VGA_B	<= (others => '0');
		end if;
	end process;

    ------------------------------------------------

    unsignedA <= unsigned(vector_x(9 downto 3));
 	unsignedB <= unsigned(vector_y(8 downto 3));
 	result <= unsignedB * unsigned(const80) + unsignedA;

    VGA_Addr <= std_logic_vector(result);

 -----------------------------------------------------------------------
	process(rst, clk, vector_x, vector_y) -- ctrl x, y, output VGA_Addr
	begin
		if rst='0' then
            r1 <= "000";
			g1 <= "000";
			b1 <= "000";
        elsif (clk'event and clk = '1') then
            if vector_x > 639 or vector_y > 479 then
					r1  <= "000";
					g1	<= "000";
					b1	<= "000";
            else
                -- posx <= conv_integer(vector_x(9 downto 3));     -- 80: 1010000, srl by 3: 1010
                -- posy <= conv_integer(vector_y(8 downto 3));
                r1 <= s_VGA_Data(8 downto 6);
                g1 <= s_VGA_Data(5 downto 3);
                b1 <= s_VGA_Data(2 downto 0);
            end if;
        end if;
	end process;

end behavior;

