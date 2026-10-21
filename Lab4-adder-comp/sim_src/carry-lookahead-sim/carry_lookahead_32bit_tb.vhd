
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity cla_32b_tb is
end cla_32b_tb;

architecture Behavioral of cla_32b_tb is

component cla_32b is
    Port (
        A32, B32 : in std_logic_vector(31 downto 0);
        clk : in std_logic;
        Carry : out std_logic;
        Sum32 : out std_logic_vector(31 downto 0)
    );
end component;

constant CLK_PERIOD : time := 10 ns;

signal A32, B32, Sum32 : std_logic_vector(31 downto 0);
signal Carry : std_logic;
signal clk_test : std_logic := '0';

begin

    uut_32: cla_32b
        port map(
            A32 => A32,
            B32 => B32,
            clk => clk_test,
            Carry => Carry,
            Sum32 => Sum32
        );

    clk_process: process
    begin
        clk_test <= '0';
        wait for CLK_PERIOD / 2;
        clk_test <= '1';
        wait for CLK_PERIOD / 2;
    end process;

    test_32: process
    begin

        A32 <= X"00000001";
        B32 <= X"00000000";
        wait for 2 * CLK_PERIOD;
        assert (Sum32 = X"00000001" and Carry = '0')
            report "Test 1 failed" severity error;

        A32 <= X"00000003";
        B32 <= X"00000005";
        wait for 2 * CLK_PERIOD;
        assert (Sum32 = X"00000008" and Carry = '0')
            report "Test 2 failed" severity error;

        A32 <= X"7FFFFFFF";
        B32 <= X"00000001";
        wait for 2 * CLK_PERIOD;
        assert (Sum32 = X"80000000" and Carry = '0')
            report "Test 3 failed" severity error;

        A32 <= X"FFFFFFFF";
        B32 <= X"00000001";
        wait for 2 * CLK_PERIOD;
        assert (Sum32 = X"00000000" and Carry = '1')
            report "Test 4 failed" severity error;

        A32 <= X"80000000";
        B32 <= X"80000000";
        wait for 2 * CLK_PERIOD;
        assert (Sum32 = X"00000000" and Carry = '1')
            report "Test 5 failed" severity error;

        report "32-bit CLA tests completed" severity note;
        wait;

    end process test_32;

end Behavioral;
