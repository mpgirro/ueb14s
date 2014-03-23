	.globl asmb
	.type asmb, @function
	
# make 128 bits worth of 0s
zero16: 
	.align
	.size mask, 16
	.fill 16, 1, 0x00
	
zero8:
	.align
	.size mask8, 8
	.fill 8, 1, 0x00
	
asmb:
	# well, now we have to do this:
	#
	# for (i=0; s[i] && t[i]; i++)
	# {
 	#     u[i] = (s[i]<t[i]) ? s[i] : t[i];
 	# } 
	# u[i] = ’\0’;	 
	#
	# that could become a though one.
	movdqu (%rdi),%xmm8	# load s into xmm8
	movdqu (%rsi),%xmm9	# load t into xmm9
	movdqu zero16, %xmm10	# load mask to xmm10
	mov $0, %r8		# we need this
loop:

	movdqu (%rdi,%r8), %xmm11
	movdqu (%rsi,%r8), %xmm12
#	add $16, %r8			# r8 = r8 + 16

	pminub %xmm11, %xmm12
	movdqu %xmm12, (%rdx,%r8)	# mov result to rdx
	add $16, %r8
	pcmpeqb %xmm10, %xmm12  # packed compare bytes
				# if there is a \0, we will have 
				# a byte worth of 0xFF

	pmovmskb %xmm12, %r9	# copies msb of every byte
				# if there is 0xFF in xmm12, we
				# will have a 1 in r8				

	cmpq %r9, zero8 # check if there was something found
	je loop			# continue if no \0 was found
	ret 			# we're done here
	
