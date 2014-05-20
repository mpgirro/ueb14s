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
	mov %rsi, tmp1
	add $2, tmp1
	imul %rdi, tmp1
	mov tmp1, %rax
	ret
