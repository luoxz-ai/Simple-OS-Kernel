
#include "..\include\basic.h"
#include "..\include\kernel.h"

asm _DATA ends
asm _TEXT segment byte public 'CODE'

asm .MODEL TINY
asm .486
/* Default process is the kernel itself */
unsigned short last_error = 0x0000;

asm _TEXT ends
asm _DATA segment word public 'DATA'

void PrintRegisters()
{
    Printf("\n\nAX = %x BX = %x CX = %x DX = %x\nSI = %x DI = %x SP = %x BP = %x\n",
           _AX,_BX,_CX,_DX,_SI,_DI,_SP,_BP);
    asm push gs
    asm push fs
    asm push ss
    asm push es
    asm push ds
    asm push cs
    Printf("CS = %x DS = %x ES = %x SS = %x FS = %x GS = %x\n");
    asm add sp, 12
    return;
}

/* An error that cannot be recoverd. We just display a blue screen
and crash (freeze) */
void FatalError(char far *err_str) /* public */
{
    int i;
    ClearScreen(0,0,25,80,0x1F);
    PutString("\nError\n\n");
    PutString(err_str);
    /* Executing environment for detecting errors */
    PrintRegisters();
    PutChar('\n');
    /* Dead */
    while(1);
}
