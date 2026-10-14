
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity carry_lookahead_adder is
    generic(
        data_width : integer := 16
    );
    Port ( 
        A, B : in std_logic_vector(data_width - 1 downto 0);
        Carry : out std_logic;
        Sum : out std_logic_vector(data_width - 1 downto 0)
    );
end carry_lookahead_adder;

architecture Behavioral of carry_lookahead_adder is
    component full_adder is
        Port (
            FA_in1, FA_in2, Carry_in : in STD_LOGIC;
            Sum, Carry_out : out STD_LOGIC
        );
    end component;

    signal G, P : std_logic_vector(data_width - 1 downto 0);
    signal C : std_logic_vector(data_width downto 0); --EXTRA carry position
    signal S : std_logic_vector(data_width - 1 downto 0);

begin

    C(0) <= '0'; --initial carry doesnt exist

    adders: for i in data_width - 1 downto 0 generate

        adder_x: full_adder
            port map (
                FA_in1 => A(i),
                FA_in2 => B(i),
                Carry_in => C(i),
                Sum => S(i),
                Carry_out => open
            );

        G(i) <= A(i) and B(i); --generate
        P(i) <= A(i) xor B(i); --propogate

    end generate adders;

    lookahead: for i in 0 to data_width - 1 generate

        bit0: if i mod 4 = 0 generate
            C(i+1) <= G(i) or (P(i) and C(i));  --using C(i) instead of C0 so potential 5th bit knows to use C4
        end generate bit0;

        bit1: if i mod 4 = 1 generate
            C(i+1) <= G(i) or (P(i) and G(i-1)) or (P(i) and P(i-1) and C(i-1));
        end generate bit1;

        bit2: if i mod 4 = 2 generate
            C(i+1) <= G(i) or (P(i) and G(i-1)) or (P(i) and P(i-1) and G(i-2)) or (P(i) and P(i-1) and P(i-2) and C(i-2));
        end generate bit2;

        bit3: if i mod 4 = 3 generate
            C(i+1) <= G(i) or (P(i) and G(i-1)) or (P(i) and P(i-1) and G(i-2)) or (P(i) and P(i-1) and P(i-2) and G(i-3)) or (P(i) and P(i-1) and P(i-2) and P(i-3) and C(i-3));
        end generate bit3;

    end generate lookahead;

    Carry <= C(data_width);
    Sum <= S;

end Behavioral;
