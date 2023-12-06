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
        protectEnable:        IN std_logic;
        writeData:          in std_logic_vector(15 downto 0);
        RDst :          IN std_logic_vector(2 DOWNTO 0);
        readData:           out std_logic_vector(15 downto 0);
        aluOut_out:        out std_logic_vector(31 downto 0);
        RDst_Sel :          OUT std_logic_vector(2 DOWNTO 0)
    );
END ENTITY memoryStage;

ARCHITECTURE execution OF memoryStage  IS
signal isOutOp:                std_logic;


BEGIN

    isOutOp <= '1' when instruction(15 DOWNTO 11) = "01101" else '0';

    MemoryInstance : entity work.dataMem port map(clk, rst,
        memAddress(11 DOWNTO 0),
        dataReadEnable,
        memAddress(11 DOWNTO 0),
        dataWriteEnable,
        writeData,
        readData,
        memAddress(11 DOWNTO 0),
        protectEnable
    );

    RDst_Sel <= RDst;
    aluOut_out <= aluOut;


END execution;
