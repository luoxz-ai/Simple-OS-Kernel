	ifndef	??version
?debug	macro
	endm
	endif
	?debug	S "print.c"
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
	?debug	C E98E089E43077072696E742E63
	?debug	C E9BD9B2444132E2E5C696E636C7564655C6B65726E656C2E68
_BSS	ends
_DATA	segment word public 'DATA'
 	video_char_segment	 equ word ptr _video_char_ptr + 2
 	.486
 	.MODEL TINY
_DATA	ends
_TEXT	segment	byte public 'CODE'
;	?debug	L 20
_PutChar	proc	near
	push	bp
	mov	bp,sp
	push	si
;	?debug	L 24
	call	near ptr _UnDrawCursor
;	?debug	L 25
	cmp	byte ptr [bp+4],10
	jne	@2
;	?debug	L 27
	call	near ptr _GoNextRow
;	?debug	L 28
	jmp	short @3
@2:
;	?debug	L 29
	cmp	byte ptr [bp+4],13
	jne	@4
;	?debug	L 31
	call	near ptr _GoFirstColumn
;	?debug	L 32
	jmp	short @5
@4:
;	?debug	L 33
	cmp	byte ptr [bp+4],9
	jne	@6
;	?debug	L 36
	mov	ax,word ptr DGROUP:_current_col
	and	ax,3
	mov	si,4
	sub	si,ax
	jmp	short @10
@9:
;	?debug	L 38
	mov	al,32
	push	ax
	call	near ptr _PutChar
	pop	cx
@8:
	dec	si
@10:
	or	si,si
	jg	@9
@7:
;	?debug	L 39
	jmp	short @11
@6:
;	?debug	L 42
	mov	al,byte ptr [bp+4]
	les	bx,dword ptr DGROUP:_video_char_ptr
	add	bx,word ptr DGROUP:_current_offset
	mov	byte ptr es:[bx],al
;	?debug	L 43
	mov	al,byte ptr DGROUP:_default_mode
	mov	dx,word ptr DGROUP:_current_offset
	inc	dx
	les	bx,dword ptr DGROUP:_video_char_ptr
	add	bx,dx
	mov	byte ptr es:[bx],al
;	?debug	L 44
	call	near ptr _GoNextPosition
@11:
@5:
@3:
;	?debug	L 46
	call	near ptr _DrawCursor
;	?debug	L 47
	mov	al,byte ptr [bp+4]
	mov	ah,0
	jmp	short @1
@1:
;	?debug	L 48
	pop	si
	pop	bp
	ret	
_PutChar	endp
;	?debug	L 52
_PutString	proc	near
	push	bp
	mov	bp,sp
	push	si
;	?debug	L 54
	xor	si,si
	jmp	short @13
@15:
;	?debug	L 57
	les	bx,dword ptr [bp+4]
	inc	word ptr [bp+4]
	mov	al,byte ptr es:[bx]
	push	ax
	call	near ptr _PutChar
	pop	cx
;	?debug	L 58
	inc	si
@13:
;	?debug	L 55
	les	bx,dword ptr [bp+4]
	cmp	byte ptr es:[bx],0
	jne	@15
@14:
;	?debug	L 60
	mov	ax,si
	jmp	short @12
@12:
;	?debug	L 61
	pop	si
	pop	bp
	ret	
_PutString	endp
;	?debug	L 63
_PrintByteHex	proc	near
	push	bp
	mov	bp,sp
;	?debug	L 65
	mov	al,byte ptr [bp+4]
	mov	ah,0
	mov	bx,ax
	and	bx,240
	mov	cl,4
	sar	bx,cl
	push	word ptr DGROUP:_digit_table[bx]
	call	near ptr _PutChar
	pop	cx
;	?debug	L 66
	mov	al,byte ptr [bp+4]
	mov	ah,0
	mov	bx,ax
	and	bx,15
	push	word ptr DGROUP:_digit_table[bx]
	call	near ptr _PutChar
	pop	cx
;	?debug	L 67
	xor	ax,ax
	jmp	short @16
@16:
;	?debug	L 68
	pop	bp
	ret	
