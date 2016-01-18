;; heart_monitor 
;;
;; Copyright 2014 - By Michael Kohn
;; http://www.mikekohn.net/
;; mike@mikekohn.net
;;
;; Read data from a heart monitor chip and send to computer for drawing.

.msp430
.include "msp430x2xx.inc"

RAM equ 0x0200

;  r4 =
;  r5 =
;  r6 =
;  r7 =
;  r8 =
;  r9 =
; r10 =
; r11 =
; r12 =
; r13 =
; r14 =
; r15 = 
  .org 0xc000
start:
  ;; Turn off watchdog
  mov.w #(WDTPW|WDTHOLD), &WDTCTL

  ;; Interrupts off
  dint

  ;; Set up stack pointer
  mov.w #0x0400, SP

  ;; Set MCLK to 16 MHz with DCO 
  mov.b #DCO_4, &DCOCTL
  mov.b #RSEL_15, &BCSCTL1
  mov.b #0, &BCSCTL2

.if 0
  ;; Set MCLK to 16 MHz external crystal
  bic.w #OSCOFF, SR
  bis.b #XTS, &BCSCTL1
  mov.b #LFXT1S_3, &BCSCTL3
  ;mov.b #LFXT1S_3|XCAP_1, &BCSCTL3
test_osc:
  bic.b #OFIFG, &IFG1
  mov.w #0x00ff, r15
dec_again:
  dec r15
  jnz dec_again
  bit.b #(OFIFG), &IFG1
  jnz test_osc
  mov.b #(SELM_3|SELS), &BCSCTL2
.endif

  ;; Set up output pins
  ;; P1.1 = RX
  ;; P1.2 = TX
  mov.b #0, &P1DIR
  mov.b #0, &P1OUT
  mov.b #0x06, &P1SEL
  mov.b #0x06, &P1SEL2

  ;; Setup UART
  mov.b #UCSSEL_2|UCSWRST, &UCA0CTL1
  mov.b #0, &UCA0CTL0
  ;mov.b #0x8a, &UCA0BR0
  ;mov.b #0x00, &UCA0BR1
  ;mov.b #0x20, &UCA0BR0
  ;mov.b #0x06, &UCA0BR1
  mov.b #0xf8, &UCA0BR0
  mov.b #0x05, &UCA0BR1
  bic.b #UCSWRST, &UCA0CTL1

  ;; Set up A/D
  mov.w #ADC10ON|REF2_5V|REFON|ADC10SHT_3|SREF_1, &ADC10CTL0
  mov.w #0x30, &ADC10AE0
  mov.w #INCH_4|ADC10SSEL_2, &ADC10CTL1

  ;; Set up Timer.  16,000,000 / 8 / 2222 should be 30 samples a second
  mov.w #2222, &TACCR0
  mov.w #(TASSEL_2|ID_3|MC_1), &TACTL ; SMCLK, DIV1, COUNT to TACCR0
  mov.w #CCIE, &TACCTL0
  mov.w #0, &TACCTL1

  ;; Interrupts on
  eint

main:
  jmp main

timer_interrupt:
  inc.w r14

  ;; Read value and write to serial
  mov.w &ADC10MEM, r9
  rra.w r9
  rra.w r9
  ;mov.b r9, &UCA0TXBUF
  mov.b 'A', &UCA0TXBUF

  bic.w #ENC|ADC10IFG, &ADC10CTL0
  mov.w #INCH_4|ADC10SSEL_2, &ADC10CTL1
  bis.w #ENC|ADC10SC, &ADC10CTL0
  reti

  org 0xffe8
vectors:
  dw 0
  dw 0
  dw 0
  dw 0
  dw 0
  dw timer_interrupt       ; Timer_A2 TACCR0, CCIFG
  dw 0
  dw 0
  dw 0
  dw 0
  dw 0
  dw start                 ; Reset



