#
# Topological sort using an adjacency matrix. Maximum 4 nodes.
# 
# The expected output of this program is that the 1st 4 addresses of the data segment
# are [4,0,3,2]. should take ~2000 cycles in a single cycle procesor.
#

.data
res:
	.word -1-1-1-1
nodes:
        .byte   97 # a
        .byte   98 # b
        .byte   99 # c
        .byte   100 # d
adjacencymatrix:
        .word   6
        .word   0
        .word   0
        .word   3
visited:
	.byte 0 0 0 0
res_idx:
        .word   3
.text
	# li $sp, 0x10011000

        lui $1, 0x1001
        nop
        nop
        ori $sp, $1, 0x1000


	li $fp, 0
        # addiu $fp, $0, 0

	
        
        # la $ra pump
        # nop
        lui $1, 64 
        nop
        nop
        ori $ra, $1, 44

	j main # jump to the starting location
        nop

pump:
	halt


main:
        addiu   $sp,$sp,-40 # MAIN
        nop
        nop
        sw      $31,36($sp)
        sw      $fp,32($sp)
        add    	$fp,$sp,$zero
        nop
        nop
        sw      $0,24($fp)
        j       main_loop_control
        nop

main_loop_body:
        lw      $4,24($fp)
        # la 	$ra, trucks
        # j     is_visited
        nop
        nop
        nop
        jal     is_visited
        nop

        trucks:

        xori    $2,$2,0x1
        nop
        nop
        andi    $2,$2,0x00ff
        nop
        nop
        beq     $2,$0,kick
        nop
        nop

        lw      $4,24($fp)
        # addi 	$k0, $k0,1# breakpoint

        # la 	$ra, billowy
        # j     	topsort
        nop
        nop
        nop
        jal     topsort
        nop
        billowy:

kick:
        lw      $2,24($fp)
        nop
        nop
        addiu   $2,$2,1
        nop
        nop
        sw      $2,24($fp)
        nop
        nop

main_loop_control:
        nop
        lw      $2,24($fp)
        nop
        nop
        slti     $2,$2, 4
        nop
        nop
        beq	$2, $zero, hew # beq, j to simulate bne
        nop
        nop 
        j       main_loop_body
        nop

hew:
        sw      $0,28($fp)
        j       welcome
        nop

wave:
        lw      $2,28($fp)
        nop
        nop
        addiu   $2,$2,1
        nop
        nop
        sw      $2,28($fp)
welcome:
        lw      $2,28($fp)
        nop
        nop
        slti    $2,$2,4
        nop
        nop
        xori	$2,$2,1 # xori 1, beq to simulate bne where val in [0,1]
        nop
        nop
        beq     $2,$0,wave
        nop
        nop

        move    $2,$0
        move    $sp,$fp
        nop
        nop
        lw      $31,36($sp)
        lw      $fp,32($sp)
        addiu   $sp,$sp,40
        jr       $ra
        nop
        nop
        
interest:
        lw      $4,24($fp)
        # la	$ra, new
        # j	is_visited
        nop
        nop
        nop
        jal     is_visited
        nop

	new:
        xori    $2,$2,0x1
        nop
        nop
        andi    $2,$2,0x00ff
        nop
        nop
        beq     $2,$0,tasteful
        nop
        nop

        lw      $4,24($fp)
        # la	$ra, partner
        # j     	topsort
        nop
        nop
        nop
        jal     topsort
        nop

        partner:

tasteful:
        addiu   $2,$fp,28
        nop
        nop
        move    $4,$2
        # la	$ra, badge
        # j     next_edge
        nop
        nop
        nop
        jal     next_edge
        nop

        badge:
        sw      $2,24($fp)
        
