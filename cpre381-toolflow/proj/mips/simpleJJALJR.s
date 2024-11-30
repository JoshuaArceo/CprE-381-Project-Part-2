main:
	ori $s0, $zero 0x1234
	ori $s1 $zero 0x1234
    nop
    nop
    nop
	jal fun
    nop
    nop
	ori $s3 $zero 0x1234
	
	beq $s0, $zero exit
    nop
    nop
	ori $s4 $zero 0x1234
	j exit
    nop

fun:
	ori $s2 $zero 0x1234
	jr $ra
    nop
    nop
exit:
	halt

