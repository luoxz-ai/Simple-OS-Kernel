	ifndef	??version
?debug	macro
	endm
	endif
	?debug	S "mem.c"
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
	?debug	C E9F7A52244056D656D2E63
	?debug	C E9A1949B43122E2E5C696E636C7564655C62617369632E68
	?debug	C E9BD9B2444132E2E5C696E636C7564655C6B65726E656C2E68
_BSS	ends
_DATA	segment word public 'DATA'
 	video_char_segment	 equ word ptr _video_char_ptr + 2
 	_DATA	 ends
 	_TEXT	 segment byte public 'CODE'
 	.486
 	.MODEL TINY
_basic_mem_size	label	word
	dw	0
_mem_slot_num	label	word
	dw	0
_mem_slot_remain	label	word
	dw	0
_sys_mem_ptr	label	dword
	dw	0
	dw	0
_mem_slot_full_msg	label	byte
	db	77
	db	101
	db	109
	db	111
	db	114
	db	121
	db	32
	db	83
	db	108
	db	111
	db	116
	db	32
	db	70
	db	117
	db	108
	db	108
	db	46
	db	0
 	_TEXT	 ends
 	_DATA	 segment word public 'DATA'
_DATA	ends
_TEXT	segment	byte public 'CODE'
;	?debug	L 34
_AddressCompare	proc	near
	push	bp
	mov	bp,sp
	sub	sp,4
;	?debug	L 38
 	xor	 eax, eax
;	?debug	L 39
 	mov	 ebx, eax
;	?debug	L 41
 	mov	 ax, [[bp+4] + 2]
;	?debug	L 42
 	mov	 bx, [[bp+8] + 2]
;	?debug	L 43
 	shl	 eax, 4
;	?debug	L 44
 	shl	 ebx, 4
;	?debug	L 46
 	xor	 cx, cx
;	?debug	L 47
 	mov	 [[bp+4] + 2], cx
;	?debug	L 48
 	mov	 [[bp+8] + 2], cx
;	?debug	L 50
 	add	 eax, [bp+4]
;	?debug	L 51
 	add	 ebx, [bp+8]
;	?debug	L 53
 	sub	 eax, ebx
;	?debug	L 55
 	mov	 [bp-4], eax
;	?debug	L 57
 	mov	 dx, [[bp-4] + 2]
;	?debug	L 58
 	mov	 ax, [[bp-4]]
	jmp	short @1
@1:
;	?debug	L 60
	mov	sp,bp
	pop	bp
	ret	
_AddressCompare	endp
;	?debug	L 65
_ULCompare	proc	near
	push	bp
	mov	bp,sp
;	?debug	L 67
 	mov	 eax, [bp+4]
;	?debug	L 68
 	mov	 ebx, [bp+8]
;	?debug	L 69
 	sub	 eax, ebx
;	?debug	L 70
 	ja	 @3
;	?debug	L 71
 	jb	 @4
;	?debug	L 72
	xor	ax,ax
	jmp	short @2
@3:
;	?debug	L 74
	mov	ax,1
	jmp	short @2
@4:
;	?debug	L 76
	mov	ax,-1
	jmp	short @2
@2:
;	?debug	L 77
	pop	bp
	ret	
_ULCompare	endp
;	?debug	L 81
_ULAddition	proc	near
	push	bp
	mov	bp,sp
	sub	sp,4
;	?debug	L 84
 	mov	 eax, [bp+4]
;	?debug	L 85
 	mov	 ebx, [bp+8]
;	?debug	L 86
 	add	 eax, ebx
;	?debug	L 87
 	mov	 [bp-4], eax
;	?debug	L 88
 	mov	 dx, [[bp-4] + 2]
	jmp	short @5
@5:
;	?debug	L 91
	mov	sp,bp
	pop	bp
	ret	
_ULAddition	endp
;	?debug	L 93
_MemoryCopy	proc	near
	push	bp
	mov	bp,sp
	push	si
	push	di
;	?debug	L 95
 	push	 es
;	?debug	L 96
 	push	 ds
;	?debug	L 97
 	push	 si
;	?debug	L 98
 	push	 di
;	?debug	L 100
 	lds	 si, [bp+8]
;	?debug	L 101
 	les	 di, [bp+4]
;	?debug	L 104
 	push	 dword ptr [bp+8]
;	?debug	L 105
 	push	 dword ptr [bp+4]
;	?debug	L 106
 	call	 _AddressCompare
;	?debug	L 107
 	add	 sp, 8
;	?debug	L 109
 	mov	 cx, [bp+12]
;	?debug	L 112
 	test	 dx, dx
;	?debug	L 114
 	jns	 @7
;	?debug	L 115
 	cld	
;	?debug	L 116
 	jmp	 @8
@7:
;	?debug	L 118
 	std	
;	?debug	L 119
 	dec	 word ptr [bp+12]
;	?debug	L 120
 	add	 si, [bp+12]
;	?debug	L 121
 	add	 di, [bp+12]
@8:
;	?debug	L 123
 	rep movsb	
;	?debug	L 125
 	pop	 di
;	?debug	L 126
 	pop	 si
;	?debug	L 127
 	pop	 ds
;	?debug	L 128
 	pop	 es
;	?debug	L 130
	mov	ax,word ptr [bp+12]
	jmp	short @6
@6:
;	?debug	L 131
	pop	di
	pop	si
	pop	bp
	ret	
_MemoryCopy	endp
;	?debug	L 136
_SegmentCopy	proc	near
	push	bp
	mov	bp,sp
;	?debug	L 139
 	push	 word ptr [bp+10]
;	?debug	L 140
 	push	 word ptr [bp+4]
;	?debug	L 141
 	push	 word ptr [bp+8]
;	?debug	L 142
 	push	 word ptr [bp+4]
;	?debug	L 143
 	push	 word ptr [bp+6]
;	?debug	L 144
 	call	 _MemoryCopy
;	?debug	L 145
 	add	 sp, 10
	jmp	short @9
@9:
;	?debug	L 147
	pop	bp
	ret	
_SegmentCopy	endp
;	?debug	L 151
_SegmentSet	proc	near
	push	bp
	mov	bp,sp
	push	si
	push	di
;	?debug	L 153
 	push	 di
;	?debug	L 154
 	push	 es
;	?debug	L 155
 	les	 di, [bp+4]
;	?debug	L 156
 	mov	 al, byte ptr [bp+8]
;	?debug	L 157
 	mov	 cx, [bp+10]
;	?debug	L 158
 	cld	
;	?debug	L 159
 	rep stosb	
;	?debug	L 160
 	pop	 es
;	?debug	L 161
 	pop	 di
	jmp	short @10
@10:
;	?debug	L 163
	pop	di
	pop	si
	pop	bp
	ret	
_SegmentSet	endp
;	?debug	L 167
_SegmentSetWord	proc	near
	push	bp
	mov	bp,sp
	push	si
	push	di
;	?debug	L 169
 	push	 di
;	?debug	L 170
 	push	 es
;	?debug	L 171
 	les	 di, [bp+4]
;	?debug	L 172
 	mov	 ax, word ptr [bp+8]
;	?debug	L 173
 	mov	 cx, [bp+10]
;	?debug	L 174
 	cld	
;	?debug	L 175
 	rep stosw	
;	?debug	L 176
 	pop	 es
