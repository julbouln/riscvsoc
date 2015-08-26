MEMORY
{
     ROM ( rx ) : ORIGIN = 0x00800054 , LENGTH = 32K
     RAM ( xrw) : ORIGIN = 0x10000000 , LENGTH = 16K
}


SECTIONS
{
.text : { 
*(.text*)
*(.sdata*)
*(.data*)
*(.rodata*)
*(.bss*) 
 } >ROM
/* data segmemt */

/* End of uninitalized data segement */
end = .;
}
