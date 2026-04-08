


	; read address from basic variables M and O
	; default to $c000, if not set
	;
	lda #$4f 		a9,4f
	ldx #$00 		a2,00
	jsr @d 			20,<d,>d
	sta @o 			8d,<o,>o
	stx @o+1 		8e,+o,>o

	lda #$4f 		a9,4d
	ldx #$00 		a2,00
	jsr @d 			20,<d,>d
	sta @m 			8d,<m,>m
	stx @m+1 		8e,+m,>m
	rts 			60

	; fac = (int) var
	; in:
	; ax - variable name 1st byte
	; xr - variable name 2nd byte
	; out:
	; ax - low byte, default $00
	; xr - high byte, default $c0
	;
@d	ldy #$00 		a0,00
	sta $45 		85,45
	stx $46 		86,46
	lda $2d 		a5,2d
	ldx $2e 		a6,2e
	jsr $b0ef 		20,ef,b0
	jsr $bba2 		20,a2,bb
	lda $61 		a5,61
	beq @2 			f0,?2
	jsr $bc9b 		20,9b,bc
	lda $65 		a5,65
	ldx $64 		a6,64
	rts 			60
@2 	lda #$00 		a9,00
	ldx #$c0 		a2,c0
	rts				60

@o 	00,00
@m 	00,00


240 data a9,4f,a2,00,20,<d,>d,8d,<o,>o,8e,+o,>o
241 data a9,4d,a2,00,20,<d,>d,8d,<m,>m,8e,+m,>m,60
250 data @d,a0,00,85,45,86,46,a5,2d,a6,2e,20,ef,b0,20,a2,bb
251 data a5,61,f0,?2,20,9b,bc,a5,65,a6,64,60,@2,a9,00,a2,c0,60
260 data @o,00,00,@m,00,00
900 data end



	; fd/fe = address of i-th element
	;	
	; fd/fe = 2f/30, end of vartab
@a 	lda $2f 		a5,2f
	sta $fd 		85,fd
	lda $30 		a5,30
	sta $fe 		85,fe

	lda @i 			ad,<i,>i

	; if i = 0, end
	beq @1			f0,?1

	; t = i * 2
	clc 			18
	asl a 			0a
	sta @t 			8d,<t,>t
	lda #$00 		a9,00
	adc @t+1 		6d,+t,>t
	sta @t+1 		8d,+t,>t

	; fd/fe = fd/fe + t
	clc 			18
	lda $fd 		a5,fd
	adc @t 			6d,<t,>t
	sta $fd 		85,fd
	lda $fe 		a5,fe
	adc @t+1 		6d,+t,>t
	sta $fe 		85,fe

@1	rts 			60


; v = (fd/fe)
;
@b	ldy #$00  		a0,00
	lda ($fd),y 	b1,fd
	sta @v 			8d,<v,>v
	iny 			c8
	lda ($fd),y 	b1,fd
	sta @v+1 		8d,+v,>v
	rts 			60

; (fd/fe) = v
;
@c	ldy #$00 		a0,00
	lda @v 			ad,<v,>v
	sta ($fd),y 	91,fd
	iny 			c8
	lda @v+1 		ad,+v,>v
	sta ($fd),y 	91,fd
	rts 			60

@i	0
@v 	0,0
@t  0,0


200 data @a,a5,2f,85,fd,a5,30,85,fe
201 data ad,<i,>i,f0,?1
202 data 18,0a,8d,<t,>t,a9,00,6d,+t,>t,8d,+t,>t
203 data 18,a5,fd,6d,<t,>t,85,fd,a5,fe,6d,+t,>t,85,fe,@1,60
210 data @b,a0,00,b1,fd,8d,<v,>v,c8,b1,fd,8d,+v,>v,60
220 data @c,a0,00,ad,<v,>v,91,fd,c8,ad,+v,>v,91,fd,60
230 data @i,00,@v,00,00,@t,00,00
900 data end



RESTORE
$A81D–A82B

READ
$AC06–ACFB

