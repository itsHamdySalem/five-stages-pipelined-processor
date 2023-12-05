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
           write_data : in STD_LOGIC_VECTOR(31 downto 0);
           readData1 : out STD_LOGIC_VECTOR(31 downto 0);
           readData2 : out STD_LOGIC_VECTOR(31 downto 0)
    );
end RegistersFile;

architecture Behavioral of RegistersFile is
    type registerFile is array (0 to 7) of STD_LOGIC_VECTOR(31 downto 0);
    signal R : registerFile := (others => (others => '0'));
begin
    process(clk, rst)
    begin
        -- R(0) <= "00000000000000000000000000000001";
        -- R(1) <= "00000000000000000000000000000010";
        -- R(2) <= "00000000000000000000000000000100";
        -- R(3) <= "00000000000000000000000000001000";
        -- R(4) <= "00000000000000000000000000010000";
        -- R(5) <= "00000000000000000000000000100000";
        -- R(6) <= "00000000000000000000000001000000";
        -- R(7) <= "00000000000000000000000010000000";
        if rst = '1' then
            R <= (others => (others => '0'));
        elsif falling_edge(clk) then
            if write_flag = '1' then
                R(to_integer(unsigned(write_reg))) <= write_data;
            end if;
        end if;
    end process;
    readData1 <= R(to_integer(unsigned(Rsrc1_sel)));
    readData2 <= R(to_integer(unsigned(Rsrc2_sel)));
end Behavioral;
