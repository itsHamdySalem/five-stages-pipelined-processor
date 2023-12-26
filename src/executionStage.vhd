LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.all;

ENTITY ExecutionStage IS
    PORT (
        clk:                IN std_logic;
        rst :               IN std_logic;
        instruction:        IN std_logic_vector(15 DOWNTO 0);
        isOneOp :           IN STD_LOGIC;
        isImmediate :           IN STD_LOGIC;
        RS1 :           IN std_logic_vector(31 DOWNTO 0);
        RS2 :           IN std_logic_vector(31 DOWNTO 0);
        RDst :          IN std_logic_vector(31 DOWNTO 0);
        ImmVal :          IN std_logic_vector(31 DOWNTO 0);
        willBranch:              OUT STD_LOGIC;
        outFlag:              OUT std_logic_vector(2 DOWNTO 0);
        Alu_Out:                OUT std_logic_vector(31 downto 0);
        memReadSig_in:          IN STD_LOGIC;
        memReadSig_out:         out STD_LOGIC;
        instruction_out:        out std_logic_vector(15 DOWNTO 0);
        Rdst_sel_in : IN STD_LOGIC_VECTOR(2 downto 0);
        Rdst_sel_out : out STD_LOGIC_VECTOR(2 downto 0);
        MemAdr : in STD_LOGIC_VECTOR(31 downto 0);
        MemAdr_out : out STD_LOGIC_VECTOR(31 downto 0);

        regWriteSig_in:      IN STD_LOGIC;
        regWriteSig_out:      out STD_LOGIC;
        Z,N,C:              out std_logic;
        spIncIn,spDecIn:              in std_logic;
        spIncOut,spDecOut:              out std_logic
        

    );
END ENTITY ExecutionStage;

ARCHITECTURE execution OF ExecutionStage  IS
 
signal A : std_logic_vector(31 DOWNTO 0);
signal B : std_logic_vector(31 DOWNTO 0);
signal F_out : std_logic_vector(31 DOWNTO 0);
signal outFlag_temp : std_logic_vector(2 DOWNTO 0);

BEGIN

    A <= RS1 when isOneOp = '0' else RDst;
    B <= RS2 when isImmediate = '0' else ImmVal;

    ALUInstance : entity work.AluEnt port map(A, B, instruction(15 downto 11), "000", outFlag_temp, F_out);

    Alu_Out <= F_out;
    outFlag <= outFlag_temp;

    memReadSig_out <= memReadSig_in;
    instruction_out <= instruction;

    Rdst_sel_out <= Rdst_sel_in;
    MemAdr_out <= MemAdr;

    regWriteSig_out <= regWriteSig_in;

    Z <= outFlag_temp(0);
    N <= outFlag_temp(1);
    C <= outFlag_temp(2);

    spDecOut <= spDecIn;
    spIncOut <= spIncIn;
END execution;
