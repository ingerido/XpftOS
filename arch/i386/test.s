#
#	/arch/i386/test.s
#
#   For test purpose	
#

.code16
.text

begin:

_test:
	movw 	%cs, %ax
	movw 	%ax, %ds
	movw 	%ax, %es
	movw 	%ax, %ss	

	movw 	$msg1, %bp
	movw 	$0x0007, %cx
	movw 	$0x1301, %ax
	movw 	$0x0007, %bx
	movw	$0x1100, %dx
	int		$0x10

	jmp		.

msg1:
	.ascii "test..."

fill:	
	.fill	(512-(.-begin)), 1, 0
