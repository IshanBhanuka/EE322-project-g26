;
; EE322step1.asm
;
; Created: 11/28/2022 1:40:10 PM
; Author : ishan
;


; Replace with your application code
.include "m328pdef.inc"

start:
SBI DDRD, 0  ;Set PD0 as output
CBI DDRB, 0  ;Set PB0 as input

forever:
L1: SBIS PINB, 0 ; 
RJMP L2
SBI PORTD, 0 ; 
SBIC PINB, 0 ; 
RJMP L1
L2: CBI PORTD, 0 ; 
RJMP forever
