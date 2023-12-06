LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;

entity ALU_Mux_1 is 
port(
R1,ALU_forward,MEM_forward: in std_logic_vector (31 downto 0) ; 
Sel: in std_logic_vector(1 downto 0);
F : out std_logic_vector(31 downto 0));
end entity ALU_Mux_1;

-- 00 ->R1
-- 01 ->ALU_forward
-- 10 ->MEM_forward
-- 11 ->R1-> avoid latch

architecture ALU_Mux1_Arch of ALU_Mux_1 is 
begin

    F <= ALU_forward  WHEN Sel(1) = '0' and Sel(0) = '1'
ELSE MEM_forward  WHEN Sel(1) = '1' and Sel(0) = '0'
ELSE R1;

end architecture ALU_Mux1_Arch;