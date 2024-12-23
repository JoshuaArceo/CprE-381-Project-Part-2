library IEEE;
use IEEE.std_logic_1164.all;

entity nor_32bit is

  port(i_A          : in std_logic_vector(31 downto 0);
       i_B          : in std_logic_vector(31 downto 0);
       o_F          : out std_logic_vector(31 downto 0)
       );

end nor_32bit;

architecture dataflow of nor_32bit is

component org2 is
  port(i_A          : in std_logic;
       i_B          : in std_logic;
       o_F          : out std_logic
       );
end component;

component invg is 
  port(i_A          : in std_logic;
       o_F          : out std_logic
       );
end component;

signal s_or : std_logic_Vector(31 downto 0);

begin

  or_loop : for i in 0 to 31 generate
	or_gate : org2 port map(i_A    => i_A(i),
                          i_B    => i_B(i),
                          o_F    => s_or(i)
                          );
  end generate or_loop;

  inv_loop : for i in 0 to 31 generate
	inv_gate : invg port map(i_A    => s_or(i),
                           o_F    => o_F(i)
                          );
  end generate inv_loop;

end dataflow;