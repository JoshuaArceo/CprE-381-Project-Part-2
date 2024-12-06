library IEEE;
use IEEE.std_logic_1164.all;

entity sw_reg is
	generic(N : integer := 32);
	port(i_D	: in std_logic_vector(N-1 downto 0);
		 i_Sel	: in std_logic_vector(1 downto 0);
	     i_RST	: in std_logic;
	     i_CLK	: in std_logic;
	     i_WE	: in std_logic;
	     o_Q	: out std_logic_vector(N-1 downto 0);
		 o_Sel  : out std_logic_vector(1 downto 0));
end sw_reg;

architecture structural of sw_reg is
	
	component dffg is
		port(
				 i_CLK        : in std_logic;     -- Clock input
       		     i_RST        : in std_logic;     -- Reset input
       		     i_WE         : in std_logic;     -- Write enable input
       		     i_D          : in std_logic;     -- Data value input
       		     o_Q          : out std_logic);   -- Data value output
	end component;

begin 

generateSel: for i in 0 to 1 generate
DFFGSel:	dffg 
port map(
	i_CLK => i_CLK,
	i_RST => i_RST,
	i_WE => i_WE,
	i_D => i_Sel(i),
	o_Q => o_Sel(i));
end generate generateSel;

generateData: for i in 0 to N - 1 generate
	DFFGIL:	dffg 
	port map(
		i_CLK => i_CLK,
		i_RST => i_RST,
		i_WE => i_WE,
		i_D => i_D(i),
		o_Q => o_Q(i));
end generate generateData;
	

end structural; 
	