  .data
arr: .word 10, 60, 40, 70, 20, 30, 90, 100, 0, 80, 50
  space: .asciiz " "
  .text
  .globl main

main:
  lui $s0, 0x1001                   #arr[0]
  addi $t0, $0, 5  
  nop
  nop
  add $t1, $0, $s0
  nop
  nop
  nop

  lw $s1, 0($t1)
  # lw $s2, 4($t1)
  nop
  nop
  nop



halt
