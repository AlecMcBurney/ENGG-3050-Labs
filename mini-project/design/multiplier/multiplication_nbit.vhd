library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity multiplier_nb is
    generic(
        data_width : integer := 6
    );
    Port ( 
        Mul_In1 : in  std_logic_vector(data_width-1 downto 0);
        Mul_In2 : in  std_logic_vector(data_width-1 downto 0);
        Product : out  std_logic_vector(2*data_width-1 downto 0));
end multiplier_nb;

architecture Behavioral of multiplier_nb is
    -- natural range <> allows the signal to decide dimension of array on declaration
    -- natural restricts range value to nonnegative integers
    type product_array is array (natural range <>) of
        std_logic_vector(2*data_width-1 downto 0);

    component multiplier_1b is
        Port ( 
            Mul_In1 : in  STD_LOGIC;
            Mul_In2 : in  STD_LOGIC;
            Product : out  STD_LOGIC);
    end component;

    component rc_adder is
        generic(
            data_width : integer := 16
        );
        Port ( A, B   : in  std_logic_vector(data_width - 1 downto 0);
            Carry  : out std_logic;
            Sum : out std_logic_vector(data_width - 1 downto 0)
        );
    end component;
    
    signal partial_products : product_array(0 to data_width-1);
    signal accum : product_array(0 to data_width);

begin

    accum(0) <= (others => '0');

    multipliy_outer: for i in 0 to data_width-1 generate
        -- Generate each digit of a partial product
        -- Loop over all possible product digits
        multipliy_inner: for k in 0 to 2*data_width-1 generate
            -- Only assign digits for the current partial product, otherwise assign 0
            partial_product: if k >= i and k < i + data_width generate
                multiplier_x: multiplier_1b port map (
                    Mul_In1 => Mul_In1(k-i),
                    Mul_In2 => Mul_In2(i),
                    Product => partial_products(i)(k)
                );
            end generate partial_product;

            zero_fill: if k < i or k >= i + data_width generate
                partial_products(i)(k) <= '0';
            end generate zero_fill;
        end generate multipliy_inner;

        -- Sum the current partial product with the accumulated sum of previous partial products
        adder: rc_adder
            generic map(
                data_width => 2*data_width
            )
            port map(
                A => accum(i),
                B => partial_products(i),
                Carry => open,
                Sum => accum(i+1)
            );
    end generate multipliy_outer;

    Product <= accum(data_width);
 
end Behavioral;