library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity one_bit_alu is
    Port ( 
       A, B   : in  std_logic;
       Op     : in  std_logic_vector(2 downto 0);
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

    component Mux2To1_1bit is
        Port (	I_0, I_1 : in std_logic;
                S : in  std_logic;
                Z : out  std_logic
            );
    end component;

    signal a_comp, b_comp, A_res, B1_res, B0_res, B_res : std_logic;
    signal b0_sel, b1_sel : std_logic;

begin
    A_comp <= not A;
    a_mux: Mux2To1_1bit port map (
        I_0 => A,
        I_1 => A_comp,
        S => Op(1),
        Z => A_res
    );
    
    B_comp <= not B;
    b0_sel <= not Op(2) and not Op(1) and Op(0);
    b1_sel <= Op(2) and not Op(1) and not Op(0);
    b0_mux: Mux2To1_1bit port map (
        I_0 => B,
        I_1 => B_comp,
        S => b0_sel,
        Z => B0_res
    );
    b1_mux: Mux2To1_1bit port map (
        I_0 => '0',
        I_1 => '1',
        S => b1_sel,
        Z => B1_res
    );
    b2_mux: Mux2To1_1bit port map (
        I_0 => B0_res,
        I_1 => B1_res,
        S => Op(2),
        Z => B_res
    );

    adder_x: full_adder port map (
        FA_in1    => A_res,
        FA_in2    => B_res,
        Carry_in  => Cin,
        Sum       => Res,
        Carry_out => Carry
    );
end Behavioral;
