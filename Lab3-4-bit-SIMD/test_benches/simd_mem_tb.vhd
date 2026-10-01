library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity simd_mem_tb is
end simd_mem_tb;

architecture Behavioral of simd_mem_tb is 
    component simd_mem 
        generic (
            DATA_W : integer := 4;
            DEPTH  : integer := 10;
            ADDR_W : integer := 4
        );
        Port ( 
            addr0, addr1 : in  STD_LOGIC_VECTOR(3 downto 0); 
            a0, a1, b0, b1   : out STD_LOGIC_VECTOR(3 downto 0) 
        ); 
    end component; 

    signal addr0, addr1 : STD_LOGIC_VECTOR(3 downto 0) := "0000";
    signal a0,a1,b0,b1   : STD_LOGIC_VECTOR(3 downto 0); 

begin 
    uut: simd_mem 
        port map ( 
            addr0 => addr0, 
            addr1 => addr1, 
            a0   => a0, 
            a1   => a1, 
            b0   => b0, 
            b1   => b1 
        ); 

    -- Stimulus Process 
    process 
    begin 
        -- Sweep through addresses 0 to 9 to verify memory output
        for i in 0 to 9 loop
            addr0 <= std_logic_vector(to_unsigned(i, 4)); 
            addr1 <= std_logic_vector(to_unsigned(i, 4)); 
            wait for 10 ns; 
        end loop;

        wait; 
    end process; 

end Behavioral;