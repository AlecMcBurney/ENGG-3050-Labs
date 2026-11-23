library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.matrix_pkg.all;

entity matrix_mul_tb is
end matrix_mul_tb;

architecture Behavioral of matrix_mul_tb is
    constant DATA_WIDTH   : positive := 6;
    constant OUTPUT_WIDTH : positive := 14;
    constant NUM_ROWS     : positive := 3;
    constant NUM_COLS     : positive := 3;

    component matrix_mul is
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
    end component;

    type integer_matrix_t is array (natural range <>, natural range <>) of natural;

    -- Edit these values to test different input matrices.
    constant MATRIX_A_VALUES : integer_matrix_t(0 to NUM_ROWS - 1, 0 to NUM_COLS - 1) := (
        (63, 63, 63),
        (63, 63, 63),
        (63, 63, 63)
    );
    constant MATRIX_B_VALUES : integer_matrix_t(0 to NUM_ROWS - 1, 0 to NUM_COLS - 1) := (
        (63, 63, 63),
        (63, 63, 63),
        (63, 63, 63)
    );

    signal matrix_a : input_3x3_6b_matrix;
    signal matrix_b : input_3x3_6b_matrix;
    signal result : output_3x3_14b_matrix;
begin
    uut: matrix_mul
        generic map (
            input_width  => DATA_WIDTH,
            output_width => OUTPUT_WIDTH,
            NUM_ROWS     => NUM_ROWS,
            NUM_COLS     => NUM_COLS
        )
        port map (
            matrix1 => matrix_a,
            matrix2 => matrix_b,
            result  => result
        );

    test_process: process
        variable expected : natural;
        variable failures : natural := 0;
    begin
        for i in 0 to NUM_ROWS - 1 loop
            for j in 0 to NUM_COLS - 1 loop
                matrix_a(i, j) <= std_logic_vector(to_unsigned(MATRIX_A_VALUES(i, j), DATA_WIDTH));
                matrix_b(i, j) <= std_logic_vector(to_unsigned(MATRIX_B_VALUES(i, j), DATA_WIDTH));
            end loop;
        end loop;

        wait for 1 ns;

        for i in 0 to NUM_ROWS - 1 loop
            for j in 0 to NUM_COLS - 1 loop
                expected := 0;
                for k in 0 to NUM_COLS - 1 loop
                    expected := expected + MATRIX_A_VALUES(i, k) * MATRIX_B_VALUES(k, j);
                end loop;

                if unsigned(result(i, j)) /= to_unsigned(expected, OUTPUT_WIDTH) then
                    failures := failures + 1;
                    report "Mismatch at result(" & integer'image(i) & "," &
                           integer'image(j) & "): expected " & integer'image(expected) &
                           ", got " & integer'image(to_integer(unsigned(result(i, j))))
                        severity error;
                end if;
            end loop;
        end loop;

        assert failures = 0
            report "Matrix multiplication test failed."
            severity failure;
        report "Matrix multiplication test passed." severity note;
        wait;
    end process;
end Behavioral;
