library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity sevseg_disp_tb is
end sevseg_disp_tb;

architecture Behavioral of sevseg_disp_tb is
component sevseg_disp is
    Port ( 
        I_0, I_1, I_2, I_3, I_4, I_5, I_6, I_7 : in std_logic_vector(3 downto 0);
        DOT : in std_logic;
        AN_SEL : in std_logic_vector(2 downto 0); -- numbered anode select (Selected via clock)
        AN : out std_logic_vector(7 downto 0); -- per bit which anode to turn on/off
        SEG : out STD_LOGIC_VECTOR (7 downto 0) -- 7-1 bits are cathodes, 0 bit is dot. 0 on, 1 off
    );
end component;

signal I_0, I_1, I_2, I_3, I_4, I_5, I_6, I_7 : std_logic_vector(3 downto 0);
signal DOT : std_logic;
signal AN_SEL : std_logic_vector(2 downto 0);
signal AN : std_logic_vector(7 downto 0);
signal SEG : std_logic_vector(7 downto 0);

procedure check_result(
    constant actual     : in std_logic_vector(3 downto 0);
    constant expected   : in std_logic_vector(3 downto 0);
    constant test_name  : in string
) is
begin
    assert actual = expected
        report test_name & " FAILED"
            severity error;
    if actual = expected then
        report test_name & " PASSED"
            severity note;
    end if;
end procedure;

begin
    uut: four_bit_alu 
        port map ( 
            I_0 => I_0, 
            I_1 => I_1, 
            I_2 => I_2, 
            I_3 => I_3, 
            I_4 => I_4, 
            I_5 => I_5, 
            I_6 => I_6, 
            I_7 => I_7,
            DOT => DOT,
            AN_SEL => AN_SEL,
            AN => AN,
            SEG => SEG
        );
    
    test_bench: process
    begin
        I_0 <= "0000"; 
        I_1 <= "0001"; 
        I_2 <= "0010"; 
        I_3 <= "0011"; 
        I_4 <= "0100"; 
        I_5 <= "0101"; 
        I_6 <= "0110"; 
        I_7 <= "0111";
        DOT <= '1';
        
        AN_SEL <= "000";
        wait for 100 ns;
        check_result(SEG, "0000", "Select Anode 0 (0) case cathode value");
        check_result(AN, "11111110", "Select Anode 0 (0) case anode value");

        AN_SEL <= "001";
        wait for 100 ns;
        check_result(SEG, "0001", "Select Anode 1 (1) case cathode value");
        check_result(AN, "11111101", "Select Anode 1 (1) case anode value");

        AN_SEL <= "010";
        wait for 100 ns;
        check_result(SEG, "0010", "Select Anode 0 (0) case cathode value");
        check_result(AN, "11111011", "Select Anode 0 (0) case anode value");

        AN_SEL <= "011";
        wait for 100 ns;
        check_result(SEG, "0011", "Select Anode 0 (0) case cathode value");
        check_result(AN, "11110111", "Select Anode 0 (0) case anode value");

        AN_SEL <= "100";
        wait for 100 ns;
        check_result(SEG, "0100", "Select Anode 0 (0) case cathode value");
        check_result(AN, "11101111", "Select Anode 0 (0) case anode value");

        AN_SEL <= "101";
        wait for 100 ns;
        check_result(SEG, "0101", "Select Anode 0 (0) case cathode value");
        check_result(AN, "11011111", "Select Anode 0 (0) case anode value");

        AN_SEL <= "110";
        wait for 100 ns;
        check_result(SEG, "0110", "Select Anode 0 (0) case cathode value");
        check_result(AN, "10111111", "Select Anode 0 (0) case anode value");

        AN_SEL <= "111";
        wait for 100 ns;
        check_result(SEG, "0111", "Select Anode 0 (0) case cathode value");
        check_result(AN, "01111111", "Select Anode 0 (0) case anode value");

        wait;
    end process test_bench;
end Behavioral;
