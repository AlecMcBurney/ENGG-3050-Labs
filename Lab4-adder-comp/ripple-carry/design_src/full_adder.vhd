library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity full_adder is
    Port ( FA_in1, FA_in2, Carry_in : in  STD_LOGIC;
           Sum, Carry_out : out  STD_LOGIC);
end full_adder;

architecture Behavioral of full_adder is

signal cout1,cout2,S1 : STD_LOGIC;

component half_adder is
    Port ( HA_in1 : in  STD_LOGIC;
           HA_in2 : in  STD_LOGIC;
           Sum : out  STD_LOGIC;
           Carry : out  STD_LOGIC);
end component;

begin
    
    HA1: half_adder
            port map (
                HA_in1 => FA_in1,
                HA_in2 => FA_in2,
                Sum => S1,
                Carry => cout1);
    HA2: half_adder
            port map (
                HA_in1 => S1,
                HA_in2 => Carry_in,
                Sum => Sum,
                Carry => cout2);
            
    Carry_out <= cout1 or cout2;

end Behavioral;
