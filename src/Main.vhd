LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;
ENTITY Processor IS
    PORT (
        clk, reset, enable : IN STD_LOGIC;
        enableFetch : IN STD_LOGIC
    );
END ENTITY;
ARCHITECTURE Processor_design OF Processor IS
    SIGNAL PcSelect, PcSelect2 : STD_LOGIC;
    SIGNAL PcData, PcData2 : STD_LOGIC_VECTOR(15 DOWNTO 0);
    SIGNAL pcOut, instruction_IFID : STD_LOGIC_VECTOR(15 DOWNTO 0);
    SIGNAL Rdest_IFID, RS1_IFID, RS2_IFID : STD_LOGIC_VECTOR(2 DOWNTO 0);

    SIGNAL RS1Data_D, RS2Data_D, RDestData_D : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL ImmSig_D,
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
    spIncSig_ID_EX,
    spDecSig_ID_EX,
    spIncSig_EX,
    spDecSig_EX,
    spIncSig_EX_Mem,
    spDecSig_EX_Mem,
    spIncSig_Mem,
    spDecSig_Mem,
    spDecSig_D,
    isOneOp_D,
    isOneOp_ID_EX,
    memReadSig_ID_EX,
    memReadSig_EX, memReadSig_EX_Mem, memReadSig_Mem, memReadSig_Mem_WB : STD_LOGIC;
    SIGNAL RDest_D : STD_LOGIC_VECTOR(2 DOWNTO 0);
    SIGNAL instruction_D, instruction_ID_EX, instruction_EX, instruction_EX_Mem, instruction_Mem, instruction_Mem_WB : STD_LOGIC_VECTOR(15 DOWNTO 0);
    SIGNAL instruction_F, immediate_F : STD_LOGIC_VECTOR(15 DOWNTO 0);
    SIGNAL readData_Mem, readData_Mem_WB : STD_LOGIC_VECTOR(31 DOWNTO 0);

    SIGNAL memAddress_ID_EX, memAddress_EX, memAddress_EX_Mem : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL Rdst_sel_ID_EX, Rdst_sel_EX, Rdst_sel_EX_Mem, Rdst_sel_Mem, Rdst_sel_Mem_WB : STD_LOGIC_VECTOR(2 DOWNTO 0);
    SIGNAL immediate_out_ID_EX, Rsrc1_ID_EX, Rsrc2_ID_EX, Rdest_ID_EX : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL isImmediate_ID_EX : STD_LOGIC;
    SIGNAL ALU_OP_ID_EX : STD_LOGIC_VECTOR(4 DOWNTO 0);
    SIGNAL Mem_control_out_ID_EX, WB_control_out_ID_EX : STD_LOGIC_VECTOR(2 DOWNTO 0);

    SIGNAL willBranch_EX : STD_LOGIC;
    SIGNAL outFlag_EX : STD_LOGIC_VECTOR(2 DOWNTO 0);
    SIGNAL Alu_Out_EX, Alu_Out_EX_Mem, Alu_Out_Mem, Alu_Out_Mem_WB : STD_LOGIC_VECTOR(31 DOWNTO 0);

    SIGNAL writeRegisterEnable_D : STD_LOGIC;
    SIGNAL writeRegisterSel_D : STD_LOGIC_VECTOR(2 DOWNTO 0);
    SIGNAL writeRegisterData_D : STD_LOGIC_VECTOR(31 DOWNTO 0);

    SIGNAL R0, R1, R2, R3, R4, R5, R6, R7 : STD_LOGIC_VECTOR(31 DOWNTO 0);

    SIGNAL OutReg : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL SP : STD_LOGIC_VECTOR(11 DOWNTO 0);
    SIGNAL curData : STD_LOGIC_VECTOR(31 DOWNTO 0);

    SIGNAL Z, N, C : STD_LOGIC;

    SIGNAL RS1_ID_EX, RS2_ID_EX : STD_LOGIC_VECTOR(2 DOWNTO 0);
    SIGNAL Fwrd_sel1, Fwrd_sel2, zin, zout : STD_LOGIC;
    SIGNAL Fwrd_data1, Fwrd_data2 : STD_LOGIC_VECTOR(31 DOWNTO 0);

