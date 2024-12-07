library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL; 

entity HazardDetection is
    port (

        IF_Inst      : in std_logic_vector(31 downto 0); 
        ID_Inst      : in std_logic_vector(31 downto 0); 
        EX_Inst      : in std_logic_vector(31 downto 0); 
        MEM_Inst     : in std_logic_vector(31 downto 0); 
        WB_Inst      : in std_logic_vector(31 downto 0); 

        ID_Dst      : in std_logic_vector(4 downto 0);
        EX_Dst       : in std_logic_vector(4 downto 0);  
        MEM_Dst      : in std_logic_vector(4 downto 0); 
        WB_Dst       : in std_logic_vector(4 downto 0);  

        i_RST           : in std_logic;
        i_EX_branch     : in std_logic;
        

        o_IFID_Flush     : out std_logic;
        o_IFID_Stall     : out std_logic;
        o_IDEX_Flush     : out std_logic;
        o_IDEX_Stall     : out std_logic;
        o_EXMEM_Flush    : out std_logic;
        o_EXMEM_Stall    : out std_logic;
        o_MEMWB_Flush    : out std_logic;
        o_MEMWB_Stall    : out std_logic
    );
end HazardDetection;

architecture mixed of HazardDetection is
    begin
        process(IF_Inst, ID_Inst, EX_Inst, WB_Inst, i_RST, i_EX_branch)
        begin    
        o_IFID_Stall  <= '0';
        o_IDEX_Stall  <= '0';
        o_EXMEM_Stall <= '0';
        o_MEMWB_Stall <= '0';


        o_IFID_Flush  <= i_RST;
        o_IDEX_Flush  <= i_RST;
        o_EXMEM_Flush <= i_RST;
        o_MEMWB_Flush <= i_RST;


            if(EX_Inst(31 downto 26) ="000100" or EX_Inst(31 downto 26) ="000101")
                then o_IFID_Stall  <= '0';
                if i_EX_branch ='1' then
                    o_IFID_Flush <= '1';
                end if;
            elsif(ID_Inst(31 downto 26) ="000100" or ID_Inst(31 downto 26) ="000101")
                then o_IFID_Stall  <= '1';
            end if;

            --TODO UGRENT: FIX FWD/HAZARD WITH LW USING PROJ1BASETEST
          
                -- if(ID_Inst(31 downto 26) ="100011" and (ID_Dst = IF_Inst(25 downto 21) or ID_Dst = IF_Inst(16 downto 15))) then 
                -- o_IFID_Stall  <= '1';
                if(EX_Inst(31 downto 26) ="100011" and (EX_Dst = IF_Inst(25 downto 21) or EX_Dst = IF_Inst(16 downto 15))) then 
                o_IFID_Stall  <= '1';
                o_IDEX_Stall  <= '1';
                elsif(MEM_Inst(31 downto 26) ="100011" and (MEM_Dst = IF_Inst(25 downto 21) or MEM_Dst = IF_Inst(16 downto 15))) then 
                o_IFID_Stall  <= '1';
                o_IDEX_Stall  <= '1';

            end if;
            
        end process;

  

    end mixed;