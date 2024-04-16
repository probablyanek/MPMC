2*4
ORG 0000H                            
SJMP START                          


           ORG 0030H             
           START:MOV P0,#0FFH          
           ACALL LCD_INITIALIZE          
           K1:MOV P1,#0                      
           MOV A,P0                           
           ANL A,#00001111B              
           CJNE A,#00001111B,K1        
         


         K2:ACALL DELAY                    
           MOV A,P0                               
           ANL A,#00001111B                
           CJNE A,#00001111B,OVER    
           SJMP K2                                    
          

         OVER:ACALL DELAY                
           MOV A,P0                                 
           ANL A,#00001111B                 
           CJNE A,#00001111B,OVER1    
           SJMP K2                                         
           

        OVER1:MOV P1,#11111011B    
           MOV A,P0                                     
           ANL A,#00001111B                      
           CJNE A,#00001111B,ROW_0      
           MOV P1,#11110111B                  
        MOV A,P0                                    
        ANL A,#00001111B                     
        CJNE A,#00001111B,ROW_1         
           LJMP K2                                       
           


          ROW_0:MOV DPTR,#KCODE0         
           SJMP FIND                                    
           ROW_1:MOV DPTR,#KCODE1       
           SJMP FIND                                   
           ROW_2:MOV DPTR,#KCODE2       
           SJMP FIND                                   
           ROW_3:MOV DPTR,#KCODE3         
          

         FIND:RRC A                                         
           JNC MATCH                                       
           INC DPTR                                          
           SJMP FIND                                           
          

        MATCH:CLR A                                   
           MOVC A,@A+DPTR                         
           ACALL LCD_DATA                    
           LJMP K1                                              



           LCD_INITIALIZE:                       
           MOV A,#38H                                    
ACALL LCD_COMMAND                  
MOV A,#0EH                                    
ACALL LCD_COMMAND                 
           MOV A,#01H                                     
           ACALL LCD_COMMAND                 
           MOV A,#06H                                   
           ACALL LCD_COMMAND                
           MOV A,#80H                                   
           ACALL LCD_COMMAND                
           RET                                                   
           LCD_COMMAND:                       
           MOV P2,A                                       
           CLR P3.7                                          
           CLR P3.6                                         
           SETB P3.5                                       
           ACALL DELAY                                  
           CLR P3.5                                         
           RET                                                 
           LCD_DATA:                                 
           MOV P2,A                                  
           SETB P3.7                                     
           CLR P3.6                                  
           SETB P3.5                                     
           ACALL DELAY                            
           CLR P3.5                                       
           RET                                              
            DELAY:MOV R4,#40                  
            HERE:MOV R5,#230                
           HERE1:DJNZ R5,HERE1             
DJNZ R4,HERE                           
RET                                             
ORG 300H                                          
                       KCODE3:DB 'C','D','E','F'     
                       KCODE2:DB '8','9','A','B'    
            KCODE1:DB '4','5','6','7'                                
            KCODE0:DB '0','1','2','3'                                 
END