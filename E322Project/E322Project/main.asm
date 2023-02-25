;
; EE322Project.asm
;
; Created: 2/20/2023 1:38:15 AM
; Author : ishan
; GROUP 26
; Members : 
;			E/18/317
;           E/18/322
;           E/18/324

LCD_Write:
	ldi r16, 0xF0        
	out DDRD, r16        ; set port D o/p
	ldi r16, 0xFF
	out DDRB, r16        ; set port B o/p
	cbi PORTB, 0         ; EN = 0
	rcall delay_ms       ; wait for LCD power on
	
	rcall LCD_init       ; subroutine to initialize LCD

Main:
	rcall disp_name      ; subroutine to display name
	;ldi r16, 0x01        ; clear LCD
	rcall command_wrt    ; send command code
	rcall delay_ms
	
	rcall command_wrt    ; send command code
	rcall delay_ms

	rcall count

	ldi r17, 4           ; wait 1 second

	loop1:
		rcall delay_seconds
		dec r17
		brne loop1
	rjmp Main          ; jump to main for another run

LCD_init:
	ldi r16, 0x33        ; init LCD for 4-bit data
	rcall command_wrt	 ; send to command register
	rcall delay_ms
	ldi r16, 0x32        ; init LCD for 4-bit data 
	rcall command_wrt	 ; send to command register
	rcall delay_ms
	ldi r16, 0x28        ; LCD 2 lines - 5x7 matrix
	rcall command_wrt	 ; send to command register
	rcall delay_ms
	ldi r16, 0x0C        ; display On , cursor off
	rcall command_wrt
	ldi r16, 0x01
	rcall command_wrt
	rcall delay_ms
	ldi r16, 0x06        ; shift cursor right
	rcall command_wrt	 ; send to command register
	ret

command_wrt:
	mov r27, r16
	andi r27, 0xF0       ; mask low nibble & keep high nibble
	out PORTD, r27       ; o/p command high nibble to port D
	cbi PORTB, 1         ; RS = 0 for command
	sbi PORTB, 0         ; EN = 1
	rcall delay_short    ; widen EN pulse
	cbi PORTB, 0         ; EN = 0 for H to L pulse 
	rcall delay_us       ; delay in micro seconds

	mov r27, r16
	swap r27             ; swap nibbles
	andi r27, 0xF0       ; mask low nibble and keep high nibble
	out PORTD, r27       ; o/p command high nibble to port D
	sbi PORTB, 0         ; EN =1
	rcall delay_short    ; widen EN pulse
	cbi PORTB, 0         ; EN = 0 for H to L pulse 
	rcall delay_us       ; delay in micro seconds
	ret

data_wrt:
	mov r27, r16
	andi r27, 0xF0       ; mask low nibble & keep high nibble
	out PORTD, r27       ; o/p command high nibble to port D
	sbi PORTB, 1         ; RS = 1 for data
	sbi PORTB, 0         ; EN = 1
	rcall delay_short    ; widen EN pulse
	cbi PORTB, 0         ; EN = 0 for H to L pulse 
	rcall delay_us       ; delay in micro seconds	
	
	mov r27, r16
	swap r27             ; swap nibbles
	andi r27, 0xF0       ; mask low nibble and keep high nibble
	out PORTD, r27       ; o/p command high nibble to port D
	sbi PORTB, 0         ; EN =1
	rcall delay_short    ; widen EN pulse
	cbi PORTB, 0         ; EN = 0 for H to L pulse 
	rcall delay_us       ; delay in micro seconds
	ret

disp_name :
	ldi r16, 'V'         ; display characters
	rcall data_wrt       ; via data register

	ldi r16, 'I'
	rcall data_wrt
	
	ldi r16, 'S'
	rcall data_wrt
	
	ldi r16, 'I'
	rcall data_wrt
	
	ldi r16, 'T'
	rcall data_wrt
	
	ldi r16, 'O'
	rcall data_wrt
	
	ldi r16, 'R'
	rcall data_wrt
	
	ldi r16, ' '
	rcall data_wrt
	
	ldi r16, 'C'
	rcall data_wrt
	
	ldi r16, 'O'
	rcall data_wrt
	
	ldi r16, 'U'
	rcall data_wrt
	
	ldi r16, 'N'
	rcall data_wrt
	
	ldi r16, 'T'
	rcall data_wrt
	
	ldi r16, ':'
	rcall data_wrt
	
	ldi r16, ' '
	rcall data_wrt
	
	ldi r16, ' '
	rcall data_wrt
	rcall delay_seconds

	rjmp secondline

	;ret

secondline:
	ldi r16, 0xC0        ;force cursor beginning of 2nd line
    rcall command_wrt
    rcall delay_ms
		
	ldi r16, '0'           ;print the count
	rcall data_wrt
	rcall delay_seconds
	
		
	ret

count:
	
	clr r18                                 ; clear the register for count variable

	in r17, PIND
	andi r17,0x0F							; check wheather the input 1 is one
	cpi r17, 0x01
	breq in1

	andi r17,0x0F
	cpi r17, 0x02							; check wheather the input 2 is one
	breq out1
	

in1:
	andi r17,0x0F
	cpi r17, 0x02                            ; check wheather the input 2 is one
	breq inc1

inc1:
	inc r19                                 ; increment count by one
	cpi r19,0								; r19 = count, check wheather the count is zero
	breq turn_off_light                     ; if zero go to turn off light function

out1: 
	andi r17,0x0F
	cpi r17, 0x01						; check wheather the input 1 is one
	breq dec1

dec1:
	dec r19                     ; decrement count by one
	cpi r19,0					; r19 = count
	breq turn_off_light

turn_off_light:
    cbi PORTB, PB5 ; turn off light
    rcall secondline ; display count on LCD
    rjmp count ; infinite loop

delay_short:
	nop
	nop
	ret

delay_us:
	ldi r20, 90
	loop2:
		rcall delay_short
		dec r20
		brne loop2
	ret

delay_ms:
	ldi r21, 40
	loop3:
		rcall delay_us
		dec r21
		brne loop3
	ret

delay_seconds:                 ; nested loop subroutine (max delay 3.11s)
	ldi r20, 255               ; outer loop counter
	loop4:
		ldi r21, 255               ; mid loop counter
	loop5:
		ldi r22, 20                ; inner loop counter to give 0.25s delay
	loop6:
		dec r22                    ; decrement inner loop
		brne loop6                 ; loop if not zero
		dec r21                    ; decrement mid loop
		brne loop5                 ; loop if not zero
		dec r20                    ; decrement outer loop
		brne loop4                 ; loop if not zero
	ret                        ; return to caller
