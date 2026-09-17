library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
--	In-Datapath-Out: Switches for adder => 7seg Cathode Mux => 7seg endoder
	
--	Control: clock divider => Anode Sequencer & 7seg Cathode Mux == match anode and cathode to same digit

entity main_clk is
    Port (	CLK100MHZ: in std_logic;
			SW: in std_logic_vector(11 downto 0); -- use 3 switches as binary bits
			ANODES : out std_logic_vector(7 downto 0); --7 seg ANODES
			SEG_CATHODES : out std_logic_vector(7 downto 0) --7 seg Cathodes   order might be backward?
	);
end main_clk;

architecture Structural of main_clk is

	--Component Declarations:

    -- Adder + 7seg display
    component display_result
        Port ( 
            SW: in std_logic_vector(11 downto 0); -- use 3 switches as binary bits
            DIG_SEL : in std_logic_vector(2 downto 0); -- number to select anode based on clock 
            ANODES : out std_logic_vector(7 downto 0); --7 seg ANODES
            SEG_CATHODES : out std_logic_vector(7 downto 0) --7 seg Cathodes   order might be backward?
        );
    end component;
    -- Signals
    signal clkdiv : std_logic_vector(10 downto 0); -- CLOCK 
    signal digCode : std_logic_vector (2 downto 0); --signal from clock division for anode and cathode selection
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
			case digCode is				--used to rotate 7 seg digits
		 		when "000" => digCode <= "001";
				when "001" => digCode <= "000";
			end case;
		end if;
	end process digit_select;

	display: display_result
	    port map(
            SW => SW,
            DIG_SEL => digCode, 
            ANODES => ANODES,
            SEG_CATHODES => SEG_CATHODES
        );
	

end Structural;
