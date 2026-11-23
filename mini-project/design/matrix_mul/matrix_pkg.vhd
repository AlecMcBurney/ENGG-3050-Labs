library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

package matrix_pkg is
    -- 6 bit inputs
    type input_3x3_6b_matrix is array (2 downto 0, 2 downto 0) of
        std_logic_vector(5 downto 0);
    type output_3x3_14b_matrix is array (2 downto 0, 2 downto 0) of
        std_logic_vector(13 downto 0);
end package matrix_pkg;
