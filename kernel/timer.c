#include "..\include\basic.h"
#include "..\include\kernel.h"

asm _DATA ends
asm _TEXT segment byte public 'CODE'

asm .486
asm .MODEL TINY

unsigned long time_counter = 0x00000000;
unsigned long time_counter_high = 0x00000000;

asm _TEXT ends
asm _DATA segment word public 'DATA'

void int70h()
{
    /* STACK: */
    /* FLAGS       bp + 24 */
    /* CS          bp + 22 */
    /* IP          bp + 20 */
    asm cli
    asm add sp, 4
    asm push ss /* bp + 18 */
    asm push ax /* bp + 16 */
    asm push bx /* bp + 14 */
    asm push cx /* bp + 12 */
    asm push dx /* bp + 10 */
    asm push si /* bp + 8 */
    asm push di /* bp + 6 */
    asm push bp /* bp + 4 */
    asm push ds /* bp + 2 */
    asm push es /* bp + 0 */
    /* Save SP prior to any stack operation (but after register saving)
    The SP before this interrupt is (bp + 26d) */
    asm mov bp, sp
    /* Switch to system data segment (actually code segment which contains the static data) */
    asm mov ax, SYS_CODE_SEG
    asm mov ds, ax
    /* Increment on 32-bit time recorder.
    Do not use inc, since inc will not change CF */
    asm add dword ptr [time_counter], 1
    /* Cascade the carry bit to higher 32 bits */
    asm adc dword ptr [time_counter_high], 0
    /* 8259A Slave EOI */
    OutByte(0xA0,0x20);
    /* 8259A Master EOI */
    OutByte(0x20,0x20);
    /* Select register C */
    OutByte(0x70,0x0C);
    /* Read a value to enable next rtc interrupt */
    InByte(0x71);
    /* Interrupt handler */
    /* TODO: something important here */
    /* finally we will decide if we are going to switch the current process or not
    If current time is a multiple of 32 (1/32 second) */
    asm test word ptr [time_counter], 001Fh
    asm jnz int70h_return
    /* BP is the saved stack position */
    asm call SaveContext
    asm call Schedule
int70h_return:

    asm pop es
    asm pop ds
    asm pop bp
    asm pop di
    asm pop si
    asm pop dx
    asm pop cx
    asm pop bx
    asm pop ax
    asm pop ss

    asm sti
    asm iret
}

int InitRealTimeClock()
{
    unsigned char temp;
    /* Set up the interrupt vector for int 70h */
    SetInterrupt(0x70,(void far *)int70h);
    /*
    asm push cs
    asm push offset int70h
    asm push word ptr 70h
    asm call SetInterrupt
    asm add sp, 6
    */
    /* Select register B of the rtc */
    OutByte(0x70,0x0b);
    /* Read register B and return */
    temp = InByte(0x71);
    /* Select register B again */
    OutByte(0x70,0x0b);
    /* Enable rtc */
    OutByte(0x71,temp | 0x40);
    /* Program 8259A to enable IRQ 8 */
    UnmaskIRQ(0x08);
    return 0;
}
