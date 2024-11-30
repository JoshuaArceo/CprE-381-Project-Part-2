.data
    arr: .word 160, 160, 10, 10, 160, 10, 90, 100, 0, 80, 50
.text
.globl main

main:
    lui $s0, 0x1001 
   
loop:
    nop
    nop
    lw $s7, 0($s0)
    lw $t9, 4($s0)
    addi $s6, $0, 100
    addi $s5, $0, 34
    nop
    srl $s7, $s7, 2
    sll $t9, $t9, 2
    nop
    nop
    addi $s0, $s0, 4   
    beq $s7, $t9, exit
    nop
    nop
    j loop
    nop
    nop

exit:
	halt

