	ifndef	??version
?debug	macro
	endm
	endif
	?debug	S "kernel.c"
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
	?debug	C E94E912444086B65726E656C2E63
	?debug	C E9A1949B43122E2E5C696E636C7564655C62617369632E68
	?debug	C E9BD9B2444132E2E5C696E636C7564655C6B65726E656C2E68
_BSS	ends
_DATA	segment word public 'DATA'
 	video_char_segment	 equ word ptr _video_char_ptr + 2
 	_DATA	 ends
 	_TEXT	 segment byte public 'CODE'
 	.MODEL TINY
 	.486
 	cli	
 	mov	 si, cs
 	mov	 es, si
 	mov	 ds, si
 	mov	 si, 0B800h
 	mov	 fs, si
 	mov	 si, 07000H 
 	mov	 ss, si
 	mov	 sp, 0FFFEh
 	sti	
 	mov	 ebx, 01234567h
 	mov	 eax, [ebx]
 	push	 ds
 	jmp	 _main
 	assume	 ds:_TEXT, cs:_TEXT, es:nothing
_digit_table	label	byte
	db	48
	db	49
	db	50
	db	51
	db	52
	db	53
	db	54
	db	55
	db	56
	db	57
	db	65
	db	66
	db	67
	db	68
	db	69
	db	70
	db	0
_equal_16	label	byte
	db	61
	db	61
	db	61
	db	61
	db	61
	db	61
	db	61
	db	61
	db	61
	db	61
	db	61
	db	61
	db	61
	db	61
	db	61
	db	61
	db	0
_large_mem_ok	label	byte
	db	84
	db	101
	db	115
	db	116
	db	32
	db	101
	db	120
	db	116
	db	101
	db	110
	db	100
	db	101
	db	100
	db	32
	db	109
	db	101
	db	109
	db	111
	db	114
	db	121
	db	46
	db	46
	db	46
	db	79
	db	75
	db	33
	db	10
	db	0
_sys_mem_avail	label	dword
	dw	0
	dw	-32768
 	_TEXT	 ends
 	_DATA	 segment word public 'DATA'
_DATA	ends
_TEXT	segment	byte public 'CODE'
;	?debug	L 50
_main	proc	near
	push	si
;	?debug	L 57
	mov	al,2
	push	ax
	call	near ptr _InitVideo
	pop	cx
;	?debug	L 58
	push	ds
	mov	ax,offset DGROUP:_large_mem_ok
	push	ax
	call	near ptr _PutString
	pop	cx
	pop	cx
;	?debug	L 59
	call	near ptr _PrintAllMemory
	mov	si,ax
;	?debug	L 60
	cmp	si,-1
	jne	@2
;	?debug	L 62
	push	ds
	mov	ax,offset DGROUP:s@
	push	ax
	call	near ptr _PutString
	pop	cx
	pop	cx
;	?debug	L 63
	jmp	short @3
@5:
@3:
	jmp	short @5
@4:
@2:
;	?debug	L 66
	mov	ax,256
	push	ax
	call	near ptr _InitMemoryTable
	pop	cx
;	?debug	L 68
	mov	ax,32
	push	ax
	call	near ptr _InitProcessTable
	pop	cx
;	?debug	L 69
	call	near ptr _InitSystemCall
;	?debug	L 70
	call	near ptr _InitRealTimeClock
;	?debug	L 71
	jmp	short @6
@8:
@6:
	jmp	short @8
@7:
@1:
;	?debug	L 72
	pop	si
	ret	
_main	endp
_TEXT	ends
	?debug	C E9
_DATA	segment word public 'DATA'
s@	label	byte
	db	77
	db	101
	db	109
	db	111
	db	114
	db	121
	db	32
	db	68
	db	101
	db	116
	db	101
	db	99
	db	116
	db	32
	db	70
	db	97
	db	105
	db	108
	db	0
_DATA	ends
	extrn	_video_char_ptr:dword
_TEXT	segment	byte public 'CODE'
	extrn	_PrintAllMemory:near
	extrn	_InitProcessTable:near
	extrn	_InitMemoryTable:near
	extrn	_InitSystemCall:near
	extrn	_InitVideo:near
	extrn	_PutString:near
	extrn	_InitRealTimeClock:near
_TEXT	ends
	public	_sys_mem_avail
	public	_large_mem_ok
	public	_digit_table
	public	_main
	public	_equal_16
	end
