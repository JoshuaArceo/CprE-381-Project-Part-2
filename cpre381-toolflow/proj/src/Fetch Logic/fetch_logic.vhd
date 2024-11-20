library IEEE;
use IEEE.std_logic_1164.ALL;

entity fetch_logic is
    generic (N : INTEGER := 32); 
    port (
        i_PC4             : in std_logic_vector(N - 1 downto 0); 
        i_JAddr           : in std_logic_vector(25 downto 0);
        i_BranchAddr      : in std_logic_Vector(N - 1 downto 0);
        i_RegA            : in std_logic_vector(N - 1 downto 0);
        i_Branch          : in std_logic; 
        i_ALU_Zero        : in std_logic;
        i_Jump            : in std_logic;  
        i_JR              : in std_logic;
        i_BNE             : in std_logic;  
        o_Next_PC         : out std_logic_vector(N - 1 downto 0) 
        );

end fetch_logic;

architecture structural of fetch_logic is

    component mux2t1_N is
        generic(N : integer := 32);
        port (
            i_S  : in std_logic;
            i_D0 : in std_logic_vector(N - 1 downto 0);
            i_D1 : in std_logic_vector(N - 1 downto 0);
            o_O  : out std_logic_vector(N - 1 downto 0)
            );
    end component;

    
    component andg2 is
        port(
        i_A          : in std_logic;
        i_B          : in std_logic;
        o_F          : out std_logic
        );
    end component;

    component org2 is
        port(
        i_A          : in std_logic;
        i_B          : in std_logic;
        o_F          : out std_logic
        );
    end component;

    component invg is
        port(
            i_A : in std_logic;
            o_F : out std_logic
        );
    end component;


    signal s_PC4, s_branch_addr, s_jumpAddr, s_branchOut, s_jrOut : std_logic_vector(N-1 downto 0); 
    signal s_BranchSelect, s_BranchZero, s_BNEZero, s_not_ALU_Zero, s_JumpsOr, s_OutSel  : std_logic;

begin

    s_PC4 <= i_PC4;
    s_jumpAddr <= s_PC4(31 downto 28) & i_JAddr & "00";

    beqAnd : andg2
    port map(
        i_A => i_Branch,
        i_B => i_ALU_Zero,
        o_F => s_BranchZero
    );

    notALU_Zero : invg
    port map(
        i_A => i_ALU_Zero,
        o_F => s_not_ALU_Zero
    );

    bneAnd : andg2
        port map(
        i_A => i_BNE,
        i_B => s_not_ALU_Zero,
        o_F => s_BNEZero
    );
    
    branchOr : org2
    port map(
        i_A => s_BranchZero,
        i_B => s_BNEZero,
        o_F => s_BranchSelect
    );

    jrBranch : mux2t1_N
    port map(
        i_S => i_JR,
        i_D0 => s_jumpAddr,
        i_D1 => i_RegA,
        o_O => s_jrOut
    );

    branchMux: mux2t1_N
    port map(
        i_S  => s_BranchSelect,
        i_D0 => s_jrOut,
        i_D1 => s_branch_addr,
        o_O  => s_branchOut
    );

    orJumps: org2
    port map(
        i_A => i_Jump,
        i_B => i_JR,
        o_F => s_JumpsOr
    );

    orOut: org2
    port map(
        i_A => s_JumpsOr,
        i_B => s_BranchSelect,
        o_F => s_OutSel
    );


    outMux : mux2t1_N
    port map(
        i_S => s_OutSel,
        i_D0 => s_PC4,
        i_D1 => s_branchOut,
        o_O => o_Next_PC
    );



END structural;
