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
	?debug	C E9F0ACF44406746573742E63
_BSS	ends
_TEXT	segment	byte public 'CODE'
;	?debug	L 12
_main	proc	near
;	?debug	L 14
	mov	bx,offset DGROUP:_temp2
	push	ds
	push	bx
	mov	bx,offset DGROUP:_temp
	push	ds
	push	bx
	mov	cx,13
	push	cs
	call	near ptr SCOPY@
	jmp	short @1
@1:
;	?debug	L 16
	ret	
_main	endp
_TEXT	ends
_BSS	segment word public 'BSS'
_temp2	label	word
	db	13 dup (?)
_temp	label	word
	db	13 dup (?)
_BSS	ends
	?debug	C E9
_DATA	segment word public 'DATA'
s@	label	byte
_DATA	ends
	extrn	SCOPY@:far
_TEXT	segment	byte public 'CODE'
_TEXT	ends
	public	_temp
	public	_main
	public	_temp2
	end
