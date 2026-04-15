
	; get BASIC variables
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

	; READ into variable S$
	;
	lda #$ff 		a9,ff
 	sta $0d 		85,0d

 	lda #<s 		a9,<s
 	sta $49 		85,49
 	lda #>s 		a9,>s
 	sta $4a 		85,4a

200 data a9,00,a2,c0,8d,+2,>2,8e,+3,>3
202 data a9,4f,a2,00,20,<d,>d,8d,<o,>o,8e,+o,>o
204 data 8d,+2,>2,8e,+3,>3
206 data a9,4d,a2,00,20,<d,>d,8d,<m,>m,8e,+m,>m
208 data a9,ff,85,0d,a9,<s,85,49,a9,>s,85,4a

	; Pass 1
	;
	jsr @h 			20,<h,>h 	; pc = O
	jsr @a81d 		20,1d,a8 	; RESTORE

@5	jsr @g 			20,<g,>g 	; READ S$

	ldy #$00 		a0,00
	lda ($4b),y 	b1,4b

	cmp #$3b 		c9,3b 		; end of pass?
	beq @7 			f0,?7

	cmp #$40 		c9,40 		; symbol?
	beq @6 			f0,?6

	jsr @j 			20,<j,>j 	; pc++

	jmp @5 			4c,<5,>5

@6 	iny 			c8 			; store pc to symbol table
	lda ($4b),y 	b1,4b
	
	sta @i 			8d,<i,>i 	; i = asc(symbol)

	lda @p  		ad,<p,>p 	; v = pc
	sta @v 			8d,<v,>v
	lda @p+1 		ad,+p,>p
	sta @v+1 		8d,+v,>v

	jsr @a 			20,<a,>a	; fd/fe = symbol table address for i
	
	ldy #$00 		a0,00 		; (fd/fe) = V
	lda @v 			ad,<v,>v
	sta ($fd),y 	91,fd
	iny 			c8
	lda @v+1 		ad,+v,>v
	sta ($fd),y 	91,fd
	
	jmp @5 			4c,<5,>5

220 data 20,<h,>h,20,1d,a8
222 data @5,20,<g,>g,a0,00,b1,4b,c9,3b,f0,?7,c9,40,f0,?6,20,<j,>j,4c,<5,>5
224 data @6,c8,b1,4b,8d,<i,>i,ad,<p,>p,8d,<v,>v,ad,+p,>p,8d,+v,>v
226 data 20,<a,>a,a0,00,ad,<v,>v,91,fd,c8,ad,+v,>v,91,fd
228 data 4c,<5,>5

	; Pass 2
	;
@7	lda @m 			ad,<m,>m 	; $fb/fc = m
	sta $fb 		85,fb
	lda @m 			ad,+m,>m
	sta $fc 		85,fc

 	jsr @h 			20,<h,>h 	; pc = O

	jsr @a81d 		20,1d,a8 	; RESTORE

@8	jsr @g 			20,<g,>g 	; READ S$

	ldy #$00 		a0,00
	lda ($4b),y 	b1,4b
	jsr $ffd2 		20,d2,ff
	iny 			c8
	lda ($4b),y 	b1,4b
	jsr $ffd2 		20,d2,ff
	lda #$20 		a9,20
	jsr $ffd2 		20,d2,ff
	jsr $ffd2 		20,d2,ff

	ldy #$00 		a0,00
	lda ($4b),y 	b1,4b

	cmp #$3b 		c9,3b 		; end of pass?
	bne @9 			d0,?9
	
	rts 			60 			; return to BASIC

@9	cmp #$40 		c9,40 		; @
	beq @8 			f0,?8

	cmp #$3f 		c9,3f 		; ?
	bne @0 			d0,?0

	jmp @$ 			4c,<$,>$