;	?debug	L 177
 	pop	 di
	jmp	short @11
@11:
;	?debug	L 179
	pop	di
	pop	si
	pop	bp
	ret	
_SegmentSetWord	endp
;	?debug	L 183
_DetectLowMemory	proc	near
;	?debug	L 185
 	xor	 ax, ax
;	?debug	L 186
 	int	 12h
;	?debug	L 187
 	jc	 @13
;	?debug	L 188
 	test	 ax, ax
;	?debug	L 189
 	jz	 @13
;	?debug	L 191
 	mov	 DGROUP:_basic_mem_size, ax
	jmp	short @12
@13:
;	?debug	L 195
 	xor	 ax, ax
;	?debug	L 196
 	dec	 ax
	jmp	short @12
@12:
;	?debug	L 198
	ret	
_DetectLowMemory	endp
;	?debug	L 200
_DetectHighMemory	proc	near
	push	bp
	mov	bp,sp
	sub	sp,4
	push	si
	push	di
;	?debug	L 203
 	push	 es
;	?debug	L 204
 	push	 di
;	?debug	L 206
 	les	 di, [bp+4]
;	?debug	L 207
 	xor	 eax, eax
;	?debug	L 208
 	mov	 edx, 534D4150h
;	?debug	L 209
 	mov	 ax, 0E820h
;	?debug	L 210
 	mov	 ecx, 24
;	?debug	L 211
 	mov	 ebx, [bp+8]
;	?debug	L 212
 	int	 15h
;	?debug	L 213
 	cmp	 eax, 534D4150h
;	?debug	L 214
 	jnz	 @15
;	?debug	L 215
 	jc	 @15
;	?debug	L 217
 	mov	 [bp-4], ebx
;	?debug	L 219
 	mov	 ax, bx
;	?debug	L 221
 	mov	 dx, [[bp-4] + 2]
;	?debug	L 223
 	pop	 di
;	?debug	L 224
 	pop	 es
	jmp	short @14
@15:
;	?debug	L 227
 	xor	 ax, ax
;	?debug	L 228
 	dec	 ax
;	?debug	L 229
 	mov	 dx, ax
;	?debug	L 230
 	pop	 di
;	?debug	L 231
 	pop	 es
	jmp	short @14
@14:
;	?debug	L 233
	pop	di
	pop	si
	mov	sp,bp
	pop	bp
	ret	
_DetectHighMemory	endp
_TEXT	ends
_DATA	segment word public 'DATA'
_DATA	ends
_TEXT	segment	byte public 'CODE'
;	?debug	L 237
_PrintMemoryMap	proc	near
	push	bp
	mov	bp,sp
	sub	sp,32
;	?debug	L 239
	mov	word ptr [bp-30],0
	mov	word ptr [bp-32],0
;	?debug	L 242
	mov	byte ptr [bp-4],32
;	?debug	L 243
	mov	byte ptr [bp-3],124
;	?debug	L 244
	mov	byte ptr [bp-2],32
;	?debug	L 245
	mov	byte ptr [bp-1],0
;	?debug	L 246
	push	ds
	mov	ax,offset DGROUP:_equal_16
	push	ax
	push	ds
	mov	ax,offset DGROUP:_equal_16
	push	ax
	mov	ax,offset DGROUP:s@
	push	ax
	call	near ptr _Printf
	add	sp,10
;	?debug	L 247
	push	ds
	mov	ax,offset DGROUP:s@+20
	push	ax
	call	near ptr _PutString
	pop	cx
	pop	cx
@19:
;	?debug	L 250
	push	word ptr [bp-30]
	push	word ptr [bp-32]
	push	ss
	lea	ax,word ptr [bp-28]
	push	ax
	call	near ptr _DetectHighMemory
	add	sp,8
	mov	word ptr [bp-30],dx
	mov	word ptr [bp-32],ax
;	?debug	L 251
	cmp	word ptr [bp-30],-1
	jne	@20
	cmp	word ptr [bp-32],-1
	jne	@20
@21:
	mov	ax,-1
	jmp	short @16
@20:
;	?debug	L 252
	push	word ptr [bp-22]
	push	word ptr [bp-24]
	call	near ptr _PrintLongHex
	pop	cx
	pop	cx
;	?debug	L 253
	push	word ptr [bp-26]
	push	word ptr [bp-28]
	call	near ptr _PrintLongHex
	pop	cx
	pop	cx
;	?debug	L 254
	push	ss
	lea	ax,word ptr [bp-4]
	push	ax
	call	near ptr _PutString
	pop	cx
	pop	cx
;	?debug	L 255
	push	word ptr [bp-14]
	push	word ptr [bp-16]
	call	near ptr _PrintLongHex
	pop	cx
	pop	cx
;	?debug	L 256
	push	word ptr [bp-18]
	push	word ptr [bp-20]
	call	near ptr _PrintLongHex
	pop	cx
	pop	cx
;	?debug	L 257
	push	ss
	lea	ax,word ptr [bp-4]
	push	ax
	call	near ptr _PutString
	pop	cx
	pop	cx
;	?debug	L 258
	push	word ptr [bp-10]
	push	word ptr [bp-12]
	call	near ptr _PrintLongHex
	pop	cx
	pop	cx
;	?debug	L 259
	mov	al,10
	push	ax
	call	near ptr _PutChar
	pop	cx
@17:
;	?debug	L 260
	mov	ax,word ptr [bp-32]
	or	ax,word ptr [bp-30]
	je	@22
	jmp	@19
@22:
@18:
;	?debug	L 261
	xor	ax,ax
	jmp	short @16
@16:
;	?debug	L 262
	mov	sp,bp
	pop	bp
	ret	
_PrintMemoryMap	endp
;	?debug	L 264
_GetMemoryNode	proc	near
	push	bp
	mov	bp,sp
;	?debug	L 266
	mov	ax,word ptr [bp+4]
	mov	cl,4
	shl	ax,cl
	push	ax
	mov	dx,word ptr DGROUP:_sys_mem_ptr+2
	mov	ax,word ptr DGROUP:_sys_mem_ptr
	pop	bx
	add	ax,bx
	jmp	short @23
@23:
;	?debug	L 267
	pop	bp
	ret	
_GetMemoryNode	endp
_TEXT	ends
_DATA	segment word public 'DATA'
_DATA	ends
_TEXT	segment	byte public 'CODE'
;	?debug	L 269
_PrintAllMemory	proc	near
	push	bp
	mov	bp,sp
	sub	sp,2
;	?debug	L 271
	call	near ptr _DetectLowMemory
	mov	word ptr [bp-2],ax
;	?debug	L 272
	push	word ptr [bp-2]
	mov	ax,offset DGROUP:s@+64
	push	ax
	call	near ptr _Printf
	pop	cx
	pop	cx
;	?debug	L 273
	call	near ptr _PrintMemoryMap
	jmp	short @24
@24:
;	?debug	L 274
	mov	sp,bp
	pop	bp
	ret	
_PrintAllMemory	endp
;	?debug	L 280
_FindUnusedMemoryNode	proc	near
	push	bp
	mov	bp,sp
	sub	sp,4
	push	si
;	?debug	L 282
	les	bx,dword ptr DGROUP:_sys_mem_ptr
	mov	word ptr [bp-2],es
	mov	word ptr [bp-4],bx
;	?debug	L 285
	xor	si,si
	jmp	short @29
