main:
	ori $s0, $zero 0x1234
	ori $s1 $zero 0x1235
	jal fun
	ori $s3 $zero 0x1236
	
	beq $s0, $zero exit
	ori $s4 $zero 0x1237
	j exit

fun:
	ori $s2 $zero 0x1238
	jr $ra
exit:
	halt

