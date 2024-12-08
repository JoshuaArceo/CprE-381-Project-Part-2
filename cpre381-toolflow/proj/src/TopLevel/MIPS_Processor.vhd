-------------------------------------------------------------------------
-- Henry Duwe
-- Department of Electrical and Computer Engineering
-- Iowa State University
-------------------------------------------------------------------------


-- MIPS_Processor.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains a skeleton of a MIPS_Processor  
-- implementation.

-- 01/29/2019 by H3::Design created.
-------------------------------------------------------------------------


library IEEE;
use IEEE.std_logic_1164.all;

library work;
use work.MIPS_types.all;

entity MIPS_Processor is
  generic(N : integer := DATA_WIDTH);
  port(iCLK            : in std_logic;
       iRST            : in std_logic;
       iInstLd         : in std_logic;
       iInstAddr       : in std_logic_vector(N-1 downto 0);
       iInstExt        : in std_logic_vector(N-1 downto 0);
       oALUOut         : out std_logic_vector(N-1 downto 0)); 
      
end  MIPS_Processor;


architecture structure of MIPS_Processor is

  -- Required data memory signals
  signal s_DMemWr       : std_logic; -- TODO: use this signal as the final active high data memory write enable signal
  signal s_DMemAddr     : std_logic_vector(N-1 downto 0); -- TODO: use this signal as the final data memory address input
  signal s_DMemData     : std_logic_vector(N-1 downto 0); -- TODO: use this signal as the final data memory data input
  signal s_DMemOut      : std_logic_vector(N-1 downto 0); -- TODO: use this signal as the data memory output
 
  -- Required register file signals 
  signal s_RegWr        : std_logic; -- TODO: use this signal as the final active high write enable input to the register file
  signal s_RegWrAddr    : std_logic_vector(4 downto 0); -- TODO: use this signal as the final destination register address input
  signal s_RegWrData    : std_logic_vector(N-1 downto 0); -- TODO: use this signal as the final data memory data input

  -- Required instruction memory signals
  signal s_IMemAddr     : std_logic_vector(N-1 downto 0); -- Do not assign this signal, assign to s_NextInstAddr instead
  signal s_NextInstAddr : std_logic_vector(N-1 downto 0); -- TODO: use this signal as your intended final instruction memory address input.
  signal s_Inst         : std_logic_vector(N-1 downto 0); -- TODO: use this signal as the instruction signal 

  -- Required halt signal -- for simulation
  signal s_Halt         : std_logic;  -- TODO: this signal indicates to the simulation that intended program execution has completed. (Opcode: 01 0100)

  -- Required overflow signal -- for overflow exception detection
  signal s_Ovfl         : std_logic;  -- TODO: this signal indicates an overflow exception would have been initiated


  component mem is
    generic(ADDR_WIDTH : integer;
            DATA_WIDTH : integer);
    port(
          clk          : in std_logic;
          addr         : in std_logic_vector((ADDR_WIDTH-1) downto 0);
          data         : in std_logic_vector((DATA_WIDTH-1) downto 0);
          we           : in std_logic := '1';
          q            : out std_logic_vector((DATA_WIDTH -1) downto 0));
    end component;

  -- TODO: You may add any additional signals or components your implementation 
  --       requires below this comment

  component invg is
    port(
        i_A : in std_logic;
        o_F : out std_logic
    );
end component;

