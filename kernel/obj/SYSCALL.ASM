	ifndef	??version
?debug	macro
	endm
	endif
	?debug	S "syscall.c"
_TEXT	segment	byte public 'CODE'
DGROUP	group	_DATA,_BSS
	assume	cs:_TEXT,ds:DGROUP
_TEXT	ends
_DATA	segment word public 'DATA'
d@	label	byte
d@w	label	word
_DATA	ends
_BSS	segment word public 'BSS'
b@	label	byte
b@w	label	word
	?debug	C E931A724440973797363616C6C2E63
	?debug	C E9A1949B43122E2E5C696E636C7564655C62617369632E68
	?debug	C E9BD9B2444132E2E5C696E636C7564655C6B65726E656C2E68
_BSS	ends
_DATA	segment word public 'DATA'
 	video_char_segment	 equ word ptr _video_char_ptr + 2
	?debug	C E9B2932444142E2E5C696E636C7564655C73797363616C6C2E68
 	_DATA	 ends
 	_TEXT	 segment byte public 'CODE'
 	.486
 	.MODEL TINY
 	ah00_table	 label byte
 	ah00_al00	 label word
 	dw	 offset _PutChar
 	ah00_al01	 label word
 	dw	 offset _PutString
 	ah00_al02	 label word
 	dw	 offset _PrintUnsignedShortDec
 	ah00_al03	 label word
 	dw	 offset _PrintSignedShortDec
 	ah00_al04	 label word
 	dw	 offset _PrintShortHex
 	ah00_al05	 label word
 	dw	 offset _PrintLongHex
 	ah00_al06	 label word
 	dw	 offset _PrintSignedLongDec
 	ah00_al07	 label word
 	dw	 offset _PrintSignedLongDec
 	syscall_directory	 label byte
 	dw	 offset ah00_table
 	_TEXT	 ends
 	_DATA	 segment word public 'DATA'
_DATA	ends
_TEXT	segment	byte public 'CODE'
;	?debug	L 44
_SysPutChar	proc	near
	push	bp
	mov	bp,sp
;	?debug	L 46
 	mov	 ax, 0000h
;	?debug	L 47
 	push	 word ptr [bp+4]
;	?debug	L 49
 	push	 word ptr 1
;	?debug	L 50
 	int	 80h
;	?debug	L 51
 	add	 sp, 4
;	?debug	L 52
	jmp	short @1
@1:
;	?debug	L 53
	pop	bp
	ret	
_SysPutChar	endp
;	?debug	L 55
_SysPutString	proc	near
	push	bp
	mov	bp,sp
;	?debug	L 57
 	mov	 ax, 0001h
;	?debug	L 58
 	push	 dword ptr [bp+4]
;	?debug	L 59
 	push	 word ptr 2
;	?debug	L 60
 	int	 80h
;	?debug	L 61
 	add	 sp, 6
;	?debug	L 62
	jmp	short @2
@2:
;	?debug	L 63
	pop	bp
	ret	
_SysPutString	endp
;	?debug	L 65
_SysPrintUnsignedShortDec	proc	near
	push	bp
	mov	bp,sp
;	?debug	L 67
 	mov	 ax, 0002h
;	?debug	L 68
 	push	 word ptr [bp+4]
;	?debug	L 69
 	push	 word ptr 1
;	?debug	L 70
 	int	 80h
;	?debug	L 71
 	add	 sp, 4
;	?debug	L 72
	jmp	short @3
@3:
;	?debug	L 73
	pop	bp
	ret	
_SysPrintUnsignedShortDec	endp
;	?debug	L 75
_SysPrintSignedShortDec	proc	near
	push	bp
	mov	bp,sp
;	?debug	L 77
 	mov	 ax, 0003h
;	?debug	L 78
 	push	 word ptr [bp+4]
;	?debug	L 79
 	push	 word ptr 1
;	?debug	L 80
 	int	 80h
;	?debug	L 81
 	add	 sp, 4
;	?debug	L 82
	jmp	short @4
@4:
;	?debug	L 83
	pop	bp
	ret	
_SysPrintSignedShortDec	endp
;	?debug	L 85
_SysPrintShortHex	proc	near
	push	bp
	mov	bp,sp
;	?debug	L 87
 	mov	 ax, 0004h
;	?debug	L 88
 	push	 word ptr [bp+4]
;	?debug	L 89
 	push	 word ptr 1
;	?debug	L 90
 	int	 80h
;	?debug	L 91
 	add	 sp, 4
;	?debug	L 92
	jmp	short @5
@5:
;	?debug	L 93
	pop	bp
	ret	
_SysPrintShortHex	endp
;	?debug	L 95
_SysPrintLongHex	proc	near
	push	bp
	mov	bp,sp
;	?debug	L 97
 	mov	 ax, 0005h
;	?debug	L 98
 	push	 dword ptr [bp+4]
;	?debug	L 99
 	push	 word ptr 2
;	?debug	L 100
 	int	 80h
;	?debug	L 101
 	add	 sp, 6
;	?debug	L 102
	jmp	short @6
