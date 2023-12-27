LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.all;

ENTITY WBStage IS
    PORT (
        clk:                IN std_logic;
        rst :               IN std_logic;
        Rdest_Sel:            IN std_logic_vector(2 DOWNTo 0);
        ALU_out:            IN std_logic_vector(31 DOWNTo 0);
        readData:            IN std_logic_vector(31 DOWNTo 0);
        regWriteSig_in:      IN STD_LOGIC;
        memReadSig_in:      IN STD_LOGIC;

        writeRegisterEnable: OUT std_logic;
        writeRegisterSel_D: OUT std_logic_vector(2 DOWNTO 0);
        writeRegisterData_D: OUT std_logic_vector(31 DOWNTO 0);
        instruction: IN std_logic_vector(15 DOWNTO 0);
        InReg: IN std_logic_vector(31 DOWNTO 0);
        OutReg: OUT std_logic_vector(31 DOWNTO 0);
        InValue: IN std_logic_vector(31 DOWNTO 0)

    );
END ENTITY WBStage;
ARCHITECTURE execution OF WBStage  IS
BEGIN
    writeRegisterEnable <= '1' when regWriteSig_in='1'
    else '0';

    writeRegisterSel_D <= Rdest_Sel;

    writeRegisterData_D <= 
    InValue when instruction(15 downto 11) = "01100"
    else readData when memReadSig_in='1'
    else ALU_out;

    OutReg <= ALU_out when instruction(15 DOWNTO 11) = "01101" else InReg;
END execution;
