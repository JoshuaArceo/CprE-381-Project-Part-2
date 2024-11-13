library IEEE;
use IEEE.std_logic_1164.all;

entity IFID_Reg is
    generic(
        N : integer := 32
    );
    port(
        i_PC        : in    std_logic_vector((N - 1) downto 0);
        i_Inst      : in    std_logic_vector((N - 1) downto 0);
        i_IF_Flush  : in    std_logic;
        i_CLK       : in    std_logic;
        o_PC        : in    std_logic_vector((N - 1) downto 0);
        o_Inst      : in    std_logic_vector((N - 1) downto 0);
    );
end IFID_Reg;

architecture structural of IFID_Reg is
    component reg_N is
        port(
            i_D	    : in std_logic_vector(N-1 downto 0);
	        i_RST	: in std_logic;
	        i_CLK	: in std_logic;
	        i_WE	: in std_logic;
	        o_Q	    : out std_logic_vector(N-1 downto 0)
         );
    end component;

    

    begin
        PC_Reg: reg_N
        port map(
            i_D => i_PC,
            i_RST => i_IF_Flush,
            i_CLK => i_CLK,
            i_WE => '1',
            o_Q => o_PC
        );
        
        Inst_Reg: reg_N
        port map(
            i_D => i_Inst,
            i_RST => i_IF_Flush,
            i_CLK => i_CLK,
            i_WE => '1',
            o_Q => o_Inst
        );

    end structural;