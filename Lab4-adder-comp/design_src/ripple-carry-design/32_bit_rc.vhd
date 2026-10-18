library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity rc_32b is
    Port ( 
        A32, B32   : in  std_logic_vector(31 downto 0);
        clk  : in  std_logic;
        Carry  : out std_logic;
        Sum32 : out std_logic_vector(31 downto 0)
    );
end rc_32b;

architecture Behavioral of rc_32b is
    component rc_adder is
        generic(
            data_width : integer := 16
        );
        Port ( A, B   : in  std_logic_vector(data_width - 1 downto 0);
            Carry  : out std_logic;
            Sum : out std_logic_vector(data_width - 1 downto 0)
        );
    end component;

    -- Registered signals
    signal A_reg, B_reg, Sum_reg, sum_tmp    : std_logic_vector(31 downto 0);
    signal Carry_reg, carry_tmp  : std_logic;

begin
    -- Input Register Process
    process(clk)
    begin
        if rising_edge(clk) then
            A_reg   <= A32;
            B_reg <= B32;
        end if;
    end process;
    
    uut_16: rc_adder
        generic map(
            data_width => 32
        )
        port map(
            A => A_reg,
            B => B_reg,
            Carry => carry_tmp,
            Sum => sum_tmp
        );
    
    -- Output Register Process
    process(clk)
    begin
        if rising_edge(clk) then
            Sum_reg  <= sum_tmp;
            Carry_reg <= carry_tmp;
        end if;
    end process;
    Sum32 <= Sum_reg;
    Carry <= Carry_reg;
end Behavioral;
