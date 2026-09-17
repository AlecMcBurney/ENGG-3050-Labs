library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity sevseg_dot is
    Port ( 
        int : in STD_LOGIC_VECTOR (4 downto 1);--same input vector here
        dot : in std_logic;		--as here when using component. 4-1 bits are character in hex, 0 bit is dot
        seg : out STD_LOGIC_VECTOR (7 downto 0) -- 7-1 bits are cathodes, 0 bit is dot. -- 0 is dot on, 1 is dot off
    );
end sevseg_dot;

architecture Behavioral of sevseg_dot is
begin
    decode: process(int, dot)
    begin
        case (int) is
            when "0000" => seg <= dot &"1000000" ;--& dot; 	--0 --DOT,G,F,E,D,C,B,A,
            when "0001" => seg <= dot &"1111001" ;--& dot; 	--1
            when "0010" => seg <= dot &"0100100" ;--& dot; 	--2
            when "0011" => seg <= dot &"0110000" ;--& dot; 	--3
            when "0100" => seg <= dot &"0011001" ;--& dot; 	--4
            when "0101" => seg <= dot &"0001001" ;--& dot; 	--5
            when "0110" => seg <= dot &"0000010" ;--& dot; 	--6
            when "0111" => seg <= dot &"1111000" ;--& dot; 	--7
            when "1000" => seg <= dot &"0000000" ;--& dot;  --8 --CHANAGE
            when "1001" => seg <= dot &"0011000" ;--& dot; 	--9
            when "1010" => seg <= dot &"0001000" ;--& dot;	--A
            when "1011" => seg <= dot &"0000011" ;--& dot;	--b
            when "1100" => seg <= dot &"1100110" ;--& dot;	--C
            when "1101" => seg <= dot &"0100001" ;--& dot;	--d
            when "1110" => seg <= dot &"0000110" ;--& dot;	--E
            when "1111" => seg <= dot &"0001110" ;--& dot;	--F
            when others => seg <= dot &"1111110" ;--& dot;	---
        end case;
    end process;

end Behavioral;
