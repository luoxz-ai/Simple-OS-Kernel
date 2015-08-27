#include "..\include\basic.h"
#include "..\include\kernel.h"
#include "..\include\syscall.h"

asm _DATA ends
asm _TEXT segment byte public 'CODE'

asm .486
asm .MODEL TINY

/* Static data must be initialized, or they will be stored in the BSS segment
which is out of the range of the executable, and will cause problems (to the stack) */

/* Addressing table of INT 80H AH=00H */
/* We can only do near call here. If the code needs a far call then please
use this as a stub, and after jumping to the stub, do a far call to a far
procedure (return using a retf instead of a ret) */
asm ah00_table label byte
asm ah00_al00 label word
asm dw offset PutChar
asm ah00_al01 label word
asm dw offset PutString
asm ah00_al02 label word
asm dw offset PrintUnsignedShortDec
asm ah00_al03 label word
asm dw offset PrintSignedShortDec
asm ah00_al04 label word
asm dw offset PrintShortHex
asm ah00_al05 label word
asm dw offset PrintLongHex
asm ah00_al06 label word
asm dw offset PrintSignedLongDec
asm ah00_al07 label word
asm dw offset PrintSignedLongDec


asm syscall_directory label byte
asm dw offset ah00_table


asm _TEXT ends
asm _DATA segment word public 'DATA'

int SysPutChar(char chr)
{
    asm mov ax, 0000h
    asm push word ptr chr
    /* 1 word */
    asm push word ptr 1
    asm int 80h
    asm add sp, 4
    return _AX;
}

int SysPutString(char far *str)
{
    asm mov ax, 0001h
    asm push dword ptr str
    asm push word ptr 2
    asm int 80h
    asm add sp, 6
    return _AX;
}

int SysPrintUnsignedShortDec(unsigned short num)
{
    asm mov ax, 0002h
    asm push word ptr num
    asm push word ptr 1
    asm int 80h
    asm add sp, 4
    return _AX;
}

int SysPrintSignedShortDec(short num)
{
    asm mov ax, 0003h
    asm push word ptr num
    asm push word ptr 1
    asm int 80h
    asm add sp, 4
    return _AX;
}

int SysPrintShortHex(short num)
{
    asm mov ax, 0004h
    asm push word ptr num
    asm push word ptr 1
    asm int 80h
    asm add sp, 4
    return _AX;
}

int SysPrintLongHex(unsigned long num)
{
    asm mov ax, 0005h
    asm push dword ptr num
    asm push word ptr 2
    asm int 80h
    asm add sp, 6
    return _AX;
}

int SysPrintUnsignedLongDec(unsigned long num)
{
    asm mov ax, 0006h
    asm push dword ptr num
    asm push word ptr 2
    asm int 80h
    asm add sp, 6
    return _AX;
}

int SysPrintSignedLongDec(unsigned long num)
{
    asm mov ax, 0007h
    asm push dword ptr num
    asm push word ptr 2
    asm int 80h
    asm add sp, 6
    return _AX;
}

int InitSystemCall()
{
    SetInterrupt(0x80,(void far *)int80h);
    return 0;
}

/* Do a system call.
The first parameter must be the number of words (16 bit words) in the argument,
so that we can copy the parameters to the stack */
void int80h()
{
    /* Compiler will insert
    push si
    push di
    So we need to adjust the stack pointer */
    asm add sp, 4
    /* We do not save ax, since it will be used to pass the return value */
    /* 1st parameter SP + 22 */
    /* FLAGS       SP + 20 */
    /* CS          SP + 18 */
    /* IP          SP + 16 */
    asm push bx /* SP + 14 */
    asm push cx /* SP + 12 */
    asm push dx /* SP + 10 */
    asm push si /* SP + 8 */
    asm push di /* SP + 6 */
    asm push bp /* SP + 4 */
    asm push ds /* SP + 2 */
    asm push es /* SP + 0 */
    /* We use BP as a backup of SP, the value of which will be preserved during
    procedure calls */
    asm mov bp, sp
    /* Disable interrupts, since we will not know what's going to happen */
    asm cli
    /* backup old ax */
    asm mov dx, ax
    /* CX is the length of arguments (in 16 bit words) */
    asm mov cx, [bp + 22]
    /* Initialize DS and ES to be SS */
    asm mov ax, ss
    asm mov es, ax
    asm mov ds, ax
    asm cld
    /* SI points to the starting word of the parameter */
    asm lea si, [bp + 24]
    /* ax is the actual bytes of the parameter (excluding the first parameter) */
    asm mov ax, cx
    asm shl ax, 1
    /* Move the stack pointer to hold the parameter */
    asm sub sp, ax
    /* DI points to the low address of the destination */
    asm mov di, bp
    asm sub di, ax
    /* CX is the number of words, so we use movsw */
    asm rep movsw
    /* Switch to system code segment to access the tables */
    asm mov ax, SYS_CODE_SEG
    asm mov ds, ax

    /* dx is the old ax */
    asm mov si, dx
    asm and si, 0FF00h
    /* si = ah * 2 */
    asm shr si, (8 - 1)
    /* Get ahxx table offset and put it into bx */
    asm mov bx, word ptr [syscall_directory + si]
    asm mov si, dx
    /* si = AL * 2 */
    asm and si, 00FFh
    asm shl si, 1
    asm sti
    asm call word ptr [bx + si]
    /* Restore the satck. BP is guaranteed not to change */
    asm mov sp, bp

    asm pop es
    asm pop ds
    asm pop bp
    asm pop di
    asm pop si
    asm pop dx
    asm pop cx
    asm pop bx
    asm iret
}
