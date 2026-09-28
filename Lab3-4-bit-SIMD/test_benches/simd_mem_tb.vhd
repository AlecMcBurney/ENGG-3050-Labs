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
            clk  : in  STD_LOGIC; 
            addr : in  STD_LOGIC_VECTOR(ADDR_W-1 downto 0); 
            a0   : out STD_LOGIC_VECTOR(DATA_W-1 downto 0); 
            a1   : out STD_LOGIC_VECTOR(DATA_W-1 downto 0); 
            b0   : out STD_LOGIC_VECTOR(DATA_W-1 downto 0); 
            b1   : out STD_LOGIC_VECTOR(DATA_W-1 downto 0) 
        ); 
    end component; 

    signal clk  : STD_LOGIC := '0';
    signal addr : STD_LOGIC_VECTOR(3 downto 0) := "0000"; 
    signal a0   : STD_LOGIC_VECTOR(3 downto 0); 
    signal a1   : STD_LOGIC_VECTOR(3 downto 0); 
    signal b0   : STD_LOGIC_VECTOR(3 downto 0); 
    signal b1   : STD_LOGIC_VECTOR(3 downto 0); 

begin 
    uut: simd_mem 
        port map ( 
            clk  => clk, 
            addr => addr, 
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
            addr <= std_logic_vector(to_unsigned(i, 4)); 
            wait for 10 ns; 
        end loop;

        wait; 
    end process; 

end Behavioral;