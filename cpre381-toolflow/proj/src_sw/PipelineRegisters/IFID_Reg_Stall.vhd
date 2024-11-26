library IEEE;
use IEEE.std_logic_1164.all;

entity IFID_Reg_Stall is
    generic(
        N : integer := 32
    );
    port(
        i_PC        : in    std_logic_vector((N - 1) downto 0);
        i_Inst      : in    std_logic_vector((N - 1) downto 0);
        i_IF_Flush  : in    std_logic;
        i_Stall     : in    std_logic;
        i_CLK       : in    std_logic;
        o_PC        : out    std_logic_vector((N - 1) downto 0);
        o_Inst      : out    std_logic_vector((N - 1) downto 0)
    );
end IFID_Reg_Stall;

architecture structural of IFID_Reg_Stall is
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
            i_WE => not i_Stall,
            o_Q => o_PC
        );
        
        Inst_Reg: reg_N
        port map(
            i_D => i_Inst,
            i_RST => i_IF_Flush,
            i_CLK => i_CLK,
            i_WE => not i_Stall,
            o_Q => o_Inst
        );

    end structural;