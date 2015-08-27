	ifndef	??version
?debug	macro
	endm
	endif
	?debug	S "loader.c"
_TEXT	segment	byte public 'CODE'
DGROUP	group	_DATA,_BSS
	assume	cs:_TEXT,ds:DGROUP,ss:DGROUP
_TEXT	ends
_DATA	segment word public 'DATA'
d@	label	byte
d@w	label	word
_DATA	ends
_BSS	segment word public 'BSS'
b@	label	byte
b@w	label	word
	?debug	C E9B3949B43086C6F616465722E63
	?debug	C E9A1949B43122E2E5C696E636C7564655C62617369632E68
_BSS	ends
_DATA	segment word public 'DATA'
 	.486p
_DATA	ends
_TEXT	segment	byte public 'CODE'
;	?debug	L 15
_main	proc	near
	push	bp
	mov	bp,sp
	sub	sp,6
	push	si
;	?debug	L 20
 	mov	 si, cs
;	?debug	L 21
 	mov	 ds, si
;	?debug	L 22
 	mov	 [bp-6], si
;	?debug	L 23
 	xor	 si, si
;	?debug	L 24
 	mov	 es, si
;	?debug	L 25
 	assume	 ds:_TEXT, es:nothing
;	?debug	L 26
 	mov	 [bp-4], offset cs_value_str
;	?debug	L 27
 	mov	 [bp-2], offset crlf
;	?debug	L 28
	call	near ptr _SwitchTo4GB
;	?debug	L 29
	push	word ptr [bp-4]
	call	near ptr _PrintString
	pop	cx
;	?debug	L 30
	push	word ptr [bp-6]
	call	near ptr _PrintShortHex
	pop	cx
;	?debug	L 31
	push	word ptr [bp-2]
	call	near ptr _PrintString
	pop	cx
;	?debug	L 32
	call	near ptr _ReadFile
;	?debug	L 33
	jmp	short @2
@4:
@2:
	jmp	short @4
@3:
@1:
;	?debug	L 34
	pop	si
	mov	sp,bp
	pop	bp
	ret	
_main	endp
;	?debug	L 36
_SwitchTo4GB	proc	near
;	?debug	L 38
 	push	 ds
;	?debug	L 39
 	push	 es
;	?debug	L 41
 	xor	 eax, eax
;	?debug	L 42
 	mov	 ax, ds
;	?debug	L 43
 	shl	 eax, 4
;	?debug	L 45
 	add	 eax, offset gdt
;	?debug	L 46
 	mov	 dword ptr [gdt_ptr + 2], eax
;	?debug	L 47
 	cli	
;	?debug	L 48
 	lgdt	 qword ptr [gdt_ptr]
;	?debug	L 49
 	mov	 eax, cr0
;	?debug	L 50
 	or	 al, 1
;	?debug	L 51
 	mov	 cr0, eax
;	?debug	L 52
 	mov	 bx, ds_descriptor
;	?debug	L 53
 	mov	 ds, bx
;	?debug	L 54
 	mov	 es, bx
;	?debug	L 55
 	mov	 fs, bx
;	?debug	L 56
 	mov	 gs, bx
;	?debug	L 57
 	SwitchTo4GB_next	:
;	?debug	L 58
 	dec	 al
;	?debug	L 59
 	mov	 cr0, eax
;	?debug	L 60
 	pop	 es
;	?debug	L 61
 	pop	 ds
	jmp	@5
;	?debug	L 64
 	gdt	 label byte
;	?debug	L 65
 	dw	 0
;	?debug	L 66
 	dw	 0
;	?debug	L 67
 	db	 0
;	?debug	L 68
 	db	 0
;	?debug	L 69
 	db	 0
;	?debug	L 70
 	db	 0
;	?debug	L 71
 	ds_descriptor	 equ $ - offset gdt
;	?debug	L 72
 	dw	 0FFFFh
;	?debug	L 73
 	dw	 0
;	?debug	L 74
 	db	 0
;	?debug	L 75
 	db	 92h
;	?debug	L 76
 	db	 0CFh
;	?debug	L 77
 	db	 0