_PrintByteHex	endp
;	?debug	L 70
_PrintShortHex	proc	near
	push	bp
	mov	bp,sp
	sub	sp,4
;	?debug	L 74
	mov	word ptr [bp-4],12
	jmp	short @21
@20:
;	?debug	L 76
	mov	ax,word ptr [bp+4]
	mov	cl,byte ptr [bp-4]
	shr	ax,cl
	mov	word ptr [bp-2],ax
;	?debug	L 77
	and	word ptr [bp-2],15
;	?debug	L 78
	mov	bx,word ptr [bp-2]
	push	word ptr DGROUP:_digit_table[bx]
	call	near ptr _PutChar
	pop	cx
@19:
	sub	word ptr [bp-4],4
@21:
	cmp	word ptr [bp-4],0
	jge	@20
@18:
;	?debug	L 80
	xor	ax,ax
	jmp	short @17
@17:
;	?debug	L 81
	mov	sp,bp
	pop	bp
	ret	
_PrintShortHex	endp
;	?debug	L 83
_PrintLongHex	proc	near
	push	bp
	mov	bp,sp
	sub	sp,4
;	?debug	L 86
	mov	bx,ss
	mov	es,bx
	lea	bx,word ptr [bp+6]
	mov	word ptr [bp-2],es
	mov	word ptr [bp-4],bx
;	?debug	L 88
	les	bx,dword ptr [bp-4]
	push	word ptr es:[bx]
	call	near ptr _PrintShortHex
	pop	cx
;	?debug	L 90
	les	bx,dword ptr [bp-4]
	add	bx,-2
	push	word ptr es:[bx]
	call	near ptr _PrintShortHex
	pop	cx
;	?debug	L 91
	xor	ax,ax
	jmp	short @22
@22:
;	?debug	L 92
	mov	sp,bp
	pop	bp
	ret	
_PrintLongHex	endp
;	?debug	L 96
_PrintUnsignedShortDec	proc	near
	push	bp
	mov	bp,sp
	sub	sp,6
	push	si
	push	di
;	?debug	L 100
	xor	si,si
@26:
;	?debug	L 104
	mov	ax,word ptr [bp+4]
	mov	bx,10
	xor	dx,dx
	div	bx
	mov	bx,dx
	mov	al,byte ptr DGROUP:_digit_table[bx]
	mov	byte ptr ss:[bp+si-6],al
	inc	si
;	?debug	L 105
	mov	ax,word ptr [bp+4]
	mov	bx,10
	xor	dx,dx
	div	bx
	mov	word ptr [bp+4],ax
@24:
;	?debug	L 106
	cmp	word ptr [bp+4],0
	ja	@26
@25:
;	?debug	L 107
	mov	di,si
;	?debug	L 109
	jmp	short @27
@29:
	dec	si
	mov	bx,si
	lea	ax,word ptr [bp-6]
	add	bx,ax
	push	word ptr ss:[bx]
	call	near ptr _PutChar
	pop	cx
@27:
	or	si,si
	jg	@29
@28:
;	?debug	L 110
	mov	ax,di
	jmp	short @23
@23:
;	?debug	L 111
	pop	di
	pop	si
	mov	sp,bp
	pop	bp
	ret	
_PrintUnsignedShortDec	endp
;	?debug	L 113
_PrintSignedShortDec	proc	near
	push	bp
	mov	bp,sp
;	?debug	L 115
	cmp	word ptr [bp+4],0
	jge	@31
;	?debug	L 117
	mov	ax,word ptr [bp+4]
	neg	ax
	mov	word ptr [bp+4],ax
;	?debug	L 118
	mov	al,45
	push	ax
	call	near ptr _PutChar
	pop	cx
@31:
;	?debug	L 121
	push	word ptr [bp+4]
	call	near ptr _PrintUnsignedShortDec
	pop	cx
	inc	ax
	jmp	short @30
@30:
;	?debug	L 122
	pop	bp
	ret	
_PrintSignedShortDec	endp
;	?debug	L 124
_PrintUnsignedLongDec	proc	near
	push	bp
	mov	bp,sp
	sub	sp,2
;	?debug	L 128
 	xor	 ecx, ecx
