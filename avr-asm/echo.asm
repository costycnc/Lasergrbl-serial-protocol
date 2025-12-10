.equ	RXCIE0	= 7	
.equ	RXEN0	= 4	
.equ	UCSR0B	= 0xc1
.equ	UCSR0C	= 0xc2
.equ	TXEN0	= 3
.equ	UDR0	= 0xc6
.equ	bps	= 16000000/(16*9600) - 1
.equ	UBRR0L	= 0xc4	
.equ	UBRR0H	= 0xc5
.equ	UCSZ00	= 1
.equ	UCSZ01	= 2

.org 0x0
	jmp RESET		; Reset Handler
.org 0x24   ;USART, RX Complete Handler
	jmp receive
.org 0x60
RESET:	
        sbi 4,5
	ldi	r16,103			
	ldi	r17,0	
	sts	UBRR0L,r16			
	sts	UBRR0H,r17
        ldi r16 ,(1 << UCSZ00) | (1 << UCSZ01)
        sts UCSR0C,r16
	ldi	r16,(1 << RXCIE0) | (1 << RXEN0)| (1 << TXEN0)
	sts	UCSR0B,r16
	sei
loop:	
        cpi r22,1
        breq loop
; Invia primo byte
WAIT_TX1:
    lds r17, 0xC0      ; UCSR0A
    sbrc r17, 5         ; salta se UDRE0=1
    rjmp WAIT_TX1
    sts UDR0, r16

; Invia secondo byte
ldi r16, 10
WAIT_TX2:
    lds r17, 0xC0      ; UCSR0A
    sbrc r17, 5
    rjmp WAIT_TX2
    sts UDR0, r16
        ldi r22,1
	rjmp loop
receive:
        ldi r22,2
        lds	r16,UDR0	      
        reti 
