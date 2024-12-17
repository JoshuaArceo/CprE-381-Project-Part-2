  .data
arr: .word 10, 60, 40, 70, 20, 30, 90, 100, 0, 80, 50
  space: .asciiz " "
  .text
  .globl main

main:
  addi $t0, $0, 3
  addi $t1, $0, 0

branch:
  addi $t1, $t1, 1
  bne $t1, $t0, branch
  addi $t2, $0, 5  
  addi $t3, $0, 2



halt
