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
    signal pcOut, instruction_IFID: std_logic_vector(15 DOWNTO 0);
    signal Rdest_IFID, RS1_IFID, RS2_IFID : std_logic_vector(2 DOWNTO 0);

    signal RS1Data_D, RS2Data_D, RDestData_D : std_logic_vector(31 DOWNTO 0);
    signal ImmSig_D,
    InOpSig_D,        
    OutOpSig_D,       
    MemOpSig_D,       
    regWriteSig_D,    
    pcSrcSig_D,    
    memReadSig_D,     
    memWriteSig_D,    
    memToRegSig_D,    
    spIncSig_D,    
    spDecSig_D,
    isOneOp_D,
    isOneOp_ID_EX : STD_LOGIC;
    signal RDest_D : std_logic_vector(2 DOWNTO 0);
    signal instruction_D, instruction_ID_EX: std_logic_vector(15 DOWNTO 0);
    signal instruction_F, immediate_F : std_logic_vector(15 DOWNTO 0);


    signal memAddress_ID_EX : STD_LOGIC_VECTOR(31 downto 0);
    signal Rdst_sel_ID_EX: std_logic_vector(2 DOWNTO 0);
    signal immediate_out_ID_EX, Rsrc1_ID_EX, Rsrc2_ID_EX, Rdest_ID_EX : std_logic_vector(31 DOWNTO 0);
    signal isImmediate_ID_EX : std_logic;
    signal ALU_OP_ID_EX : std_logic_vector(4 DOWNTO 0);
    signal Mem_control_out_ID_EX, WB_control_out_ID_EX : std_logic_vector(2 DOWNTO 0);

    signal willBranch_EX : std_logic;
    signal outFlag_EX : std_logic_vector(2 DOWNTO 0);
    signal Alu_Out_EX : std_logic_vector(31 downto 0);
    

BEGIN
    fetchStageInstance: entity work.fetchStage port map(
        clk,
        reset,
        enableFetch,
        PcSelect,
        PcData,
        instruction_F,
        immediate_F,
        pcOut
    );

    IF_IDInstance: entity work.IF_ID port map(
        clk,
        reset,
        instruction_F,
        RS1_IFID,
        RS2_IFID,
        Rdest_IFID,
        instruction_IFID
    );

    --- cycle
    DecodeInstance: entity work.DecodingStage port map(
        clk,
        reset,
        RS1_IFID,
        RS2_IFID,
        Rdest_IFID,
        instruction_IFID,
        RS1Data_D,
        RS2Data_D,
        RDestData_D,
        ImmSig_D,
        InOpSig_D,        
        OutOpSig_D,       
        MemOpSig_D,       
        regWriteSig_D,    
        pcSrcSig_D,    
        memReadSig_D,     
        memWriteSig_D,    
        memToRegSig_D,    
        spIncSig_D,    
        spDecSig_D,
        isOneOp_D,
        Rdest_D,
        instruction_D
    );

    
    ID_EXInstance: entity work.ID_EX port map(
        clk,
        reset,
        instruction_D,
        x"00000000",
        Rdest_D,
        x"00000000",
        RS1Data_D,
        RS2Data_D,
        RDestData_D,
        '0',
        instruction_D(15 DOWNTO 11),
        "000",
        "000",
        isOneOp_D,
        memAddress_ID_EX,
        Rdst_sel_ID_EX,
        immediate_out_ID_EX,
        Rsrc1_ID_EX,
        Rsrc2_ID_EX,
        Rdest_ID_EX,
        isImmediate_ID_EX,
        ALU_OP_ID_EX,
        Mem_control_out_ID_EX,
        WB_control_out_ID_EX,
        instruction_ID_EX,
        isOneOp_ID_EX
    );

    EXInstance: entity work.ExecutionStage port map(
        clk,
        reset,
        instruction_ID_EX,
        isOneOp_ID_EX,
        isImmediate_ID_EX,
        Rsrc1_ID_EX,
        Rsrc2_ID_EX,
        Rdest_ID_EX,
        immediate_out_ID_EX,
        willBranch_EX,
        outFlag_EX,
        Alu_Out_EX
    );
    
END Processor_design;

