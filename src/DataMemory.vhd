library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity dataMem is
    port(
        clk:                in std_logic;
        rst:                in std_logic;
        readAddress:        in std_logic_vector(11 downto 0);
        readEnable:         in std_logic;
        writeAddress:       in std_logic_vector(11 downto 0);
        writeEnable:        in std_logic;
        writeData:          in std_logic_vector(15 downto 0);
        readData:           out std_logic_vector(15 downto 0);
        protectAddress:     in std_logic_vector(11 downto 0); -- New input for protecting a cell
        protectEnable:      in std_logic                    -- New input for protecting a cell
    );
end entity;

architecture dataMemDesign of dataMem is
    type ram_type is array(0 to 2**12 - 1) of std_logic_vector(15 downto 0);
    signal ram: ram_type;
    type ram_protected_type is array(0 to 2**12 - 1) of std_logic;
    signal ram_protected: ram_protected_type;

begin

    process(clk, rst)
    begin    
        ram(0) <= x"00F1";
        ram(1) <= x"00F2";
        ram(2) <= x"00F3";
        ram(3) <= x"00F4";
        if rst = '1' then
            ram <= (others => (others => '0'));
            ram_protected <= (others => '0');
        elsif falling_edge(clk) then
            if protectEnable = '1' then
                ram_protected(to_integer(unsigned(protectAddress))) <= '1';
            elsif writeEnable = '1' and ram_protected(to_integer(unsigned(writeAddress))) = '0' then
                ram(to_integer(unsigned(writeAddress))) <= writeData;
            end if;
        end if;
    end process;
    
    readData <= ram(to_integer(unsigned(readAddress))) when readEnable = '1' else (others => '0');

end dataMemDesign;
