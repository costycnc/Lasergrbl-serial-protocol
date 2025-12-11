;------------------------------------------
; Fake GRBL Minimal – Arduino Nano / ATmega328P
; Macro version for minimal cognitive load
; Every Arduino line is referenced as comment
; Educational version with detailed comments
;------------------------------------------

.org 0x0000
rjmp RESET                                      ; jump to RESET, equivalent to Arduino setup start

.org 0x60
RESET:
    INIT_SERIAL                                 ; Arduino: Serial.begin(115200), setup USART

MAIN_LOOP:
    READ_SERIAL                                 ; Arduino: while(Serial.available()) Serial.read(), wait for byte

    CASE_NEWLINE                                ; if byte == '\n', send "ok" to host
    CASE_ASK_SIGN                               ; if byte == '?', send status to host
    CASE_DEFAULT_OK                             ; otherwise send "ok" anyway (for compatibility)

    rjmp MAIN_LOOP                              ; loop forever, equivalent to Arduino loop()

;------------------- MACRO ZONE ----------------------

.macro INIT_SERIAL
    ; Initialize USART0 for 115200 baud, 8N1
    ; Registers: UBRR0H/UBRR0L = baud rate
    ; UCSR0B = enable RX/TX
    ; UCSR0C = frame format: 8 data bits, no parity, 1 stop bit
    ldi r16, 0b00000000
    sts 0xC5, r16       ; UBRR0H = 0, high byte baud
    ldi r16, 0b00001000
    sts 0xC4, r16       ; UBRR0L = 8, low byte baud → 16MHz/115200 = 8
    ldi r16, 0b00011000
    sts 0xC1, r16       ; RXEN0 + TXEN0, enable receiver and transmitter
    ldi r16, 0b00000110
    sts 0xC2, r16       ; UCSZ01 + UCSZ00, 8-bit data
.endmacro

.macro READ_SERIAL
    ; Wait for byte from USART, similar to Arduino Serial.available()
WAIT_RX:
    lds r16, 0xC0       ; read UCSR0A
    sbrc r16, 7         ; check RXC0 (Receive Complete)
    rjmp READ_DONE
    rjmp WAIT_RX         ; wait until byte received
READ_DONE:
    lds r16, 0xC6       ; read byte from UDR0 (USART Data Register)
.endmacro

.macro CASE_NEWLINE
    ; Check if received byte == '\n'
    ; Equivalent Arduino: if(byte == '\n') { Serial.println("ok"); }
    cpi r16, 0x0A
    brne CASE_NEWLINE_END
        SEND_OK          ; send "ok" response
        rjmp MAIN_LOOP   ; break, return to main loop
CASE_NEWLINE_END:
.endmacro

.macro CASE_ASK_SIGN
    ; Check if received byte == '?'
    ; Equivalent Arduino: if(byte == '?') { Serial.println(status); }
    cpi r16, '?'
    brne CASE_ASK_SIGN_END
        SEND_STATUS      ; send status string
        rjmp MAIN_LOOP   ; break, return to main loop
CASE_ASK_SIGN_END:
.endmacro

.macro CASE_DEFAULT_OK
    ; Default behavior: always reply "ok" for unknown commands
    ; This keeps host software happy, avoids buffer overflow
    SEND_OK
.endmacro

.macro SEND_OK
    ; Point Z register to string "ok" in flash
    ; Arduino: Serial.println("ok");
    ldi r30, low(MSG_OK*2)
    ldi r31, high(MSG_OK*2)
    rcall SEND_STRING     ; call subroutine to send string byte by byte
.endmacro

.macro SEND_STATUS
    ; Point Z register to status string in flash
    ; Arduino: Serial.println("<Idle|MPos:0.000,...>");
    ldi r30, low(MSG_STATUS*2)
    ldi r31, high(MSG_STATUS*2)
    rcall SEND_STRING     ; send byte by byte
.endmacro

;------------------------------------------
; Subroutine: send string from flash memory
; Only this subroutine has labels, avoids conflicts
;------------------------------------------
SEND_STRING:
SEND_LOOP:
    lpm r16, Z+                   ; read byte from program memory (flash)
    cpi r16, 0
    breq RETURN                    ; end of string → return
WAIT_TX:
    lds r17, 0xC0                 ; read UCSR0A
    sbrs r17, 5                   ; wait for UDRE0 (Transmit buffer empty)
    rjmp WAIT_TX
    sts 0xC6, r16                 ; write byte to UDR0
    rjmp SEND_LOOP
RETURN:
    ret

;------------------------------------------
; Strings stored in flash (program memory)
;------------------------------------------
MSG_OK:
    .db "ok",10,0                   ; "\n" added for Arduino println

MSG_STATUS:
    .db "<Idle|MPos:0.000,0.000,0.000|FS:0,0|WCO:0.000,0.000,0.000>",10,0

