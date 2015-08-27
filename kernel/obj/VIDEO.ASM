	ifndef	??version
?debug	macro
	endm
	endif
	?debug	S "video.c"
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
	?debug	C E9C1059E4307766964656F2E63
	?debug	C E9BD9B2444132E2E5C696E636C7564655C6B65726E656C2E68
_BSS	ends
_DATA	segment word public 'DATA'
 	video_char_segment	 equ word ptr _video_char_ptr + 2
 	_DATA	 ends
 	_TEXT	 segment byte public 'CODE'
 	.486
 	.MODEL TINY
_video_char_ptr	label	dword
	dw	0
	dw	-18432
_video_mode	label	word
	dw	0
_current_col	label	word
	dw	0
_current_row	label	word
	dw	0
_total_col	label	word
	dw	80
_total_row	label	word
	dw	25
_start_col	label	word
	dw	0
_start_row	label	word
	dw	0
_default_mode	label	byte
	db	7
_current_offset	label	word
	dw	0
_cursor_char	label	byte
	db	32
_cursor_mode	label	byte
	db	112
_under_cursor_char	label	byte
	db	0
_under_cursor_mode	label	byte
	db	7
 	_TEXT	 ends
 	_DATA	 segment word public 'DATA'
_DATA	ends
_TEXT	segment	byte public 'CODE'
;	?debug	L 41
_ClearScreen	proc	near
	push	bp
	mov	bp,sp
	sub	sp,2
	push	si
;	?debug	L 45
	mov	al,byte ptr [bp+12]
	mov	ah,0
	mov	cl,8
	shl	ax,cl
	mov	word ptr [bp-2],ax
;	?debug	L 47
	mov	ax,word ptr [bp+4]
	mov	word ptr DGROUP:_start_row,ax
;	?debug	L 48
	mov	ax,word ptr [bp+6]
	mov	word ptr DGROUP:_start_col,ax
;	?debug	L 49
	mov	ax,word ptr [bp+8]
	mov	word ptr DGROUP:_total_row,ax
;	?debug	L 50
	mov	ax,word ptr [bp+10]
	mov	word ptr DGROUP:_total_col,ax
;	?debug	L 51
	mov	al,byte ptr [bp+12]
	mov	byte ptr DGROUP:_default_mode,al
;	?debug	L 53
	mov	al,byte ptr [bp+12]
	mov	byte ptr DGROUP:_under_cursor_mode,al
;	?debug	L 54
	mov	word ptr DGROUP:_current_row,0
;	?debug	L 55
	mov	word ptr DGROUP:_current_col,0
;	?debug	L 56
	xor	ax,ax
	push	ax
	xor	ax,ax
	push	ax
	call	near ptr _GetVideoOffset
	pop	cx
	pop	cx
	mov	word ptr DGROUP:_current_offset,ax
;	?debug	L 57
	xor	si,si
	jmp	short @5
@4:
	push	word ptr [bp-2]
	push	si
	call	near ptr _ClearLine
	pop	cx
	pop	cx
@3:
	inc	si
@5:
	mov	ax,word ptr DGROUP:_total_row
	sub	ax,word ptr DGROUP:_start_row
	cmp	ax,si
	ja	@4
@2:
	jmp	short @1
@1:
;	?debug	L 59
	pop	si
	mov	sp,bp
	pop	bp
	ret	
_ClearScreen	endp
;	?debug	L 61
_GetVideoPointer	proc	near
;	?debug	L 63
	mov	dx,word ptr DGROUP:_video_char_ptr+2
	mov	ax,word ptr DGROUP:_video_char_ptr
	jmp	short @6
@6:
;	?debug	L 64
	ret	
_GetVideoPointer	endp
;	?debug	L 66
_InitVideo	proc	near
	push	bp
	mov	bp,sp
;	?debug	L 69
 	xor	 ax, ax
;	?debug	L 70
 	mov	 al, [bp+4]
;	?debug	L 71
 	mov	 DGROUP:_video_mode, ax
;	?debug	L 73
 	mov	 word ptr DGROUP:_current_row, 0000h
;	?debug	L 75
 	mov	 word ptr DGROUP:_current_col, 0000h
;	?debug	L 77
 	mov	 word ptr DGROUP:_start_row, 0000h
;	?debug	L 79
 	mov	 word ptr DGROUP:_start_col, 0000h
;	?debug	L 80
 	mov	 ah, 00h
