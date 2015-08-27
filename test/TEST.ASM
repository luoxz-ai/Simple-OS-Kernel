	ifndef	??version
?debug	macro
	endm
	endif
	?debug	S "test.c"
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
	?debug	C E99D1B944306746573742E63
_BSS	ends
_TEXT	segment	byte public 'CODE'
;	?debug	L 17
_main	proc	near
	push	si
	push	di
;	?debug	L 19
 	xor	 ax, ax
;	?debug	L 20
 	mov	 al, 01h
;	?debug	L 21
 	int	 10h
;	?debug	L 22
 	push	 0b800h
;	?debug	L 23
 	pop	 es
;	?debug	L 24
 	xor	 di, di
;	?debug	L 25
 	cld	
;	?debug	L 26
 	mov	 ax, cs
;	?debug	L 30
 	mov	 ds, ax
;	?debug	L 31
 	mov	 si, offset str_start
;	?debug	L 32
 	mov	 cx, offset str_end - offset str_start
;	?debug	L 33
 	rep movsb	
;	?debug	L 35
 	mov	 di, 87d
;	?debug	L 36
 	mov	 ax, cs
;	?debug	L 37
 	mov	 bx, offset char_table
;	?debug	L 38
 	mov	 cx, 4
;	?debug	L 39
 	std	
@2:
;	?debug	L 41
 	mov	 dx, ax
;	?debug	L 42
 	and	 dx, 000Fh
;	?debug	L 43
 	mov	 si, dx
;	?debug	L 44
 	push	 ax
;	?debug	L 45
 	mov	 al, ' '
;	?debug	L 46
 	stosb	
;	?debug	L 47
 	mov	 al, byte ptr [bx + si]
;	?debug	L 48
 	stosb	
;	?debug	L 49
 	pop	 ax
;	?debug	L 50
 	shr	 ax, 4
;	?debug	L 51
 	loop	 @2
;	?debug	L 52
 	cld	
;	?debug	L 53
	jmp	short @3
@5:
@3:
	jmp	short @5
@4:
@1:
;	?debug	L 54
	pop	di
	pop	si
	ret	
_main	endp
;	?debug	L 56
_null	proc	near
;	?debug	L 58
 	db	 2000 dup('*')
;	?debug	L 60
 	str_start	:
;	?debug	L 61
 	db	 "T h i s   i s   a   s t r i n g "
;	?debug	L 62
 	str_end	:
;	?debug	L 63
 	char_table	:
;	?debug	L 64
 	db	 '0123456789ABCDEF'
@6:
;	?debug	L 65
	ret	
_null	endp
_TEXT	ends
	?debug	C E9
_DATA	segment word public 'DATA'
s@	label	byte
_DATA	ends
_TEXT	segment	byte public 'CODE'
_TEXT	ends
	public	_main
	public	_null
	end
