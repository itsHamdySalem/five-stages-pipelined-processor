LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;

ENTITY ID_EX IS
    PORT (
        clk : IN STD_LOGIC;
        rst : IN STD_LOGIC;
        instruction : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
        SP_EA : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        Rdst_sel_in : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
        immediate_in : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        Rsrc1_in, Rsrc2_in, Rdest_in : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        isImmediate_In : IN STD_LOGIC;
        ALU_OP_In : IN STD_LOGIC_VECTOR(4 DOWNTO 0);
        Mem_control_in : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
        WB_control_in : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
        isOneOp : IN STD_LOGIC;
        MemAdr : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
        Rdst_sel_out : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
        immediate_out : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
        Rsrc1_out, Rsrc2_out, Rdest_out : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
        isImmediate : OUT STD_LOGIC; -- 4-th bit in Ex_control
        ALU_OP : OUT STD_LOGIC_VECTOR(4 DOWNTO 0); -- [3:0] bits of Ex_control
        Mem_control_out : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
        WB_control_out : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
        instruction_out : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
        isOneOp_out : OUT STD_LOGIC;
        memReadSig_in : IN STD_LOGIC;
        memReadSig_out : OUT STD_LOGIC;
        regWriteSig_in : IN STD_LOGIC;
        regWriteSig_out : OUT STD_LOGIC;
        SP_INC_IN : IN STD_LOGIC;
        SP_INC_OUT : OUT STD_LOGIC;
        SP_DEC_IN : IN STD_LOGIC;
        SP_DEC_OUT : OUT STD_LOGIC;
        RS1_in, RS2_in : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
        RS1_out, RS2_out : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
        cjFlush : in STD_LOGIC
    );
END ID_EX;

ARCHITECTURE Behavioral OF ID_EX IS
    SIGNAL instruction_sig : STD_LOGIC_VECTOR(15 DOWNTO 0);
    SIGNAL SP_EA_sig : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL Rdst_sel_in_sig : STD_LOGIC_VECTOR(2 DOWNTO 0);
    SIGNAL immediate_in_sig : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL Rsrc1_in_sig, Rsrc2_in_sig, Rdest_in_sig : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL isImmediate_In_sig : STD_LOGIC;
    SIGNAL ALU_OP_In_sig : STD_LOGIC_VECTOR(4 DOWNTO 0);
    SIGNAL Mem_control_in_sig : STD_LOGIC_VECTOR(2 DOWNTO 0);
    SIGNAL WB_control_in_sig : STD_LOGIC_VECTOR(2 DOWNTO 0);
    SIGNAL isOneOp_sig : STD_LOGIC;
    SIGNAL memReadSig_in_sig : STD_LOGIC;
    SIGNAL regWriteSig_in_sig : STD_LOGIC;

    SIGNAL imm1 : STD_LOGIC := '0';
    SIGNAL imm2 : STD_LOGIC := '0';

    SIGNAL SP_DEC_IN_sig, SP_INC_IN_sig : STD_LOGIC := '0';

