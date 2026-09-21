library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity display_alu_result is
    Port (
        SW: in std_logic_vector(10 downto 0); -- use 12 switches as binary bits
        DIG_SEL : in std_logic_vector(2 downto 0); -- number to select anode based on clock 
        ANODES : out std_logic_vector(7 downto 0); --7 seg ANODES
        SEG_CATHODES : out std_logic_vector(7 downto 0) --7 seg Cathodes
	);
end display_alu_result;

architecture Structural of display_alu_result is

	--Component Declarations:

    -- 6-bit adder
    component four_bit_alu
        Port ( 
            A, B   : in  std_logic_vector(3 downto 0);
            Op     : in  std_logic_vector(1 downto 0);
            Cin    : in std_logic;
            Carry  : out std_logic;
            Res : out std_logic_vector(3 downto 0)
        );
    end component;
    
    -- Seven segment display logic
    component sevseg_disp
        Port (
            VAL : in STD_LOGIC_VECTOR (3 downto 0);
            AN_SEL : in std_logic_vector(2 downto 0);
            AN : out std_logic_vector(7 downto 0);
            SEG : out STD_LOGIC_VECTOR (7 downto 0)
        );
    end component;
    
    -- Signal Declaration
    -- Signals for 6b adder outputs
    signal res : std_logic_vector(3 downto 0);
    signal carry: std_logic;

begin

    disp_A: sevseg_disp
        port map (
            VAL => SW(7 downto 4),
            AN_SEL => "111",
            AN => ANODES,
            SEG => SEG_CATHODES
        );
    disp_B: sevseg_disp
        port map (
            VAL => SW(3 downto 0),
            AN_SEL => "110",
            AN => ANODES,
            SEG => SEG_CATHODES
        );

	adder: four_bit_alu
	    port map(
            A => SW(7 downto 4),
            B => SW(3 downto 0),
            Op => SW(10 downto 9),
            Cin => SW(8),
            Carry => carry,
            Sum => res
        );
    
    disp_res: sevseg_disp
        port map (
            VAL => res,
            AN_SEL => "000",
            AN => ANODES,
            SEG => SEG_CATHODES
        );
end Structural;