@6:
;	?debug	L 103
	pop	bp
	ret	
_SysPrintLongHex	endp
;	?debug	L 105
_SysPrintUnsignedLongDec	proc	near
	push	bp
	mov	bp,sp
;	?debug	L 107
 	mov	 ax, 0006h
;	?debug	L 108
 	push	 dword ptr [bp+4]
;	?debug	L 109
 	push	 word ptr 2
;	?debug	L 110
 	int	 80h
;	?debug	L 111
 	add	 sp, 6
;	?debug	L 112
	jmp	short @7
@7:
;	?debug	L 113
	pop	bp
	ret	
_SysPrintUnsignedLongDec	endp
;	?debug	L 115
_SysPrintSignedLongDec	proc	near
	push	bp
	mov	bp,sp
;	?debug	L 117
 	mov	 ax, 0007h
;	?debug	L 118
 	push	 dword ptr [bp+4]
;	?debug	L 119
 	push	 word ptr 2
;	?debug	L 120
 	int	 80h
;	?debug	L 121
 	add	 sp, 6
;	?debug	L 122
	jmp	short @8
@8:
;	?debug	L 123
	pop	bp
	ret	
_SysPrintSignedLongDec	endp
;	?debug	L 125
_InitSystemCall	proc	near
;	?debug	L 127
	push	cs
	mov	ax,offset _int80h
	push	ax
	mov	al,128
	push	ax
	call	near ptr _SetInterrupt
	add	sp,6
;	?debug	L 128
	xor	ax,ax
	jmp	short @9
@9:
;	?debug	L 129
	ret	
_InitSystemCall	endp
;	?debug	L 134
_int80h	proc	near
	push	si
	push	di
;	?debug	L 140
 	add	 sp, 4
;	?debug	L 146
 	push	 bx 
;	?debug	L 147
 	push	 cx 
;	?debug	L 148
 	push	 dx 
;	?debug	L 149
 	push	 si 
;	?debug	L 150
 	push	 di 
;	?debug	L 151
 	push	 bp 
;	?debug	L 152
 	push	 ds 
;	?debug	L 153
 	push	 es 
;	?debug	L 156
 	mov	 bp, sp
;	?debug	L 158
 	cli	
;	?debug	L 160
 	mov	 dx, ax
;	?debug	L 162
 	mov	 cx, [bp + 22]
;	?debug	L 164
 	mov	 ax, ss
;	?debug	L 165
 	mov	 es, ax
;	?debug	L 166
 	mov	 ds, ax
;	?debug	L 167
 	cld	
;	?debug	L 169
 	lea	 si, [bp + 24]
;	?debug	L 171
 	mov	 ax, cx
;	?debug	L 172
 	shl	 ax, 1
;	?debug	L 174
 	sub	 sp, ax
;	?debug	L 176
 	mov	 di, bp
;	?debug	L 177
 	sub	 di, ax
;	?debug	L 179
 	rep movsw	
;	?debug	L 181
 	mov	 ax, 07000H 
;	?debug	L 182
 	mov	 ds, ax
;	?debug	L 185
 	mov	 si, dx
;	?debug	L 186
 	and	 si, 0FF00h
;	?debug	L 188
 	shr	 si, (8 - 1)
;	?debug	L 190
 	mov	 bx, word ptr [syscall_directory + si]
;	?debug	L 191
 	mov	 si, dx
;	?debug	L 193
 	and	 si, 00FFh
;	?debug	L 194
 	shl	 si, 1
;	?debug	L 195
 	sti	
;	?debug	L 196
 	call	 word ptr [bx + si]
;	?debug	L 198
 	mov	 sp, bp
;	?debug	L 200
 	pop	 es
;	?debug	L 201
 	pop	 ds
;	?debug	L 202
 	pop	 bp
;	?debug	L 203
 	pop	 di
;	?debug	L 204
 	pop	 si
;	?debug	L 205
 	pop	 dx
;	?debug	L 206
 	pop	 cx
;	?debug	L 207
 	pop	 bx
;	?debug	L 208
 	iret	
@10:
;	?debug	L 209
	pop	di
	pop	si
	ret	
_int80h	endp
_TEXT	ends
	?debug	C E9
_DATA	segment word public 'DATA'
s@	label	byte
_DATA	ends
	extrn	_video_char_ptr:dword
_TEXT	segment	byte public 'CODE'
	extrn	_PrintShortHex:near
	extrn	_PrintLongHex:near
	extrn	_SetInterrupt:near
	extrn	_PutString:near
	extrn	_PutChar:near
	extrn	_PrintUnsignedShortDec:near
	extrn	_PrintSignedShortDec:near
	extrn	_PrintSignedLongDec:near
_TEXT	ends
	public	_InitSystemCall
	public	_SysPutString
	public	_SysPutChar
	public	_int80h
	public	_SysPrintUnsignedShortDec
	public	_SysPrintUnsignedLongDec
	public	_SysPrintSignedShortDec
	public	_SysPrintSignedLongDec
	public	_SysPrintShortHex
	public	_SysPrintLongHex
	end
