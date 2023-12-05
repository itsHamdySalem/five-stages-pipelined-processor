LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.all;

ENTITY instructionMem IS
    PORT (
        rst :               IN std_logic;
        readAddress :    	IN std_logic_vector(11 DOWNTO 0);
        instruction :       OUT std_logic_vector(15 DOWNTO 0); 
        immediate :         OUT std_logic_vector(15 DOWNTO 0);
        memZero :           OUT std_logic_vector(15 DOWNTO 0);
        memOne :           OUT std_logic_vector(15 DOWNTO 0)
    );
END ENTITY instructionMem;

ARCHITECTURE instructionMem_design OF instructionMem  IS 
    TYPE ram_type IS ARRAY(0 TO 2**12 - 1) OF std_logic_vector(15 DOWNTO 0);
    
    SIGNAL ram : ram_type ;    
    
BEGIN
    memZero <= ram(0);
    memOne <= ram(1);
    instruction  <= ram(to_integer(unsigned(readAddress)));
    immediate    <= ram(to_integer(unsigned(readAddress))+1);

END instructionMem_design;