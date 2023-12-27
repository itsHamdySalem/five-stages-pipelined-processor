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
        writeData:          in std_logic_vector(31 downto 0);
        readData:           out std_logic_vector(31 downto 0);
        protectAddress:     in std_logic_vector(11 downto 0); -- New input for protecting a cell
        protectEnable:      in std_logic;                    -- New input for protecting a cell
        instruction:        in std_logic_vector(15 DOWNTO 0);
        alu_out:            in std_logic_vector(31 DOWNTO 0);
        inc : IN std_logic_vector(2 DOWNTO 0);
        sp : OUT std_logic_vector(11 DOWNTO 0);
        curData: out std_logic_vector(31 downto 0);
        freeEnable:      in std_logic
    );
end entity;

architecture dataMemDesign of dataMem is
    type ram_type is array(0 to 2**12 - 1) of std_logic_vector(31 downto 0);
    signal ram: ram_type := (0 => x"00000000", 1 => x"00000000", others => x"00000000");
    type ram_protected_type is array(0 to 2**12 - 1) of std_logic;
    signal ram_protected: ram_protected_type := (0 => '0', 1 => '0', others => '0');
      signal curSP: STD_LOGIC_VECTOR(11 DOWNTO 0) := "111111111111";

begin

    process(clk, rst)
    variable spINC:std_logic_vector(11 downto 0);
    begin    
        if rst = '1' then
            ram <= (others => (others => '0'));
            ram_protected <= (others => '0');

            sp <= "111111111111";                          
            spINC := (others => '0');   
        elsif rising_edge(clk) then
            if inc = "001" then
                -- curSP <= "111111111111";
                curSP <= std_logic_vector(unsigned(curSP) + 1);
            elsif inc = "010" then
                curSP <= std_logic_vector(unsigned(curSP) + 2);
            elsif inc = "111" then
                -- curSP <= "111111111110";
                curSP <= std_logic_vector(unsigned(curSP) - 1);
            end if;
            -- curSP <= spINC;
        elsif falling_edge(clk) then
            if instruction(15 downto 11) = "00101" then -- PUSH
                ram(to_integer(unsigned(curSP))) <= alu_out;
            elsif protectEnable = '1' then
                ram_protected(to_integer(unsigned(protectAddress))) <= '1';
            elsif freeEnable = '1' then
                ram_protected(to_integer(unsigned(protectAddress))) <= '0';
            elsif writeEnable = '1' and ram_protected(to_integer(unsigned(writeAddress))) = '0' then
                ram(to_integer(unsigned(writeAddress))) <= writeData;
            end if;
        end if;

        readData <= ram(to_integer(unsigned(curSP) + 1)) when instruction(15 downto 11) = "00110"
            else ram(to_integer(unsigned(readAddress))) when readEnable = '1'
            else (others => '0');
        sp <= curSP;  
        curData <= ram(2**12-1);

    end process;
    
		

    
        
end dataMemDesign;
