
#include "..\include\basic.h"
#include "..\include\kernel.h"

asm _DATA ends

asm _TEXT segment byte public 'CODE'
/* code, data and stack segment is the same, so the assembler will use
the same offset to calculate the address of the symbol */
asm .MODEL TINY
/* Enable extend register and some other instructions */
asm .486

/* The first few instructions must lead to the entry point */
/* First disable interrupt and set the stack to be the same segment as the code & data */
asm cli
asm mov si, cs
asm mov es, si
asm mov ds, si
asm mov si, 0B800h
asm mov fs, si
asm mov si, SYS_STACK_SEG
asm mov ss, si
asm mov sp, 0FFFEh


asm sti
/* Test large memory access */
asm mov ebx, 01234567h
asm mov eax, [ebx]
asm push ds
asm jmp _main

asm assume ds:_TEXT, cs:_TEXT, es:nothing

/* Data goes here, since we want to combine data and code into one segment */
/* All data must be initialized. Unintialized data will go into BSS */

char digit_table[] = "0123456789ABCDEF";
char equal_16[] = "================";
char large_mem_ok[] = "Test extended memory...OK!\n";

/* The pointer for next available system static memory
Moved by various initialization routines */
unsigned char far *sys_mem_avail = SYS_DATA_PTR;

asm _TEXT ends
asm _DATA segment word public 'DATA'

void main()
{
    int i;
    int ret;
    char buffer[24];
    unsigned char temp;
    /* 80 * 25, video memory = B800:0000 */
    InitVideo(0x02);
    PutString(large_mem_ok);
    ret = PrintAllMemory();
    if(ret == -1)
    {
        PutString("Memory Detect Fail");
        while(1);
    }
    /* At most 256 slot */
    InitMemoryTable(256);
    /* FatalError("This is a fatal error"); */
    InitProcessTable(32);
    InitSystemCall();
    InitRealTimeClock();
    while(1);
}

