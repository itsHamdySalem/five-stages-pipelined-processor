LIBRARY IEEE;
USE IEEE.std_logic_1164.all;
USE IEEE.numeric_std.all;

ENTITY SP IS
	PORT (clk, reset : IN  std_logic;
          inc : IN std_logic_vector(2 DOWNTO 0);
		  sp : OUT std_logic_vector(11 DOWNTO 0)
        );
END SP;

ARCHITECTURE SP_design OF SP IS
signal curSP: STD_LOGIC_VECTOR(11 DOWNTO 0) := "111111111111";
BEGIN

    PROCESS (clk,reset)
    variable spINC:std_logic_vector(11 downto 0);
    BEGIN
        IF reset = '1' THEN
            sp <= "111111111111";                          
            spINC := (others => '0');     
        ELSIF rising_edge(clk) THEN
            spINC := std_logic_vector(signed(curSP)+signed(inc));
            -- curSP <= spINC;
            sp <= spINC;
        END IF;
        -- sp <= curSP;
    END PROCESS;
		
END SP_design;
