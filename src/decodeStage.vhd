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
        instruction_out:      OUT std_logic_vector(15 DOWNTO 0);
        WriteEnable :               IN std_logic;
        WriteReg :               IN std_logic_vector(2 DOWNTO 0);
        WriteData :    	        IN std_logic_vector(31 DOWNTO 0);
        R0,R1,R2,R3,R4,R5,R6,R7: OUT std_logic_vector(31 DOWNTO 0);
        ucjFlush : out std_logic
    );
END ENTITY DecodingStage;

ARCHITECTURE decoding OF DecodingStage  IS 
BEGIN


    ControlU : entity work.ControlUnit port map(clk, instruction, Imm, InOp, OutOp, MemOp, regWrite, pcSrc, memRead, memWrite, memToReg, spInc, spDec, isOneOp);
    regFile: entity work.RegistersFile port map(clk, rst, RS1, RS2, Rdest, WriteEnable, WriteReg, WriteData, RS1Data, RS2Data, RdstData,
    R0,R1,R2,R3,R4,R5,R6,R7);
    -- PROCESS (clk, rst)
    -- BEGIN
    --     IF falling_edge(clk) THEN
            Rdest_out <= Rdest;
    --     END IF;
    -- END PROCESS;
    
    ucjFlush <= '1' when instruction = "0000000000011001" else '0';
    instruction_out <= instruction;
END decoding;
