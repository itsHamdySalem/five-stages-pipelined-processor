library ieee;
use ieee.std_logic_1164.all;
USE IEEE.numeric_std.all;

entity EX_Mem is
    Port ( clk : in STD_LOGIC;
           rst : in STD_LOGIC;
           instruction: in STD_LOGIC_VECTOR(15 downto 0);
           Rdst_sel_in : in STD_LOGIC_VECTOR(2 downto 0);
           MemAdr_in : in STD_LOGIC_VECTOR(31 downto 0);
           instruction_out: out STD_LOGIC_VECTOR(15 downto 0);
           MemAdr_out : out STD_LOGIC_VECTOR(31 downto 0);
           Rdst_sel_out : out STD_LOGIC_VECTOR(2 downto 0);
           memReadSig_in : in std_logic;
           memReadSig_out : out std_logic;
           Aluin : in STD_LOGIC_VECTOR(31 downto 0);
           Aluout : out STD_LOGIC_VECTOR(31 downto 0)


           );
end EX_Mem;

architecture Behavioral of EX_Mem is
    
begin
    process(clk, rst) -- TODO:: deal with the reset if there is any.
    begin 
        if rising_edge(clk) then
            instruction_out <= instruction;
            MemAdr_out <= MemAdr_in;
            Rdst_sel_out <= Rdst_sel_in;
            memReadSig_out <= memReadSig_in;
            Aluout <= Aluin;
        end if;
    end process;
end Behavioral;
