
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.all;
use ieee.std_logic_unsigned.all;

entity AluEnt is 
port(
A,B: in std_logic_vector (31 downto 0); 
S: in std_logic_vector(4 downto 0);
In_Flags:in std_logic_vector(2 downto 0);
Out_Flags:out std_logic_vector(2 downto 0);
F : out std_logic_vector(31 DOWNTO 0)
);
end entity AluEnt;

architecture AluArch of AluEnt is 

component my_nadder IS
PORT   (     a, b : IN std_logic_vector(31 DOWNTO 0);
             cin : IN std_logic;
             s : OUT std_logic_vector(31 DOWNTO 0);
             cout : OUT std_logic);
end component my_nadder;

-- >>(11000), <<(10111), bitset(10110) (a[b], cout old a[b])

signal AND_Output    : std_logic_vector(31 downto 0);
signal OR_Output     : std_logic_vector(31 downto 0);signal ADD_Output    : std_logic_vector(31 downto 0);
signal SUB_Output    : std_logic_vector(31 downto 0);
signal INC_Output    : std_logic_vector(31 downto 0);
signal DEC_Output    : std_logic_vector(31 downto 0);
signal shift_left_Output    : std_logic_vector(31 downto 0);
signal shift_left_Amount    : std_logic_vector(4 downto 0);
signal shift_left_input_concatened : std_logic_vector(32 downto 0);
signal shift_left_output_concatened : std_logic_vector(32 downto 0);
signal shift_right_Output    : std_logic_vector(31 downto 0);
signal shift_right_Amount    : std_logic_vector(4 downto 0);
signal shift_right_input_concatened : std_logic_vector(32 downto 0);
signal shift_right_output_concatened : std_logic_vector(32 downto 0);
signal bit_set_Output    : std_logic_vector(31 downto 0);
signal A_NOT     : std_logic_vector(31 downto 0);
signal B_NOT     : std_logic_vector(31 downto 0);
signal F_Temp  : std_logic_vector(31 downto 0);
signal NEG_A     : std_logic_vector(31 downto 0);
signal XOR_Output    : std_logic_vector(31 downto 0);

signal ADD_Carry : std_logic;
signal SUB_Carry : std_logic;
signal INC_Carry : std_logic;
signal DEC_Carry : std_logic;
signal shift_left_Carry : std_logic;
signal shift_right_Carry : std_logic;
signal bit_set_Carry : std_logic;
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
--------------------------------shift right----------------------------------------

shift_right_input_concatened <= A & In_Flags(2);
shift_right_Amount <= B(4 downto 0);



shift_right_output_concatened <= shift_right_input_concatened(to_integer(unsigned(shift_right_Amount))-1 downto 0) & 
                                shift_right_input_concatened(32 downto to_integer(unsigned(shift_right_Amount))) 
                                when to_integer(unsigned(shift_right_Amount)) > 0 else shift_right_input_concatened;

shift_right_Carry <= shift_right_output_concatened(0);
shift_right_Output <= shift_right_output_concatened(32 downto 1);

----------------------------------------------------------------------------------
--------------------------------shift left----------------------------------------

shift_left_input_concatened <= A & In_Flags(2);
shift_left_Amount <= B(4 downto 0);



shift_left_output_concatened <= shift_left_input_concatened(32-to_integer(unsigned(shift_left_Amount)) downto 0) & 
                                shift_left_input_concatened(32 downto 33-to_integer(unsigned(shift_left_Amount))) 
                                when to_integer(unsigned(shift_left_Amount)) > 0 else shift_left_input_concatened;

shift_left_Carry <= shift_left_output_concatened(0);
shift_left_Output <= shift_left_output_concatened(32 downto 1);


----------------------------------------------------------------------------------
--------------------------------bitset--------------------------------------------

bit_set_Carry <= A(to_integer(unsigned(B(4 downto 0))));

process
begin

    for i in 0 to 31 loop
        bit_set_Output(i) <= '1' when to_integer(unsigned(B(4 downto 0))) = i else A(i);
    end loop;

wait;
end process;


----------------------------------------------------------------------------------
---------------------------------Flags--------------------------------------------

------------------subtraction flag
SUB_Carry <= '1' when S = "01111" and to_integer(signed(B)) < to_integer(signed(A)) else '0';
------------------Decrease flag
DEC_Carry <= '1' when S = "00100" and to_integer(signed(A)) <= 0 else '0';

------------------ flag(0) -> Z
Out_Flags(0) <= '1' when F_Temp =  "00000000000000000000000000000000" and S /= "11111" else In_Flags(0);

------------------ flag(1) -> N
Out_Flags(1) <= F_Temp(31) when S /= "11111" else In_Flags(1);

------------------ flag(2) -> C
Out_Flags(2) <= INC_Carry when  S="00011"
else DEC_Carry when S = "00100" 
else ADD_Carry when S = "01110" 
else SUB_Carry when S = "01111" 
else shift_right_Carry when S = "11000"
else shift_left_Carry when S = "10111"
else bit_set_Carry when S = "10110"
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
    else shift_right_Output when S = "11000"
    else shift_left_Output when S = "10111"
    else bit_set_Output when S = "10110"
    else(A);
	
    F <= F_Temp;

end architecture AluArch;
