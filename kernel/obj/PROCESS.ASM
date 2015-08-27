	ifndef	??version
?debug	macro
	endm
	endif
	?debug	S "process.c"
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
	?debug	C E9359224440970726F636573732E63
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
_current_proc	label	word
	dw	0
_proc_slot_num	label	word
	dw	0
_proc_slot_remain	label	word
	dw	0
_sys_proc_ptr	label	dword
	dw	0
	dw	0
 	_TEXT	 ends
 	_DATA	 segment word public 'DATA'
_DATA	ends
_TEXT	segment	byte public 'CODE'
;	?debug	L 21
_IdleProcess	proc	near
	push	bp
	mov	bp,sp
	sub	sp,4
;	?debug	L 24
	mov	word ptr [bp-2],0
;	?debug	L 25
	push	ds
	mov	ax,offset DGROUP:s@
	push	ax
	call	near ptr _SysPutString
	pop	cx
	pop	cx
	jmp	short @2
@4:
;	?debug	L 28
	mov	word ptr [bp-4],0
	jmp	short @8
@7:
@6:
	inc	word ptr [bp-4]
@8:
	cmp	word ptr [bp-4],-1
	jb	@7
@5:
;	?debug	L 29
	inc	word ptr [bp-2]
;	?debug	L 30
 	cli	
;	?debug	L 31
	push	word ptr [bp-2]
	call	near ptr _SysPrintSignedShortDec
	pop	cx
;	?debug	L 32
	mov	al,97
	push	ax
	call	near ptr _SysPutChar
	pop	cx
;	?debug	L 33
 	sti	
@2:
;	?debug	L 26
	jmp	short @4
@3:
@1:
;	?debug	L 35
	mov	sp,bp
	pop	bp
	ret	
_IdleProcess	endp
_TEXT	ends
_DATA	segment word public 'DATA'
_DATA	ends
_TEXT	segment	byte public 'CODE'
;	?debug	L 37
_IdleProcess2	proc	near
	push	bp
	mov	bp,sp
	sub	sp,4
;	?debug	L 40
	mov	word ptr [bp-2],0
;	?debug	L 41
	push	ds
	mov	ax,offset DGROUP:s@+23
	push	ax
	call	near ptr _SysPutString
	pop	cx
	pop	cx
	jmp	short @10
@12:
;	?debug	L 44
	mov	word ptr [bp-4],0
	jmp	short @16
@15:
@14:
	inc	word ptr [bp-4]
@16:
	cmp	word ptr [bp-4],-1
	jb	@15
@13:
;	?debug	L 45
	inc	word ptr [bp-2]
;	?debug	L 46
 	cli	
;	?debug	L 47
	push	word ptr [bp-2]
	call	near ptr _SysPrintSignedShortDec
	pop	cx
;	?debug	L 48
	mov	al,98
	push	ax
	call	near ptr _SysPutChar
	pop	cx
;	?debug	L 49
 	sti	
@10:
;	?debug	L 42
	jmp	short @12
@11:
@9:
;	?debug	L 51
	mov	sp,bp
	pop	bp
	ret	
_IdleProcess2	endp
;	?debug	L 56
_SaveContext	proc	near
	push	bp
	mov	bp,sp
	sub	sp,4
	push	si
	push	di
;	?debug	L 58
	mov	ax,word ptr DGROUP:_current_proc
	mov	dx,30
	mul	dx
	les	bx,dword ptr DGROUP:_sys_proc_ptr
	add	bx,ax
	mov	word ptr [bp-2],es
	mov	word ptr [bp-4],bx
;	?debug	L 59
 	les	 bx, [bp-4]
;	?debug	L 61
 	mov	 sp, bp
;	?debug	L 62
 	pop	 bp
;	?debug	L 64
 	mov	 ax, [bp + 16]
;	?debug	L 65
 	mov	 cx, [bp + 12]
;	?debug	L 66
 	mov	 dx, [bp + 10]
;	?debug	L 67
 	mov	 si, [bp + 8]
;	?debug	L 68
 	mov	 di, [bp + 6]
;	?debug	L 69
 	mov	 es:[bx + 0], ax
;	?debug	L 70
 	mov	 es:[bx + 4], cx
;	?debug	L 71
 	mov	 es:[bx + 6], dx
;	?debug	L 72
 	mov	 es:[bx + 8], si
;	?debug	L 73
 	mov	 es:[bx + 10], di
;	?debug	L 75
 	mov	 ax, [bp + 14]
;	?debug	L 76
 	mov	 es:[bx + 2], ax
;	?debug	L 78
 	mov	 ax, [bp + 4]
;	?debug	L 79
 	mov	 es:[bx + 14], ax
;	?debug	L 81
 	mov	 ax, [bp + 2]
