library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
 
entity half_adder is
    Port ( HA_in1 : in  STD_LOGIC;
           HA_in2 : in  STD_LOGIC;
           Sum : out  STD_LOGIC;
           Carry : out  STD_LOGIC);
end half_adder;
 
architecture Behavioral of half_adder is
 
begin
 
    Sum <= HA_in1 xor HA_in2;
    Carry <= HA_in1 and HA_in2;
 
end Behavioral;