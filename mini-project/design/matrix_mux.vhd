library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.matrix_pkg.all;

entity matrix_mux_3x3 is
    Port (	
        M0, M1 : in input_3x3_6b_matrix;
        M2 : in output_3x3_14b_matrix;
        
        row_sel, col_sel : in  std_logic_vector(1 downto 0);
        
        M0_out, M1_out : out std_logic_vector(5 downto 0);
        M2_out : out std_logic_vector(13 downto 0)
    );
end matrix_mux_3x3;

architecture Behavioral of matrix_mux_3x3 is
begin
    process(row_sel, col_sel, M0, M1, M2)
    begin
        M0_out <= (others => '0');
        M1_out <= (others => '0');
        M2_out <= (others => '0');

        case row_sel & col_sel is
            when "0000" =>
                M0_out <= M0(0, 0);
                M1_out <= M1(0, 0);
                M2_out <= M2(0, 0);
            when "0001" =>
                M0_out <= M0(0, 1);
                M1_out <= M1(0, 1);
                M2_out <= M2(0, 1);
            when "0010" =>
                M0_out <= M0(0, 2);
                M1_out <= M1(0, 2);
                M2_out <= M2(0, 2);
            when "0100" =>
                M0_out <= M0(1, 0);
                M1_out <= M1(1, 0);
                M2_out <= M2(1, 0);
            when "0101" =>
                M0_out <= M0(1, 1);
                M1_out <= M1(1, 1);
                M2_out <= M2(1, 1);
            when "0110" =>
                M0_out <= M0(1, 2);
                M1_out <= M1(1, 2);
                M2_out <= M2(1, 2);
            when "1000" =>
                M0_out <= M0(2, 0);
                M1_out <= M1(2, 0);
                M2_out <= M2(2, 0);
            when "1001" =>
                M0_out <= M0(2, 1);
                M1_out <= M1(2, 1);
                M2_out <= M2(2, 1);
            when "1010" =>
                M0_out <= M0(2, 2);
                M1_out <= M1(2, 2);
                M2_out <= M2(2, 2);
            when others =>
                M0_out <= (others => '0');
                M1_out <= (others => '0');
                M2_out <= (others => '0');
        end case;
    end process;
end Behavioral;
