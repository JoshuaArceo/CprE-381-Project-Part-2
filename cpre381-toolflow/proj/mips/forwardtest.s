

    .data
.text
.globl main
main:
    # Start Test
    lui $5, 0x1001
    addi $1, $0, 4   
    add $2, $1, $2  
    add $3, $1, $2  
    sw   $2, 0($5)
    addi $1, $0, 10 
    addi $2, $2, 12  
    addi $6, $3, 12  
    lw  $4, 0($5)
    sw  $4, 0($5)


    halt