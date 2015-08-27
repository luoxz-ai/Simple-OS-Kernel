
BIO_SEG		EQU	80H		; Destingation segment of BIOS
BIO_OFFSET	EQU	800H
DIR_ENTRY_SIZE	EQU	32		; Size of directory entry in bytes

CODE	SEGMENT
	.386
	ASSUME CS:CODE,DS:NOTHING,ES:NOTHING,SS:NOTHING
	ORG	7C00H
$START:
	jmp	Main
	;Here is an automatic NOP, so please add 1 to all offsets

OsVersion	DB	"WANGZIQI"	; DOS version number
BytesPerSector	DW	0200h		; Size of a physical sector
SecsPerClust	DB	01		; Sectors per allocation unit
ReservedSecs	DW	0001		; Number of reserved sectors
NumFats		DB	02		; Number of fats
NumDirEntries	DW	00e0h		; Number of direc entries
TotalSectors	DW	0b40h		; Number of sectors - number of hidden
					; sectors (0 when 32 bit sector number)
MediaByte	DB	0F0H		; MediaByte byte
NumFatSecs	DW	0009h		; Number of fat sectors
SecPerTrack	DW	0012h		; Sectors per track
NumHeads	DW	0002h		; Number of drive heads

HiddenSecs	DD	00000000		; Number of hidden sectors
BigTotalSecs	DD	00000000		; 32 bit version of number of sectors
BootDrv		DB	00h
CurrentHead	DB	00h		; Current Head
ExtBootSig	DB	29h
SerialNum	DD	5a541826h
VolumeLabel	DB	'NO NAME    '
FatId		DB	'FAT12   '

uData	LABEL	BYTE
Sec9		EQU	BYTE PTR uData+0
BiosLow 	EQU	WORD PTR uData+11
BiosHigh	EQU	WORD PTR uData+13
CurTrk		EQU	WORD PTR uData+15
CurSec		EQU	BYTE PTR uData+17
DirLow		EQU	WORD PTR uData+18
DirHigh		EQU	WORD PTR uData+20

MAIN:
	cli	
	xor	AX, AX
	mov	SS, AX
	mov	SP, 7C00H
	push	SS
	pop	ES

	mov	BX, 1EH * 4
	lds	SI, DWORD PTR SS:[BX]
	push	DS
	push	SI
	push	SS
	push	BX
	mov	DI,OFFSET Sec9
	mov	CX,11
	cld

	repz	movsb
	push	ES
	pop	DS
	assume	DS:CODE

	mov	BYTE PTR [DI-2], 0fh
	mov	CX, [offset SecPerTrack]
	mov	BYTE PTR [DI-7], cl

	mov	[BX+2],AX
	mov	[BX],offset Sec9

	sti
	int	13h
	jc	near ptr CkErr

	xor	AX,AX
	cmp	TotalSectors,AX
	je	Dir_Cont

	mov	CX,TotalSectors
	mov	WORD PTR BigTotalSecs,CX

Dir_Cont:
	mov	AL,NumFats
	mul	NumFatSecs
	add	AX,WORD PTR HiddenSecs
	adc	DX,WORD PTR HiddenSecs[2]
	add	AX,ReservedSecs
	adc	DX,0

	mov	[DirLow],AX
	mov	[DirHigh],DX
	mov	[BiosLow],AX
	mov	[BiosHigh],DX

	mov	AX,0020h
	mul	NumDirEntries
	mov	BX,BytesPerSector
	add	AX,BX
	dec	AX
	div	BX
	add	[BiosLow],AX
	adc	[BiosHigh],0

	mov	BX,0500H

	mov	DX,[DirHigh]
	mov	AX,[DirLow]
	call	DoDiv
	jc	CkErr

	mov	al, 1
	call	DoCall
	jc	CkErr

	mov	ax, word ptr BytesPerSector
	mov	cl, 20h
	div	cl
	xor	ah, ah
TryNext:
	dec	ax
	mov	DI,BX
	mov	SI,OFFSET Bio
	mov	CX,11
	repz	cmpsb
	jz	DoLoad
	add	bx, 20h
	cmp	ax, 0
	jnz	TryNext

CkErr:	mov	SI,OFFSET SysMsg

ErrOut:
	call	Write


	xor	AX,AX
	int	16h
	pop	SI
	pop	DS
	pop	[SI]
	pop	[SI+2]
	int	19h

Load_Failure:
	pop	ax
	pop	ax
	pop	ax
	jmp	short CkErr

DoLoad:
	mov	AX,[BX + 1AH]
	dec	AX
	dec	AX
	mov	BL,SecsPerClust
	xor	BH,BH
	mul	BX

	add	AX,[BiosLow]
	adc	DX,[BiosHigh]

	mov	BX,800H
	mov	CX,3

Do_While:
	push	AX
	push	DX
	push	CX
	call	DoDiv
	jc	Load_Failure
	mov	al, 1

	call	DoCall
	pop	CX
	pop	DX
	pop	AX
	jc	CkErr
	
	add	AX,1
	adc	DX,0
	add	BX,BytesPerSector
	loop	Do_While

DISKOK:
	mov	CH,MediaByte
	mov	DL,BootDrv
	mov	BX,[BiosLow]
	mov	AX,[BiosHigh]
	push	word ptr 80H
	push	word ptr 0000h
	retf

WRITE:
	lodsb
	or	AL,AL
	jz	EndWr
	mov	AH,14
	mov	BX,7
	int	10h
	jmp	Write

DODIV:
	cmp	DX,SecPerTrack
	jae	DivOverFlow
	div	SecPerTrack
	inc	DL

	mov	CurSec, DL
	xor	DX,DX
	div	NumHeads
	mov	CurrentHead,DL
	mov	CurTrk,AX
	clc
	ret

DivOverFlow:
	stc

EndWR:
	ret

DOCALL:
	mov	AH,2
	mov	DX,CurTrk
	mov	CL,6
	shl	DH,CL
	or	DH,CurSec
	mov	CX,DX
	xchg	CH,CL
	mov	DL, BootDrv
	mov	DH, CurrentHead
	int	13h
	ret

SYSMSG	label	byte
Bio	DB	"LOADER  COM"

Free	EQU (512 - 4) - ($-$start)

if Free LT 0
    %out FATAL PROBLEM:boot sector is too large
	.ERR
endif

	org	7C00H + (512 - 2)
	db	55h,0aah			; Boot sector signature

CODE	ENDS
	END 