;	?debug	L 130
 	mov	 ebx, 10
;	?debug	L 132
 	mov	 eax, [bp+4]
@33:
;	?debug	L 135
 	xor	 edx, edx
;	?debug	L 136
 	div	 ebx
;	?debug	L 137
 	inc	 ecx
;	?debug	L 138
 	push	 dx
;	?debug	L 139
 	test	 eax, eax
;	?debug	L 140
 	jz	 @34
;	?debug	L 141
 	jmp	 @33
@34:
;	?debug	L 144
 	mov	 word ptr [bp-2], cx
;	?debug	L 145
 	xor	 eax, eax
;	?debug	L 147
 	mov	 bx, offset _digit_table
@35:
;	?debug	L 150
 	pop	 ax
;	?debug	L 151
 	xlat	
;	?debug	L 153
 	push	 cx
;	?debug	L 154
 	push	 bx
;	?debug	L 155
 	push	 ax
;	?debug	L 156
 	call	 _PutChar
;	?debug	L 157
 	add	 sp, 2
;	?debug	L 159
 	pop	 bx
;	?debug	L 160
 	pop	 cx
;	?debug	L 161
 	loop	 @35
;	?debug	L 162
	mov	ax,word ptr [bp-2]
	jmp	short @32
@32:
;	?debug	L 163
	mov	sp,bp
	pop	bp
	ret	
_PrintUnsignedLongDec	endp
;	?debug	L 165
_PrintSignedLongDec	proc	near
	push	bp
	mov	bp,sp
	sub	sp,2
;	?debug	L 167
	mov	word ptr [bp-2],0
;	?debug	L 168
 	mov	 ebx, [bp+4]
;	?debug	L 169
 	xor	 eax, eax
;	?debug	L 170
 	cmp	 ebx, eax
;	?debug	L 172
 	jg	 @37
;	?debug	L 174
 	inc	 word ptr [bp-2]
;	?debug	L 176
 	push	 ebx
;	?debug	L 177
 	push	 word ptr '-'
;	?debug	L 178
 	call	 _PutChar
;	?debug	L 179
 	add	 sp, 2
;	?debug	L 180
 	pop	 ebx
;	?debug	L 181
 	neg	 ebx
@37:
;	?debug	L 183
 	push	 ebx
;	?debug	L 184
 	call	 _PrintUnsignedLongDec
;	?debug	L 185
 	add	 sp, 4
;	?debug	L 187
 	add	 ax, [bp-2]
	jmp	short @36
@36:
;	?debug	L 189
	mov	sp,bp
	pop	bp
	ret	
_PrintSignedLongDec	endp
;	?debug	L 191
_PrintShortBinary	proc	near
	push	bp
	mov	bp,sp
	push	si
;	?debug	L 194
	xor	si,si
	jmp	short @42
@41:
;	?debug	L 196
	test	word ptr [bp+4],-32768
	je	@43
	mov	al,49
	push	ax
	call	near ptr _PutChar
	pop	cx
	jmp	short @44
@43:
;	?debug	L 197
	mov	al,48
	push	ax
	call	near ptr _PutChar
	pop	cx
@44:
;	?debug	L 198
	shl	word ptr [bp+4],1
@40:
	inc	si
@42:
	cmp	si,16
	jl	@41
@39:
;	?debug	L 200
	mov	ax,16
	jmp	short @38
@38:
;	?debug	L 201
	pop	si
	pop	bp
	ret	
_PrintShortBinary	endp
;	?debug	L 203
_PrintLongBinary	proc	near
	push	bp
	mov	bp,sp
;	?debug	L 205
 	mov	 ax, [[bp+4] + 2]
;	?debug	L 206
 	push	 ax
;	?debug	L 207
 	call	 _PrintShortBinary
;	?debug	L 208
 	mov	 ax, [bp+4]
;	?debug	L 209
 	push	 ax
;	?debug	L 210
 	call	 _PrintShortBinary
;	?debug	L 212
 	add	 sp, 4
;	?debug	L 213
	mov	ax,32
	jmp	short @45
@45:
;	?debug	L 214
	pop	bp
	ret	
