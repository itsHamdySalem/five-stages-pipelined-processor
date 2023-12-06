
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.all;
use ieee.std_logic_unsigned.all;

entity AluEnt is 
port(
A,B: in std_logic_vector (31 downto 0) ; 
S: in std_logic_vector(4 downto 0);
In_Flags:in std_logic_vector(2 downto 0);
Out_Flags:out std_logic_vector(2 downto 0) ;
F : out std_logic_vector(31 DOWNTO 0)
);
end entity AluEnt;

architecture AluArch of AluEnt is 

component my_nadder IS
PORT   (     a, b : IN std_logic_vector(31 DOWNTO 0) ;
             cin : IN std_logic;
             s : OUT std_logic_vector(31 DOWNTO 0);
             cout : OUT std_logic);
end component my_nadder;

signal AND_Output    : std_logic_vector(31 downto 0);
signal OR_Output     : std_logic_vector(31 downto 0);
signal ADD_Output    : std_logic_vector(31 downto 0);
signal SUB_Output    : std_logic_vector(31 downto 0);
signal INC_Output    : std_logic_vector(31 downto 0);
signal DEC_Output    : std_logic_vector(31 downto 0);
signal A_NOT     : std_logic_vector(31 downto 0);
signal B_NOT     : std_logic_vector(31 downto 0);
signal F_Temp  : std_logic_vector(31 downto 0);
signal NEG_A     : std_logic_vector(31 downto 0);
signal XOR_Output    : std_logic_vector(31 downto 0);

signal ADD_Carry : std_logic;
signal SUB_Carry : std_logic;
signal INC_Carry : std_logic;
signal DEC_Carry : std_logic;
signal dummySub    : std_logic;
signal dummyDec    : std_logic;

begin 
-----------------------------------------------------------------------------------
--------------------------------OneOP----------------------------------------------
A_NOT <= not A; -- 00001

NEG_A <= not A + "00000000000000000000000000000001"; --00010
 
INClable : my_nadder port map(A,(others=>'0'),'1',INC_Output,INC_Carry); --00011
 
DEClable: my_nadder port map(A,(others=>'1'),'0',DEC_Output,dummyDec); --00100


-----------------------------------------------------------------------------------
--------------------------------TwoOP----------------------------------------------
ADDlable : my_nadder port map(A,B,'0',ADD_output,ADD_Carry); --01110

B_NOT <= not B;
SUBlable: my_nadder port map(A,B_NOT,'1',SUB_output,dummySub); --01111

AND_Output <= A and B;--10010

OR_Output <= A or B; --10011

XOR_Output <= A xor B; --10100

----------------------------------------------------------------------------------
---------------------------------Flags--------------------------------------------

------------------subtraction flag
SUB_Carry <= '1' when S = "01111" and to_integer(signed(B)) < to_integer(signed(A)) else '0';
------------------Decrease flag
DEC_Carry <= '1' when S = "00100" and to_integer(signed(A)) <= 0 else '0';

------------------ flag(0) -> Z
Out_Flags(0) <= '1' when F_Temp =  "00000000000000000000000000000000" and S /= "11111" else '0';

------------------ flag(1) -> N
Out_Flags(1) <= F_Temp(31) when S /= "11111" else In_Flags(1);

------------------ flag(2) -> C
Out_Flags(2) <= INC_Carry when  S="00011"
else DEC_Carry when S = "00100" 
else ADD_Carry when S = "01110" 
else SUB_Carry when S = "01111"  
else In_Flags(2) ;
    
--------------------------------------------------------------------------------------
------------------------------------F(Rdst)-------------------------------------------
F_Temp <= (A_NOT)   When S = "00001"
    else (INC_Output)    when  S =  "00011"
    else (NEG_A)    when  S =  "00010"
    else (DEC_Output) when  S =  "00100"
    else (ADD_Output)   when  S =  "01110"
    else (SUB_Output) when  S =  "01111"
    else (AND_Output)   when  S =  "10010"
    else (OR_Output)  when  S =  "10011"
    else (XOR_Output)  when  S =  "10100"
    else(A);
	
    F <= F_Temp;

end architecture AluArch;