;	?debug	L 81
 	mov	 al, [bp+4]
;	?debug	L 82
 	int	 10h
;	?debug	L 84
 	mov	 ah, 01h
;	?debug	L 85
 	mov	 cx, 2607h
;	?debug	L 86
 	int	 10h
;	?debug	L 88
 	xor	 ax, ax
;	?debug	L 89
 	push	 ax
;	?debug	L 90
 	push	 ax
;	?debug	L 91
 	call	 _GetVideoOffset
;	?debug	L 92
 	add	 sp, 4
;	?debug	L 93
 	mov	 DGROUP:_current_offset, ax
;	?debug	L 94
	jmp	short @7
@7:
;	?debug	L 95
	pop	bp
	ret	
_InitVideo	endp
;	?debug	L 97
_GetVideoMode	proc	near
;	?debug	L 99
 	mov	 ax, DGROUP:_video_mode
;	?debug	L 100
 	mov	 sp, bp
;	?debug	L 101
 	pop	 bp
;	?debug	L 102
 	retn	
@8:
;	?debug	L 103
	ret	
_GetVideoMode	endp
;	?debug	L 105
_GetNextColumn	proc	near
;	?debug	L 107
 	mov	 ax, DGROUP:_current_col
;	?debug	L 109
 	mov	 cx, ax
;	?debug	L 110
 	add	 cx, DGROUP:_start_col
;	?debug	L 111
 	inc	 cx
;	?debug	L 112
 	cmp	 cx, DGROUP:_total_col
;	?debug	L 113
 	jae	 @10
;	?debug	L 114
 	inc	 ax
;	?debug	L 115
 	jmp	 @11
@10:
;	?debug	L 117
 	xor	 ax, ax
@11:
	jmp	short @9
@9:
;	?debug	L 124
	ret	
_GetNextColumn	endp
;	?debug	L 126
_GetNextRow	proc	near
;	?debug	L 128
 	mov	 ax, DGROUP:_current_row
;	?debug	L 129
 	mov	 cx, ax
;	?debug	L 130
 	add	 cx, DGROUP:_start_row
;	?debug	L 131
 	inc	 cx
;	?debug	L 132
 	cmp	 cx, DGROUP:_total_row
;	?debug	L 133
 	jae	 @13
;	?debug	L 134
 	inc	 ax
;	?debug	L 135
 	jmp	 @14
@13:
;	?debug	L 137
 	mov	 ax, DGROUP:_total_row
;	?debug	L 138
 	sub	 ax, DGROUP:_start_row
;	?debug	L 139
 	dec	 ax
@14:
	jmp	short @12
@12:
;	?debug	L 146
	ret	
_GetNextRow	endp
;	?debug	L 148
_GetPreviousRow	proc	near
;	?debug	L 150
	cmp	word ptr DGROUP:_current_row,0
	jne	@16
	xor	ax,ax
	jmp	short @15
	jmp	short @17
@16:
;	?debug	L 151
	mov	ax,word ptr DGROUP:_current_row
	dec	ax
	jmp	short @15
@17:
@15:
;	?debug	L 152
	ret	
_GetPreviousRow	endp
;	?debug	L 154
_GetPreviousColumn	proc	near
;	?debug	L 156
	cmp	word ptr DGROUP:_current_col,0
	jne	@19
	mov	ax,word ptr DGROUP:_total_col
	sub	ax,word ptr DGROUP:_start_col
	dec	ax
	jmp	short @18
	jmp	short @20
@19:
;	?debug	L 157
	mov	ax,word ptr DGROUP:_current_col
	dec	ax
	jmp	short @18
@20:
@18:
;	?debug	L 158
	ret	
_GetPreviousColumn	endp
;	?debug	L 166
_GetVideoOffset	proc	near
	push	bp
	mov	bp,sp
;	?debug	L 169
 	mov	 ax, DGROUP:_start_row
;	?debug	L 170
 	add	 [bp+4], ax
;	?debug	L 171
 	mov	 ax, DGROUP:_start_col
;	?debug	L 172
 	add	 [bp+6], ax
;	?debug	L 174
 	mov	 ax, [bp+4]
;	?debug	L 177
 	mov	 bx, ax
;	?debug	L 178
 	shl	 ax, 4
;	?debug	L 179
 	shl	 bx, 6
;	?debug	L 180
 	add	 ax, bx