@28:
;	?debug	L 287
	les	bx,dword ptr [bp-4]
	test	word ptr es:[bx+14],2
	jne	@30
;	?debug	L 289
	dec	word ptr DGROUP:_mem_slot_remain
;	?debug	L 290
	les	bx,dword ptr [bp-4]
	or	word ptr es:[bx+14],2
;	?debug	L 291
	mov	ax,si
	jmp	short @25
@30:
;	?debug	L 293
	add	word ptr [bp-4],16
@27:
	inc	si
@29:
	cmp	si,word ptr DGROUP:_mem_slot_num
	jl	@28
@26:
;	?debug	L 295
	mov	ax,-1
	jmp	short @25
@25:
;	?debug	L 296
	pop	si
	mov	sp,bp
	pop	bp
	ret	
_FindUnusedMemoryNode	endp
;	?debug	L 301
_AddUnusedMemoryNode	proc	near
	push	bp
	mov	bp,sp
	sub	sp,4
;	?debug	L 303
	les	bx,dword ptr DGROUP:_sys_mem_ptr
	mov	word ptr [bp-2],es
	mov	word ptr [bp-4],bx
;	?debug	L 304
	mov	ax,word ptr [bp+4]
	mov	cl,4
	shl	ax,cl
	les	bx,dword ptr [bp-4]
	add	bx,ax
	and	word ptr es:[bx+14],-3
;	?debug	L 305
	inc	word ptr DGROUP:_mem_slot_remain
;	?debug	L 306
	xor	ax,ax
	jmp	short @31
@31:
;	?debug	L 307
	mov	sp,bp
	pop	bp
	ret	
_AddUnusedMemoryNode	endp
;	?debug	L 313
_MarkMemoryBlock	proc	near
	push	bp
	mov	bp,sp
	sub	sp,26
	push	si
	push	di
;	?debug	L 316
	les	bx,dword ptr DGROUP:_sys_mem_ptr
	mov	word ptr [bp-24],es
	mov	word ptr [bp-26],bx
;	?debug	L 318
	les	bx,dword ptr [bp-26]
	mov	word ptr [bp-20],es
	mov	word ptr [bp-22],bx
;	?debug	L 320
	mov	word ptr [bp-18],0
;	?debug	L 333
	cmp	word ptr DGROUP:_current_proc,0
	je	@33
	mov	ax,word ptr [bp+12]
	cmp	ax,word ptr DGROUP:_current_proc
	je	@33
	mov	ax,-1
	jmp	@32
@33:
@36:
;	?debug	L 337
	les	bx,dword ptr [bp-22]
	mov	ax,word ptr es:[bx+10]
	mov	word ptr [bp-18],ax
;	?debug	L 338
	les	bx,dword ptr [bp-22]
	mov	ax,word ptr es:[bx+10]
	mov	cl,4
	shl	ax,cl
	les	bx,dword ptr [bp-26]
	add	bx,ax
	mov	word ptr [bp-20],es
	mov	word ptr [bp-22],bx
;	?debug	L 340
	mov	dx,-1
	mov	ax,-1
	push	dx
	push	ax
	push	word ptr [bp+10]
	push	word ptr [bp+8]
	push	word ptr [bp+6]
	push	word ptr [bp+4]
	call	near ptr _ULAddition
	add	sp,8
	push	dx
	push	ax
	call	near ptr _ULAddition
	add	sp,8
	mov	word ptr [bp-2],dx
	mov	word ptr [bp-4],ax
;	?debug	L 342
	push	word ptr [bp-2]
	push	word ptr [bp-4]
	les	bx,dword ptr [bp-22]
	push	word ptr es:[bx+6]
	push	word ptr es:[bx+4]
	call	near ptr _ULCompare
	add	sp,8
	mov	si,ax
;	?debug	L 343
	les	bx,dword ptr [bp-22]
	push	word ptr es:[bx+2]
	push	word ptr es:[bx]
	push	word ptr [bp+6]
	push	word ptr [bp+4]
	call	near ptr _ULCompare
	add	sp,8
	mov	di,ax
;	?debug	L 345
	cmp	di,-1
	jne	@48
	jmp	@37
@48:
	cmp	si,-1
	jne	@49
	jmp	@37
@49:
;	?debug	L 348
	les	bx,dword ptr [bp-22]
	cmp	word ptr es:[bx+10],-1
	je	@38
	les	bx,dword ptr [bp-22]
	mov	ax,word ptr es:[bx+12]
	les	bx,dword ptr [bp-22]
	mov	dx,word ptr es:[bx+10]
	mov	cl,4
	shl	dx,cl
	les	bx,dword ptr [bp-26]
	add	bx,dx
	mov	word ptr es:[bx+12],ax
@38:
;	?debug	L 349
	les	bx,dword ptr [bp-22]
	cmp	word ptr es:[bx+12],-1
	je	@39
	les	bx,dword ptr [bp-22]
	mov	ax,word ptr es:[bx+10]
	les	bx,dword ptr [bp-22]
	mov	dx,word ptr es:[bx+12]
	mov	cl,4
	shl	dx,cl
	les	bx,dword ptr [bp-26]
	add	bx,dx
	mov	word ptr es:[bx+10],ax
@39:
;	?debug	L 351
	or	di,di
	jne	@50
	jmp	@40
@50:
;	?debug	L 354
	call	near ptr _FindUnusedMemoryNode
	mov	word ptr [bp-8],ax
;	?debug	L 357
	cmp	word ptr [bp-8],-1
	jne	@41
	push	ds
	mov	ax,offset DGROUP:_mem_slot_full_msg
	push	ax
	call	near ptr _FatalError
	pop	cx
	pop	cx
@41:
;	?debug	L 358
	mov	ax,word ptr [bp-8]
	mov	cl,4
	shl	ax,cl
	les	bx,dword ptr [bp-26]
	add	bx,ax
	mov	word ptr [bp-14],es
	mov	word ptr [bp-16],bx
;	?debug	L 359
	les	bx,dword ptr [bp-22]
	mov	dx,word ptr es:[bx+2]
	mov	ax,word ptr es:[bx]
	les	bx,dword ptr [bp-16]
	mov	word ptr es:[bx+2],dx
	mov	word ptr es:[bx],ax
;	?debug	L 361
	mov	dx,-1
	mov	ax,-1
	push	dx
	push	ax
	push	word ptr [bp+6]
	push	word ptr [bp+4]
	call	near ptr _ULAddition
	add	sp,8
	les	bx,dword ptr [bp-16]
	mov	word ptr es:[bx+6],dx
	mov	word ptr es:[bx+4],ax
;	?debug	L 362
	les	bx,dword ptr [bp-22]
	mov	ax,word ptr es:[bx+8]
	les	bx,dword ptr [bp-16]
	mov	word ptr es:[bx+8],ax
;	?debug	L 364
	les	bx,dword ptr [bp-22]
	mov	ax,word ptr es:[bx+14]
	les	bx,dword ptr [bp-16]
	mov	word ptr es:[bx+14],ax
;	?debug	L 366
	les	bx,dword ptr [bp-22]
	mov	ax,word ptr es:[bx+10]
	les	bx,dword ptr [bp-16]
	mov	word ptr es:[bx+10],ax
