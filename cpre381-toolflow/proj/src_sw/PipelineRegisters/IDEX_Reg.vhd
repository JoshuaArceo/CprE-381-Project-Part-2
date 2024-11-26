library IEEE;
use IEEE.std_logic_1164.all;


entity IDEX_Reg is
    generic(
        Addr_Width : integer := 5;
        N : integer := 32
    );
    port(
        i_ReadA     : in     std_logic_vector((N - 1) downto 0);
        i_ReadB     : in     std_logic_vector((N - 1) downto 0);
        -- i_AddrA     : in     std_logic_vector((Addr_Width - 1) downto 0);
        -- i_AddrB     : in     std_logic_vector((Addr_Width - 1) downto 0);
        i_WB_Addr    : in     std_logic_vector((Addr_Width - 1) downto 0);
        i_InstOpCode  : in     std_logic_vector(5 downto 0);
        i_InstFunc  : in     std_logic_vector(5 downto 0);
        i_BranchAddr  : in     std_logic_vector(N -1 downto 0);
        i_ImmExt    : in     std_logic_vector((N - 1) downto 0);
        i_CTRL_Sigs : in     std_logic_vector(8 downto 0);  
        i_CLK       : in     std_logic;
        i_RST       : in     std_logic;
        o_ReadA     : out    std_logic_vector((N - 1) downto 0);
        o_ReadB     : out    std_logic_vector((N - 1) downto 0);
        -- o_AddrA     : out    std_logic_vector((Addr_Width - 1) downto 0);
        -- o_AddrB     : out    std_logic_vector((Addr_Width - 1) downto 0);
        o_WB_Addr    : out    std_logic_vector((Addr_Width - 1) downto 0);
        o_InstOpCode  : out     std_logic_vector(5 downto 0);
        o_InstFunc  : out    std_logic_vector(5 downto 0);
        o_BranchAddr  : out     std_logic_vector(N -1 downto 0);
        o_ImmExt    : out    std_logic_vector((N - 1) downto 0);
        o_CTRL_Sigs : out     std_logic_vector(8 downto 0)
    );
end IDEX_Reg;

-- Ctrlsignals:
-- 0:  Mem2Reg
-- 1:  Halt
-- 2:  RegWrite
-- 3:  MemWrite
-- 4:  ALUSrc
-- 5:  Shift
-- 6:  Branch
-- 7:  BNE
-- 8:  JR

architecture structural of IDEX_Reg is
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
        ReadA_Reg: reg_N
        generic map(N => N)
        port map(
            i_D => i_ReadA,
            i_RST => i_RST,
            i_CLK => i_CLK,
            i_WE => '1',
            o_Q => o_ReadA
        );
        
        ReadB_Reg: reg_N
        generic map(N => N)
        port map(
            i_D => i_ReadB,
            i_RST => i_RST,
            i_CLK => i_CLK,
            i_WE => '1',
            o_Q => o_ReadB
        );

        -- AddrA_Reg: reg_N
        -- generic map(N => Addr_Width)
        -- port map(
        --     i_D => i_AddrA,
        --     i_RST => i_RST,
        --     i_CLK => i_CLK,
        --     i_WE => '1',
        --     o_Q => o_AddrA
        -- );

        -- AddrB_Reg: reg_N
        -- generic map(N => Addr_Width)
        -- port map(
        --     i_D => i_AddrB,
        --     i_RST => i_RST,
        --     i_CLK => i_CLK,
        --     i_WE => '1',
        --     o_Q => o_AddrB
        -- );

        AddrWr_Reg: reg_N
        generic map(N => Addr_Width)
        port map(
            i_D => i_WB_Addr,
            i_RST => i_RST,
            i_CLK => i_CLK,
            i_WE => '1',
            o_Q => o_WB_Addr
        );

        InstFunc_Reg: reg_N
        generic map(N => 6)
        port map(
            i_D => i_InstFunc,
            i_RST => i_RST,
            i_CLK => i_CLK,
            i_WE => '1',
            o_Q => o_InstFunc
        );

        InstOp_Reg: reg_N
        generic map(N => 6)
        port map(
            i_D => i_InstOpCode,
            i_RST => i_RST,
            i_CLK => i_CLK,
            i_WE => '1',
            o_Q => o_InstOpCode
        );

        -- JumpAddr_Reg: reg_N
        -- generic map(N => 26)
        -- port map(
        --     i_D => i_JumpAddr,
        --     i_RST => i_RST,
        --     i_CLK => i_CLK,
        --     i_WE => '1',
        --     o_Q => o_JumpAddr
        -- );

        ImmExt_Reg: reg_N
        generic map(N => N)
        port map(
            i_D => i_ImmExt,
            i_RST => i_RST,
            i_CLK => i_CLK,
            i_WE => '1',
            o_Q => o_ImmExt
        );

        ctrl_Reg: reg_N
        generic map(N => 9)
        port map(
            i_D => i_CTRL_Sigs,
            i_RST => i_RST,
            i_CLK => i_CLK,
            i_WE => '1',
            o_Q => o_CTRL_Sigs
        );


    end structural;