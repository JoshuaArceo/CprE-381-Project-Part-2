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

architecture mixed of HazardDetection is
    begin

        o_IDIF_Flush  <= '0';
        o_IFEX_Flush  <= '0';
        o_EXMEM_Flush <= '0';
        o_MEMWB_Flush <= '0';




        -- Flush on branch
        if (i_EX_branch) then
            o_IDIF_Flush  <= '1';
            o_IFEX_Flush  <= '1';
            o_EXMEM_Flush <= '1';
            o_MEMWB_Flush <= '1';
        end if;

    end mixed;