

	; Read BASIC variables
	; 	O defaults to C000, if not set
	; 	M defaults to O, if not set
	;
 	lda #$00 		a9,00
	ldx #$c0 		a2,c0
	sta @2+1 		8d,+2,>2
	stx @3+1 		8e,+3,>3

	lda #$4f 		a9,4f
	ldx #$00 		a2,00
	jsr @d 			20,<d,>d
	sta @o 			8d,<o,>o
	stx @o+1 		8e,+o,>o

	sta @2+1 		8d,+2,>2
	stx @3+1 		8e,+3,>3

	lda #$4f 		a9,4d
	ldx #$00 		a2,00
	jsr @d 			20,<d,>d
	sta @m 			8d,<m,>m
	stx @m+1 		8e,+m,>m
	rts 			60

	; O, Origin
	;
@o 	00,00

	; M, Memory
	;
@m 	00,00

	; ac/xr = (int) var
	;
	; in:
	; 	ac - variable name 1st byte
	; 	xr - variable name 2nd byte
	; out:
	; 	ac - low byte, default $00
	; 	xr - high byte, default $c0
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
@3	ldx #$c0 		a2,c0
	rts				60

240 data a9,00,a2,c0,8d,+2,>2,8e,+3,>3
241 data a9,4f,a2,00,20,<d,>d,8d,<o,>o,8e,+o,>o
242 data 8d,+2,>2,8e,+3,>3
243 data a9,4d,a2,00,20,<d,>d,8d,<m,>m,8e,+m,>m
244 data 60
245 data @o,00,00,@m,00,00
250 data @d,a0,00,85,45,86,46,a5,2d,a6,2e,20,ef,b0,20,a2,bb
251 data a5,61,f0,?2,20,9b,bc,a5,65,a6,64,60,@2,a9,00,@3,a2,c0,60
252 data 60,;



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



	; use variable S$
	;
 	lda #$ff 		a9,ff 	; variable is a string
 	sta $0d 		85,0d

 	lda #<s 		a9,<s
 	sta $49 		85,49
 	lda #>s 		a9,>s
 	sta $4a 		85,4a
 	rts 			60

	; S$
	;
@s 	00,00,00

	; READ A$
	;
 	lda #$98 		a9,98 	; data entry method is READ
 	sta $11 		85,11

 	lda $7a 		a5,7a 	; save current CHRGET position to temp
 	sta $4b 		85,4b
 	lda $7b 		a5,7b
 	sta $4c 		85,4c

 	lda $41 		a5,41 	; set current CHRGET position to next DATA element
 	sta $7a 		85,7a
 	lda $42 		a5,42
 	sta $7b 		85,7b

 	jsr $ac2c 		20,2c,ac
 	rts 			60


200 data a9,ff,85,0d,a9,<s,85,49,a9,>s,85,4a,60
202 data @s,00,00,00
206 data a9,98,85,11
208 data a5,7a,85,4b,a5,7b,85,4c
210 data a5,41,85,7a,a5,42,85,7b
212 data 20,2c,ac,60
220 data ;
