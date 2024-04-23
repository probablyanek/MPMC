DISPLAY+KEYPAD


ORG 0000H
SJMP 0030H
ORG 0030H
LCD_DATA        EQU     P2      ; LCD Data lines
LCD_RS          EQU     P0.6    ; Register Select
LCD_RW          EQU     P0.5    ; Read/Write
LCD_EN          EQU     P0.4    ; Enable

MOV P0,#0FFH
MOV P1,#00H
K1:MOV A,P0
ANL A,#00001111B
CJNE A,#00001111B,K1
K2:ACALL DELAY
MOV A,P0
ANL A,#00001111B
CJNE A,#00001111B,OVER
SJMP K2
OVER:MOV A,P0
ANL A,#00001111B
CJNE A,#00001111B,OVER
SJMP K2

OVER1:MOV P1,#11111110
MOV A,P0
ANL A,#00001111B
CJNE A,#00001111B,ROW0

MOV P1,#11111101B
MOV A,P0
ANL A,#00001111B
CJNE A,#00001111B,ROW1

MOV P1,#11111011B
MOV A,P0
ANL A,#00001111B
CJNE A,#00001111B,ROW2

MOV P1,#11110111B
MOV A,P0
ANL A,#00001111B
CJNE A,#00001111B,ROW3

ROW0:MOV DPTR,#KCODE0
SJMP FIND

ROW1:MOV DPTR,#KCODE1
SJMP FIND

ROW2:MOV DPTR,#KCODE2
SJMP FIND

ROW3:MOV DPTR,#KCODE3
SJMP FIND

FIND:RRC A
JNC MATCH
INC DPTR
SJMP FIND

MATCH:CLR A
MOVC A,@ A+DPTR
ACALL LCDdisplay
LJMP K2

KCODE0:DB '0','1','2','3'
KCODE1:DB '4','5','6','7'
KCODE2:DB '8','9','A','B'
KCODE3:DB 'C','D','E','F'

LCDdisplay:
    PUSH    ACC             ; Save accumulator value
    MOV     A, #1           ; Function set instruction
    ACALL   SendLCDCommand  ; Call SendLCDCommand routine
    MOV     A, #0Ch         ; Display on, cursor off
    ACALL   SendLCDCommand  ; Call SendLCDCommand routine
    MOV     A, #38h         ; 2-line, 5x8 matrix
    ACALL   SendLCDCommand  ; Call SendLCDCommand routine
    MOV     A, #01h         ; Clear display
    ACALL   SendLCDCommand  ; Call SendLCDCommand routine
    MOV     A, #80h         ; Set cursor to first line
    ACALL   SendLCDCommand  ; Call SendLCDCommand routine
    POP     ACC             ; Retrieve accumulator value
    ACALL   SendLCDData     ; Call SendLCDData routine
    RET                     ; Return from LCDdisplay

SendLCDCommand:
    CLR     LCD_RS          ; RS = 0 for command
    CLR     LCD_RW          ; RW = 0 for write
    MOV     LCD_DATA, A     ; Move command to LCD data lines
    SETB    LCD_EN          ; Toggle Enable
    NOP                     ; Wait for LCD to process command
    CLR     LCD_EN          ; Clear Enable
    RET                     ; Return from SendLCDCommand


SendLCDData:
    SETB    LCD_RS          ; RS = 1 for data
    CLR     LCD_RW          ; RW = 0 for write
    MOV     LCD_DATA, A     ; Move data to LCD data lines
    SETB    LCD_EN          ; Toggle Enable
    NOP                     ; Wait for LCD to process data
    CLR     LCD_EN          ; Clear Enable
    RET                     ; Return from SendLCDData

DELAY:
	MOV R7,#0FFH
	Here22:MOV R6,#0FFH
	Here222:DJNZ R6,Here222
	DJNZ R7,Here22
	RET
RET
END