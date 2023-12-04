LIBRARY IEEE;
USE IEEE.std_logic_1164.all;
USE IEEE.numeric_std.all;


entity Processor is
PORT  (
    clk, reset, enable:    	IN std_logic;
    enableFetch:            IN std_logic
);
end entity;


Architecture Processor_design of Processor is
    signal PcSelect:                std_logic;
    signal PcData:                  std_logic_vector(15 downto 0);
    signal instruction, immediate, pcOut, memOne: std_logic_vector(15 DOWNTO 0);


BEGIN
    fetchStageInstance: entity work.fetchStage port map(
        clk,
        reset,
        enableFetch,
        PcSelect,
        PcData,
        instruction,
        immediate,
        pcOut,
        memOne
    );

END Processor_design;

