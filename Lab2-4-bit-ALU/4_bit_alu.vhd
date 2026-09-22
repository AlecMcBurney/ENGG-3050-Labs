library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity four_bit_alu is
    Port ( 
       A, B   : in  std_logic_vector(3 downto 0);
       Op     : in  std_logic_vector(2 downto 0);
       Carry  : out std_logic;
       Res : out std_logic_vector(3 downto 0)
    );
end four_bit_alu;

architecture Behavioral of four_bit_alu is
    component one_bit_alu is
        Port ( 
            A, B   : in  std_logic;
            Op     : in  std_logic_vector(2 downto 0);
            Cin    : in std_logic;
            Carry  : out std_logic;
            Res : out std_logic
        );
    end component;

    component Mux2To1 is
        Port (	I_0, I_1 : in std_logic_vector(3 downto 0);
                S : in  std_logic;
                Z : out  std_logic_vector(3 downto 0)
            );
    end component;
    
    signal S : std_logic_vector (3 downto 0);
    signal C : std_logic_vector (4 downto 0);

begin
    C(0) <= Op(0);
    
    alus: for i in 0 to 3 generate
        alu_x: one_bit_alu port map (
            A    => A(i),
            B    => B(i),
            Cin  => C(i),
            Op   => Op,
            Res   => S(i),
            Carry => C(i+1)
        );
    end generate alus;
    
    Carry <= C(4);
    Res <= S;
end Behavioral;