;	?debug	L 82
 	mov	 es:[bx + 20], ax
;	?debug	L 84
 	mov	 ax, [bp + 0]
;	?debug	L 85
 	mov	 es:[bx + 22], ax
;	?debug	L 87
 	mov	 ax, [bp + 18]
;	?debug	L 88
 	mov	 es:[bx + 24], ax
;	?debug	L 90
 	mov	 ax, [bp + 22]
;	?debug	L 91
 	mov	 es:[bx + 16], ax
;	?debug	L 93
 	mov	 ax, [bp + 20]
;	?debug	L 94
 	mov	 es:[bx + 18], ax
;	?debug	L 96
 	mov	 ax, [bp + 24]
;	?debug	L 97
 	mov	 es:[bx + 26], ax
;	?debug	L 99
 	mov	 es:[bx + 12], bp
;	?debug	L 100
 	add	 word ptr es:[bx + 12], 26
;	?debug	L 103
 	push	 bp
;	?debug	L 104
 	mov	 bp, sp
;	?debug	L 105
 	push	 si
;	?debug	L 106
 	push	 di
	jmp	short @17
@17:
;	?debug	L 115
	pop	di
	pop	si
	mov	sp,bp
	pop	bp
	ret	
_SaveContext	endp
;	?debug	L 120
_FindNextProcess	proc	near
	push	bp
	mov	bp,sp
	sub	sp,6
	push	si
;	?debug	L 123
	mov	ax,word ptr DGROUP:_current_proc
	mov	dx,30
	mul	dx
	les	bx,dword ptr DGROUP:_sys_proc_ptr
	add	bx,ax
	add	bx,30
	mov	word ptr [bp-4],es
	mov	word ptr [bp-6],bx
;	?debug	L 126
	mov	si,word ptr DGROUP:_current_proc
	inc	si
	jmp	short @22
@21:
;	?debug	L 128
	les	bx,dword ptr [bp-6]
	mov	ax,word ptr es:[bx+28]
	mov	word ptr [bp-2],ax
;	?debug	L 129
	cmp	word ptr [bp-2],0
	je	@24
	cmp	word ptr [bp-2],1
	jne	@23
@24:
;	?debug	L 132
	mov	word ptr [bp-2],1
;	?debug	L 133
	mov	ax,si
	jmp	short @18
;	?debug	L 134
	jmp	short @25
@23:
;	?debug	L 135
	add	word ptr [bp-6],30
@25:
@20:
	inc	si
@22:
	cmp	si,word ptr DGROUP:_proc_slot_num
	jl	@21
@19:
;	?debug	L 138
	les	bx,dword ptr DGROUP:_sys_proc_ptr
	add	bx,30
	mov	word ptr [bp-4],es
	mov	word ptr [bp-6],bx
;	?debug	L 139
	mov	si,1
	jmp	short @29
@28:
;	?debug	L 141
	les	bx,dword ptr [bp-6]
	mov	ax,word ptr es:[bx+28]
	mov	word ptr [bp-2],ax
;	?debug	L 142
	cmp	word ptr [bp-2],0
	je	@31
	cmp	word ptr [bp-2],1
	jne	@30
@31:
;	?debug	L 144
	mov	word ptr [bp-2],1
;	?debug	L 145
	mov	ax,si
	jmp	short @18
;	?debug	L 146
	jmp	short @32
@30:
;	?debug	L 147
	add	word ptr [bp-6],30
@32:
@27:
	inc	si
@29:
	cmp	si,word ptr DGROUP:_current_proc
	jle	@28
@26:
;	?debug	L 150
	xor	ax,ax
	jmp	short @18
@18:
;	?debug	L 151
	pop	si
	mov	sp,bp
	pop	bp
	ret	
_FindNextProcess	endp
_TEXT	ends
_DATA	segment word public 'DATA'
_DATA	ends
_TEXT	segment	byte public 'CODE'
;	?debug	L 155
_Schedule	proc	near
	push	bp
	mov	bp,sp
	sub	sp,8
	push	si
	push	di
;	?debug	L 161
	call	near ptr _FindNextProcess
	mov	word ptr [bp-8],ax
;	?debug	L 162
	mov	ax,word ptr [bp-8]
	mov	dx,30
	mul	dx
	les	bx,dword ptr DGROUP:_sys_proc_ptr
	add	bx,ax
	mov	word ptr [bp-4],es
	mov	word ptr [bp-6],bx
;	?debug	L 163
	les	bx,dword ptr [bp-6]
	mov	ax,word ptr es:[bx+28]
	mov	word ptr [bp-2],ax
;	?debug	L 165
	cmp	word ptr [bp-2],0
	je	@34
	cmp	word ptr [bp-2],1
	je	@34
