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
	imul $7, tmp1
	mov tmp1, %rax
	ret
