library IEEE;
use IEEE.std_logic_1164.all;

entity tb_IFID_Reg_Stall is
end tb_IFID_Reg_Stall;

architecture behavior of tb_IFID_Reg_Stall is
    constant N : integer := 32;

    component IFID_Reg is
        generic(
            N : integer := 32
        );
        port(
            i_PC        : in    std_logic_vector((N - 1) downto 0);
            i_Inst      : in    std_logic_vector((N - 1) downto 0);
            i_IF.Flush  : in    std_logic;
            i_Stall     : in    std_logic;
            i_CLK       : in    std_logic;
            o_PC        : out   std_logic_vector((N - 1) downto 0);
            o_Inst      : out   std_logic_vector((N - 1) downto 0)
        );
    end component;

    -- Pipeline register signals
    signal PC_IFID    : std_logic_vector(N-1 downto 0);
    signal PC_IDEX    : std_logic_vector(N-1 downto 0);
    signal PC_EXMEM   : std_logic_vector(N-1 downto 0);
    signal PC_MEMWB   : std_logic_vector(N-1 downto 0);
    signal Inst_IFID  : std_logic_vector(N-1 downto 0);
    signal Inst_IDEX  : std_logic_vector(N-1 downto 0); 
    signal Inst_EXMEM : std_logic_vector(N-1 downto 0);
    signal Inst_MEMWB : std_logic_vector(N-1 downto 0);

    -- Signals for stalling and flushing
    signal Stall_IFID  : std_logic := '0';
    signal Stall_IDEX  : std_logic := '0';
    signal Stall_EXMEM : std_logic := '0';
    signal Stall_MEMWB : std_logic := '0';
    signal Flush_IFID  : std_logic := '0'; 
    signal Flush_IDEX  : std_logic := '0';
    signal Flush_EXMEM : std_logic := '0';
    signal Flush_MEMWB : std_logic := '0';

    -- Clock and input signals
    signal CLK     : std_logic := '0';
    signal PC_in   : std_logic_vector(N-1 downto 0);
    signal Inst_in : std_logic_vector(N-1 downto 0);

begin

    clock_process: process
    begin
        CLK <= '0';
        wait for 10 ns;
        CLK <= '1';
        wait for 10 ns;
    end process;

    -- Instantiate each stage register
    IFID: IFID_Reg
        generic map (N => N)
        port map (
            i_PC => PC_in,
            i_Inst => Inst_in,
            i_IF.Flush => Flush_IFID,
            i_Stall => Stall_IFID,
            i_CLK => CLK,
            o_PC => PC_IFID,
            o_Inst => Inst_IFID
        );

    IDEX: IFID_Reg
        generic map (N => N)
        port map (
            i_PC => PC_IFID,
            i_Inst => Inst_IFID,
            i_IF.Flush => Flush_IDEX,
            i_Stall => Stall_IDEX,
            i_CLK => CLK,
            o_PC => PC_IDEX,
            o_Inst => Inst_IDEX
        );

    EXMEM: IFID_Reg
        generic map (N => N)
        port map (
            i_PC => PC_IDEX,
            i_Inst => Inst_IDEX,
            i_IF.Flush => Flush_EXMEM,
            i_Stall => Stall_EXMEM,
            i_CLK => CLK,
            o_PC => PC_EXMEM,
            o_Inst => Inst_EXMEM
        );

    MEMWB: IFID_Reg
        generic map (N => N)
        port map (
            i_PC => PC_EXMEM,
            i_Inst => Inst_EXMEM,
            i_IF.Flush => Flush_MEMWB,
            i_Stall => Stall_MEMWB,
            i_CLK => CLK,
            o_PC => PC_MEMWB,
            o_Inst => Inst_MEMWB
        );

    test_process: process
    begin
        -- Values for PC and Inst inputs
        PC_in <= x"00000000";
        Inst_in <= x"11111111";

        -- Load initial values
        wait for 20 ns;

        -- Insert new values
        PC_in <= x"00000001";
        Inst_in <= x"22222222";
        wait for 20 ns;

        -- Insert new values
        PC_in <= x"00000002";
        Inst_in <= x"33333333";
        wait for 20 ns;

        -- Insert new values and stall IFID stage
        PC_in <= x"00000003";
        Inst_in <= x"44444444";
        Stall_IFID <= '1';
        wait for 20 ns;

        -- Remove stall from IFID and stall IDEX
        Stall_IFID <= '0';
        Stall_IDEX <= '1';
        PC_in <= x"00000004";
        Inst_in <= x"55555555";
        wait for 20 ns;

        -- Flush EXMEM and remove stall from IDEX
        Stall_IDEX <= '0';
        Flush_EXMEM <= '1';
        PC_in <= x"00000005";
        Inst_in <= x"66666666";
        wait for 20 ns;
        Flush_EXMEM <= '0';

        -- Insert more data and stall MEMWB
        PC_in <= x"00000006";
        Inst_in <= x"77777777";
        Stall_MEMWB <= '1';
        wait for 20 ns;

        -- Unstall MEMWB and insert final data
        Stall_MEMWB <= '0';
        PC_in <= x"00000007";
        Inst_in <= x"88888888";
        wait for 20 ns;

        wait;
    end process;

end behavior;
