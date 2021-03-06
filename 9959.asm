.include "m32def.inc"
//makra dla czytelnosci kodu
.macro pushf
		push R30
		in R30,SREG
		push R30
.endm

.macro popf
		pop R30
		out SREG, R30
		pop R30
.endm

//definicje rejestrow
.def licznik5 = r25
.def licznik4 = r26
.def licznik3 = r27
.def licznik2 = r28
.def licznik1 = r29
.def Klawisz = R30
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
ldi Zerowanie, 0b11000011//ustawiamy portc tam gdzie sie da na wejscie do klawiatury
out DDRC, Zerowanie

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
ldi Seg0, dziewiec
ldi Seg1, piec
ldi Seg2, dziewiec
ldi Seg3, dziewiec
jmp Wyswietlanie



 //petla glowna
/*
//Obsluga klawisza
Przycisk:
in Klawisz, PINC			;ładuj do rejestru Klawisz stan na porcie C
sbrc Klawisz, 0				;jeśli zerowy bit ma stan niski (przycisk wcisniety) to przeskocz następną instrukcję i idz do PrzyciskWcisniety
rjmp Wyswietlanie				;jeśli natomiast stan jest wysoki, idz do Wyswietlanie

PrzycikWcisniety:
cli
in Klawisz, PINC	;znowu laduj do Klawisz stan na klawiaturze
cpi Klawisz,0b

rjmp PrzyciskWcisniety
sei*/

Wyswietlanie:

ldi Kolumna, 0b11110111
out PORTD, Kolumna
out PORTA, Seg0
rcall Opoznienie
out PORTA, Zerowanie

ldi Kolumna, 0b11111011
out PORTD, kolumna
out PORTA, Seg1
rcall Opoznienie
out PORTA, Zerowanie

ldi Kolumna, 0b11111101
out PORTD, kolumna
out PORTA, Seg2
rcall Opoznienie
out PORTA, Zerowanie

ldi Kolumna, 0b11111110
out PORTD, kolumna
out PORTA, Seg3
rcall Opoznienie
out PORTA, Zerowanie

rjmp Wyswietlanie//Przycisk //koniec Wyswietlanie


Opoznienie://5ms
ldi  r23, 7
ldi  r24, 125
L1: 
dec  r24
brne L1
dec  r23
brne L1
nop
reti


TimerOVF: //przerwanie czasowe
pushf
inc licznik1
cpi licznik1, 125
breq DecSekundyJ
ContinueOVF:
ldi Temp, 131 //ustawienie wart poczatkowej
out TCNT0, Temp
popf
reti

DecSekundyJ:
ldi licznik1,0
inc licznik2
cpi licznik2, 1
breq wartOsiemJ
cpi licznik2, 2
breq wartSiedemJ
cpi licznik2, 3
breq wartSzescJ
cpi licznik2, 4
breq wartPiecJ
cpi licznik2, 5
breq wartCzteryJ
cpi licznik2, 6
breq wartTrzyJ
cpi licznik2, 7
breq wartDwaJ
cpi licznik2, 8
breq wartJedenJ
cpi licznik2, 9
breq wartZeroJ
cpi licznik2, 10
breq wartDziewiecJ

wartOsiemJ:
ldi Seg0, osiem
rjmp ContinueOVF

wartSiedemJ:
ldi Seg0, siedem
rjmp ContinueOVF

wartSzescJ:
ldi Seg0, szesc
rjmp ContinueOVF

wartPiecJ:
ldi Seg0, piec
rjmp ContinueOVF

wartCzteryJ:
ldi Seg0, cztery
rjmp ContinueOVF

wartTrzyJ:
ldi Seg0, trzy
rjmp ContinueOVF

wartDwaJ:
ldi Seg0, dwa
rjmp ContinueOVF

wartJedenJ:
ldi Seg0, jeden
rjmp ContinueOVF

wartZeroJ:
ldi Seg0, zero
rjmp ContinueOVF

wartDziewiecJ:
ldi Seg0, dziewiec
ldi licznik2,0
inc licznik3
cpi licznik3, 1
breq wartCzteryD
cpi licznik3, 2
breq wartTrzyD
cpi licznik3, 3
breq wartDwaD
cpi licznik3, 4
breq wartJedenD
cpi licznik3, 5
breq wartZeroD
cpi licznik3, 6
breq wartPiecD
rjmp ContinueOVF

wartCzteryD:
ldi Seg1, cztery
rjmp ContinueOVF

wartTrzyD:
ldi Seg1, trzy
rjmp ContinueOVF

wartDwaD:
ldi Seg1, dwa
rjmp ContinueOVF

wartJedenD:
ldi Seg1, jeden
rjmp ContinueOVF

wartZeroD:
ldi Seg1, zero
rjmp ContinueOVF

wartPiecD:
ldi Seg1, zero
ldi licznik3,0
inc licznik4
cpi licznik4, 1
breq wartOsiemS
cpi licznik4, 2
breq wartSiedemS
cpi licznik4, 3
breq wartSzescS
cpi licznik4, 4
breq wartPiecS
cpi licznik4, 5
breq wartCzteryS
cpi licznik4, 6
breq wartTrzyS
cpi licznik4, 7
breq wartDwaS
cpi licznik4, 8
breq wartJedenS
cpi licznik4, 9
breq wartZeroS
cpi licznik4, 10
breq wartDziewiecS
rjmp ContinueOVF

wartOsiemS:
ldi Seg2, osiem
rjmp ContinueOVF

wartSiedemS:
ldi Seg2, siedem
rjmp ContinueOVF

wartSzescS:
ldi Seg2, szesc
rjmp ContinueOVF

wartPiecS:
ldi Seg2, piec
rjmp ContinueOVF

wartCzteryS:
ldi Seg2, cztery
rjmp ContinueOVF

wartTrzyS:
ldi Seg2, trzy
rjmp ContinueOVF

wartDwaS:
ldi Seg2, dwa
rjmp ContinueOVF

wartJedenS:
ldi Seg2, jeden
rjmp ContinueOVF

wartZeroS:
ldi Seg2, zero
rjmp ContinueOVF

wartDziewiecS:
ldi Seg2, dziewiec
ldi licznik4,0
inc licznik5
cpi licznik5, 1
breq wartOsiemT
cpi licznik5, 2
breq wartSiedemT
cpi licznik5, 3
breq wartSzescT
cpi licznik5, 4
breq wartPiecT
cpi licznik5, 5
breq wartCzteryT
cpi licznik5, 6
breq wartTrzyT
cpi licznik5, 7
breq wartDwaT
cpi licznik5, 8
breq wartJedenT
cpi licznik5, 9
breq wartZeroT
cpi licznik5, 10
breq wartDziewiecT
rjmp ContinueOVF


wartOsiemT:
ldi Seg3, osiem
rjmp ContinueOVF

wartSiedemT:
ldi Seg3, siedem
rjmp ContinueOVF

wartSzescT:
ldi Seg3, szesc
rjmp ContinueOVF

wartPiecT:
ldi Seg3, piec
rjmp ContinueOVF

wartCzteryT:
ldi Seg3, cztery
rjmp ContinueOVF

wartTrzyT:
ldi Seg3, trzy
rjmp ContinueOVF

wartDwaT:
ldi Seg3, dwa
rjmp ContinueOVF

wartJedenT:
ldi Seg3, jeden
rjmp ContinueOVF

wartZeroT:
ldi Seg3, zero
rjmp ContinueOVF

wartDziewiecT:
ldi Seg3, dziewiec
ldi licznik5,0
rjmp ContinueOVF

