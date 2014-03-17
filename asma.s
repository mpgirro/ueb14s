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
	movdqu (%rdi),%xmm8  		# load s into xmm8
	movdqu (%rsi),%xmm9		# load t into xmm9
	#movdqu $0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF, %xmm11  		# xmm8 = ~xmm8 & mask, invert bits 
	movdqu mask, %xmm12		# load mask to xmm12
	andnpd %xmm12, %xmm8 		# xmm8 = -xmm8 & mask => s = -s	
	andnpd %xmm12, %xmm9		# xmm9 = -xmm9 & mask => t = -t
	pminub %xmm8, %xmm9		# compare 8 bit blocks, write the lesser 
					# block into %xmm9 
	andnpd %xmm12, %xmm9
	movdqu %xmm9, (%rdx)	
	ret
	
