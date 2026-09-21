library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity display_result is
    Port (
        SW: in std_logic_vector(11 downto 0); -- use 12 switches as binary bits
        DIG_SEL : in std_logic_vector(2 downto 0); -- number to select anode based on clock 
        ANODES : out std_logic_vector(7 downto 0); --7 seg ANODES
        SEG_CATHODES : out std_logic_vector(7 downto 0) --7 seg Cathodes
	);
end display_result;

architecture Structural of display_result is

	--Component Declarations:

    -- 6-bit adder
    component sixbitadder
        Port ( 
            A, B   : in  std_logic_vector(5 downto 0);
            Carry  : out std_logic;
            Sum : out std_logic_vector(5 downto 0)
        );
    end component;
    
    -- Seven segment display logic
    component sevseg_disp
        Port (
            VAL : in STD_LOGIC_VECTOR (5 downto 0);
            AN_SEL : in std_logic_vector(2 downto 0);
            AN : out std_logic_vector(7 downto 0);
            SEG : out STD_LOGIC_VECTOR (7 downto 0)
        );
    end component;
    
    -- Signal Declaration
    -- Signals for 6b adder outputs
    signal res : std_logic_vector(5 downto 0);
    signal carry: std_logic;

begin

	adder: sixbitadder
	    port map(
            A => SW(11 downto 6),
            B => SW(5 downto 0),
            Carry => carry,
            Sum => res
        );
    
    disp: sevseg_disp
        port map (
            VAL => res,
            AN_SEL => DIG_SEL,
            AN => ANODES,
            SEG => SEG_CATHODES
        );
end Structural;