BEGIN
    fetchStageInstance : ENTITY work.fetchStage PORT MAP(
        clk,
        reset,
        enableFetch,
        PcSelect,
        PcData,
        instruction_F,
        immediate_F,
        pcOut,
        PcSelect2,
        PcData2
        );

    IF_IDInstance : ENTITY work.IF_ID PORT MAP(
        clk,
        reset,
        instruction_F,
        RS1_IFID,
        RS2_IFID,
        Rdest_IFID,
        instruction_IFID
        );

    DecodeInstance : ENTITY work.DecodingStage PORT MAP(
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
        R0, R1, R2, R3, R4, R5, R6, R7,
        PcSelect,
        PcData
        );

    ID_EXInstance : ENTITY work.ID_EX PORT MAP(
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
        regWriteSig_ID_EX,
        spIncSig_D,
        spIncSig_ID_EX,
        spDecSig_D,
        spDecSig_ID_EX,
        RS1_IFID, RS2_IFID,
        RS1_ID_EX, RS2_ID_EX
        );

    ForwardingUnitInstance : ENTITY work.ForwardingUnit PORT MAP(
        clk,
        isOneOp_ID_EX,
        Rdst_sel_ID_EX,
        RS1_ID_EX,
        RS2_ID_EX,
        Rdst_sel_EX_Mem,
        Rdst_sel_Mem_WB,
        Alu_Out_EX_Mem,
        Alu_Out_Mem_WB,
        Fwrd_sel1,
        Fwrd_sel2,
        Fwrd_data1,
        Fwrd_data2
        );

    EXInstance : ENTITY work.ExecutionStage PORT MAP(
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
        regWriteSig_EX,
        Z, N, C,
        spIncSig_ID_EX,
        spDecSig_ID_EX,
        spIncSig_EX,
        spDecSig_EX,
        Fwrd_sel1,
        Fwrd_sel2,
        Fwrd_data1,
        Fwrd_data2,
        PcSelect2,
        PcData2,
        zout
        );

    EX_MemInstance : ENTITY work.EX_Mem PORT MAP(
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
        regWriteSig_EX_Mem,
        spIncSig_EX,
        spDecSig_EX,
        spIncSig_EX_Mem,
        spDecSig_EX_Mem,
        Z,zout
        );

    MemInstance : ENTITY work.memoryStage PORT MAP(
        clk,
        reset,
        instruction_EX_Mem,
        Alu_Out_EX_Mem,
        memAddress_EX_Mem,
        memReadSig_EX_Mem,
        '0',
        x"00000000",
        Rdst_sel_EX_Mem,
        readData_Mem,
        Alu_Out_Mem,
        Rdst_sel_Mem,
        memReadSig_Mem,
        regWriteSig_EX_Mem,
        regWriteSig_Mem,
        instruction_Mem,
        spIncSig_EX_Mem,
        spDecSig_EX_Mem,
        spIncSig_Mem,
        spDecSig_Mem,
        SP,
        curData
        );

    Mem_WBInstance : ENTITY work.Mem_WB PORT MAP(
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
        regWriteSig_Mem_WB,
        instruction_Mem,
        instruction_Mem_WB
        );

    WBInstance : ENTITY work.WBStage PORT MAP(
        clk,
        reset,
        Rdst_sel_Mem_WB,
        Alu_Out_Mem_WB,
        readData_Mem_WB,
        regWriteSig_Mem_WB,
        memReadSig_Mem_WB,
        writeRegisterEnable_D,
        writeRegisterSel_D,
        writeRegisterData_D,
        instruction_Mem_WB,
        OutReg,
        OutReg
        );

END Processor_design;