;	?debug	L 166
	push	ds
	mov	ax,offset DGROUP:s@+46
	push	ax
	call	near ptr _FatalError
	pop	cx
	pop	cx
@34:
;	?debug	L 168
	mov	ax,word ptr [bp-8]
	mov	word ptr DGROUP:_current_proc,ax
;	?debug	L 170
 	les	 bx, [bp-6]
;	?debug	L 172
 	mov	 cx, es:[bx + 4]
;	?debug	L 173
 	mov	 dx, es:[bx + 6]
;	?debug	L 174
 	mov	 si, es:[bx + 8]
;	?debug	L 175
 	mov	 di, es:[bx + 10]
;	?debug	L 176
 	mov	 bp, es:[bx + 14]
;	?debug	L 178
 	mov	 ax, es:[bx + 20]
;	?debug	L 179
 	mov	 ds, ax
;	?debug	L 181
 	mov	 ax, es:[bx + 24]
;	?debug	L 182
 	mov	 ss, ax
;	?debug	L 183
 	mov	 sp, es:[bx + 12]
;	?debug	L 185
 	mov	 ax, es:[bx]
;	?debug	L 188
 	push	 es:[bx + 26]
;	?debug	L 189
 	push	 es:[bx + 16]
;	?debug	L 190
 	push	 es:[bx + 18]
;	?debug	L 192
 	push	 es:[bx + 22]
;	?debug	L 193
 	push	 es:[bx + 2]
;	?debug	L 194
 	pop	 bx
;	?debug	L 195
 	pop	 es
;	?debug	L 197
 	iret	
@33:
;	?debug	L 198
	pop	di
	pop	si
	mov	sp,bp
	pop	bp
	ret	
_Schedule	endp
;	?debug	L 200
_InitProcessTable	proc	near
	push	bp
	mov	bp,sp
	sub	sp,8
	push	si
;	?debug	L 202
	mov	ax,word ptr [bp+4]
	mov	dx,30
	mul	dx
	mov	word ptr [bp-8],ax
;	?debug	L 207
	mov	ax,word ptr [bp+4]
	mov	word ptr DGROUP:_proc_slot_num,ax
;	?debug	L 209
	les	bx,dword ptr DGROUP:_sys_mem_avail
	mov	word ptr DGROUP:_sys_proc_ptr+2,es
	mov	word ptr DGROUP:_sys_proc_ptr,bx
;	?debug	L 210
	les	bx,dword ptr DGROUP:_sys_proc_ptr
	mov	word ptr [bp-4],es
	mov	word ptr [bp-6],bx
;	?debug	L 212
	mov	ax,word ptr [bp+4]
	mov	dx,30
	mul	dx
	push	ax
	xor	ax,ax
	push	ax
	push	word ptr [bp-4]
	push	word ptr [bp-6]
	call	near ptr _SegmentSet
	add	sp,8
;	?debug	L 214
	les	bx,dword ptr [bp-6]
	mov	word ptr es:[bx+24],28672
;	?debug	L 216
	les	bx,dword ptr [bp-6]
	mov	word ptr es:[bx+12],-2
;	?debug	L 218
	les	bx,dword ptr [bp-6]
	mov	word ptr es:[bx+16],28672
;	?debug	L 220
	mov	ax,offset _IdleProcess
	les	bx,dword ptr [bp-6]
	mov	word ptr es:[bx+18],ax
;	?debug	L 222
	les	bx,dword ptr [bp-6]
	mov	word ptr es:[bx+20],28672
;	?debug	L 224
	les	bx,dword ptr [bp-6]
	mov	word ptr es:[bx+22],-32768
;	?debug	L 226
 	pushf	
;	?debug	L 227
 	pop	 ax
;	?debug	L 228
 	mov	 [bp-2], ax
;	?debug	L 230
	and	word ptr [bp-2],-4054
;	?debug	L 232
	or	word ptr [bp-2],512
;	?debug	L 234
	mov	ax,word ptr [bp-2]
	les	bx,dword ptr [bp-6]
	mov	word ptr es:[bx+26],ax
;	?debug	L 236
	les	bx,dword ptr [bp-6]
	mov	word ptr es:[bx+28],0
;	?debug	L 237
	add	word ptr [bp-6],30
;	?debug	L 243
	les	bx,dword ptr [bp-6]
	mov	word ptr es:[bx+24],28672
;	?debug	L 245
	les	bx,dword ptr [bp-6]
	mov	word ptr es:[bx+12],-2
;	?debug	L 247
	les	bx,dword ptr [bp-6]
	mov	word ptr es:[bx+16],28672
;	?debug	L 249
	mov	ax,offset _IdleProcess2
	les	bx,dword ptr [bp-6]
	mov	word ptr es:[bx+18],ax
;	?debug	L 251
	les	bx,dword ptr [bp-6]
	mov	word ptr es:[bx+20],28672
