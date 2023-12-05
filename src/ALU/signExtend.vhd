Library IEEE;
USE IEEE.std_logic_1164.all;
entity sign_extend is
port (
INPUT : in std_logic_vector (15 downto 0);
OUTPUT : out std_logic_vector (31 downto 0)
);
end entity;

architecture sign_extend_arch of sign_extend is
begin
    OUTPUT(31 downto 16) <=  (others => INPUT(15));
    OUTPUT(15 downto 0) <= INPUT ; 
end architecture;