;	?debug	L 78
 	gdt_end	 label byte
;	?debug	L 79
 	gdt_ptr	 label
;	?debug	L 80
 	dw	 offset gdt_end - offset gdt
;	?debug	L 81
 	dd	 0
@5:
;	?debug	L 82
	ret	
_SwitchTo4GB	endp
;	?debug	L 85
_PrintString	proc	near
	push	bp
	mov	bp,sp
	push	si
;	?debug	L 87
 	mov	 si, [bp+4]
;	?debug	L 88
 	cld	
@7:
;	?debug	L 90
 	lodsb	
;	?debug	L 91
 	mov	 ah, 0eh
;	?debug	L 92
 	cmp	 al, 0
;	?debug	L 93
 	jz	 @8
;	?debug	L 94
 	xor	 bx, bx
;	?debug	L 95
 	mov	 bl, 07h
;	?debug	L 96
 	int	 10h
;	?debug	L 97
 	jmp	 @7
@8:
	jmp	short @6
@6:
;	?debug	L 100
	pop	si
	pop	bp
	ret	
_PrintString	endp
;	?debug	L 102
_Error	proc	near
	push	bp
	mov	bp,sp
	sub	sp,4
;	?debug	L 106
 	mov	 [bp-4], offset error_str
;	?debug	L 107
 	mov	 [bp-2], offset crlf
;	?debug	L 108
	push	word ptr [bp-4]
	call	near ptr _PrintString
	pop	cx
;	?debug	L 109
	push	word ptr [bp+4]
	call	near ptr _PrintShortHex
	pop	cx
;	?debug	L 110
	push	word ptr [bp-2]
	call	near ptr _PrintString
	pop	cx
;	?debug	L 111
	jmp	short @10
@12:
@10:
	jmp	short @12
@11:
@9:
;	?debug	L 112
	mov	sp,bp
	pop	bp
	ret	
_Error	endp
;	?debug	L 114
_null	proc	near
;	?debug	L 116
 	digit_table	 db '0123456789ABCDEF'
;	?debug	L 117
 	kernel_filename	 db 'KERNEL  COM'
;	?debug	L 118
 	crlf	 db 0dh, 0ah, 0
;	?debug	L 119
 	cs_value_str	 db 'Code Segment = ',0
;	?debug	L 120
 	error_str	 db 'Fatal Error, Code = ',0
@13:
;	?debug	L 121
	ret	
_null	endp
;	?debug	L 125
_GetNextCluster	proc	near
	push	bp
	mov	bp,sp
	sub	sp,20
	push	si
	push	di
;	?debug	L 129
	mov	word ptr [bp-18],0
	mov	word ptr [bp-20],5632
;	?debug	L 130
	mov	ax,word ptr [bp+4]
	shr	ax,1
	mov	word ptr [bp-16],ax
;	?debug	L 131
	mov	ax,word ptr [bp-16]
	mov	dx,3
	mul	dx
	mov	si,ax
;	?debug	L 133
	mov	al,byte ptr [bp+4]
	and	al,1
	mov	byte ptr [bp-13],al
;	?debug	L 134
	mov	di,si
	mov	cl,9
	shr	di,cl
;	?debug	L 135
	mov	ax,si
	inc	ax
	inc	ax
	mov	cl,9
	shr	ax,cl
	mov	word ptr [bp-12],ax
;	?debug	L 136
	mov	ax,si
	and	ax,511
	mov	word ptr [bp-10],ax
;	?debug	L 141
	cmp	di,word ptr [bp-12]
	jne	@15
	mov	word ptr [bp-8],1
	jmp	short @16
@15:
;	?debug	L 142
	mov	word ptr [bp-8],2
@16:
;	?debug	L 144
	push	word ptr [bp-18]
	push	word ptr [bp-20]
	push	word ptr [bp+12]
	push	word ptr [bp+10]
	push	word ptr [bp+8]
	push	word ptr [bp-8]
	mov	ax,di
	add	ax,word ptr [bp+6]
	push	ax
	call	near ptr _ReadSector
	add	sp,14
