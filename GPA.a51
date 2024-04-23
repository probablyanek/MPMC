GPA

ORG 0000H

MOV DPTR, #3000H;Point DPTR to the start of the Grade Equivalents Values
MOV R0, #50H;Initialize R0 with the starting value for Grade Equivalents
MOV R1, #40H;Initialize R1 with the starting value for Credits
MOV R5, #04H;Initialize R5 with the number of Grade Equivalents to be calculated
MOV R6, #00H;Initialize R6 with the starting value for the numerator
MOV R7, #00H;Initialize R7 with the starting value for the denominator
LOOP:
	MOV A, @R1 
	ADD A, R6
	MOV R6, A
	MOV A, @R1
	MOV B, @R0
	MUL AB
	MOVX @DPTR, A     ; Move the LSB of the product to the address pointed by DPTR
	ADD A, R7
	MOV R7, A
	INC R0           ; Increment R0
	INC R1			 ; Increment R1
	INC DPTR         ; Increment DPTR
	DJNZ R5, LOOP    ; Repeat the loop until R0 becomes zero
MOV A, R7
MOV B, R6
DIV AB;Divide the numerator by the denominator to get CGPA
END
	