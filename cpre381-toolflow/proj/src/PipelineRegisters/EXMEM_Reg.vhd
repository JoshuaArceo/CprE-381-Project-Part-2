library IEEE;
use IEEE.std_logic_1164.all;

entity EXMEM_Reg is
    generic(
        Addr_Width : integer := 5;
        N : integer := 32
    );
    port(
        i_ALU_Out   : in    std_logic_vector((N - 1) downto 0);
        i_W_Data    : in    std_logic_vector((N - 1) downto 0);
        i_WB_Addr   : in    std_logic_vector((Addr_Width - 1) downto 0);
        i_CTRL_Sigs : in    std_logic_vector(3 downto 0);
        i_CLK       : in    std_logic;
        o_ALU_Out   : out   std_logic_vector((N - 1) downto 0);
        o_W_Data    : out   std_logic_vector((N - 1) downto 0);
        o_WB_Addr   : out   std_logic_vector((Addr_Width - 1) downto 0);
        o_CTRL_Sigs : out   std_logic_vector(3 downto 0)
    );
end EXMEM_Reg;


-- Ctrlsignals:
-- 0:  Mem2Reg
-- 1:  Halt
-- 2:  RegWrite
-- 3:  MemWrite





architecture structural of EXMEM_Reg is
    component reg_N is
        generic(N : integer);
        port(
            i_D	    : in std_logic_vector(N-1 downto 0);
	        i_RST	: in std_logic;
	        i_CLK	: in std_logic;
	        i_WE	: in std_logic;
	        o_Q	    : out std_logic_vector(N-1 downto 0)
         );
    end component;

    begin
        DataOut_Reg: reg_N
        generic map(N => N)
        port map(
            i_D => i_ALU_Out,
            i_RST => '0',
            i_CLK => i_CLK,
            i_WE => '1',
            o_Q => o_ALU_Out 
        );

        WBAddr_Reg: reg_N
        generic map(N => Addr_Width)
        port map(
            i_D => i_WB_Addr,
            i_RST => '0',
            i_CLK => i_CLK,
            i_WE => '1',
            o_Q => o_WB_Addr
        );
        
        WriteData_Reg: reg_N
        generic map(N => N)
        port map(
            i_D => i_W_Data,
            i_RST => '0',
            i_CLK => i_CLK,
            i_WE => '1',
            o_Q => o_W_Data
        );

        ctrl_Reg: reg_N
        generic map(N => 3)
        port map(
            i_D => i_CTRL_Sigs,
            i_RST => '0',
            i_CLK => i_CLK,
            i_WE => '1',
            o_Q => o_CTRL_Sigs
        );


    end structural;