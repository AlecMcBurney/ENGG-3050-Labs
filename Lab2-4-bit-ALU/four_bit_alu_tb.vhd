library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity four_bit_alu_tb is
end four_bit_alu_tb;

architecture Behavioral of four_bit_alu_tb is
component four_bit_alu is
    Port (
        A, B   : in  std_logic_vector(3 downto 0);
        Op     : in  std_logic_vector(2 downto 0);
        Carry  : out std_logic;
        Res    : out std_logic_vector(3 downto 0)
   );
end component;

signal A, B : std_logic_vector(3 downto 0);
signal Op   : std_logic_vector(2 downto 0);
signal Cout   : std_logic;
signal S    : std_logic_vector(3 downto 0);

procedure check_result(
    constant actual     : in std_logic_vector(3 downto 0);
    constant expected   : in std_logic_vector(3 downto 0);
    constant test_name  : in string
) is
begin
    assert actual = expected
        report test_name & " FAILED"
            severity error;
    if actual = expected then
        report test_name & " PASSED"
            severity note;
    end if;
end procedure;

begin
    uut: four_bit_alu port map (
        A => A, 
        B => B,
        Op => Op,
        Carry => Cout,
        Res => S
    );
    
    test_bench: process
    begin
        -- 00, Cin = 0: A + B
        Op <= "000"; 
        A <= "0011"; -- A = 3
        B <= "0101"; -- B = 5
        wait for 100 ns;
        check_result(S, "1000", "ADD case 1"); -- 3 + 5 = 8
        
        A <= "1111"; -- A = 15
        B <= "0001"; -- B = 1
        wait for 100 ns;
        check_result(S, "0000", "ADD case 2"); -- 15 + 1 = 0, carry = 1

        -- 00, Cin = 1: A + not B + 1 (A - B)
        Op <= "001";
        A <= "1001"; -- A = 9
        B <= "0011"; -- B = 3
        wait for 100 ns;
        check_result(S, "0110", "A-B case 1"); -- 9 - 3 = 6
        
        A <= "0010"; -- A = 2
        B <= "0101"; -- B = 5
        wait for 100 ns;
        check_result(S, "1101", "A-B case 2"); -- 2 - 5 = -3 = 13

        -- 01, Cin = 0: not A + B
        Op <= "010";
        A <= "0011"; -- A = 3
        B <= "0101"; -- B = 5
        wait for 100 ns;
        check_result(S, "0001", "not-A+B case 1"); -- not 3 + 5 = 12 + 5 = 17 = 1, carry = 1
        
        A <= "1001"; -- A = 9
        B <= "0010"; -- B = 2
        wait for 100 ns;
        check_result(S, "1000", "not-A+B case 2"); -- not 9 + 2 = 8

        -- 01, Cin = 1: not A + B + 1 (B - A)
        Op <= "011";
        A <= "0011"; -- A = 3
        B <= "0101"; -- B = 5
        wait for 100 ns;
        check_result(S, "0010", "B-A case 1"); -- 5 - 3 = 2
        
        A <= "1001"; -- A = 9
        B <= "0010"; -- B = 2
        wait for 100 ns;
        check_result(S, "1001", "B-A case 2"); -- 2 - 9 = -7 = 9

        -- 10, Cin = 0: A - 1
        Op <= "100";
        A <= "0000"; -- A = 0
        B <= "0000"; -- B = 0, unused
        wait for 100 ns;
        check_result(S, "1111", "DECREMENT case 1"); -- 0 - 1 = -1 = 15
        
        A <= "0111"; -- A = 7
        wait for 100 ns;
        check_result(S, "0110", "DECREMENT case 2"); -- 7 - 1 = 6

        -- 10, Cin = 1: A + 1
        Op <= "101";
        A <= "1111"; -- A = 15
        B <= "0000"; -- B = 0, unused
        wait for 100 ns;
        check_result(S, "0000", "INCREMENT case 1"); -- 15 + 1 = 0, carry = 1
        
        A <= "0100"; -- A = 4
        wait for 100 ns;
        check_result(S, "0101", "INCREMENT case 2"); -- 4 + 1 = 5

        -- 11, Cin = 0: not A
        Op <= "110";
        A <= "0000"; -- A = 0
        B <= "0000"; -- B = 0, unused
        wait for 100 ns;
        check_result(S, "1111", "1s COMPLEMENT case 1"); -- not 0 = 15
        
        A <= "1010"; -- A = 10
        wait for 100 ns;
        check_result(S, "0101", "1s COMPLEMENT case 2"); -- not 10 = 5

        -- 11, Cin = 1: not A + 1 (2s complement)
        Op <= "111";
        A <= "0000"; -- A = 0
        B <= "0000"; -- B = 0, unused
        wait for 100 ns;
        check_result(S, "0000", "2s COMPLEMENT case 1"); -- not 0 + 1 = 0 (mod 16)
        
        A <= "0101"; -- A = 5
        wait for 100 ns;
        check_result(S, "1011", "2s COMPLEMENT case 2"); -- not 5 + 1 = 11

        wait;
    end process test_bench;
end Behavioral;
