library ieee;
use ieee.std_logic_1164.all;
USE IEEE.numeric_std.all;

entity ID_EX is
    Port ( clk : in STD_LOGIC;
           rst : in STD_LOGIC;
           cjFlush : in STD_LOGIC;
           instruction: in STD_LOGIC_VECTOR(15 downto 0);
           SP_EA: in STD_LOGIC_VECTOR(31 downto 0);
           Rdst_sel_in : in STD_LOGIC_VECTOR(2 downto 0);
           immediate_in : in STD_LOGIC_VECTOR(31 downto 0);
           Rsrc1_in, Rsrc2_in, Rdest_in : in STD_LOGIC_VECTOR(31 downto 0);
           isImmediate_In : in STD_LOGIC;
           ALU_OP_In : in STD_LOGIC_VECTOR(4 downto 0);
           Mem_control_in : in STD_LOGIC_VECTOR(2 downto 0);
           WB_control_in : in STD_LOGIC_VECTOR(2 downto 0);
           isOneOp:      in STD_LOGIC;
           memReadSig_in:      IN STD_LOGIC;

           MemAdr : out STD_LOGIC_VECTOR(31 downto 0);
           Rdst_sel_out : out STD_LOGIC_VECTOR(2 downto 0);
           immediate_out : out STD_LOGIC_VECTOR(31 downto 0);
           Rsrc1_out, Rsrc2_out, Rdest_out : out STD_LOGIC_VECTOR(31 downto 0);
           isImmediate : out std_logic;
           ALU_OP : out STD_LOGIC_VECTOR(4 downto 0);
           Mem_control_out : out STD_LOGIC_VECTOR(2 downto 0);
           WB_control_out : out STD_LOGIC_VECTOR(2 downto 0);
           instruction_out: out STD_LOGIC_VECTOR(15 downto 0);
           isOneOp_out:      out STD_LOGIC;
           memReadSig_out:      out STD_LOGIC;
           regWriteSig_in:      IN STD_LOGIC;
           regWriteSig_out:      out STD_LOGIC;
           SP_INC_IN:  IN STD_LOGIC;
           SP_INC_OUT:  OUT STD_LOGIC;
           SP_DEC_IN:  IN STD_LOGIC;
           SP_DEC_OUT:  OUT STD_LOGIC
           

           );
end ID_EX;

architecture Behavioral of ID_EX is
    signal instruction_sig: STD_LOGIC_VECTOR(15 downto 0);
    signal SP_EA_sig: STD_LOGIC_VECTOR(31 downto 0);
    signal Rdst_sel_in_sig : STD_LOGIC_VECTOR(2 downto 0);
    signal immediate_in_sig : STD_LOGIC_VECTOR(31 downto 0);
    signal Rsrc1_in_sig, Rsrc2_in_sig, Rdest_in_sig : STD_LOGIC_VECTOR(31 downto 0);
    signal isImmediate_In_sig : STD_LOGIC;
    signal ALU_OP_In_sig : STD_LOGIC_VECTOR(4 downto 0);
    signal Mem_control_in_sig : STD_LOGIC_VECTOR(2 downto 0);
    signal WB_control_in_sig : STD_LOGIC_VECTOR(2 downto 0);
    signal isOneOp_sig: STD_LOGIC;
    signal memReadSig_in_sig:      STD_LOGIC;
    signal regWriteSig_in_sig:      STD_LOGIC;

    signal imm1: std_logic := '0';
    signal imm2: std_logic := '0';

    signal SP_DEC_IN_sig, SP_INC_IN_sig: STD_LOGIC := '0';

begin
    process(clk, rst, cjFlush) -- TODO:: deal with the reset if there is any.
    begin 
        if rst or cjFlush then
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
        elsIF rising_edge(clk) THEN
        if imm2 = '1' then 
            -- output <= prev signal
            imm1 <= '0';
            imm2 <= '0';

            MemAdr <= x"000" & instruction_sig(7 DOWNTO 4) & instruction;
            Rdst_sel_out <= Rdst_sel_in_sig;
            immediate_out <= x"000" & instruction_sig(7 DOWNTO 4) & instruction;
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
        elsIF isImmediate_In = '0' and imm1 = '0' THEN
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
        else 
            instruction_sig <= instruction;
            SP_EA_sig <= SP_EA;
            Rdst_sel_in_sig <= Rdst_sel_in;
            immediate_in_sig <= immediate_in;
            Rsrc1_in_sig <= Rsrc1_in;
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
            MemAdr <= (others => '0');
            Rdst_sel_out <= (others => '0');
            immediate_out <= (others => '0');
            Rsrc1_out <= (others => '0');
            Rsrc2_out <= (others => '0');
            isImmediate <= '0';
            ALU_OP <= (others => '0');
            Mem_control_out <= (others => '0');
            WB_control_out <= (others => '0');
            instruction_out <= (others => '0');
            Rdest_out <= (others => '0');
            isOneOp_out <= '0';
            memReadSig_out <= '0';
            regWriteSig_out <= '0';   
            SP_DEC_OUT <= '0';
            SP_INC_OUT <= '0';        
            imm2 <= '1';
        END IF;
        end if;
    end process;
    
end Behavioral;
