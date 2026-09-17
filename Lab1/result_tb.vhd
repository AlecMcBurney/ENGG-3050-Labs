----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 09/16/2026 11:53:19 PM
-- Design Name: 
-- Module Name: seg_tb - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity result_tb is
--  Port ( );
end result_tb;

architecture Behavioral of result_tb is

    component display_result
        Port ( 
            SW: in std_logic_vector(11 downto 0); -- use 3 switches as binary bits
            DIG_SEL : in std_logic_vector(2 downto 0); -- number to select anode based on clock 
            ANODES : out std_logic_vector(7 downto 0); --7 seg ANODES
            SEG_CATHODES : out std_logic_vector(7 downto 0) --7 seg Cathodes   order might be backward?
        );
    end component;
    
    signal sw_test: std_logic_vector(11 downto 0);
    signal DIG_SEL_test: std_logic_vector(2 downto 0);
    signal ANODES_test : std_logic_vector(7 downto 0);
    signal SEG_CATHODES_test : std_logic_vector(7 downto 0);

begin
    display_test: display_result
	    port map(
            SW => SW_test,
            DIG_SEL => DIG_SEL_test, 
            ANODES => ANODES_test,
            SEG_CATHODES => SEG_CATHODES_test
        );
    
    result_tb: process
    begin
        SW_test(5 downto 0) <= "000000";
        SW_test(11 downto 6) <= "000000";
        --Sum=000000 Carry = 0
        DIG_SEL_test <= "000";
        wait for 100 ns;
        
        SW_test(5 downto 0) <= "111111";
        SW_test(11 downto 6) <= "111111";
        --Sum=111110 Carry = 1
        wait for 100 ns;
        
        SW_test(5 downto 0) <= "101010";
        SW_test(11 downto 6) <= "010101";
        --Sum=111111 Carry = 0
        wait for 100 ns;
        
        SW_test(5 downto 0) <= "001111";
        SW_test(11 downto 6) <= "001111";
        --Sum=010000 Carry = 0
        wait for 100 ns;
        
        SW_test(5 downto 0) <= "010000";
        SW_test(11 downto 6) <= "000001";
        --Sum=010001 Carry = 0
        wait for 100 ns;
        
        SW_test(5 downto 0) <= "001000";
        SW_test(11 downto 6) <= "101100";
        --Sum=110100 carry=0
        wait for 100 ns;
        
        SW_test(5 downto 0) <= "001100";
        SW_test(11 downto 6) <= "101100";
        -- expecting Sum = "1110" Carry = 0        
        wait for 100 ns;
        
        SW_test(5 downto 0) <= "100000";
        SW_test(11 downto 6) <= "100000";
        -- expecting sum=000000 carry=1
        wait for 100 ns;
        
        wait;
    end process result_tb;
end Behavioral;