;	?debug	L 182
 	add	 ax, [bp+6]
;	?debug	L 184
 	shl	 ax, 1
	jmp	short @21
@21:
;	?debug	L 186
	pop	bp
	ret	
_GetVideoOffset	endp
;	?debug	L 190
_CopyLine	proc	near
	push	bp
	mov	bp,sp
	sub	sp,4
	push	si
	push	di
;	?debug	L 194
 	push	 si
;	?debug	L 195
 	push	 di
;	?debug	L 197
 	mov	 si, [bp+6]
;	?debug	L 198
 	mov	 di, [bp+4]
;	?debug	L 201
 	mov	 dx, DGROUP:_total_col
;	?debug	L 202
 	sub	 dx, DGROUP:_start_col
;	?debug	L 203
 	shl	 dx, 1
;	?debug	L 205
 	mov	 [bp-4], dx
;	?debug	L 207
 	push	 0
;	?debug	L 208
 	push	 si
;	?debug	L 209
 	call	 _GetVideoOffset
;	?debug	L 210
 	add	 sp, 4
;	?debug	L 211
 	mov	 [bp-2], ax
;	?debug	L 213
 	push	 0
;	?debug	L 214
 	push	 di
;	?debug	L 216
 	call	 _GetVideoOffset
;	?debug	L 217
 	add	 sp, 4
;	?debug	L 218
 	push	 word ptr [bp-4]
;	?debug	L 219
 	push	 word ptr [bp-2]
;	?debug	L 220
 	push	 ax
;	?debug	L 221
 	push	 video_char_segment
;	?debug	L 222
 	call	 _SegmentCopy
;	?debug	L 223
 	add	 sp, 8
;	?debug	L 225
 	pop	 di
;	?debug	L 226
 	pop	 si
	jmp	short @22
@22:
;	?debug	L 228
	pop	di
	pop	si
	mov	sp,bp
	pop	bp
	ret	
_CopyLine	endp
;	?debug	L 232
_ClearLine	proc	near
	push	bp
	mov	bp,sp
;	?debug	L 234
 	push	 0
;	?debug	L 235
 	push	 word ptr [bp+4]
;	?debug	L 237
 	call	 _GetVideoOffset
;	?debug	L 238
 	add	 sp, 4
;	?debug	L 240
 	mov	 cx, DGROUP:_total_col
;	?debug	L 241
 	sub	 cx, DGROUP:_start_col
;	?debug	L 243
 	push	 cx
;	?debug	L 244
 	push	 [bp+6]
;	?debug	L 245
 	push	 video_char_segment
;	?debug	L 246
 	push	 ax
;	?debug	L 247
 	call	 _SegmentSetWord
;	?debug	L 248
 	add	 sp, 8
	jmp	short @23
@23:
;	?debug	L 250
	pop	bp
	ret	
_ClearLine	endp
;	?debug	L 255
_VideoScrollUp	proc	near
	push	bp
	mov	bp,sp
	sub	sp,4
;	?debug	L 258
 	mov	 cx, DGROUP:_total_row
;	?debug	L 260
 	sub	 cx, DGROUP:_start_row
;	?debug	L 261
 	sub	 cx, [bp+4]
;	?debug	L 264
 	xor	 ax, ax
;	?debug	L 265
 	mov	 [bp-2], ax
;	?debug	L 266
 	add	 ax, [bp+4]
;	?debug	L 267
 	mov	 [bp-4], ax
@25:
;	?debug	L 269
 	push	 cx
;	?debug	L 271
 	push	 word ptr [[bp-4]]
;	?debug	L 272
 	push	 word ptr [[bp-2]]
;	?debug	L 273
 	call	 _CopyLine
;	?debug	L 274
 	add	 sp, 4
;	?debug	L 276
 	mov	 ah, byte ptr DGROUP:_default_mode
;	?debug	L 277
 	xor	 al, al
;	?debug	L 278
 	push	 ax
;	?debug	L 279
 	push	 word ptr [[bp-4]]
;	?debug	L 280
 	call	 _ClearLine
;	?debug	L 281
 	add	 sp, 4
;	?debug	L 283
 	inc	 word ptr [[bp-4]]
;	?debug	L 284
 	inc	 word ptr [[bp-2]]
;	?debug	L 285
 	pop	 cx
;	?debug	L 286
 	loop	 @25
	jmp	short @24
