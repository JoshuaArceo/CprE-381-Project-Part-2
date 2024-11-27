-------------------------------------------------------------------------
-- Author: Braedon Giblin
-- Date: 2022.02.12
-- Files: MIPS_types.vhd
-------------------------------------------------------------------------
-- Description: This file contains a skeleton for some types that 381 students
-- may want to use. This file is guarenteed to compile first, so if any types,
-- constants, functions, etc., etc., are wanted, students should declare them
-- here.
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

package MIPS_types is

  -- Example Constants. Declare more as needed
  constant DATA_WIDTH : integer := 32;
  constant ADDR_WIDTH : integer := 10;


  constant REG_ADDR_WIDTH : integer := 5;

  constant REG_31 : std_logic_vector((REG_ADDR_WIDTH -1 ) downto 0) := "11111";

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
  constant MEM_TO_REG : integer := 0;
  constant HALT       : integer := 1;
  constant REG_WRITE  : integer := 2;
  constant MEM_WRITE  : integer := 3;
  constant ALU_SRC    : integer := 4;
  constant SHIFT      : integer := 5;
  constant BRANCH     : integer := 6;
  constant BRANCH_NE  : integer := 7;
  constant JUMP_RET   : integer := 8;

  -- Example record type. Declare whatever types you need here
  type control_t is record
    reg_wr : std_logic;
    reg_to_mem : std_logic;
  end record control_t;

end package MIPS_types;

package body MIPS_types is
  -- Probably won't need anything here... function bodies, etc.
end package body MIPS_types;