_PrintLongBinary	endp
;	?debug	L 218
_Printf	proc	near
	push	bp
	mov	bp,sp
	sub	sp,8
	push	si
;	?debug	L 220
	mov	bx,ss
	mov	es,bx
	lea	bx,word ptr [bp+6]
	mov	word ptr [bp-6],es
	mov	word ptr [bp-8],bx
;	?debug	L 221
	mov	bx,word ptr [bp+4]
	mov	al,byte ptr [bx]
	mov	byte ptr [bp-3],al
	inc	word ptr [bp+4]
;	?debug	L 224
	xor	si,si
	jmp	@47
@49:
;	?debug	L 227
	cmp	byte ptr [bp-3],37
	je	@78
	jmp	@50
@78:
;	?debug	L 229
	mov	bx,word ptr [bp+4]
	mov	al,byte ptr [bx]
	mov	byte ptr [bp-2],al
	inc	word ptr [bp+4]
;	?debug	L 230
	cmp	byte ptr [bp-2],37
	jne	@51
	mov	al,37
	push	ax
	call	near ptr _PutChar
	pop	cx
	inc	si
	jmp	@52
@51:
;	?debug	L 231
	cmp	byte ptr [bp-2],100
	jne	@53
;	?debug	L 233
	les	bx,dword ptr [bp-8]
	push	word ptr es:[bx]
	call	near ptr _PrintSignedShortDec
	pop	cx
	add	si,ax
;	?debug	L 234
	add	word ptr [bp-8],2
;	?debug	L 235
	jmp	@54
@53:
;	?debug	L 236
	cmp	byte ptr [bp-2],117
	jne	@55
;	?debug	L 238
	les	bx,dword ptr [bp-8]
	push	word ptr es:[bx]
	call	near ptr _PrintUnsignedShortDec
	pop	cx
	add	si,ax
;	?debug	L 239
	add	word ptr [bp-8],2
;	?debug	L 240
	jmp	@56
@55:
;	?debug	L 241
	cmp	byte ptr [bp-2],120
	je	@58
	cmp	byte ptr [bp-2],88
	jne	@57
@58:
;	?debug	L 243
	les	bx,dword ptr [bp-8]
	push	word ptr es:[bx]
	call	near ptr _PrintShortHex
	pop	cx
	add	si,ax
;	?debug	L 244
	add	word ptr [bp-8],2
;	?debug	L 245
	jmp	@59
@57:
;	?debug	L 246
	cmp	byte ptr [bp-2],108
	je	@79
	jmp	@60
@79:
;	?debug	L 248
	mov	bx,word ptr [bp+4]
	mov	al,byte ptr [bx]
	mov	byte ptr [bp-1],al
	inc	word ptr [bp+4]
;	?debug	L 249
	cmp	byte ptr [bp-1],100
	jne	@61
;	?debug	L 251
	les	bx,dword ptr [bp-8]
	push	word ptr es:[bx+2]
	push	word ptr es:[bx]
	call	near ptr _PrintSignedLongDec
	pop	cx
	pop	cx
	add	si,ax
;	?debug	L 252
	add	word ptr [bp-8],4
;	?debug	L 253
	jmp	@62
@61:
;	?debug	L 254
	cmp	byte ptr [bp-1],117
	jne	@63
;	?debug	L 256
	les	bx,dword ptr [bp-8]
	push	word ptr es:[bx+2]
	push	word ptr es:[bx]
	call	near ptr _PrintUnsignedLongDec
	pop	cx
	pop	cx
	add	si,ax
;	?debug	L 257
	add	word ptr [bp-8],4
;	?debug	L 258
	jmp	short @64
@63:
;	?debug	L 259
	cmp	byte ptr [bp-1],120
	je	@66
	cmp	byte ptr [bp-1],88
	jne	@65
@66:
;	?debug	L 261
	les	bx,dword ptr [bp-8]
	push	word ptr es:[bx+2]
	push	word ptr es:[bx]
	call	near ptr _PrintLongHex
	pop	cx
	pop	cx
	add	si,ax
;	?debug	L 262
	add	word ptr [bp-8],4
;	?debug	L 263
	jmp	short @67
