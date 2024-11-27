  .data
arr: .word 10, 60, 40, 70, 20, 30, 90, 100, 0, 80, 50
  space: .asciiz " "
  .text
  .globl main

main:
  addi $t0, $0, 5  
  addi $t1, $0, 0
  nop
  nop
  nop

branch:
  addi $t1, $t1, 1
  nop
  nop
  nop
  bne $t1, $t0, branch
  nop
  nop



halt
