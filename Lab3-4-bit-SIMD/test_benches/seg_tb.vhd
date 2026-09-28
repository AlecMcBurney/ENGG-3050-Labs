library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity sevseg_disp_tb is
end sevseg_disp_tb;

architecture Behavioral of sevseg_disp_tb is
    component sevseg_disp is
        Port (
            I_0, I_1, I_2, I_3, I_4, I_5, I_6, I_7 : in std_logic_vector(4 downto 0);
            AN_SEL : in std_logic_vector(2 downto 0);
            AN : out std_logic_vector(7 downto 0);
            SEG : out std_logic_vector(7 downto 0)
        );
    end component;

    type digit_array is array (0 to 7) of std_logic_vector(4 downto 0);
    signal digit_inputs : digit_array := (others => (others => '0'));
    signal AN_SEL : std_logic_vector(2 downto 0);
    signal AN : std_logic_vector(7 downto 0);
    signal SEG : std_logic_vector(7 downto 0);

function segment_pattern(value : integer) return std_logic_vector is
begin
    case value is
        when 0 => return "1000000";
        when 1 => return "1111001";
        when 2 => return "0100100";
        when 3 => return "0110000";
        when 4 => return "0011001";
        when 5 => return "0010010";
        when 6 => return "0000010";
        when 7 => return "1111000";
        when 8 => return "0000000";
        when 9 => return "0011000";
        when 10 => return "0001000";
        when 11 => return "0000011";
        when 12 => return "1000110";
        when 13 => return "0100001";
        when 14 => return "0000110";
        when others => return "0001110";
    end case;
end function;

function anode_pattern(index : integer) return std_logic_vector is
    variable result : std_logic_vector(7 downto 0) := (others => '1');
begin
    result(index) := '0';
    return result;
end function;

function vector_string(value : std_logic_vector) return string is
    variable result : string(1 to value'length);
begin
    for position in 0 to value'length - 1 loop
        case value(value'left - position) is
            when 'U' => result(position + 1) := 'U';
            when 'X' => result(position + 1) := 'X';
            when '0' => result(position + 1) := '0';
            when '1' => result(position + 1) := '1';
            when 'Z' => result(position + 1) := 'Z';
            when 'W' => result(position + 1) := 'W';
            when 'L' => result(position + 1) := 'L';
            when 'H' => result(position + 1) := 'H';
            when '-' => result(position + 1) := '-';
        end case;
    end loop;
    return result;
end function;

begin
    uut: sevseg_disp
        port map (
            I_0 => digit_inputs(0),
            I_1 => digit_inputs(1),
            I_2 => digit_inputs(2),
            I_3 => digit_inputs(3),
            I_4 => digit_inputs(4),
            I_5 => digit_inputs(5),
            I_6 => digit_inputs(6),
            I_7 => digit_inputs(7),
            AN_SEL => AN_SEL,
            AN => AN,
            SEG => SEG
        );

    test_bench: process
        variable dot_value : std_logic;
        variable expected_seg : std_logic_vector(7 downto 0);
        variable passed_count : natural := 0;
        variable case_passed : boolean;
        variable value : integer;
        constant total_count : natural := 2 * 2 * 8;
    begin
        for batch in 0 to 1 loop
            for dot_index in 0 to 1 loop
                if dot_index = 0 then
                    dot_value := '0';
                else
                    dot_value := '1';
                end if;

                for digit_index in 0 to 7 loop
                    value := batch * 8 + digit_index;
                    digit_inputs(digit_index) <= std_logic_vector(to_unsigned(value, 4)) & dot_value;
                end loop;

                for anode_index in 0 to 7 loop
                    value := batch * 8 + anode_index;
                    AN_SEL <= std_logic_vector(to_unsigned(anode_index, AN_SEL'length));
                    expected_seg := dot_value & segment_pattern(value);
                    case_passed := true;

                    wait for 10 ns;
                    if SEG /= expected_seg then
                        report "FAIL SEG: batch " & integer'image(batch) &
                            ", anode " & integer'image(anode_index) &
                            ", value " & integer'image(value) &
                            ", dot " & std_logic'image(dot_value) &
                            ", expected " & vector_string(expected_seg) &
                            ", got " & vector_string(SEG)
                            severity warning;
                        case_passed := false;
                    end if;
                    if AN /= anode_pattern(anode_index) then
                        report "FAIL AN: batch " & integer'image(batch) &
                            ", anode " & integer'image(anode_index) &
                            ", expected " & vector_string(anode_pattern(anode_index)) &
                            ", got " & vector_string(AN)
                            severity warning;
                        case_passed := false;
                    end if;
                    if case_passed then
                        passed_count := passed_count + 1;
                    end if;
                end loop;
            end loop;
        end loop;

        report integer'image(passed_count) & "/" & integer'image(total_count) &
            " sevseg_disp cases passed" severity note;
        wait;
    end process test_bench;
end Behavioral;
