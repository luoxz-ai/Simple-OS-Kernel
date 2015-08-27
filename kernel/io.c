
#include "..\include\kernel.h"
#include "..\include\basic.h"

asm .486
asm .MODEL TINY

void OutByte(unsigned short port,unsigned char o_byte) /* public */
{
    asm mov dx, port
    asm mov al, o_byte
    asm out dx, al
    return;
}

unsigned char InByte(unsigned short port) /* public */
{
    asm xor ax, ax
    asm mov dx, port
    asm in al, dx
    return;
}

void MaskIRQ(unsigned short irq) /* public */
{
    /* 8259A Master Data Port = 0x21 */
    unsigned short port = 0x21;
    unsigned char imr;
    if(irq >= 8)
    {
        port = 0xA1;
        irq -= 8;
    }
    imr = InByte(port);
    imr |= ((unsigned char)0x01 << irq);
    OutByte(port,imr);
    return;
}

void UnmaskIRQ(unsigned short irq) /* public */
{
    /* 8259A Master Data Port = 0x21 */
    unsigned short port = 0x21;
    unsigned char imr;
    if(irq >= 8)
    {
        port = 0xA1;
        irq -= 8;
    }
    imr = InByte(port);
    imr &= (~((unsigned char)0x01 << irq));
    OutByte(port,imr);
    return;
}

void SetInterrupt(unsigned char int_num,void far *address) /* public */
{
    /* Points to the Interrupt Vector Table */
    unsigned long far *ivt = 0x00000000;
    /* Each entry is 4 bytes long (same as an unsigned long) */
    ivt[int_num] = (unsigned long)address;
    return;
}

unsigned char far *GetInterrupt(unsigned char int_num) /* public */
{
    unsigned long far *ivt = 0x00000000;
    return (unsigned char far *)(ivt[int_num]);
}

int CheckRTC()
{
    asm mov ah, 0c0h
    asm int 15h
    asm jc CheckRTC_error
    asm mov al, es:[bx + 5]
    asm test al, 10h
    asm jz CheckRTC_error
    return 0;
CheckRTC_error:
    return -1;
}
