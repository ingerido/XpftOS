	.file	"kernel.c"
	.globl	vga_buffer
	.data
	.align 4
	.type	vga_buffer, @object
	.size	vga_buffer, 4
vga_buffer:
	.long	753664
	.globl	VGA_COLS
	.section	.rodata
	.align 4
	.type	VGA_COLS, @object
	.size	VGA_COLS, 4
VGA_COLS:
	.long	80
	.globl	VGA_ROWS
	.align 4
	.type	VGA_ROWS, @object
	.size	VGA_ROWS, 4
VGA_ROWS:
	.long	25
	.globl	term_col
	.section	.bss
	.align 4
	.type	term_col, @object
	.size	term_col, 4
term_col:
	.zero	4
	.globl	term_row
	.align 4
	.type	term_row, @object
	.size	term_row, 4
term_row:
	.zero	4
	.globl	term_color
	.data
	.type	term_color, @object
	.size	term_color, 1
term_color:
	.byte	15
	.text
	.globl	term_init
	.type	term_init, @function
term_init:
.LFB0:
	.cfi_startproc
	pushl	%ebp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	movl	%esp, %ebp
	.cfi_def_cfa_register 5
	subl	$16, %esp
	movl	$0, -4(%ebp)
	jmp	.L2
.L5:
	movl	$0, -8(%ebp)
	jmp	.L3
.L4:
	movl	$80, %eax
	imull	-8(%ebp), %eax
	movl	%eax, %edx
	movl	-4(%ebp), %eax
	addl	%edx, %eax
	movl	%eax, -12(%ebp)
	movl	vga_buffer, %eax
	movl	-12(%ebp), %edx
	addl	%edx, %edx
	addl	%edx, %eax
	movzbl	term_color, %edx
	movzbl	%dl, %edx
	sall	$8, %edx
	orl	$32, %edx
	movw	%dx, (%eax)
	addl	$1, -8(%ebp)
.L3:
	movl	$25, %eax
	cmpl	%eax, -8(%ebp)
	jl	.L4
	addl	$1, -4(%ebp)
.L2:
	movl	$80, %eax
	cmpl	%eax, -4(%ebp)
	jl	.L5
	leave
	.cfi_restore 5
	.cfi_def_cfa 4, 4
	ret
	.cfi_endproc
.LFE0:
	.size	term_init, .-term_init
	.globl	term_putc
	.type	term_putc, @function
term_putc:
.LFB1:
	.cfi_startproc
	pushl	%ebp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	movl	%esp, %ebp
	.cfi_def_cfa_register 5
	subl	$20, %esp
	movl	8(%ebp), %eax
	movb	%al, -20(%ebp)
	movsbl	-20(%ebp), %eax
	cmpl	$10, %eax
	jne	.L12
	movl	$0, term_col
	movl	term_row, %eax
	addl	$1, %eax
	movl	%eax, term_row
	jmp	.L9
.L12:
	movl	$80, %edx
	movl	term_row, %eax
	imull	%eax, %edx
	movl	term_col, %eax
	addl	%edx, %eax
	movl	%eax, -4(%ebp)
	movl	vga_buffer, %eax
	movl	-4(%ebp), %edx
	addl	%edx, %edx
	addl	%edx, %eax
	movzbl	term_color, %edx
	movzbl	%dl, %edx
	sall	$8, %edx
	movl	%edx, %ecx
	movsbw	-20(%ebp), %dx
	orl	%ecx, %edx
	movw	%dx, (%eax)
	movl	term_col, %eax
	addl	$1, %eax
	movl	%eax, term_col
	nop
.L9:
	movl	term_col, %eax
	movl	$80, %edx
	cmpl	%edx, %eax
	jl	.L10
	movl	$0, term_col
	movl	term_row, %eax
	addl	$1, %eax
	movl	%eax, term_row
.L10:
	movl	term_row, %eax
	movl	$25, %edx
	cmpl	%edx, %eax
	jl	.L6
	movl	$0, term_col
	movl	$0, term_row
.L6:
	leave
	.cfi_restore 5
	.cfi_def_cfa 4, 4
	ret
	.cfi_endproc
.LFE1:
	.size	term_putc, .-term_putc
	.globl	term_print
	.type	term_print, @function
term_print:
.LFB2:
	.cfi_startproc
	pushl	%ebp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	movl	%esp, %ebp
	.cfi_def_cfa_register 5
	subl	$16, %esp
	movl	$0, -4(%ebp)
	jmp	.L14
.L15:
	movl	8(%ebp), %edx
	movl	-4(%ebp), %eax
	addl	%edx, %eax
	movzbl	(%eax), %eax
	movsbl	%al, %eax
	pushl	%eax
	call	term_putc
	addl	$4, %esp
	addl	$1, -4(%ebp)
.L14:
	movl	8(%ebp), %edx
	movl	-4(%ebp), %eax
	addl	%edx, %eax
	movzbl	(%eax), %eax
	testb	%al, %al
	jne	.L15
	leave
	.cfi_restore 5
	.cfi_def_cfa 4, 4
	ret
	.cfi_endproc
.LFE2:
	.size	term_print, .-term_print
	.globl	why
	.type	why, @function
why:
.LFB3:
	.cfi_startproc
	pushl	%ebp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	movl	%esp, %ebp
	.cfi_def_cfa_register 5
	subl	$4, %esp
	movl	8(%ebp), %eax
	movb	%al, -4(%ebp)
	movl	vga_buffer, %eax
	movzbl	term_color, %edx
	movzbl	%dl, %edx
	sall	$8, %edx
	movl	%edx, %ecx
	movsbw	-4(%ebp), %dx
	orl	%ecx, %edx
	movw	%dx, (%eax)
	leave
	.cfi_restore 5
	.cfi_def_cfa 4, 4
	ret
	.cfi_endproc
.LFE3:
	.size	why, .-why
	.globl	kernel_main
	.type	kernel_main, @function
kernel_main:
.LFB4:
	.cfi_startproc
	pushl	%ebp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	movl	%esp, %ebp
	.cfi_def_cfa_register 5
	subl	$16, %esp
	movb	$83, -1(%ebp)
	movsbl	-1(%ebp), %eax
	pushl	%eax
	call	why
	addl	$4, %esp
	leave
	.cfi_restore 5
	.cfi_def_cfa 4, 4
	ret
	.cfi_endproc
.LFE4:
	.size	kernel_main, .-kernel_main
	.ident	"GCC: (GNU) 4.9.4"
