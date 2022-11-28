;
; EE322step2.asm
;
; Created: 11/28/2022 3:34:13 PM
; Author : ishan
;


; Replace with your application code
.include "m328pdef.inc"

start:
SBI DDRD, 0  ;Set PD0 as output
CBI DDRC, 0  ;Set PB0 as input

SBI DDRD, 1  ;Set PD0 as output
CBI DDRC, 1  ;Set PB0 as input

output:
agn: SBIS PINC, 0 ; 
RJMP outputbyte
SBI PORTD, 0 ; 
SBIC PINC, 0 ; 
RJMP agn
outputbyte: CBI PORTD, 0 ; 
RJMP output2

output2:
agn2: SBIS PINC, 1 ; 
RJMP outputbyte1
SBI PORTD, 1 ; 
SBIC PINC, 1 ; 
RJMP agn2
outputbyte1: CBI PORTD, 1 ; 
RJMP output