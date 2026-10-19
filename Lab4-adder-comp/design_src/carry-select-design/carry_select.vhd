library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity cs_adder is
    Generic(
        DATA_W     : integer := 16; -- how many blocks
        BLOCK_SIZE : integer := 4  -- How many full adders in each block
    );
    Port(
        A    : in  std_logic_vector(DATA_W * BLOCK_SIZE - 1 downto 0);
        Bin  : in  std_logic_vector(DATA_W * BLOCK_SIZE - 1 downto 0);
        cIn  : in  std_logic;
        Sum  : out std_logic_vector(DATA_W * BLOCK_SIZE - 1 downto 0);
        Cout : out std_logic
    );
end cs_adder;

architecture Structural of cs_adder is
    component full_adder is
        Port (
            FA_in1    : in  STD_LOGIC;
            FA_in2    : in  STD_LOGIC;
            Carry_in  : in  STD_LOGIC;
            Sum       : out STD_LOGIC;
            Carry_out : out STD_LOGIC
        );
    end component;

    -- Registered input signals
    --signal A_reg    : std_logic_vector(DATA_W * BLOCK_SIZE - 1 downto 0);
    --signal Bin_reg  : std_logic_vector(DATA_W * BLOCK_SIZE - 1 downto 0);
    -- signal cIn_reg  : std_logic;

    -- Combinational intermediate signals
    signal c_chain   : std_logic_vector(DATA_W downto 0);
    signal Sum_comb  : std_logic_vector(DATA_W * BLOCK_SIZE - 1 downto 0);
    signal Cout_comb : std_logic;

begin

    c_chain(0) <= cIn;

    block0_gen: block
        signal c_b0 : std_logic_vector(BLOCK_SIZE downto 0);
    begin
        c_b0(0) <= c_chain(0);

        gen_b0_FAs: for i in 0 to BLOCK_SIZE-1 generate
            fa_inst: full_adder port map (
                FA_in1    => A(i),
                FA_in2    => Bin(i),
                Carry_in  => c_b0(i),
                Sum       => Sum_comb(i),
                Carry_out => c_b0(i+1)
            );
        end generate;

        c_chain(1) <= c_b0(BLOCK_SIZE);
    end block;

    gen_cs_blocks: for b in 1 to DATA_W-1 generate
        constant base : integer := b * BLOCK_SIZE;
        signal c0_temp : std_logic_vector(BLOCK_SIZE downto 0);
        signal c1_temp : std_logic_vector(BLOCK_SIZE downto 0);
        signal s0_vec  : std_logic_vector(BLOCK_SIZE-1 downto 0);
        signal s1_vec  : std_logic_vector(BLOCK_SIZE-1 downto 0);
    begin
        c0_temp(0) <= '0';
        gen_top_row: for i in 0 to BLOCK_SIZE-1 generate
            constant idx : integer := base + i;
        begin
            fa_top: full_adder port map (
                FA_in1    => A(idx),
                FA_in2    => Bin(idx),
                Carry_in  => c0_temp(i),
                Sum       => s0_vec(i),
                Carry_out => c0_temp(i+1)
            );
        end generate;

        c1_temp(0) <= '1';
        gen_bot_row: for i in 0 to BLOCK_SIZE-1 generate
            constant idx : integer := base + i;
        begin
            fa_bot: full_adder port map (
                FA_in1    => A(idx),
                FA_in2    => Bin(idx),
                Carry_in  => c1_temp(i),
                Sum       => s1_vec(i),
                Carry_out => c1_temp(i+1)
            );
        end generate;

        gen_muxes: for i in 0 to BLOCK_SIZE-1 generate
            constant idx : integer := base + i;
        begin
            Sum_comb(idx) <= s1_vec(i) when c_chain(b) = '1' else s0_vec(i);
        end generate;

        c_chain(b+1) <= c1_temp(BLOCK_SIZE) when c_chain(b) = '1' else c0_temp(BLOCK_SIZE);
    end generate;

    Cout_comb <= c_chain(DATA_W);
    Sum  <= Sum_comb;
    Cout <= Cout_comb;


end Structural;