;	?debug	L 367
	les	bx,dword ptr [bp-22]
	mov	ax,word ptr es:[bx+12]
	les	bx,dword ptr [bp-16]
	mov	word ptr es:[bx+12],ax
;	?debug	L 369
	les	bx,dword ptr [bp-22]
	cmp	word ptr es:[bx+12],-1
	je	@42
	mov	ax,word ptr [bp-8]
	les	bx,dword ptr [bp-22]
	mov	dx,word ptr es:[bx+12]
	mov	cl,4
	shl	dx,cl
	les	bx,dword ptr [bp-26]
	add	bx,dx
	mov	word ptr es:[bx+10],ax
@42:
;	?debug	L 370
	les	bx,dword ptr [bp-22]
	cmp	word ptr es:[bx+10],-1
	je	@43
	mov	ax,word ptr [bp-8]
	les	bx,dword ptr [bp-22]
	mov	dx,word ptr es:[bx+10]
	mov	cl,4
	shl	dx,cl
	les	bx,dword ptr [bp-26]
	add	bx,dx
	mov	word ptr es:[bx+12],ax
@43:
;	?debug	L 371
	mov	dx,word ptr [bp+6]
	mov	ax,word ptr [bp+4]
	les	bx,dword ptr [bp-22]
	mov	word ptr es:[bx+2],dx
	mov	word ptr es:[bx],ax
;	?debug	L 372
	mov	ax,word ptr [bp-8]
	les	bx,dword ptr [bp-22]
	mov	word ptr es:[bx+12],ax
@40:
;	?debug	L 374
	or	si,si
	jne	@51
	jmp	@44
@51:
;	?debug	L 376
	call	near ptr _FindUnusedMemoryNode
	mov	word ptr [bp-6],ax
;	?debug	L 377
	cmp	word ptr [bp-6],-1
	jne	@45
	push	ds
	mov	ax,offset DGROUP:_mem_slot_full_msg
	push	ax
	call	near ptr _FatalError
	pop	cx
	pop	cx
@45:
;	?debug	L 378
	mov	ax,word ptr [bp-6]
	mov	cl,4
	shl	ax,cl
	les	bx,dword ptr [bp-26]
	add	bx,ax
	mov	word ptr [bp-10],es
	mov	word ptr [bp-12],bx
;	?debug	L 379
	xor	dx,dx
	mov	ax,1
	push	dx
	push	ax
	push	word ptr [bp-2]
	push	word ptr [bp-4]
	call	near ptr _ULAddition
	add	sp,8
	les	bx,dword ptr [bp-12]
	mov	word ptr es:[bx+2],dx
	mov	word ptr es:[bx],ax
;	?debug	L 380
	les	bx,dword ptr [bp-22]
	mov	dx,word ptr es:[bx+6]
	mov	ax,word ptr es:[bx+4]
	les	bx,dword ptr [bp-12]
	mov	word ptr es:[bx+6],dx
	mov	word ptr es:[bx+4],ax
;	?debug	L 381
	les	bx,dword ptr [bp-22]
	mov	ax,word ptr es:[bx+8]
	les	bx,dword ptr [bp-12]
	mov	word ptr es:[bx+8],ax
;	?debug	L 382
	les	bx,dword ptr [bp-22]
	mov	ax,word ptr es:[bx+14]
	les	bx,dword ptr [bp-12]
	mov	word ptr es:[bx+14],ax
;	?debug	L 383
	les	bx,dword ptr [bp-22]
	mov	ax,word ptr es:[bx+10]
	les	bx,dword ptr [bp-12]
	mov	word ptr es:[bx+10],ax
;	?debug	L 384
	les	bx,dword ptr [bp-22]
	mov	ax,word ptr es:[bx+12]
	les	bx,dword ptr [bp-12]
	mov	word ptr es:[bx+12],ax
;	?debug	L 386
	les	bx,dword ptr [bp-22]
	cmp	word ptr es:[bx+12],-1
	je	@46
	mov	ax,word ptr [bp-6]
	les	bx,dword ptr [bp-22]
	mov	dx,word ptr es:[bx+12]
	mov	cl,4
	shl	dx,cl
	les	bx,dword ptr [bp-26]
	add	bx,dx
	mov	word ptr es:[bx+10],ax
@46:
;	?debug	L 387
	les	bx,dword ptr [bp-22]
	cmp	word ptr es:[bx+10],-1
	je	@47
	mov	ax,word ptr [bp-6]
	les	bx,dword ptr [bp-22]
	mov	dx,word ptr es:[bx+10]
	mov	cl,4
	shl	dx,cl
	les	bx,dword ptr [bp-26]
	add	bx,dx
	mov	word ptr es:[bx+12],ax
@47:
;	?debug	L 388
	mov	dx,word ptr [bp-2]
	mov	ax,word ptr [bp-4]
	les	bx,dword ptr [bp-22]
	mov	word ptr es:[bx+6],dx
	mov	word ptr es:[bx+4],ax
@44:
;	?debug	L 391
	les	bx,dword ptr [bp-22]
	mov	word ptr es:[bx+10],-1
;	?debug	L 392
	les	bx,dword ptr [bp-22]
	mov	word ptr es:[bx+12],-1
;	?debug	L 393
	les	bx,dword ptr [bp-22]
	or	word ptr es:[bx+14],1
;	?debug	L 394
	mov	ax,word ptr [bp+12]
	les	bx,dword ptr [bp-22]
	mov	word ptr es:[bx+8],ax
;	?debug	L 395
	mov	ax,word ptr [bp-18]
	jmp	short @32
@37:
@34:
;	?debug	L 397
	les	bx,dword ptr [bp-22]
	cmp	word ptr es:[bx+10],-1
	je	@52
	jmp	@36
@52:
@35:
;	?debug	L 399
	mov	ax,-1
	jmp	short @32
@32:
;	?debug	L 400
	pop	di
	pop	si
	mov	sp,bp
	pop	bp
	ret	
_MarkMemoryBlock	endp
;	?debug	L 402
_UnmarkMemoryBlock	proc	near
	push	bp
	mov	bp,sp
	sub	sp,22
	push	si
	push	di
;	?debug	L 404
	les	bx,dword ptr DGROUP:_sys_mem_ptr
	mov	word ptr [bp-20],es
	mov	word ptr [bp-22],bx
;	?debug	L 405
	mov	ax,word ptr [bp+4]
	mov	cl,4
	shl	ax,cl
	les	bx,dword ptr [bp-22]
	add	bx,ax
	mov	word ptr [bp-16],es
	mov	word ptr [bp-18],bx
;	?debug	L 406
	les	bx,dword ptr [bp-22]
	mov	word ptr [bp-12],es
	mov	word ptr [bp-14],bx
;	?debug	L 410
	xor	si,si
;	?debug	L 414
	mov	ax,word ptr [bp+4]
	cmp	ax,word ptr DGROUP:_mem_slot_num
	jb	@54
	mov	ax,-1
	jmp	@53
@54:
;	?debug	L 416
	mov	ax,word ptr [bp+4]
	mov	cl,4
	shl	ax,cl
	les	bx,dword ptr [bp-22]
	add	bx,ax
	mov	ax,word ptr es:[bx+14]
	neg	ax
	sbb	ax,ax
	inc	ax
	test	ax,2
	je	@55
	mov	ax,-1
	jmp	@53
