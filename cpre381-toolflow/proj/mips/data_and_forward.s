.data
.text
.globl main
    main:
        # Start Test
        addi $t0, $zero, 5     
        add $t1, $t0, $t0      
        addi $t0, $t1, 2        
        add $t2, $t1, $t0     
        nop

        halt