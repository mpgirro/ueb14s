	.globl asma
	.type asma, @function
	
mask: 
	.align
	.size mask, 16
	.fill 16, 1, 0xFF	
	
asma:
	# well, we have to compare characters like this:
	# u[i] = (s[i] > t[i]) ? s[i] : t[i];
	# yet we have to do this with pminub. that sucks.
	# fortunatelly, this is eaqual to:
	# NOT u[i] = (NOT s[i] < NOT t[i]) ? NOT s[i] : NOT t[i];
	# we can live with that, can't we
	movq (%rdi),%xmm8  		# load s into xmm8
	movq (%rsi),%xmm9		# load t into xmm9
	andps mask, %xmm8  		# xmm8 = ~xmm8 & mask, invert bits 
	andps mask, %xmm9  		# xmm9 = ~xmm9 & mask, invert bits
	movq %xmm8,%xmm10		# make a copy of (NOT s)
	pminub %xmm8, %xmm9		# compare 16x8 bit blocks (the chars), write 
					# 0xFF to xmm9 if block in xmm9 is smaller
					# than the one in xmm10, else write 0x00
	andps %xmm8, %xmm10			# mask values in (NOT s)
	andps %xmm8, %xmm9			# mask values in (NOT t)

	por %xmm10, %xmm9			# u = s | t
	movq %xmm9, %rax
	ret
	
