library IEEE;
use IEEE.std_logic_1164.all;

entity MEMWB_Reg is
    generic(
        N : integer := 32
    );
    port(
        i_ALU       : in    std_logic_vector((N - 1) downto 0);
        i_W_Data    : in    std_logic_vector((N - 1) downto 0);
        i_CLK       : in    std_logic;
        o_ALU       : in    std_logic_vector((N - 1) downto 0);
        o_W_Data    : in    std_logic_vector((N - 1) downto 0);
    );
end MEMWB_Reg;

architecture structural of MEMWB_Reg is
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
        ALU_Reg: reg_N
        port map(
            i_D => i_ALU,
            i_RST => , --TODO
            i_CLK => i_CLK,
            i_WE => '1',
            o_Q => o_ALU
        );
        
        WriteData_Reg: reg_N
        port map(
            i_D => i_W_Data,
            i_RST => , --TODO
            i_CLK => i_CLK,
            i_WE => '1',
            o_Q => o_W_Data
        );

    end structural;