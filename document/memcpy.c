
void memcpy(void far *dest,void far *src,unsigned short len)
{
    asm push es
    asm push di
    asm push ds
    asm push si

    asm les di, [dest]
    asm lds si, [src]

    asm mov ax, [dest + 2]
    asm shl eax, 4
    asm add eax, [dest]
    asm mov bx, [src + 2]
    asm shl ebx, 4
    asm add ebx, [src]
    /* cx is the length to copy */
    asm mov cx, [len]
    /* default is to copy from low to high */
    asm mov dx, -3
    asm cld
    /* address compare */
    asm cmp eax, ebx
    /* extra test: if dest and src are the same then return */
    asm jz memcpy_ret
    /* if dest is lower than bx then copy from low to high */
    asm jb memcpy_start
    /* if dest is higher then adjust si and di and set DF */
    asm std
    asm add di, cx
    asm add si, cx
    /* point to the low byte of the last dword */
    asm sub di, 4
    asm sub si, 4
    /* dx = 3 */
    asm neg dx
memcpy_start:
    /* temporarily save cx (len) in ax */
    asm mov ax, cx
    /* divide by 4 */
    asm shr cx, 2
    /* copy 4 bytes */
    asm rep movsd

    /* adjust si and di to do 1 byte copy */
    asm add si, dx
    asm add di, dx
    asm mov cx, ax
    asm and cx, 0003h
    /* copy 1 byte */
    asm rep movsb
memcpy_ret:
    asm pop si
    asm pop ds
    asm pop di
    asm pop es
    return;
}
