#
#	/boot/x86/boot.s
#
#	512 Byte Master Boot Record
# 
#	Author: Yujie REN
#	Date:	2017.8
#
#   read loader.s to 0x07e0:0x0000
#   jump to kernel loader
#

.code16
.text

begin:
.globl _start

.set ZEROSEG, 0x0000
.set BOOTSEG, 0x07c0
.set LOADSEG, 0x07e0

	jmp $BOOTSEG, $_start

_start:
	movw 	%cs, %ax
	movw 	%ax, %ds
	movw 	%ax, %es
	movw 	%ax, %ss
	#movw	$0x500, %sp

	movw 	$msg1, %bp
	movw 	$0x0011, %cx
	movw 	$0x1301, %ax
	movw 	$0x000f, %bx
	movw	$0x0900, %dx
	int		$0x10

	# reset floppy drive
reset:
	xorw	%ax, %ax
	movb	$0x0, %dl
	int		$0x13
	jc		reset
	
	# read the second sector .aka load.s to 0x07e0:0x0000
	pushw	%es
read:
	movw	$LOADSEG, %ax
	movw	%ax, %es
	xorw	%bx, %bx
	movb	$0x02, %ah
	movb	$0x01, %al
	xorb	%ch, %ch
	movb	$0x02, %cl
	xorw	%dx, %dx
	movb	$0x80, %dl
	int		$0x13
	jc		read
	popw	%es

	movw 	$msg2, %bp
	movw 	$0x0014, %cx
	movw 	$0x1301, %ax
	movw 	$0x0007, %bx
	movw	$0x0a00, %dx
	int		$0x10
go:
	jmp	$ZEROSEG, $0x7e00

msg1:
	.ascii "boot sector found"

msg2:
	.ascii "read loader complete"

fill:	
	.fill	(510-(.-begin)), 1, 0

signature:
	.byte	0x55, 0xaa
