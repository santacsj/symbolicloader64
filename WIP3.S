
todo
	
	- use $fb/fc for M (memory pointer)

	- use $02 instead of @i
	
	- inline?
		@c 	; (fd/fe) = V



	; 2 char hex str at $4b/4c to byte
	;
	; in:
	; 	$4b/4c - address of 2 char hex string
	; 	$fb/fc - result address
	; out:
	; 	byte at ($fb/fc)
	;
	ldy #$01 		a0,01
	lda ($4b),y 	b1,4b

	sec 			38
	sbc #$30 		e9,30
	cmp #$0a 		c9,0a
	bcc @1 			90,?1
	sbc #$07 		e9,07

@1	sta $02			85,02	; unused zero-page byte as temp

	dey 			88
	lda ($4b),y 	b1,4b

	sec 			38
	sbc #$30 		e9,30
	cmp #$0a 		c9,0a
	bcc @1 			90,?2
	sbc #$07 		e9,07

@2	asl a 			0a
	asl a 			0a
	asl a 			0a
	asl a 			0a

 	clc 			18
	adc $02 		65,02

	sta ($fb),y 	91,fb 	; ide kell majd ugrani, es utana pc++,m++ majd read s$

	rts 			60


200 data a0,01,b1,4b
201 data 38,e9,30,c9,0a,90,?1,e9,07
202 data @1,85,02
203 data 88,b1,4b
204 data 38,e9,30,c9,0a,90,?2,e9,07
205 data @2,0a,0a,0a,0a,18,65,02,91,fb,60
206 data ;




	; END with OVERFLOW ERROR
	;
 	ldx #$0f  		a2,0f
 	jmp $a437 		4c,37,a4




https://calc.penjee.com/

ff80 = -128, ergo ff7f vagy kevesebb akkor out of range, ff81 az -127 az ok

007f =  127, ergo 0080 vagy tobb  akkor out of range, 007e az 126 az jo

also byte-ot eleg vizsgalni es N flag kivonas utan

also byte-ok kell csak hasznalni, az mar kettes komplemensben van a kivonas utan


https://6502.org/tutorials/
https://6502.org/tutorials/compare_instructions.html
https://6502.org/tutorials/compare_beyond.html

16 bit signed comparison

N = 0, if a >= b
N = 1, if a < b


	; ha a < -128 (N = 1) akkor ?OVERFLOW ERROR
	;
@a 	80,ff 	; -128

	lda @a 		ad,<a,>a
	cmp #$80	c9,80
	lda @a+1 	ad,+a,>a
	sbc #$ff 	e9,ff
	bvc ?1 		50,?1
	eor #$80 	49,80
@1 	rts 		60


	; ha a >= 128 (N = 0) akkor ?OVERFLOW ERROR
	;
@a 	7f,00 	; 127

	lda @a 		ad,<a,>a
	cmp #$80	c9,80
	lda @a+1 	ad,+a,>a
	sbc #$00 	e9,00
	bvc ?1 		50,?1
	eor #$80 	49,80
@1 	rts 		60



	; ? - relative address
	;	
	ldy #$01 		a0,01
	lda ($4b),y 	b1,4b

	; v = symbol(i)
	sta @i 			8d,<i,>i
	jsr @a 			20,<a,>a
	jsr @b 			20,<b,>b

	; v = v - pc
	sec   			38
	lda @v 			ad,<v,>v
	sbc @p 			ed,<p,>p
	sta @v 			8d,<v,>v
	lda @v+1 		ad,+v,>v
	sbc @p+1 		ed,+p,>p
	sta @v+1 		8d,+v,>v

	; v = v - 1
	dec @v 			ce,<v,>v
	bne @8 			d0,?8
	dec @v+1 		ce,+v,>v

	; v < -128, overflow error if N = 1
@8 	lda @v 			ad,<v,>v
	cmp #$80		c9,80
	lda @v+1 		ad,+v,>v
	sbc #$ff 		e9,ff
	bvc ?9 			50,?9
	eor #$80 		49,80

@9 	bpl @0 			10,?0

	ldx #$0f  		a2,0f
 	jmp $a437 		4c,37,a4

 	; v >= 128, overflow error if N = 0
@0 	lda @v 			ad,<v,>v
	cmp #$80		c9,80
	lda @v+1 		ad,+v,>v
	sbc #$00 		e9,00
	bvc @/ 			50,?/
	eor #$80 		49,80

@/ 	bmi @. 			30,?.

	ldx #$0f  		a2,0f
 	jmp $a437 		4c,37,a4

@.  lda @v 			ad,<v,>v

	; jmp to insert by and inc pointers



	; > - high byte
	;	
	ldy #$01 		a0,01
	lda ($4b),y 	b1,4b

	; v = symbol(i)
	sta @i 			8d,<i,>i
	jsr @a 			20,<a,>a
	jsr @b 			20,<b,>b

	lda @v+1		ad,+v,>v

	; jmp to insert by and inc pointers



	; <,+,# - low byte
	;
	; in:
	; 	@x - offset
	;	
	ldy #$01 		a0,01
	lda ($4b),y 	b1,4b

	; v = symbol(i)
	sta @i 			8d,<i,>i
	jsr @a 			20,<a,>a
	jsr @b 			20,<b,>b

	lda @v 			ad,<v,>v
	adc @x 			6d,<x,>x

	; jmp to insert by and inc pointers
	
	; X, Offset
	;
@x 	00



