library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity tb_SW_MIPS_Processor_ is
end tb_SW_MIPS_Processor_;

architecture behavior of tb_SW_MIPS_Processor_ is
  constant N : integer := 32; 
  constant Addr_Width : integer := 5; 
  constant CLK_PERIOD : time := 10 ns;
  
  signal clk   : std_logic := '0';
  signal rst   : std_logic := '0';
  signal if_pc4_in, if_inst_in : std_logic_vector(N-1 downto 0) := (others => '0');
  signal if_pc4_out, if_inst_out : std_logic_vector(N-1 downto 0);
  signal id_inst_in, id_readA_in, id_readB_in : std_logic_vector(N-1 downto 0) := (others => '0');
  signal id_immext_in : std_logic_vector(N-1 downto 0) := (others => '0');
  signal id_ctrl_sigs_in : std_logic_vector(8 downto 0) := (others => '0');
  signal id_inst_out, id_readA_out, id_readB_out : std_logic_vector(N-1 downto 0);
  signal id_immext_out : std_logic_vector(N-1 downto 0);
  signal id_ctrl_sigs_out : std_logic_vector(8 downto 0);

begin
  clk_process: process
  begin
    while true loop
      clk <= '0';
      wait for CLK_PERIOD / 2;
      clk <= '1';
      wait for CLK_PERIOD / 2;
    end loop;
  end process;

  rst_process: process
  begin
    rst <= '1';
    wait for 20 ns;
    rst <= '0';
    wait;
  end process;

  uut_ifid: IFID_Reg
    generic map(N => N)
    port map(
      i_PC4 => if_pc4_in,
      i_Inst => if_inst_in,
      i_CLK => clk,
      i_RST => rst,
      o_PC4 => if_pc4_out,
      o_Inst => if_inst_out
    );

  uut_idex: IDEX_Reg
    generic map(Addr_Width => Addr_Width, N => N)
    port map(
      i_Inst => id_inst_in,
      i_ReadA => id_readA_in,
      i_ReadB => id_readB_in,
      i_WB_Addr => (others => '0'),
      i_BranchAddr => (others => '0'),
      i_ImmExt => id_immext_in,
      i_CTRL_Sigs => id_ctrl_sigs_in,
      i_CLK => clk,
      i_RST => rst,
      o_Inst => id_inst_out,
      o_ReadA => id_readA_out,
      o_ReadB => id_readB_out,
      o_WB_Addr => open,
      o_BranchAddr => open,
      o_ImmExt => id_immext_out,
      o_CTRL_Sigs => id_ctrl_sigs_out
    );

  test_stimuli: process
  begin
    -- Test 1
    if_pc4_in <= X"00000004";
    if_inst_in <= X"12345678";
    id_inst_in <= X"12345678";
    id_readA_in <= X"00000001";
    id_readB_in <= X"00000002";
    id_immext_in <= X"0000FFFF";
    id_ctrl_sigs_in <= "100101011";
    wait for 30 ns;
    -- Test 2
    if_pc4_in <= X"00000008";
    if_inst_in <= X"87654321";
    id_inst_in <= X"87654321";
    id_readA_in <= X"00000010";
    id_readB_in <= X"00000020";
    id_immext_in <= X"0000AAAA";
    id_ctrl_sigs_in <= "011010100";
    wait for 50 ns;
    wait;
  end process;

end behavior;