turkey:
        lw      $3,24($fp)
        li      $2,-1
        nop
        nop
        beq	$3,$2,telling # beq, j to simulate bne
        nop
        nop
        j	interest
        nop

        telling:
	la 	$v0, res_idx
        nop
        nop
	lw	$v0, 0($v0)
        nop
        nop
        addiu   $4,$2,-1
        la 	$3, res_idx
        lui     $3, 4097
        nop
        nop
        nop
        sw 	$4, 0($3)
        la	$4, res
        lui     $4, 4097

        #lui     $3,%hi(res_idx)
        #sw      $4,%lo(res_idx)($3)
        #lui     $4,%hi(res)
        sll     $3,$2,2
        nop
        nop
        srl	$3,$3,1
        nop
        nop
        sra	$3,$3,1
        nop
        nop
        sll     $3,$3,2

       
       	xor	$at, $ra, $2 # does nothing 
        nor	$at, $ra, $2 # does nothing 
        
        # la	$2, res
        lui $1, 4097
        nop
        nop
        ori $2, $1, 0
        nop
        nop
        andi	$at, $2, 0xffff # -1 will sign extend (according to assembler), but 0xffff won't
        nop
        nop
        addu 	$2, $4, $at
        nop
        nop
        addu    $2,$3,$2
        lw      $3,48($fp)
        nop
        nop
        sw      $3,0($2)
        move    $sp,$fp
        nop
        nop
        lw      $31,44($sp)
        lw      $fp,40($sp)
        addiu   $sp,$sp,48
        jr      $ra
        nop
        nop
   
topsort:
        addiu   $sp,$sp,-48
        nop
        nop
        sw      $31,44($sp)
        sw      $fp,40($sp)
        move    $fp,$sp
        nop
        nop
        sw      $4,48($fp)
        lw      $4,48($fp)
        # la	$ra, verse
        # j	mark_visited
        nop
        nop
        nop
        jal     mark_visited
        nop

        verse:

        addiu   $2,$fp,28
        lw      $5,48($fp)
        nop
        move    $4,$2
        # la 	$ra, joyous
        # j	iterate_edges
        nop
        nop
        nop
        jal     iterate_edges
        nop
        joyous:

        addiu   $2,$fp,28
        nop
        nop
        move    $4,$2
        # la	$ra, whispering
        # j     	next_edge
        nop
        nop
        nop
        jal     next_edge
        nop

        whispering:

        sw      $2,24($fp)
        j       turkey
        nop

iterate_edges:
        addiu   $sp,$sp,-24
        nop
        nop
        sw      $fp,20($sp)
        move    $fp,$sp
        nop
        nop
        subu	$at, $fp, $sp
        nop
        nop
        sw      $4,24($fp)
        sw      $5,28($fp)
        lw      $2,28($fp)
        nop
        nop
        nop
        sw      $2,8($fp)
        sw      $0,12($fp)
        lw      $2,24($fp)
        lw      $4,8($fp)
        lw      $3,12($fp)
        nop
        nop
        sw      $4,0($2)
        sw      $3,4($2)
        lw      $2,24($fp)
        move    $sp,$fp
        nop
        nop
        lw      $fp,20($sp)
        addiu   $sp,$sp,24
        jr      $ra
        nop
        nop
        
next_edge:
        addiu   $sp,$sp,-32
        nop
        nop
        sw      $31,28($sp)
        sw      $fp,24($sp)
        add	$fp,$zero,$sp
        nop
        nop
        sw      $4,32($fp)
        j       waggish
        nop

snail:
        lw      $2,32($fp)
        nop
        nop
        lw      $3,0($2)
        lw      $2,32($fp)
        nop
        nop
        lw      $2,4($2)
        nop
        nop
        move    $5,$2
        move    $4,$3
        # la	$ra,induce
        # j       has_edge
        nop
        nop
        nop
        jal      has_edge
        nop

        induce:
        beq     $2,$0,quarter
        nop
        nop
        lw      $2,32($fp)
        nop
        nop
        lw      $2,4($2)
        nop
        nop
        addiu   $4,$2,1
        lw      $3,32($fp)
        nop
        nop
        sw      $4,4($3)
        j       cynical
        nop



quarter:
        lw      $2,32($fp)
        nop
        nop
        lw      $2,4($2)
        nop
        nop
        addiu   $3,$2,1
        nop
        lw      $2,32($fp)
        nop
        nop
        sw      $3,4($2)

waggish:
        lw      $2,32($fp)
        nop
        nop
        lw      $2,4($2)
        nop
        nop
        slti    $2,$2,4
        nop
        nop
        beq	$2,$zero,mark # beq, j to simulate bne 
        nop
        nop
        j	snail
        nop

        mark:
        li      $2,-1

cynical:
        move    $sp,$fp
        nop
        nop
        lw      $31,28($sp)
        lw      $fp,24($sp)
        addiu   $sp,$sp,32
        jr      $ra
        nop
        nop

