#
#	Load 32 Kernel
# 
#	Author: Yujie REN
#	Date:	2017.8
#
#   Setting up GDT, IDT
#	Setting up Stack
#   Setting up early stage Paging
#	Copy The rest of Kernel Image

.code32

# This section contains data initialised to zeroes when the kernel is loaded
.section .bss
	# Our C code will need a stack to run. Here, we allocate 4096 bytes (or 4 Kilobytes) for our stack.
	# We can expand this later if we want a larger stack. For now, it will be perfectly adequate.
	.align 16
stack_bottom:
	.skip 4096	# Reserve a 4096-byte (4K) stack
stack_top:

.section .text

begin:
.extern kernel_main
.globl start, _gdt, _idt

.set CODE_SELECTOR,  0x08
.set DATA_SELECTOR,  0x10
.set STACK_SELECTOR, 0X18
.set DISPLAY_ADDR,  0xb8000

_pg_dir:

start:
	movw	$DATA_SELECTOR, %ax
	movw	%ax, %ds
	movw	%ax, %es
	movw	%ax, %gs
	movw	$STACK_SELECTOR, %ax
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

# First thing's first: we want to set up an environment that's ready to run C code.
# C is very relaxed in its requirements: All we need to do is to set up the stack.
# Please note that on x86, the stack grows DOWNWARD. This is why we start at the top.
	mov $stack_top, %esp # Set the stack pointer to the top of the stack

	#jmp	.

# Now we have a C-worthy (haha!) environment ready to run the rest of our kernel.
# At this point, we can call our main C function.
	call kernel_main

# If, by some mysterious circumstances, the kernel's C code ever returns, all we want to do is to hang the CPU
hang:
	cli      # Disable CPU interrupts
	hlt      # Halt the CPU
	jmp hang # If that didn't work, loop around and try again.


msg:
	.ascii "Welcome to protected mode"
	.byte 0

	.fill	(512-(.-begin)), 1, 0

