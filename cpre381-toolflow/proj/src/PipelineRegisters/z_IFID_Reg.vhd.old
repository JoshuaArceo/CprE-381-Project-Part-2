library IEEE;
use IEEE.std_logic_1164.all;

entity IFID_Reg is
    generic(
        N : integer := 32
    );
    port(
        i_PC4       : in     std_logic_vector((N - 1) downto 0);
        i_Inst      : in     std_logic_vector((N - 1) downto 0);
        i_CLK       : in     std_logic;
        i_RST       : in     std_logic;
        o_PC4       : out    std_logic_vector((N - 1) downto 0);
        o_Inst      : out    std_logic_vector((N - 1) downto 0)
    );
end IFID_Reg;

architecture structural of IFID_Reg is
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
        PC_Reg: reg_N
        generic map(N=>N)
        port map(
            i_D => i_PC4,
            i_RST => i_RST,
            i_CLK => i_CLK,
            i_WE => '1',
            o_Q => o_PC4
        );
        
        Inst_Reg: reg_N
        generic map(N=>N)
        port map(
            i_D => i_Inst,
            i_RST => i_RST,
            i_CLK => i_CLK,
            i_WE => '1',
            o_Q => o_Inst
        );

    end structural;