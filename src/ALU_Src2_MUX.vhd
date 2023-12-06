LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;

entity ALU_Mux_2 is 
port(
R2,Imd_Val,ALU_forward,MEM_forward: in std_logic_vector (31 downto 0) ; 
Imd_Sel: in std_logic;
Sel: in std_logic_vector (1 downto 0);
F : out std_logic_vector(31 downto 0));
end entity ALU_Mux_2;

-- Sel -> from Forwarding unit 

-- 00 ->R2
-- 01 ->ALU_forward
-- 10 ->MEM_forward
-- 11 ->R2-> avoid latch
-------------------------------------------
-- Imd_Sel -> from ??  

-- 1  -> Imd_val
-------------------------------------------


architecture ALU_Mux2_Arch of ALU_Mux_2 is 
begin
F <=  ALU_forward  WHEN Sel(1) = '0' and Sel(0) = '1'
ELSE MEM_forward  WHEN Sel(1) = '1' and Sel(0) = '0'
ELSE Imd_Val  WHEN Imd_Sel = '1'
ELSE R2;


  

end architecture ALU_Mux2_Arch;