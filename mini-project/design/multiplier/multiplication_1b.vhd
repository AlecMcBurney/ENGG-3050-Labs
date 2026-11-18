library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity multiplier_1b is
    Port ( 
        Mul_In1 : in  STD_LOGIC;
        Mul_In2 : in  STD_LOGIC;
        Product : out  STD_LOGIC);
end multiplier_1b;
 
architecture Behavioral of multiplier_1b is
 
begin
 
    Product <= Mul_In1 and Mul_In2;
 
end Behavioral;