@55:
@58:
;	?debug	L 420
	les	bx,dword ptr [bp-14]
	mov	ax,word ptr es:[bx+10]
	mov	word ptr [bp-6],ax
;	?debug	L 421
	mov	ax,word ptr [bp-6]
	mov	cl,4
	shl	ax,cl
	les	bx,dword ptr [bp-22]
	add	bx,ax
	mov	word ptr [bp-12],es
	mov	word ptr [bp-14],bx
;	?debug	L 424
	les	bx,dword ptr [bp-18]
	push	word ptr es:[bx+6]
	push	word ptr es:[bx+4]
	les	bx,dword ptr [bp-14]
	push	word ptr es:[bx+2]
	push	word ptr es:[bx]
	call	near ptr _ULCompare
	add	sp,8
	mov	di,ax
;	?debug	L 425
	cmp	di,-1
	je	@59
;	?debug	L 427
	mov	ax,word ptr [bp+4]
	les	bx,dword ptr [bp-14]
	mov	dx,word ptr es:[bx+12]
	mov	cl,4
	shl	dx,cl
	les	bx,dword ptr [bp-22]
	add	bx,dx
	mov	word ptr es:[bx+10],ax
;	?debug	L 428
	les	bx,dword ptr [bp-14]
	mov	ax,word ptr es:[bx+12]
	les	bx,dword ptr [bp-18]
	mov	word ptr es:[bx+12],ax
;	?debug	L 429
	mov	ax,word ptr [bp+4]
	les	bx,dword ptr [bp-14]
	mov	word ptr es:[bx+12],ax
;	?debug	L 430
	mov	ax,word ptr [bp-6]
	les	bx,dword ptr [bp-18]
	mov	word ptr es:[bx+10],ax
;	?debug	L 431
	jmp	short @57
;	?debug	L 432
	jmp	short @60
@59:
;	?debug	L 434
	les	bx,dword ptr [bp-14]
	cmp	word ptr es:[bx+10],-1
	jne	@61
;	?debug	L 436
	mov	ax,word ptr [bp+4]
	les	bx,dword ptr [bp-14]
	mov	word ptr es:[bx+10],ax
;	?debug	L 437
	mov	ax,word ptr [bp-6]
	les	bx,dword ptr [bp-18]
	mov	word ptr es:[bx+12],ax
;	?debug	L 438
	les	bx,dword ptr [bp-18]
	mov	word ptr es:[bx+10],-1
;	?debug	L 439
	jmp	short @57
@61:
@60:
@56:
;	?debug	L 441
	jmp	@58
@57:
;	?debug	L 443
	les	bx,dword ptr [bp-18]
	and	word ptr es:[bx+14],-2
@64:
;	?debug	L 447
	xor	si,si
;	?debug	L 448
	les	bx,dword ptr [bp-18]
	cmp	word ptr es:[bx+12],-1
	jne	@71
	jmp	@65
@71:
;	?debug	L 451
	les	bx,dword ptr [bp-18]
	mov	ax,word ptr es:[bx+12]
	mov	cl,4
	shl	ax,cl
	les	bx,dword ptr [bp-22]
	add	bx,ax
	mov	word ptr [bp-8],es
	mov	word ptr [bp-10],bx
;	?debug	L 452
	les	bx,dword ptr [bp-18]
	mov	ax,word ptr es:[bx+12]
	mov	word ptr [bp-4],ax
;	?debug	L 453
	xor	dx,dx
	mov	ax,1
	push	dx
	push	ax
	les	bx,dword ptr [bp-10]
	push	word ptr es:[bx+6]
	push	word ptr es:[bx+4]
	call	near ptr _ULAddition
	add	sp,8
	push	dx
	push	ax
	les	bx,dword ptr [bp-18]
	push	word ptr es:[bx+2]
	push	word ptr es:[bx]
	call	near ptr _ULCompare
	add	sp,8
	mov	word ptr [bp-2],ax
;	?debug	L 455
	cmp	word ptr [bp-2],0
	jne	@66
;	?debug	L 457
	inc	si
;	?debug	L 458
	les	bx,dword ptr [bp-10]
	mov	dx,word ptr es:[bx+2]
	mov	ax,word ptr es:[bx]
	les	bx,dword ptr [bp-18]
	mov	word ptr es:[bx+2],dx
	mov	word ptr es:[bx],ax
;	?debug	L 459
	les	bx,dword ptr [bp-10]
	mov	ax,word ptr es:[bx+12]
	les	bx,dword ptr [bp-18]
	mov	word ptr es:[bx+12],ax
;	?debug	L 460
	les	bx,dword ptr [bp-10]
	cmp	word ptr es:[bx+12],-1
	je	@67
	mov	ax,word ptr [bp+4]
	les	bx,dword ptr [bp-10]
	mov	dx,word ptr es:[bx+12]
	mov	cl,4
	shl	dx,cl
	les	bx,dword ptr [bp-22]
	add	bx,dx
	mov	word ptr es:[bx+10],ax
@67:
;	?debug	L 462
	push	word ptr [bp-4]
	call	near ptr _AddUnusedMemoryNode
	pop	cx
@66:
@65:
;	?debug	L 465
	les	bx,dword ptr [bp-18]
	cmp	word ptr es:[bx+10],-1
	jne	@72
	jmp	@68
@72:
;	?debug	L 468
	les	bx,dword ptr [bp-18]
	mov	ax,word ptr es:[bx+10]
	mov	cl,4
	shl	ax,cl
	les	bx,dword ptr [bp-22]
	add	bx,ax
	mov	word ptr [bp-8],es
	mov	word ptr [bp-10],bx
;	?debug	L 469
	les	bx,dword ptr [bp-18]
	mov	ax,word ptr es:[bx+10]
	mov	word ptr [bp-4],ax
;	?debug	L 470
	les	bx,dword ptr [bp-10]
	push	word ptr es:[bx+2]
	push	word ptr es:[bx]
	xor	dx,dx
	mov	ax,1
	push	dx
	push	ax
	les	bx,dword ptr [bp-18]
	push	word ptr es:[bx+6]
	push	word ptr es:[bx+4]
	call	near ptr _ULAddition
	add	sp,8
	push	dx
	push	ax
	call	near ptr _ULCompare
	add	sp,8
	mov	di,ax
;	?debug	L 472
	or	di,di
	jne	@69
;	?debug	L 474
	inc	si
;	?debug	L 475
	les	bx,dword ptr [bp-10]
	mov	dx,word ptr es:[bx+6]
	mov	ax,word ptr es:[bx+4]
	les	bx,dword ptr [bp-18]
	mov	word ptr es:[bx+6],dx
	mov	word ptr es:[bx+4],ax
;	?debug	L 476
	les	bx,dword ptr [bp-10]
	mov	ax,word ptr es:[bx+10]
	les	bx,dword ptr [bp-18]
	mov	word ptr es:[bx+10],ax
;	?debug	L 479
	les	bx,dword ptr [bp-10]
	cmp	word ptr es:[bx+10],-1
	je	@70
	mov	ax,word ptr [bp+4]
	les	bx,dword ptr [bp-10]
	mov	dx,word ptr es:[bx+10]
	mov	cl,4
	shl	dx,cl
	les	bx,dword ptr [bp-22]
	add	bx,dx
	mov	word ptr es:[bx+12],ax
@70:
;	?debug	L 480
	push	word ptr [bp-4]
	call	near ptr _AddUnusedMemoryNode
	pop	cx
