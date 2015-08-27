	ifndef	??version
?debug	macro
	endm
	endif
	?debug	S "io.c"
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
	?debug	C E952189F4304696F2E63
	?debug	C E9BD9B2444132E2E5C696E636C7564655C6B65726E656C2E68
_BSS	ends
_DATA	segment word public 'DATA'
 	video_char_segment	 equ word ptr _video_char_ptr + 2
	?debug	C E9A1949B43122E2E5C696E636C7564655C62617369632E68
 	.486
 	.MODEL TINY
_DATA	ends
_TEXT	segment	byte public 'CODE'
;	?debug	L 8
_OutByte	proc	near
	push	bp
	mov	bp,sp
;	?debug	L 10
 	mov	 dx, [bp+4]
;	?debug	L 11
 	mov	 al, [bp+6]
;	?debug	L 12
 	out	 dx, al
	jmp	short @1
@1:
;	?debug	L 14
	pop	bp
	ret	
_OutByte	endp
;	?debug	L 16
_InByte	proc	near
	push	bp
	mov	bp,sp
;	?debug	L 18
 	xor	 ax, ax
;	?debug	L 19
 	mov	 dx, [bp+4]
;	?debug	L 20
 	in	 al, dx
	jmp	short @2
@2:
;	?debug	L 22
	pop	bp
	ret	
_InByte	endp
;	?debug	L 24
_MaskIRQ	proc	near
	push	bp
	mov	bp,sp
	sub	sp,4
;	?debug	L 27
	mov	word ptr [bp-4],33
;	?debug	L 29
	cmp	word ptr [bp+4],8
	jb	@4
;	?debug	L 31
	mov	word ptr [bp-4],161
;	?debug	L 32
	sub	word ptr [bp+4],8
@4:
;	?debug	L 34
	push	word ptr [bp-4]
	call	near ptr _InByte
	pop	cx
	mov	byte ptr [bp-1],al
;	?debug	L 35
	mov	al,1
	mov	cl,byte ptr [bp+4]
	shl	al,cl
	or	byte ptr [bp-1],al
;	?debug	L 36
	push	word ptr [bp-1]
	push	word ptr [bp-4]
	call	near ptr _OutByte
	pop	cx
	pop	cx
	jmp	short @3
@3:
;	?debug	L 38
	mov	sp,bp
	pop	bp
	ret	
_MaskIRQ	endp
;	?debug	L 40
_UnmaskIRQ	proc	near
	push	bp
	mov	bp,sp
	sub	sp,4
;	?debug	L 43
	mov	word ptr [bp-4],33
;	?debug	L 45
	cmp	word ptr [bp+4],8
	jb	@6
;	?debug	L 47
	mov	word ptr [bp-4],161
;	?debug	L 48
	sub	word ptr [bp+4],8
@6:
;	?debug	L 50
	push	word ptr [bp-4]
	call	near ptr _InByte
	pop	cx
	mov	byte ptr [bp-1],al
;	?debug	L 51
	mov	al,1
	mov	cl,byte ptr [bp+4]
	shl	al,cl
	not	ax
	and	byte ptr [bp-1],al
;	?debug	L 52
	push	word ptr [bp-1]
	push	word ptr [bp-4]
	call	near ptr _OutByte
	pop	cx
	pop	cx
	jmp	short @5
@5:
;	?debug	L 54
	mov	sp,bp
	pop	bp
	ret	
_UnmaskIRQ	endp
;	?debug	L 56
_SetInterrupt	proc	near
	push	bp
	mov	bp,sp
	sub	sp,4
;	?debug	L 59
	mov	word ptr [bp-2],0
	mov	word ptr [bp-4],0
;	?debug	L 61
	mov	dx,word ptr [bp+8]
	mov	ax,word ptr [bp+6]
	mov	bl,byte ptr [bp+4]
	mov	bh,0
	shl	bx,1
	shl	bx,1
	push	dx
	push	ax
	push	bx
	les	bx,dword ptr [bp-4]
	pop	ax
	add	bx,ax
	pop	ax
	pop	dx
	mov	word ptr es:[bx+2],dx
	mov	word ptr es:[bx],ax
	jmp	short @7
@7:
;	?debug	L 63
	mov	sp,bp
	pop	bp
	ret	
_SetInterrupt	endp
;	?debug	L 65
_GetInterrupt	proc	near
	push	bp
	mov	bp,sp
	sub	sp,4
;	?debug	L 67
	mov	word ptr [bp-2],0
	mov	word ptr [bp-4],0
;	?debug	L 68
	mov	al,byte ptr [bp+4]
	mov	ah,0
	shl	ax,1
	shl	ax,1
	les	bx,dword ptr [bp-4]
	add	bx,ax
	mov	dx,word ptr es:[bx+2]
	mov	ax,word ptr es:[bx]
	jmp	short @8
@8:
;	?debug	L 69
	mov	sp,bp
	pop	bp
	ret	
_GetInterrupt	endp
;	?debug	L 71
_CheckRTC	proc	near
;	?debug	L 73
 	mov	 ah, 0c0h
;	?debug	L 74
 	int	 15h
;	?debug	L 75
 	jc	 @10
;	?debug	L 76
 	mov	 al, es:[bx + 5]
;	?debug	L 77
 	test	 al, 10h
;	?debug	L 78
 	jz	 @10
;	?debug	L 79
	xor	ax,ax
	jmp	short @9
@10:
;	?debug	L 81
	mov	ax,-1
	jmp	short @9
@9:
;	?debug	L 82
	ret	
_CheckRTC	endp
_TEXT	ends
	?debug	C E9
_DATA	segment word public 'DATA'
s@	label	byte
_DATA	ends
	extrn	_video_char_ptr:dword
_TEXT	segment	byte public 'CODE'
_TEXT	ends
	public	_SetInterrupt
	public	_GetInterrupt
	public	_OutByte
	public	_UnmaskIRQ
	public	_InByte
	public	_MaskIRQ
	public	_CheckRTC
	end