$11 	= #$98
$0d 	= #$ff
$49/4a 	= memoria mutato ahova az olvasas tortenjen / variable data ptr
$43/44 	= $7a/7b
$7a/7b 	= $41/42

ac2c-n kezd el olvasni
	$0d-nak be kell lennie allitva $ff-re (string valtozo)
	ra kell mutatni 49/4a-val a string hossz/mutato-t az elemre


$0041-$0042	65-66		next DATA item for READ
$00A9		169	Flag	RS-232 start bit 0 = received, 144 = not received
$0011		17	Flag	Designates data entry method; 0 = INPUT, 64 = GET or 152 = READ
$0043-$0044	67-68		temporary storage for INPUT/ pointer (41/42-hoz hasonlo)
$0049-$004A	73-74		Index variable of FOR ... NEXT loop/variable data pointer
$007a-$007b 			chrget/got-on belul az aktualis karakter mutato
$004b-$004c 			7a/7b atmeneti taroloja (ha le akarja menteni)
$000D		13	Flag	Variable type; 0 = numeric, 255 = character string

bff1 49137
bffd 49188

$B08B
Output: ax/yr pointer to variable data
Fetch name of variable from BASIC program and find it; if found, address of variable is written into memory addresses $005F-$0060, address of value into memory addressesd $0047-$0048; if not found and the caller was $AF28, return empty value (0 for numerical or empty string for string variables), otherwise create new variable with empty value.



https://www.c64-wiki.com/wiki/Zeropage
https://sta.c64.org/cbm64basconv.html
https://sta.c64.org/cbm64pet.html

A$="OK" -> 41 80 02 09 08 00 00, ahol
	41 80	valtozo neve
	02 		$ ertek hossza
	09 08 	$ ertek cime
	00 00 	$ valtozonal nem hasznalt


READ
$AC06–ACFB

xr/yr 	:= $41/42

ac 		:= $98

$11 	:= ac

$43/44 	:= xr/yr

jsr $b08b
	$5f/60 	:= variable address
	$47/48 	:= variable value address
	ac/yr 	:= variable value address

$49/4a 	:= ac/yr

ac/yr 	:= $7a/7b

$4b/4c 	:= ac/yr

xr/yr 	:= $43/44

$7a/7b 	:= xr/yr

jsr $0079
	ac 		:= CHRGET character read
	C 		:= 0 if decimal digit
	Z 		:= 1 if end of instruction 



	; set pointers to A$
	;
 	lda #<s 		a9,<s
 	sta $5f 		85,5f
 	lda #>s 		a9,>s
 	sta $60 		85,60

 	lda ##s 		a9,#s
 	sta $47 		85,47
 	sta $49 		85,49
 	lda #>s 		a9,>s
 	sta $48 		85,48
 	sta $4a 		85,4a

	; READ A$
	;
 	lda #$98 		a9,98  ; c014 49172
 	sta $11 		85,11

 	lda #$ff 		a9,ff
 	sta $0d 		85,0d

 	lda $7a 		a5,7a
 	sta $4b 		85,4b
 	lda $7b 		a5,7b
 	sta $4c 		85,4c

 	lda $41 		a5,41
 	sta $43 		85,43
 	sta $7a 		85,7a
 	lda $42 		a5,42
 	sta $44 		85,44
 	sta $7b 		85,7b

 	jsr $ac2c 		20,2c,ac
 	rts 			60

	; A$
	;
@s 	41,80,00,00,00,00,00


200 data a9,<s,85,5f,a9,>s,85,60
205 data a9,#s,85,47,85,49,a9,>s,85,48,85,4a
210 data a9,98,85,11,a9,ff,85,0d
215 data a5,7a,85,4b,a5,7b,85,4c
220 data a5,41,85,43,85,7a,a5,42,85,44,85,7b
225 data 20,2c,ac,60,@s,41,80,00,00,00,00,00
230 data end



Name:	CHRGET / CHRGOT
Description:	Read characters from BASIC text
Entry point:	$73 / 115 (CHRGET)
$79 / 121 (CHRGOT)
Passed arguments:
Return values:
Accumulator:	Character read
carry flag:	0 = decimal digit
zero flag:	1 = end of instruction
