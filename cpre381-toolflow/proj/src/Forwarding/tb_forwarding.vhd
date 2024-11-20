library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL; 

entity tb_forwarding is
end tb_forwarding;

architecture Behavioral of tb_forwarding is
    component forwarding
        Port (
            rs           : in std_logic_vector(4 downto 0);  
            rt           : in std_logic_vector(4 downto 0);  
            MEM_RD       : in std_logic_vector(4 downto 0); 
            WB_RD        : in std_logic_vector(4 downto 0);  
            MEM_RegWrite : in std_logic;                     
            WB_RegWrite  : in std_logic;                     
            forward_A    : out std_logic_vector(1 downto 0);
            forward_B    : out std_logic_vector(1 downto 0)  
        );
    end component;

    signal EX_RS        : std_logic_vector(4 downto 0);
    signal EX_RT        : std_logic_vector(4 downto 0);
    signal MEM_RD       : std_logic_vector(4 downto 0);
    signal WB_RD        : std_logic_vector(4 downto 0);
    signal MEM_RegWrite : std_logic;
    signal WB_RegWrite  : std_logic;
    signal ForwardA     : std_logic_vector(1 downto 0);
    signal ForwardB     : std_logic_vector(1 downto 0);

begin
    -- Instantiate the Forwarding Unit
    DUT: forwarding
        Port map (
            rs => EX_RS,
            rt => EX_RT,
            MEM_RD => MEM_RD,
            WB_RD => WB_RD,
            MEM_RegWrite => MEM_RegWrite,
            WB_RegWrite => WB_RegWrite,
            forward_A => ForwardA,
            forward_B => ForwardB
        );

    -- Test process
    Stimulus: process
    begin
        -- Forward from WB to EX_RS
        MEM_RegWrite <= '0';
        WB_RD <= "00001";
        WB_RegWrite <= '1';
        wait for 10 ns;

        -- Forward from MEM to EX_RT
        EX_RT <= "00010";
        MEM_RD <= "00010";
        MEM_RegWrite <= '1';
        WB_RegWrite <= '0';
        wait for 10 ns;

        -- No forwarding (default case)
        EX_RS <= "00001";
        EX_RT <= "00010";
        MEM_RD <= "00000";
        WB_RD <= "00000";
        MEM_RegWrite <= '0';
        WB_RegWrite <= '0';
        wait for 10 ns;

        -- Both MEM and WB match (MEM should be First)
        MEM_RD <= "00011";
        WB_RD <= "00011";
        EX_RS <= "00011";
        MEM_RegWrite <= '1';
        WB_RegWrite <= '1';
        wait for 10 ns;

        -- Forward from MEM to EX_RS
        MEM_RD <= "00001";
        MEM_RegWrite <= '1';
        WB_RegWrite <= '0';
        wait for 10 ns;

        -- Forward from WB to EX_RT
        MEM_RegWrite <= '0';
        WB_RD <= "00010";
        WB_RegWrite <= '1';
        wait for 10 ns;

        wait;
    end process;
end Behavioral;
