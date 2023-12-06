
Library IEEE;
USE IEEE.std_logic_1164.all;
entity EA_extend is
port (
EA : in std_logic_vector (19 downto 0);
F : out std_logic_vector (31 downto 0)
);
end entity;

architecture EA_extend_arch of EA_extend is
begin
    F (31 downto 20) <=  (others => '0') ;
    F (19 downto 0) <= EA ; 
end architecture;