@24:
;	?debug	L 288
	mov	sp,bp
	pop	bp
	ret	
_VideoScrollUp	endp
;	?debug	L 293
_GoNextPosition	proc	near
;	?debug	L 295
 	call	 _GetNextColumn
;	?debug	L 296
 	mov	 DGROUP:_current_col, ax
;	?debug	L 298
 	cmp	 ax, 0
;	?debug	L 299
 	jnz	 @27
;	?debug	L 301
 	call	 _GetNextRow
;	?debug	L 304
 	cmp	 ax, DGROUP:_current_row
;	?debug	L 306
 	mov	 DGROUP:_current_row, ax
;	?debug	L 308
 	jz	 @28
;	?debug	L 311
 	mov	 ax, DGROUP:_start_col
;	?debug	L 312
 	add	 ax, 81
;	?debug	L 313
 	sub	 ax, DGROUP:_total_col
;	?debug	L 314
 	shl	 ax, 1
;	?debug	L 315
 	add	 DGROUP:_current_offset, ax
;	?debug	L 316
 	jmp	 @29
@28:
;	?debug	L 319
 	push	 word ptr 1
;	?debug	L 320
 	call	 _VideoScrollUp
;	?debug	L 321
 	add	 sp, 2
;	?debug	L 323
 	mov	 ax, DGROUP:_total_col
;	?debug	L 324
 	sub	 ax, DGROUP:_start_col
;	?debug	L 325
 	dec	 ax
;	?debug	L 326
 	shl	 ax, 1
;	?debug	L 327
 	sub	 DGROUP:_current_offset, ax
;	?debug	L 328
 	jmp	 @29
@27:
;	?debug	L 332
 	mov	 ax, DGROUP:_current_col
;	?debug	L 334
 	add	 DGROUP:_current_offset, 2
;	?debug	L 335
 	jmp	 @29
@29:
	jmp	short @26
@26:
;	?debug	L 339
	ret	
_GoNextPosition	endp
;	?debug	L 343
_GoPreviousPosition	proc	near
	push	bp
	mov	bp,sp
	sub	sp,4
;	?debug	L 345
	call	near ptr _GetPreviousColumn
	mov	word ptr [bp-4],ax
;	?debug	L 348
	mov	ax,word ptr DGROUP:_total_col
	sub	ax,word ptr DGROUP:_start_col
	dec	ax
	cmp	ax,word ptr [bp-4]
	jne	@31
;	?debug	L 350
	call	near ptr _GetPreviousRow
	mov	word ptr [bp-2],ax
;	?debug	L 352
	mov	ax,word ptr [bp-2]
	cmp	ax,word ptr DGROUP:_current_row
	jne	@32
;	?debug	L 355
	mov	word ptr DGROUP:_current_row,0
;	?debug	L 356
	mov	word ptr DGROUP:_current_col,0
;	?debug	L 357
	mov	word ptr DGROUP:_current_offset,0
;	?debug	L 358
	mov	ax,1
	jmp	short @30
;	?debug	L 359
	jmp	short @33
@32:
;	?debug	L 362
	mov	ax,word ptr [bp-2]
	mov	word ptr DGROUP:_current_row,ax
;	?debug	L 363
	mov	ax,word ptr [bp-4]
	mov	word ptr DGROUP:_current_col,ax
;	?debug	L 364
	push	word ptr DGROUP:_current_col
	push	word ptr DGROUP:_current_row
	call	near ptr _GetVideoOffset
	pop	cx
	pop	cx
	mov	word ptr DGROUP:_current_offset,ax
;	?debug	L 365
	xor	ax,ax
	jmp	short @30
@33:
;	?debug	L 367
	jmp	short @34
@31:
;	?debug	L 370
	mov	ax,word ptr [bp-4]
	mov	word ptr DGROUP:_current_col,ax
;	?debug	L 371
	push	word ptr DGROUP:_current_col
	push	word ptr DGROUP:_current_row
	call	near ptr _GetVideoOffset
	pop	cx
	pop	cx
	mov	word ptr DGROUP:_current_offset,ax
;	?debug	L 372
	xor	ax,ax
	jmp	short @30
@34:
;	?debug	L 375
	mov	ax,-1
	jmp	short @30
@30:
;	?debug	L 376
	mov	sp,bp
	pop	bp
	ret	
