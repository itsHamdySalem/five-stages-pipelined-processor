LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.ALL;

ENTITY DecodingStage IS
    PORT (
        clk : IN STD_LOGIC;
        rst : IN STD_LOGIC;
        RS1 : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
        RS2 : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
        Rdest : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
        instruction : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
        RS1Data : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
        RS2Data : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
        RdstData : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
        Imm : OUT STD_LOGIC;
        InOp : OUT STD_LOGIC;
        OutOp : OUT STD_LOGIC;
        MemOp : OUT STD_LOGIC;
        regWrite : OUT STD_LOGIC;
        pcSrc : OUT STD_LOGIC;
        memRead : OUT STD_LOGIC;
        memWrite : OUT STD_LOGIC;
        memToReg : OUT STD_LOGIC;
        spInc : OUT STD_LOGIC;
        spDec : OUT STD_LOGIC;
        isOneOp : OUT STD_LOGIC;
        Rdest_out : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
        instruction_out : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
        WriteEnable : IN STD_LOGIC;
        WriteReg : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
        WriteData : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        R0, R1, R2, R3, R4, R5, R6, R7 : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
        Fwrd_sel1, Fwrd_sel2 : IN STD_LOGIC;
        Fwrd_data1, Fwrd_data2 : IN STD_LOGIC_VECTOR(31 DOWNTO 0)
    );
END ENTITY DecodingStage;

ARCHITECTURE decoding OF DecodingStage IS

    SIGNAL RegFile_Rsrc1Data, RegFile_Rsrc2Data : STD_LOGIC_VECTOR(31 DOWNTO 0);

BEGIN
    ControlU : ENTITY work.ControlUnit PORT MAP(clk, instruction, Imm, InOp, OutOp, MemOp, regWrite, pcSrc, memRead, memWrite, memToReg, spInc, spDec, isOneOp);
    regFile : ENTITY work.RegistersFile PORT MAP(clk, rst, RS1, RS2, Rdest, WriteEnable, WriteReg, WriteData, RegFile_Rsrc1Data, RegFile_Rsrc2Data, RdstData,
        R0, R1, R2, R3, R4, R5, R6, R7);

    RS1Data <=
        Fwrd_data1 WHEN Fwrd_sel1 = '1' ELSE
        RegFile_Rsrc1Data;

    RS2Data <=
        Fwrd_data2 WHEN Fwrd_sel2 = '1' ELSE
        RegFile_Rsrc2Data;

    Rdest_out <= Rdest;

    instruction_out <= instruction;
END decoding;