; mams code

ORG 0000H                             ; ORIGIN to load program in 0H
SJMP START                            ;short jump to label start


           ORG 0030H             
           START:MOV P0,#0FFH          ; make P2 an input port
           ACALL LCD_INITIALIZE          ; call LCD_INITIALIZE  
           K1:MOV P1,#0                       ; ground all rows at once
           MOV A,P0                           ; read all keys(ensure open)
           ANL A,#00001111B               ; mask unused bits
           CJNE A,#00001111B,K1        ; till all keys release
         


         K2:ACALL DELAY                     ; call 20 msec delay
           MOV A,P0                                ; see if any key is pressed
           ANL A,#00001111B                 ; mask unused bits
           CJNE A,#00001111B,OVER    ; key pressed,find row
           SJMP K2                                     ; check till key pressed
          

         OVER:ACALL DELAY                 ; wait 20 msecdebounce time
           MOV A,P0                                  ; check key closure
           ANL A,#00001111B                  ; mask unused bits
           CJNE A,#00001111B,OVER1     ; key pressed,find row
           SJMP K2                                         ; of none, keep polling
           

        OVER1:MOV P1,#11111110B     ; ground row 0
           MOV A,P0                                      ; read all columns
           ANL A,#00001111B                      ; mask unused bits
           CJNE A,#00001111B,ROW_0      ; key row 0, find column
           MOV P1,#11111101B                   ; ground row 1
        MOV A,P0                                      ; read all columns
        ANL A,#00001111B                      ; mask unused bits
        CJNE A,#00001111B,ROW_1      ; key row 1, find column
           MOV P1,#11111011B                    ; ground row 2
           MOV A,P0                                        ; read all columns
           ANL A,#00001111B                        ; mask unused bits
           CJNE A,#00001111B,ROW_2        ; key row 2, find column
           MOV P1,#11110111B                    ; ground row 3
           MOV A,P0                                          ; read all columns
           ANL A,#00001111B                          ; mask unused bits
           CJNE A,#00001111B,ROW_3          ; key row 3, find column
           LJMP K2                                          ; if none ,false input ,repeat
           


          ROW_0:MOV DPTR,#KCODE0         ; set DPTR=start of row 0
           SJMP FIND                                    ; find column key belongs to
           ROW_1:MOV DPTR,#KCODE1        ; set DPTR=start of row 1
           SJMP FIND                                    ; find column key belongs to
           ROW_2:MOV DPTR,#KCODE2         ; set DPTR=start of row 2
           SJMP FIND                                    ; find column key belongs to
           ROW_3:MOV DPTR,#KCODE3         ; set DPTR=start of row 3
          

         FIND:RRC A                                         ; see if any CY bit is low
           JNC MATCH                                         ; if zero get ASCII code
           INC DPTR                                             ; point to next column
           SJMP FIND                                           ; keep searching
          

        MATCH:CLR A                                     ; set A=0 (match is found)
           MOVC A,@A+DPTR                           ; get ASCII from table
           ACALL LCD_DATA                       ; call LCD_DATA subroutine
           LJMP K1                                               ; long jump to K1(loop)



           LCD_INITIALIZE:                        ; LCD_INITIALIZE subroutine
           MOV A,#38H                                      ; initialize 16x2 LCD
ACALL LCD_COMMAND                  ; call LCD_COMMAND subroutine
MOV A,#0EH                                     ; display on, cursor on
ACALL LCD_COMMAND                 ; call LCD_COMMAND subroutine
           MOV A,#01H                                     ; clear LCD
           ACALL LCD_COMMAND                  ; call LCD_COMMAND subroutine
           MOV A,#06H                                     ; shift cursor right
           ACALL LCD_COMMAND                  ; call LCD_COMMAND subroutine
           MOV A,#80H                                    ; force cursor to the beginning of first line
           ACALL LCD_COMMAND                ; call LCD_COMMAND subroutine
           RET                                                   ; return from LCD_INITIALIZE subroutine
           LCD_COMMAND:                          ; LCD_COMMAND subroutine
           MOV P2,A                                        ; copy reg A to port 2
           CLR P3.7                                           ; RS=0 for command
           CLR P3.6                                           ; R/W=0 for write
           SETB P3.5                                         ; E=1 for high pulse
           ACALL DELAY                                   ; give LCD sometime
           CLR P3.5                                           ; E=0 for H-to-L pulse
           RET                                                  ; return from LCD_COMMAND subroutine
           LCD_DATA:                                    ; LCD_DATA subroutine
           MOV P2,A                                      ; copy reg A to port 2
           SETB P3.7                                       ; RS=0 for command
           CLR P3.6                                         ; R/W=0 for write
           SETB P3.5                                       ; E=1 for high pulse
           ACALL DELAY                                ; give LCD sometime
           CLR P3.5                                        ; E=0 for H-to-L pulse
           RET                                               ; return from LCD_DATA subroutine
            DELAY:MOV R4,#40                   ; R4=40
            HERE:MOV R5,#230                  ; R5=230
           HERE1:DJNZ R5,HERE1             ; stay until R5 becomes 0
DJNZ R4,HERE                           ; stay until R4 becomes 0
RET                                              ; return from DELAY subroutine
ORG 300H                                          ; ASCII look-up table for each row
                       KCODE3:DB 'C','D','E','F'     ; row 3
                       KCODE2:DB '8','9','A','B'    ; row 2
            KCODE1:DB '4','5','6','7'                                 ; row 1
            KCODE0:DB '0','1','2','3'                                 ; row 0
END                                                          ; end of program
 
