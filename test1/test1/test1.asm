
.include "m32def.inc"

//definicje rejestrow
.def Kolumna = R22
.def Zerowanie = R21 
.def Stos = R20
.def Seg0 = R19
.def Seg1 = R18
.def Seg2 = R17
.def Seg3 = R16

//definicje warotsci wyswietlanych

.equ zero = ~0x3F
.equ jeden = ~0x06
.equ dwa = ~0x5B
.equ trzy = ~0x4F
.equ cztery = ~0x66
.equ piec = ~0x6D
.equ szesc = ~0x7D
.equ siedem = ~0x07
.equ osiem = ~0x7F
.equ dziewiec = ~0x6F

//programik

.org 0x000 //definicje wektorow przerwan
rjmp Reset
.org 0x016
rjmp TimerOVF


Reset:// przerwanie reset
ldi Stos, LOW(RAMEND)
out SPL, Stos
ldi Stos, HIGH(RAMEND)
out SPH, Stos
ldi Zerowanie, 0xff //inicjacje jak w instrukcji
out DDRA, Zerowanie
ldi Kolumna, 0xff
out DDRD, Kolumna
sei
ldi Zerowanie, 0xFF//tu sobie ustawiamy zera- bedziemy tym wylaczac segmenty
ldi Seg0, cztery
ldi Seg0, trzy
ldi Seg0, dwa
ldi Seg3, jeden
jmp Wyswietlanie

Wyswietlanie: //petla glowna

ldi Kolumna, 0xF0
out PORTD, Kolumna
out PORTA, Seg0
rcall Opoznienie
out PORTA, Zerowanie

ldi Kolumna, 0xF1
out PORTD, kolumna
out PORTA, Seg1
rcall Opoznienie
out PORTA, Zerowanie

ldi Kolumna, 0xF2
out PORTD, kolumna
out PORTA, Seg2
rcall Opoznienie
out PORTA, Zerowanie

ldi Kolumna, 0xF3
out PORTD, kolumna
out PORTA, Seg3
rcall Opoznienie
out PORTA, Zerowanie

rjmp Wyswietlanie //koniec Wyswietlanie


Opoznienie://15ms
ldi  r23, 20
ldi  r24, 122
L1: 
dec  r24
brne L1
dec  r23
brne L1
nop


TimerOVF:
reti
