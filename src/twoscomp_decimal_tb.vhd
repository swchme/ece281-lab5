-- Generated by ChatGPT, 14 April 2023
-- Modified by Capt Brian Yarbrough

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity twoscomp_decimal_tb is
end twoscomp_decimal_tb;

architecture Behavioral of twoscomp_decimal_tb is

    component twos_comp is
        port (
            i_bin: in std_logic_vector(7 downto 0);
            o_sign: out std_logic;
            o_hund: out std_logic_vector(3 downto 0);
            o_tens: out std_logic_vector(3 downto 0);
            o_ones: out std_logic_vector(3 downto 0)
        );
    end component twos_comp;

    signal w_binary: std_logic_vector(7 downto 0) := (others => '0');
    signal w_negative: std_logic;
    signal w_hundreds: std_logic_vector(3 downto 0);
    signal w_tens: std_logic_vector(3 downto 0);
    signal w_ones: std_logic_vector(3 downto 0);
    
begin

    uut: twos_comp
        port map (
            i_bin => w_binary,
            o_sign => w_negative,
            o_hund => w_hundreds,
            o_tens => w_tens,
            o_ones => w_ones
        );
        
    process
    begin
        w_binary <= "00000000";
        wait for 10 ns;
        assert w_negative = '0' and w_hundreds = "0000" and w_tens = "0000" and w_ones = "0000" report "Bad convert 0" severity error;
        
        w_binary <= "11110000";
        wait for 10 ns;
        assert w_negative = '1' and w_hundreds = "0000" and w_tens = "0001" and w_ones = "0110" report "Bad convert -16" severity error;
        
        w_binary <= "00111010";
        wait for 10 ns;
        assert w_negative = '0' and w_hundreds = "0000" and w_tens = "0101" and w_ones = "1000" report "Bad convert 58" severity error;
        
        w_binary <= "01101111";
        wait for 10 ns;
        assert w_negative = '0' and w_hundreds = "0001" and w_tens = "0001" and w_ones = "0001" report "Bad convert 111" severity error;
        
        w_binary <= "10001000";
        wait for 10 ns;
        assert w_negative = '1' and w_hundreds = "0001" and w_tens = "0010" and w_ones = "0000" report "Bad convert -120" severity error;

        wait;
    end process;
    
end Behavioral;
