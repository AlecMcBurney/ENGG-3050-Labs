library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity simd_full_tb is
end simd_full_tb;

architecture Behavioral of simd_full_tb is
component simd_module is
    generic(
        NUM_PU : integer := 2;
        DATA_WIDTH : integer := 4
    );
    
    Port (
        OP   : in std_logic_vector(2 downto 0);
        ADDR0 : in std_logic_vector(3 downto 0); -- Memory address0
        ADDR1 : in std_logic_vector(3 downto 0); -- Memory address1

        A0 : out std_logic_vector(DATA_WIDTH-1 downto 0);
        B0 : out std_logic_vector(DATA_WIDTH-1 downto 0);
        A1 : out std_logic_vector(DATA_WIDTH-1 downto 0);
        B1 : out std_logic_vector(DATA_WIDTH-1 downto 0);
        Res0   : out std_logic_vector(DATA_WIDTH-1 downto 0);
        Carry0 : out std_logic;
        Res1   : out std_logic_vector(DATA_WIDTH-1 downto 0);
        Carry1 : out std_logic
    );
end component;

signal A0, B0, A1, B1 : std_logic_vector(3 downto 0);
signal Op   : std_logic_vector(2 downto 0);
signal ADDR0 : std_logic_vector(3 downto 0);
signal C0, C1   : std_logic;
signal Res0, Res1    : std_logic_vector(3 downto 0);

shared variable pass_count, fail_count, total_count : integer := 0;

