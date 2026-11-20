library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

package matrix_pkg is
    type input_matrix_t is array (natural range <>, natural range <>) of
        std_logic_vector;
    type output_matrix_t is array (natural range <>, natural range <>) of
        std_logic_vector;
end package matrix_pkg;
