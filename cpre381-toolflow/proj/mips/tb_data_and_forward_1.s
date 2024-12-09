.data
.text
.globl main
main:
    # Start Test
    addi $t0, $zero, 5
    nop
    add $t1, $t0, $t0 

    halt  # Read After Write (Without Fowarding)