;	?debug	L 146
	les	bx,dword ptr [bp-20]
	add	bx,word ptr [bp-10]
	mov	ax,word ptr es:[bx]
	mov	word ptr [bp-6],ax
;	?debug	L 147
	les	bx,dword ptr [bp-20]
	add	bx,word ptr [bp-10]
	mov	ax,word ptr es:[bx+2]
	mov	word ptr [bp-4],ax
;	?debug	L 148
	cmp	byte ptr [bp-13],0
	jne	@17
	mov	ax,word ptr [bp-6]
	and	ax,4095
	mov	word ptr [bp-2],ax
	jmp	short @18
@17:
;	?debug	L 149
	mov	ax,word ptr [bp-6]
	mov	cl,12
	shr	ax,cl
	mov	dx,word ptr [bp-4]
	and	dx,255
	mov	cl,4
	shl	dx,cl
	or	ax,dx
	mov	word ptr [bp-2],ax
@18:
;	?debug	L 150
	mov	ax,word ptr [bp-2]
	jmp	short @14
@14:
;	?debug	L 151
	pop	di
	pop	si
	mov	sp,bp
	pop	bp
	ret	
_GetNextCluster	endp
;	?debug	L 153
_ReadSector	proc	near
	push	bp
	mov	bp,sp
	sub	sp,4
;	?debug	L 156
	mov	ax,word ptr [bp+4]
	push	ax
	mov	ax,word ptr [bp+8]
	mul	word ptr [bp+10]
	mov	bx,ax
	pop	ax
	xor	dx,dx
	div	bx
	mov	word ptr [bp-4],ax
;	?debug	L 157
	mov	ax,word ptr [bp+4]
	xor	dx,dx
	div	word ptr [bp+8]
	xor	dx,dx
	div	word ptr [bp+10]
	mov	word ptr [bp-2],dx
;	?debug	L 158
	mov	ax,word ptr [bp+4]
	xor	dx,dx
	div	word ptr [bp+8]
	inc	dx
	mov	word ptr [bp+4],dx
;	?debug	L 159
	cmp	word ptr [bp-4],127
	ja	@21
	cmp	word ptr [bp-2],127
	ja	@21
	cmp	word ptr [bp+4],127
	ja	@21
	cmp	word ptr [bp+6],127
	jbe	@20
@21:
	mov	ax,-1
	push	ax
	call	near ptr _Error
	pop	cx
@20:
;	?debug	L 160
 	push	 es
;	?debug	L 161
 	push	 bx
;	?debug	L 162
 	mov	 al, byte ptr [bp+6]
;	?debug	L 163
 	mov	 ch, byte ptr [bp-4]
;	?debug	L 164
 	mov	 cl, byte ptr [bp+4]
;	?debug	L 165
 	mov	 dh, byte ptr [bp-2]
;	?debug	L 166
 	mov	 dl, byte ptr [bp+12]
;	?debug	L 167
 	mov	 ah, 02h
;	?debug	L 168
 	les	 bx, [bp+14]
;	?debug	L 169
 	int	 13h
;	?debug	L 170
 	jc	 @22
;	?debug	L 171
 	pop	 bx
;	?debug	L 172
 	pop	 es
	jmp	short @19
@22:
;	?debug	L 175
	mov	ax,-2
	push	ax
	call	near ptr _Error
	pop	cx
@19:
;	?debug	L 176
	mov	sp,bp
	pop	bp
	ret	
_ReadSector	endp
;	?debug	L 178
_ReadClusters	proc	near
	push	bp
	mov	bp,sp
	sub	sp,46
	push	si
;	?debug	L 180
	les	bx,dword ptr [bp+4]
	mov	al,byte ptr es:[bx+26]
	mov	ah,0
	mov	word ptr [bp-46],ax
;	?debug	L 181
	mov	word ptr [bp-42],0
	mov	word ptr [bp-44],31744
;	?debug	L 182
	les	bx,dword ptr [bp-44]
	mov	ax,word ptr es:[bx+24]
	mov	word ptr [bp-40],ax
