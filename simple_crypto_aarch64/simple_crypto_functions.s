// 64 bit version
.global encrypt
.global decrypt

.text
.align 8
/// function: encrypt
/// input: X0 - address of message array
///	   X1 - length of message array
///	   X2 - address of key array
///	   X3 - length of key array
/// return: no return values, just the message encrypted
///
encrypt:
	// step #1a_en - Save X18, X19
	stp x18, x19, [sp, -16]!
	// step #1b_en - Save FP, and LR
	stp fp, lr, [sp, -16]!
	// step #2_en - Set register X18 to 0
	mov x18, #0
	// step #3_en - Set register X19 to 0
	mov x19, #0

EN_WHL_X19_LT_X1:
	// step #4_en - compare X19 and X1 in this order of the registers
	cmp x19, x1
	// step #5_en - if X19 greater than or equal to X1, branch to EN_END_WHL_X19_LT_X1
	bge EN_END_WHL_X19_LT_X1
	// step #6_en - load byte into register W4, the contents of X0[X19]
	ldrb w4, [x0, x19]
	// step #7_en - load byte into register W5, the contents of X2[X18]
	ldr w5, [x2, x18]
	// step #8_en - exclusive or W4 and W5, storing result in W4
	eor w4, w4, w5
	// step #9_en - use bitwise AND with X19 and #255 to cast X19's value as char instead of int, store in W5
	and x5, x19, #0xff
	// step #10_en - add W4 and W5, storing result in W4
	add w4, w4, w5
	// step #11_en - store byte in W4 to X0[X19]
	strb w4, [x0, x19]
	// step #12_en - increment X18 by one
	add x18, x18, #1

EN_IF_X18_GE_X3:
	// step #13_en - compare X18 and X3 in this order of the registers
	cmp x18, x3
	blt NEXT_STEP_EN
	// step #14_en - move into X18 the value #0
	mov x18, #0

NEXT_STEP_EN:
	// step #15_en - increment X19 by one
	add x19, x19, #1
	// step #16_en - branch back to EN_WHL_X19_LT_X1 label
	b EN_WHL_X19_LT_X1

EN_END_WHL_X19_LT_X1:
	// step #17_en - restore the registers X18,X19,FP
	// and LR; in the order of registers given (two instructions)
	ldp fp, lr, [sp], 16
	ldp x18, x19, [sp], 16
	ret

//////////////////////////////////////////////////////////////////////////////////////////////
/// end of encrypt function //////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////

/// function: decrypt
/// input: X0 - address of encrypted message array
///	   X1 - length of encrypted message array
///	   X2 - address of key array
///	   X3 - length of key array
/// return: no return values, just the message decrypted
///
.align 8
decrypt:
	// step #1a_de - Save X18, X19
	stp x18, x19, [sp, -16]!
	// step #1b_de - Save FP, and LR
	stp fp, lr, [sp, -16]!
	// step #2_de - Set register X18 to 0
	mov x18, #0
	// step #3_de - Set register X19 to 0
	mov x19, #0

DE_WHL_X19_LT_X1:
	// step #4_de - compare X19 and X1 in this order of the registers
	cmp x19, x1
	// step #5_de - if X19 greater than or equal to X1, branch to DE_END_WHL_X19_LT_X1
	bge DE_END_WHL_X19_LT_X1
	// step #6_de - load byte into register W4, the contents of X0[X19]
	ldrb w4, [x0, x19]
	// step #7_de - use bitwise AND with X19 and #255 to cast X19's value as char instead of int, store in W5
	and x5, x19, #0xff
	// step #8_de - subtract W4 and W5, storing result in W4
	sub w4, w4, w5
	// step #9_de - load byte into register W5, the contents of X2[X18]
	ldrb w5, [x2, x18]
	// step #10_de - exclusive or W4 and W5, storing result in W4
	eor w4, w4, w5
	// step #11_de - store byte in W4 to X0[X19]
	strb w4, [x0, x19]
	// step #12_de - increment X18 by one
	add x18, x18, #1

DE_IF_X18_GE_X3:
	// step #13_de - compare X18 and X3 in this order of the registers
	cmp x18, x3
	blt NEXT_STEP_DE
	// step #14_de - move into X18 the value #0
	mov x18, #0

NEXT_STEP_DE:
	// step #15_de - increment X19 by one
	add x19, x19, #1
	// step #16_de - branch back to DE_WHL_X19_LT_X1 label
	b DE_WHL_X19_LT_X1

DE_END_WHL_X19_LT_X1:
	// step #17_de - restore the registers FP, LR, X18
	// and X19; in the order of registers given (two instructions)
	ldp fp, lr, [sp], 16
	ldp x18, x19, [sp], 16
	ret


//////////////////////////////////////////////////////////////////////////////////////////////
/// end of decrypt function //////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////
