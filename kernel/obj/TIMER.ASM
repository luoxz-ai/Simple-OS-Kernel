	ifndef	??version
?debug	macro
	endm
	endif
	?debug	S "timer.c"
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
	?debug	C E90EA622440774696D65722E63
	?debug	C E9A1949B43122E2E5C696E636C7564655C62617369632E68
	?debug	C E9BD9B2444132E2E5C696E636C7564655C6B65726E656C2E68
_BSS	ends
_DATA	segment word public 'DATA'
 	video_char_segment	 equ word ptr _video_char_ptr + 2
 	_DATA	 ends
 	_TEXT	 segment byte public 'CODE'
 	.486
 	.MODEL TINY
_time_counter	label	word
	dw	0
	dw	0
_time_counter_high	label	word
	dw	0
	dw	0
 	_TEXT	 ends
 	_DATA	 segment word public 'DATA'
_DATA	ends
_TEXT	segment	byte public 'CODE'
;	?debug	L 16
_int70h	proc	near
	push	si
	push	di
;	?debug	L 22
 	cli	
;	?debug	L 23
 	add	 sp, 4
;	?debug	L 24
 	push	 ss 
;	?debug	L 25
 	push	 ax 
;	?debug	L 26
 	push	 bx 
;	?debug	L 27
 	push	 cx 
;	?debug	L 28
 	push	 dx 
;	?debug	L 29
 	push	 si 
;	?debug	L 30
 	push	 di 
;	?debug	L 31
 	push	 bp 
;	?debug	L 32
 	push	 ds 
;	?debug	L 33
 	push	 es 
;	?debug	L 36
 	mov	 bp, sp
;	?debug	L 38
 	mov	 ax, 07000H 
;	?debug	L 39
 	mov	 ds, ax
;	?debug	L 42
 	add	 dword ptr [DGROUP:_time_counter], 1
;	?debug	L 44
 	adc	 dword ptr [DGROUP:_time_counter_high], 0
;	?debug	L 46
	mov	al,32
	push	ax
	mov	ax,160
	push	ax
	call	near ptr _OutByte
	pop	cx
	pop	cx
;	?debug	L 48
	mov	al,32
	push	ax
	mov	ax,32
	push	ax
	call	near ptr _OutByte
	pop	cx
	pop	cx
;	?debug	L 50
	mov	al,12
	push	ax
	mov	ax,112
	push	ax
	call	near ptr _OutByte
	pop	cx
	pop	cx
;	?debug	L 52
	mov	ax,113
	push	ax
	call	near ptr _InByte
	pop	cx
;	?debug	L 57
 	test	 word ptr [DGROUP:_time_counter], 001Fh
;	?debug	L 58
 	jnz	 @2
;	?debug	L 60
 	call	 _SaveContext
;	?debug	L 61
 	call	 _Schedule
@2:
;	?debug	L 64
 	pop	 es
;	?debug	L 65
 	pop	 ds
;	?debug	L 66
 	pop	 bp
;	?debug	L 67
 	pop	 di
;	?debug	L 68
 	pop	 si
;	?debug	L 69
 	pop	 dx
;	?debug	L 70
 	pop	 cx
;	?debug	L 71
 	pop	 bx
;	?debug	L 72
 	pop	 ax
;	?debug	L 73
 	pop	 ss
;	?debug	L 75
 	sti	
;	?debug	L 76
 	iret	
@1:
;	?debug	L 77
	pop	di
	pop	si
	ret	
_int70h	endp
;	?debug	L 79
_InitRealTimeClock	proc	near
	push	bp
	mov	bp,sp
	sub	sp,2
;	?debug	L 83
	push	cs
	mov	ax,offset _int70h
	push	ax
	mov	al,112
	push	ax
	call	near ptr _SetInterrupt
	add	sp,6
;	?debug	L 92
	mov	al,11
	push	ax
	mov	ax,112
	push	ax
	call	near ptr _OutByte
	pop	cx
	pop	cx
;	?debug	L 94
	mov	ax,113
	push	ax
	call	near ptr _InByte
	pop	cx
	mov	byte ptr [bp-1],al
;	?debug	L 96
	mov	al,11
	push	ax
	mov	ax,112
	push	ax
	call	near ptr _OutByte
	pop	cx
	pop	cx
;	?debug	L 98
	mov	al,byte ptr [bp-1]
	or	al,64
	push	ax
	mov	ax,113
	push	ax
	call	near ptr _OutByte
	pop	cx
	pop	cx
;	?debug	L 100
	mov	ax,8
	push	ax
	call	near ptr _UnmaskIRQ
	pop	cx
;	?debug	L 101
	xor	ax,ax
	jmp	short @3
@3:
;	?debug	L 102
	mov	sp,bp
	pop	bp
	ret	
_InitRealTimeClock	endp
_TEXT	ends
	?debug	C E9
_DATA	segment word public 'DATA'
s@	label	byte
_DATA	ends
	extrn	_video_char_ptr:dword
_TEXT	segment	byte public 'CODE'
	extrn	_SetInterrupt:near
	extrn	_SaveContext:near
	extrn	_Schedule:near
	extrn	_OutByte:near
	extrn	_UnmaskIRQ:near
	extrn	_InByte:near
_TEXT	ends
	public	_time_counter
	public	_int70h
	public	_time_counter_high
	public	_InitRealTimeClock
	end