component andg2 is
    port(
        i_A : in std_logic;
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

    component fetch_logic is
      generic(N : integer);
      PORT (
        i_PC4             : in std_logic_vector(N - 1 downto 0); 
        i_JAddr           : in std_logic_vector(25 downto 0);
        i_BranchAddr      : in std_logic_Vector(N-1 downto 0);
        i_RegA            : in std_logic_vector(N - 1 downto 0);
        i_Branch          : in std_logic; 
        i_ALU_Zero        : in std_logic;
        i_Jump            : in std_logic;  
        i_JR              : in std_logic;
        i_BNE             : in std_logic;  
        o_BRANCHING       : out std_logic;
        o_Next_PC         : out std_logic_vector(N - 1 downto 0) 
        );
      end component;
      
      component IFID_Reg is
        generic(
            N : integer
        );
        port(
            i_PC4       : in     std_logic_vector((N - 1) downto 0);
            i_Inst      : in     std_logic_vector((N - 1) downto 0);
            i_CLK       : in     std_logic;
            i_Flush     : in    std_logic;
            i_Stall     : in    std_logic;
            o_PC4       : out    std_logic_vector((N - 1) downto 0);
            o_Inst      : out    std_logic_vector((N - 1) downto 0)
        );
    end component;

    component IDEX_Reg is
      generic(
          Addr_Width : integer;
          N : integer
      );
      port(
          i_Inst      : in    std_logic_vector((N - 1) downto 0);
          i_ReadA     : in     std_logic_vector((N - 1) downto 0);
          i_ReadB     : in     std_logic_vector((N - 1) downto 0);
          -- i_AddrA     : in     std_logic_vector((Addr_Width - 1) downto 0);
          -- i_AddrB     : in     std_logic_vector((Addr_Width - 1) downto 0);
          i_WB_Addr    : in     std_logic_vector((Addr_Width - 1) downto 0);
          i_BranchAddr  : in     std_logic_vector(N -1 downto 0);
          i_ImmExt    : in     std_logic_vector((N - 1) downto 0);
          i_CTRL_Sigs : in     std_logic_vector(8 downto 0);  
          i_CLK       : in     std_logic;
          i_Flush     : in    std_logic;
          i_Stall     : in    std_logic;
          o_Inst      : out    std_logic_vector((N - 1) downto 0);
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
  end component;

  component EXMEM_Reg is
    generic(
        Addr_Width : integer;
        N : integer
    );
    port(
        i_Inst      : in    std_logic_vector((N - 1) downto 0);
        i_ALU_Out   : in    std_logic_vector((N - 1) downto 0);
        i_W_Data    : in    std_logic_vector((N - 1) downto 0);
        i_WB_Addr   : in    std_logic_vector((Addr_Width - 1) downto 0);
        i_CTRL_Sigs : in    std_logic_vector(3 downto 0);
        i_CLK       : in    std_logic;
        i_Flush     : in    std_logic;
        i_Stall     : in    std_logic;
        o_Inst      : out    std_logic_vector((N - 1) downto 0);
        o_ALU_Out   : out   std_logic_vector((N - 1) downto 0);
        o_W_Data    : out   std_logic_vector((N - 1) downto 0);
        o_WB_Addr   : out   std_logic_vector((Addr_Width - 1) downto 0);
        o_CTRL_Sigs : out   std_logic_vector(3 downto 0)
    );
  end component;

  component MEMWB_Reg is
    generic(
        Addr_Width : integer;
        N : integer
    );
    port(
        i_Inst      : in    std_logic_vector((N - 1) downto 0);
        i_ALU       : in    std_logic_vector((N - 1) downto 0);
        i_Mem_Data    : in    std_logic_vector((N - 1) downto 0);
        i_WB_Addr   : in    std_logic_vector((Addr_Width - 1) downto 0);
        i_CTRL_Sigs : in    std_logic_vector(2 downto 0);
        i_CLK       : in    std_logic;
        i_Flush     : in    std_logic;
        i_Stall     : in    std_logic;
        o_Inst      : out    std_logic_vector((N - 1) downto 0);
        o_ALU       : out   std_logic_vector((N - 1) downto 0);
        o_Mem_Data    : out   std_logic_vector((N - 1) downto 0);
        o_WB_Addr   : out   std_logic_vector((Addr_Width - 1) downto 0);
        o_CTRL_Sigs : out    std_logic_vector(2 downto 0)

    );

    end component;

    component dffg is

      port(i_CLK        : in std_logic;     -- Clock input
           i_RST        : in std_logic;     -- Reset input
           i_WE         : in std_logic;     -- Write enable input
           i_D          : in std_logic;     -- Data value input
           o_Q          : out std_logic);   -- Data value output
    
    end component;

      component pc_reg is
        generic(N : integer);
        port(
          i_D	: in std_logic_vector(N-1 downto 0);
          i_RST	: in std_logic;
          i_CLK	: in std_logic;
          i_WE	: in std_logic;
          o_Q	: out std_logic_vector(N-1 downto 0)
          );
      end component;

      component regfile is 
      generic(
        ADDR_WIDTH : integer;
        DATA_WIDTH : integer);
      port(
        i_rA    : in    std_logic_vector((REG_ADDR_WIDTH-1) downto 0); -- 5 bit register address source
        i_rB    : in    std_logic_vector((REG_ADDR_WIDTH-1) downto 0); -- 5 bit register address target
        i_rW    : in    std_logic_vector((REG_ADDR_WIDTH-1) downto 0); -- 5 bit register address destination
        i_WE    : in    std_logic;
        i_D     : in    std_logic_vector((DATA_WIDTH - 1) downto 0);
        i_CLK   : in    std_logic;
        i_RST   : in    std_logic;
        o_ReadA : out   std_logic_vector((DATA_WIDTH - 1) downto 0);
        o_ReadB : out   std_logic_vector((DATA_WIDTH - 1) downto 0)
    );
    end component;

    component mux2t1_N is
      generic(N : integer);
      port(
       i_S          : in std_logic;
       i_D0         : in std_logic_vector((N - 1) downto 0);
       i_D1         : in std_logic_vector((N - 1) downto 0);
       o_O          : out std_logic_vector((N - 1) downto 0));
      end component;

      component mux3t1_N is
        generic(N : integer); 
          port(
              i_A     : in std_logic_vector((N - 1) downto 0);
              i_B     : in std_logic_vector((N - 1) downto 0);
              i_C     : in std_logic_vector((N - 1) downto 0);        
              i_Sel   : in std_logic_vector(1 downto 0);
              o_F     : out std_logic_vector((N - 1) downto 0)
          );
      end component;

  component shifter is
  port(
        i_D     : in    std_logic_vector(N-1 downto 0);
        i_AMT     : in    std_logic_vector(4 downto 0);
        i_DIR   : in    std_logic; -- 1 left , 0 right
        i_ARITH   : in    std_logic; -- 0 logical, 1 arithmetic
        o_Q     : out   std_logic_vector(N-1 downto 0)
    );
    end component;

    component extend16t32 is
      port(
        i_data   : in std_logic_vector((DATA_WIDTH/2 -1) downto 0);
        i_signed : in std_logic;
        o_data   : out std_logic_vector((DATA_WIDTH - 1) downto 0)
    );
    end component;

    component ALUcontrol is 
    port(
      i_func       : in std_logic_Vector(5 downto 0);
      i_opcode       : in std_logic_Vector(5 downto 0);
      s_out        : out std_logic_Vector(3 downto 0)
	   );  
     end component;

     component alu is 
     port (
          i_OP_A      : in    std_logic_vector((DATA_WIDTH - 1) downto 0);
          i_OP_B      : in    std_logic_vector((DATA_WIDTH - 1) downto 0);
          i_ALUCTRL     : in    std_logic_vector(3 downto 0); -- 4 bit to support 13 functions
          o_F         : out   std_logic_vector((DATA_WIDTH - 1) downto 0);
          o_C_OUT     : out   std_logic;
          o_OVERFLOW  : out   std_logic;
          o_ZERO      : out std_logic
        );
        end component;
     
     component control is 
        port( 
          i_opcode       :   in std_logic_vector(5 downto 0); --bits 31-26 opcode
          i_func         :   in std_logic_vector(5 downto 0);
          o_ALUSrc       :   out std_logic; --use correcty extended immediate from B
          o_MemtoReg     :   out std_logic; -- on 0 does not read from memory
          o_Shift          :   out std_logic;
          o_Jal          :   out std_logic;
          o_JR           :   out std_logic;
          o_DMemWr       :   out std_logic; --memwrite from text, on 0 does not write to memory
          o_RegWr        :   out std_logic; --Regwrite from text, on 1 writes back to a register
          o_Jump	     :   out std_logic;
          o_Branch	     :   out std_logic;
          o_BNE			 :   out std_logic;
          o_Halt	     :   out std_logic;
          o_RegDst       :   out std_logic;  --uses rt as destinatioForwardingUnitn register rather than rd
          o_SignExt	     :   out std_logic
          ); 
      end component;

      component ripple_adder_N is
        port(
          i_A	: in std_logic_vector((DATA_WIDTH - 1) downto 0);
          i_B	: in std_logic_vector((DATA_WIDTH - 1) downto 0);
          i_Cin	: in std_logic;
          o_S	: out std_logic_vector((DATA_WIDTH - 1) downto 0);
          o_OFCIN: out std_logic; --ignore this is only used in ALU
          o_Cout	: out std_logic
        );

      end component;

      component ForwardingUnit is
        port (
          EX_Inst      : in std_logic_vector(31 downto 0); 
          MEM_Inst     : in std_logic_vector(31 downto 0); 
          WB_Inst      : in std_logic_vector(31 downto 0); 
          MEM_Dst      : in std_logic_vector(4 downto 0);
          WB_Dst       : in std_logic_vector(4 downto 0); 
          MEM_RegWrite : in std_logic;                     -- Signal for MEM stage
          WB_RegWrite  : in std_logic;                     -- Signal for WB stage
          ALU_Src      : in std_logic;
          forward_A    : out std_logic_vector(1 downto 0); -- Forwarding control for rs
          forward_B    : out std_logic_vector(1 downto 0); -- Forwarding control for rt
          forward_data_reg : out std_logic_vector(1 downto 0); -- Forwarding control for DMEM address
          forward_data : out std_logic_vector(1 downto 0)  -- Forwarding control for DMEM data
        );
    end component; 
    
    component HazardDetection is
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
  end component;

    signal s_ofDel1, s_ofDel2  : std_logic;



  -- Instruction Signals
  
  
  signal s_ID_inst_opcode, s_EX_inst_opcode, s_ID_inst_func, s_EX_inst_func   : std_logic_vector(5 downto 0);
  signal s_inst_addr_RS, s_inst_Addr_RT, s_inst_Addr_RD, s_EX_WB_Addr, s_MEM_WB_Addr, s_WB_WB_Addr: std_logic_vector((REG_ADDR_WIDTH -1) downto 0);
  signal s_inst_jumpAddr: std_logic_vector(25 downto 0);
  signal s_inst_imm      : std_logic_vector((16-1) downto 0);

  signal s_ID_Inst, s_EX_Inst, s_MEM_Inst, s_WB_Inst, s_ID_ImmExt, s_EX_ImmExt, s_shifted_imm       : std_logic_vector((DATA_WIDTH - 1) downto 0);

  signal s_PC, s_IF_PC4, s_ID_PC4, s_EX_Branch_Addr, s_branch_addr          : std_logic_vector((DATA_WIDTH -1) downto 0);

  --RegFile Signals
  signal s_regDstMux : std_logic_vector((REG_ADDR_WIDTH -1) downto 0);
  signal s_ID_Reg_A, s_EX_Reg_A, s_ID_Reg_B, s_EX_Reg_B : std_logic_vector((DATA_WIDTH -1 )downto 0);

  --ALU Signals
  signal  s_ALU_Zero, s_ALU_COUT, s_ALU_Ovfl, s_NotBranch: std_logic;
  signal s_ALUOP : std_logic_vector(3 downto 0);
  signal s_MEM_ALU_Out : std_logic_vector((DATA_WIDTH - 1) downto 0); 
  signal s_ALU_A_In, s_ALU_B_In, s_ALU_A_Src, s_ALU_B_Src, s_ALU_Out   :std_logic_vector((DATA_WIDTH - 1) downto 0);

  -- control signals
  signal s_JAL, s_Jump, s_RegDst, s_signExt : std_logic;
  signal s_ID_CTRL_Sigs   : std_logic_vector(8 downto 0);
  signal s_EX_CTRL_Sigs   : std_logic_vector(8 downto 0);
  signal s_MEM_CTRL_Sigs  : std_logic_vector(3 downto 0);
  signal s_WB_CTRL_Sigs   : std_logic_vector(2 downto 0);

  signal s_MEM_DMem_Data, s_MEM_WBReg_Data, s_EX_DMemData : std_logic_vector((DATA_WIDTH - 1) downto 0);
  

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

  --Write Back Data 
  signal s_WB_WBDataZero, s_WB_WBDataOne, s_WB_Data : std_logic_vector((DATA_WIDTH)-1 downto 0);

  --Stall and Flush Signals
  signal s_PC_Stall, s_IFID_Stall, s_IDEX_Stall, s_EXMEM_Stall, s_MEMWB_Stall : std_logic := '0';
  signal s_IFID_Flush, s_IDEX_Flush, s_EXMEM_Flush, s_MEMWB_Flush : std_logic;
  --TODO RST will set all flush values to 1 in the hazard detection unit

  signal s_HzdBrnch : std_logic;


  --Forwarding signals
  signal s_Fwd_A, s_Fwd_B, s_Fwd_D, s_Fwd_D_R: std_logic_vector(1 downto 0);

begin

--TODO remove when hazard control implemented
  -- s_IFID_Flush  <= iRst;
  -- s_IDEX_Flush  <= iRst;
  -- s_EXMEM_Flush <= iRst; 
  -- s_MEMWB_Flush <= iRst; 

  -- TODO: This is required to be your final input to your instruction memory. This provides a feasible method to externally load the memory module which means that the synthesis tool must assume it knows nothing about the values stored in the instruction memory. If this is not included, much, if not all of the design is optimized out because the synthesis tool will believe the memory to be all zeros.
  with iInstLd select
    s_IMemAddr <= s_NextInstAddr when '0',
      iInstAddr when others;


  IMem: mem
    generic map(ADDR_WIDTH => ADDR_WIDTH,
                DATA_WIDTH => N)
    port map(clk  => iCLK,
             addr => s_IMemAddr(11 downto 2),
             data => iInstExt,
             we   => iInstLd,
             q    => s_Inst);
  
  DMem: mem
    generic map(ADDR_WIDTH => ADDR_WIDTH,
                DATA_WIDTH => N)
    port map(clk  => iCLK,
             addr => s_DMemAddr(11 downto 2),
             data => s_DMemData,
             we   => s_DMemWr,
             q    => s_DMemOut);

  -- TODO: Ensure that s_Halt is connected to an output control signal produced from decoding the Halt instruction (Opcode: 01 0100)
  -- TODO: Ensure that s_Ovfl is connected to the overflow output of your ALU

  -- TODO: Implement the rest of your processor below this comment! 


------------------------------FETCH------------------------------

  pcreg: pc_reg
  generic map(N => DATA_WIDTH)
  port map(
    i_D => s_PC,
    i_RST => iRST,
    i_CLK => iCLK,
    i_WE => not s_PC_Stall,
    o_Q => s_NextInstAddr
  );

  PC_Add4 : ripple_adder_N
    port map(
        i_A => s_NextInstAddr, 
        i_B => X"00000004",
        i_Cin => '0',
        o_S => s_IF_PC4
    );


    pcFetch: fetch_logic
    generic map(N=>N)
    port map(
        i_PC4             => s_IF_PC4,
        i_JAddr           => s_inst_jumpAddr,
        i_BranchAddr      => s_EX_Branch_Addr,
        i_RegA            => s_EX_Reg_A,
        i_Branch          => s_EX_CTRL_Sigs(BRANCH), 
        i_ALU_Zero        => s_ALU_Zero,
        i_Jump            => s_Jump,
        i_JR              => s_EX_CTRL_Sigs(JUMP_RET),
        i_BNE             => s_EX_CTRL_Sigs(BRANCH_NE),
        o_BRANCHING       => s_HzdBrnch,
        o_Next_PC         => s_PC 
    );

  IFID: IFID_Reg
  generic map(N => N)
  port map(
    i_PC4 => s_IF_PC4,
    i_Inst => s_Inst,
    i_CLK => iCLK,
    i_Flush => s_IFID_Flush,
    i_Stall => s_IFID_Stall,

------------------------------DECODE------------------------------
    
    o_PC4 => s_ID_PC4,
    o_Inst => s_ID_inst
  );

s_ID_inst_opcode  <= s_ID_inst(31 downto 26);
s_inst_addr_RS    <= s_ID_inst(25 downto 21);
s_inst_addr_RT    <= s_ID_inst(20 downto 16);
s_inst_addr_RD    <= s_ID_inst(15 downto 11);
s_ID_inst_func    <= s_ID_inst(5 downto 0);
s_inst_imm        <= s_ID_inst(15 downto 0);
s_Inst_jumpAddr   <= s_ID_Inst(25 downto 0);



CTRL: control
port map(
  i_opcode => s_ID_inst_opcode,                
  i_func => s_ID_inst_func,                    

  o_ALUSrc => s_ID_CTRL_Sigs(ALU_SRC),      -- Carries to EX
  o_MemtoReg => s_ID_CTRL_Sigs(MEM_TO_REG), -- Carries to MEM
  o_Shift => s_ID_CTRL_Sigs(SHIFT),         -- Carries to EX
  o_JAL => s_JAL,                           -- Stays in ID
  o_JR => s_ID_CTRL_Sigs(JUMP_RET),         -- Carries to EX
  o_DMemWr => s_ID_CTRL_Sigs(MEM_WRITE),    -- Carries to MEM
  o_RegWr => s_ID_CTRL_Sigs(REG_WRITE),     -- Carries to WB
  o_Jump => s_Jump,                         -- Stays in ID
  o_Branch => s_ID_CTRL_Sigs(BRANCH),       -- Carries to EX
  o_BNE   => s_ID_CTRL_Sigs(BRANCH_NE),     -- Carries to EX
  o_Halt => s_ID_CTRL_Sigs(HALT),           -- Carries to WB
  o_RegDst => s_RegDst,                     -- Stays in ID
  o_signExt => s_signExt                    -- Stays in ID
);

HzdDetection: HazardDetection
port map(


  IF_Inst      => s_Inst,
  ID_Inst      => s_ID_Inst,
  EX_Inst      => s_EX_Inst,
  MEM_Inst     => s_MEM_Inst,
  WB_Inst      => s_WB_Inst,

  ID_Dst       => s_regDstMux,
  EX_Dst       => s_EX_WB_Addr, 
  MEM_Dst      => s_MEM_WB_Addr,
  WB_Dst       => s_WB_WB_Addr, 

  EX_WriteToReg   => s_EX_CTRL_Sigs(REG_WRITE),
  MEM_WriteToReg  => s_MEM_CTRL_Sigs(REG_WRITE),
  WB_WriteToReg   => s_WB_CTRL_Sigs(REG_WRITE),

  i_RST           => iRST,
  i_EX_branch     => s_HzdBrnch,

  o_PC_Stall       => s_PC_Stall,
  o_IFID_Flush     =>  s_IFID_Flush,
  o_IFID_Stall     =>  s_IFID_Stall,
  o_IDEX_Flush     =>  s_IDEX_Flush,
  o_IDEX_Stall     =>  s_IDEX_Stall,
  o_EXMEM_Flush    =>  s_EXMEM_Flush,
  o_EXMEM_Stall    =>  s_EXMEM_Stall,
  o_MEMWB_Flush    =>  s_MEMWB_Flush,
  o_MEMWB_Stall    =>  s_MEMWB_Stall
  );

muxRegWrite0: mux2t1_N
    generic map(N => REG_ADDR_WIDTH)
    port map(
      i_S => s_RegDst,
      i_D0 => s_inst_addr_RT,
      i_D1 => s_inst_addr_RD,
      o_O => s_regDstMux --sent through pipeline
    );

    muxRegWrite1: mux2t1_N
    generic map(N => REG_ADDR_WIDTH)
    port map(
      i_S => s_JAL,
      i_D0 => s_WB_WB_Addr, --from WB
      i_D1 => REG_31,
      o_O => s_RegWrAddr
    );

    wbJALMux : mux2t1_N
    generic map(N => N)
    port map(
      i_S => s_JAL,
      i_D0 => s_WB_Data,
      i_D1 => s_ID_PC4,
      o_O => s_RegWrData
    );

    OR_RegWE: org2
    port map(
      i_A => s_WB_CTRL_Sigs(REG_WRITE),
      i_B => s_JAL,
      o_F => s_RegWr 
    );

    regFile0: regfile
    generic map(
      ADDR_WIDTH => REG_ADDR_WIDTH,
      DATA_WIDTH => N
    )
    port map(
      i_rA => s_inst_addr_RS,
      i_rB => s_inst_addr_RT,
      i_rW => s_RegWrAddr,
      i_WE => s_RegWr,
      i_D => s_RegWrData,
      i_CLK => not iCLK,
      i_RST => iRST,
      o_ReadA => s_ID_Reg_A,
      o_ReadB => s_ID_Reg_B
    );

    signExt: extend16t32
    port map(
        i_data   => s_inst_imm,
        i_signed => s_signExt,
        o_data   => s_ID_ImmExt
    );

    Branch_Shifter : shifter
    port map(
        i_D                => s_ID_ImmExt,
        i_AMT              => "00010",     
        i_DIR              => '1',    
        i_ARITH            => '0', 
        o_Q                => s_shifted_imm
    );

    Branch_PC_Adder : ripple_adder_N
    port map(
        i_A => s_ID_PC4,
        i_B => s_shifted_imm,
        i_Cin => '0',
        o_S => s_branch_addr
    );

    IDEX: IDEX_Reg
    generic map(Addr_Width =>REG_ADDR_WIDTH,
      N=>N)
    port map(
      i_Inst        => s_ID_Inst,
      i_ReadA       => s_ID_Reg_A,
      i_ReadB       => s_ID_Reg_B,
      i_WB_Addr     => s_regDstMux,
      i_BranchAddr  => s_branch_addr,
      i_ImmExt      => s_ID_ImmExt,
      i_CTRL_Sigs   => s_ID_CTRL_Sigs,
      i_CLK         => iCLK,
      i_Flush => s_IDEX_Flush,
      i_Stall => s_IDEX_Stall,

      --------------------------------EXECUTE--------------------------------
      o_Inst        => s_EX_Inst,
      o_ReadA       => s_EX_Reg_A,
      o_ReadB       => s_EX_Reg_B,
      o_WB_Addr     => s_EX_WB_Addr,
      o_BranchAddr  => s_EX_Branch_Addr,
      o_ImmExt      => s_EX_ImmExt,
      o_CTRL_Sigs   => s_EX_CTRL_Sigs
    );

    s_EX_Inst_opcode  <= s_EX_Inst(31 downto 26);
    s_EX_Inst_func    <= s_EX_Inst(5 downto 0);

ALUCtrl: ALUcontrol
port map(
  i_func => s_EX_inst_func,
  i_opcode => s_EX_inst_opcode,
  s_out => s_ALUOP 
);

Fwd: ForwardingUnit
  port map(
      EX_Inst         => s_EX_Inst,
      MEM_Inst        => s_MEM_Inst, 
      WB_Inst         => s_WB_Inst,
      MEM_Dst         => s_MEM_WB_Addr,   -- Register in MEM stage
      WB_DST          => s_WB_WB_Addr,    -- Register in WB stage
      MEM_RegWrite    => s_MEM_CTRL_Sigs(REG_WRITE), -- Signal for MEM stage
      WB_RegWrite     => s_WB_CTRL_Sigs(REG_WRITE),  -- Signal for WB stage
      ALU_Src         => s_EX_CTRL_Sigs(ALU_SRC),
      forward_A       => s_Fwd_A,                    -- Forwarding control for rs
      forward_B       => s_Fwd_B,                    -- Forwarding control for rt
      forward_data_reg    => s_Fwd_D_R,                    -- Forwarding control for DMEM address
      forward_data    => s_Fwd_D                     -- Forwarding control for DMEM data
  );


ALUSrc: mux2t1_N
    generic map(N => N)
    port map(
      i_S =>  s_EX_CTRL_Sigs(ALU_SRC),
      i_D0 => s_EX_Reg_B,
      i_D1 => s_EX_ImmExt,
      o_O => s_ALU_B_Src
    );

    ALUSrcShift: mux2t1_N
    generic map(N => N)
    port map(
      i_S => s_EX_CTRL_Sigs(SHIFT),
      i_D0 => s_EX_Reg_A,
      i_D1 => s_EX_Reg_B,
      o_O =>  s_ALU_A_Src
    );

    fwdMuxA: mux3t1_N 
    generic map(N => N)
    port map(
      i_A   => s_ALU_A_Src,
      i_B   => s_WB_Data,
      i_C   => s_DMemAddr,
      i_Sel => s_Fwd_A,
      o_F   => s_ALU_A_In
    );

    fwdMuxB: mux3t1_N 
    generic map(N => N)
    port map(
      i_A   => s_ALU_B_Src,
      i_B   => s_WB_Data,
      i_C   => s_DMemAddr,
      i_Sel => s_Fwd_B,
      o_F   => s_ALU_B_In
    );

ALU0: alu
    port map(
      i_OP_A => s_ALU_A_In,
      i_OP_B => s_ALU_B_In,
      i_ALUCTRL => s_ALUOP,
      o_F => s_ALU_Out,
      o_C_OUT => s_ALU_COUT,
      o_OVERFLOW => s_ALU_Ovfl,
      o_ZERO => s_ALU_Zero
    );


    -- For synthesis
    oALUOut <= s_ALU_Out;

  --Overflow Detection:

  notBranch: invg
    port map(
      i_A => s_EX_CTRL_Sigs(BRANCH),   
      o_F => s_NotBranch
    );

    ovflAnd: andg2
    port map(
      i_A => s_ALU_Ovfl,
      i_B => s_NotBranch,
      o_F => s_ofDel1
    );
    --TODO ADD OVERFLOW TAG TO REGISTERS

    ovflDel1: dffg
    port map(
       i_CLK => iClk,
       i_RST => iRST,
       i_WE  => '1',
       i_D   => s_ofDel1,
       o_Q   => s_ofDel2
    );
    ovflDel2: dffg
    port map(
       i_CLK => iClk,
       i_RST => iRST,
       i_WE  => '1',
       i_D   => s_ofDel2,
       o_Q   => s_Ovfl
    );

    WriteDataMux: mux2t1_N
    generic map(N => N)
    port map(
      i_S  => s_FWD_D(1),
      i_D0 => s_EX_Reg_B,
      i_D1 => s_WB_Data,
      o_O  => s_EX_DMemData
      );


    EXMEM: EXMEM_Reg
    generic map(
      Addr_Width => REG_ADDR_WIDTH,
      N => N
    )
    port map(
      i_Inst      => s_EX_Inst,
      i_ALU_Out   => s_ALU_Out,
      i_W_Data    => s_EX_DMemData,
      i_WB_Addr   => s_EX_WB_Addr,
      i_CTRL_Sigs => s_EX_CTRL_Sigs(3 downto 0),
      i_CLK       => iCLK,
      i_Flush => s_EXMEM_Flush,
      i_Stall => s_EXMEM_Stall,

--------------------------------MEMORY--------------------------------
      o_Inst      => s_MEM_Inst,
      o_ALU_Out   => s_DMemAddr,
      o_W_Data    => s_MEM_DMem_Data,
      o_WB_Addr   => s_MEM_WB_Addr,
      o_CTRL_Sigs => s_MEM_CTRL_Sigs 
    );

    s_DMemWr <= s_MEM_CTRL_Sigs(MEM_WRITE);
  
    
    fwdDMemMux: mux3t1_N
    generic map(N => N)
    port map(
      i_A   => s_MEM_DMem_Data,
      i_B   => s_WB_Data,
      i_C   => s_MEM_WBReg_Data,
      i_Sel => s_Fwd_D,
      o_F   => s_DMemData
    );

    MEMWB: MEMWB_Reg
    generic map(
      Addr_Width => REG_ADDR_WIDTH,
      N => N
    )
    port map(
      i_Inst      => s_MEM_Inst,
      i_ALU => s_DMemAddr,
      i_Mem_Data => s_DMemOut,
      i_WB_Addr => s_MEM_WB_Addr,
      i_CTRL_Sigs => s_MEM_CTRL_Sigs(2 downto 0),
      i_CLK => iCLK,
      i_Flush => s_MEMWB_Flush,
      i_Stall => s_MEMWB_Stall,

------------------------------WRITE-BACK------------------------------

      o_Inst      => s_WB_Inst,
      o_ALU => s_WB_WBDataZero,
      o_Mem_Data => s_WB_WBDataOne,
      o_WB_Addr => s_WB_WB_Addr,
      o_CTRL_Sigs => s_WB_CTRL_Sigs 
    );

    wbDataMux: mux2t1_N
    generic map(N => N)
    port map(
      i_S => s_WB_CTRL_Sigs(MEM_TO_REG),
      i_D0 => s_WB_WBDataZero,
      i_D1 => s_WB_WBDataOne,
      o_O => s_WB_Data
    );

    s_Halt <= s_WB_CTRL_Sigs(HALT);


end structure;

