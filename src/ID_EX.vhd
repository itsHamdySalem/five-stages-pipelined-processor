library ieee;
use ieee.std_logic_1164.all;
USE IEEE.numeric_std.all;

entity ID_EX is
    Port ( clk : in STD_LOGIC;
           rst : in STD_LOGIC;
           SP_EA: in STD_LOGIC_VECTOR(31 downto 0);
           Rdst_sel_in : in STD_LOGIC_VECTOR(2 downto 0);
           immediate_in : in STD_LOGIC_VECTOR(31 downto 0);
           Rsrc1_in, Rsrc2_in : in STD_LOGIC_VECTOR(31 downto 0);
           Ex_control : in STD_LOGIC_VECTOR(4 downto 0);
           Mem_control_in : in STD_LOGIC_VECTOR(2 downto 0);
           WB_control_in : in STD_LOGIC_VECTOR(2 downto 0);

           MemAdr : out STD_LOGIC_VECTOR(31 downto 0);
           Rdst_sel_out : out STD_LOGIC_VECTOR(2 downto 0);
           immediate_out : out STD_LOGIC_VECTOR(31 downto 0);
           Rsrc1_out, Rsrc2_out : out STD_LOGIC_VECTOR(31 downto 0);
           isImmediate : out std_logic; -- 4-th bit in Ex_control
           ALU_OP : out STD_LOGIC_VECTOR(3 downto 0); -- [3:0] bits of Ex_control
           Mem_control_out : out STD_LOGIC_VECTOR(2 downto 0);
           WB_control_out : out STD_LOGIC_VECTOR(2 downto 0)
    );
end ID_EX;

architecture Behavioral of ID_EX is
    
begin
    process(clk, rst) -- TODO:: deal with the reset if there is any.
    begin 
        if rising_edge(clk) then
            MemAdr <= SP_EA;
            Rdst_sel_out <= Rdst_sel_in;
            immediate_out <= immediate_in;
            Rsrc1_out <= Rsrc1_in;
            Rsrc2_out <= Rsrc2_in;
            isImmediate <= Ex_control(4);
            ALU_OP <= Ex_control(3 downto 0);
            Mem_control_out <= Mem_control_in;
            WB_control_out <= WB_control_in;
        end if;
    end process;
end Behavioral;
