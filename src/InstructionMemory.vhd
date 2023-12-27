LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_textio.ALL;
USE std.textio.ALL;
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_textio.ALL;
USE std.textio.ALL;
USE IEEE.numeric_std.all;

ENTITY instructionMem IS
    PORT (
        clk:                IN std_logic;
        rst :               IN std_logic;
        readAddress :    	IN std_logic_vector(11 DOWNTO 0);
        instruction :       OUT std_logic_vector(15 DOWNTO 0); 
        immediate :         OUT std_logic_vector(15 DOWNTO 0)
    );
END ENTITY instructionMem;

ARCHITECTURE instructionMem_design OF instructionMem  IS 
    TYPE ram_type IS ARRAY(0 TO 2**12 - 1) OF std_logic_vector(15 DOWNTO 0);
        
    SIGNAL ram : ram_type ;

BEGIN


    -- ram(0) <= "1101000000000000";  -- LDD instruction
    -- ram(1) <= "0000000000000001";  -- Imm
    -- ram(2) <= "0010001000001000";  -- DEC instruction
    -- ram(3) <= "0010001000001000";  -- DEC instruction
    -- ram(4) <= "0010001000001000";  -- DEC instruction
    -- ram(5) <= "1001101100001101";  -- OR instruction
    -- ram(6) <= "0110100000000000";  -- OUT instruction
    -- ram(7) <= "1101000000000000";  -- LDD instruction
    -- ram(8) <= "0000000000000001";  -- Imm
    -- ram(9) <= "0010001000001000";  -- DEC instruction
    -- ram(10) <= "0010001000001000";  -- DEC instruction
    -- ram(11) <= "0010001000001000";  -- DEC instruction
    -- ram(12) <= "1001101100001101";  -- OR instruction
 
    -- ram(0) <= "1001101100001101";  -- OR instruction
    -- ram(1) <= "0010001000001000";  -- DEC instruction
    -- ram(2) <= "1001101000001000";  -- OR instruction

    initialize_memory : PROCESS
    FILE memory_file : text OPEN READ_MODE IS "program.mem";
    VARIABLE file_line : line;
    VARIABLE temp_data : STD_LOGIC_VECTOR(15 DOWNTO 0);
    BEGIN

        FOR i IN ram'RANGE LOOP
            IF NOT endfile(memory_file) THEN
                readline(memory_file, file_line);
                read(file_line, temp_data);
                ram(i) <= temp_data;

            ELSE
                file_close(memory_file);
                WAIT;
            END IF;
        END LOOP;

    END PROCESS;

   
    process(clk, rst)
    begin
        IF rising_edge(clk) THEN
        instruction  <= ram(to_integer(unsigned(readAddress)));
        immediate    <= ram(to_integer(unsigned(readAddress))+1);
        END IF;

    END PROCESS;

END instructionMem_design;
