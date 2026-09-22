library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Mux8To1_8bit is
    Port (	I_0, I_1, I_2, I_3, I_4, I_5, I_6, I_7 : in std_logic_vector(7 downto 0);
			S : in  std_logic_vector(2 downto 0);
			Z : out  std_logic_vector(7 downto 0)
			);  
end Mux8To1_8bit;

architecture Behavioral of Mux8To1_8bit is

begin
	process(S, I_0, I_1, I_2, I_3, I_4, I_5, I_6, I_7)
	begin	case (S) is
            when "000" => Z <= I_0;
			when "001" => Z <= I_1;
			when "010" => Z <= I_2;
			when "011" => Z <= I_3;
			when "100" => Z <= I_4;
			when "101" => Z <= I_5;
			when "110" => Z <= I_6;
			when "111" => Z <= I_7;
			when others => Z <= "0";
        end case;
	end process;
end Behavioral;
