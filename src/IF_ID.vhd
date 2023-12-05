LIBRARY IEEE;
USE IEEE.std_logic_1164.all;
use IEEE.STD_LOGIC_SIGNED.ALL;
USE IEEE.numeric_std.all;


ENTITY IF_ID IS
PORT( 
    clk, reset :                    IN  std_logic; 
    instruction:          IN  std_logic_vector(15 DOWNTO 0);

    RS1,RS2,Rdest:                        OUT std_logic_vector(2 DOWNTO 0)
);
END IF_ID;

ARCHITECTURE IF_ID_Design OF IF_ID IS
BEGIN
PROCESS (clk, reset)
BEGIN

    IF rising_edge(clk) THEN
        RS1 <= instruction(6 DOWNTO 4);
        RS2 <= instruction(3 DOWNTO 1);
        Rdest <= instruction(9 DOWNTO 7);
    END IF;
END PROCESS;
END IF_ID_Design;




