;
; Arduino Asembler, RGB diode 800kHz.asm
;
; Created: 11.10.2022. 10:02:02
; Author : Aleksandar Bogdanovic
;

/* Arduino Asembler, RGB diode 800kHz. Proveriti da li je Arduino 
koji koristite dovoljno brz, ako nije, odraiditi na ESP-u. 
Analizirati protokol, odraditi interfejs gde šaljemo R, G, B tri bajta
i RGB idoda svetli u zadatoj boji*/

// Belo svetli 1 sekund to je main, zatim ide loop - crvena boja 2 sekunde, ugasi se 1 sekund, plava boja 2 sekunde, 

.include "m328pdef.inc"
.org 0x000000
jmp main

// NOP = 1 clock cycle = 0.0625

main:
	sbi DDRD, 4
	rcall white
	rcall delay_1000ms
loop:
	rcall black
	rcall delay_ms				// reset
	rcall delay_1000ms
	;
	rcall red
	rcall delay_ms
	rcall delay_2000ms
	;
	rcall black
	rcall delay_ms				// reset
	rcall delay_1000ms
	;
	rcall blue
	rcall delay_ms
	rcall delay_2000ms
	;
	rcall black
	rcall delay_ms				// reset
	rcall delay_1000ms
	;
	rcall green
	rcall delay_ms
	rcall delay_2000ms
	;
	rjmp loop

black:
	// BLACK = 0x000000, logic 0 code
	ldi r17, 24
b1: sbi PORTD, 4				// 0.40 ms high pulse = 6 CLK cycles
	nop							// NOP = 1 clock cycle = 0.0625 micro seconds
	nop
	nop
	nop
	nop							// 6 * 0.0625 = 0.375 ms
	cbi PORTD, 4				// 0.85ms low pulse = 14 CLK cycles
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop	
	nop						// 12 NOP => 12 CLK cycles						
	dec r17						// 1 CLK cycles
	brne b1						// 1 CLK cycles
	ret

white:
	// WHITE = 0xFFFFFF, logic 1 code
	ldi r17, 24					// 24 bits
w1: sbi PORTD, 4				// 0.80ms high pulse
	nop							// NOP = 1 clock cycle = 0.0625 micro seconds
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop							// 13 NOP => 13 CLK cycles => 0.8125 ms
	//
	cbi PORTD, 4				// 0.45ms low pulse
	// logic 0
	nop
	nop
	nop
	nop
	nop							// 5 NOP
	dec	r17						// 1 CKL cycle
	brne w1						// 1 CKL cycle 5+1+1 = 7 cycles => 7 * 0.0625 = 0.4375 ms
	ret

green:
	// GREEN = 0xFF0000
	ldi r17, 8					// counter for 1st 8 bits
// logic 1
g1:	sbi PORTD, 4				// 0.80ms high pulse
	nop							// NOP = 1 clock cycle = 0.0625 micro seconds
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop							// 13 NOP => 13 CLK cycles => 0.8125 ms
	cbi PORTD, 4				// 0.45ms low pulse
	nop
	nop
	nop
	nop							// 5 NOP
	dec	r17						// 1 CKL cycle
	brne g1						// 1 CKL cycle 5+1+1 = 7 cycles => 7 * 0.0625 = 0.4375 ms
	//
	ldi r17, 16					// counter for remaining 16 bits
	// logic 0
g2:	sbi PORTD, 4				// 0.40ms high pulse
	nop
	nop
	nop
	nop
	nop							// 6 * 0.0625 = 0.375 ms
	cbi PORTD, 4				// 0.85 ms low pulse = 14 CLK cycles
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop							// 12 NOP => 12 CLK cycles						
	dec r17						// 1 CLK cycles
	brne g2						// 1 CLK cycles, 14 * 0.0625 ms = 0.875 ms 
	ret

red:
	// RED = 0x00FF00
	ldi r17, 8					// counter for 1st 8 bits => 00
	// logic 0
red1:sbi PORTD, 4				// 0.40ms high pulse
	nop
	nop
	nop
	nop
	nop							// 6 * 0.0625 = 0.375 ms
	cbi PORTD, 4				// 0.85 ms low pulse = 14 CLK cycles
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop							// 12 NOP => 12 CLK cycles						
	dec r17						// 1 CLK cycles
	brne red1					// 1 CLK cycles, 14 * 0.0625 ms = 0.875 ms
	//
	ldi r17, 8					// counter for 2nd 8 bits => XX
	// logic 1
red2:sbi PORTD, 4				// 0.80ms high pulse
	nop							// NOP = 1 clock cycle = 0.0625 micro seconds
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop							// 13 NOP => 13 CLK cycles => 0.8125 ms
	cbi PORTD, 4				// 0.45ms low pulse
	nop
	nop
	nop
	nop							// 5 NOP
	dec	r17						// 1 CKL cycle
	brne red2					// 1 CKL cycle 5+1+1 = 7 cycles => 7 * 0.0625 = 0.4375 ms
	//
	ldi r17, 8					// counter for final 8 bits => 00
	// logic 0
red3:sbi PORTD, 4				// 0.40 ms high pulse
	nop
	nop
	nop
	nop
	nop							// 6 * 0.0625 = 0.375 ms
	cbi PORTD, 4				// 0.85 ms low pulse = 14 CLK cycles
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop							// 12 NOP => 12 CLK cycles						
	dec r17						// 1 CLK cycles
	brne red3					// 1 CLK cycles, 14 * 0.0625 ms = 0.875 ms
	ret

blue:
	// BLUE = 0x0000FF
	ldi r17, 16					// counter for 1st 16 bits => 0000
	// logic 0
bl1: sbi PORTD, 4				// 0.40 ms high pulse
	nop
	nop
	nop
	nop
	nop							// 6 * 0.0625 = 0.375 ms
	cbi PORTD, 4				// 0.85 ms low pulse = 14 CLK cycles
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop							// 12 NOP => 12 CLK cycles						
	dec r17						// 1 CLK cycles
	brne bl1						// 1 CLK cycles, 14 * 0.0625 ms = 0.875 ms
	//
	ldi r17, 8					// counter for final 8 bits => XX
	// logic 1
bl2:	sbi PORTD, 4				// 0.80ms high pulse
	nop							// NOP = 1 clock cycle = 0.0625 micro seconds
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop							// 13 NOP => 13 CLK cycles => 0.8125 ms
	cbi PORTD, 4				// 0.45ms low pulse
	nop
	nop
	nop
	nop							// 5 NOP
	dec	r17						// 1 CKL cycle
	brne bl2						// 1 CKL cycle 5+1+1 = 7 cycles => 7 * 0.0625 = 0.4375 ms
	ret

delay_ms:					// delay = 50 micro seconds => reset
	ldi  r18, 2
    ldi  r19, 8
L1: dec  r19
    brne L1
    dec  r18
    brne L1
    rjmp PC+1
    ret

delay_2000ms:
	ldi  r18, 163
    ldi  r19, 87
    ldi  r20, 3
L2: dec  r20
    brne L2
    dec  r19
    brne L2
    dec  r18
    brne L2
	ret

delay_1000ms:
	ldi  r18, 82
    ldi  r19, 43
    ldi  r20, 0
L3: dec  r20
    brne L3
    dec  r19
    brne L3
    dec  r18
    brne L3
    lpm



