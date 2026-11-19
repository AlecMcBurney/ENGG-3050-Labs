library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity matrix_mul is
    generic(
        data_width : integer := 6
    );
    Port (
        result : out  std_logic_vector(2*data_width-1 downto 0)
    );
end matrix_mul;

architecture Behavioral of matrix_mul is
    type matrix_col array is array (natural range <>) of
        std_logic_vector(data_width-1 downto 0);
    
    component multiplier_nb is
        generic(
            data_width : integer := 6
        );
        Port ( 
            Mul_In1 : in  std_logic_vector(data_width-1 downto 0);
            Mul_In2 : in  std_logic_vector(data_width-1 downto 0);
            Product : out  std_logic_vector(2*data_width-1 downto 0)
        );
    end

begin

    matrix1 : matrix_col(0 to 1) := (
        "000001", -- 1
        "000010"  -- 2
    );
    matrix2 : matrix_col(0 to 1) := (
        "000011", -- 3
        "000100"  -- 4
    );
    Row: for(int i = 0; i < MAT_A_ROWS; i++) {
        // Iterate over the columns of the B matrix
        Col: for(int j = 0; j < MAT_B_COLS; j++) {
            // Do the inner product of a row of A and col of B
            res[i][j] = 0;
            Product: for(int k = 0; k < MAT_B_ROWS; k++) {
                res[i][j] += a[i][k] * b[k][j];
            }
        }
    }

end Behavioral;