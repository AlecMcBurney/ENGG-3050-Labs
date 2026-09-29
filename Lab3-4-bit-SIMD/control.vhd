library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
--	In-Datapath-Out:

entity main_control is
	generic(
		NUM_PU : integer := 2; -- How many ALUs
		DATA_WIDTH : integer := 4 -- Width of each ALU's data paths
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

    -- 4-bit SIMD module (2 ALUs)
	component alu_multiple
		generic (
			data_width : integer := 4
		);
		Port (
			A0 : in std_logic_vector(data_width-1 downto 0);
			B0 : in std_logic_vector(data_width-1 downto 0);
			A1 : in std_logic_vector(data_width-1 downto 0);
			B1 : in std_logic_vector(data_width-1 downto 0);
			Op : in std_logic_vector(2 downto 0);
			Res0   : out std_logic_vector(data_width-1 downto 0);
			Carry0 : out std_logic;
			Res1   : out std_logic_vector(data_width-1 downto 0);
			Carry1 : out std_logic
		);
	end component;
    
	--Memory
	component simd_mem
		generic ( DATA_W : integer := 4; DEPTH : integer := 10; ADDR_W : integer := 4 );
		port (
			addr : in  std_logic_vector(ADDR_W-1 downto 0);
			a0, b0, a1, b1 : out std_logic_vector(DATA_W-1 downto 0)
		);
	end component;



    -- Seven segment display logic
    component sevseg_disp
        Port (
            I_0, I_1, I_2, I_3, I_4, I_5, I_6, I_7 : in std_logic_vector(4 downto 0);
            AN_SEL : in std_logic_vector(2 downto 0); -- numbered anode select (Selected via clock)
            AN : out std_logic_vector(7 downto 0); -- per bit which anode to turn on/off
            SEG : out STD_LOGIC_VECTOR (7 downto 0) -- 7-1 bits are cathodes, 0 bit is dot. 0 on, 1 off
        );
    end component;

	type   vector_arr is array(NUM_PU - 1 downto 0) of std_logic_vector(DATA_WIDTH - 1 downto 0);
	type   logic_arr is array(NUM_PU - 1 downto 0) of std_logic;
	
    -- Signals
    signal clkdiv : std_logic_vector(10 downto 0); -- CLOCK 
    signal an_sel : std_logic_vector (2 downto 0); --signal from clock division for anode and cathode selection
	
	-- Signals for 4-bit ALU
   	signal res : vector_arr; -- ALU outputs
	signal carry : logic_arr; -- ALU carry out
	
	-- Operation Signals
	signal sw_to_cin : std_logic;
	signal sw_to_op : std_logic_vector(2 downto 0);
	signal sw_to_op_req : std_logic;

	--Memory Signals
	constant LAST_ADDR : integer := 9;                 -- 10 values per memory (0..9)
	signal addr : std_logic_vector(3 downto 0) := (others => '0');
	signal mem_a, mem_b : vector_arr;
	
	-- 7seg inputs
	signal I_0, I_1, I_2, I_3, I_4, I_5, I_6, I_7 : std_logic_vector(4 downto 0);

begin
	clock_divider: process (CLK100MHz)		-- create system clock divder
	begin
		if (rising_edge(CLK100MHz)) then
			clkdiv <= std_logic_vector(unsigned(clkdiv) + 1);
		end if;
	end process clock_divider;
	
	digit_select: process (clkdiv(10))
	begin
		if (rising_edge(clkdiv(10))) then
			-- used to rotate 7 seg digits
			case an_sel is				
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

	sw_to_op_req <= SW(0);
	sw_to_cin <= SW(1);
	sw_to_op <= SW(3 downto 1);
	
	memories: simd_mem
        generic map( 
            DATA_W => DATA_WIDTH, 
            ADDR_W => 4
        )
        port map( 
            addr => addr,
            a0 => mem_a(0), 
            b0 => mem_b(0),
            a1 => mem_a(1), 
            b1 => mem_b(1) 
        );
	simd: alu_multiple
		generic map(
			data_width => DATA_WIDTH
		)
		port map(
			A0 => mem_a(0),
			B0 => mem_b(0),
			A1 => mem_a(1),
			B1 => mem_b(1),
			Op => sw_to_op,
			Res0   => res(0),
			Carry0 => carry(0),
			Res1   => res(1),
			Carry1 => carry(1)
		);

	pending_instruction: process (sw_to_op_req)
	begin
		if rising_edge(sw_to_op_req) then
			if unsigned(addr) > to_unsigned(LAST_ADDR, addr'length) then
				addr <= (others => '0');
			else
				addr <= std_logic_vector(unsigned(addr) + 1);
			end if;
		end if;
	end process pending_instruction;

	
	-- Pad inputs with 0 to turn dots off
	I_0 <= "00000";
	I_1 <= res(1) & carry(1);
	I_2 <= mem_b(1) & '0';
	I_3 <= mem_a(1) & '0';
	I_4 <= "00000";
	I_5 <= res(0) & carry(0);
	I_6 <= mem_b(0) & '0';
	I_7 <= mem_a(0) & '0';
	seven_seg: sevseg_disp
	    port map(
			I_0 => I_0,
			I_1 => I_1,
			I_2 => I_2,
			I_3 => I_3,
			I_4 => I_4,
			I_5 => I_5,
			I_6 => I_6,
			I_7 => I_7,
			AN_SEL => an_sel,
			AN => ANODES,
			SEG => SEG_CATHODES
		);

end Structural;