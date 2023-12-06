library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

ENTITY controlUnit IS
PORT( 
    clk:          IN STD_LOGIC;
    instruction : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
    Imm:          OUT STD_LOGIC;
    InOp:         OUT STD_LOGIC;
    OutOp:        OUT STD_LOGIC;
    MemOp:        OUT STD_LOGIC;
    regWrite:     OUT STD_LOGIC;
    pcSrc:        OUT STD_LOGIC;
    memRead:      OUT STD_LOGIC;
    memWrite:     OUT STD_LOGIC;
    memToReg:     OUT STD_LOGIC;
    spInc:        OUT STD_LOGIC;
    spDec:        OUT STD_LOGIC;
    isOneOp:      OUT STD_LOGIC
);
END controlUnit;

ARCHITECTURE controlUnitDesign OF controlUnit IS
BEGIN
    PROCESS(clk)
    BEGIN
            -- Extract opcode from instruction
            CASE instruction(15 DOWNTO 11) IS
                WHEN "00001" =>
                    -- NOT instruction
                    Imm <= '0';
                    InOp <= '0';
                    OutOp <= '0';
                    MemOp <= '0';
                    regWrite <= '1';
                    pcSrc <= '0';
                    memRead <= '0';
                    memWrite <= '0';
                    memToReg <= '0';
                    spInc <= '0';
                    spDec <= '0';
                    isOneOp <= '1';
                    
                WHEN "00100" =>
                    -- DEC instruction
                    Imm <= '0';
                    InOp <= '0';
                    OutOp <= '0';
                    MemOp <= '0';
                    regWrite <= '1';
                    pcSrc <= '0';
                    memRead <= '0';
                    memWrite <= '0';
                    memToReg <= '0';
                    spInc <= '0';
                    spDec <= '0';
                    isOneOp <= '1';
                    
                WHEN "10011" =>
                    -- OR instruction
                    Imm <= '0';
                    InOp <= '0';
                    OutOp <= '0';
                    MemOp <= '0';
                    regWrite <= '1';
                    pcSrc <= '0';
                    memRead <= '0';
                    memWrite <= '0';
                    memToReg <= '0';
                    spInc <= '0';
                    spDec <= '0';
                    isOneOp <= '0';
                    
                WHEN "01101" =>
                    -- OUT instruction
                    Imm <= '0';
                    InOp <= '0';
                    OutOp <= '1';
                    MemOp <= '0';
                    regWrite <= '0';
                    pcSrc <= '0';
                    memRead <= '0';
                    memWrite <= '0';
                    memToReg <= '0';
                    spInc <= '0';
                    spDec <= '0';
                    isOneOp <= '1';
                    
                WHEN "11010" =>
                    -- LDD instruction
                    Imm <= '1';
                    InOp <= '0';
                    OutOp <= '0';
                    MemOp <= '1';
                    regWrite <= '1';
                    pcSrc <= '0';
                    memRead <= '1';
                    memWrite <= '0';
                    memToReg <= '1';
                    spInc <= '0';
                    spDec <= '0';
                    isOneOp <= '0';
                    
                WHEN "00111" =>
                    -- PROTECT instruction
                    Imm <= '0';
                    InOp <= '0';
                    OutOp <= '0';
                    MemOp <= '1';
                    regWrite <= '0';
                    pcSrc <= '1';
                    memRead <= '0';
                    memWrite <= '1';
                    memToReg <= '0';
                    spInc <= '0';
                    spDec <= '0';
                    isOneOp <= '0';
                    
                WHEN OTHERS =>
                    -- Default case for unsupported opcode
                    Imm <= '0';
                    InOp <= '0';
                    OutOp <= '0';
                    MemOp <= '0';
                    regWrite <= '0';
                    pcSrc <= '0';
                    memRead <= '0';
                    memWrite <= '0';
                    memToReg <= '0';
                    spInc <= '0';
                    spDec <= '0';
                    isOneOp <= '0';
            END CASE;
    END PROCESS;
END controlUnitDesign;
