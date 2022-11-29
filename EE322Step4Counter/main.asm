;
; EE322Step4Counter.asm
;
; Created: 11/29/2022 1:07:10 AM
; Author : ishan
;


; Replace with your application code
.ORG 0x00

start:
	LDI	R20,HIGH(RAMEND);Initialize stack
	OUT	SPH,R20
	LDI	R20,LOW(RAMEND)
	OUT	SPL,R20			;Initialize stack

	LDI R16,0           ;setting r16 value to zero
	LDI R19,0x00        ;setting r19 value to 0000 0000
	OUT DDRB,R19        
	OUT DDRC,R19
	LDI R19,0xFF        ;setting r19 value to 1111 1111
	OUT DDRD,R19

;subroutine for adding function
loop1: IN R18,PINB       ;defining PinB as input and save the value in r18
	CPI R18,1            ;compare r18 value is equal to 1 
	BRNE INC1            
	INC R16              ;Increment r16 value by 1
inc1: OUT PORTD,R16      ;Set the r16 value to port D

loop2: IN R18,PINB
	CPI R18,0            ;compare r18 value is equal to 0
	BRNE LOOP2           
	IN R18,PINC
	CPI R18,1            ;compare r18 value is equal to 1  
	BRNE DEC1 
	DEC R16              ;Decrement r16 value by 1
dec1: OUT PORTD,R16      ;Set the r16 value to port D

loop3: IN R18,PINC
	CPI R18,0            
	BRNE loop3
	JMP loop1           ; jump back to loop1
