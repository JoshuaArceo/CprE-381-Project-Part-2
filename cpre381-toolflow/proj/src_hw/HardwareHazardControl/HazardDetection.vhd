library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL; 

entity HazardDetection is
    port (
        i_EX_branch     : std_logic;


        o_IDIF_Flush     : std_logic;
        o_IDIF_Stall     : std_logic;
        o_IFEX_Flush     : std_logic;
        o_IFEX_Stall     : std_logic;
        o_EXMEM_Flush    : std_logic;
        o_EXMEM_Stall    : std_logic;
        o_MEMWB_Flush    : std_logic;
        o_MEMWB_Stall    : std_logic;
    );
end HazardDetection;


