	.globl f
	.type f, @function
f:

----
new generated varname: tmp1
-----
	.data
tmp1:
	.space 8
	.align 8
	.text
	mov %rdi, tmp1
	add $1, tmp1

----
new generated varname: tmp2
-----
	.data
tmp2:
	.space 8
	.align 8
	.text
	mov %rsi, tmp2
	add $1, tmp2

mov tmp1, %r10
	add %r10, tmp2
	mov tmp2, %rax
	ret