has_edge:
        addiu   $sp,$sp,-32
        nop
        nop
        sw      $fp,28($sp)
        move    $fp,$sp
        nop
        nop
        sw      $4,32($fp)
        sw      $5,36($fp)
        # la      $2,adjacencymatrix
        lui     $1, 4097
        nop
        nop
        ori     $2, $1, 20
        lw      $3,32($fp)
        nop
        nop
        sll     $3,$3,2
        nop
        nop
        addu    $2,$3,$2
        nop
        nop
        lw      $2,0($2)
        nop
        nop
        sw      $2,16($fp)
        nop
        nop
        li      $2,1
        nop
        nop
        sw      $2,8($fp)
        sw      $0,12($fp)
        j       measley
        nop

look:
        lw      $2,8($fp)
        nop
        nop
        sll     $2,$2,1
        nop
        nop
        sw      $2,8($fp)
        lw      $2,12($fp)
        nop
        nop
        addiu   $2,$2,1
        nop
        nop
        sw      $2,12($fp)
measley:
        lw      $3,12($fp)
        lw      $2,36($fp)
        nop
        nop
        slt     $2,$3,$2
        nop
        nop
        beq     $2,$0,experience # beq, j to simulate bne 
        nop
        nop
        j 	look
        nop

       	experience:
        lw      $3,8($fp)
        lw      $2,16($fp)
        nop
        nop
        and     $2,$3,$2
        nop
        nop
        slt     $2,$0,$2
        nop
        nop
        andi    $2,$2,0x00ff
        move    $sp,$fp
        nop
        nop
        lw      $fp,28($sp)
        addiu   $sp,$sp,32
        jr      $ra
        nop
        nop
        
mark_visited:
        addiu   $sp,$sp,-32
        nop
        nop
        sw      $fp,28($sp)
        move    $fp,$sp
        nop
        nop
        sw      $4,32($fp)
        li      $2,1
        nop
        nop
        sw      $2,8($fp)
        sw      $0,12($fp)
        j       recast
        nop

example:
        lw      $2,8($fp)
        nop
        nop
        sll     $2,$2,8
        nop
        nop
        sw      $2,8($fp)
        lw      $2,12($fp)
        nop
        nop
        addiu   $2,$2,1
        nop
        nop
        sw      $2,12($fp)
recast:
        lw      $3,12($fp)
        lw      $2,32($fp)
        nop
        nop
        slt     $2,$3,$2
        nop
        nop
        beq	$2,$zero,pat # beq, j to simulate bne
        nop
        nop
        j	example
        nop

        pat:

       	la	$2, visited
        nop
        nop
        sw      $2,16($fp)
        lw      $2,16($fp)
        nop
        nop
        lw      $3,0($2)
        lw      $2,8($fp)
        nop
        nop
        or      $3,$3,$2
        nop
        lw      $2,16($fp)
        nop
        nop
        sw      $3,0($2)
        move    $sp,$fp
        nop
        nop
        lw      $fp,28($sp)
        addiu   $sp,$sp,32
        jr      $ra
        nop
        nop

is_visited:
        addiu   $sp,$sp,-32
        nop
        nop
        sw      $fp,28($sp)
        move    $fp,$sp
        nop
        nop
        sw      $4,32($fp)
        ori     $2,$zero,1
        nop
        nop
        sw      $2,8($fp)
        sw      $0,12($fp)
        j       evasive
        nop

justify:
        lw      $2,8($fp)
        nop
        nop
        sll     $2,$2,8
        nop
        nop
        sw      $2,8($fp)
        nop
        nop
        lw      $2,12($fp)
        nop
        nop
        addiu   $2,$2,1
        nop
        nop
        sw      $2,12($fp)

evasive:
        nop
        lw      $3,12($fp)
        lw      $2,32($fp)
        nop
        nop
        slt     $2,$3,$2
        nop
        nop
        beq	$2,$0,representitive # beq, j to simulate bne
        nop
        nop
        j     	justify
        nop

        representitive:

        # la	$2,visited
        lui     $1, 4097
        nop
        nop
        ori $2, $1, 36
        nop
        nop
        lw      $2,0($2)
        nop
        nop
        sw      $2,16($fp)
        lw      $3,16($fp)
        lw      $2,8($fp)
        nop
        nop
        and     $2,$3,$2
        nop
        nop
        slt     $2,$0,$2
        nop
        nop
        andi    $2,$2,0x00ff
        move    $sp,$fp
        nop
        nop
        lw      $fp,28($sp)
        nop
        nop
        addiu   $sp,$sp,32
        nop
        jr      $ra
        nop
        nop