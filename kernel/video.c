
#define WINDEBUG

#ifndef _WINDEBUG
#include "..\include\kernel.h"
#else
#include <stdio.h>
#endif

asm _DATA ends
asm _TEXT segment byte public 'CODE'

asm .486
asm .MODEL TINY

/* Far pointer to current video memory. */
unsigned char far *video_char_ptr = 0xB8000000;
unsigned short video_mode = 0x0000;
unsigned short current_col = 0x0000;
unsigned short current_row = 0x0000;
unsigned short total_col = 80;
unsigned short total_row = 25;
unsigned short start_col = 0x0000;
unsigned short start_row = 0x0000;
unsigned char default_mode = 0x07;

/* This value is updated dynamically with the current_col and current_row */
/* Try to manage the consistency */
unsigned short current_offset = 0x0000;

unsigned char cursor_char = ' ';
unsigned char cursor_mode = 0x70;
unsigned char under_cursor_char = 0x00;
unsigned char under_cursor_mode = 0x07;

asm _TEXT ends
asm _DATA segment word public 'DATA'

/* Return the start far address of the video memory.
The structure of video memory may vary */
int ClearScreen(unsigned short start_row_val,unsigned short start_col_val,
                unsigned short total_row_val,unsigned short total_col_val,
                unsigned char default_mode_val) /* public */
{
    unsigned short default_word = ((unsigned short)default_mode_val << 8);
    int i;
    start_row = start_row_val;
    start_col = start_col_val;
    total_row = total_row_val;
    total_col = total_col_val;
    default_mode = default_mode_val;
    /* Manually update the backup under-cursor byte */
    under_cursor_mode = default_mode_val;
    current_row = 0;
    current_col = 0;
    current_offset = GetVideoOffset(0,0);
    for(i = 0;i < total_row - start_row;i++) ClearLine(i,default_word);
    return;
}

unsigned char far *GetVideoPointer() /* public */
{
    return video_char_ptr;   
}

int InitVideo(unsigned char mode)
{
    /* video_mode = mode; */
    asm xor ax, ax
    asm mov al, mode
    asm mov video_mode, ax
    /* current_row = 0x00; */
    asm mov word ptr current_row, 0000h
    /* current_col = 0x00; */
    asm mov word ptr current_col, 0000h
    /* start_row = 0; */
    asm mov word ptr start_row, 0000h
    /* start_col = 0; */
    asm mov word ptr start_col, 0000h
    asm mov ah, 00h
    asm mov al, mode
    asm int 10h
    /* Hide the cursor */
    asm mov ah, 01h
    asm mov cx, 2607h
    asm int 10h
    /* Initialize current_offset using relative position 0,0 */
    asm xor ax, ax
    asm push ax
    asm push ax
    asm call GetVideoOffset
    asm add sp, 4
    asm mov current_offset, ax
    return _AX;
}

unsigned short GetVideoMode()
{
    asm mov ax, video_mode
    asm mov sp, bp
    asm pop bp
    asm retn
}

unsigned short GetNextColumn()
{
    asm mov ax, current_col
    /* CX = current_col + start_col */
    asm mov cx, ax
    asm add cx, start_col
    asm inc cx
    asm cmp cx, total_col
    asm jae GetNextColumn_change_col
    asm inc ax
    asm jmp GetNextColumn_ret
GetNextColumn_change_col:
    asm xor ax, ax
GetNextColumn_ret:
    return;
    /*
    if(current_col + start_col >= total_col - 1) return 0;
    else return current_col + 1;
    */
}

unsigned short GetNextRow()
{
    asm mov ax, current_row
    asm mov cx, ax
    asm add cx, start_row
    asm inc cx
    asm cmp cx, total_row
    asm jae GetNextRow_change_row
    asm inc ax
    asm jmp GetNextRow_ret
GetNextRow_change_row:
    asm mov ax, total_row
    asm sub ax, start_row
    asm dec ax
GetNextRow_ret:
    return;
    /*
    if(current_row + start_row >= total_row - 1) return total_row - start_row - 1;
    else return current_row + 1;
    */
}

unsigned short GetPreviousRow()
{
    if(current_row == 0) return 0;
    else return current_row - 1;
}

unsigned short GetPreviousColumn()
{
    if(current_col == 0) return total_col - start_col - 1;
    else return current_col - 1;
}

/* Get the offset of a certain position in the video memory
Only calculates according to the position, no check on the validity of
the position (i.e. the position can be invalid) */
/* This function deals with relative offset! */
/* This function does not use the current_offset, instead it will return
a newly calculated one */
unsigned short GetVideoOffset(unsigned short row,unsigned short col)
{
    /* Convert relative position to absolute position */
    asm mov ax, start_row
    asm add row, ax
    asm mov ax, start_col
    asm add col, ax

    asm mov ax, row
    /* Here we must use 80 * 25, instead of using total_row and total_col */
    /* ax * 80 = (ax << 4) + (ax << 6) */
    asm mov bx, ax
    asm shl ax, 4
    asm shl bx, 6
    asm add ax, bx
    /* ax + col */
    asm add ax, col
    /* ax *= 2 */
    asm shl ax, 1
    return;
}

/* Copy one line in the video memory for chat mode
The two arguments are line numbers */
int CopyLine(unsigned short dest,unsigned short src)
{
    unsigned short copy_byte, source_offset;
    /* Save si and di */
    asm push si
    asm push di
    /* dest and src are relative rows */
    asm mov si, src
    asm mov di, dest

    /* DX is the number of bytes need to copy */
    asm mov dx, total_col
    asm sub dx, start_col
    asm shl dx, 1
    /* Save the value */
    asm mov copy_byte, dx
    /* Then calculate the start and end offset */
    asm push 0
    asm push si
    asm call GetVideoOffset
    asm add sp, 4
    asm mov source_offset, ax

    asm push 0
    asm push di
    /* AX is the dest offset */
    asm call GetVideoOffset
    asm add sp, 4
    asm push word ptr copy_byte
    asm push word ptr source_offset
    asm push ax
    asm push video_char_segment
    asm call SegmentCopy
    asm add sp, 8

    asm pop di
    asm pop si
    return;
}

