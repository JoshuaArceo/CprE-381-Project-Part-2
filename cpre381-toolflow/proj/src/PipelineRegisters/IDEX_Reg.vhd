library IEEE;
use IEEE.std_logic_1164.all;


entity IDEX_Reg is
    generic(
        Addr_Width : integer := 5;
        N : integer := 32
    );
    port(
        i_ReadA     : in    std_logic_vector((N - 1) downto 0);
        i_ReadB     : in    std_logic_vector((N - 1) downto 0);
        i_AddrA     : in    std_logic_vector((Addr_Width - 1) downto 0);
        i_AddrB     : in    std_logic_vector((Addr_Width - 1) downto 0);
        i_InstFunc  : in    std_logic_vector(5 downto 0);
        i_JumpAddr  : in    std_logic_vector(25 downto 0);
        i_ImmExt    : in    std_logic_vector((N - 1) downto 0);
        i_CLK       : in    std_logic;
        o_ReadA     : in    std_logic_vector((N - 1) downto 0);
        o_ReadB     : in    std_logic_vector((N - 1) downto 0);
        o_AddrA     : in    std_logic_vector((Addr_Width - 1) downto 0);
        o_AddrB     : in    std_logic_vector((Addr_Width - 1) downto 0);
        o_InstFunc  : in    std_logic_vector(5 downto 0);
        o_JumpAddr  : in    std_logic_vector(25 downto 0);
        o_ImmExt    : in    std_logic_vector((N - 1) downto 0);

    );
end IDEX_Reg;

architecture structural of IDEX_Reg is
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
        ReadA_Reg: reg_N
        generic map(N => N)
        port map(
            i_D => i_ReadA,
            i_RST => , --TODO RESET
            i_CLK => i_CLK,
            i_WE => '1',
            o_Q => o_ReadA
        );
        
        ReadB_Reg: reg_N
        generic map(N => N)
        port map(
            i_D => i_ReadB,
            i_RST => , --TODO RESET
            i_CLK => i_CLK,
            i_WE => '1',
            o_Q => o_ReadB
        );

        AddrA_Reg: reg_N
        generic map(N => Addr_Width)
        port map(
            i_D => i_AddrA,
            i_RST => , --TODO RESET
            i_CLK => i_CLK,
            i_WE => '1',
            o_Q => o_AddrA
        );

        AddrB_Reg: reg_N
        generic map(N => Addr_Width)
        port map(
            i_D => i_AddrB,
            i_RST => , --TODO RESET
            i_CLK => i_CLK,
            i_WE => '1',
            o_Q => o_AddrB
        );

        InstFunc_Reg: reg_N
        generic map(N => 6)
        port map(
            i_D => i_InstFunc,
            i_RST => , --TODO RESET
            i_CLK => i_CLK,
            i_WE => '1'
            o_Q => o_InstFunc
        );

        JumpAddr_Reg: reg_N
        generic map(N => 26)
        port map(
            i_D => i_JumpAddr,
            i_RST => , --TODO RESET
            i_CLK => i_CLK,
            i_WE => '1'
            o_Q => o_JumpAddr
        );

        ImmExt_Reg: reg_N
        generic map(N => N)
        port map(
            i_D => i_ImmExt,
            i_RST => , --TODO RESET
            i_CLK => i_CLK,
            i_WE => '1'
            o_Q => o_ImmExt
        );


    end structural;