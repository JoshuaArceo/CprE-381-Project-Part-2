library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity forwarding is
    port (
        rs           : in std_logic_vector(4 downto 0);  -- register 1 in EX stage
        rt           : in std_logic_vector(4 downto 0);  -- register 2 in EX stage
        MEM_RD       : in std_logic_vector(4 downto 0);  -- register in MEM stage
        WB_RD        : in std_logic_vector(4 downto 0);  -- register in WB stage
        MEM_RegWrite : in std_logic;                     -- signal for MEM stage
        WB_RegWrite  : in std_logic;                     -- signal for WB stage
        forward_A    : out std_logic_vector(1 downto 0); -- Forwarding control for rs
        forward_B    : out std_logic_vector(1 downto 0)  -- Forwarding control for rt
    );
end forwarding;

architecture Behavioral of forwarding is
begin
    -- Forwarding control for rs 
    with (MEM_RegWrite & MEM_RD & rs) select
        forward_A <= "10" when (MEM_RegWrite = '1' and MEM_RD = rs),
                     "01" when (WB_RegWrite = '1' and WB_RD = rs),
                     "00" when others;

    -- Forwarding control for rt 
    with (MEM_RegWrite & MEM_RD & rt) select
        forward_B <= "10" when (MEM_RegWrite = '1' and MEM_RD = rt),
                     "01" when (WB_RegWrite = '1' and WB_RD = rt),
                     "00" when others;
end Behavioral;
