	.file	"test.c"
	.intel_syntax
	.def	___main;	.scl	2;	.type	32;	.endef
	.text
.globl _main
	.def	_main;	.scl	2;	.type	32;	.endef
_main:
	push	ebp
	mov	ebp, esp
	sub	esp, 24
	and	esp, -16
	mov	eax, 0
	add	eax, 15
	add	eax, 15
	shr	eax, 4
	sal	eax, 4
	mov	DWORD PTR [ebp-4], eax
	mov	eax, DWORD PTR [ebp-4]
	call	__alloca
	call	___main
	mov	ecx, OFFSET FLAT:_temp2
	mov	edx, OFFSET FLAT:_temp
	mov	eax, 132
	mov	DWORD PTR [esp+8], eax
	mov	DWORD PTR [esp+4], edx
	mov	DWORD PTR [esp], ecx
	call	_memcpy
	leave
	ret
	.comm	_temp, 144	 # 132
	.comm	_temp2, 144	 # 132
	.def	_memcpy;	.scl	3;	.type	32;	.endef
