library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity one_bit_alu is
    Port ( 
       A, B   : in  std_logic;
       Op     : in  std_logic_vector(1 downto 0);
       Cin    : in std_logic;
       Carry  : out std_logic;
       Res : out std_logic
    );
end one_bit_alu;

architecture Behavioral of one_bit_alu is
    component full_adder is
        Port ( 
            FA_in1, FA_in2, Carry_in : in  STD_LOGIC;
            Sum, Carry_out : out  STD_LOGIC
        );
    end component;

begin
    
    adder_x: full_adder port map (
        FA_in1    => A,
        FA_in2    => B,
        Carry_in  => Cin,
        Sum       => Res,
        Carry_out => Carry
    );
end Behavioral;
