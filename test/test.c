
#define WINDEBUG

#ifdef _WINDEBUG

asm _DATA   ENDS

asm _TEXT   segment byte public 'CODE'
asm ORG 100H
asm start:
asm _TEXT ENDS

asm _DATA   segment word public 'DATA'

#endif

void main()
{
 asm xor ax, ax
 asm mov al, 01h
 asm int 10h
 asm push 0b800h
 asm pop es
 asm xor di, di
 asm cld
 asm mov ax, cs
 #ifdef _WINDEBUG
 asm add ax, 10h
 #endif
 asm mov ds, ax
 asm mov si, offset str_start
 asm mov cx, offset str_end - offset str_start;
 asm rep movsb

 asm mov di, 87d;
 asm mov ax, cs;
 asm mov bx, offset char_table
 asm mov cx, 4
 asm std
print_cs:
 asm mov dx, ax
 asm and dx, 000Fh;
 asm mov si, dx;
 asm push ax
 asm mov al, ' '
 asm stosb
 asm mov al, byte ptr [bx + si];
 asm stosb;
 asm pop ax
 asm shr ax, 4
 asm loop print_cs
 asm cld
 while(1);
}

void null()
{
 asm db 2000 dup('*')

 asm str_start:
 asm db "T h i s   i s   a   s t r i n g ";
 asm str_end:
 asm char_table:
 asm db '0123456789ABCDEF'
}
