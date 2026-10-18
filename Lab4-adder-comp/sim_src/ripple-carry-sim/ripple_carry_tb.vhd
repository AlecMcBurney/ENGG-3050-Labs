library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity rc_adder_tb is
end rc_adder_tb;

architecture Behavioral of rc_adder_tb is
component rc_16b is
    Port ( 
        A16, B16   : in  std_logic_vector(15 downto 0);
        clk  : in  std_logic;
        Carry  : out std_logic;
        Sum16 : out std_logic_vector(15 downto 0)
    );
end component;

component rc_32b is
    Port ( 
        A32, B32   : in  std_logic_vector(31 downto 0);
        clk  : in  std_logic;
        Carry  : out std_logic;
        Sum32 : out std_logic_vector(31 downto 0)
    );
end component;

component rc_64b is
    Port ( 
        A64, B64   : in  std_logic_vector(63 downto 0);
        clk  : in  std_logic;   
        Carry  : out std_logic;
        Sum64 : out std_logic_vector(63 downto 0)
    );
end component;

signal A16, B16, Res16 : std_logic_vector(15 downto 0);
signal A32, B32, Res32 : std_logic_vector(31 downto 0);
signal A64, B64, Res64 : std_logic_vector(63 downto 0);
signal Cout16 : std_logic;
signal Cout32 : std_logic;
signal Cout64 : std_logic;
signal clk_test : std_logic := '0';

shared variable pass_count, fail_count, total_count : integer := 0;

-- Clock period constant (e.g., 10 ns -> 100 MHz)
constant CLK_PERIOD : time := 10 ns;

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
    -- Clock Generation Process
    clk_process: process
    begin
        clk_test <= '0';
        wait for CLK_PERIOD / 2;
        clk_test <= '1';
        wait for CLK_PERIOD / 2;
    end process;

    uut_16: rc_16b
        port map(
            A16 => A16,
            B16 => B16,
            clk => clk_test,
            Carry => Cout16,
            Sum16 => Res16
        );

    uut_32: rc_32b
        port map(
            A32 => A32,
            B32 => B32,
            clk => clk_test,
            Carry => Cout32,
            Sum32 => Res32
        );

    uut_64: rc_64b
        port map(
            A64 => A64,
            B64 => B64,
            clk => clk_test,
            Carry => Cout64,
            Sum64 => Res64
        );

    test_16: process
    begin
        A16 <= "0000000000000001";
        B16 <= "0000000000000000";

        A32 <= X"00000001";
        B32 <= X"00000000";

        A64 <= X"0000000000000001";
        B64 <= X"0000000000000001";
        wait for 100 ns;
        check_result(Res16, "0000000000000001", "16-bit 1 + 0");
        check_result(Res32, X"00000001", "32-bit 1 + 0");
        check_result(Res64, X"0000000000000002", "64-bit 1 + 1");
        



        A16 <= "0000000000000011";
        B16 <= "0000000000000101";

        A32 <= X"00000003";
        B32 <= X"00000005";

        A64 <= X"0000000000000003";
        B64 <= X"0000000000000005";
        wait for 100 ns;
        check_result(Res16, "0000000000001000", "16-bit 3 + 5");
        check_result(Res32, X"00000008", "32-bit 3 + 5");
        check_result(Res64, X"0000000000000008", "64-bit 3 + 5");


        A16 <= "0111111111111111";
        B16 <= "0000000000000001";

        A32 <= X"7FFFFFFF";
        B32 <= X"00000001";
        
        A64 <= X"7FFFFFFFFFFFFFFF";
        B64 <= X"0000000000000001";
        wait for 100 ns;
        check_result(Res16, "1000000000000000", "16-bit 2^15-1 + 1");
        check_result(Res32, X"80000000", "32-bit 2^31-1 + 1");
        check_result(Res64, X"8000000000000000", "64-bit 2^63-1 + 1");


        A16 <= "1111111111111111";
        B16 <= "0000000000000001";

        A32 <= X"FFFFFFFF";
        B32 <= X"00000001";

        A64 <= X"FFFFFFFFFFFFFFFF";
        B64 <= X"0000000000000001";
        wait for 100 ns;
        check_result(Res16, "0000000000000000", "16-bit max + 1");
        check_result(Res32, X"00000000", "32-bit max + 1");
        check_result(Res64, X"0000000000000000", "64-bit max + 1");


        A16 <= "1000000000000000";
        B16 <= "1000000000000000";

        A32 <= X"40000000";
        B32 <= X"40000000";

        A64 <= X"4000000000000000";
        B64 <= X"4000000000000000";
        wait for 100 ns;
        check_result(Res16, "0000000000000000", "16-bit 0x8000 + 0x8000");
        check_result(Res32, X"80000000", "32-bit 0x40000000 + 0x40000000");
        check_result(Res64, X"8000000000000000", "64-bit 0x4000000000000000 + 0x4000000000000000");

        report "RC Adder TB SUMMARY: Total=" & integer'image(total_count) &
               ", PASS=" & integer'image(pass_count) &
               ", FAIL=" & integer'image(fail_count) severity note;
        wait;
    end process test_16;
end Behavioral;
