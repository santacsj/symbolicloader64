; Get BASIC variables
; 	O defaults to C000, if not set
; 	$fb/fc defaults to O, if not set
;
a9,00,a2,c0,8d,+2,>2,8e,+3,>3

a9,4f,a2,00,20,<d,>d,85,69,86,6a

8d,+2,>2,8e,+3,>3

a9,4d,a2,00,20,<d,>d,85,fb,86,fc

; READ into $21-23
;
a9,ff,85,0d

a9,21,85,49,a9,00,85,4a

; Pass 1
;
20,<h,>h ; PC = O
20,1d,a8 ; RESTORE

@5,20,<g,>g ; READ S$

a0,00,b1,22

c9,3b,f0,?7 ; end of pass?

c9,40,f0,?6 ; symbol?

e6,f9,d0,?5,e6,fa,f0,?5 ; PC++

@6,c8,b1,22
aa ; I = asc(symbol)
20,<a,>a ; fd/fe = symbol table address for I

a5,fa,91,fd,88,a5,f9,91,fd ; (fd/fe) = PC

4c,<5,>5

; Pass 2
;
@7,20,<h,>h ; PC = O
20,1d,a8 ; RESTORE

@8,20,<g,>g ; READ S$

a5,21,20,24,ab,a9,20,20,d2,ff,20,d2,ff ; print c$ spc(2)

a0,00,b1,22,aa

e0,3b,d0,?9 ; end of pass?

60 ; return to BASIC

@9,c8,b1,22

e0,40,f0,?8 ; @

e0,3f,f0,?$ ; ?

e0,3e,d0,?/ ; >

4c,<(,>(

@/,e0,3c,d0,?. ; <

a2,00,4c,<',>' ; OF = 0

@.,e0,2b,d0,?- ; +

a2,01,4c,<',>' ; OF = 1

@-,e0,23,d0,?+ ; #

a2,02,4c,<',>' ; OF = 2

; 2 char hex str to byte
;
@+,20,<e,>e

85,02 ; unused zero-page byte as temp

88,b1,22,20,<e,>e

0a,0a,0a,0a

18,65,02

@&,a0,00,91,fb ; store by to m

e6,f9,d0,02,e6,fa ; PC++

e6,fb,d0,02,e6,fc ; M++

4c,<8,>8

; hex digit to byte
;
; in:
; 	ar - asc of hex digit
; out:
; 	ar - byte
;
@e,38,e9,30,c9,0a,90,02,e9,07,60

; ? - relative address
;
@$,20,<f,>f ; V = symbol(I)

38,a5,f7,e5,f9,85,f7,a5,f8,e5,fa,85,f8 ; V = V - PC

38,a5,f7,e9,01,85,f7,b0,?#,c6,f8 ; V = V - 1

@#,c9,80,a5,f8,e9,ff,50,?=,49,80 ; V < -128, overflow error, if N = 1

@=,10,?!

a2,0f,4c,37,a4 ; ?OVERFLOW ERROR

@!,a5,f7,c9,80,a5,f8,e9,00,50,?<,49,80 ; V >= 128, overflow error, if N = 0

@<,30,?>

a2,0f,4c,37,a4 ; ?OVERFLOW ERROR

@>,a5,f7

4c,<&,>&

; > - high byte
;
@(,20,<f,>f ; V = symbol(I)
a5,f8
4c,<&,>&

; <,+,# - low byte
;
; in:
; 	xr - offset
;
@',86,02

20,<f,>f ; V = symbol(I)

18,a5,f7,65,02

4c,<&,>&

; PC = O
;
@h,a5,69,85,f9,a5,6a,85,fa,60

; READ S$
;
; out:
; 	$6a/6b - points to S$ data
;
@g,a9,98,85,11 ; data entry method is READ

a5,7a,85,4b,a5,7b,85,4c ; save current CHRGET position to temp

a5,41,85,7a,a5,42,85,7b ; set current CHRGET position to next DATA element

20,2c,ac,60

; ac/xr = (int) var
;
; in:
; 	ac - variable name 1st byte
; 	xr - variable name 2nd byte
; out:
; 	ac - low byte, default $00
; 	xr - high byte, default $c0
;
@d,a0,00,85,45,86,46,a5,2d,a6,2e,20,ef,b0,20,a2,bb
a5,61,f0,?2,20,9b,bc,a5,65,a6,64,60,@2,a9,00,@3,a2,c0,60

; $f7/f8 = symbol(i)
;
; in:
;	ac - asc of symbol
; out:
; 	$f7/f8 - symbol value
;
@f,aa,20,<a,>a

a0,00,b1,fd,85,f7,c8,b1,fd,85,f8 ; $f7/f8 = (fd/fe)
60

; fd/fe = address of I-th word in ARYTAB
;
; in:
; 	xr - index
;
@a,8a,0a,85,bb,a9,00,2a,85,bc ; T = I * 2

18,a5,2f,65,bb,85,fd,a5,30,65,bc,85,fe ; fd/fe = 2f/30 + T
60

