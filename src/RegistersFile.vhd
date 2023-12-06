library ieee;
use ieee.std_logic_1164.all;
USE IEEE.numeric_std.all;

entity RegistersFile is
    Port ( clk : in STD_LOGIC;
           rst : in STD_LOGIC;
           Rsrc1_sel : in std_logic_vector(2 downto 0);
           Rsrc2_sel : in std_logic_vector(2 downto 0);
           Rdst_sel : in STD_LOGIC_VECTOR(2 downto 0);
           write_flag : in std_logic;
           write_reg : in std_logic_vector(2 downto 0);
           write_data : in STD_LOGIC_VECTOR(31 downto 0);

           Rsrc1 : out STD_LOGIC_VECTOR(31 downto 0);
           Rsrc2 : out STD_LOGIC_VECTOR(31 downto 0);
           Rdst : out STD_LOGIC_VECTOR(31 downto 0);
           R0,R1,R2,R3,R4,R5,R6,R7: OUT std_logic_vector(31 DOWNTO 0)

    );
end RegistersFile;

architecture Behavioral of RegistersFile is
    type registerFile is array (0 to 7) of STD_LOGIC_VECTOR(31 downto 0);
    signal R : registerFile := (others => (others => '0'));
begin
    process(clk, rst)
    begin
        if rst = '1' then
            R <= (others => (others => '0'));   
        elsif falling_edge(clk) then
            if write_flag = '1' then
                R(to_integer(unsigned(write_reg))) <= write_data;
            end if;
        end if;
    end process;
    Rsrc1 <= R(to_integer(unsigned(Rsrc1_sel)));
    Rsrc2 <= R(to_integer(unsigned(Rsrc2_sel)));
    Rdst <= R(to_integer(unsigned(Rdst_sel)));
    R0 <= R(0);
    R1 <= R(1);
    R2 <= R(2);
    R3 <= R(3);
    R4 <= R(4);
    R5 <= R(5);
    R6 <= R(6);
    R7 <= R(7);
end Behavioral;