@69:
@68:
@62:
;	?debug	L 483
	or	si,si
	je	@73
	jmp	@64
@73:
@63:
;	?debug	L 485
	xor	ax,ax
	jmp	short @53
@53:
;	?debug	L 486
	pop	di
	pop	si
	mov	sp,bp
	pop	bp
	ret	
_UnmarkMemoryBlock	endp
;	?debug	L 490
_InitMemoryTable	proc	near
	push	bp
	mov	bp,sp
	sub	sp,18
	push	si
;	?debug	L 500
	les	bx,dword ptr DGROUP:_sys_mem_avail
	mov	word ptr DGROUP:_sys_mem_ptr+2,es
	mov	word ptr DGROUP:_sys_mem_ptr,bx
;	?debug	L 501
	les	bx,dword ptr DGROUP:_sys_mem_ptr
	mov	word ptr [bp-8],es
	mov	word ptr [bp-10],bx
;	?debug	L 504
	mov	ax,word ptr [bp+4]
	mov	word ptr DGROUP:_mem_slot_num,ax
;	?debug	L 506
	les	bx,dword ptr [bp-10]
	mov	word ptr es:[bx+2],0
	mov	word ptr es:[bx],0
;	?debug	L 507
	les	bx,dword ptr [bp-10]
	mov	word ptr es:[bx+6],0
	mov	word ptr es:[bx+4],0
;	?debug	L 508
	les	bx,dword ptr [bp-10]
	mov	word ptr es:[bx+10],1
;	?debug	L 509
	les	bx,dword ptr [bp-10]
	mov	word ptr es:[bx+12],-1
;	?debug	L 510
	les	bx,dword ptr [bp-10]
	mov	word ptr es:[bx+14],2
;	?debug	L 511
	add	word ptr [bp-10],16
;	?debug	L 513
	les	bx,dword ptr [bp-10]
	mov	word ptr es:[bx+2],0
	mov	word ptr es:[bx],1280
;	?debug	L 517
 	xor	 eax, eax
;	?debug	L 518
 	mov	 ax, DGROUP:_basic_mem_size
;	?debug	L 519
 	shl	 eax, 10
;	?debug	L 520
 	dec	 eax
;	?debug	L 521
 	mov	 [bp-18], eax
;	?debug	L 522
	mov	dx,word ptr [bp-16]
	mov	ax,word ptr [bp-18]
	les	bx,dword ptr [bp-10]
	mov	word ptr es:[bx+6],dx
	mov	word ptr es:[bx+4],ax
;	?debug	L 524
	les	bx,dword ptr [bp-10]
	mov	word ptr es:[bx+10],-1
;	?debug	L 525
	les	bx,dword ptr [bp-10]
	mov	word ptr es:[bx+12],0
;	?debug	L 527
	les	bx,dword ptr [bp-10]
	mov	word ptr es:[bx+14],2
;	?debug	L 528
	add	word ptr [bp-10],16
;	?debug	L 531
	mov	si,2
	jmp	short @78
@77:
;	?debug	L 533
	les	bx,dword ptr [bp-10]
	mov	word ptr es:[bx+2],0
	mov	word ptr es:[bx],0
;	?debug	L 534
	les	bx,dword ptr [bp-10]
	mov	word ptr es:[bx+6],0
	mov	word ptr es:[bx+4],0
;	?debug	L 535
	les	bx,dword ptr [bp-10]
	mov	word ptr es:[bx+10],-1
;	?debug	L 536
	les	bx,dword ptr [bp-10]
	mov	word ptr es:[bx+12],-1
;	?debug	L 537
	les	bx,dword ptr [bp-10]
	mov	word ptr es:[bx+14],0
;	?debug	L 538
	add	word ptr [bp-10],16
@76:
	inc	si
@78:
	cmp	si,word ptr DGROUP:_mem_slot_num
	jl	@77
@75:
;	?debug	L 541
	xor	ax,ax
	push	ax
	mov	dx,1
	xor	ax,ax
	push	dx
	push	ax
	mov	dx,7
	xor	ax,ax
	push	dx
	push	ax
	call	near ptr _MarkMemoryBlock
	add	sp,10
	mov	word ptr [bp-14],ax
;	?debug	L 543
	xor	ax,ax
	push	ax
	mov	dx,1
	xor	ax,ax
	push	dx
	push	ax
	mov	dx,8
	xor	ax,ax
	push	dx
	push	ax
	call	near ptr _MarkMemoryBlock
	add	sp,10
	mov	word ptr [bp-12],ax
;	?debug	L 544
	push	word ptr [bp-12]
	call	near ptr _UnmarkMemoryBlock
	pop	cx
;	?debug	L 545
	push	word ptr [bp-14]
	call	near ptr _UnmarkMemoryBlock
	pop	cx
;	?debug	L 546
	xor	ax,ax
	push	ax
	mov	dx,1
	xor	ax,ax
	push	dx
	push	ax
	mov	dx,7
	xor	ax,ax
	push	dx
	push	ax
	call	near ptr _MarkMemoryBlock
	add	sp,10
	mov	word ptr [bp-14],ax
;	?debug	L 547
	xor	ax,ax
	push	ax
	mov	dx,1
	xor	ax,ax
	push	dx
	push	ax
	mov	dx,8
	xor	ax,ax
	push	dx
	push	ax
	call	near ptr _MarkMemoryBlock
	add	sp,10
	mov	word ptr [bp-12],ax
;	?debug	L 548
	xor	dx,dx
	mov	ax,288
	push	dx
	push	ax
	call	near ptr _MemoryAllocation
	pop	cx
	pop	cx
	mov	word ptr [bp-4],dx
	mov	word ptr [bp-6],ax
;	?debug	L 549
	push	word ptr [bp-4]
	push	word ptr [bp-6]
	call	near ptr _MemoryFree
	pop	cx
	pop	cx
;	?debug	L 550
	call	near ptr _PrintMemoryTable
;	?debug	L 551
	call	near ptr _PrintMemoryNode
;	?debug	L 553
	mov	ax,word ptr [bp+4]
	mov	cl,4
	shl	ax,cl
	mov	word ptr [bp-2],ax
;	?debug	L 555
	mov	ax,word ptr [bp-2]
	add	word ptr DGROUP:_sys_mem_avail,ax
;	?debug	L 557
	mov	ax,word ptr [bp-2]
	jmp	short @74
@74:
;	?debug	L 558
	pop	si
	mov	sp,bp
	pop	bp
	ret	
_InitMemoryTable	endp
;	?debug	L 564
_GetFarPointer	proc	near
	push	bp
	mov	bp,sp
;	?debug	L 566
 	mov	 eax, [bp+4]
;	?debug	L 568
 	mov	 cx, ax
;	?debug	L 569
 	and	 cx, 000Fh
;	?debug	L 570
 	shr	 eax, 4
;	?debug	L 572
 	mov	 dx, ax
;	?debug	L 574
 	mov	 ax, cx
	jmp	short @79
@79:
;	?debug	L 576
	pop	bp
	ret	
_GetFarPointer	endp
;	?debug	L 582
_MemoryAllocation	proc	near
	push	bp
	mov	bp,sp
	sub	sp,18
;	?debug	L 584
	les	bx,dword ptr DGROUP:_sys_mem_ptr
	mov	word ptr [bp-16],es
	mov	word ptr [bp-18],bx
