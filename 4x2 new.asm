4x2 new
ORG 0000H                             
SJMP START                           


           ORG 0030H             
           START:MOV P0,#0FFH          
           ACALL LCD_INITIALIZE          
           K1:MOV P1,#0                      
           MOV A,P0                          
           ANL A,#00000011B               
           CJNE A,#00000011B,K1        
         


         K2:ACALL DELAY                     
           MOV A,P0                               
           ANL A,#00000011B                 
           CJNE A,#00000011B,OVER   
           SJMP K2                                    
          

         OVER:ACALL DELAY                
           MOV A,P0                                  
           ANL A,#00000011B                  
           CJNE A,#00000011B,OVER1     
           SJMP K2                                         
           

        OVER1:MOV P1,#11111110B     
           MOV A,P0                                      
           ANL A,#00000011B                      
           CJNE A,#00000011B,ROW_0     
           MOV P1,#11111101B                   
        MOV A,P0                                      
        ANL A,#00000011B                    
        CJNE A,#00000011B,ROW_1      
           MOV P1,#11111011B                    
           MOV A,P0                                        
           ANL A,#00000011B                        
           CJNE A,#00000011B,ROW_2        
           MOV P1,#11110111B                    
           MOV A,P0                                          
           ANL A,#00000011B                          
           CJNE A,#00000011B,ROW_3          
           LJMP K2                                          ; i
           


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
           ACALL LCD_COMMAND                  
           MOV A,#06H                                     
           ACALL LCD_COMMAND                 
           MOV A,#80H                                    
           ACALL LCD_COMMAND                ;
           RET                                                   
           LCD_COMMAND:                          
           MOV P2,A                                        
           CLR P3.7                                           
           CLR P3.6                                           
           SETB P3.5                                         
           ACALL DELAY                                   
           CLR P3.5                                           ; 
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
           HEREA:DJNZ R5,HEREA             ; stay until R5 becomes 0
DJNZ R4,HERE                           ; stay until R4 becomes 0
RET                                              ; return from DELAY subroutine
ORG 300H                                          ; ASCII look-up table for each row
                       KCODE3:DB '7','6'     ; row 3
                       KCODE2:DB '5','4'    ; row 2
            KCODE1:DB '3','2'                                 ; row 1
            KCODE0:DB '0','1'                                 ; row 0
END                                                          ; end of program
 