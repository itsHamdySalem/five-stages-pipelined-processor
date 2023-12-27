LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.all;

ENTITY memoryStage IS
    PORT (
        clk:                IN std_logic;
        rst :               IN std_logic;
        instruction:        IN std_logic_vector(15 DOWNTO 0);
        aluOut:        in std_logic_vector(31 downto 0);
        memAddress:        in std_logic_vector(31 downto 0);
        dataReadEnable :           IN STD_LOGIC;
        dataWriteEnable :           IN STD_LOGIC;
        writeData:          in std_logic_vector(31 downto 0);
        RDst :          IN std_logic_vector(2 DOWNTO 0);
        readData:           out std_logic_vector(31 downto 0);
        aluOut_out:        out std_logic_vector(31 downto 0);
        RDst_Sel :          OUT std_logic_vector(2 DOWNTO 0);
        dataReadEnable_out :           OUT STD_LOGIC;
        regWriteSig_in:      IN STD_LOGIC;
        regWriteSig_out:      out STD_LOGIC;
        instruction_Mem:     out std_logic_vector(15 DOWNTO 0);
        spIncIn,spDecIn:              in std_logic;
        spIncOut, spDecOut:              out std_logic;
        SP:                            OUT std_logic_vector(11 DOWNTO 0);
        curData:                        OUT std_logic_vector(31 downto 0)

        );
END ENTITY memoryStage;

ARCHITECTURE execution OF memoryStage  IS

signal protectEnable: STD_LOGIC;
signal freeEnable: STD_LOGIC;

signal inc: std_logic_vector(2 DOWNTO 0);
signal spOut:                              std_logic_vector(11 DOWNTO 0);

BEGIN
    protectEnable <= '1' when instruction(15 DOWNTO 11) = "00111" else '0';
    freeEnable <= '1' when instruction(15 DOWNTO 11) = "01000" else '0';

    
    inc <=  "010" when instruction(15 downto 11) = "11100" or instruction(15 downto 11) = "11101" else
    "001" when spIncIn = '1' else          -- +1
    "111" when spDecIn = '1' else "000";    -- -1

    -- StackPointer: entity work.SP port map(clk,rst,);

    MemoryInstance : entity work.dataMem port map(clk, rst,
        memAddress(11 DOWNTO 0),
        dataReadEnable,
        memAddress(11 DOWNTO 0),
        dataWriteEnable,
        writeData,
        readData,
        memAddress(11 DOWNTO 0),
        protectEnable,
        instruction,
        aluOut,
        inc,spOut,
        curData,
        freeEnable
    );

    SP <= spOut;

    spDecOut <= spDecIn;
    spIncOut <= spIncIn;

    RDst_Sel <= RDst;
    aluOut_out <= readData when instruction(15 downto 11) = "00110"
        else aluOut;
    dataReadEnable_out <= dataReadEnable;
    regWriteSig_out <= regWriteSig_in;
    instruction_Mem <= instruction;
END execution;
