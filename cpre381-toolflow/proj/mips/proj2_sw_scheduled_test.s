.data
    arr: .word 10, 60, 40, 70, 20, 30, 90, 100, 0, 80, 50
.text
.globl main


 
 
main:
    lui $s0, 0x1001                                 
    addi $s1, $0, 11                        
    li $s2, 11    
    nop                      
    addi $s1, $s1, -1
    add $t2, $zero, $s0              
    add $t3, $zero, $s0  
    addu $s4, $s1, $s2  
    lw $s5, 0($s0)
    lw $s6, 4($s0)
    addiu $s3, $s4, 10
    nop
    nop
    nop
    jal here
    nop
    lw $s5, 0($s0)
    lw $s6, 4($s0)
    lw $s7, 8($s0)
    lw $t9, 12($s0)
    j yup
    nop

back:
    nop
    nor $t2, $t2, $s3
    xor $t3, $s5, $s4
    xori $t4, $t4, 0xABCDBEEF
    addi $t3, $t3, 0x0101ABDC
    subu $t2, $s6, $s5  
    nop    
    sra  $t4, $t3, 2
    bne $t2, $t3, exit
    nop
    nop
    j yup
    nop


# sra, bne,
yup:
    nop
    nop
    slt $t6, $s5, $s6
    sll $s7, $s7, 2
    srl $t9, $t9, 2
    nop
    slti $t7, $s7, 90
    sub $t3, $s5, $s6
    ori $t2, $t6, 0x1234ABCD
    add $t7, $0, $t6
    nop
    or $t8, $t7, $t6
    beq $t6, $t7, back
    nop
    nop



  
exit:
    halt


here:
    nop
    andi $t6, $s5, 0x0000FF0A
    and  $t5, $s5, $s6
    sw $s6, 0($s0)
    sw $s5, 4($s0)
    nop
    nop
    addi $s0, $s0, 4
    jr $ra
