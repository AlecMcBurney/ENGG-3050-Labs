library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity carry_select_16bit_tb is
end carry_select_16bit_tb;

architecture Behavioral of carry_select_16bit_tb is
    component cs_adder_16bit
        Generic(
            DATA_W     : integer := 4;
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
    signal A_test     : std_logic_vector(15 downto 0) := (others => '0');
    signal B_test     : std_logic_vector(15 downto 0) := (others => '0');
    signal cIn_test   : std_logic := '0';
    signal Sum_test   : std_logic_vector(15 downto 0);
    signal Cout_test  : std_logic;

    constant CLK_PERIOD : time := 10 ns;

begin
    --test
    uut: cs_adder_16bit
        generic map(
            DATA_W     => 4,
            BLOCK_SIZE => 4
        )
        port map(
            clk  => clk_test,
            A    => A_test,
            Bin  => B_test,
            Sum  => Sum_test,
            cIn  => cIn_test,
            Cout => Cout_test
        );


    clk_process: process
    begin
        clk_test <= '0';
        wait for CLK_PERIOD / 2;
        clk_test <= '1';
        wait for CLK_PERIOD / 2;
    end process;


    stimulus_process: process
    begin
        A_test   <= x"0001";
        B_test   <= x"0000";
        wait for 100 ns;

        A_test   <= x"0003";
        B_test   <= x"0005";
        wait for 100 ns;
        
        A_test   <= x"7FFF";
        B_test   <= x"0001";
        wait for 100 ns;

        A_test   <= x"FFFF";
        B_test   <= x"0000";
        wait for 100 ns;

        A_test   <= x"4000";
        B_test   <= x"4000";
        wait for 100 ns;

        wait;
    end process stimulus_process;
end Behavioral;
