
-- VHDL Instantiation Created from source file ClockGen.vhd -- 04:46:42 12/08/2017
--
-- Notes: 
-- 1) This instantiation template has been automatically generated using types
-- std_logic and std_logic_vector for the ports of the instantiated module
-- 2) To use this template to instantiate this entity, cut-and-paste and then edit

	COMPONENT ClockGen
	PORT(
		CLKIN_IN : IN std_logic;
		RST_IN : IN std_logic;          
		CLKFX_OUT : OUT std_logic;
		CLKIN_IBUFG_OUT : OUT std_logic;
		CLK0_OUT : OUT std_logic;
		CLK2X_OUT : OUT std_logic
		);
	END COMPONENT;

	Inst_ClockGen: ClockGen PORT MAP(
		CLKIN_IN => ,
		RST_IN => ,
		CLKFX_OUT => ,
		CLKIN_IBUFG_OUT => ,
		CLK0_OUT => ,
		CLK2X_OUT => 
	);