;	?debug	L 183
	les	bx,dword ptr [bp-44]
	mov	ax,word ptr es:[bx+26]
	mov	word ptr [bp-38],ax
;	?debug	L 184
	les	bx,dword ptr [bp-44]
	mov	ax,word ptr es:[bx+22]
	mov	word ptr [bp-36],ax
;	?debug	L 185
	les	bx,dword ptr [bp-44]
	mov	al,byte ptr es:[bx+16]
	mov	byte ptr [bp-33],al
;	?debug	L 186
	les	bx,dword ptr [bp-44]
	mov	ax,word ptr es:[bx+14]
	mov	word ptr [bp-32],ax
;	?debug	L 187
	les	bx,dword ptr [bp-44]
	mov	dx,word ptr es:[bx+30]
	mov	ax,word ptr es:[bx+28]
	mov	word ptr [bp-28],dx
	mov	word ptr [bp-30],ax
;	?debug	L 188
	les	bx,dword ptr [bp-44]
	mov	ax,word ptr es:[bx+17]
	mov	word ptr [bp-26],ax
;	?debug	L 189
	les	bx,dword ptr [bp-44]
	mov	al,byte ptr es:[bx+13]
	mov	byte ptr [bp-24],al
;	?debug	L 190
	les	bx,dword ptr [bp-44]
	mov	al,byte ptr es:[bx+36]
	mov	byte ptr [bp-23],al
;	?debug	L 191
	mov	word ptr [bp-22],512
;	?debug	L 192
	mov	word ptr [bp-20],32
;	?debug	L 195
	mov	ax,word ptr [bp-32]
	xor	dx,dx
	add	ax,word ptr [bp-30]
	adc	dx,word ptr [bp-28]
	mov	bl,byte ptr [bp-33]
	mov	bh,0
	push	dx
	push	ax
	mov	ax,bx
	mul	word ptr [bp-36]
	xor	dx,dx
	pop	bx
	pop	cx
	add	bx,ax
	adc	cx,dx
	mov	word ptr [bp-16],cx
	mov	word ptr [bp-18],bx
;	?debug	L 196
	mov	ax,word ptr [bp-26]
	mul	word ptr [bp-20]
	add	ax,word ptr [bp-22]
	dec	ax
	xor	dx,dx
	div	word ptr [bp-22]
	xor	dx,dx
	add	ax,word ptr [bp-18]
	adc	dx,word ptr [bp-16]
	mov	word ptr [bp-12],dx
	mov	word ptr [bp-14],ax
;	?debug	L 197
	mov	ax,word ptr [bp-32]
	xor	dx,dx
	add	ax,word ptr [bp-30]
	adc	dx,word ptr [bp-28]
	mov	word ptr [bp-8],dx
	mov	word ptr [bp-10],ax
;	?debug	L 200
	mov	word ptr [bp-2],28672
	mov	word ptr [bp-4],0
;	?debug	L 201
	xor	si,si
;	?debug	L 208
	cmp	word ptr [bp-46],0
	jne	@24
	mov	ax,-4
	push	ax
	call	near ptr _Error
	pop	cx
@24:
	jmp	short @25
@27:
;	?debug	L 211
	mov	ax,word ptr [bp-46]
	add	ax,-2
	mov	dl,byte ptr [bp-24]
	mov	dh,0
	mul	dx
	mov	word ptr [bp-6],ax
;	?debug	L 212
	mov	ax,si
	mov	cl,9
	shl	ax,cl
	mov	cx,word ptr [bp-2]
	mov	bx,word ptr [bp-4]
	add	bx,ax
	push	cx
	push	bx
	push	word ptr [bp-23]
	push	word ptr [bp-38]
	push	word ptr [bp-40]
	mov	al,byte ptr [bp-24]
	mov	ah,0
	push	ax
	mov	ax,word ptr [bp-6]
	add	ax,word ptr [bp-14]
	push	ax
	call	near ptr _ReadSector
	add	sp,14
;	?debug	L 213
	mov	al,byte ptr [bp-23]
	mov	ah,0
	push	ax
	push	word ptr [bp-38]
	push	word ptr [bp-40]
	push	word ptr [bp-10]
	push	word ptr [bp-46]
	call	near ptr _GetNextCluster
	add	sp,10
	mov	word ptr [bp-46],ax
