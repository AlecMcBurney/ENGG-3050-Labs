library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity cla_16b_tb is
end cla_16b_tb;

architecture Behavioral of cla_16b_tb is
    component cla_16b is
        Port (
            clk : in std_logic;
            addr_16 : in std_logic_vector(2 downto 0)
        );
    end component;

    -- Testbench signals
    signal clk_test   : std_logic := '0';
    signal addr_16    : std_logic_vector(2 downto 0) := "000";

    -- Clock period constant (e.g., 10 ns -> 100 MHz)
    constant CLK_PERIOD : time := 10 ns;

begin

    -- Instantiate the Unit Under Test (UUT)
    uut: cla_16b
        port map(
            clk  => clk_test,
            addr_16 => addr_16
        );

    -- Clock Generation Process
    clk_process: process
    begin
        clk_test <= '0';
        wait for CLK_PERIOD / 2;
        clk_test <= '1';
        wait for CLK_PERIOD / 2;
        case addr_16 is				
            when "000" => addr_16 <= "001";
            when "001" => addr_16 <= "010";
            when "010" => addr_16 <= "011";
            when "011" => addr_16 <= "100";
            when "100" => addr_16 <= "101";
            when "101" => addr_16 <= "110";
            when "110" => addr_16 <= "111";
            when "111" => addr_16 <= "000";
            when others => addr_16 <= "000";
        end case;
    end process;

    -- Stimulus Process
    result_tb: process
    begin
        wait;
    end process result_tb;
end Behavioral;
