Lab9:

Saw:
ORG 0
	Again:MOV A,#0
	Back:MOV P1,A
	INC A
	CJNE A, #0FFH, Back
	SJMP Again
END

Spike:
ORG 0
	Again:MOV A,#0
	Back:MOV P1,A
	INC A
	CJNE A, #0FFH, Back
	Back1:MOV P1,A
	DEC A
	CJNE A, #0H, Back1
	SJMP Again
END

Staircase:

ORG 0
	Again:MOV A,#0
	Back:MOV P1,A
	ACALL Delay
	ADD A,#2FH
	CJNE A, #0FFH, Back
	SJMP Again
	
	
	
	Delay: MOV R0,#01H
	L2: MOV R2,#0FFH
	L1: MOV R1, #0FFH
	Here: DJNZ R1, Here
	DJNZ R2,L1
	DJNZ R0,L2
	RET
	
END


ORG 0
	Again:MOV A,#0
	Back:MOV P1,A
	mov p1,#0ffh
	acall delay 
	mov p1,#00h
	acall delay
	SJMP Again
	
	
	
	Delay: MOV R0,#01H
	L2: MOV R2,#0FFH
	L1: MOV R1, #0FFH
	Here: DJNZ R1, Here
	DJNZ R2,L1
	DJNZ R0,L2
	RET
	
END