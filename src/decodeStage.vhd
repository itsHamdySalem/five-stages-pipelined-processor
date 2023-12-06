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
        instruction:        IN std_logic_vector(15 DOWNTO 0);
        RS1Data :           OUT std_logic_vector(31 DOWNTO 0);
        RS2Data :           OUT std_logic_vector(31 DOWNTO 0);
        RdstData :          OUT std_logic_vector(31 DOWNTO 0);
        Imm:                OUT STD_LOGIC;
        InOp:               OUT STD_LOGIC;
        OutOp:              OUT STD_LOGIC;
        MemOp:              OUT STD_LOGIC;
        regWrite:           OUT STD_LOGIC;
        pcSrc:              OUT STD_LOGIC;
        memRead:            OUT STD_LOGIC;
        memWrite:           OUT STD_LOGIC;
        memToReg:           OUT STD_LOGIC;
        spInc:              OUT STD_LOGIC;
        spDec:              OUT STD_LOGIC;
        isOneOp:            OUT STD_LOGIC;
        Rdest_out :    	        OUT std_logic_vector(2 DOWNTO 0);
        instruction_out:      OUT std_logic_vector(15 DOWNTO 0)
    );
END ENTITY DecodingStage;

ARCHITECTURE decoding OF DecodingStage  IS 
--  signal RS1_or_RD : std_logic_vector(2 DOWNTO 0);
BEGIN

    -- RS1_or_RD <= RD when pcSrc = '1' and memRead = '0' else RS1;

    ControlU : entity work.ControlUnit port map(clk, instruction, Imm, InOp, OutOp, MemOp, regWrite, pcSrc, memRead, memWrite, memToReg, spInc, spDec, isOneOp);
    regFile: entity work.RegistersFile port map(clk, rst, RS1, RS2, Rdest, '0', "000", X"00000000", RS1Data, RS2Data, RdstData); -- RS1 and RS2 check themmm! 
    -- PROCESS (clk, rst)
    -- BEGIN
    --     IF falling_edge(clk) THEN
            Rdest_out <= Rdest;
    --     END IF;
    -- END PROCESS;
    
    instruction_out <= instruction;
END decoding;