;	?debug	L 214
	inc	si
@25:
;	?debug	L 209
	cmp	word ptr [bp-46],4095
	jne	@27
@26:
;	?debug	L 217
 	jmp	 dword ptr [[bp-4]]
	jmp	short @23
@23:
;	?debug	L 220
	pop	si
	mov	sp,bp
	pop	bp
	ret	
_ReadClusters	endp
;	?debug	L 222
_ReadFile	proc	near
	push	bp
	mov	bp,sp
	sub	sp,10
	push	si
	push	di
;	?debug	L 224
	mov	word ptr [bp-8],0
	mov	word ptr [bp-10],0
;	?debug	L 225
	les	bx,dword ptr [bp-10]
	add	bx,1280
	mov	word ptr [bp-4],es
	mov	word ptr [bp-6],bx
;	?debug	L 230
 	mov	 [bp-2], offset kernel_filename
;	?debug	L 231
	xor	di,di
	jmp	short @32
@31:
;	?debug	L 233
	les	bx,dword ptr [bp-6]
	cmp	byte ptr es:[bx],0
	jne	@33
	jmp	short @29
@33:
;	?debug	L 234
	xor	si,si
	jmp	short @37
@36:
;	?debug	L 236
	les	bx,dword ptr [bp-6]
	mov	al,byte ptr es:[bx+si]
	mov	bx,word ptr [bp-2]
	cmp	al,byte ptr [bx+si]
	je	@38
	jmp	short @34
@38:
@35:
	inc	si
@37:
	cmp	si,11
	jl	@36
@34:
;	?debug	L 239
	cmp	si,11
	jne	@39
	push	word ptr [bp-4]
	push	word ptr [bp-6]
	call	near ptr _ReadClusters
	pop	cx
	pop	cx
	jmp	short @40
@39:
;	?debug	L 240
	add	word ptr [bp-6],32
@40:
@30:
	inc	di
@32:
	cmp	di,16
	jl	@31
@29:
;	?debug	L 242
	mov	ax,-3
	push	ax
	call	near ptr _Error
	pop	cx
@28:
;	?debug	L 243
	pop	di
	pop	si
	mov	sp,bp
	pop	bp
	ret	
_ReadFile	endp
;	?debug	L 318
_PrintShortHex	proc	near
	push	bp
	mov	bp,sp
;	?debug	L 320
 	push	 ax
;	?debug	L 321
 	push	 bx
;	?debug	L 322
 	push	 cx
;	?debug	L 323
 	mov	 cx, 12d
@42:
;	?debug	L 325
 	mov	 ax, [bp+4]
;	?debug	L 326
 	shr	 ax, cl
;	?debug	L 327
 	sub	 cx, 4
;	?debug	L 328
 	and	 ax, 0Fh
;	?debug	L 329
 	mov	 bx, ax
;	?debug	L 330
 	mov	 al, byte ptr [offset digit_table + bx]
;	?debug	L 331
 	mov	 ah, 0eh
;	?debug	L 332
 	xor	 bx, bx
;	?debug	L 333
 	mov	 bl, 07h
;	?debug	L 334
 	int	 10h
;	?debug	L 336
 	cmp	 cx, 0
;	?debug	L 337
 	jge	 @42
;	?debug	L 339
 	pop	 cx
;	?debug	L 340
 	pop	 bx
;	?debug	L 341
 	pop	 ax
@41:
;	?debug	L 342
	pop	bp
	ret	
_PrintShortHex	endp
_TEXT	ends
	?debug	C E9
_DATA	segment word public 'DATA'
s@	label	byte
_DATA	ends
_TEXT	segment	byte public 'CODE'
_TEXT	ends
	public	_PrintShortHex
	public	_GetNextCluster
	public	_ReadClusters
	public	_ReadSector
	public	_PrintString
	public	_ReadFile
	public	_SwitchTo4GB
	public	_Error
	public	_main
	public	_null
	end
