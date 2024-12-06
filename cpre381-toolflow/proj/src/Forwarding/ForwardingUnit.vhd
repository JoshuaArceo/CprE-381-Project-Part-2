library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL; 

entity ForwardingUnit is
    port (
        EX_Inst      : in std_logic_vector(31 downto 0); 
        MEM_Inst     : in std_logic_vector(31 downto 0); 
        WB_Inst      : in std_logic_vector(31 downto 0); 
        MEM_Dst      : in std_logic_vector(4 downto 0);
        WB_Dst       : in std_logic_vector(4 downto 0); 
        MEM_RegWrite : in std_logic;                 
        WB_RegWrite  : in std_logic;                  
        ALU_Src      : in std_logic;
        forward_A    : out std_logic_vector(1 downto 0); 
        forward_B    : out std_logic_vector(1 downto 0);
        forward_data_reg : out std_logic_vector(1 downto 0); 
        forward_data : out std_logic_vector(1 downto 0)
    );
end ForwardingUnit;


architecture Behavioral of ForwardingUnit is
    signal s_EX_RS, s_EX_RT, s_EX_RD, s_MEM_RS, s_MEM_RT, s_MEM_RD, s_WB_RS, s_WB_RT, s_WB_RD : std_logic_vector(4 downto 0);

    begin
        s_EX_RS    <= EX_Inst(25 downto 21);
        s_EX_RT    <= EX_Inst(20 downto 16);
        s_EX_RD    <= EX_Inst(15 downto 11);

        s_MEM_RS    <= MEM_Inst(25 downto 21);
        s_MEM_RT    <= MEM_Inst(20 downto 16);
        s_MEM_RD    <= MEM_Inst(15 downto 11);

        s_WB_RS    <= WB_Inst(25 downto 21);
        s_WB_RT    <= WB_Inst(20 downto 16);
        s_WB_RD    <= WB_Inst(15 downto 11);

    process(s_EX_RS, s_EX_RT, s_EX_RD, s_MEM_RS, s_MEM_RT, s_MEM_RD, s_WB_RS, s_WB_RT, s_WB_RD, MEM_Dst, WB_Dst, MEM_RegWrite, WB_RegWrite)
    begin
        -- Initialize outputs
        forward_A <= "00";
        forward_B <= "00";
        forward_data_reg <= "00";
        forward_data <= "00";

        

            if MEM_RegWrite = '1' and MEM_Dst /= "00000" and MEM_Dst = s_EX_RS then
                forward_A <= "10";

            elsif WB_RegWrite = '1' and WB_Dst /= "00000" and WB_Dst = s_EX_RS then
                forward_A <= "01";

            end if;

            
            if MEM_RegWrite = '1' and MEM_Dst /= "00000" and MEM_Dst = s_EX_RT and EX_Inst(31 downto 26) = "000000" then
                forward_B <= "10";

            elsif WB_RegWrite = '1' and WB_Dst /= "00000" and WB_Dst = s_EX_RT and EX_Inst(31 downto 26) = "000000" then
                forward_B <= "01";

            end if;


        if WB_RegWrite = '1' and WB_Dst /= "00000" and WB_Dst = s_MEM_RT and MEM_Inst(31 downto 26) = "101011" then
            forward_data <= "01"; 
        end if;

        if WB_RegWrite = '1' and WB_Dst /= "00000" and WB_Dst = s_EX_RT and EX_Inst(31 downto 26) = "101011"then
            forward_data <= "10"; 
        end if;

    end process;
end Behavioral;
