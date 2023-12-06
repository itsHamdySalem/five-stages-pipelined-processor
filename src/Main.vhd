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
    regWriteSig_ID_EX,
    regWriteSig_EX,
    regWriteSig_EX_Mem,
    regWriteSig_Mem,
    regWriteSig_Mem_WB,
    pcSrcSig_D,    
    memReadSig_D,     
    memWriteSig_D,    
    memToRegSig_D,    
    spIncSig_D,    
    spDecSig_D,
    isOneOp_D,
    isOneOp_ID_EX,
    memReadSig_ID_EX,
    memReadSig_EX,memReadSig_EX_Mem,memReadSig_Mem,memReadSig_Mem_WB : STD_LOGIC;
    signal RDest_D : std_logic_vector(2 DOWNTO 0);
    signal instruction_D, instruction_ID_EX, instruction_EX,instruction_EX_Mem: std_logic_vector(15 DOWNTO 0);
    signal instruction_F, immediate_F : std_logic_vector(15 DOWNTO 0);
    signal readData_Mem,readData_Mem_WB : std_logic_vector(31 DOWNTO 0);

    signal memAddress_ID_EX,memAddress_EX,memAddress_EX_Mem : STD_LOGIC_VECTOR(31 downto 0);
    signal Rdst_sel_ID_EX,Rdst_sel_EX,Rdst_sel_EX_Mem,Rdst_sel_Mem,Rdst_sel_Mem_WB: std_logic_vector(2 DOWNTO 0);
    signal immediate_out_ID_EX, Rsrc1_ID_EX, Rsrc2_ID_EX, Rdest_ID_EX : std_logic_vector(31 DOWNTO 0);
    signal isImmediate_ID_EX : std_logic;
    signal ALU_OP_ID_EX : std_logic_vector(4 DOWNTO 0);
    signal Mem_control_out_ID_EX, WB_control_out_ID_EX : std_logic_vector(2 DOWNTO 0);

    signal willBranch_EX : std_logic;
    signal outFlag_EX : std_logic_vector(2 DOWNTO 0);
    signal Alu_Out_EX,Alu_Out_EX_Mem,Alu_Out_Mem,Alu_Out_Mem_WB : std_logic_vector(31 downto 0);
    
    signal writeRegisterEnable_D: std_logic;
    signal writeRegisterSel_D: std_logic_vector(2 downto 0);
    signal writeRegisterData_D: std_logic_vector(31 downto 0);

    signal R0,R1,R2,R3,R4,R5,R6,R7: STD_LOGIC_VECTOR(31 downto 0);

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
        instruction_D,
        writeRegisterEnable_D,
        writeRegisterSel_D,
        writeRegisterData_D,
        R0,R1,R2,R3,R4,R5,R6,R7
    );

    
    ID_EXInstance: entity work.ID_EX port map(
        clk,
        reset,
        instruction_D,
        x"00000000", -- mem Address
        Rdest_D,
        x"00000000",
        RS1Data_D,
        RS2Data_D,
        RDestData_D,
        ImmSig_D,
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
        isOneOp_ID_EX,
        memReadSig_D,
        memReadSig_ID_EX,
        regWriteSig_D,
        regWriteSig_ID_EX
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
        Alu_Out_EX,
        memReadSig_ID_EX,
        memReadSig_EX,
        instruction_EX,
        Rdst_sel_ID_EX,
        Rdst_sel_EX,
        memAddress_ID_EX,
        memAddress_EX,
        regWriteSig_ID_EX,
        regWriteSig_EX
    );

    EX_MemInstance: entity work.EX_Mem port map(
        clk,
        reset,
        instruction_EX,
        Rdst_sel_EX,
        memAddress_EX,
        instruction_EX_Mem,
        memAddress_EX_Mem,
        Rdst_sel_EX_Mem,
        memReadSig_EX,
        memReadSig_EX_Mem,
        Alu_Out_EX,
        Alu_Out_EX_Mem,
        regWriteSig_EX,
        regWriteSig_EX_Mem
    );
    
    MemInstance: entity work.memoryStage port map(
        clk,
        reset,
        instruction_EX_Mem,
        Alu_Out_EX_Mem,
        memAddress_EX_Mem,
        memReadSig_EX_Mem,
        '0',
        '0',
        x"00000000",
        Rdst_sel_EX_Mem,
        readData_Mem,
        Alu_Out_Mem,
        Rdst_sel_Mem,
        memReadSig_Mem,
        regWriteSig_EX_Mem,
        regWriteSig_Mem
    );

    Mem_WBInstance: entity work.Mem_WB port map(
        clk,
        reset,
        Rdst_sel_Mem,
        Rdst_sel_Mem_WB,
        Alu_Out_Mem,
        Alu_Out_Mem_WB,
        readData_Mem,
        readData_Mem_WB,
        memReadSig_Mem,
        memReadSig_Mem_WB,
        regWriteSig_Mem,
        regWriteSig_Mem_WB
    );

    WBInstance: entity work.WBStage port map(
        clk,
        reset,
        Rdst_sel_Mem_WB,
        Alu_Out_Mem_WB,
        readData_Mem_WB,
        regWriteSig_Mem_WB,
        memReadSig_Mem_WB,
        writeRegisterEnable_D,
        writeRegisterSel_D,
        writeRegisterData_D
    );


    
END Processor_design;