begin
    process(clk, rst) -- TODO:: deal with the reset if there is any.
    begin 
        if cjFlush = '1' then
            MemAdr <= (others => '0');
            Rdst_sel_out <= (others => '0');
            immediate_out <= (others => '0');
            Rsrc1_out <= (others => '0');
            Rsrc2_out <= (others => '0');
            Rdest_out <= (others => '0');
            isImmediate <= '0';
            ALU_OP <= (others => '0');
            Mem_control_out <= (others => '0');
            WB_control_out <= (others => '0');
            instruction_out <= (others => '0');
            isOneOp_out <= '0';
            memReadSig_out <= '0';
            regWriteSig_out <= '0';
            SP_INC_OUT <= '0';
            SP_DEC_OUT <= '0';
            
            instruction_sig <= (others => '0');
            SP_EA_sig <= (others => '0');
            Rdst_sel_in_sig <= (others => '0');
            immediate_in_sig <= (others => '0');
            Rsrc1_in_sig <= (others => '0');
            isImmediate_In_sig <= '0';
            ALU_OP_In_sig <= (others => '0');
            Mem_control_in_sig <= (others => '0');
            WB_control_in_sig <= (others => '0');
            isOneOp_sig <= '0';
            memReadSig_in_sig <= '0';
            regWriteSig_in_sig <= '0';
            SP_INC_IN_sig <= '0';
            SP_DEC_IN_sig <= '0';



            imm1 <= '0';
            imm2 <= '0';
        elsIF rising_edge(clk) THEN
            if imm2 = '1' then
                -- output <= prev signal
                imm1 <= '0';
                imm2 <= '0';
                MemAdr <= x"000" & instruction_sig(7 DOWNTO 4) & instruction;
                Rdst_sel_out <= Rdst_sel_in_sig;
                immediate_out <= x"0000" & instruction when instruction_sig(15 DOWNTO 11) = "10101"
                    else x"000" & instruction_sig(7 DOWNTO 4) & instruction;
                Rsrc1_out <= Rsrc1_in_sig;
                Rsrc2_out <= Rsrc2_in_sig;
                isImmediate <= isImmediate_In_sig;
                ALU_OP <= ALU_OP_In_sig;
                Mem_control_out <= Mem_control_in_sig;
                WB_control_out <= WB_control_in_sig;
                instruction_out <= instruction_sig;
                Rdest_out <= Rdest_in_sig;
                isOneOp_out <= isOneOp_sig;
                memReadSig_out <= memReadSig_in_sig;
                regWriteSig_out <= regWriteSig_in_sig;
                SP_INC_OUT <= SP_INC_IN_sig;
                SP_DEC_OUT <= SP_DEC_IN_sig;
            ELSIF isImmediate_In = '0' AND imm1 = '0' THEN
                MemAdr <= SP_EA;
                Rdst_sel_out <= Rdst_sel_in;
                immediate_out <= immediate_in;
                Rsrc1_out <= Rsrc1_in;
                Rsrc2_out <= Rsrc2_in;
                isImmediate <= isImmediate_In;
                ALU_OP <= ALU_OP_In;
                Mem_control_out <= Mem_control_in;
                WB_control_out <= WB_control_in;
                instruction_out <= instruction;
                Rdest_out <= Rdest_in;
                isOneOp_out <= isOneOp;
                memReadSig_out <= memReadSig_in;
                regWriteSig_out <= regWriteSig_in;
                SP_INC_OUT <= SP_INC_IN;
                SP_DEC_OUT <= SP_DEC_IN;
            ELSE
                instruction_sig <= instruction;
                SP_EA_sig <= SP_EA;
                Rdst_sel_in_sig <= Rdst_sel_in;
                immediate_in_sig <= immediate_in;
                Rsrc1_in_sig <= Rsrc1_in;
                Rsrc2_in_sig <= Rsrc2_in;
                Rdest_in_sig <= Rdest_in;
                isImmediate_In_sig <= isImmediate_In;
                ALU_OP_In_sig <= ALU_OP_In;
                Mem_control_in_sig <= Mem_control_in;
                WB_control_in_sig <= WB_control_in;
                isOneOp_sig <= isOneOp;
                memReadSig_in_sig <= memReadSig_in;
                regWriteSig_in_sig <= regWriteSig_in;
                SP_INC_IN_sig <= SP_INC_IN;
                SP_DEC_IN_sig <= SP_DEC_IN;

                imm1 <= '1';
                MemAdr <= (OTHERS => '0');
                Rdst_sel_out <= (OTHERS => '0');
                immediate_out <= (OTHERS => '0');
                Rsrc1_out <= (OTHERS => '0');
                Rsrc2_out <= (OTHERS => '0');
                isImmediate <= '0';
                ALU_OP <= (OTHERS => '0');
                Mem_control_out <= (OTHERS => '0');
                WB_control_out <= (OTHERS => '0');
                instruction_out <= (OTHERS => '0');
                Rdest_out <= (OTHERS => '0');
                isOneOp_out <= '0';
                memReadSig_out <= '0';
                regWriteSig_out <= '0';
                SP_DEC_OUT <= '0';
                SP_INC_OUT <= '0';
                imm2 <= '1';
            END IF;
            Rs1_out <= Rs1_in;
            Rs2_out <= Rs2_in;
        END IF;
    END PROCESS;

END Behavioral;