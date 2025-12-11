;------------------------------------------
; Arduino Nano / ATmega328P
; invia stringa ciclicamente
;------------------------------------------

.equ UBRR0H = 0xC5
.equ UBRR0L = 0xC4
.equ UCSR0A = 0xC0
.equ UCSR0B = 0xC1
.equ UCSR0C = 0xC2
.equ UDR0   = 0xC6

.equ TXEN0  = 3
.equ UDRE0  = 5
.equ UCSZ01 = 2
.equ UCSZ00 = 1

.cseg
.org 0x0000
rjmp RESET
.org 0x60
RESET:
    ; USART 115200 baud
    ldi r16,0
    sts UBRR0H,r16
    ldi r16,8
    sts UBRR0L,r16

    ; TX only
    ldi r16,(1<<TXEN0)
    sts UCSR0B,r16

    ; 8-bit
    ldi r16,(1<<UCSZ01)|(1<<UCSZ00)
    sts UCSR0C,r16

MAIN_LOOP:
    ldi r30, low(MSG*2)
    ldi r31, high(MSG*2)

SEND_LOOP:
    lpm r16, Z+ 
    cpi r16,0
    breq   MAIN_LOOP    
    sts UDR0, r16
    rcall WAIT_INTERVAL
    rjmp SEND_LOOP

;------------------------------------------
WAIT_INTERVAL:
    dec r19
    brne WAIT_INTERVAL
    dec r20
    brne WAIT_INTERVAL
    ret

MSG:
    .db "<Idle|MPos:0.000,0.000,0.000|FS:0,0>", 10, 0
