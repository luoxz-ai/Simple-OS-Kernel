
#define WINDEBUG

#ifndef _WINDEBUG
#include "..\include\kernel.h"
#else
#include <stdio.h>

char digit_table[] = "0123456789ABCDEF";

int PutChar(char ch)
{
    putchar(ch);
}
#endif

asm .486
asm .MODEL TINY

int PutChar(unsigned char ch) /* public */
{
    int i;
    /* unsigned short offset = GetVideoOffset(current_row,current_col); */
    UnDrawCursor();
    if(ch == '\n')
    {
        GoNextRow();
    }
    else if(ch == '\r')
    {
        GoFirstColumn();
    }
    else if(ch == '\t')
    {
        /* Make current_col align to a 4-character span */
        i = 4 - (current_col % 4);
        /* Although it is a recursive call, we will not make it true recursive */
        for(;i > 0;i--) PutChar(' ');
    }
    else
    {
        video_char_ptr[current_offset] = ch;
        video_char_ptr[current_offset + 1] = default_mode;
        GoNextPosition();
    }
    DrawCursor();
    return ch;
}

/* Print a C String and returns the length of the string
For string, please use far pointer */
int PutString(unsigned char far *str) /* public */
{
    int count = 0;
    while(*str != '\0')
    {
        PutChar(*str++);
        count++;
    }
    return count;
}

int PrintByteHex(unsigned char hex) /* public */
{
    PutChar(digit_table[(hex & 0xF0) >> 4]);
    PutChar(digit_table[hex & 0x0F]);
    return 0;
}

int PrintShortHex(unsigned short hex) /* public */
{
    int i;
    unsigned short temp;
    for(i = 12;i >= 0;i -= 4)
    {
        temp = hex >> i;
        temp &= 0x000F;
        PutChar(digit_table[temp]);
    }
    return 0;
}

int PrintLongHex(unsigned long hex) /* public */
{
    /* Points to the high 16 bit of the long hex */
    unsigned short *hex_ptr = ((unsigned short *)&hex) + 1;
    /* Print high 16 bits */
    PrintShortHex(*hex_ptr);
    /* Print low 16 bits */
    PrintShortHex(*(hex_ptr - 1));
    return 0;
}

/* Print a unsigned short decimal number
The return value is the actual number of digits needed */
int PrintUnsignedShortDec(unsigned short dec) /* public */
{
    /* From 0 to 65535 we need only 5 digits */
    char stack[5];
    int stack_next = 0;
    int total;
    do
    {
        stack[stack_next++] = digit_table[dec % 10];
        dec /= 10;
    }while(dec > 0);
    total = stack_next;
    /* Then clear the stack and pump them to the screen */
    while(stack_next > 0) PutChar(stack[--stack_next]);
    return total;
}

int PrintSignedShortDec(short dec) /* public */
{
    if(dec < 0)
    {
        dec = -dec;
        PutChar('-');
    }
    /* We have printed out a minus sign */
    return PrintUnsignedShortDec(dec) + 1;
}

int PrintUnsignedLongDec(unsigned long decimal) /* public */
{
    int total;
    /* ecx is the counter */
    asm xor ecx, ecx
    /* Prepare immediate for division */
    asm mov ebx, 10
    /* Load 32 bit operand */
    asm mov eax, decimal
    /* We do not need CDQ, since we are doing unsigned division */
PrintUnsignedShortDec_loop:
    asm xor edx, edx
    asm div ebx
    asm inc ecx
    asm push dx
    asm test eax, eax
    asm jz PrintUnsignedShortDec_flush
    asm jmp PrintUnsignedShortDec_loop
PrintUnsignedShortDec_flush:
    /* The length will not exceed a int */
    asm mov word ptr total, cx
    asm xor eax, eax
    /* Prepare the base address */
    asm mov bx, offset digit_table
    /* ECX exactly holds the number of digits */
PrintUnsignedShortDec_flush_loop:
    asm pop ax
    asm xlat
    /* Save cx and bx */
    asm push cx
    asm push bx
    asm push ax
    asm call PutChar
    asm add sp, 2
    /* restore cx and bx */
    asm pop bx
    asm pop cx
    asm loop PrintUnsignedShortDec_flush_loop
    return total;
}

