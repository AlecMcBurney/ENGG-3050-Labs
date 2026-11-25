library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.matrix_pkg.all;

entity matrix_mux_tb is
end matrix_mux_tb;

architecture Behavioral of matrix_mux_tb is
    type integer_matrix_t is array (0 to 2, 0 to 2) of natural;

    constant M0_VALUES : integer_matrix_t := (
        (1, 2, 3),
        (4, 5, 6),
        (7, 8, 9)
    );
    constant M1_VALUES : integer_matrix_t := (
        (11, 12, 13),
        (14, 15, 16),
        (17, 18, 19)
    );
    constant M2_VALUES : integer_matrix_t := (
        (101, 202, 303),
        (404, 505, 606),
        (707, 808, 909)
    );

    signal matrix0 : input_3x3_6b_matrix;
    signal matrix1 : input_3x3_6b_matrix;
    signal matrix2 : output_3x3_14b_matrix;
    signal row_sel, col_sel : std_logic_vector(1 downto 0) := (others => '0');
    signal matrix0_out, matrix1_out : std_logic_vector(5 downto 0);
    signal matrix2_out : std_logic_vector(13 downto 0);
begin
    uut: entity work.matrix_mux_3x3
        port map (
            M0      => matrix0,
            M1      => matrix1,
            M2      => matrix2,
            row_sel => row_sel,
            col_sel => col_sel,
            M0_out  => matrix0_out,
            M1_out  => matrix1_out,
            M2_out  => matrix2_out
        );

    test_process: process
        variable failures : natural := 0;
    begin
        for row in 0 to 2 loop
            for col in 0 to 2 loop
                matrix0(row, col) <= std_logic_vector(to_unsigned(M0_VALUES(row, col), matrix0(row, col)'length));
                matrix1(row, col) <= std_logic_vector(to_unsigned(M1_VALUES(row, col), matrix1(row, col)'length));
                matrix2(row, col) <= std_logic_vector(to_unsigned(M2_VALUES(row, col), matrix2(row, col)'length));
            end loop;
        end loop;

        wait for 1 ns;

        for row in 0 to 2 loop
            for col in 0 to 2 loop
                row_sel <= std_logic_vector(to_unsigned(row, row_sel'length));
                col_sel <= std_logic_vector(to_unsigned(col, col_sel'length));
                wait for 10 ns;

                if unsigned(matrix0_out) /= to_unsigned(M0_VALUES(row, col), matrix0_out'length) then
                    failures := failures + 1;
                    report "M0 mismatch at (" & integer'image(row) & "," &
                           integer'image(col) & ")"
                        severity error;
                end if;
                if unsigned(matrix1_out) /= to_unsigned(M1_VALUES(row, col), matrix1_out'length) then
                    failures := failures + 1;
                    report "M1 mismatch at (" & integer'image(row) & "," &
                           integer'image(col) & ")"
                        severity error;
                end if;
                if unsigned(matrix2_out) /= to_unsigned(M2_VALUES(row, col), matrix2_out'length) then
                    failures := failures + 1;
                    report "M2 mismatch at (" & integer'image(row) & "," &
                           integer'image(col) & ")"
                        severity error;
                end if;
            end loop;
        end loop;

        assert failures = 0
            report "Matrix mux test failed with " & integer'image(failures) & " mismatches."
            severity failure;
        report "Matrix mux test passed for all 9 elements." severity note;
        wait;
    end process;
end Behavioral;
