LIBRARY IEEE;
USE IEEE.std_logic_1164.all;
USE IEEE.numeric_std.all;

ENTITY PC IS
    PORT (
        clk, reset, enable : IN  std_logic;
        inc : IN std_logic_vector(15 DOWNTO 0);
        pcSel : IN std_logic;
        pcData : IN std_logic_vector(15 DOWNTO 0);
        pc : OUT std_logic_vector(15 DOWNTO 0)
    );
END PC;

ARCHITECTURE PC_design OF PC IS
    SIGNAL pc_reg : std_logic_vector(15 DOWNTO 0) := (OTHERS => '0');
BEGIN
    PROCESS (clk, reset)
        VARIABLE pcINC: std_logic_vector(15 DOWNTO 0);
    BEGIN
        IF reset = '1' THEN
            pc_reg <= x"0000";
        ELSIF rising_edge(clk) THEN
            IF enable = '1' THEN
                pcINC := std_logic_vector(unsigned(pc_reg) + unsigned(inc));
                IF pcSel = '1' THEN
                    pc_reg <= pcData;
                ELSE
                    pc_reg <= pcINC;
                END IF;
            END IF;
        END IF;
    END PROCESS;

    pc <= pc_reg;
END PC_design;
