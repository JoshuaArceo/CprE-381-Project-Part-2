library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL; 

entity ForwardingUnit is
    port (
        rs           : in std_logic_vector(4 downto 0);  -- Register 1 in EX stage
        rt           : in std_logic_vector(4 downto 0);  -- Register 2 in EX stage
        MEM_RD       : in std_logic_vector(4 downto 0);  -- Register in MEM stage
        WB_RD        : in std_logic_vector(4 downto 0);  -- Register in WB stage
        MEM_RegWrite : in std_logic;                     -- Signal for MEM stage
        WB_RegWrite  : in std_logic;                     -- Signal for WB stage
        EX_Inst      : in std_logic_vector(31 downto 0); 
        forward_A    : out std_logic_vector(1 downto 0); -- Forwarding control for rs
        forward_B    : out std_logic_vector(1 downto 0); -- Forwarding control for rt
        forward_addr : out std_logic_vector(1 downto 0); -- Forwarding control for DMEM address
        forward_data : out std_logic_vector(1 downto 0)  -- Forwarding control for DMEM data
    );
end ForwardingUnit;

architecture Behavioral of ForwardingUnit is
begin
    process(rs, rt, MEM_RD, WB_RD, MEM_RegWrite, WB_RegWrite)
    begin
        -- Initialize outputs
        forward_A <= "00";
        forward_B <= "00";
        forward_addr <= "00";
        forward_data <= "00";

        -- ALU input A (rs)
        if MEM_RegWrite = '1' and MEM_RD /= "00000" and MEM_RD = rs then
            forward_A <= "10"; 
        elsif WB_RegWrite = '1' and WB_RD /= "00000" and WB_RD = rs then
            forward_A <= "01";
        end if;

        -- ALU input B (rt)
        if MEM_RegWrite = '1' and MEM_RD /= "00000" and MEM_RD = rt and EX_Inst(31 downto 26) = "000000" then
            forward_B <= "10";
        elsif WB_RegWrite = '1' and WB_RD /= "00000" and WB_RD = rt and EX_Inst(31 downto 26) = "000000" then
            forward_B <= "01";
        end if;

        -- -- DMEM address
        -- if MEM_RegWrite = '1' and MEM_RD /= "00000" and MEM_RD = rs then
        --     forward_addr <= "10"; -- Forward from MEM stage
        -- elsif WB_RegWrite = '1' and WB_RD /= "00000" and WB_RD = rs then
        --     forward_addr <= "01"; -- Forward from WB stage
        -- end if;

        -- DMEM data
        -- if MEM_RegWrite = '1' and MEM_RD /= "00000" and MEM_RD = rt then
            -- forward_data <= "10"; 
        -- if WB_RegWrite = '1' and WB_RD /= "00000" and WB_RD = rt then
        --     forward_data <= "01"; 
        -- end if;
    end process;
end Behavioral;
