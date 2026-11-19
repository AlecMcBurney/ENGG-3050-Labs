library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity mul_tb is
end mul_tb;

architecture Behavioral of mul_tb is
    constant DATA_WIDTH : positive := 6;

    signal Mul_In1 : std_logic_vector(DATA_WIDTH-1 downto 0) := (others => '0');
    signal Mul_In2 : std_logic_vector(DATA_WIDTH-1 downto 0) := (others => '0');
    signal Product : std_logic_vector(2*DATA_WIDTH-1 downto 0);

    component multiplier_nb is
        generic(
            data_width : integer := 6
        );
        Port ( 
            Mul_In1 : in  std_logic_vector(data_width-1 downto 0);
            Mul_In2 : in  std_logic_vector(data_width-1 downto 0);
            Product : out  std_logic_vector(2*data_width-1 downto 0));
    end component;
begin
    uut: multiplier_nb
        generic map(
            data_width => DATA_WIDTH
        )
        port map(
            Mul_In1 => Mul_In1,
            Mul_In2 => Mul_In2,
            Product => Product
        );

    test_process: process
        variable total_count : integer := 0;
        variable pass_count : integer := 0;
        variable fail_count : integer := 0;
    begin
        for a in 0 to 2**DATA_WIDTH-1 loop
            for b in 0 to 2**DATA_WIDTH-1 loop
                Mul_In1 <= std_logic_vector(to_unsigned(a, DATA_WIDTH));
                Mul_In2 <= std_logic_vector(to_unsigned(b, DATA_WIDTH));
                wait for 1 ns;

                total_count := total_count + 1;
                if unsigned(Product) = to_unsigned(a*b, Product'length) then
                    pass_count := pass_count + 1;
                else
                    fail_count := fail_count + 1;
                    if fail_count = 1 then
                        report "Incorrect product for " & integer'image(a) & " * " &
                               integer'image(b)
                            severity note;
                    end if;
                end if;
                wait for 10 ns;
            end loop;
        end loop;

        report "Multiplier tests: Total=" & integer'image(total_count) &
               ", PASS=" & integer'image(pass_count) &
               ", FAIL=" & integer'image(fail_count)
            severity note;
        assert fail_count = 0
            report "Multiplier testbench detected failures."
            severity failure;
        wait;
    end process;
end Behavioral;
