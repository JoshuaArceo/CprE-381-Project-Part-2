.data
arr: .word 10, 60, 40, 70, 20, 30, 90, 100, 0, 80, 50

.text
.globl main
main:
    addi $1, $0, 7     
    addi $2, $0, 7         
    beq $2, $1,  hello 
    j main
    addi $2, $2, 7    
    
hello:
    addi $2, $2, 7         
    addi $2, $2, 7         
    addi $2, $2, 7         
    
    # End Test

    exit:
    halt