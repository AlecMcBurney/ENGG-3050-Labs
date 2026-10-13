library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity sixbitadder is
    generic(
        data_width : integer := 16
    );
    Port ( A, B   : in  std_logic_vector(data_width - 1 downto 0);
           Carry  : out std_logic;
           Sum : out std_logic_vector(data_width - 1 downto 0)
    );
end sixbitadder;

architecture Behavioral of sixbitadder is
    component full_adder is
        Port ( 
            FA_in1, FA_in2, Carry_in : in  STD_LOGIC;
            Sum, Carry_out : out  STD_LOGIC
        );
    end component;
    
    signal S : std_logic_vector (data_width - 1 downto 0);
    signal C : std_logic_vector (data_width downto 0);

begin
    C(0) <= '0';
    
    adders: for i in  data_width - 1 downto 0 generate
        adder_x: full_adder port map (
            FA_in1    => A(i),
            FA_in2    => B(i),
            Carry_in  => C(i),
            Sum       => S(i),
            Carry_out => C(i+1)
        );
    end generate adders;
    
    Carry <= C(data_width);
    Sum <= S;
end Behavioral;
