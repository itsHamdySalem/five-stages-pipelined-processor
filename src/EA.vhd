library ieee;
use ieee.std_logic_1164.all;
USE IEEE.numeric_std.all;

entity EA is
    Port ( clk : in STD_LOGIC;
           rst : in STD_LOGIC;
            EA_in : in STD_LOGIC_VECTOR(19 downto 0);

            EA_out : out STD_LOGIC_VECTOR(19 downto 0)
           );
end EA;

architecture Behavioral of EA is
    
begin
    process(clk, rst) -- TODO:: deal with the reset if there is any.
    begin 
        if falling_edge(clk) then
            EA_out <= EA_in;
        end if;
    end process;

end Behavioral;
