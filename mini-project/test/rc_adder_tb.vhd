library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity rc_16bit_tb is
end rc_16bit_tb;

architecture Behavioral of rc_16bit_tb is
    component rc_16b is
        Port (
            A16, B16 : in  std_logic_vector(15 downto 0);
            clk      : in  std_logic;
            Carry    : out std_logic;
            Sum16    : out std_logic_vector(15 downto 0)
        );
    end component;

    signal A, B, Sum : std_logic_vector(15 downto 0) := (others => '0');
    signal Carry, clk : std_logic := '0';
    constant CLK_PERIOD : time := 10 ns;

    procedure run_test(
        signal test_a       : out std_logic_vector(15 downto 0);
        signal test_b       : out std_logic_vector(15 downto 0);
        signal actual_sum   : in  std_logic_vector(15 downto 0);
        signal actual_carry : in  std_logic;
        constant value_a    : in  std_logic_vector(15 downto 0);
        constant value_b    : in  std_logic_vector(15 downto 0);
        constant expected_sum : in std_logic_vector(15 downto 0);
        constant expected_carry : in std_logic;
        constant test_name  : in string;
        variable total_count : inout integer;
        variable pass_count  : inout integer;
        variable fail_count  : inout integer
    ) is
    begin
        test_a <= value_a;
        test_b <= value_b;
        wait for 100 ns;
        total_count := total_count + 1;
        if actual_sum = expected_sum and actual_carry = expected_carry then
            pass_count := pass_count + 1;
            report "PASSED: " & test_name severity note;
        else
            fail_count := fail_count + 1;
            assert false
                report "FAILED: " & test_name
                severity error;
        end if;
    end procedure;
begin
    clk_process: process
    begin
        loop
            clk <= '0';
            wait for CLK_PERIOD / 2;
            clk <= '1';
            wait for CLK_PERIOD / 2;
        end loop;
    end process;

    uut: rc_16b
        port map (
            A16 => A,
            B16 => B,
            clk => clk,
            Carry => Carry,
            Sum16 => Sum
        );

    test_process: process
        variable total_count : integer := 0;
        variable pass_count  : integer := 0;
        variable fail_count  : integer := 0;
    begin
        run_test(
            test_a        => A,
            test_b        => B,
            actual_sum    => Sum,
            actual_carry  => Carry,
            value_a       => X"0001",
            value_b       => X"0000",
            expected_sum  => X"0001",
            expected_carry => '0',
            test_name     => "16-bit 1 + 0",
            total_count   => total_count,
            pass_count    => pass_count,
            fail_count    => fail_count
        );
        run_test(
            test_a        => A,
            test_b        => B,
            actual_sum    => Sum,
            actual_carry  => Carry,
            value_a       => X"0003",
            value_b       => X"0005",
            expected_sum  => X"0008",
            expected_carry => '0',
            test_name     => "16-bit 3 + 5",
            total_count   => total_count,
            pass_count    => pass_count,
            fail_count    => fail_count
        );
        run_test(
            test_a        => A,
            test_b        => B,
            actual_sum    => Sum,
            actual_carry  => Carry,
            value_a       => X"7FFF",
            value_b       => X"0001",
            expected_sum  => X"8000",
            expected_carry => '0',
            test_name     => "16-bit 2^15-1 + 1",
            total_count   => total_count,
            pass_count    => pass_count,
            fail_count    => fail_count
        );
        run_test(
            test_a        => A,
            test_b        => B,
            actual_sum    => Sum,
            actual_carry  => Carry,
            value_a       => X"FFFF",
            value_b       => X"0001",
            expected_sum  => X"0000",
            expected_carry => '1',
            test_name     => "16-bit max + 1",
            total_count   => total_count,
            pass_count    => pass_count,
            fail_count    => fail_count
        );
        run_test(
            test_a        => A,
            test_b        => B,
            actual_sum    => Sum,
            actual_carry  => Carry,
            value_a       => X"8000",
            value_b       => X"8000",
            expected_sum  => X"0000",
            expected_carry => '1',
            test_name     => "16-bit 0x8000 + 0x8000",
            total_count   => total_count,
            pass_count    => pass_count,
            fail_count    => fail_count
        );
        report "16-bit ripple-carry summary: Total=" & integer'image(total_count) &
               ", PASS=" & integer'image(pass_count) &
               ", FAIL=" & integer'image(fail_count) severity note;
        wait;
    end process;
end Behavioral;
