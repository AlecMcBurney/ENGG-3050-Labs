library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity cs_adder_64bit is
    Generic(
        DATA_W     : integer := 16; -- how many blocks
        BLOCK_SIZE : integer := 4  -- How many full adders in each block
    );
    Port(
        clk  : in  std_logic;
        A    : in  std_logic_vector(DATA_W * BLOCK_SIZE - 1 downto 0);
        Bin  : in  std_logic_vector(DATA_W * BLOCK_SIZE - 1 downto 0);
        cIn  : in  std_logic;
        Sum  : out std_logic_vector(DATA_W * BLOCK_SIZE - 1 downto 0);
        Cout : out std_logic
    );
end cs_adder_64bit;

architecture Structural of cs_adder_64bit is
    component cs_adder is
        generic(
            DATA_W     : integer := 16; -- how many blocks
            BLOCK_SIZE : integer := 4  -- How many full adders in each block
        );
        Port (
            A    : in  std_logic_vector(DATA_W * BLOCK_SIZE - 1 downto 0);
            Bin    : in  std_logic_vector(DATA_W * BLOCK_SIZE - 1 downto 0);
            cIn  : in  std_logic;
            Sum       : out std_logic_vector(DATA_W * BLOCK_SIZE - 1 downto 0);
            Cout : out std_logic
        );
    end component;

    -- Registered input signals
    signal A_reg    : std_logic_vector(DATA_W * BLOCK_SIZE - 1 downto 0);
    signal Bin_reg  : std_logic_vector(DATA_W * BLOCK_SIZE - 1 downto 0);
    signal cIn_reg  : std_logic;

    -- Combinational intermediate signals
    signal c_chain   : std_logic_vector(DATA_W downto 0);
    signal Sum_comb  : std_logic_vector(DATA_W * BLOCK_SIZE - 1 downto 0);
    signal Cout_comb : std_logic;

begin

    -- Input Register Process
    process(clk)
    begin
        if rising_edge(clk) then
            A_reg   <= A;
            Bin_reg <= Bin;
            cIn_reg <= cIn;
        end if;
    end process;

    uut: cs_adder
        generic map(
            DATA_W     => DATA_W,
            BLOCK_SIZE => BLOCK_SIZE
        )
        port map(
            A    => A_reg,
            Bin  => Bin_reg,
            cIn  => cIn_reg,
            Sum  => Sum_comb,
            Cout => Cout_comb
        );

   

    -- Output Register Process
    process(clk)
    begin
        if rising_edge(clk) then
            Sum  <= Sum_comb;
            Cout <= Cout_comb;
        end if;
    end process;

end Structural;