library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
--	In-Datapath-Out: 
--      Switches for ALU input and Cin + CLK for 7seg selection =>
--      Clock divider => 
--      4-bit ALU =>
--      Anode decoder =>
--      7seg Cathode Mux => 
--      7seg decoder =>
--      7seg anode + cathode output

entity main is
    Port (	
		CLK100MHZ: in std_logic;
		SW: in std_logic_vector(10 downto 0); -- 7-0=> ALU inputs, 8=> Cin, 10-9=> Op
		ANODES : out std_logic_vector(7 downto 0); -- 7 seg ANODES
		SEG_CATHODES : out std_logic_vector(7 downto 0) -- 7 seg Cathodes
	);
end main;

architecture Structural of main is

	--Component Declarations:

    -- 4-bit ALU
    component four_bit_alu
        generic(
            data_width : integer := 4
        );
        Port ( 
            A, B   : in  std_logic_vector(3 downto 0);
			Op     : in  std_logic_vector(2 downto 0);
            Carry  : out std_logic;
            Res : out std_logic_vector(3 downto 0)
        );
    end component;

    -- Seven segment display logic
    component sevseg_disp
        Port (
            I_0, I_1, I_2, I_3, I_4, I_5, I_6, I_7 : in std_logic_vector(3 downto 0);
            DOT : in std_logic;
            AN_SEL : in std_logic_vector(2 downto 0); -- numbered anode select (Selected via clock)
            AN : out std_logic_vector(7 downto 0); -- per bit which anode to turn on/off
            SEG : out STD_LOGIC_VECTOR (7 downto 0) -- 7-1 bits are cathodes, 0 bit is dot. 0 on, 1 off
        );
    end component;

    -- Signals
    signal clkdiv : std_logic_vector(10 downto 0); -- CLOCK 
    signal an_sel : std_logic_vector (2 downto 0); --signal from clock division for anode and cathode selection
	-- Signals for 4-bit ALU
    signal sw_to_a, sw_to_b, res : std_logic_vector(3 downto 0);
	signal sw_to_s : std_logic_vector(1 downto 0);
	signal sw_to_cin : std_logic;
	signal sw_to_op : std_logic_vector(2 downto 0);
    signal carry: std_logic;
begin
	clock_divider: process (CLK100MHz)		-- create system clock divder
	begin
		if (rising_edge(CLK100MHz)) then
			clkdiv <= clkdiv+1;
		end if;
	end process clock_divider;
	
	digit_select: process (clkdiv(10))
	begin
		if (rising_edge(clkdiv(10))) then
			case an_sel is				--used to rotate 7 seg digits
		 		when "000" => an_sel <= "001";
				when "001" => an_sel <= "010";
				when "010" => an_sel <= "011";
				when "011" => an_sel <= "100";
				when "100" => an_sel <= "101";
				when "101" => an_sel <= "110";
				when "110" => an_sel <= "111";
				when "111" => an_sel <= "000";
			end case;
		end if;
	end process digit_select;

	sw_to_a <= SW(7 downto 4);
	sw_to_b <= SW(3 downto 0);
	sw_to_cin <= SW(8);
	sw_to_s <= SW(10 downto 9);
	sw_to_op <= SW(10 downto 8);
	
	alu: four_bit_alu
	    generic map(
            data_width => 4
        )
	    port map(
            A => sw_to_a,
            B => sw_to_b,
            Op => sw_to_op,
            Carry => carry,
            Res => res
        );

	seven_seg: sevseg_disp
	    port map(
			I_0 => res,
			I_1 => "0000",
			I_2 => "0000",
			I_3 => "0000",
			I_4 => sw_to_b,
			I_5 => sw_to_a,
			I_6 => "000" & sw_to_cin,
			I_7 => "00" & sw_to_s,
			DOT => carry,
			AN_SEL => an_sel,
			AN => ANODES,
			SEG => SEG_CATHODES
		);	

end Structural;
