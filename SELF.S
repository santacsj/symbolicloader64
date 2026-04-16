
	; get BASIC variables
	; 	O defaults to C000, if not set
	; 	$fb/fc defaults to O, if not set
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
	sta $fb 		85,fb
	stx $fc 		86,fc

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
206 data a9,4d,a2,00,20,<d,>d,85,fb,86,fc
208 data a9,ff,85,0d,a9,<s,85,49,a9,>s,85,4a

	; Pass 1
	;
	jsr @h 			20,<h,>h 	; PC = O
	jsr @a81d 		20,1d,a8 	; RESTORE

@5	jsr @g 			20,<g,>g 	; READ S$

	ldy #$00 		a0,00
	lda ($4b),y 	b1,4b

	cmp #$3b 		c9,3b 		; end of pass?
	beq @7 			f0,?7

	cmp #$40 		c9,40 		; symbol?
	beq @6 			f0,?6

	inc $f9			e6,f9 		; PC++
	bne @5 			d0,?5
	inc $fa			e6,fa
	beq @5 			f0,?5

@6 	iny 			c8 			; store PC to symbol table
	lda ($4b),y 	b1,4b
	
	tax 			aa 		 	; I = asc(symbol)

	jsr @a 			20,<a,>a	; fd/fe = symbol table address for I
	
	dey 			88  		; (fd/fe) = PC
	lda $f9 		a5,f9
	sta ($fd),y 	91,fd
	iny 			c8
	lda $fa 		a5,fa
	sta ($fd),y 	91,fd
	
	jmp @5 			4c,<5,>5

220 data 20,<h,>h,20,1d,a8
222 data @5,20,<g,>g,a0,00,b1,4b,c9,3b,f0,?7,c9,40,f0,?6
223 data e6,f9,d0,?5,e6,fa,f0,?5
224 data @6,c8,b1,4b,aa
226 data 20,<a,>a,88,a5,f9,91,fd,c8,a5,fa,91,fd
228 data 4c,<5,>5

	; Pass 2
	;
@7 	jsr @h 			20,<h,>h 	; PC = O

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

@/	ldx #$00 		a2,00 		; OF = 0
	stx $02			86,02

	cmp #$3c 		c9,3c 		; <
	bne @. 			d0,?.

	jmp @' 			4c,<',>'

@.	inc $02			e6,02

	cmp #$2b 		c9,2b 		; +
	bne @- 			d0,?-

	jmp @' 			4c,<',>'

@- 	inc $02			e6,02

	cmp #$23 		c9,23 		; #
	bne @+ 			d0,?+

	jmp @' 			4c,<',>'

