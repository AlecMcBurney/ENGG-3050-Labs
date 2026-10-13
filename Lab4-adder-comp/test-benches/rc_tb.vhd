library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity simd_full_tb is
end simd_full_tb;

architecture Behavioral of simd_full_tb is
component sixbitadder is
    generic(
        data_width : integer := 16
    );
    Port ( A, B   : in  std_logic_vector(data_width - 1 downto 0);
           Carry  : out std_logic;
           Sum : out std_logic_vector(data_width - 1 downto 0)
    );
end component;

constant data_width : integer := 16;
signal A, B, Res : std_logic_vector(data_width-1 downto 0);
signal Cout   : std_logic;

shared variable pass_count, fail_count, total_count : integer := 0;

procedure check_result(
    constant actual     : in std_logic_vector;
    constant expected   : in std_logic_vector;
    constant test_name  : in string
) is
begin
    total_count := total_count + 1;
    if actual = expected then
        pass_count := pass_count + 1;
        report "PASSED: " & test_name & " actual=" & integer'image(to_integer(unsigned(actual))) &
               ", expected=" & integer'image(to_integer(unsigned(expected)))
            severity note;
    else
        fail_count := fail_count + 1;
        assert false
            report "! FAILED !: " & test_name & " actual=" & integer'image(to_integer(unsigned(actual))) &
                   ", expected=" & integer'image(to_integer(unsigned(expected)))
            severity error;
    end if;
end procedure;

begin
    uut: sixbitadder
        generic map(
            data_width => data_width
        )
        Port map( 
            A => A,
            B => B,
            Carry => Cout,
            Sum => Res
        );

    test_bench: process
    begin
        A <= "0000000000000001";
        B <= "0000000000000000";
        wait for 100 ns;
        check_result(Res, "0000000000000001", "Test 16-bit 1 + 0");

        A <= "1111111111111111";
        B <= "0000000000000001";
        wait for 100 ns;
        check_result(Res, "0000000000000000", "Test 16-bit 2^16-1 + 1");

        A <= "1111111111111111";
        B <= "1111111111111111";
        wait for 100 ns;
        check_result(Res, "1111111111111110", "Test 16-bit 2^16-1 + 1");

        report "SIMD TB SUMMARY: Total=" & integer'image(total_count) &
               ", PASS=" & integer'image(pass_count) &
               ", FAIL=" & integer'image(fail_count) severity note;
        wait;
    end process test_bench;
end Behavioral;