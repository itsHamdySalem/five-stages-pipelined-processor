LIBRARY IEEE;
USE IEEE.std_logic_1164.all;
use IEEE.STD_LOGIC_SIGNED.ALL;
USE IEEE.numeric_std.all;


ENTITY Mem_WB IS
PORT( 
    clk, reset :                   IN  std_logic; 
    RDst_Sel   :                   IN std_logic_vector(2 DOWNTO 0);
    RDst_Sel_out   :               OUT std_logic_vector(2 DOWNTO 0);
    
    ALU_in   :                   IN std_logic_vector(31 DOWNTO 0);
    ALU_out   :               OUT std_logic_vector(31 DOWNTO 0);

    readData:           in std_logic_vector(31 downto 0);
    readData_out:           out std_logic_vector(31 downto 0);

    dataReadEnable:     in std_logic;
    dataReadEnable_out:     out std_logic;
    regWriteSig_in:      IN STD_LOGIC;
    regWriteSig_out:      out STD_LOGIC;
    instructionI:           in std_logic_vector(15 downto 0);
    instructionO:           out std_logic_vector(15 downto 0)


);
END Mem_WB;

ARCHITECTURE Mem_WB_Design OF Mem_WB IS
BEGIN
PROCESS (clk, reset)
BEGIN
    IF rising_edge(clk) THEN
    RDst_Sel_out <= RDst_Sel;
    ALU_out <= ALU_in;
    readData_out <= readData;
    dataReadEnable_out <= dataReadEnable;
    regWriteSig_out <= regWriteSig_in;
    instructionO <= instructionI;
    END IF;
END PROCESS;
END Mem_WB_Design;




