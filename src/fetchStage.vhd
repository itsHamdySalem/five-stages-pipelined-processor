LIBRARY IEEE;
USE IEEE.std_logic_1164.all;
use IEEE.STD_LOGIC_SIGNED.ALL;
USE IEEE.numeric_std.all;


ENTITY fetchStage IS
PORT( 
 clk, reset, enable, pcSel:                           IN  std_logic; 
 pcData:                                              IN  std_logic_vector(15 DOWNTO 0);
 instruction,immediate,pcOut:           OUT std_logic_vector(15 DOWNTO 0);
 pcSel2:                           IN  std_logic; 
 pcData2:                 IN  std_logic_vector(15 DOWNTO 0)
);
END fetchStage;

ARCHITECTURE fetchStageDesign OF fetchStage IS


COMPONENT instructionMem IS
    PORT (
        rst :               IN std_logic;
        readAddress :    	IN std_logic_vector(11 DOWNTO 0);
        instruction :       OUT std_logic_vector(15 DOWNTO 0); 
        immediate :         OUT std_logic_vector(15 DOWNTO 0)
    );
END COMPONENT;

COMPONENT PC IS
    PORT (
        clk, reset, enable : IN  std_logic;
        inc : IN std_logic_vector(15 DOWNTO 0);
        pcSel : IN std_logic;
        pcData : IN std_logic_vector(15 DOWNTO 0);
        pc : OUT std_logic_vector(15 DOWNTO 0)
    );
END COMPONENT;


signal pcOutput:                            std_logic_vector(15 DOWNTO 0);
signal increment:                           std_logic_vector(15 DOWNTO 0);
signal outInstruction:                      std_logic_vector(15 DOWNTO 0);
signal isImmediate:                         std_logic;

BEGIN

    pcc:            entity work.PC port map(clk, reset, enable, increment, pcSel, pcData, pcOutput, pcSel2, pcData2);
    instructions:   entity work.instructionMem port map(clk, reset, pcOutput(11 downto 0), outInstruction,immediate);
    isImmediate <= outInstruction(10);
    instruction <= outInstruction;

    increment <= x"0001";
    pcOut <= pcOutput;

END fetchStageDesign;
