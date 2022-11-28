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
CBI DDRC, 0  ;Set PB0 as input

output:
agn: SBIS PINC, 0 ; 
RJMP outputbyte
SBI PORTD, 0 ; 
SBIC PINC, 0 ; 
RJMP agn
outputbyte: CBI PORTD, 0 ; 
RJMP output
