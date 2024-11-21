 .data
arr:    .word 10, 60, 40, 70, 20, 30, 90, 100, 0, 80, 50  # Array to sort
space:  .asciiz " "                                       # Space for output formatting
newline: .asciiz "\n" 
.text
.globl main

main:
    # Initialization
    lui $s0, 0x1001                 # Base address of array
    li $t0, 0                       # i = 0 (outer loop index)
    li $t1, 0                       # j = 0 (inner loop index)
    li $s1, 11                      # n = 11 (array size)
    li $s2, 11                      # n-i for inner loop
    add $t2, $zero, $s0             # address for i
    add $t3, $zero, $s0             # address for j

    addi $s1, $s1, -1               # Outer loop max iterations = n-1

outer_loop:
    li $t1, 0                       # Reset j = 0 for inner loop
    addi $s2, $s2, -1               # Decrease size for inner loop
    add $t3, $zero, $s0             # Reset iterator address for j

inner_loop:
    lw $s3, 0($t3)                  # Load arr[j] into $s3
    addi $t3, $t3, 4                # Increment address iterator for j
    lw $s4, 0($t3)                  # Load arr[j+1] into $s4

    slt $t4, $s4, $s3               # $t4 = 1 if $s4 < $s3
    beq $t4, $zero, no_swap         # Skip swap if $s4 >= $s3

    # Swap arr[j] and arr[j+1]
    sw $s4, -4($t3)                 # Store $s4 into arr[j]
    sw $s3, 0($t3)                  # Store $s3 into arr[j+1]

no_swap:
    addi $t1, $t1, 1                # j++
    bne $t1, $s2, inner_loop        # Continue if j != n-i

    addi $t0, $t0, 1                # i++
    bne $t0, $s1, outer_loop        # Continue if i != n-1

    # Print sorted array
    li $t0, 0                       # Reset i for print loop
    add $t2, $zero, $s0             # Reset iterator address for print loop

print_loop:
    lw $a0, 0($t2)                  # Load current element into $a0
    li $v0, 1                       # Syscall for print integer
    syscall

    la $a0, space                   # Print space
    li $v0, 4                       # Syscall for print string
    syscall

    addi $t2, $t2, 4                # Increment iterator address
    addi $t0, $t0, 1                # i++
    bne $t0, $s1, print_loop        # Continue if i != n

    # Print newline
    la $a0, newline
    li $v0, 4
    syscall

exit:
    li $v0, 10                      # Exit syscall
    syscall
