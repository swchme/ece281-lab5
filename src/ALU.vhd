----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/18/2025 02:50:18 PM
-- Design Name: 
-- Module Name: ALU - Behavioral
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
-- use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating 
-- any Xilinx leaf cells in this code.
-- library UNISIM;
-- use UNISIM.VComponents.all;

entity ALU is
    Port ( A_in    : in  STD_LOGIC_VECTOR (7 downto 0);
           B_in    : in  STD_LOGIC_VECTOR (7 downto 0);
           ALUOp   : in  STD_LOGIC_VECTOR (2 downto 0);
           result  : out STD_LOGIC_VECTOR (7 downto 0);
           flags   : out STD_LOGIC_VECTOR (3 downto 0));
end ALU;

architecture behavioral of ALU is
    component ripple_adder
        port ( A     : in  STD_LOGIC_VECTOR(3 downto 0);
               B     : in  STD_LOGIC_VECTOR(3 downto 0);
               Cin   : in  STD_LOGIC;
               S     : out STD_LOGIC_VECTOR(3 downto 0);
               Cout  : out STD_LOGIC);
    end component;

    signal x_sum, resultOUT : STD_LOGIC_VECTOR(7 downto 0);
    signal x_lower_carry, x_upper_carry : STD_LOGIC;
    signal q_result : STD_LOGIC_VECTOR(7 downto 0);
begin
    u0_ALU : ripple_adder
        port map ( A    => A_in(3 downto 0),
                   B    => B_in(3 downto 0),
                   Cin  => '0',
                   S    => x_sum(3 downto 0),
                   Cout => x_lower_carry );

    Ripple_Upper : ripple_adder -- Upper Bits
        port map ( A    => A_in(7 downto 4),
                   B    => B_in(7 downto 4),
                   Cin  => x_lower_carry,
                   S    => x_sum(7 downto 4),
                   Cout => x_upper_carry );

    -- MUX
    resultOUT <= x_sum when ALUOp = "000" else
                 x_sum when ALUOp = "001" else
                 (others => '0') when ALUOp = "010" else
                 (others => '0');

    q_result <= resultOUT;

    -- overflow flag
    flags(0) <= not (A_in(7) xor B_in(7)) and (A_in(7) xor x_sum(7));

    -- carry
    flags(1) <= x_upper_carry and (not ALUOp(0));

    -- negative
    flags(2) <= resultOUT(7);

    -- zero
    flags(3) <= '1' when (resultOUT = "00000000") else '0';

    result <= q_result;
end behavioral;
