LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.all;

ENTITY DecodingStage IS
    PORT (
        clk:                IN std_logic;
        rst :               IN std_logic;
        RS1 :               IN std_logic_vector(2 DOWNTO 0);
        RS2 :               IN std_logic_vector(2 DOWNTO 0);
        Rdest :    	        IN std_logic_vector(2 DOWNTO 0); 
        RS1Data :           OUT std_logic_vector(31 DOWNTO 0);
        RS2Data :           OUT std_logic_vector(31 DOWNTO 0)
    );
END ENTITY DecodingStage;

ARCHITECTURE decoding OF DecodingStage  IS 
--  signal RS1_or_RD : std_logic_vector(2 DOWNTO 0);
BEGIN

    -- RS1_or_RD <= RD when pcSrc = '1' and memRead = '0' else RS1;
    -- ControlU : entity work.ControlUnit port map(clk, Instruction,stall,regWrite, pcSrc, memRead, memWrite, memToReg, inPort, outPort, spInc, spDec, InterruptSignal, NOP, count);
    regFile: entity work.RegistersFile port map(clk, rst, RS1, RS2, '0', "000", X"00000000", RS1Data, RS2Data); -- RS1 and RS2 check themmm! 
    
END decoding;
