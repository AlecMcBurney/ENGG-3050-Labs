
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity cla_64b_tb is
end cla_64b_tb;

architecture Behavioral of cla_64b_tb is

component cla_64b is
    Port (
        A64, B64 : in std_logic_vector(63 downto 0);
        clk : in std_logic;
        Carry : out std_logic;
        Sum64 : out std_logic_vector(63 downto 0)
    );
end component;

constant CLK_PERIOD : time := 10 ns;

signal A64, B64, Sum64 : std_logic_vector(63 downto 0);
signal Carry : std_logic;
signal clk_test : std_logic := '0';

begin

    uut_64: cla_64b
        port map(
            A64 => A64,
            B64 => B64,
            clk => clk_test,
            Carry => Carry,
            Sum64 => Sum64
        );

    clk_process: process
    begin
        clk_test <= '0';
        wait for CLK_PERIOD / 2;
        clk_test <= '1';
        wait for CLK_PERIOD / 2;
    end process;

    test_64: process
    begin

        A64 <= X"0000000000000001";
        B64 <= X"0000000000000000";
        wait for 2 * CLK_PERIOD;
        assert (Sum64 = X"0000000000000001" and Carry = '0')
            report "Test 1 failed" severity error;

        A64 <= X"0000000000000003";
        B64 <= X"0000000000000005";
        wait for 2 * CLK_PERIOD;
        assert (Sum64 = X"0000000000000008" and Carry = '0')
            report "Test 2 failed" severity error;

        A64 <= X"7FFFFFFFFFFFFFFF";
        B64 <= X"0000000000000001";
        wait for 2 * CLK_PERIOD;
        assert (Sum64 = X"8000000000000000" and Carry = '0')
            report "Test 3 failed" severity error;

        A64 <= X"FFFFFFFFFFFFFFFF";
        B64 <= X"0000000000000001";
        wait for 2 * CLK_PERIOD;
        assert (Sum64 = X"0000000000000000" and Carry = '1')
            report "Test 4 failed" severity error;

        A64 <= X"8000000000000000";
        B64 <= X"8000000000000000";
        wait for 2 * CLK_PERIOD;
        assert (Sum64 = X"0000000000000000" and Carry = '1')
            report "Test 5 failed" severity error;

        report "64-bit CLA tests completed" severity note;
        wait;

    end process test_64;

end Behavioral;
