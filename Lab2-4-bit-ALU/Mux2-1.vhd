library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Mux2To1 is
    Port (	I_0, I_1 : in std_logic_vector(3 downto 0);
			S : in  std_logic;
			Z : out  std_logic_vector(3 downto 0)
			);  
end Mux2To1;

architecture Behavioral of Mux2To1 is

begin
	process(S, I_0, I_1)
	begin	case (S) is
            when '0' => Z <= I_0;
			when '1' => Z <= I_1;
			when others => Z <= "0000";
        end case;
	end process;
end Behavioral;