procedure check_result(
    constant actual     : in std_logic_vector(3 downto 0);
    constant expected   : in std_logic_vector(3 downto 0);
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
    -- Addr = 0:
    -- A0 ("0001"); -- d=1, h=0x1
    -- B0 ("0000"); -- d=0, h=0x0
    -- A1 ("1010"); -- d=10, h=0xA
    -- B1 ("0001"); -- d=1, h=0x1
    -- Addr = 1:
    -- A0 ("0010"); -- d=2, h=0x2
    -- B0 ("0010"); -- d=2, h=0x2
    -- A1 ("1001"); -- d=9, h=0x9
    -- B1 ("0011"); -- d=3, h=0x3
    -- Addr = 2:
    -- A0 ("0011"); -- d=3, h=0x3
    -- B0 ("0100"); -- d=4, h=0x4
    -- A1 ("1000"); -- d=8, h=0x8
    -- B1 ("0101"); -- d=5, h=0x5
    -- Addr = 3:
    -- A0 ("0100"); -- d=4, h=0x4
    -- B0 ("0110"); -- d=6, h=0x6
    -- A1 ("0111"); -- d=7, h=0x7
    -- B1 ("0111"); -- d=7, h=0x7
    -- Addr = 4:
    -- A0 ("0101"); -- d=5, h=0x5
    -- B0 ("1000"); -- d=8, h=0x8
    -- A1 ("0110"); -- d=6, h=0x6
    -- B1 ("1001"); -- d=9, h=0x9
    -- Addr = 5:
    -- A0 ("0110"); -- d=6, h=0x6
    -- B0 ("1010"); -- d=10, h=0xA
    -- A1 ("0101"); -- d=5, h=0x5
    -- B1 ("1011"); -- d=11, h=0xB
    -- Addr = 6:
    -- A0 ("0111"); -- d=7, h=0x7
    -- B0 ("1100"); -- d=12, h=0xC
    -- A1 ("0100"); -- d=4, h=0x4
    -- B1 ("1101"); -- d=13, h=0xD
    -- Addr = 7:
    -- A0 ("1000"); -- d=8, h=0x8
    -- B0 ("1110"); -- d=14, h=0xE
    -- A1 ("0011"); -- d=3, h=0x3
    -- B1 ("0000"); -- d=0, h=0x0
    -- Addr = 8:
    -- A0 ("1001"); -- d=9, h=0x9
    -- B0 ("1111"); -- d=15, h=0xF
    -- A1 ("0010"); -- d=2, h=0x2
    -- B1 ("0001"); -- d=1, h=0x1
    -- Addr = 9:
    -- A0 ("1010"); -- d=10, h=0xA
    -- B0 ("1101"); -- d=13, h=0xD
    -- A1 ("0001"); -- d=1, h=0x1
    -- B1 ("0011"); -- d=3, h=0x3
    uut: simd_module
        generic map(
            NUM_PU => 2,
            DATA_WIDTH => 4
        )
        
        port map(
            OP => OP,
            ADDR0 => ADDR0,
            ADDR1 => ADDR0,

            A0 => A0,
            B0 => B0,
            A1 => A1,
            B1 => B1,

            Res0 => Res0,
            Carry0 => C0,

            Res1 => Res1,
            Carry1 => C1
        );

    test_bench: process
    begin
        ADDR0 <= "0000";
        -- A0 ("0001"); -- d=1, h=0x1
        -- B0 ("0000"); -- d=0, h=0x0
        -- A1 ("1010"); -- d=10, h=0xA
        -- B1 ("0001"); -- d=1, h=0x1
       
        -- 000: A + B
        OP <= "000";
        -- 0: 1+0=1
        -- 1: 10+1=11 (B)
        wait for 100 ns;
        check_result(Res0, "0001", "Test ADDR=0,OP=000: A0 + B0");
        check_result(Res1, "1011", "Test ADDR=0,OP=000: A1 + B1");
        

        -- 001: A - B
        OP <= "001";
        -- 0: 1-0=1
        -- 1: 10-1=9 (9)
        wait for 100 ns;
        check_result(Res0, "0001", "Test ADDR=0,OP=001: A0 - B0");
        check_result(Res1, "1001", "Test ADDR=0,OP=001: A1 - B1");

        -- 010: not A + B
        OP <= "010";
        -- 0: 14+0=14 (E)
        -- 1: 5+1=6 (6)
        wait for 100 ns;
        check_result(Res0, "1110", "Test ADDR=0,OP=010: not A0 + B0");
        check_result(Res1, "0110", "Test ADDR=0,OP=010: not A1 + B1");

        -- 011: B - A
        OP <= "011";
        -- 0: 0-1=15 (F) + overflow (1)
        -- 1: 1-10=-9 (7) + overflow (1)
        wait for 100 ns;
        check_result(Res0, "1111", "Test ADDR=0,OP=011: B0 - A0");
        check_result(Res1, "0111", "Test ADDR=0,OP=011: B1 - A1");


        -- 100: A - 1
        OP <= "100";
        -- 0: 1-1=0
        -- 1: 10-1=9 (9)
        wait for 100 ns;
        check_result(Res0, "0000", "Test ADDR=0,OP=100: A0 - 1");
        check_result(Res1, "1001", "Test ADDR=0,OP=100: A1 - 1");


        -- 101: A + 1
        OP <= "101";
        -- 0: 1+1=2 (2)
        -- 1: 10+1=11 (B)
        wait for 100 ns;
        check_result(Res0, "0010", "Test ADDR=0,OP=101: A0 + 1");
        check_result(Res1, "1011", "Test ADDR=0,OP=101: A1 + 1");

        -- 110: not A
        OP <= "110";
        -- 0: ~1=E
        -- 1: ~10=5
        wait for 100 ns;
        check_result(Res0, "1110", "Test ADDR=0,OP=110: not A0");
        check_result(Res1, "0101", "Test ADDR=0,OP=110: not A1");

        -- 111: not A + 1
        OP <= "111";
        -- 0: ~1+1=F
        -- 1: ~10+1=6
        wait for 100 ns;
        check_result(Res0, "1111", "Test ADDR=0,OP=111: not A0 + 1");
        check_result(Res1, "0110", "Test ADDR=0,OP=111: not A1 + 1");

        ADDR0 <= "0001";
        -- A0 ("0010"); -- d=2, h=0x2
        -- B0 ("0010"); -- d=2, h=0x2
        -- A1 ("1001"); -- d=9, h=0x9
        -- B1 ("0011"); -- d=3, h=0x3

        -- A + B
        OP <= "000";
        -- 2 + 2 = 4 (4)
        -- 9 + 3 = 12 (C)
        wait for 100 ns;
        check_result(Res0, "0100", "Test ADDR=1,OP=000: A0 + B0");
        check_result(Res1, "1100", "Test ADDR=1,OP=000: A1 + B1");

        -- A - B
        OP <= "001";
        -- 2 - 2 = 0 (0)
        -- 9 - 3 = 6 (6)
        wait for 100 ns;
        check_result(Res0, "0000", "Test ADDR=1,OP=001: A0 - B0");
        check_result(Res1, "0110", "Test ADDR=1,OP=001: A1 - B1");

        ADDR0 <= "0010";
        -- A0 ("0011"); -- d=3, h=0x3
        -- B0 ("0100"); -- d=4, h=0x4
        -- A1 ("1000"); -- d=8, h=0x8
        -- B1 ("0101"); -- d=5, h=0x5

        -- A + B
        OP <= "000";
        -- 3 + 4 = 7 (7)
        -- 8 + 5 = 13 (D)
        wait for 100 ns;
        check_result(Res0, "0111", "Test ADDR=2,OP=000: A0 + B0");
        check_result(Res1, "1101", "Test ADDR=2,OP=000: A1 + B1");

        -- B - A
        OP <= "011";
        -- 4 - 3 = 1 (1)
        -- 5 - 8 = -3 => 13 (D)
        wait for 100 ns;
        check_result(Res0, "0001", "Test ADDR=2,OP=011: B0 - A0");
        check_result(Res1, "1101", "Test ADDR=2,OP=011: B1 - A1");

        ADDR0 <= "0011";
        -- A0 ("0100"); -- d=4, h=0x4
        -- B0 ("0110"); -- d=6, h=0x6
        -- A1 ("0111"); -- d=7, h=0x7
        -- B1 ("0111"); -- d=7, h=0x7

        -- Increment
        OP <= "101";
        -- 4 + 1 = 5 (5)
        -- 7 + 1 = 8 (8)
        wait for 100 ns;
        check_result(Res0, "0101", "Test ADDR=3,OP=101: A0 + 1");
        check_result(Res1, "1000", "Test ADDR=3,OP=101: A1 + 1");

        ADDR0 <= "0100";
        -- A0 ("0101"); -- d=5, h=0x5
        -- B0 ("1000"); -- d=8, h=0x8
        -- A1 ("0110"); -- d=6, h=0x6
        -- B1 ("1001"); -- d=9, h=0x9

        -- Decrement
        OP <= "100";
        -- 5 - 1 = 4 (4)
        -- 6 - 1 = 5 (5)
        wait for 100 ns;
        check_result(Res0, "0100", "Test ADDR=4,OP=100: A0 - 1");
        check_result(Res1, "0101", "Test ADDR=4,OP=100: A1 - 1");

        ADDR0 <= "0101";
        -- A0 ("0110"); -- d=6, h=0x6
        -- B0 ("1010"); -- d=10, h=0xA
        -- A1 ("0101"); -- d=5, h=0x5
        -- B1 ("1011"); -- d=11, h=0xB

        -- 1's complement
        OP <= "110";
        -- ~6 = 9 (9)
        -- ~5 = 10 (A)
        wait for 100 ns;
        check_result(Res0, "1001", "Test ADDR=5,OP=110: not A0");
        check_result(Res1, "1010", "Test ADDR=5,OP=110: not A1");

        ADDR0 <= "0110";
        -- A0 ("0111"); -- d=7, h=0x7
        -- B0 ("1100"); -- d=12, h=0xC
        -- A1 ("0100"); -- d=4, h=0x4
        -- B1 ("1101"); -- d=13, h=0xD

        -- 2's complement
        OP <= "111";
        -- ~7 + 1 = 9 (9)
        -- ~4 + 1 = 12 (C)
        wait for 100 ns;
        check_result(Res0, "1001", "Test ADDR=6,OP=111: not A0 + 1");
        check_result(Res1, "1100", "Test ADDR=6,OP=111: not A1 + 1");

        ADDR0 <= "0111";
        -- A0 ("1000"); -- d=8, h=0x8
        -- B0 ("1110"); -- d=14, h=0xE
        -- A1 ("0011"); -- d=3, h=0x3
        -- B1 ("0000"); -- d=0, h=0x0

        OP <= "000";
        -- 8 + 14 = 22 => 0110
        -- 3 + 0 = 3
        wait for 100 ns;
        check_result(Res0, "0110", "Test ADDR=7,OP=000: A0 + B0");
        check_result(Res1, "0011", "Test ADDR=7,OP=000: A1 + B1");

        ADDR0 <= "1000";
        -- A0 ("1001"); -- d=9, h=0x9
        -- B0 ("1111"); -- d=15, h=0xF
        -- A1 ("0010"); -- d=2, h=0x2
        -- B1 ("0001"); -- d=1, h=0x1

        OP <= "011";
        -- 15 - 9 = 6 (6)
        -- 1 - 2 = -1 => 15 (F)
        wait for 100 ns;
        check_result(Res0, "0110", "Test ADDR=8,OP=011: B0 - A0");
        check_result(Res1, "1111", "Test ADDR=8,OP=011: B1 - A1");

        ADDR0 <= "1001";
        -- A0 ("1010"); -- d=10, h=0xA
        -- B0 ("1101"); -- d=13, h=0xD
        -- A1 ("0001"); -- d=1, h=0x1
        -- B1 ("0011"); -- d=3, h=0x3

        OP <= "000";
        -- 10 + 13 = 23 => 0111
        -- 1 + 3 = 4 (4)
        wait for 100 ns;
        check_result(Res0, "0111", "Test ADDR=9,OP=000: A0 + B0");
        check_result(Res1, "0100", "Test ADDR=9,OP=000: A1 + B1");

        report "SIMD TB SUMMARY: Total=" & integer'image(total_count) &
               ", PASS=" & integer'image(pass_count) &
               ", FAIL=" & integer'image(fail_count) severity note;
        wait;
    end process test_bench;
end Behavioral;