230 data @7,20,<h,>h,20,1d,a8
232 data @8,20,<g,>g
233 data a0,00,b1,4b,20,d2,ff,c8,b1,4b,20,d2,ff,a9,20,20,d2,ff,20,d2,ff
234 data a0,00,b1,4b,c9,3b,d0,?9,60
236 data @9,c9,40,f0,?8,c9,3f,d0,?0,4c,<$,>$
238 data @0,c9,3e,d0,?/,4c,<(,>(
240 data @/,a2,00,86,02,c9,3c,d0,?.,4c,<',>'
244 data @.,e6,02,c9,2b,d0,?-,4c,<',>'
246 data @-,e6,02,c9,23,d0,?+,4c,<',>'

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

	inc $f9			e6,f9 		; PC++
	bne @4 			d0,?4
	inc $fa			e6,fa

@4	inc $fb 		e6,fb 		; M++
	bne @% 			d0,?%
	inc $fc 		e6,fc

@% 	jmp @8 			4c,<8,>8

	; hex digit to byte
	;
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
270 data @&,a0,00,91,fb,e6,f9,d0,?4,e6,fa
271 data @4,e6,fb,d0,?%,e6,fc
272 data @%,4c,<8,>8
274 data @e,38,e9,30,c9,0a,90,?*,e9,07,@*,60

	; ? - relative address
	;	
@$	ldy #$01 		a0,01
	lda ($4b),y 	b1,4b
	
	jsr @f 			20,<f,>f 	; V = symbol(I)

	sec   			38 			; V = V - PC
	lda $f7			a5,f7
	sbc $f9			e5,f9
	sta $f7			85,f7
	lda $f8			a5,f8
	sbc $fa			e5,fa
	sta $f8			85,f8

	sec 			38 			; V = V - 1
	lda $f7			a5,f7
	sbc #$01 		e9,01
	sta $f7			85,f7
	bcs @# 			b0,?#
	dec $f8 		c6,f8

@# 	lda $f7			a5,f7 		; V < -128, overflow error, if N = 1
	cmp #$80		c9,80
	lda $f8			a5,f8
	sbc #$ff 		e9,ff
	bvc @= 			50,?=
	eor #$80 		49,80

@= 	bpl @! 			10,?!

	ldx #$0f  		a2,0f 		; ?OVERFLOW ERROR
 	jmp $a437 		4c,37,a4

@! 	lda $f7			a5,f7 		; V >= 128, overflow error, if N = 0
	cmp #$80		c9,80
	lda $f8			a5,f8
	sbc #$00 		e9,00
	bvc @: 			50,?<
	eor #$80 		49,80

@< 	bmi @; 			30,?;

	ldx #$0f  		a2,0f 		; ?OVERFLOW ERROR
 	jmp $a437 		4c,37,a4

@;  lda $f7			a5,f7

	jmp @& 			4c,<&,>&

280 data @$,a0,01,b1,4b,20,<f,>f
282 data 38,a5,f7,e5,f9,85,f7,a5,f8,e5,fa,85,f8
284 data 38,a5,f7,e9,01,85,f7,b0,?#,c6,f8
286 data @#,a5,f7,c9,80,a5,f8,e9,ff,50,?=,49,80
288 data @=,10,?!,a2,0f,4c,37,a4
290 data @!,a5,f7,c9,80,a5,f8,e9,00,50,?<,49,80
292 data @<,30,?;,a2,0f,4c,37,a4
294 data @;,a5,f7,4c,<&,>&

	; > - high byte
	;	
@(	ldy #$01 		a0,01
	lda ($4b),y 	b1,4b
	jsr @f 			20,<f,>f 	; V = symbol(I)
	lda $f8			a5,f8

	jmp @& 			4c,<&,>&

300 data @(,a0,01,b1,4b,20,<f,>f,a5,f8,4c,<&,>&

	; <,+,# - low byte
	;
@'	ldy #$01 		a0,01
	lda ($4b),y 	b1,4b
	jsr @f 			20,<f,>f 	; V = symbol(I)

	clc 			18
	lda $f7			a5,f7
	adc $02			65,02

	jmp @& 			4c,<&,>& 	

322 data @',a0,01,b1,4b,20,<f,>f
324 data 18,a5,f7,65,02,4c,<&,>&

	; PC = O
	;
@h	lda @o  		ad,<o,>o
	sta $f9			85,f9
	lda @o+1 		ad,+o,>o
	sta $fa			85,fa
	rts 			60

332 data @h,ad,<o,>o,85,f9,ad,+o,>o,85,fa,60

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

	; $f7/f8 = symbol(i)
	;
	: in:
	;	xr - index
	; out:
	; 	$f7/f8 - symbol value
	;
@f	tax 			aa
	jsr @a 			20,<a,>a

	ldy #$00  		a0,00 		; $f7/f8 = (fd/fe)
	lda ($fd),y 	b1,fd
	sta $f7			85,f7
	iny 			c8
	lda ($fd),y 	b1,fd
	sta $f8			85,f8
	
	rts

	; fd/fe = address of I-th word in ARYTAB
	;
	; in:
	; 	xr - index
	;	
@a 	lda $2f 		a5,2f 		; fd/fe = 2f/30, ARYTAB
	sta $fd 		85,fd
	lda $30 		a5,30
	sta $fe 		85,fe

	txa 			8a
	beq @1			f0,?1 		; if I = 0, end

	asl a 			0a 			; T = I * 2
	sta $bb			85,bb
	lda #$00 		a9,00
	rol a 			2a
	sta $bc			85,bc

	clc 			18 			; fd/fe = fd/fe + T
	lda $fd 		a5,fd
	adc $bb			65,bb
	sta $fd 		85,fd
	lda $fe 		a5,fe
	adc $bc			65,bc
	sta $fe 		85,fe
@1	rts 			60

380 data @f,aa,20,<a,>a
382 data a0,00,b1,fd,85,f7,c8,b1,fd,85,f8,60
384 data @a,a5,2f,85,fd,a5,30,85,fe
386 data 8a,f0,?1
388 data 0a,85,bb,a9,00,2a,85,bc
390 data 18,a5,fd,65,bb,85,fd,a5,fe,65,bc,85,fe
392 data @1,60

	; S$
	;
@s 	00,00,00

	; O, Origin
	;
@o 	00,00

400 data @s,00,00,00
412 data @o,00,00
