library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

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
        ADDR : in std_logic_vector(3 downto 0);

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
signal ADDR : std_logic_vector(3 downto 0);
signal C0, C1   : std_logic;
signal Res0, Res1    : std_logic_vector(3 downto 0);

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
    uut: simd_module
        generic map(
            NUM_PU => 2,
            DATA_WIDTH => 4
        )
        
        port map(
            OP => OP,
            ADDR => ADDR,

            A0 => A0,
            B0 => B0,
            A1 => A1,
            B1 => B1,

            Res0 => Res0,
            Carry0 => Carry0,

            Res1 => Res1,
            Carry1 => Carry1
        );

    test_bench: process
    begin
       ADDR <= "0000"; -- A0 = 0001, B0 = 0000, A1 = 1010, B1 = 0001
       
       -- 000: A + B
       OP <= "000";
       wait for 100 ns;

       -- 001: A - B
        OP <= "001";
        wait for 100 ns;


        -- 010: not A + B
        OP <= "010";
        wait for 100 ns;


        -- 011: B - A
        OP <= "011";
        wait for 100 ns;


        -- 100: A - 1
        OP <= "100";
        wait for 100 ns;


        -- 101: A + 1
        OP <= "101";
        wait for 100 ns;


        -- 110: not A
        OP <= "110";
        wait for 100 ns;


        -- 111: not A + 1
        OP <= "111";
        wait for 100 ns;

        ADDR <= "0001"; -- A0 = 0001, B0 = 0000, A1 = 1010, B1 = 0001

        -- A + B
        OP <= "000";
        wait for 100 ns;

        -- A - B
        OP <= "001";
        wait for 100 ns;

        ADDR <= "0010"; -- A0 = 0010, B0 = 0010, A1 = 1001, B1 = 0011

        -- A + B
        OP <= "000";
        wait for 100 ns;

        -- B - A
        OP <= "011";
        wait for 100 ns;

        ADDR <= "0011"; -- A0 = 0011, B0 = 0100, A1 = 1000, B1 = 0101

        -- Increment
        OP <= "101";
        wait for 100 ns;

        ADDR <= "0100"; -- A0 = 0100, B0 = 0110, A1 = 0111, B1 = 0111

        -- Decrement
        OP <= "100";
        wait for 100 ns;

        ADDR <= "0101"; -- A0 = 0101, B0 = 1000, A1 = 0110, B1 = 1001

        -- 1's complement
        OP <= "110";
        wait for 100 ns;

        ADDR <= "0110"; -- A0 = 0110, B0 = 1010, A1 = 0101, B1 = 1011

        -- 2's complement
        OP <= "111";
        wait for 100 ns;

        ADDR <= "0111"; -- A0 = 0111, B0 = 1100, A1 = 0100, B1 = 1101

        OP <= "000";
        wait for 100 ns;

        ADDR <= "1000"; -- A0 = 1000, B0 = 1110, A1 = 0011, B1 = 0000

        OP <= "000";
        wait for 100 ns;

        ADDR <= "1001"; -- A0 = 1001, B0 = 1111, A1 = 0010, B1 = 0001

        OP <= "000";
        wait for 100 ns;

        ADDR <= "1010"; -- A0 = 1010, B0 = 1101, A1 = 0001, B1 = 0011

        OP <= "000";
        wait for 100 ns;

        wait;
    end process test_bench;
end Behavioral;