;------------------------------------------
; Arduino Nano / ATmega328P
; Serial echo minimale in ASM
; Tutti i registri USART >0x3F usano lds/sts
;------------------------------------------

.equ UBRR0H = 0xC5
.equ UBRR0L = 0xC4
.equ UCSR0A = 0xC0
.equ UCSR0B = 0xC1
.equ UCSR0C = 0xC2
.equ UDR0   = 0xC6

.equ RXEN0  = 4
.equ TXEN0  = 3
.equ UDRE0  = 5
.equ RXC0   = 7
.equ UCSZ01 = 2
.equ UCSZ00 = 1

.cseg
.org 0x0000
rjmp RESET

RESET:
    ; USART init 115200 baud, F_CPU=16MHz → UBRR = 8
    ldi r16, 0
    sts UBRR0H, r16
    ldi r16, 8
    sts UBRR0L, r16

    ; TX e RX enable
    ldi r16, (1<<RXEN0)|(1<<TXEN0)
    sts UCSR0B, r16

    ; 8N1
    ldi r16, (1<<UCSZ01)|(1<<UCSZ00)
    sts UCSR0C, r16

MAIN_LOOP:
    ; Attende byte
WAIT_RX:
    lds r16, UCSR0A
    sbrc r16, RXC0    ; se RXC0=1 salta
    rjmp GOT_RX
    rjmp WAIT_RX

GOT_RX:
    lds r16, UDR0     ; legge il byte ricevuto

WAIT_TX:
    lds r17, UCSR0A
    sbrc r17, UDRE0   ; se UDRE0=1 salta
    rjmp WAIT_TX
    sts UDR0, r16     ; invia byte indietro
    rjmp MAIN_LOOP
