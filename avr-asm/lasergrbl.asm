;------------------------------------------
; Arduino Nano / ATmega328P
; Serial minimal GRBL-like in ASM
; 115200 baud, F_CPU=16MHz
; Nessun include, registri in chiaro
; Tutti i registri USART >0x3F usano sts/lds
;------------------------------------------

; USART registri (indirizzi assoluti)
.equ UBRR0H = 0xC5
.equ UBRR0L = 0xC4
.equ UCSR0A = 0xC0
.equ UCSR0B = 0xC1
.equ UCSR0C = 0xC2
.equ UDR0   = 0xC6

; Bit
.equ RXEN0  = 4
.equ TXEN0  = 3
.equ UDRE0  = 5
.equ UCSZ01 = 2
.equ UCSZ00 = 1
.equ RXC0   = 7

;------------------------------------------

.org 0x0000
rjmp RESET

;------------------------------------------
; RESET
;------------------------------------------
.org 0x60
RESET:
    ; USART init 115200 baud, F_CPU=16MHz → UBRR=8
    ldi r16, 0
    sts UBRR0H, r16
    ldi r16, 8
    sts UBRR0L, r16

    ; TX e RX enable
    ldi r16, (1<<RXEN0)|(1<<TXEN0)
    sts UCSR0B, r16

    ; 8 bit, no parity, 1 stop bit
    ldi r16, (1<<UCSZ01)|(1<<UCSZ00)
    sts UCSR0C, r16

MAIN_LOOP:
    ; Attende byte
WAIT_RX:
    lds r16, UCSR0A
    sbrc r16, RXC0   ; salta se RXC0=1
    rjmp GOT_RX
    rjmp WAIT_RX

GOT_RX:
    lds r16, UDR0     ; Legge il byte ricevuto

    ; Se '?', invia status
    cpi r16, '?'
    breq SEND_STATUS

    ; Se '\n', invia ok
    cpi r16, 0x0A
    breq SEND_OK

    ; altrimenti torna al loop
    rjmp MAIN_LOOP

;------------------------------------------
; INVIO STATUS
;------------------------------------------
SEND_STATUS:
    ; Puntatore Z su MSG_STATUS
    ldi r30, low(MSG_STATUS)
    ldi r31, high(MSG_STATUS)

SEND_STATUS_LOOP:
    lpm r16, Z+        ; legge byte da FLASH
    cpi r16, 0
    breq MAIN_LOOP      ; fine stringa
WAIT_TX_READY:
    lds r17, UCSR0A
    sbrc r17, UDRE0
    rjmp WAIT_TX_READY
    sts UDR0, r16
    rjmp SEND_STATUS_LOOP

;------------------------------------------
; INVIO OK
;------------------------------------------
SEND_OK:
    ldi r30, low(MSG_OK)
    ldi r31, high(MSG_OK)

SEND_OK_LOOP:
    lpm r16, Z+
    cpi r16, 0
    breq MAIN_LOOP
WAIT_TX_OK:
    lds r17, UCSR0A
    sbrc r17, UDRE0
    rjmp WAIT_TX_OK
    sts UDR0, r16
    rjmp SEND_OK_LOOP

;------------------------------------------
; MESSAGGI in FLASH
;------------------------------------------
MSG_STATUS:
    .db "<Idle|MPos:0.000,0.000,0.000|FS:0,0>",0
MSG_OK:
    .db "ok",0