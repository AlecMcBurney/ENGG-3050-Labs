library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity simd_mem is
    generic (
        DATA_W : integer := 4;    -- width of each stored word (must match four_bit_alu)
        DEPTH  : integer := 10;   -- how many words each memory holds (8-10 required) (Number of addresses)
        ADDR_W : integer := 4     -- width of the shared address bus
    );
    port (                  
        addr   : in  std_logic_vector(ADDR_W-1 downto 0);   -- from control unit (data pointer)
        -- operands for ALU 0
        a0     : out std_logic_vector(DATA_W-1 downto 0);
        b0     : out std_logic_vector(DATA_W-1 downto 0);
        -- operands for ALU 1
        a1     : out std_logic_vector(DATA_W-1 downto 0);
        b1     : out std_logic_vector(DATA_W-1 downto 0)
    );
end simd_mem;

architecture Behavioral of simd_mem is
    -- The register file's storage type: an array of DEPTH words, each DATA_W bits wide.
    type mem_t is array (0 to DEPTH-1) of std_logic_vector(DATA_W-1 downto 0);


    signal MEM_A0 : mem_t := ("0001", "0010", "0011", "0100", "0101", "0110", "0111", "1000", "1001", "1010");
    signal MEM_B0 : mem_t := ("0000", "0010", "0100", "0110", "1000", "1010", "1100", "1110", "1111", "1101");

    signal MEM_A1 : mem_t := ("1010", "1001", "1000", "0111", "0110", "0101", "0100", "0011", "0010", "0001");
    signal MEM_B1 : mem_t := ("0001", "0011", "0101", "0111", "1001", "1011", "1101", "0000", "0001", "0011");
begin
    a0 <= MEM_A0(to_integer(unsigned(addr)));
    a1 <= MEM_A1(to_integer(unsigned(addr)));
    b0 <= MEM_B0(to_integer(unsigned(addr)));
    b1 <= MEM_B1(to_integer(unsigned(addr)));
end Behavioral;