;	?debug	L 585
	les	bx,dword ptr [bp-18]
	mov	word ptr [bp-12],es
	mov	word ptr [bp-14],bx
;	?debug	L 590
	xor	ax,ax
	push	ax
	push	ax
	push	word ptr [bp+6]
	push	word ptr [bp+4]
	call	near ptr _ULCompare
	add	sp,8
	or	ax,ax
	jne	@81
	xor	dx,dx
	xor	ax,ax
	jmp	@80
@81:
;	?debug	L 592
	xor	dx,dx
	mov	ax,2
	push	dx
	push	ax
	push	word ptr [bp+6]
	push	word ptr [bp+4]
	call	near ptr _ULAddition
	add	sp,8
	mov	word ptr [bp+6],dx
	mov	word ptr [bp+4],ax
@84:
;	?debug	L 596
	les	bx,dword ptr [bp-14]
	mov	ax,word ptr es:[bx+10]
	mov	cl,4
	shl	ax,cl
	les	bx,dword ptr [bp-18]
	add	bx,ax
	mov	word ptr [bp-12],es
	mov	word ptr [bp-14],bx
;	?debug	L 597
	mov	dx,-1
	mov	ax,-1
	push	dx
	push	ax
	push	word ptr [bp+6]
	push	word ptr [bp+4]
	call	near ptr _ULAddition
	add	sp,8
	push	dx
	push	ax
	les	bx,dword ptr [bp-14]
	push	word ptr es:[bx+2]
	push	word ptr es:[bx]
	call	near ptr _ULAddition
	add	sp,8
	mov	word ptr [bp-2],dx
	mov	word ptr [bp-4],ax
;	?debug	L 599
	push	word ptr [bp-2]
	push	word ptr [bp-4]
	les	bx,dword ptr [bp-14]
	push	word ptr es:[bx+6]
	push	word ptr es:[bx+4]
	call	near ptr _ULCompare
	add	sp,8
	cmp	ax,-1
	je	@85
;	?debug	L 602
	push	word ptr DGROUP:_current_proc
	push	word ptr [bp+6]
	push	word ptr [bp+4]
	les	bx,dword ptr [bp-14]
	push	word ptr es:[bx+2]
	push	word ptr es:[bx]
	call	near ptr _MarkMemoryBlock
	add	sp,10
	mov	word ptr [bp-6],ax
;	?debug	L 604
	cmp	word ptr [bp-6],-1
	jne	@86
	xor	dx,dx
	xor	ax,ax
	jmp	short @80
	jmp	short @87
@86:
;	?debug	L 605
	mov	ax,word ptr [bp-6]
	mov	cl,4
	shl	ax,cl
	les	bx,dword ptr [bp-18]
	add	bx,ax
	push	word ptr es:[bx+2]
	push	word ptr es:[bx]
	call	near ptr _GetFarPointer
	pop	cx
	pop	cx
	mov	word ptr [bp-8],dx
	mov	word ptr [bp-10],ax
@87:
;	?debug	L 607
	mov	ax,word ptr [bp-6]
	les	bx,dword ptr [bp-10]
	mov	word ptr es:[bx],ax
;	?debug	L 609
	mov	dx,word ptr [bp-8]
	mov	ax,word ptr [bp-10]
	inc	ax
	inc	ax
	jmp	short @80
@85:
@82:
;	?debug	L 612
	les	bx,dword ptr [bp-14]
	cmp	word ptr es:[bx+10],-1
	je	@88
	jmp	@84
@88:
@83:
;	?debug	L 613
	xor	dx,dx
	xor	ax,ax
	jmp	short @80
@80:
;	?debug	L 614
	mov	sp,bp
	pop	bp
	ret	
_MemoryAllocation	endp
;	?debug	L 616
_MemoryFree	proc	near
	push	bp
	mov	bp,sp
	sub	sp,10
;	?debug	L 618
	les	bx,dword ptr [bp+4]
	mov	word ptr [bp-8],es
	mov	word ptr [bp-10],bx
;	?debug	L 619
	les	bx,dword ptr [bp-10]
	add	bx,-2
	mov	ax,word ptr es:[bx]
	mov	word ptr [bp-6],ax
;	?debug	L 620
	les	bx,dword ptr DGROUP:_sys_mem_ptr
	mov	word ptr [bp-2],es
	mov	word ptr [bp-4],bx
;	?debug	L 621
	mov	ax,word ptr [bp-6]
	cmp	ax,word ptr DGROUP:_mem_slot_num
	jb	@90
;	?debug	L 623
	mov	word ptr DGROUP:_last_error,-1
;	?debug	L 624
	mov	ax,-1
	jmp	short @89
;	?debug	L 625
	jmp	short @91
@90:
;	?debug	L 626
	cmp	word ptr DGROUP:_current_proc,0
	je	@92
	mov	ax,word ptr [bp-6]
	mov	cl,4
	shl	ax,cl
	les	bx,dword ptr [bp-4]
	add	bx,ax
	mov	ax,word ptr es:[bx+8]
	cmp	ax,word ptr DGROUP:_current_proc
	je	@92
;	?debug	L 628
	mov	word ptr DGROUP:_last_error,-2
;	?debug	L 629
	mov	ax,-1
	jmp	short @89
@92:
@91:
;	?debug	L 631
	push	word ptr [bp-6]
	call	near ptr _UnmarkMemoryBlock
	pop	cx
	jmp	short @89
@89:
;	?debug	L 632
	mov	sp,bp
	pop	bp
	ret	
_MemoryFree	endp
_TEXT	ends
_DATA	segment word public 'DATA'
_DATA	ends
_TEXT	segment	byte public 'CODE'
;	?debug	L 634
_PrintMemoryTableHead	proc	near
;	?debug	L 636
	mov	ax,offset DGROUP:s@+109
	push	ax
	call	near ptr _Printf
	pop	cx
	jmp	short @93
@93:
;	?debug	L 638
	ret	
_PrintMemoryTableHead	endp
_TEXT	ends
_DATA	segment word public 'DATA'
_DATA	ends
_TEXT	segment	byte public 'CODE'
;	?debug	L 640
_PrintMemoryTableNode	proc	near
	push	bp
	mov	bp,sp
	sub	sp,4
;	?debug	L 642
	push	word ptr [bp+4]
	call	near ptr _GetMemoryNode
	pop	cx
	mov	word ptr [bp-2],dx
	mov	word ptr [bp-4],ax
;	?debug	L 643
;	?debug	L 644
	les	bx,dword ptr [bp-4]
	push	word ptr es:[bx+12]
	les	bx,dword ptr [bp-4]
	push	word ptr es:[bx+10]
	les	bx,dword ptr [bp-4]
	push	word ptr es:[bx+14]
	les	bx,dword ptr [bp-4]
	push	word ptr es:[bx+6]
	push	word ptr es:[bx+4]
	les	bx,dword ptr [bp-4]
	push	word ptr es:[bx+2]
	push	word ptr es:[bx]
	push	word ptr [bp+4]
	mov	ax,offset DGROUP:s@+146
	push	ax
	call	near ptr _Printf
	add	sp,18
	jmp	short @94
@94:
;	?debug	L 646
	mov	sp,bp
	pop	bp
	ret	
