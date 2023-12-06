LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.all;

ENTITY instructionMem IS
    PORT (
        clk:                IN std_logic;
        rst :               IN std_logic;
        readAddress :    	IN std_logic_vector(11 DOWNTO 0);
        instruction :       OUT std_logic_vector(15 DOWNTO 0); 
        immediate :         OUT std_logic_vector(15 DOWNTO 0)
    );
END ENTITY instructionMem;

ARCHITECTURE instructionMem_design OF instructionMem  IS 
    TYPE ram_type IS ARRAY(0 TO 2**12 - 1) OF std_logic_vector(15 DOWNTO 0);
    
    SIGNAL ram : ram_type ;    
BEGIN

    PROCESS (clk, rst)

    BEGIN
    ram(0) <= "1101000100000000";  -- LDD instruction
    ram(1) <= "0010001000001000";  -- DEC instruction
    ram(2) <= "1001101100001101";  -- OR instruction
    

    IF rising_edge(clk) THEN
        instruction  <= ram(to_integer(unsigned(readAddress)));
        immediate    <= ram(to_integer(unsigned(readAddress))+1);
    END IF;
    END PROCESS;


END instructionMem_design;