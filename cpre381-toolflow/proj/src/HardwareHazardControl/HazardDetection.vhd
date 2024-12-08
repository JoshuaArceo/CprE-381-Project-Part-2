library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL; 

-- Author: jarceo
--         jarceo@iastate.edu

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

        EX_WriteToReg   : in std_logic;
        MEM_WriteToReg  : in std_logic;
        WB_WriteToReg   : in std_logic;

        i_RST           : in std_logic;
        i_EX_branch     : in std_logic;
        
        o_PC_Stall       : out std_logic;
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
    
    signal s_IF_RS, s_IF_RT, s_IF_RD, s_ID_RS, s_ID_RT, s_ID_RD, s_EX_RS, s_EX_RT, s_EX_RD, s_MEM_RS, s_MEM_RT, s_MEM_RD, s_WB_RS, s_WB_RT, s_WB_RD : std_logic_vector(4 downto 0);


    begin

        s_IF_RS    <= IF_Inst(25 downto 21);
        s_IF_RT    <= IF_Inst(20 downto 16);
        s_IF_RD    <= IF_Inst(15 downto 11);
    
        s_ID_RS    <= ID_Inst(25 downto 21);
        s_ID_RT    <= ID_Inst(20 downto 16);
        s_ID_RD    <= ID_Inst(15 downto 11);
    
        s_EX_RS    <= EX_Inst(25 downto 21);
        s_EX_RT    <= EX_Inst(20 downto 16);
        s_EX_RD    <= EX_Inst(15 downto 11);
    
        s_MEM_RS    <= MEM_Inst(25 downto 21);
        s_MEM_RT    <= MEM_Inst(20 downto 16);
        s_MEM_RD    <= MEM_Inst(15 downto 11);
    
        s_WB_RS    <= WB_Inst(25 downto 21);
        s_WB_RT    <= WB_Inst(20 downto 16);
        s_WB_RD    <= WB_Inst(15 downto 11);

        process(IF_Inst, ID_Inst, EX_Inst, WB_Inst, EX_Dst, MEM_Dst, i_RST, i_EX_branch, 
        s_IF_RS, s_IF_RT, s_IF_RD, s_ID_RS, s_ID_RT, s_ID_RD, s_EX_RS, s_EX_RT, s_EX_RD, 
        s_MEM_RS, s_MEM_RT, s_MEM_RD, s_WB_RS, s_WB_RT, s_WB_RD,
        EX_WriteToReg, MEM_WriteToReg, WB_WriteToReg)
        begin    
        o_IFID_Stall  <= '0';
        o_IDEX_Stall  <= '0';
        o_EXMEM_Stall <= '0';
        o_MEMWB_Stall <= '0';
        o_PC_Stall    <= '0';



        o_IFID_Flush  <= i_RST;
        o_IDEX_Flush  <= i_RST;
        o_EXMEM_Flush <= i_RST;
        o_MEMWB_Flush <= i_RST;

       

  --TODO STALL FOR JUMP
    if(EX_Inst(31 downto 26) = "000010") then
        o_IFID_Flush <= '1';
        o_PC_Stall    <= '1';
    elsif  ID_Inst(31 downto 26) = "000010" then
        o_PC_Stall <= '0';
    elsif  IF_Inst(31 downto 26) = "000010"
         then
            -- o_PC_Stall    <= '1';
    
    end if;



        
            --Stall for LW forwarding
                if(EX_Inst = ID_Inst) then
                    o_IFID_Stall  <= '0';
                    o_IDEX_Stall  <= '0';
                   
                    elsif(EX_Inst(31 downto 26) ="100011" and (EX_Dst = s_ID_RS or EX_Dst = s_ID_RT)) then 
                        o_IFID_Stall  <= '1';
                        o_PC_Stall    <= '1';
                end if;

                --Ensure no double writes
                if(WB_Inst = Mem_Inst) 
                and MEM_Dst = WB_Dst and MEM_WriteToReg = '1' and WB_WriteToReg = '1'
                then
                    o_EXMEM_Flush <= '1';
                end if;


                
                --Stall for JR
                if(EX_Inst(31 downto 26) ="000000" and EX_Inst(5 downto 0) = "001000")
                then o_IFID_Stall  <= '0';
                    o_IFID_Flush <= '1';
                elsif(ID_Inst(31 downto 26) = "000000" and ID_Inst(5 downto 0) = "001000")
                    then o_IFID_Stall  <= '1';
                    o_PC_Stall    <= '1';

                end if;
                
                --Branch Stalling
            if(EX_Inst(31 downto 26) ="000100" or EX_Inst(31 downto 26) ="000101")
                then o_IFID_Stall  <= '0';
                if i_EX_branch ='1' then
                    o_IFID_Flush <= '1';

                end if;
            elsif(ID_Inst(31 downto 26) ="000100" or ID_Inst(31 downto 26) ="000101")
                then o_IFID_Stall  <= '1';
                o_PC_Stall    <= '1';

            end if;

            --JAL Stalling
                if(EX_Inst(31 downto 26) = "000011") then
                    o_IFID_Flush <= '1';
                    o_PC_Stall    <= '1';

                elsif(IF_Inst(31 downto 26) = "000011" and (MEM_WriteToReg ='1'))
                    then o_IFID_Stall  <= '1';
                    o_PC_Stall    <= '1';
                elsif(ID_Inst(31 downto 26) = "000011" )
                    then o_IFID_Stall  <= '1';
                end if;

                if(IF_Inst(31 downto 26) = "000011") and ID_Inst = WB_Inst then
                    o_IFID_Flush <= '1';
                    o_IDEX_Flush <= '1';
                end if;

            

        end process;

  

    end mixed;