_PrintMemoryTableNode	endp
_TEXT	ends
_DATA	segment word public 'DATA'
_DATA	ends
_TEXT	segment	byte public 'CODE'
;	?debug	L 648
_PrintMemoryTable	proc	near
	push	bp
	mov	bp,sp
	sub	sp,10
;	?debug	L 650
	les	bx,dword ptr DGROUP:_sys_mem_ptr
	mov	word ptr [bp-8],es
	mov	word ptr [bp-10],bx
;	?debug	L 651
	les	bx,dword ptr [bp-10]
	mov	word ptr [bp-4],es
	mov	word ptr [bp-6],bx
;	?debug	L 653
	push	ds
	mov	ax,offset DGROUP:_equal_16
	push	ax
	push	ds
	mov	ax,offset DGROUP:_equal_16
	push	ax
	mov	ax,offset DGROUP:s@+169
	push	ax
	call	near ptr _Printf
	add	sp,10
;	?debug	L 654
	call	near ptr _PrintMemoryTableHead
@98:
;	?debug	L 657
	les	bx,dword ptr [bp-6]
	mov	ax,word ptr es:[bx+10]
	mov	word ptr [bp-2],ax
;	?debug	L 658
	mov	ax,word ptr [bp-2]
	mov	cl,4
	shl	ax,cl
	les	bx,dword ptr [bp-10]
	add	bx,ax
	mov	word ptr [bp-4],es
	mov	word ptr [bp-6],bx
;	?debug	L 659
	push	word ptr [bp-2]
	call	near ptr _PrintMemoryTableNode
	pop	cx
@96:
;	?debug	L 660
	les	bx,dword ptr [bp-6]
	cmp	word ptr es:[bx+10],-1
	jne	@98
@97:
	jmp	short @95
@95:
;	?debug	L 662
	mov	sp,bp
	pop	bp
	ret	
_PrintMemoryTable	endp
_TEXT	ends
_DATA	segment word public 'DATA'
_DATA	ends
_TEXT	segment	byte public 'CODE'
;	?debug	L 664
_PrintMemoryNode	proc	near
	push	bp
	mov	bp,sp
	sub	sp,4
	push	si
;	?debug	L 666
	les	bx,dword ptr DGROUP:_sys_mem_ptr
	mov	word ptr [bp-2],es
	mov	word ptr [bp-4],bx
;	?debug	L 668
	push	ds
	mov	ax,offset DGROUP:_equal_16
	push	ax
	push	ds
	mov	ax,offset DGROUP:_equal_16
	push	ax
	mov	ax,offset DGROUP:s@+191
	push	ax
	call	near ptr _Printf
	add	sp,10
;	?debug	L 669
	call	near ptr _PrintMemoryTableHead
;	?debug	L 670
	xor	si,si
	jmp	short @103
@102:
;	?debug	L 672
	les	bx,dword ptr [bp-4]
	test	word ptr es:[bx+14],2
	je	@104
	push	si
	call	near ptr _PrintMemoryTableNode
	pop	cx
@104:
;	?debug	L 673
	add	word ptr [bp-4],16
@101:
	inc	si
@103:
	cmp	si,word ptr DGROUP:_mem_slot_num
	jl	@102
@100:
	jmp	short @99
@99:
;	?debug	L 676
	pop	si
	mov	sp,bp
	pop	bp
	ret	
_PrintMemoryNode	endp
_TEXT	ends
	?debug	C E9
_DATA	segment word public 'DATA'
s@	label	byte
	db	37
	db	115
	db	10
	db	61
	db	32
	db	77
	db	101
	db	109
	db	111
	db	114
	db	121
	db	32
	db	77
	db	97
	db	112
	db	10
	db	37
	db	115
	db	10
	db	0
	db	66
	db	97
	db	115
	db	101
	db	32
	db	65
	db	100
	db	100
	db	114
	db	101
	db	115
	db	115
	db	32
	db	32
	db	32
	db	32
	db	32
	db	124
	db	32
	db	76
	db	101
	db	110
	db	103
	db	116
	db	104
	db	32
	db	32
	db	32
	db	32
	db	32
	db	32
	db	32
	db	32
	db	32
	db	32
	db	32
	db	124
	db	32
	db	84
	db	121
	db	112
	db	101
	db	10
	db	0
	db	68
	db	101
	db	116
	db	101
	db	99
	db	116
	db	105
	db	110
	db	103
	db	32
	db	98
	db	97
	db	115
	db	105
	db	99
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
	db	73
	db	78
	db	84
	db	32
	db	49
	db	53
	db	72
	db	32
	db	45
	db	32
	db	37
	db	100
	db	75
	db	66
	db	121
	db	116
	db	101
	db	115
	db	10
	db	0
	db	73
	db	110
	db	100
	db	101
	db	120
	db	9
	db	83
	db	116
	db	97
	db	114
	db	116
	db	9
	db	9
	db	69
	db	110
	db	100
	db	9
	db	9
	db	9
	db	83
	db	116
	db	97
	db	116
	db	117
	db	115
	db	9
	db	78
	db	101
	db	120
	db	116
	db	9
	db	80
	db	114
	db	101
	db	118
	db	10
	db	0
	db	37
	db	100
	db	9
	db	9
	db	37
	db	108
	db	120
	db	9
	db	37
	db	108
	db	120
	db	9
	db	37
	db	120
	db	9
	db	37
	db	100
	db	9
	db	9
	db	37
	db	100
	db	10
	db	0
	db	37
	db	115
	db	10
	db	61
	db	32
	db	77
	db	101
	db	109
	db	111
	db	114
	db	121
	db	32
	db	84
	db	97
	db	98
	db	108
	db	101
	db	10
	db	37
	db	115
	db	10
	db	0
	db	37
	db	115
	db	10
	db	61
	db	32
	db	77
	db	101
	db	109
	db	111
	db	114
	db	121
	db	32
	db	78
	db	111
	db	100
	db	101
	db	10
	db	37
	db	115
	db	10
	db	0
_DATA	ends
	extrn	_video_char_ptr:dword
	extrn	_sys_mem_avail:dword
	extrn	_last_error:word
	extrn	_current_proc:word
	extrn	_equal_16:byte
_TEXT	segment	byte public 'CODE'
	extrn	_PrintLongHex:near
	extrn	_FatalError:near
	extrn	_PutString:near
	extrn	_PutChar:near
	extrn	_Printf:near
_TEXT	ends
	public	_PrintAllMemory
	public	_PrintMemoryTable
	public	_MarkMemoryBlock
	public	_PrintMemoryMap
	public	_PrintMemoryNode
	public	_InitMemoryTable
	public	_basic_mem_size
	public	_GetFarPointer
	public	_SegmentSetWord
	public	_mem_slot_num
	public	_sys_mem_ptr
	public	_SegmentCopy
	public	_AddressCompare
	public	_GetMemoryNode
	public	_MemoryCopy
	public	_SegmentSet
	public	_ULAddition
	public	_MemoryFree
	public	_ULCompare
	public	_PrintMemoryTableNode
	public	_PrintMemoryTableHead
	public	_FindUnusedMemoryNode
	public	_AddUnusedMemoryNode
	public	_mem_slot_full_msg
	public	_DetectHighMemory
	public	_UnmarkMemoryBlock
	public	_DetectLowMemory
	public	_mem_slot_remain
	public	_MemoryAllocation
	end
