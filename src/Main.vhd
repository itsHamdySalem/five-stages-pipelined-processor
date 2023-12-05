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
    signal Rdest, RS1, RS2 : std_logic_vector(2 DOWNTO 0);
    signal RS1Data, RS2Data, RDestData : std_logic_vector(31 DOWNTO 0);
    signal ImmSig,
    InOpSig,        
    OutOpSig,       
    MemOpSig,       
    regWriteSig,    
    pcSrcSig,    
    memReadSig,     
    memWriteSig,    
    memToRegSig,    
    spIncSig,    
    spDecSig : STD_LOGIC;

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

    IF_IDInstance: entity work.IF_ID port map(
        clk,
        reset,
        instruction,
        RS1,
        RS2,
        Rdest
    );


    DecodeInstance: entity work.DecodingStage port map(
        clk,
        reset,
        RS1,
        RS2,
        Rdest,
        instruction,
        RS1Data,
        RS2Data,
        RDestData,
        ImmSig,
        InOpSig,        
        OutOpSig,       
        MemOpSig,       
        regWriteSig,    
        pcSrcSig,    
        memReadSig,     
        memWriteSig,    
        memToRegSig,    
        spIncSig,    
        spDecSig       
    );

END Processor_design;