@65:
;	?debug	L 264
	cmp	byte ptr [bp-1],0
	jne	@68
;	?debug	L 266
	les	bx,dword ptr [bp-8]
	push	word ptr es:[bx+2]
	push	word ptr es:[bx]
	call	near ptr _PrintSignedLongDec
	pop	cx
	pop	cx
	add	si,ax
;	?debug	L 267
	add	word ptr [bp-8],4
;	?debug	L 268
	jmp	@48
;	?debug	L 269
	jmp	short @69
@68:
;	?debug	L 272
	dec	word ptr [bp+4]
;	?debug	L 273
	les	bx,dword ptr [bp-8]
	push	word ptr es:[bx+2]
	push	word ptr es:[bx]
	call	near ptr _PrintSignedLongDec
	pop	cx
	pop	cx
	add	si,ax
;	?debug	L 274
	add	word ptr [bp-8],4
@69:
@67:
@64:
@62:
;	?debug	L 276
	jmp	short @70
@60:
;	?debug	L 277
	cmp	byte ptr [bp-2],115
	jne	@71
;	?debug	L 279
	les	bx,dword ptr [bp-8]
	push	word ptr es:[bx+2]
	push	word ptr es:[bx]
	call	near ptr _PutString
	pop	cx
	pop	cx
	add	si,ax
;	?debug	L 280
	add	word ptr [bp-8],4
;	?debug	L 281
	jmp	short @72
@71:
;	?debug	L 282
	cmp	byte ptr [bp-2],0
	jne	@73
;	?debug	L 284
	mov	al,37
	push	ax
	call	near ptr _PutChar
	pop	cx
;	?debug	L 285
	inc	si
;	?debug	L 286
	jmp	short @48
;	?debug	L 287
	jmp	short @74
@73:
;	?debug	L 290
	dec	word ptr [bp+4]
;	?debug	L 291
	inc	si
;	?debug	L 292
	mov	al,37
	push	ax
	call	near ptr _PutChar
	pop	cx
@74:
@72:
@70:
@59:
@56:
@54:
@52:
;	?debug	L 294
	jmp	short @75
@50:
;	?debug	L 295
	cmp	byte ptr [bp-3],0
	jne	@76
;	?debug	L 297
	push	word ptr [bp-3]
	call	near ptr _PutChar
	pop	cx
;	?debug	L 298
	inc	si
;	?debug	L 299
	jmp	short @48
;	?debug	L 300
	jmp	short @77
@76:
;	?debug	L 303
	push	word ptr [bp-3]
	call	near ptr _PutChar
	pop	cx
;	?debug	L 304
	inc	si
@77:
@75:
;	?debug	L 306
	mov	bx,word ptr [bp+4]
	mov	al,byte ptr [bx]
	mov	byte ptr [bp-3],al
	inc	word ptr [bp+4]
@47:
;	?debug	L 225
	cmp	byte ptr [bp-3],0
	je	@80
	jmp	@49
@80:
@48:
;	?debug	L 308
	mov	ax,si
	jmp	short @46
@46:
;	?debug	L 309
	pop	si
	mov	sp,bp
	pop	bp
	ret	
_Printf	endp
_TEXT	ends
	?debug	C E9
_DATA	segment word public 'DATA'
s@	label	byte
_DATA	ends
	extrn	_video_char_ptr:dword
	extrn	_current_offset:word
	extrn	_default_mode:byte
	extrn	_current_col:word
	extrn	_digit_table:byte
_TEXT	segment	byte public 'CODE'
	extrn	_GoNextPosition:near
	extrn	_GoFirstColumn:near
	extrn	_UnDrawCursor:near
	extrn	_DrawCursor:near
	extrn	_GoNextRow:near
_TEXT	ends
	public	_PrintShortHex
	public	_PrintLongHex
	public	_PrintByteHex
	public	_PutString
	public	_PutChar
	public	_Printf
	public	_PrintUnsignedShortDec
	public	_PrintUnsignedLongDec
	public	_PrintSignedShortDec
	public	_PrintShortBinary
	public	_PrintSignedLongDec
	public	_PrintLongBinary
	end
