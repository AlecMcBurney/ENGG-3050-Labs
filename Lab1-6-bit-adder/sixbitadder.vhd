library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity sixbitadder is
    Port ( A, B   : in  std_logic_vector(5 downto 0);
           Carry  : out std_logic;
           Sum : out std_logic_vector(5 downto 0)
    );
end sixbitadder;

architecture Behavioral of sixbitadder is
    component full_adder is
        Port ( 
            FA_in1, FA_in2, Carry_in : in  STD_LOGIC;
            Sum, Carry_out : out  STD_LOGIC
        );
    end component;
    
    signal S : std_logic_vector (5 downto 0);
    signal C : std_logic_vector (6 downto 0);

begin
    C(0) <= '0';
    
    adders: for i in 0 to 5 generate
        adder_x: full_adder port map (
            FA_in1    => A(i),
            FA_in2    => B(i),
            Carry_in  => C(i),
            Sum       => S(i),
            Carry_out => C(i+1)
        );
    end generate adders;
    
    Carry <= C(6);
    Sum <= S;
end Behavioral;
