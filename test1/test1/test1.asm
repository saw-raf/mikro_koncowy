
.include "m32def.inc"
//makra dla czytelnosci kodu
.macro pushf
		push Acc
		in Acc,SREG
		push Acc
.endm

.macro popf
		pop Acc
		out SREG, Acc
		pop Acc
.endm

//definicje rejestrow
.def licznik3 = r27
.def licznik2 = r28
.def licznik1 = r29
.def Acc = R30
.def Temp = R31
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

ldi Temp, (1<<CS00) | (1<<CS01)//to do przerwan
out TCCR0, Temp //ustawienie preskalera na 64
ldi Temp, 1<<TOIE0; //wlaczenie przerwania
out TIMSK, Temp
ldi Temp, 131 //ustawienie wart poczatkowej
out TCNT0, Temp
sei //wlaczenie przerwan
ldi licznik1,0
ldi licznik2,0
ldi licznik3,0

ldi Zerowanie, 0xFF//tu sobie ustawiamy zera- bedziemy tym wylaczac segmenty
ldi Seg0, zero
ldi Seg0, zero
ldi Seg0, zero
ldi Seg3, zero
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


TimerOVF: //przerwanie czasowe
pushf
inc licznik1
cpi licznik1, 125
breq IncSekundyJ
ContinueOVF:
ldi Temp, 131 //ustawienie wart poczatkowej
out TCNT0, Temp
popf
reti

IncSekundyJ:
ldi licznik1,0
inc licznik2
cpi licznik2, 1
breq wartJedenJ
cpi licznik2, 2
breq wartDwaJ
cpi licznik2, 3
breq wartTrzyJ
cpi licznik2, 4
breq wartCzteryJ
cpi licznik2, 5
breq wartPiecJ
cpi licznik2, 6
breq wartSzescJ
cpi licznik2, 7
breq wartSiedemJ
cpi licznik2, 8
breq wartOsiemJ
cpi licznik2, 9
breq wartDziewiecJ
cpi licznik2, 10
breq wartDziesiecJ


wartJedenJ:
ldi Seg0, jeden
rjmp ContinueOVF

wartDwaJ:
ldi Seg0, dwa
rjmp ContinueOVF

wartTrzyJ:
ldi Seg0, trzy
rjmp ContinueOVF

wartCzteryJ:
ldi Seg0, cztery
rjmp ContinueOVF

wartPiecJ:
ldi Seg0, piec
rjmp ContinueOVF

wartSzescJ:
ldi Seg0, szesc
rjmp ContinueOVF

wartSiedemJ:
ldi Seg0, siedem
rjmp ContinueOVF

wartOsiemJ:
ldi Seg0, osiem
rjmp ContinueOVF

wartDziewiecJ:
ldi Seg0, dziewiec
rjmp ContinueOVF

wartDziesiecJ:
ldi Seg0, zero
ldi licznik2,0
inc licznik3
cpi licznik3, 1
breq wartJedenD
cpi licznik3, 2
breq wartDwaD
cpi licznik3, 3
breq wartTrzyD
cpi licznik3, 4
breq wartCzteryD
cpi licznik3, 5
breq wartPiecD
cpi licznik3, 6
breq wartSzescD
rjmp ContinueOVF

wartJedenD:
ldi Seg1, jeden
rjmp ContinueOVF

wartDwaD:
ldi Seg1, dwa
rjmp ContinueOVF

wartTrzyD:
ldi Seg1, trzy
rjmp ContinueOVF

wartCzteryD:
ldi Seg1, cztery
rjmp ContinueOVF

wartPiecD:
ldi Seg1, piec
rjmp ContinueOVF

wartSzescD:
ldi Seg1, zero
ldi licznik3,0
rjmp ContinueOVF