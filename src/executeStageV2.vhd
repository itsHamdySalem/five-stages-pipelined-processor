
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;

entity exeStage is 
port(
-------------------------------------------------------------------
------------------INPUTs
DE_Rdst, DE_Rs1, DE_Rs2, DE_Immd : in std_logic_vector (31 downto 0);
DE_Rdst_adrs, DE_Rs1_adrs, DE_Rs2_adrs : in std_logic_vector (2 downto 0);
DE_OpCode : in std_logic_vector (4 downto 0); 

aluForWard , memForWard: in std_logic_vector (31 downto 0) ;
ForWardSel1,ForWardSel2 : in std_logic_vector (1 downto 0) ;

isImmediate :           IN STD_LOGIC;

In_Flags : in std_logic_vector (2 downto 0)  :=(others => '0'); 

clk,Reset: in std_logic;

-------------------------------------------------------------------
------------------OUTPUTs
EM_AluOutput, EM_Rd, EM_Rs2 : out std_logic_vector (31 downto 0);
EM_Rd_adrs, EM_Rs1_adrs, EM_Rs2_adrs : out std_logic_vector (2 downto 0);
EM_OpCode : out std_logic_vector (4 downto 0); 

Out_Flags : out std_logic_vector (2 downto 0)   :=(others => '0')

);

end entity exeStage;

architecture ExeStageArch of exeStage is 

-------------------------------------------------------------------
------------------COMPONENTs
component ALU_Mux_1 is 
port(
    R1,ALU_forward,MEM_forward: in std_logic_vector (31 downto 0) ; 
    Sel: in std_logic_vector(1 downto 0);
    F : out std_logic_vector(31 downto 0)
    );
end component ALU_Mux_1;

component ALU_Mux_2 is 
port(
    R2,Imd_Val,ALU_forward,MEM_forward: in std_logic_vector (31 downto 0) ; 
    Imd_Sel: in std_logic;
    Sel: in std_logic_vector (1 downto 0);
    F : out std_logic_vector(31 downto 0)
    );
end component ALU_Mux_2;

component AluEnt is 
port(
A,B: in std_logic_vector (31 downto 0) ; 
S: in std_logic_vector(4 downto 0);
In_Flags:in std_logic_vector(2 downto 0);
Out_Flags:out std_logic_vector(2 downto 0) ;
F : out std_logic_vector(31 DOWNTO 0)
);
end component AluEnt;




signal Alu_Mux1_Output,Alu_Mux2_Output : std_logic_vector(31 downto 0);
signal  ALU_FLAGS_OUT : std_logic_vector(2 downto 0);
begin

-------------------------------------------------------------------
------------------from DE to ME
EM_Rd <= DE_Rdst; 
EM_Rs2 <= DE_Rs2; 

EM_Rd_adrs  <= DE_Rdst_adrs; 
EM_Rs1_adrs <= DE_Rs1_adrs; 
EM_Rs2_adrs <= DE_Rs2_adrs; 

EM_OpCode <= DE_OpCode;

Out_Flags <= (others => '0') when ALU_FLAGS_OUT = "XXX" or ALU_FLAGS_OUT = "UUU" else ALU_FLAGS_OUT;

Mux1lable: ALU_Mux_1 port map (DE_Rs1 , aluForWard , memForWard, ForWardSel1 , Alu_Mux1_Output  ); 
Mux2lable: ALU_Mux_2 port map (DE_Rs2 , DE_Immd ,aluForWard ,memForWard,isImmediate ,ForWardSel2, Alu_Mux2_Output  );

AluLabel : AluEnt port map (Alu_Mux1_Output , Alu_Mux2_Output , DE_OpCode, In_Flags ,ALU_FLAGS_OUT, EM_AluOutput);

end architecture ExeStageArch;