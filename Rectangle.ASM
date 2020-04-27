;*****************Milad Eslaminia 810185259****HW4*****

PAGE 100,115

STSEG   SEGMENT STACK 'STACK'
	DW 32 DUP(0)
STSEG   ENDS

;*********************************************************
;		DEFINING DATA SEGEMENT
;*********************************************************
DSEG    SEGMENT


TMP1		DB ? 
TMP2		DB ? 
TMP3		DB ? 
TMP4		DB ? 
TMP5        DW ?
TMP6        DW ?  
TMP7        DW ?
TMP8        DW ?

N0      DB 'Lenght?','$'
N1      DB 'Width?','$'
DSEG    ENDS
;********************************************************
;		CODE SEGEMENT STARTS HERE!
;********************************************************
CSEG    SEGMENT
START   PROC FAR
	ASSUME CS:CSEG, DS:DSEG, SS:STSEG
	MOV AX,DSEG	
	MOV DS,AX	

;***********************************************************
;****prompt to enter lenght
	MOV AH,9H       				
	LEA DX,N0 
	INT 21H
	MOV AX,0000h   
	MOV DX,0001 
	MOV TMP1,0
	MOV TMP2,0
	MOV TMP3,0
	MOV TMP4,0
;************getting length	 
INPUT_LOOP:
	
	MOV AH,01					
	INT 16H
	JZ INPUT_LOOP
	MOV AH,00
	INT 16H	
	CMP AL,13           ;see if it is enter key
	JE NEXT
	CMP DX,0001
	JE STORE1
	JNE STORE2
	
STORE1:
	MOV TMP1,AL                  ;stores left digit
	DEC DX
	JMP INPUT_LOOP
STORE2:                          ;stores right digit Note: if you want to enter a single digit number you must enter it like '05'
	MOV TMP2,AL
	INC DX                     ;Note! if you want to enter a single digit number you must enter it like '05'
	JMP INPUT_LOOP
NEXT:	
;***************prompt to enter width
 MOV DL,0AH           ;new line
 MOV AH,02
 INT 21H

 MOV AH,9H       				
 LEA DX,N1 
 INT 21H	
 MOV DX,0001
 
 ;**********geting width	
	
INPUT_LOOP2:
	
	MOV AH,01					
	INT 16H
	JZ INPUT_LOOP2
	MOV AH,00
	INT 16H	
	CMP AL,13           ;see if it is enter key
	JE NEXT2
	CMP DX,0001
	JE STORE3
	JNE STORE4
	
STORE3:
	MOV TMP3,AL                  ;stores left digit
	DEC DX
	JMP INPUT_LOOP2
STORE4:                          ;stores right digit Note: if you want to enter a single digit number you must enter it like '05'
	MOV TMP4,AL
	INC DX
	JMP INPUT_LOOP2	
	
NEXT2:
;***********converting ascii value to actual numbers	
	
	SUB TMP1,48   
	SUB TMP2,48
	SUB TMP3,48   
	SUB TMP4,48
;************	
	MOV AX,0600H	      ;clear screen
	MOV CX,0000H  	
	MOV BH,41H	
	MOV DH,24      
	MOV DL,79       
	INT 10H 
;*****************multipling right digit to 10 and have value of 2digit number 	
	SUB DX,DX
	MOV DL,TMP2 
	MOV AX,0
    MOV AL,10
    MOV BL,TMP1	
    MUL BL
    ADD AX,DX
    MOV DX,AX
    MOV TMP5,DX
    
    SUB DX,DX
	MOV DL,TMP4 
	MOV AX,0
    MOV AL,10
    MOV BL,TMP3	
    MUL BL
    ADD AX,DX
    MOV DX,AX
    MOV TMP6,DX
;**************calculating start point and make the rectangle to be in the center of screen    
    
    MOV AX,320          ;screen length
    SUB AX,TMP5
    MOV BL,2
    DIV BL
    MOV AH,00 
    MOV TMP7,AX
    
    MOV AX,200         ;screen width
    SUB AX,TMP6
    MOV BL,2
    DIV BL
    MOV AH,00 
    MOV TMP8,AX
    
    MOV AX,TMP7          ;finding start  and end point of each line
    ADD AX,TMP5
    MOV TMP5,AX
    MOV AX,TMP8
    ADD AX,TMP6
    MOV TMP6,AX
    
    
       
    
	      
;	Change to mode 13 for graphics
;	-----------------------------
        MOV AH,0        
        MOV AL,13H      
        INT 10H        

;***************horizontal line1******   
        Mov CX,TMP7	      ;starting point
        MOV DX,TMP8	
BACK1:	MOV AH,0CH	;Activate pixels 
        MOV AL,7H	;white color
        INT 10H			
        INC CX		;move horizontally
        CMP CX,TMP5	;horizontal line end point
        JNE BACK1     	
        
;*******************vertical line1
	MOV CX,TMP5	; starting point
	MOV DX,TMP8	
BACK2:	MOV AH,0CH	
	MOV AL,7H	;white color
	INT 10H		
	INC DX		;move vertically
	CMP DX,TMP6	
	JNE BACK2	;vertical line end point
			

;***************horizontal line2******       
        Mov CX,TMP5	 ;same as two previus parts
        MOV DX,TMP6	
BACK3:	MOV AH,0CH	 
        MOV AL,7H	
        INT 10H			
        DEC CX		
        CMP CX,TMP7	 
        JNE BACK3     	
;******************vertical line2   *****************    
	MOV CX,TMP7	
	MOV DX,TMP6	
BACK4:	MOV AH,0CH
	MOV AL,7H	
	INT 10H		
	DEC DX		
	CMP DX,TMP8
	JNE BACK4	
;****************************** rectangle is complete


	MOV AX,4C00H	
	INT 21H		 
START   ENDP		
END START	
;******************EOP********************

