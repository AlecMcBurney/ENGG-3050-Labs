library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity alu_multiple is
    generic (
        data_width : integer := 4
    );

    Port (
        A1 : in std_logic_vector(data_width-1 downto 0);
        B1 : in std_logic_vector(data_width-1 downto 0);
        A2 : in std_logic_vector(data_width-1 downto 0);
        B2 : in std_logic_vector(data_width-1 downto 0);
        Op : in std_logic_vector(2 downto 0);
        Res1   : out std_logic_vector(data_width-1 downto 0);
        Carry1 : out std_logic;
        Res2   : out std_logic_vector(data_width-1 downto 0);
        Carry2 : out std_logic
    );
end alu_multiple;


architecture Behavioral of alu_multiple is

    component four_bit_alu is
        generic (
            data_width : integer := 4
        );

        Port (
            A, B  : in std_logic_vector(data_width-1 downto 0);
            Op    : in std_logic_vector(2 downto 0);
            Carry : out std_logic;
            Res   : out std_logic_vector(data_width-1 downto 0)
        );
    end component;

begin

    ALU1 : four_bit_alu
        generic map (
            data_width => data_width
        )
        port map (
            A     => A1,
            B     => B1,
            Op    => Op,
            Carry => Carry1,
            Res   => Res1
        );


    ALU2 : four_bit_alu
        generic map (
            data_width => data_width
        )
        port map (
            A     => A2,
            B     => B2,
            Op    => Op,
            Carry => Carry2,
            Res   => Res2
        );

end Behavioral;
