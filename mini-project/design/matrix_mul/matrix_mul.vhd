library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.all;
library work;
use work.matrix_pkg.all;

entity matrix_mul is
    generic (
        INPUT_WIDTH  : positive := 6;
        OUTPUT_WIDTH : positive := 14;
        NUM_ROWS     : positive := 3;
        NUM_COLS     : positive := 3
    );
    port (
        matrix1, matrix2 : in input_3x3_6b_matrix;
        result  : out output_3x3_14b_matrix
    );
end matrix_mul;

architecture Behavioral of matrix_mul is
    component multiplier_nb is
        generic(
            data_width : integer := 6
        );
        Port (
            Mul_In1 : in  std_logic_vector(data_width-1 downto 0);
            Mul_In2 : in  std_logic_vector(data_width-1 downto 0);
            Product : out  std_logic_vector(2*data_width-1 downto 0)
        );
    end component;

    component rc_adder is
        generic(
            data_width : integer := 16
        );
        Port ( A, B   : in  std_logic_vector(data_width - 1 downto 0);
            Carry  : out std_logic;
            Sum : out std_logic_vector(data_width - 1 downto 0)
        );
    end component;

    type in_matrix is array(NUM_ROWS-1 downto 0, NUM_COLS-1 downto 0) of
            std_logic_vector(INPUT_WIDTH - 1 downto 0);
    type out_matrix is array(NUM_ROWS-1 downto 0, NUM_COLS-1 downto 0) of
            std_logic_vector(OUTPUT_WIDTH - 1 downto 0);
    
    type double_in_matrix is array(NUM_ROWS-1 downto 0, NUM_COLS-1 downto 0) of
            std_logic_vector(2*INPUT_WIDTH - 1 downto 0);
    type product_stages_t is array (natural range <>) of double_in_matrix;
    type accumulator_stages_t is array (natural range <>) of output_3x3_14b_matrix;

    signal mul_result : product_stages_t(NUM_COLS - 1 downto 0);
    signal mul_result_extended : accumulator_stages_t(NUM_COLS - 1 downto 0);
    signal add_result : accumulator_stages_t(NUM_COLS downto 0);
begin
    add_result(0) <= (others => (others => (others => '0')));

    rows: for i in 0 to NUM_ROWS - 1 generate
        columns: for j in 0 to NUM_COLS - 1 generate
            inner_products: for k in 0 to NUM_COLS - 1 generate
                product: multiplier_nb
                    generic map(
                        data_width => input_width
                    )
                    port map(
                        Mul_In1 => matrix1(i, k),
                        Mul_In2 => matrix2(k, j),
                        Product => mul_result(k)(i, j)
                    );

                mul_result_extended(k)(i, j) <= std_logic_vector(
                    resize(unsigned(mul_result(k)(i, j)), output_width)
                );

                sum: rc_adder
                    generic map(
                        data_width => output_width
                    )
                    port map(
                        A => add_result(k)(i, j),
                        B => mul_result_extended(k)(i, j),
                        Carry => open,
                        Sum => add_result(k + 1)(i, j)
                    );
            end generate inner_products;
        end generate columns;
    end generate rows;

    result <= add_result(NUM_COLS);

end Behavioral;