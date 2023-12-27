LIBRARY IEEE;
USE IEEE.std_logic_1164.all;
use IEEE.STD_LOGIC_SIGNED.ALL;
USE IEEE.numeric_std.all;


ENTITY IF_ID IS
PORT( 
    clk, reset, cjFlush, ucjFlush :                    IN  std_logic; 
    instruction:          IN  std_logic_vector(15 DOWNTO 0);

    RS1,RS2,Rdest:                        OUT std_logic_vector(2 DOWNTO 0);
    instruction_out:          OUT  std_logic_vector(15 DOWNTO 0)

);
END IF_ID;

ARCHITECTURE IF_ID_Design OF IF_ID IS
BEGIN
PROCESS (clk, reset)
BEGIN

    if reset or cjFlush or ucjFlush then
        RS1 <= (others => '0');
        RS2 <= (others => '0');
        Rdest <= (others => '0');
        instruction_out <= (others => '0');
    elsIF rising_edge(clk) THEN
        RS1 <= instruction(7 DOWNTO 5);
        RS2 <= instruction(4 DOWNTO 2);
        Rdest <= instruction(10 DOWNTO 8);
        instruction_out <= instruction;
    END IF;
END PROCESS;
END IF_ID_Design;




