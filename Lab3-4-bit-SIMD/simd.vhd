library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
--	In-Datapath-Out:

entity simd_module is
	generic(
		NUM_PU : integer := 2; -- How many ALUs
		DATA_WIDTH : integer := 4 -- Width of each ALU's data paths
	);
    Port (	
		OP : in std_logic_vector(2 downto 0); -- ALU operation
        ADDR : in std_logic_vector(3 downto 0); -- Memory address
        
        A0 : out std_logic_vector(DATA_WIDTH-1 downto 0);
        B0 : out std_logic_vector(DATA_WIDTH-1 downto 0);
        A1 : out std_logic_vector(DATA_WIDTH-1 downto 0);
        B1 : out std_logic_vector(DATA_WIDTH-1 downto 0);
        Res0   : out std_logic_vector(DATA_WIDTH-1 downto 0);
        Carry0 : out std_logic;
        Res1   : out std_logic_vector(DATA_WIDTH-1 downto 0);
        Carry1 : out std_logic
	);
end simd_module;

architecture Structural of simd_module is

	--Component Declarations:

    -- 4-bit multi ALU module (2 ALUs)
	component alu_multiple
		generic (
			data_width : integer := 4
		);
		Port (
			A0 : in std_logic_vector(data_width-1 downto 0);
			B0 : in std_logic_vector(data_width-1 downto 0);
			A1 : in std_logic_vector(data_width-1 downto 0);
			B1 : in std_logic_vector(data_width-1 downto 0);
			Op : in std_logic_vector(2 downto 0);
			Res0   : out std_logic_vector(data_width-1 downto 0);
			Carry0 : out std_logic;
			Res1   : out std_logic_vector(data_width-1 downto 0);
			Carry1 : out std_logic
		);
	end component;
    
	--Memory
	component simd_mem
		generic ( DATA_W : integer := 4; DEPTH : integer := 10; ADDR_W : integer := 4 );
		port (
			addr : in  std_logic_vector(ADDR_W-1 downto 0);
			a0, b0, a1, b1 : out std_logic_vector(DATA_W-1 downto 0)
		);
	end component;

	type   vector_arr is array(NUM_PU - 1 downto 0) of std_logic_vector(DATA_WIDTH - 1 downto 0);
	type   logic_arr is array(NUM_PU - 1 downto 0) of std_logic;
	
    -- Signals
	
	-- Signals for 4-bit ALU
   	signal res : vector_arr; -- ALU outputs
	signal carry : logic_arr; -- ALU carry out

	--Memory Signals
	constant LAST_ADDR : integer := 9;                 -- 10 values per memory (0..9)
	signal mem_a, mem_b : vector_arr;

begin
	memories: simd_mem
        generic map( 
            DATA_W => DATA_WIDTH, 
            ADDR_W => 4
        )
        port map( 
            addr => addr,
            a0 => mem_a(0), 
            b0 => mem_b(0),
            a1 => mem_a(1), 
            b1 => mem_b(1) 
        );
	alus: alu_multiple
		generic map(
			data_width => DATA_WIDTH
		)
		port map(
			a0 => mem_a(0), 
            b0 => mem_b(0),
            a1 => mem_a(1), 
            b1 => mem_b(1),
			Op => OP,
			Res0   => Res0,
			Carry0 => carry0,
			Res1   => Res1,
			Carry1 => carry1
		);
    a0 <= mem_a(0); 
    b0 <= mem_b(0);
    a1 <= mem_a(1); 
    b1 <= mem_b(1);
end Structural;