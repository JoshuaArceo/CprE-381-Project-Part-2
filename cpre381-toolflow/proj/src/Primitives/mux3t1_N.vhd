-- 32-bit, 32-to-1 Multiplexer with Individual Inputs
library IEEE;
use IEEE.std_logic_1164.all;

entity mux3t1_N is
  generic(N : integer := 32); 
    port(
        i_A     : in std_logic_vector((N - 1) downto 0);
        i_B     : in std_logic_vector((N - 1) downto 0);
        i_C     : in std_logic_vector((N - 1) downto 0);        
        i_Sel   : in std_logic_vector(1 downto 0);
        o_F     : out std_logic_vector((N - 1) downto 0)
    );
end mux3t1_N;

architecture dataflow of mux3t1_N is
begin
    with i_Sel select
        o_F <=    i_A  when "00",
                  i_B  when "01",
                  i_C  when "10",
                  i_C  when "11",
                  (others => '0') when others;
end dataflow;
