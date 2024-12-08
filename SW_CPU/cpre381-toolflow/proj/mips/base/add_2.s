.data
.text
.globl main
main:
    # Start Test
    addi $1, $0, 1     # load 1 into $1 to initialize a value for the test
    nop
    nop
    nop
# the tests below are used to see if the registers will properly multiply by 2 and if they can ultimately store the max value
# this is storing the powers of 2 in the registers
    add $1, $1, $1     # $1 = 1 + 1 --> should be 2
    nop
    nop
    nop
    add $2, $1, $1     # $2 = 2 + 2 --> should be 4                     
    nop
    nop
    nop
    add $3, $2, $2     # $3 = 4 + 4 --> should be 8   
    nop
    nop
    nop
    add $4, $3, $3     # $4 = 8 + 8 --> should be 16   
    nop
    nop
    nop
    add $5, $4, $4     # $5 = 16 + 16 --> should be 32   
    nop
    nop
    nop
    add $6, $5, $5     # $6 = 32 + 32 --> should be 64  
    nop
    nop
    nop
    add $7, $6, $6     # $7 = 64 + 64 --> should be 128   
    nop
    nop
    nop
    add $8, $7, $7     # $8 = 128 + 128 --> should be 256   
    nop
    nop
    nop
    add $9, $8, $8     # $9 = 256 + 256 --> should be 512   
    nop
    nop
    nop
    add $10, $9, $9     # $10 = 512 + 512 --> should be 1024   
    nop
    nop
    nop
    add $11, $10, $10     # $11 = 1024 + 1024 --> should be 2048   
    nop
    nop
    nop
    add $12, $11, $11     # $12 = 2048 + 2048 --> should be 4096  
    nop
    nop
    nop
    add $13, $12, $12     # $13 = 4096 + 4096 --> should be 8192 
    nop
    nop
    nop
    add $14, $13, $13     # $14 = 8192 + 8192 --> should be 16384
    nop
    nop
    nop
    add $15, $14, $14     # $15 = 16384 + 16384 --> should be 32768   
    nop
    nop
    nop
    add $16, $15, $15     # $16 = 32768 + 32768 --> should be 65536  
    nop
    nop
    nop
    add $17, $16, $16     # $17 = 65536 + 65536 --> should be 131072   
    nop
    nop
    nop
    add $18, $17, $17     # $18 = 131072 + 131072 --> should be 262144  
    nop
    nop
    nop
    add $19, $18, $18     # $19 = 262144 + 262144 --> should be 524288  
    nop
    nop
    nop
    add $20, $19, $19     # $20 = 524288 + 524288 --> should be 1048576 
    nop
    nop
    nop 
    add $21, $20, $20     # $21 = 1048576 * 2 --> should be 2097152 
    nop
    nop
    nop
    add $22, $21, $21     # $22 = 2097152 * 2 --> should be 4194304   
    nop
    nop
    nop
    add $23, $22, $22     # $23 = 4194304 * 2 --> should be 8388608  
    nop
    nop
    nop
    add $24, $23, $23     # $24 = 8388608 * 2 --> should be 16777216  
    nop
    nop
    nop
    add $25, $24, $24     # $25 = 16777216 * 2 --> should be 33554432   
    nop
    nop
    nop
    add $26, $25, $25     # $26 = 33554432 * 2 --> should be 67108864   
    nop
    nop
    nop
    add $27, $26, $26     # $27 = 67108864 * 2 --> should be 134217782  
    nop
    nop
    nop 
    add $28, $27, $27     # $28 = 134217782 * 2 --> should be 536870912
    nop
    nop
    nop
    add $29, $28, $28     # $29 = 536870912 * 2 --> should be 1.07e9
    nop
    nop
    nop
    add $30, $29, $29     # $30 = 1.07e9 * 2 --> should be 2.15e9   
    nop
    nop
    nop
    add $31, $30, $30     # $31 = 2.15e9 * 2 --> should be 4.29e9 
# this will also test the maximum possible value that can be stored in the ALU (2^32)   
    # End Test

    # Exit program
    halt