@0	cmp #$3e 		c9,3e 		; >
	bne @/ 			d0,?/

	jmp @( 			4c,<(,>(

@/	cmp #$3c 		c9,3c 		; <
	bne @. 			d0,?.

	ldx #$00 		a2,00 		; of = 0
	stx @x 			8e,<x,>x

	jmp @' 			4c,<',>'

@.	cmp #$2b 		c9,2b 		; +
	bne @- 			d0,?-

	ldx #$01 		a2,01 		; of = 1
	stx @x 			8e,<x,>x

	jmp @' 			4c,<',>'

@-	cmp #$23 		c9,23 		; #
	bne @+ 			d0,?+

	ldx #$02 		a2,02 		; of = 2
	stx @x 			8e,<x,>x

	jmp @' 			4c,<',>'

230 data @7,ad,<m,>m,85,fb,ad,+m,>m,85,fc,20,<h,>h,20,1d,a8
232 data @8,20,<g,>g
233 data a0,00,b1,4b,20,d2,ff,c8,b1,4b,20,d2,ff,a9,20,20,d2,ff,20,d2,ff
234 data a0,00,b1,4b,c9,3b,d0,?9,60
236 data @9,c9,40,f0,?8,c9,3f,d0,?0,4c,<$,>$
238 data @0,c9,3e,d0,?/,4c,<(,>(
240 data @/,c9,3c,d0,?.,a2,00,8e,<x,>x,4c,<',>'
242 data @.,c9,2b,d0,?-,a2,01,8e,<x,>x,4c,<',>'
244 data @-,c9,23,d0,?+,a2,02,8e,<x,>x,4c,<',>'

	; 2 char hex str to byte
	;
@+	ldy #$01 		a0,01
	lda ($4b),y 	b1,4b
	jsr @e 			20,<e,>e

	sta $02			85,02		; unused zero-page byte as temp

	dey 			88
	lda ($4b),y 	b1,4b
	jsr @e 			20,<e,>e

	asl a 			0a
	asl a 			0a
	asl a 			0a
	asl a 			0a

 	clc 			18
	adc $02 		65,02

@&	ldy #$00 		a0,00
	sta ($fb),y 	91,fb 		; store by to m

	jsr @j 			20,<j,>j 	; pc++

	inc $fb 		e6,fb 		; m++
	bne @% 			d0,?%
	inc $fc 		e6,fc

@% 	jmp @8 			4c,<8,>8

	; hex digit to byte
	; in:
	; 	ar - asc of hex digit
	; out:
	; 	ar - byte
	;
@e	sec 			38
	sbc #$30 		e9,30
	cmp #$0a 		c9,0a
	bcc @* 			90,?*
	sbc #$07 		e9,07
@* 	rts 			60

260 data @+,a0,01,b1,4b,20,<e,>e
264 data 85,02,88,b1,4b,20,<e,>e
268 data 0a,0a,0a,0a,18,65,02
270 data @&,a0,00,91,fb,20,<j,>j,e6,fb,d0,?%,e6,fc
272 data @%,4c,<8,>8
274 data @e,38,e9,30,c9,0a,90,?*,e9,07,@*,60

	; ? - relative address
	;	
@$	ldy #$01 		a0,01
	lda ($4b),y 	b1,4b
	
	sta @i 			8d,<i,>i 	; v = symbol(i)
	jsr @a 			20,<a,>a
	jsr @b 			20,<b,>b

	sec   			38 			; v = v - pc
	lda @v 			ad,<v,>v
	sbc @p 			ed,<p,>p
	sta @v 			8d,<v,>v
	lda @v+1 		ad,+v,>v
	sbc @p+1 		ed,+p,>p
	sta @v+1 		8d,+v,>v

	sec 			38 			; v = v - 1
	lda @v 			ad,<v,>v
	sbc #$01 		e9,01
	sta @v 			8d,<v,>v
	bcs @# 			b0,?#
	dec @v+1 		ce,+v,>v

@# 	lda @v 			ad,<v,>v 	; v < -128, overflow error if N = 1
	cmp #$80		c9,80
	lda @v+1 		ad,+v,>v
	sbc #$ff 		e9,ff
	bvc @= 			50,?=
	eor #$80 		49,80

@= 	bpl @! 			10,?!

	ldx #$0f  		a2,0f 		; ?OVERFLOW ERROR
 	jmp $a437 		4c,37,a4

@! 	lda @v 			ad,<v,>v 	; v >= 128, overflow error if N = 0
	cmp #$80		c9,80
	lda @v+1 		ad,+v,>v
	sbc #$00 		e9,00
	bvc @: 			50,?<
	eor #$80 		49,80

@< 	bmi @; 			30,?;

	ldx #$0f  		a2,0f 		; ?OVERFLOW ERROR
 	jmp $a437 		4c,37,a4

@;  lda @v 			ad,<v,>v

	jmp @& 			4c,<&,>&

280 data @$,a0,01,b1,4b,8d,<i,>i,20,<a,>a,20,<b,>b
282 data 38,ad,<v,>v,ed,<p,>p,8d,<v,>v,ad,+v,>v,ed,+p,>p,8d,+v,>v
284 data 38,ad,<v,>v,e9,01,8d,<v,>v,b0,?#,ce,+v,>v
286 data @#,ad,<v,>v,c9,80,ad,+v,>v,e9,ff,50,?=,49,80
288 data @=,10,?!,a2,0f,4c,37,a4
290 data @!,ad,<v,>v,c9,80,ad,+v,>v,e9,00,50,?<,49,80
292 data @<,30,?;,a2,0f,4c,37,a4
294 data @;,ad,<v,>v,4c,<&,>&

	; > - high byte
	;	
@(	ldy #$01 		a0,01
	lda ($4b),y 	b1,4b

	sta @i 			8d,<i,>i 	; v = symbol(i)
	jsr @a 			20,<a,>a
	jsr @b 			20,<b,>b

	lda @v+1		ad,+v,>v

	jmp @& 			4c,<&,>&

300 data @(,a0,01,b1,4b,8d,<i,>i,20,<a,>a,20,<b,>b,ad,+v,>v,4c,<&,>&

	; <,+,# - low byte
	;
@'	ldy #$01 		a0,01
	lda ($4b),y 	b1,4b

	sta @i 			8d,<i,>i 	; v = symbol(i)
	jsr @a 			20,<a,>a
	jsr @b 			20,<b,>b

	clc 			18
	lda @v 			ad,<v,>v
	adc @x 			6d,<x,>x

	jmp @& 			4c,<&,>& 	

322 data @',a0,01,b1,4b,8d,<i,>i,20,<a,>a,20,<b,>b
324 data 18,ad,<v,>v,6d,<x,>x,4c,<&,>&

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

332 data @h,ad,<o,>o,8d,<p,>p,ad,+o,>o,8d,+p,>p,60
334 data @j,ee,<p,>p,d0,?4,ee,+p,>p,@4,60

	; READ S$
	;
	; out:
	; 	$4b/4c - points to S$ data
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

344 data @g,a9,98,85,11
346 data a5,7a,85,4b,a5,7b,85,4c
348 data a5,41,85,7a,a5,42,85,7b
350 data 20,2c,ac,ad,+s,>s,85,4b,ad,#s,>s,85,4c,60

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

372 data @d,a0,00,85,45,86,46,a5,2d,a6,2e,20,ef,b0,20,a2,bb
374 data a5,61,f0,?2,20,9b,bc,a5,65,a6,64,60,@2,a9,00,@3,a2,c0,60

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

	; V = (fd/fe)
	;
@b	ldy #$00  		a0,00
	lda ($fd),y 	b1,fd
	sta @v 			8d,<v,>v
	iny 			c8
	lda ($fd),y 	b1,fd
	sta @v+1 		8d,+v,>v
	rts 			60

380 data @a,a5,2f,85,fd,a5,30,85,fe
382 data ad,<i,>i,f0,?1
384 data 0a,8d,<t,>t,a9,00,2a,8d,+t,>t
386 data 18,a5,fd,6d,<t,>t,85,fd,a5,fe,6d,+t,>t,85,fe
388 data @1,60
392 data @b,a0,00,b1,fd,8d,<v,>v,c8,b1,fd,8d,+v,>v,60

	; S$
	;
@s 	00,00,00

	; I, Index
	;
@i	00

	; T, Temp
	;
@t  00,00

	; V, Value
	;	
@v 	00,00

	; PC
	;
@p 	00,00

	; X, Offset
	;
@x 	00

	; O, Origin
	;
@o 	00,00

	; M, Memory
	;
@m 	00,00

400 data @s,00,00,00
402 data @i,00
404 data @t,00,00
406 data @v,00,00
408 data @p,00,00
410 data @x,00
412 data @o,00,00
414 data @m,00,00
