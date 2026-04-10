
	jsr @e 			20,<e,>e 	; set O and M
	jsr @f 			20,<f,>f 	; use variable S$

	; Pass 1
	;
	jsr @h 			20,<h,>h 	; PC = O
	jsr @a81d 		20,1d,a8 	; RESTORE

@5	jsr @g 			20,<g,>g 	; READ S$

	ldy #$00 		a0,00
	lda ($4b),y 	b1,4b

	cmp #$3b 		c9,3b 		; end of pass 1?
	beq @7 			f0,?7

	cmp #$40 		c9,40 		; symbol?
	beq @6 			f0,?6

	jsr @j 			20,<j,>j 	; PC++

	jmp @5 			4c,<5,>5

@6 	iny 			c8 			; store PC to symbol table
	lda ($4b),y 	b1,4b
	
	sta @i 			8d,<i,>i 	; I = ASC(symbol)

	lda @p  		ad,<p,>p 	; V = PC
	sta @v 			8d,<v,>v
	lda @p+1 		ad,+p,>p
	sta @v+1 		8d,+v,>v

	jsr @a 			20,<a,>a	; fd/fe = address of I-th word in ARYTAB
	jsr @c 			20,<c,>c 	; (fd/fe) = V
	
	jmp @5 			4c,<5,>5

@7 	rts 			60

200 data 20,<e,>e,20,<f,>f,20,<h,>h,20,1d,a8
201 data @5,20,<g,>g,a0,00,b1,4b
202 data c9,3b,f0,?7,c9,40,f0,?6
203 data 20,<k,>k,4c,<5,>5
204 data @6,c8,b1,4b,8d,<i,>i
205 data 8d,<i,>i,ad,<p,>p,8d,<v,>v,ad,+p,>p,8d,+v,>v
206 data 20,<a,>a,20,<c,>c,4c,<5,>5,60
210 data @7,60


	; PC
	;
@p 	00,00

	; PC = O
	;
@h	lda @o  		ad,<o,>o
	sta @p 			8d,<p,>p
	lda @o+1 		ad,+o,>o
	sta @p+1 		8d,+p,>p
	rts 			60

	; PC++
	;
@j	inc @p 			ee,<p,>p
	bne @4 			d0,?4
	inc @p+1 		ee,+p,>p
@4	rts 			60


200 data @p,00,00
210 data @h,ad,<o,>o,8d,<p,>p,ad,+o,>o,8d,+p,>p,60
220 data @j,ee,<p,>p,d0,?4,ee,+p,>p,@4,60


	; use variable S$
	;
@f 	lda #$ff 		a9,ff 	; variable is a string
 	sta $0d 		85,0d

 	lda #<s 		a9,<s
 	sta $49 		85,49
 	lda #>s 		a9,>s
 	sta $4a 		85,4a
 	rts 			60

	; S$
	;
@s 	00,00,00

	; READ S$
	;
	; out:
	; 	$fb/fc - points to S$ data
	;
@g	lda #$98 		a9,98 		; data entry method is READ
 	sta $11 		85,11

 	lda $7a 		a5,7a 		; save current CHRGET position to temp
 	sta $4b 		85,4b
 	lda $7b 		a5,7b
 	sta $4c 		85,4c

 	lda $41 		a5,41 		; set current CHRGET position to next DATA element
 	sta $7a 		85,7a
 	lda $42 		a5,42
 	sta $7b 		85,7b

 	jsr $ac2c 		20,2c,ac

 	lda @s+1 		ad,+s,>s 	; $4b/4c = $S
	sta $fb 		85,4b
	lda @s+2 		ad,#s,>s
	sta $fc 		85,4c

 	rts 			60

200 data @f,a9,ff,85,0d,a9,<s,85,49,a9,>s,85,4a,60
202 data @s,00,00,00
206 data @g,a9,98,85,11
208 data a5,7a,85,4b,a5,7b,85,4c
210 data a5,41,85,7a,a5,42,85,7b
212 data 20,2c,ac,ad,+s,>s,85,4b,ad,#s,>s,85,4c,60


	; get BASIC variables
	; 	O defaults to C000, if not set
	; 	M defaults to O, if not set
	;
@e 	lda #$00 		a9,00
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

240 data @e,a9,00,a2,c0,8d,+2,>2,8e,+3,>3
241 data a9,4f,a2,00,20,<d,>d,8d,<o,>o,8e,+o,>o
242 data 8d,+2,>2,8e,+3,>3
243 data a9,4d,a2,00,20,<d,>d,8d,<m,>m,8e,+m,>m
244 data 60
245 data @o,00,00,@m,00,00
250 data @d,a0,00,85,45,86,46,a5,2d,a6,2e,20,ef,b0,20,a2,bb
251 data a5,61,f0,?2,20,9b,bc,a5,65,a6,64,60,@2,a9,00,@3,a2,c0,60


	; fd/fe = address of I-th word in ARYTAB
	;	
@a 	lda $2f 		a5,2f 		; fd/fe = 2f/30, ARYTAB
	sta $fd 		85,fd
	lda $30 		a5,30
	sta $fe 		85,fe

	lda @i 			ad,<i,>i
	beq @1			f0,?1 		; if i = 0, end

	asl a 			0a 			; t = i * 2
	sta @t 			8d,<t,>t
	lda #$00 		a9,00
	rol a 			2a
	sta @t+1 		8d,+t,>t

	clc 			18 			; fd/fe = fd/fe + t
	lda $fd 		a5,fd
	adc @t 			6d,<t,>t
	sta $fd 		85,fd
	lda $fe 		a5,fe
	adc @t+1 		6d,+t,>t
	sta $fe 		85,fe
@1	rts 			60

	; I, Index
	;
@i	00

	; T, Temp
	;
@t  00,00

	; V = (fd/fe)
	;
@b	ldy #$00  		a0,00
	lda ($fd),y 	b1,fd
	sta @v 			8d,<v,>v
	iny 			c8
	lda ($fd),y 	b1,fd
	sta @v+1 		8d,+v,>v
	rts 			60

	; (fd/fe) = V
	;
@c	ldy #$00 		a0,00
	lda @v 			ad,<v,>v
	sta ($fd),y 	91,fd
	iny 			c8
	lda @v+1 		ad,+v,>v
	sta ($fd),y 	91,fd
	rts 			60

	; V, Value
	;	
@v 	0,0

200 data @a,a5,2f,85,fd,a5,30,85,fe
201 data ad,<i,>i,f0,?1
202 data 0a,8d,<t,>t,a9,00,2a,8d,+t,>t
203 data 18,a5,fd,6d,<t,>t,85,fd,a5,fe,6d,+t,>t,85,fe
204 data @1,60
205 data @i,00,@t,00,00
210 data @b,a0,00,b1,fd,8d,<v,>v,c8,b1,fd,8d,+v,>v,60
220 data @c,a0,00,ad,<v,>v,91,fd,c8,ad,+v,>v,91,fd,60
230 data @v,00,00
