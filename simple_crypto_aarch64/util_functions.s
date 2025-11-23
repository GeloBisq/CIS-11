.global clear_keyboard
.global string_length
.global display_message

.align 8
.section .rodata
ASCII_STR:	.asciz	"|%d|"
CHAR_STR:	.asciz 	"%c"
NEWLINE_STR:	.asciz	"\n"

.text
/// function: clear_keyboard
/// input: none
/// output: none
///
.align 8
clear_keyboard:
	stp fp, lr, [sp, -16]!
WHL_W0_NE_10:			// ASCII code for '\n' is 13 decimal
	bl getchar		// read in a char from keyboard, ascii code of char is in R0
	and W0, W0, #255	// mask out all irrelevant bits
	cmp W0, #10		// compare W0 to #10
	bne WHL_W0_NE_10 	// branch if not equal back to start of while loop read next character
	ldp fp, lr, [sp], 16	// otherwise, return from the function, we are all done
	ret

//////////////////////////////////////////////////////////////////////////////////////////////
/// end of clear_keyboard function ///////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////

/// function: string_length
/// input: address of the string in X0
/// return: the length of the string in X0
///
.align 8
string_length:
	stp fp, lr, [sp, -16]!

	mov X1, #0
	ldrb W2, [X0,X1]	// load byte into W2 from *(X0+X1)
WHL_W2_NE_NULL:
	cmp W2, #0		// ASCII code 0 is NULL
	beq END_WHL_W2_NE_NULL
	add X1, X1, #1
	ldrb W2, [X0,X1]
	b WHL_W2_NE_NULL
END_WHL_W2_NE_NULL:
	mov X0, X1
	ldp fp, lr, [sp], 16
	ret
//////////////////////////////////////////////////////////////////////////////////////////////
/// end of string_length function ////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////

/// function: display_message
/// input: address of string in R0
///	   length of string in R1
/// return: nothing, just outputs the string
///
/// special note: if ASCII code of character is less than 32 or greater than 127,
/// the function will just print the ASCII code as anything outside of the range is
/// likely to be unprintable.
///
.align 8
display_message:
	stp fp, lr, [sp, -16]!
	stp X18, X19, [sp, -16]!
	stp X20, X21, [sp, -16]!

	mov X18, X0	// copy X0 into X18
	mov X19, X1	// copy X1 into X19
	mov X20, #0
WHL_X2_LT_X1:
	cmp X20, X19
	bge END_WHL_X2_LT_X1
	ldrb W3, [X18,X20]
IF_X3_LT_32_OR_X3_GT_127:
	cmp W3, #32
	blt OUTPUT_ASCII_CODE
	cmp W3, #127
	blt OUTPUT_CHAR
OUTPUT_ASCII_CODE:			// when X3 < 32 or X3 > 127, output ascii code
	ldr X0, ADR_ASCII_STR
	mov W1, W3
	bl printf
	b END_IF_X3_LT_32_OR_X3_GT_127 // jump to end of our if block
OUTPUT_CHAR:			// this is essentially the "else" part of our IF statement
	ldr X0, ADR_CHAR_STR
	mov W1, W3
	bl printf
bp:
					// no branch and end of else block as execution falls through
END_IF_X3_LT_32_OR_X3_GT_127:
	add X20, X20, #1
	b WHL_X2_LT_X1

END_WHL_X2_LT_X1:
	ldr X0, ADR_NEWLINE_STR
	bl printf

	ldp X20, X21, [sp], 16
	ldp X18, X19, [sp], 16
	ldp fp, lr, [sp], 16

	ret

/// local labels for display_message
.align 8
ADR_ASCII_STR:		.dword	ASCII_STR
ADR_CHAR_STR:		.dword	CHAR_STR
ADR_NEWLINE_STR:	.dword	NEWLINE_STR
//////////////////////////////////////////////////////////////////////////////////////////////
/// end of display_message function //////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////
