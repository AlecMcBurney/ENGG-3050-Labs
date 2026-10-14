
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity cla_16b is
    Port (
        clk : in std_logic;
        addr_16 : in std_logic_vector(2 downto 0)
    );
end cla_16b;

architecture Behavioral of cla_16b is
    component carry_lookahead_adder is
        generic(
            data_width : integer := 16
        );
        Port (
            A, B   : in  std_logic_vector(data_width - 1 downto 0);
            Carry  : out std_logic;
            Sum : out std_logic_vector(data_width - 1 downto 0)
        );
    end component;
    type mem_t is array (15 downto 0) of std_logic_vector(15 downto 0);

    signal a_16, b_16, sum_16, Sum_reg : std_logic_vector(15 downto 0);
    signal cout_16, Cout_reg : std_logic;

    attribute keep : string;

    attribute keep of a_16 : signal is "TRUE";
    attribute keep of b_16 : signal is "TRUE";
    attribute keep of sum_16 : signal is "TRUE";

    signal MEM_A0 : mem_t := (
        X"FFFF",
        X"0010", 
        X"0011", 
        X"0100", 
        X"0101", 
        X"0110", 
        X"0111", 
        X"1000", 
        X"FFFF", 
        X"0010", 
        X"0011", 
        X"0100", 
        X"0101", 
        X"0110", 
        X"0111", 
        X"1000"
    );
    signal MEM_B0 : mem_t := (
        X"0000", 
        X"0010", 
        X"0100", 
        X"0110", 
        X"1000", 
        X"1010", 
        X"1100", 
        X"1110", 
        X"0000", 
        X"0010", 
        X"0100", 
        X"0110", 
        X"1000", 
        X"1010", 
        X"1100", 
        X"1110"
    );

begin
    -- Input Register Process
    process(clk)
    begin
        if rising_edge(clk) then
            A_16   <= MEM_A0(to_integer(unsigned(addr_16)));
            B_16 <= MEM_B0(to_integer(unsigned(addr_16)));
        end if;
    end process;
    
    uut_16: carry_lookahead_adder
        generic map(
            data_width => 16
        )
        port map(
            A => A_16,
            B => B_16,
            Carry => Cout_16,
            Sum => sum_16
        );
    
    process(clk)
    begin
        if rising_edge(clk) then
            Sum_reg  <= sum_16;
            Cout_reg <= Cout_16;
        end if;
    end process;
end Behavioral;