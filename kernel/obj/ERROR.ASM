	ifndef	??version
?debug	macro
	endm
	endif
	?debug	S "error.c"
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
	?debug	C E948089E43076572726F722E63
	?debug	C E9A1949B43122E2E5C696E636C7564655C62617369632E68
	?debug	C E9BD9B2444132E2E5C696E636C7564655C6B65726E656C2E68
_BSS	ends
_DATA	segment word public 'DATA'
 	video_char_segment	 equ word ptr _video_char_ptr + 2
 	_DATA	 ends
 	_TEXT	 segment byte public 'CODE'
 	.MODEL TINY
 	.486
_last_error	label	word
	dw	0
 	_TEXT	 ends
 	_DATA	 segment word public 'DATA'
_DATA	ends
_TEXT	segment	byte public 'CODE'
;	?debug	L 16
_PrintRegisters	proc	near
	push	si
	push	di
;	?debug	L 18
;	?debug	L 19
	push	bp
	push	sp
	push	di
	push	si
	push	dx
	push	cx
	push	bx
	push	ax
	mov	ax,offset DGROUP:s@
	push	ax
	call	near ptr _Printf
	add	sp,18
;	?debug	L 20
 	push	 gs
;	?debug	L 21
 	push	 fs
;	?debug	L 22
 	push	 ss
;	?debug	L 23
 	push	 es
;	?debug	L 24
 	push	 ds
;	?debug	L 25
 	push	 cs
;	?debug	L 26
	mov	ax,offset DGROUP:s@+67
	push	ax
	call	near ptr _Printf
	pop	cx
;	?debug	L 27
 	add	 sp, 12
	jmp	short @1
@1:
;	?debug	L 29
	pop	di
	pop	si
	ret	
_PrintRegisters	endp
_TEXT	ends
_DATA	segment word public 'DATA'
_DATA	ends
_TEXT	segment	byte public 'CODE'
;	?debug	L 33
_FatalError	proc	near
	push	bp
	mov	bp,sp
;	?debug	L 36
	mov	al,31
	push	ax
	mov	ax,80
	push	ax
	mov	ax,25
	push	ax
	xor	ax,ax
	push	ax
	xor	ax,ax
	push	ax
	call	near ptr _ClearScreen
	mov	sp,bp
;	?debug	L 37
	push	ds
	mov	ax,offset DGROUP:s@+116
	push	ax
	call	near ptr _PutString
	mov	sp,bp
;	?debug	L 38
	push	word ptr [bp+6]
	push	word ptr [bp+4]
	call	near ptr _PutString
	mov	sp,bp
;	?debug	L 40
	call	near ptr _PrintRegisters
;	?debug	L 41
	mov	al,10
	push	ax
	call	near ptr _PutChar
	pop	cx
;	?debug	L 43
	jmp	short @3
@5:
@3:
	jmp	short @5
@4:
@2:
;	?debug	L 44
	pop	bp
	ret	
_FatalError	endp
_TEXT	ends
	?debug	C E9
_DATA	segment word public 'DATA'
s@	label	byte
	db	10
	db	10
	db	65
	db	88
	db	32
	db	61
	db	32
	db	37
	db	120
	db	32
	db	66
	db	88
	db	32
	db	61
	db	32
	db	37
	db	120
	db	32
	db	67
	db	88
	db	32
	db	61
	db	32
	db	37
	db	120
	db	32
	db	68
	db	88
	db	32
	db	61
	db	32
	db	37
	db	120
	db	10
	db	83
	db	73
	db	32
	db	61
	db	32
	db	37
	db	120
	db	32
	db	68
	db	73
	db	32
	db	61
	db	32
	db	37
	db	120
	db	32
	db	83
	db	80
	db	32
	db	61
	db	32
	db	37
	db	120
	db	32
	db	66
	db	80
	db	32
	db	61
	db	32
	db	37
	db	120
	db	10
	db	0
	db	67
	db	83
	db	32
	db	61
	db	32
	db	37
	db	120
	db	32
	db	68
	db	83
	db	32
	db	61
	db	32
	db	37
	db	120
	db	32
	db	69
	db	83
	db	32
	db	61
	db	32
	db	37
	db	120
	db	32
	db	83
	db	83
	db	32
	db	61
	db	32
	db	37
	db	120
	db	32
	db	70
	db	83
	db	32
	db	61
	db	32
	db	37
	db	120
	db	32
	db	71
	db	83
	db	32
	db	61
	db	32
	db	37
	db	120
	db	10
	db	0
	db	10
	db	69
	db	114
	db	114
	db	111
	db	114
	db	10
	db	10
	db	0
_DATA	ends
	extrn	_video_char_ptr:dword
_TEXT	segment	byte public 'CODE'
	extrn	_ClearScreen:near
	extrn	_PutString:near
	extrn	_PutChar:near
	extrn	_Printf:near
_TEXT	ends
	public	_PrintRegisters
	public	_last_error
	public	_FatalError
	end
