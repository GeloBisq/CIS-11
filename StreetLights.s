.equ INPUT, 0
.equ OUTPUT, 1
.equ LOW, 0
.equ HIGH, 1
.equ RED_PIN, 21
.equ YLW_PIN, 22
.equ GRN_PIN, 23
.equ GO_PIN, 25
.equ NO_PIN, 24
.equ STOP_PIN, 28
.equ OFF_PIN, 29

.text
.global main
main: //int main()
	stp x29, x30, [sp,-16]!

	//Setup
	bl wiringPiSetup //wiringPiSetup()
	mov x0, #RED_PIN
	mov x1, #OUTPUT
	bl pinMode //pinMode(RED_PIN, INPUT)
	mov x0, #YLW_PIN
	mov x1, #OUTPUT
	bl pinMode
	mov x0, #GRN_PIN
	mov x1, #OUTPUT
	bl pinMode
	mov x0, #GO_PIN
	mov x1, #OUTPUT
	bl pinMode
	mov x0, #NO_PIN
	mov x1, #OUTPUT
	bl pinMode
	mov x0, #STOP_PIN
	mov x1, #INPUT
	bl pinMode
	mov x0, #OFF_PIN
	mov x1, #INPUT
	bl pinMode
	mov x0, #GRN_PIN
	mov x1, #HIGH
	bl digitalWrite
	mov x0, #YLW_PIN
	mov x1, #LOW
	bl digitalWrite
	mov x0, #RED_PIN
	mov x1, #LOW
	bl digitalWrite
	mov x0, #GO_PIN
	mov x1, #LOW
	bl digitalWrite
	mov x0, #NO_PIN
	mov x1, #LOW
	bl digitalWrite

wait:
	mov x3, #OFF_PIN
	bl digitalRead
	cmp x3, #1
	beq end_wait
	mov x3, #STOP_PIN
	bl digitalRead
	cmp x3, #0
	beq stop_lights


stop_lights:
	mov x0, #GRN_PIN
	mov x1, #LOW
	bl digitalWrite
	mov x0, #YLW_PIN
	mov x1, #HIGH
	bl digitalWrite
	mov x0, #1000
	bl delay
	mov x0, #YLW_PIN
	mov x1, #LOW
	bl digitalWrite
	mov x0, #RED_PIN
	mov x1, #HIGH
	bl digitalWrite
	mov x0, #GO_PIN
	mov x1, #HIGH
	bl digitalWrite
	mov x0, #3000
	bl delay
	mov x3, #0
	b go_lights

go_lights:
	cmp x3, #3
	beq wait
	mov x0, #GO_PIN
	mov x1, #HIGH
	bl digitalWrite
	mov x0, #NO_PIN
	mov x1, #HIGH
	bl digitalWrite
	mov x0, #1000
	bl delay
	mov x0, #GO_PIN
	mov x1, #LOW
	bl digitalWrite
	mov x0, #NO_PIN
	mov x1, #LOW
	bl digitalWrite
	mov x0, #1000
	bl delay
	add x3, x3, #1
	b wait

end_wait:
	mov x0, #0 //return 0
	ldp x29, x30, [sp], 16
