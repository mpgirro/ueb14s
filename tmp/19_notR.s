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
	add $1, tmp1
	not (null)
	mov tmp1, %rax
	ret
