library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity result_tb is
end result_tb;

architecture Behavioral of result_tb is
    component carry_select_16bit
        Generic(
            DATA_W     : integer := 16;
            BLOCK_SIZE : integer := 4
        );
        Port(
            clk  : in  std_logic;
            A    : in  std_logic_vector(DATA_W * BLOCK_SIZE - 1 downto 0);
            Bin  : in  std_logic_vector(DATA_W * BLOCK_SIZE - 1 downto 0);
            cIn  : in  std_logic;
            Sum  : out std_logic_vector(DATA_W * BLOCK_SIZE - 1 downto 0);
            Cout : out std_logic
        );
    end component;

    -- Testbench signals
    signal clk_test   : std_logic := '0';
    signal A_test     : std_logic_vector(63 downto 0) := (others => '0');
    signal B_test     : std_logic_vector(63 downto 0) := (others => '0');
    signal cIn_test   : std_logic := '0';
    signal Sum_test   : std_logic_vector(63 downto 0);
    signal Cout_test  : std_logic;

    -- Clock period constant (e.g., 10 ns -> 100 MHz)
    constant CLK_PERIOD : time := 10 ns;

begin

    -- Instantiate the Unit Under Test (UUT)
    uut: carry_select_16bit
        port map(
            clk  => clk_test,
            A    => A_test,
            Bin  => B_test,
            Sum  => Sum_test,
            cIn  => cIn_test,
            Cout => Cout_test
        );

    -- Clock Generation Process
    clk_process: process
    begin
        clk_test <= '0';
        wait for CLK_PERIOD / 2;
        clk_test <= '1';
        wait for CLK_PERIOD / 2;
    end process;

    -- Stimulus Process
    result_tb: process
    begin
        -- Apply reset initially
        A_test   <= (others => '0');
        B_test   <= (others => '0');
        cIn_test <= '0';
        wait for 20 ns;
       

        A_test   <= x"0000000000000000";
        B_test   <= x"0000000000000000";
        cIn_test <= '0';
        wait for 100 ns;

        A_test   <= x"FFFFFFFFFFFFFFFF";
        B_test   <= x"FFFFFFFFFFFFFFFF";
        cIn_test <= '0';
        wait for 100 ns;
        
        A_test   <= x"FFFFFFFFFFFFFFFF";
        B_test   <= x"FFFFFFFFFFFFFFFF";
        cIn_test <= '1';
        wait for 100 ns;

        A_test   <= x"AAAAAAAAAAAAAAAA";
        B_test   <= x"1111111111111111";
        cIn_test <= '0';
        wait for 100 ns;

        A_test   <= x"AAAAAAAAAAAAAAAA";
        B_test   <= x"BBBBBBBBBBBBBBBB";
        cIn_test <= '0';
        wait for 100 ns;

        A_test   <= x"FFFFFFFFFFFFFFFF";
        B_test   <= x"0000000000000000";
        cIn_test <= '1';
        wait for 100 ns;

        A_test   <= x"FFFFFFFFFFFFFFFF";
        B_test   <= x"1000000000000000";
        cIn_test <= '0';
        wait for 100 ns;

        wait;
    end process result_tb;
end Behavioral;
