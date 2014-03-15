	.globl asma
	.type asma, @function
asma:
	# well, we have to compare characters like this:
	# u[i] = (s[i] > t[i]) ? s[i] : t[i];
	# yet we have to do this with pminub. that sucks.
	# fortunatelly, this is eaqual to:
	# NOT u[i] = (NOT s[i] < NOT t[i]) ? NOT s[i] : NOT t[i];
	# we can live with that, can't we
	
	
	pminub %xmm1, %xmm2		# compare 16x8 bit blocks (the chars), 
							# write 0xFF to xmm1 if the block in xmm1 is
							# smaller than the one in xmm2, else write 0x00
							
	ret