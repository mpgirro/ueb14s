	.globl asma
	.type asma, @function

# make 128 bits worth of 1s - we need that as a mask
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
	movdqu (%rdi),%xmm8	# load s into xmm8
	movdqu (%rsi),%xmm9	# load t into xmm9
	movdqu mask, %xmm10	# load mask to xmm10
	andnpd %xmm10, %xmm8	# xmm8 = -xmm8 & mask => s = -s	
	andnpd %xmm10, %xmm9	# xmm9 = -xmm9 & mask => t = -t
	pminub %xmm8, %xmm9	# compare 8 bit blocks, write the lesser 
				# block into %xmm9. for we inverted the blocks
				# before, now it always holds the bigger block
	andnpd %xmm10, %xmm9	# we have to re-invert 
	movdqu %xmm9, (%rdx)	# write it to result field
	ret
	
