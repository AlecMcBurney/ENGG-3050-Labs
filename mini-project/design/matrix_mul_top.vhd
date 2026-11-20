library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.matrix_pkg.all;
--	Datapath:

entity mm_top is
	generic(
		DATA_WIDTH : positive := 6;
        OUTPUT_WIDTH : positive := 14;
        NUM_ROWS : positive := 3;
        NUM_COLS : positive := 3
	);
    Port (
		CLK100MHZ: in std_logic;
		SW: in std_logic_vector(3 downto 0); -- 3-2 => row_sel, 1-0 => col_sel
		ANODES : out std_logic_vector(7 downto 0); -- 7 seg ANODES
		SEG_CATHODES : out std_logic_vector(7 downto 0) -- 7 seg Cathodes
	);
end mm_top;

architecture Structural of mm_top is
	--Component Declarations:

    -- matrix mul component

    -- Matrix mux component
    component matrix_mux_3x3
        generic(
            DATA_WIDTH : positive := 6;
            OUTPUT_WIDTH : positive := 14
        );
        Port (	
            M0, M1 : in input_matrix_t
                (0 to 2, 0 to 2)(DATA_WIDTH - 1 downto 0);
            M2 : in output_matrix_t
                (0 to 2, 0 to 2)(OUTPUT_WIDTH - 1 downto 0);
            
            row_sel, col_sel : in  std_logic_vector(1 downto 0);
            
            M0_out, M1_out : out std_logic_vector(DATA_WIDTH - 1 downto 0);
            M2_out : out std_logic_vector(OUTPUT_WIDTH - 1 downto 0)
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
	
    -- Signals
    signal clkdiv : std_logic_vector(10 downto 0); -- CLOCK 
    signal an_sel : std_logic_vector (2 downto 0); --signal from clock division for anode and cathode selection
	
	-- 7seg inputs
	signal I_0, I_1, I_2, I_3, I_4, I_5, I_6, I_7 : std_logic_vector(4 downto 0);

    -- Matrix inputs and outputs
    signal matrix_a, matrix_b : input_matrix_t
        (0 to NUM_ROWS - 1, 0 to NUM_COLS - 1)(DATA_WIDTH - 1 downto 0);
    signal matrix_result : output_matrix_t
        (0 to NUM_ROWS - 1, 0 to NUM_COLS - 1)(OUTPUT_WIDTH - 1 downto 0);

    -- Matrix in/out displayed indeces
    signal ma_index, mb_index, mr_index : std_logic_vector(5 downto 0);
    signal sw_to_col, sw_to_row : std_logic_vector(1 downto 0);

begin
	sw_to_row <= SW(3 downto 2);
    sw_to_col <= SW(1 downto 0);

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
				when others => an_sel <= "000";
			end case;
		end if;
	end process digit_select;

    -- Input matrices
    matrix_a <= (0 => (0 => "000001", 1 => "000010", 2 => "000011"),
                 1 => (0 => "000100", 1 => "000101", 2 => "000110"),
                 2 => (0 => "000111", 1 => "001000", 2 => "001001"));
    matrix_b <= (0 => (0 => "000001", 1 => "000010", 2 => "000011"),
                 1 => (0 => "000100", 1 => "000101", 2 => "000110"),
                 2 => (0 => "000111", 1 => "001000", 2 => "001001"));
	
	-- matrix mul component call
    

    -- Matrix display selection logic
    m_mux : matrix_mux_3x3
        generic map(
            DATA_WIDTH => DATA_WIDTH,
            OUTPUT_WIDTH => OUTPUT_WIDTH
        );
        Port map(	
            M0 => matrix_a,
            M1 => matrix_b,
            M2 => matrix_result,
            
            row_sel => sw_to_row,
            col_sel => sw_to_col,
            
            M0_out => ma_index,
            M1_out => mb_index,
            M2_out => mr_index
        );
	
	-- Pad input digits with 0s
	I_0 <= mr_index(3 downto 0);
	I_1 <= "00" & mr_index(5 downto 4);
	I_2 <= "11111";
	I_3 <= "11111";
	I_4 <= mb_index(3 downto 0);
	I_5 <= "00" & mb_index(5 downto 4);
	I_6 <= ma_index(3 downto 0);
	I_7 <= "00" & ma_index(5 downto 4);
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