library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity Memory is
    Port ( clk : in STD_LOGIC;
           rst : in STD_LOGIC;
           mem_rw : in STD_LOGIC;  -- Read/Write control signal
           mem_addr : in STD_LOGIC_VECTOR(11 downto 0);  -- Address bus (12 bits for 4 KB)
           mem_data_in : in STD_LOGIC_VECTOR(15 downto 0);  -- Data input bus
           mem_data_out : out STD_LOGIC_VECTOR(15 downto 0)  -- Data output bus
    );
end Memory;

architecture Behavioral of Memory is
    type memory_array is array (0 to 4095) of STD_LOGIC_VECTOR(15 downto 0);
    signal memory : memory_array := (others => (others => '0'));
begin
    process(clk, rst)
    begin
        if rst = '1' then
            memory <= (others => (others => '0'));
        elsif rising_edge(clk) then
            if mem_rw = '1' then  -- Read operation
                mem_data_out <= memory(to_integer(unsigned(mem_addr)));
            else  -- Write operation
                memory(to_integer(unsigned(mem_addr))) <= mem_data_in;
            end if;
        end if;
    end process;
end Behavioral;
