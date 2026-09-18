library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity sixbitadder_tb is
end sixbitadder_tb;

architecture Behavioral of sixbitadder_tb is
component sixbitadder is
    Port (
        A, B   : in  std_logic_vector(5 downto 0);
        Carry  : out std_logic;
        Sum : out std_logic_vector(5 downto 0)
   );
end component;

signal A, B : std_logic_vector(5 downto 0);
signal Co   : std_logic;
signal S    : std_logic_vector(5 downto 0);

begin
    uut: sixbitadder port map (
        A => A, 
        B => B,
        Sum => S,
        Carry => Co
    );
        
    test_bench: process
    begin
        A <= "000000";
        B <= "000000";
        --Sum=000000 carry=0
        wait for 100 ns;
        
        A <= "001000";
        B <= "101100";
        --Sum=110100 carry=0
        wait for 100 ns;
        
        A <= "001100";
        B <= "101100";
        --Sum=111000 carry=0        
        wait for 100 ns;
        
        A <= "100000";
        B <= "100000";
        --sum=000000 carry=1
        wait for 100 ns;
        
        A <= "001111";
        B <= "000001";
        --sum=010000 carry=0
        wait for 100 ns;
        
        A <= "001100";
        B <= "110011";
        --sum=111111 carry=0
        wait for 100 ns;
        
        wait;
    end process test_bench;
end Behavioral;
