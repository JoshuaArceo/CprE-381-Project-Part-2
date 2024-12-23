  .data
arr: .word 10, 60, 40, 70, 20, 30, 90, 100, 0, 80, 50
  space: .asciiz " "
  .text
  .globl main

main:
  lui $s0, 0x1001                   #arr[0]
  li $t0, 0                         #i = 0
  li $t1, 0                         #j = 0
  li $s1, 11                        #n = 11
  li $s2, 11                        #n-i for inner loop
  add $t2, $zero, $s0               #for iterating addr by i
  add $t3, $zero, $s0               #for iterating addr by j
  addi $s1, $s1, -1

outer_loop:
  add $t3, $zero, $s0               #resetting addr itr j
  li  $t1, 0                        #j = 0
  addi $s2, $s2, -1                 #decreasing size for inner_loop
  
  
  inner_loop:
    lw $s3, 0($t3)                  #arr[j]
    addi $t3, $t3, 4                #addr itr j += 4
    nop
    nop
    lw $s4, 0($t3)                  #arr[j+1]
    addi $t1, $t1, 1                #j++
    nop                             
    slt $t4, $s3, $s4               #set $t4 = 1 if $s3 < $s4
    nop
    nop
    bne $t4, $zero, cond
    nop
    nop
    swap:
      sw $s3, 0($t3)
      sw $s4, -4($t3)
      lw $s4, 0($t3)

    cond:
      addi $t0, $t0, 1                  #i++
      bne $t1, $s2, inner_loop      #j != n-i
      nop
      nop
      bne $t0, $s1, outer_loop           #i != n
      nop
      nop
      li $t0, 0
      addi $s1, $s1, 1
      nop

print_loop:
  addi $t0, $t0, 1                  #i++
  addi $t2, $t2, 4                  #addr itr i += 4
  nop
  bne $t0, $s1, print_loop          #i != n
  nop
  nop
  
exit:
  halt
