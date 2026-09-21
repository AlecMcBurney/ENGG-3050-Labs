library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity four_bit_alu is
    Port ( 
       A, B   : in  std_logic_vector(3 downto 0);
       Op     : in  std_logic_vector(1 downto 0);
       Cin    : in std_logic;
       Carry  : out std_logic;
       Res : out std_logic_vector(3 downto 0)
    );
end four_bit_alu;

architecture Behavioral of four_bit_alu is
    component one_bit_alu is
        Port ( 
            A, B   : in  std_logic;
            Op     : in  std_logic_vector(1 downto 0);
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
    
    signal S, a_comp, b_comp, A_res, B1_res, B0_res, B_res : std_logic_vector (3 downto 0);
    signal C : std_logic_vector (4 downto 0);
    signal b0_sel, b1_sel : std_logic;

begin
    C(0) <= Cin;
    A_comp <= not A;
    a_mux: Mux2To1 port map (
        I_0 => A,
        I_1 => A_comp,
        S => Op(0),
        Z => A_res
    );
    
    B_comp <= not B;
    b0_sel <= not Op(0) and not Op(1) and Cin;
    b1_sel <= not Op(0) and Op(1) and not Cin;
    b0_mux: Mux2To1 port map (
        I_0 => B,
        I_1 => B_comp,
        S => b0_sel,
        Z => B0_res
    );
    b1_mux: Mux2To1 port map (
        I_0 => "0000",
        I_1 => "1111",
        S => b1_sel,
        Z => B1_res
    );
    b2_mux: Mux2To1 port map (
        I_0 => B0_res,
        I_1 => B1_res,
        S => Op(1),
        Z => B_res
    );
    
    alus: for i in 0 to 3 generate
        alu_x: one_bit_alu port map (
            A    => A_res(i),
            B    => B_res(i),
            Cin  => C(i),
            Op   => Op,
            Res   => S(i),
            Carry => C(i+1)
        );
    end generate alus;
    
    Carry <= C(4);
    Res <= S;
end Behavioral;
