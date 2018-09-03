#
#	/boot/x86/entry.s
#
#	Kernel Entry
# 
#	Author: Yujie REN
#	Date:	2017.8
#
#   Setting up GDT, IDT
#	Setting up Stack
#   Setting up early stage Paging
#	Entering kernel main

.code32

# .data contains important data structure for the kernel
.section .data
	.globl _gdt, _idt

	.align 64
msg:
	.ascii "Entering protected mode..."
	.byte 0

_gdt:
	.quad 0x0000000000000000				# NULL descriptor
	.quad 0x00c09a00000007ff				# Kernel code
	.quad 0x00c09200000007ff				# Kernel data
	.quad 0x0000000000000000				# Temporary
	.fill 252,8,0							# Reserved for LDT and TSS

_idt:
	.fill 256,8,0							# idt is uninitialized

gdt_descr:
	.word 256*8-1							# gdt contains 32 entries with each 8 Byte 
	.long _gdt

idt_descr:
	.word 256*8-1							# idt contains 32 entries with each 8 Byte
	.long _idt


# .bss contains data initialised to zeroes when the kernel is loaded
.section .bss
	# Our C code will need a stack to run. Here, we allocate 4096 bytes (or 4 Kilobytes) for our stack.
	# We can expand this later if we want a larger stack. For now, it will be perfectly adequate.
	.align 16
#stack_bottom:
#	.skip 0x1000	# Reserve a 4096-byte (4K) stack
#stack_top:

# .text contains actual kernel codes
.section .text

begin:
.extern kernel_main
.globl _start

.set CODE_SELECTOR,  0x08
.set DATA_SELECTOR,  0x10
.set DISPLAY_ADDR,   0xb8000

.set _k_pg_dir, 0x130000
.set _k_pt_0,   0x131000
.set _k_pt_1,   0x132000
.set _k_pt_2,   0x210000

_start:
	movw	$DATA_SELECTOR, %ax
	movw	%ax, %ds
	movw	%ax, %es
	movw	%ax, %gs
	movw	%ax, %ss

	movw	$0x3D4, %dx       # Tell the control I/O port to get the higher byte of
	movb	$0x0E, %al        # the cursor offset
	out		%al, %dx
	movw	$0x3D5, %dx       # Switch to data I/O port
	in		%dx, %al          # Get the cursor offset's higher byte
	movb	%al, %ah

	movw	$0x3D4, %dx       # Tell the control I/O port to get the lower byte of
	movb	$0x0F, %al        # the cursor offset
	out		%al, %dx
	movw	$0x3D5, %dx       # Switch to data I/O port
	in		%dx, %al          # Get the lower byte

	imul	$2, %ax

	movl	$DISPLAY_ADDR, %ebx
	addw	%ax, %bx
	movl	$msg, %esi
	xorw    %cx, %cx

disp:
	lodsb
	cmpb	$0x00, %al
	je		end_disp
	movw	%cx, %di
	movb	%al, (%ebx, %edi, 1)
	inc		%cx
	movb	$0x0f, (%ebx, %ecx, 1)
	inc		%cx
	jmp		disp

end_disp:
	#jmp		.

# Setup Global Descriptor Table
	lgdt	gdt_descr

# Enable Paging and Setup 12MB memory for provisional kernel
	movl	$_k_pt_0+7, _k_pg_dir			# set present bit/user r/w
	movl	$_k_pt_1+7, _k_pg_dir+4

	movl	$_k_pt_0+7, _k_pg_dir+0xc00		# set present bit/user r/w
	movl	$_k_pt_1+7, _k_pg_dir+0xc04
	movl	$_k_pt_2+7, _k_pg_dir+0xf7c

	movl	$_k_pt_1+4092, %edi
	movl	$0x7ff007, %eax					# 8Mb - 4096 + 7 (r/w user,p)
	std
1:	stosl									# fill pages table entries
	subl	$0x1000, %eax
	jge		1b

	movl	$_k_pt_2+4092, %edi
	movl	$0x7fff007, %eax
	std
2:	stosl									# fill pages table entries
	subl	$0x1000, %eax
	cmpl	$0x7c00007, %eax
	jne		2b

	movl	$_k_pg_dir, %eax
	movl	%eax, %cr3						# cr3 - page directory start
	movl	%cr0, %eax
	orl		$0x80000000, %eax
	movl	%eax,%cr0						# set paging (PG) bit */

# Setup Kernel Stack
	mov		(_k_stack_top), %esp # Set the stack pointer to the top of the stack

# Now jump to C-written environment and be ready to run the rest of our kernel.
	call kernel_main

# If, by some mysterious circumstances, the kernel's C code ever returns, all we want to do is to hang the CPU
hang:
	cli      # Disable CPU interrupts
	hlt      # Halt the CPU
	jmp hang # If that didn't work, loop around and try again.

# Should never be here

