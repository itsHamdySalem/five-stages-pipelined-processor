library ieee;
use ieee.std_logic_1164.all;
USE IEEE.numeric_std.all;

entity CCR is
    Port ( clk : in STD_LOGIC;
           rst : in STD_LOGIC;
            CCR_in : in STD_LOGIC_VECTOR(2 downto 0);

            CCR_out : out STD_LOGIC_VECTOR(2 downto 0)
           );
end CCR;

architecture Behavioral of CCR is
    
begin
    process(clk, rst) -- TODO:: deal with the reset if there is any.
    begin 
        if rising_edge(clk) then
            CCR_out <= CCR_in;
        end if;
    end process;

end Behavioral;
