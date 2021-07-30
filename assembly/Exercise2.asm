Loop0:
lui s1,0xFFFFF
lh s4,0x72(s1)		#read op
#sh s4,0x62(s1)
andi s4,s4,0x00000020	#and to clear useless bit
beq s4,zero,continue
	#clear
	sw  zero,0x60(s1)
	sw  zero,0x00000000
	jal Loop0
continue:
lw s0,0x70(s1)          # read number
andi s0,s0,0x0000000F	#and to clear useless bit
lh s4,0x72(s1)		#read op
andi s4,s4,0x000000C0	#and to clear useless bit
addi t0,zero,0x00000040	#move 40H to reg t0
beq s4,t0,op2		#op2
addi t0,zero,0x00000080	#move 40H to reg t0
beq s4,t0,op2		#op3 need to do op2 first
jal Loop0			#no operation
op2:		#x^2	result is in s2
	addi t1,zero,0x4	#t1 = count
	add t2,s0,zero		#t2 = s0 for temp use
	add s5,s0,zero		#s5 = s0 for shift use
	add s2,zero,zero 	#set s2=0
	Loop2:
		andi s1,t2,0x1		#s1 = last bit of s0=t2
		beq s1,zero,no_add2
		yes_add2:		#add s5
			add s2,s2,s5
		no_add2:			#add 0 
			srli t2,t2,0x1
			slli s5,s5,0x1
		addi t1,t1,0xFFFFFFFF	#add 0xffffffff equal sub 1
		bne zero,t1,Loop2
	addi t0,zero,0x00000080	#move 40H to reg t0
	bne s4,t0,op23	#if not op3,go op23 direct ,or else do op3
op3:		#x^3 result in s3
	addi t1,zero,0x4	#t1 = count
	add t2,s0,zero		#t2 = s0 for temp use
	add s5,s2,zero		#s5 = s2 for shift use
	add s3,zero,zero		#set s3 = 0
	Loop3:
		andi s1,t2,0x1		#s1 = last bit of s0=t2
		beq s1,zero,no_add3
		yes_add3:		#add s0
			add s3,s3,s5
		no_add3:			#add 0 
			srli t2,t2,0x1
			slli s5,s5,0x1
		addi t1,t1,0xFFFFFFFF	#add 0xffffffff equal sub 1
		bne zero,t1,Loop3
op23:		#op after op2/op3
	lui s1,0xFFFFF
	beq s4,t0,op23_3	#if  op3,go op23_3 direct
	sw  s2,0x60(s1)
	sw  s2,0x00000000
	jal Loop0
	op23_3:
		sw s3,0x60(s1)
		sw s3,0x00000000
	jal Loop0