/* Set both the char and the mode using a 16-bit fill parameter
The high 8 bits are mode and low 8 bits a re character */
int ClearLine(unsigned short dest,unsigned short fill) /* public */
{
    asm push 0
    asm push word ptr dest
    /* Afther this AX = Offset of the line */
    asm call GetVideoOffset
    asm add sp, 4
    /* CX = Number of bytes to clear */
    asm mov cx, total_col
    asm sub cx, start_col
    /* asm shl cx, 1 */
    asm push cx
    asm push fill
    asm push video_char_segment
    asm push ax
    asm call SegmentSetWord
    asm add sp, 8
    return;
}

/* Scroll up the screen by several lines (given in the parameter)
from start_row to start_row + total_row - 1
The first row (start_row) will be overwritten */
int VideoScrollUp(unsigned short num)
{
    unsigned short src,dest;
    asm mov cx, total_row
    /* CX = total_row - start_row - num, which is the number of lines to copy */
    asm sub cx, start_row
    asm sub cx, num
    /* Initialize loop variable: dest = 0, src = dest + num */
    /*asm mov si, start_row*/
    asm xor ax, ax
    asm mov dest, ax
    asm add ax, num
    asm mov src, ax
VideoScrollUp_loop:
    asm push cx

    asm push word ptr [src]
    asm push word ptr [dest]
    asm call CopyLine
    asm add sp, 4

    asm mov ah, byte ptr default_mode
    asm xor al, al
    asm push ax
    asm push word ptr [src]
    asm call ClearLine
    asm add sp, 4

    asm inc word ptr [src]
    asm inc word ptr [dest]
    asm pop cx
    asm loop VideoScrollUp_loop
    return;
}


/* Update the next position in global variable current_col and current_row */
/* No value is returned since we only want to update rather than get the value */
int GoNextPosition()
{
    asm call GetNextColumn
    asm mov current_col, ax
    /* Check if there is a column change */
    asm cmp ax, 0
    asm jnz GoNextPosition_no_line_change
    /* If the column changes then we also need to change the row */
    asm call GetNextRow
    /* If the next row is the same as the current row, which means we have */
    /* reached the bottom of the line */
    asm cmp ax, current_row
    /* After cmp we can write back this value */
    asm mov current_row, ax
    /* If we have reached the bottom of the line then just scroll up */
    asm jz GoNextPosition_scroll_up
    /* Else there is a line change but we have not reached the bottom
     increase the current_offset by ((start_col + 81 - total_col) * 2) and return */
    asm mov ax, start_col
    asm add ax, 81
    asm sub ax, total_col
    asm shl ax, 1
    asm add current_offset, ax
    asm jmp GoNextPosition_ret
GoNextPosition_scroll_up:
    /* Scroll up 1 line */
    asm push word ptr 1
    asm call VideoScrollUp
    asm add sp, 2
    /* Update the current_offset by decreasing it to the first column of the window */
    asm mov ax, total_col
    asm sub ax, start_col
    asm dec ax
    asm shl ax, 1
    asm sub current_offset, ax
    asm jmp GoNextPosition_ret
GoNextPosition_no_line_change:
    /* If no column change then just update the column */
    /* and return */
    asm mov ax, current_col
    /* The offset is increased by 2 */
    asm add current_offset, 2
    asm jmp GoNextPosition_ret

GoNextPosition_ret:
    return;
}

/* Move current_col and current_row to the previous position.
If we have reached the topmost line then just remain at the beginning position */
int GoPreviousPosition()
{
    unsigned short prev_col = GetPreviousColumn();
    unsigned short prev_row;
    /* Line Switch */
    if(prev_col == total_col - start_col - 1)
    {
        prev_row = GetPreviousRow();
        /* Line switch and the topmost, return 1 */
        if(prev_row == current_row)
        {
            /* Then remain at the same position */
            current_row = 0;
            current_col = 0;
            current_offset = 0;
            return 1;
        }
        else /* Line switch but not at the topmost */
        {
            current_row = prev_row;
            current_col = prev_col;
            current_offset = GetVideoOffset(current_row,current_col);
            return 0;
        }
    }
    else
    {
        current_col = prev_col;
        current_offset = GetVideoOffset(current_row,current_col);
        return 0;
    }
    /* We should never reach this line */
    return -1;
}

/* This function will go to the next column and possibly
scroll up the screen, by setting the cursor to the end of the current
row */
int GoNextRow()
{
    current_col = total_col - start_col - 1;
    current_offset = GetVideoOffset(current_row,current_col);
    GoNextPosition();
}

int GoFirstColumn()
{
    current_col = 0;
    current_offset = GetVideoOffset(current_row,current_col);
    return;
}

int UnDrawCursor()
{
    /* unsigned short offset = */
    video_char_ptr[current_offset] = under_cursor_char;
    video_char_ptr[current_offset + 1] = under_cursor_mode;
    return;
}

/* This function will draw a cursor at the position of the current input position */
int DrawCursor()
{
    /* unsigned short offset = GetVideoOffset(current_row,current_col); */
    under_cursor_char = video_char_ptr[current_offset];
    under_cursor_mode = video_char_ptr[current_offset + 1];
    video_char_ptr[current_offset] = cursor_char;
    video_char_ptr[current_offset + 1] = cursor_mode;
    return;
}

int MoveCursor()
{

}
