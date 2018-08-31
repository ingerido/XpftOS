ENTRY(_start)
 
SECTIONS
{

	. = 1M;

	/* Executable code */
	.text BLOCK(4K) : ALIGN(4K)
	{
		*(.text)
	}
 
	/* Read-write data (initialized) */
	.data BLOCK(4K) : ALIGN(4K)
	{
		*(.data)
	}
 
	/* Read-write data (uninitialized) and stack */
	.bss BLOCK(4K) : ALIGN(4K)
	{
		*(.bss)
	}
}