_GoPreviousPosition	endp
;	?debug	L 381
_GoNextRow	proc	near
;	?debug	L 383
	mov	ax,word ptr DGROUP:_total_col
	sub	ax,word ptr DGROUP:_start_col
	dec	ax
	mov	word ptr DGROUP:_current_col,ax
;	?debug	L 384
	push	word ptr DGROUP:_current_col
	push	word ptr DGROUP:_current_row
	call	near ptr _GetVideoOffset
	pop	cx
	pop	cx
	mov	word ptr DGROUP:_current_offset,ax
;	?debug	L 385
	call	near ptr _GoNextPosition
@35:
;	?debug	L 386
	ret	
_GoNextRow	endp
;	?debug	L 388
_GoFirstColumn	proc	near
;	?debug	L 390
	mov	word ptr DGROUP:_current_col,0
;	?debug	L 391
	push	word ptr DGROUP:_current_col
	push	word ptr DGROUP:_current_row
	call	near ptr _GetVideoOffset
	pop	cx
	pop	cx
	mov	word ptr DGROUP:_current_offset,ax
	jmp	short @36
@36:
;	?debug	L 393
	ret	
_GoFirstColumn	endp
;	?debug	L 395
_UnDrawCursor	proc	near
;	?debug	L 398
	mov	al,byte ptr DGROUP:_under_cursor_char
	les	bx,dword ptr DGROUP:_video_char_ptr
	add	bx,word ptr DGROUP:_current_offset
	mov	byte ptr es:[bx],al
;	?debug	L 399
	mov	al,byte ptr DGROUP:_under_cursor_mode
	mov	dx,word ptr DGROUP:_current_offset
	inc	dx
	les	bx,dword ptr DGROUP:_video_char_ptr
	add	bx,dx
	mov	byte ptr es:[bx],al
	jmp	short @37
@37:
;	?debug	L 401
	ret	
_UnDrawCursor	endp
;	?debug	L 404
_DrawCursor	proc	near
;	?debug	L 407
	les	bx,dword ptr DGROUP:_video_char_ptr
	add	bx,word ptr DGROUP:_current_offset
	mov	al,byte ptr es:[bx]
	mov	byte ptr DGROUP:_under_cursor_char,al
;	?debug	L 408
	mov	ax,word ptr DGROUP:_current_offset
	inc	ax
	les	bx,dword ptr DGROUP:_video_char_ptr
	add	bx,ax
	mov	al,byte ptr es:[bx]
	mov	byte ptr DGROUP:_under_cursor_mode,al
;	?debug	L 409
	mov	al,byte ptr DGROUP:_cursor_char
	les	bx,dword ptr DGROUP:_video_char_ptr
	add	bx,word ptr DGROUP:_current_offset
	mov	byte ptr es:[bx],al
;	?debug	L 410
	mov	al,byte ptr DGROUP:_cursor_mode
	mov	dx,word ptr DGROUP:_current_offset
	inc	dx
	les	bx,dword ptr DGROUP:_video_char_ptr
	add	bx,dx
	mov	byte ptr es:[bx],al
	jmp	short @38
@38:
;	?debug	L 412
	ret	
_DrawCursor	endp
;	?debug	L 414
_MoveCursor	proc	near
@39:
;	?debug	L 417
	ret	
_MoveCursor	endp
_TEXT	ends
	?debug	C E9
_DATA	segment word public 'DATA'
s@	label	byte
_DATA	ends
_TEXT	segment	byte public 'CODE'
	extrn	_SegmentSetWord:near
	extrn	_SegmentCopy:near
_TEXT	ends
	public	_video_char_ptr
	public	_current_offset
	public	_GetVideoPointer
	public	_GetPreviousRow
	public	_GetVideoOffset
	public	_GoNextPosition
	public	_VideoScrollUp
	public	_GoFirstColumn
	public	_GetNextColumn
	public	_current_row
	public	_UnDrawCursor
	public	_cursor_char
	public	_default_mode
	public	_current_col
	public	_total_row
	public	_start_row
	public	_GetNextRow
	public	_ClearScreen
	public	_GetVideoMode
	public	_cursor_mode
	public	_MoveCursor
	public	_DrawCursor
	public	_video_mode
	public	_total_col
	public	_GoNextRow
	public	_start_col
	public	_InitVideo
	public	_ClearLine
	public	_CopyLine
	public	_under_cursor_char
	public	_GoPreviousPosition
	public	_under_cursor_mode
	public	_GetPreviousColumn
	end
