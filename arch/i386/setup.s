#
#	/arch/i386/setup.s
#
#	Author: Yujie REN
#	Date:	2017.8
#
#	probe physical memory layout
#	load kImage to 1MB phy addr
#	now the kImage is limited to 32KB
#	initialize environment
#	enter protected mode
#	jump to kernel entry: entry.s
#

.code16
.text

begin:
.globl _start

.set BUFSEG, 0x1000
.set IMGSEG, 0xffff

.set STACK_POINTER,   0x8800
.set MEM_MAP_OFFSET,  0x9000
.set KERNEL_P_OFFSET, 0x100000

.set CODE_SELECTOR, 0x08
.set DATA_SELECTOR, 0x10

_start:
	movw 	%cs, %ax
	movw 	%ax, %ds
	movw 	%ax, %es
	movw 	%ax, %ss

	# set stack pointer at a safer place
	movw	$STACK_POINTER, %sp 

	# check if A20 Line is enabled
	call	check_a20
	cmpw	$0x0, %ax
	jne		start_e820

enable_a20:
	pushw	%ax
	in		$0x92, %al
	and		$0xfd, %al
	out		%al, $0x92
	popw	%ax

start_e820:
	# BIOS INT 15h AX=E820h
	# Get physical memory layout
	pushw	%di
	pushw	%bp
	movw	$MEM_MAP_OFFSET, %di
	xorl	%ebx, %ebx

e820_loop:
	movl	$0x01, 20(%di)
	movl	$0xe820, %eax
	movl	$0x18, %ecx
	# SMAP
	movl	$0x534d4150, %edx
	int		$0x15
	jc		end_e820
	cmpl	$0x534d4150, %eax
	jne		fail_e820
e820_jmp:
	cmpw	$0x0, %cx
	je		e820_skip
	incw	%bp
	addw	$0x18, %di

e820_skip:
	testl	%ebx, %ebx
	jne		e820_loop

succ_e820:
	movw 	$s_msg, %bp
	movw 	$0x0007, %cx
	movw 	$0x1301, %ax
	movw 	$0x0007, %bx
	movw	$0x0d00, %dx
	int		$0x10
	# halt
	jmp		end_e820

fail_e820:
	movw 	$f_msg, %bp
	movw 	$0x0004, %cx
	movw 	$0x1301, %ax
	movw 	$0x0007, %bx
	movw	$0x0d00, %dx
	int		$0x10
	# halt
	jmp		.	

end_e820:
	popw	%bp
	popw	%di	

	# reset floppy drive
reset:
	xorw	%ax, %ax
	movb	$0x80, %dl
	int		$0x13
	jc		reset

	# read the kImage to buffer addr 0x10000
	pushw	%es
read:
	movw	$BUFSEG, %ax
	movw	%ax, %es
	xorw	%bx, %bx
	movb	$0x02, %ah
	movb	$0x09, %al
	xorb	%ch, %ch
	movb	$0x03, %cl
	xorw	%dx, %dx
	movb	$0x80, %dl
	int		$0x13
	jc		read
	popw	%es

	movw 	$msg3, %bp
	movw 	$0x0018, %cx
	movw 	$0x1301, %ax
	movw 	$0x0007, %bx
	movw	$0x0f00, %dx
	int		$0x10

	#jmp		.

	# move kImage from buffer to 0x100000
	pushw	%ds
	pushw	%es
	movw	$BUFSEG, %ax
	movw	%ax, %ds
	movw	$IMGSEG, %ax
	movw	%ax, %es
	xorw	%si, %si
	movw	$0x10, %di
	movw	$0x480, %cx			# movsl moves 4 bytes, so need 4608/4=1152 here
	rep
	movsl
	popw	%es
	popw	%ds

	#jmp		.
	#ljmp	$0xfff, $0x10

	# disable interrupt
	cli

	# preparing to enter protected mode
	lgdt	gdt_48				# load 48-bit gdt descriptor to GDTR
	lidt	idt_48				# load 48-bit idt descriptor to IDTR

	# now entering protected mode
	pusha
	movl	%cr0, %eax
	orl		$0x01, %eax
	movl	%eax, %cr0
	popa

	#jmp		.

go:
#	ljmp	$CODE_SELECTOR, $0x0000
#	ljmp	$CODE_SELECTOR, $0x100000
#
#	but we yet haven't reloaded the CS register, so the default size 
#	of the target offset still is 16 bit.
#	However, using an operand prefix (0x66), the CPU will properly
#	take our 48 bit far pointer. (INTeL 80386 Programmer's Reference
#	Manual, Mixing 16-bit and 32-bit code, page 16-6)

	.byte	0x66, 0xea
	.long	KERNEL_P_OFFSET		
	.word	CODE_SELECTOR


check_a20:
    pushf
    pushw %ds
    pushw %es
    pushw %di
    pushw %si
 
    cli
 
    xorw 	%ax, %ax
    movw	%ax, %es
    notw	%ax
    movw	%ax, %ds
 
    movw	$0x0500, %di
    movw	$0x0510, %si
 
    movb	%es:(%di), %al
    pushw	%ax
    movb	%ds:(%si), %al
    pushw 	%ax
 
    movb	$0x00, %es:(%di)
    movb	$0xff, %ds:(%si)
 
    cmpb	$0xff, %es:(%di)
 
    popw	%ax
    movb	%al, %ds:(%si)
    popw	%ax
    movb	%al, %ds:(%di)
 
    movw	$0x0, %ax
    je check_a20__exit
 
    movw	$0x1, %ax
 
check_a20__exit:
    popw	%si
    popw	%di
    popw	%es
    popw	%ds
    popf

	sti

    ret

gdt:
	.word	0,0,0,0				# dummy

	# Kernel Code Segment for entry.s
gdt_code:
	.word	0x07ff				# 8Mb - limit = 2047 (2048*4096 = 8Mb)
	.word	0x0000				# base address = 0x0000
	.word	0x9a00				# code read/exec
	.word	0x00c0				# granularity = 4096, 386

	# Kernel Data Segment for entry.s
gdt_data:
	.word	0x07ff				# 8Mb - limit = 2047 (2048*4096 = 8Mb)
	.word	0x0000				# base address = 0x0000
	.word	0x9200				# data read/write
	.word	0x00c0				# granularity = 4096, 386

gdt_48:
	.word	gdt_48 - gdt		# gdt limit = 2048, 256 GDT entries
	.word	gdt,0				# gdt base = 0x0000

idt_48:
	.word	0					# idt limit = 0
	.word	0,0					# idt base = 0L

f_msg:
	.ascii "fail"

s_msg:
	.ascii "success"

msg3:
	.ascii "loading kernel image"
	.byte	13,10,13,10

fill:	
	.fill	(512-(.-begin)), 1, 0
