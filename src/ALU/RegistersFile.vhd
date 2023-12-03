library ieee;
use ieee.std_logic_1164.all;
USE IEEE.numeric_std.all;

entity RegistersFile is
    Port ( clk : in STD_LOGIC;
           rst : in STD_LOGIC;
           Rsrc1_sel : in std_logic_vector(2 downto 0);
           Rsrc2_sel : in std_logic_vector(2 downto 0);
           write_flag : in std_logic;
           write_reg : in std_logic_vector(2 downto 0);
           write_data : in STD_LOGIC_VECTOR(15 downto 0);
           readData1 : out STD_LOGIC_VECTOR(15 downto 0);
           readData2 : out STD_LOGIC_VECTOR(15 downto 0)
    );
end RegistersFile;

architecture Behavioral of RegistersFile is
    type registerFile is array (0 to 7) of STD_LOGIC_VECTOR(31 downto 0);
    signal R : registerFile := (others => (others => '0'));
    signal PC, SP : STD_LOGIC_VECTOR(31 downto 0);
    signal CCR : STD_LOGIC_VECTOR(3 downto 0);
begin
    process(clk, rst)
    begin
        if rst = '1' then
            R <= (others => (others => '0'));
        elsif rising_edge(clk) then
            if write_flag = '1' then
                R(to_integer(unsigned(write_reg))) <= write_data;
            end if;
        else 
            readData1 <= R(to_integer(unsigned(Rsrc1_sel)));
            readData2 <= R(to_integer(unsigned(Rsrc2_sel)));
        end if;
    end process;
end Behavioral;
