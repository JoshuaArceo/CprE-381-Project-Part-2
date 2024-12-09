.data
arr: .word 10, 60, 40, 70, 20, 30, 90, 100, 0, 80, 50

.text
.globl main
main:
    addi $1, $0, 1   
    la  $2, arr  
    add $1, $1, $1     
    addi $2, $2, 4       
    lw  $3, 0($2)
    addi $4, $3, 5
    halt