
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity cla_16b_tb is
end cla_16b_tb;

architecture Behavioral of cla_16b_tb is

component cla_16b is
    Port (
        A16, B16 : in std_logic_vector(15 downto 0);
        clk : in std_logic;
        Carry : out std_logic;
        Sum16 : out std_logic_vector(15 downto 0)
    );
end component;

constant CLK_PERIOD : time := 10 ns;

signal A16, B16, Sum16 : std_logic_vector(15 downto 0);
signal Carry : std_logic;
signal clk_test : std_logic := '0';

begin

    uut_16: cla_16b
        port map(
            A16 => A16,
            B16 => B16,
            clk => clk_test,
            Carry => Carry,
            Sum16 => Sum16
        );

    clk_process: process
    begin
        clk_test <= '0';
        wait for CLK_PERIOD / 2;
        clk_test <= '1';
        wait for CLK_PERIOD / 2;
    end process;

    test_16: process
    begin

        A16 <= X"0001";
        B16 <= X"0000";
        wait for 2 * CLK_PERIOD;
        assert (Sum16 = X"0001" and Carry = '0')
            report "Test 1 failed" severity error;

        A16 <= X"0003";
        B16 <= X"0005";
        wait for 2 * CLK_PERIOD;
        assert (Sum16 = X"0008" and Carry = '0')
            report "Test 2 failed" severity error;

        A16 <= X"7FFF";
        B16 <= X"0001";
        wait for 2 * CLK_PERIOD;
        assert (Sum16 = X"8000" and Carry = '0')
            report "Test 3 failed" severity error;

        A16 <= X"FFFF";
        B16 <= X"0001";
        wait for 2 * CLK_PERIOD;
        assert (Sum16 = X"0000" and Carry = '1')
            report "Test 4 failed" severity error;

        A16 <= X"8000";
        B16 <= X"8000";
        wait for 2 * CLK_PERIOD;
        assert (Sum16 = X"0000" and Carry = '1')
            report "Test 5 failed" severity error;

        report "16-bit CLA tests completed" severity note;
        wait;

    end process test_16;

end Behavioral;
