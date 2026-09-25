library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
--	In-Datapath-Out: 

entity main_control is
	generic(
		NUM_PU : integer := 2 -- How many ALUs
	);
    Port (	
		CLK100MHZ: in std_logic;
		SW: in std_logic_vector(3 downto 0); -- 3-2 => Op, 1 => Cin, 0 => Perform Op
		ANODES : out std_logic_vector(7 downto 0); -- 7 seg ANODES
		SEG_CATHODES : out std_logic_vector(7 downto 0) -- 7 seg Cathodes
	);
end main_control;

architecture Structural of main_control is

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

	type   mem_t is array(0 to 127) of std_logic_vector(31 downto 0);
	signal mem :mem_t;

    -- Signals
    signal clkdiv : std_logic_vector(10 downto 0); -- CLOCK 
    signal an_sel : std_logic_vector (2 downto 0); --signal from clock division for anode and cathode selection
	-- Signals for 4-bit ALU
    signal res, in_a, in_b : array(NUM_PU - 1 downto 0) of std_logic_vector(3 downto 0); -- ALU inputs and outputs
	signal carry : array(NUM_PU - 1 downto 0) of std_logic; -- ALU carry out
	-- Operation Signals
	signal sw_to_cin : std_logic;
	signal sw_to_op : std_logic_vector(2 downto 0);
	signal sw_to_op_doorbell : std_logic;
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

	sw_to_op_doorbell <= SW(0);
	sw_to_cin <= SW(1);
	sw_to_s <= SW(3 downto 2);
	sw_to_op <= SW(3 downto 1);

	pending_instruction: process (sw_to_op_doorbell)
	begin
		if (rising_edge(sw_to_op_doorbell)) then
			-- Send instruction to ALUs
		end if;
	end process digit_select;

	-- alu: four_bit_alu
	--     generic map(
    --         data_width => 4
    --     )
	--     port map(
    --         A => sw_to_a,
    --         B => sw_to_b,
    --         Op => sw_to_op,
    --         Carry => carry,
    --         Res => res
    --     );
	-- I_# => [4:1 = value, 0 = dot]
	seven_seg: sevseg_disp
	    port map(
			I_0 => "00000",
			I_1 => res(1) & carry(1),
			I_2 => in_b(1) & '0',
			I_3 => in_a(1) & '0',
			I_4 => "00000",
			I_5 => res(0) & carry(0),
			I_6 => in_b(0) & '0',
			I_7 => in_a(0) & '0',
			-- DOT => carry,
			AN_SEL => an_sel,
			AN => ANODES,
			SEG => SEG_CATHODES
		);	

end Structural;