;	?debug	L 253
	les	bx,dword ptr [bp-6]
	mov	word ptr es:[bx+22],-32768
;	?debug	L 255
 	pushf	
;	?debug	L 256
 	pop	 ax
;	?debug	L 257
 	mov	 [bp-2], ax
;	?debug	L 259
	and	word ptr [bp-2],-4054
;	?debug	L 261
	or	word ptr [bp-2],512
;	?debug	L 263
	mov	ax,word ptr [bp-2]
	les	bx,dword ptr [bp-6]
	mov	word ptr es:[bx+26],ax
;	?debug	L 265
	les	bx,dword ptr [bp-6]
	mov	word ptr es:[bx+28],0
;	?debug	L 266
	add	word ptr [bp-6],30
;	?debug	L 268
	les	bx,dword ptr [bp-6]
	mov	word ptr es:[bx+24],28672
;	?debug	L 270
	les	bx,dword ptr [bp-6]
	mov	word ptr es:[bx+12],4094
;	?debug	L 272
	les	bx,dword ptr [bp-6]
	mov	word ptr es:[bx+16],28672
;	?debug	L 274
	mov	ax,offset _IdleProcess
	les	bx,dword ptr [bp-6]
	mov	word ptr es:[bx+18],ax
;	?debug	L 276
	les	bx,dword ptr [bp-6]
	mov	word ptr es:[bx+20],28672
;	?debug	L 278
	les	bx,dword ptr [bp-6]
	mov	word ptr es:[bx+22],-32768
;	?debug	L 280
 	pushf	
;	?debug	L 281
 	pop	 ax
;	?debug	L 282
 	mov	 [bp-2], ax
;	?debug	L 284
	and	word ptr [bp-2],-4054
;	?debug	L 286
	or	word ptr [bp-2],512
;	?debug	L 288
	mov	ax,word ptr [bp-2]
	les	bx,dword ptr [bp-6]
	mov	word ptr es:[bx+26],ax
;	?debug	L 290
	les	bx,dword ptr [bp-6]
	mov	word ptr es:[bx+28],0
;	?debug	L 291
	add	word ptr [bp-6],30
;	?debug	L 298
	mov	si,3
	jmp	short @39
@38:
;	?debug	L 300
	les	bx,dword ptr [bp-6]
	mov	word ptr es:[bx+28],-1
;	?debug	L 301
	add	word ptr [bp-6],30
@37:
	inc	si
@39:
	cmp	si,word ptr [bp+4]
	jl	@38
@36:
;	?debug	L 304
	mov	word ptr DGROUP:_current_proc,0
;	?debug	L 306
	mov	ax,word ptr [bp-8]
	add	word ptr DGROUP:_sys_mem_avail,ax
;	?debug	L 308
	mov	ax,word ptr [bp-8]
	jmp	short @35
@35:
;	?debug	L 309
	pop	si
	mov	sp,bp
	pop	bp
	ret	
_InitProcessTable	endp
_TEXT	ends
	?debug	C E9
_DATA	segment word public 'DATA'
s@	label	byte
	db	80
	db	114
	db	111
	db	99
	db	101
	db	115
	db	115
	db	32
	db	48
	db	32
	db	110
	db	111
	db	119
	db	32
	db	114
	db	117
	db	110
	db	110
	db	105
	db	110
	db	103
	db	10
	db	0
	db	80
	db	114
	db	111
	db	99
	db	101
	db	115
	db	115
	db	32
	db	49
	db	32
	db	110
	db	111
	db	119
	db	32
	db	114
	db	117
	db	110
	db	110
	db	105
	db	110
	db	103
	db	10
	db	0
	db	73
	db	110
	db	118
	db	97
	db	108
	db	105
	db	100
	db	32
	db	78
	db	101
	db	120
	db	116
	db	32
	db	80
	db	114
	db	111
	db	99
	db	101
	db	115
	db	115
	db	32
	db	78
	db	111
	db	100
	db	101
	db	32
	db	82
	db	101
	db	116
	db	117
	db	114
	db	110
	db	101
	db	100
	db	0
_DATA	ends
	extrn	_video_char_ptr:dword
	extrn	_sys_mem_avail:dword
_TEXT	segment	byte public 'CODE'
	extrn	_SysPutString:near
	extrn	_SegmentSet:near
	extrn	_SysPutChar:near
	extrn	_FatalError:near
	extrn	_SysPrintSignedShortDec:near
_TEXT	ends
	public	_FindNextProcess
	public	_InitProcessTable
	public	_proc_slot_num
	public	_sys_proc_ptr
	public	_SaveContext
	public	_IdleProcess
	public	_current_proc
	public	_Schedule
	public	_IdleProcess2
	public	_proc_slot_remain
	end
