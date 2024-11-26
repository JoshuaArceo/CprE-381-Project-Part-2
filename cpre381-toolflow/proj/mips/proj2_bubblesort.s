.data
arr:    .word 10, 60, 40, 70, 20, 30, 90, 100, 0, 80, 50   # Array to sort
space:  .asciiz " "                                       # Space for formatting
newline: .asciiz "\n"                                     # Newline character

.text
.globl main

main:
    # Initialization
    lui $s0, 0x1001               # Load upper part of base address of arr[0] into $s0
    nop                           # Ensure instruction completion
    nop                           # Pipeline delay
    nop                           # Pipeline delay
    ori $s0, $s0, 0x0000          # Combine with lower part to get complete address
    li $t0, 0                     # i = 0
    nop
    nop
    li $t1, 0                     # j = 0
    li $s1, 11                    # n = 11
    nop
    nop
    li $s2, 11                    # n-i for inner loop
    add $t2, $zero, $s0           # Iterator address for i
    nop
    nop
    add $t3, $zero, $s0           # Iterator address for j
    addi $s1, $s1, -1             # Set outer loop iterations to n-1

outer_loop:
    li $t1, 0                     # Reset j = 0
    nop
    nop
    addi $s2, $s2, -1             # Decrease size for inner loop
    nop
    nop
    add $t3, $zero, $s0           # Reset iterator address for j

inner_loop:
    lw $s3, 0($t3)                # Load arr[j] into $s3
    nop                           # Delay for load-use hazard
    nop
    nop
    addi $t3, $t3, 4              # Increment address for j
    lw $s4, 0($t3)                # Load arr[j+1] into $s4
    nop                           # Delay for load-use hazard
    nop
    nop
    addi $t1, $t1, 1              # j++
    nop                           # Delay for arithmetic operation
    nop
    nop
    slt $t4, $s3, $s4             # Set $t4 = 1 if arr[j] < arr[j+1]
    nop                           # Delay for arithmetic result
    nop
    bne $t4, $zero, cond          # Skip swap if arr[j] < arr[j+1]
    nop                           # Branch delay slot
    nop

swap:
    sw $s3, 0($t3)                # Store $s3 into arr[j+1]
    nop                           # Delay for store completion
    nop
    sw $s4, -4($t3)               # Store $s4 into arr[j]
    nop
    lw $s4, 0($t3)                # Reload arr[j+1] into $s4
    nop                           # Delay for load-use hazard
    nop
    nop

cond:
    bne $t1, $s2, inner_loop      # Continue inner loop if j != n-i
    nop                           # Branch delay slot
    nop
    nop

    addi $t0, $t0, 1              # i++
    nop
    nop
    bne $t0, $s1, outer_loop      # Continue outer loop if i != n-1
    nop                           # Branch delay slot
    nop
    nop

# Print sorted array
print_loop:
    li $t0, 0                     # Reset i for print loop
    nop
    nop
    add $t2, $zero, $s0           # Reset iterator address for print loop
    nop
    nop

print_loop_body:
    lw $a0, 0($t2)                # Load current element into $a0
    nop                           # Delay for load-use hazard
    nop
    nop
    li $v0, 1                     # Syscall to print integer
    syscall
    nop                           # Ensure syscall completion
    nop
    nop
    la $a0, space                 # Load space character into $a0
    nop
    nop
    li $v0, 4                     # Syscall to print string
    syscall
    nop
    nop

    addi $t2, $t2, 4              # Increment address iterator
    nop
    nop
    addi $t0, $t0, 1              # Increment loop counter
    nop
    nop
    bne $t0, $s1, print_loop_body # Continue if i != n
    nop                           # Branch delay slot
    nop
    nop

# Print newline
    la $a0, newline               # Load newline character into $a0
    nop
    nop
    li $v0, 4                     # Syscall to print string
    syscall
    nop
    nop

exit:
    li $v0, 10                    # Exit syscall
    syscall
    halt                          # Explicit stop for simulators requiring "halt"
