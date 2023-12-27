LIBRARY ieee;
USE ieee.numeric_std.ALL;
USE ieee.std_logic_1164.ALL;

ENTITY ForwardingUnit IS
    PORT (
        clk : IN STD_LOGIC;
        isOneOperand : IN STD_LOGIC;
        Rdst_sel : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
        Rsrc1_sel : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
        Rsrc2_sel : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
        ALU_sel : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
        Mem_sel : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
        ALU_out : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        Mem_out : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        Fwrd_sel1 : OUT STD_LOGIC;
        Fwrd_sel2 : OUT STD_LOGIC;
        Fwrd_data1 : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
        Fwrd_data2 : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
    );
END ForwardingUnit;

ARCHITECTURE ForwardingUnitArch OF ForwardingUnit IS
BEGIN
    PROCESS (clk)
    BEGIN
        IF (isOneOperand = '1') THEN
            IF (Rdst_sel = "UUU" OR Rsrc2_sel = "UUU") THEN
                Fwrd_sel1 <= '0';
                Fwrd_sel2 <= '0';
            ELSIF (ALU_sel = Rdst_sel OR ALU_sel = Rsrc2_sel) AND (Mem_sel = Rdst_sel OR Mem_sel = Rsrc2_sel) THEN
                IF (ALU_sel = Mem_sel) THEN
                    IF (ALU_sel = Rdst_sel) THEN
                        Fwrd_sel1 <= '1';
                        Fwrd_data1 <= ALU_out;
                    ELSE
                        Fwrd_sel1 <= '0';
                    END IF;
                    IF (ALU_sel = Rsrc2_sel) THEN
                        Fwrd_sel2 <= '1';
                        Fwrd_data2 <= ALU_out;
                    ELSE
                        Fwrd_sel2 <= '0';
                    END IF;
                ELSE
                    Fwrd_sel1 <= '1';
                    Fwrd_sel2 <= '1';
                    IF (Rdst_sel = ALU_sel) THEN
                        Fwrd_data1 <= ALU_out;
                    ELSE
                        Fwrd_data1 <= Mem_out;
                    END IF;
                    IF (Rsrc2_sel = ALU_sel) THEN
                        Fwrd_data2 <= ALU_out;
                    ELSE
                        Fwrd_data2 <= Mem_out;
                    END IF;
                END IF;
            ELSIF (ALU_sel = Rdst_sel OR ALU_sel = Rsrc2_sel) XOR (Mem_sel = Rdst_sel OR Mem_sel = Rsrc2_sel) THEN
                IF (ALU_sel = Rdst_sel OR ALU_sel = Rsrc2_sel) THEN
                    IF (ALU_sel = Rdst_sel) THEN
                        Fwrd_sel1 <= '1';
                        Fwrd_data1 <= ALU_out;
                    ELSE
                        Fwrd_sel1 <= '0';
                    END IF;
                    IF (ALU_sel = Rsrc2_sel) THEN
                        Fwrd_sel2 <= '1';
                        Fwrd_data2 <= ALU_out;
                    ELSE
                        Fwrd_sel2 <= '0';
                    END IF;
                ELSE
                    IF (Mem_sel = Rdst_sel) THEN
                        Fwrd_sel1 <= '1';
                        Fwrd_data1 <= Mem_out;
                    ELSE
                        Fwrd_sel1 <= '0';
                    END IF;
                    IF (Mem_sel = Rsrc2_sel) THEN
                        Fwrd_sel2 <= '1';
                        Fwrd_data2 <= Mem_out;
                    ELSE
                        Fwrd_sel2 <= '0';
                    END IF;
                END IF;
            ELSE
                Fwrd_sel1 <= '0';
                Fwrd_sel2 <= '0';
            END IF;
        ELSE
            IF (Rsrc1_sel = "UUU" OR Rsrc2_sel = "UUU") THEN
                Fwrd_sel1 <= '0';
                Fwrd_sel2 <= '0';
            ELSIF (ALU_sel = Rsrc1_sel OR ALU_sel = Rsrc2_sel) AND (Mem_sel = Rsrc1_sel OR Mem_sel = Rsrc2_sel) THEN
                IF (ALU_sel = Mem_sel) THEN
                    IF (ALU_sel = Rsrc1_sel) THEN
                        Fwrd_sel1 <= '1';
                        Fwrd_data1 <= ALU_out;
                    ELSE
                        Fwrd_sel1 <= '0';
                    END IF;
                    IF (ALU_sel = Rsrc2_sel) THEN
                        Fwrd_sel2 <= '1';
                        Fwrd_data2 <= ALU_out;
                    ELSE
                        Fwrd_sel2 <= '0';
                    END IF;
                ELSE
                    Fwrd_sel1 <= '1';
                    Fwrd_sel2 <= '1';
                    IF (Rsrc1_sel = ALU_sel) THEN
                        Fwrd_data1 <= ALU_out;
                    ELSE
                        Fwrd_data1 <= Mem_out;
                    END IF;
                    IF (Rsrc2_sel = ALU_sel) THEN
                        Fwrd_data2 <= ALU_out;
                    ELSE
                        Fwrd_data2 <= Mem_out;
                    END IF;
                END IF;
            ELSIF (ALU_sel = Rsrc1_sel OR ALU_sel = Rsrc2_sel) XOR (Mem_sel = Rsrc1_sel OR Mem_sel = Rsrc2_sel) THEN
                IF (ALU_sel = Rsrc1_sel OR ALU_sel = Rsrc2_sel) THEN
                    IF (ALU_sel = Rsrc1_sel) THEN
                        Fwrd_sel1 <= '1';
                        Fwrd_data1 <= ALU_out;
                    ELSE
                        Fwrd_sel1 <= '0';
                    END IF;
                    IF (ALU_sel = Rsrc2_sel) THEN
                        Fwrd_sel2 <= '1';
                        Fwrd_data2 <= ALU_out;
                    ELSE
                        Fwrd_sel2 <= '0';
                    END IF;
                ELSE
                    IF (Mem_sel = Rsrc1_sel) THEN
                        Fwrd_sel1 <= '1';
                        Fwrd_data1 <= Mem_out;
                    ELSE
                        Fwrd_sel1 <= '0';
                    END IF;
                    IF (Mem_sel = Rsrc2_sel) THEN
                        Fwrd_sel2 <= '1';
                        Fwrd_data2 <= Mem_out;
                    ELSE
                        Fwrd_sel2 <= '0';
                    END IF;
                END IF;
            ELSE
                Fwrd_sel1 <= '0';
                Fwrd_sel2 <= '0';
            END IF;
        END IF;
    END PROCESS;
END ForwardingUnitArch;