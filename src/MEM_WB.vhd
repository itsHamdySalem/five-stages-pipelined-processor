library ieee;
use ieee.std_logic_1164.all;
USE IEEE.numeric_std.all;

entity EX_Mem is
    Port (  clk : in STD_LOGIC;
            rst : in STD_LOGIC;
            instruction: in STD_LOGIC_VECTOR(15 downto 0);
            Rdst_sel_in : in STD_LOGIC_VECTOR(2 downto 0);
            forwarding_unit_in : in  STD_LOGIC_VECTOR(31 downto 0);
            data_in : in  STD_LOGIC_VECTOR(31 downto 0);
            is_in_port_in, is_mem_in, RW_in : in std_logic;


            Rdst_sel_out : out STD_LOGIC_VECTOR(2 downto 0);
            forwarding_unit_out : out  STD_LOGIC_VECTOR(31 downto 0);
            data_out : out  STD_LOGIC_VECTOR(31 downto 0);
            is_in_port_in, is_mem_in, RW_in : out std_logic;
           );
end EX_Mem;

architecture Behavioral of EX_Mem is
    
begin
    process(clk, rst) -- TODO:: deal with the reset if there is any.
    begin 
        if rising_edge(clk) then
            Rdst_sel_out <= Rdst_sel_in;
            forwarding_unit_out <= forwarding_unit_in;
            data_out <= data_in;
            is_in_port_out <= is_in_port_in;
            is_mem_out <= is_mem_in;
            RW_out <= RW_in;
        end if;
    end process;
end Behavioral;
