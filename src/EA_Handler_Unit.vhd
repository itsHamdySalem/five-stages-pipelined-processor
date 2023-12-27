library ieee;
use ieee.std_logic_1164.all;
USE IEEE.numeric_std.all;

entity EA_Handler_Unit is
    Port ( clk : in STD_LOGIC;
           rst : in STD_LOGIC;
            instruction1 : in STD_LOGIC_VECTOR(15 downto 0);
            instruction2 : in STD_LOGIC_VECTOR(15 downto 0);
            EA : out STD_LOGIC_VECTOR(19 downto 0)
           );
end EA_Handler_Unit;

architecture Behavioral of EA_Handler_Unit is
    
begin

    EA <= instruction1(7 downto 4) & instruction2;

end Behavioral;