int PrintSignedLongDec(long decimal) /* public */
{
    unsigned short sign = 0;
    asm mov ebx, decimal
    asm xor eax, eax
    asm cmp ebx, eax
    /* signed comparison */
    asm jg PrintSignedLongDec_positive
    /* sign = 1 */
    asm inc word ptr sign
    /* Save ebx */
    asm push ebx
    asm push word ptr '-'
    asm call PutChar
    asm add sp, 2
    asm pop ebx
    asm neg ebx
PrintSignedLongDec_positive:
    asm push ebx
    asm call PrintUnsignedLongDec
    asm add sp, 4
    /* If there is a sign then sign = 1, and ax + sign = ax + 1 */
    asm add ax, sign
    return;
}

int PrintShortBinary(unsigned short bin) /* public */
{
    int i;
    for(i = 0;i < 16;i++)
    {
        if(bin & 0x8000) PutChar('1');
        else PutChar('0');
        bin <<= 1;
    }
    return 16;
}

int PrintLongBinary(unsigned long bin) /* public */
{
    asm mov ax, [bin + 2]
    asm push ax
    asm call PrintShortBinary
    asm mov ax, bin
    asm push ax
    asm call PrintShortBinary
    /* Combine the two into 1 */
    asm add sp, 4
    return 32;
}

/* This version of printf is used inside of the kernel so we only use near
pointers for string, including the format string and the parameter string */
int Printf(const char near *str,...) /* public */
{
    unsigned char far *ptr = ((unsigned char far *)&str) + 2;
    char ch = *str++;
    char ch2;
    char ch3;
    int count = 0;
    while(ch != '\0')
    {
        if(ch == '%')
        {
            ch2 = *str++;
            if(ch2 == '%') { PutChar('%'); count++; }
            else if(ch2 == 'd')
            {
                count += PrintSignedShortDec(((short far *)ptr)[0]);
                ptr += 2;
            }
            else if(ch2 == 'u')
            {
                count += PrintUnsignedShortDec(((unsigned short far *)ptr)[0]);
                ptr += 2;
            }
            else if(ch2 == 'x' || ch2 == 'X')
            {
                count += PrintShortHex(((unsigned short far *)ptr)[0]);
                ptr += 2;
            }
            else if(ch2 == 'l')
            {
                ch3 = *str++;
                if(ch3 == 'd')
                {
                    count += PrintSignedLongDec(((long far *)ptr)[0]);
                    ptr += 4;
                }
                else if(ch3 == 'u')
                {
                    count += PrintUnsignedLongDec(((unsigned long far *)ptr)[0]);
                    ptr += 4;
                }
                else if(ch3 == 'x' || ch3 == 'X')
                {
                    count += PrintLongHex(((unsigned long far *)ptr)[0]);
                    ptr += 4;
                }
                else if(ch3 == '\0')
                {
                    count += PrintSignedLongDec(((long far *)ptr)[0]);
                    ptr += 4;
                    break;
                }
                else
                {
                    str--;
                    count += PrintSignedLongDec(((long far *)ptr)[0]);
                    ptr += 4;
                }
            }
            else if(ch2 == 's')
            {
                count += PutString(((char far **)ptr)[0]);
                ptr += 4;
            }
            else if(ch2 == '\0')
            {
                PutChar('%');
                count += 1;
                break;
            }
            else
            {
                str--;
                count++;
                PutChar('%');
            }
        }
        else if(ch == '\0')
        {
            PutChar(ch);
            count++;
            break;
        }
        else
        {
            PutChar(ch);
            count++;
        }
        ch = *str++;
    }
    return count;
}

#ifdef _WINDEBUG

void main()
{
    PrintSignedLongDec(0xFFFF0000);
    PutChar('\n');
    PrintLongBinary(0xFFFF0000);
    /* PrintLongHex(0x9876ABCD); */
    Printf("This is a string%d\n %d %ld",1000,2000,-1L);
    getchar();
}

#endif
