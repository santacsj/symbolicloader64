

	jsr @e 			20,<e,>e 	; set O and M

	jsr @f 			20,<f,>f 	; use S$ as a string variable

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
	jsr @c 			20,<c,>c 	; (fd/fe) = v
	
	jmp @5 			4c,<5,>5


	; Pass 2
	;
@7 	jsr @h 			20,<h,>h 	; pc = O
	jsr @a81d 		20,1d,a8 	; RESTORE

@8	jsr @g 			20,<g,>g 	; READ S$

	ldy #$00 		a0,00
	lda ($4b),y 	b1,4b

	cmp #$3b 		c9,3b 		; end of pass?
	bne @9 			d0,?9

	ldx #$80  		a2,80 		; END
 	jmp $a437 		4c,37,a4

@9	cmp #$40 		c9,40 		; @
	beq @8 			f0,?8

	cmp #$3f 		c9,3f 		; ?
	bne @0 			d0,?0

	jmp ;

@0	cmp #$3e 		c9,3e 		; >
	bne @/ 			d0,?/

	jmp ;

@/	cmp #$3c 		c9,3c 		; <
	bne @. 			d0,?.

	ldx #$00 		a2,00 		; of = 0
	stx @x 			8e,<x,>x

	jmp ;

@.	cmp #$2b 		c9,2b 		; +
	bne @- 			d0,?-

	ldx #$01 		a2,00 		; of = 1
	stx @x 			8e,<x,>x

	jmp ;

@-	cmp #$23 		c9,23 		; #
	bne @+ 			d0,?+

	ldx #$02 		a2,00 		; of = 2
	stx @x 			8e,<x,>x

	jmp ;


	; 2 char hex str to byte
	;
@+	ldy #$01 		a0,01
	lda ($4b),y 	b1,4b

	sec 			38
	sbc #$30 		e9,30
	cmp #$0a 		c9,0a
	bcc @* 			90,?*
	sbc #$07 		e9,07

@*	sta $02			85,02		; unused zero-page byte as temp

	dey 			88
	lda ($4b),y 	b1,4b

	sec 			38
	sbc #$30 		e9,30
	cmp #$0a 		c9,0a
	bcc @) 			90,?)
	sbc #$07 		e9,07

@)	asl a 			0a
	asl a 			0a
	asl a 			0a
	asl a 			0a

 	clc 			18
	adc $02 		65,02

@&	sta ($fb),y 	91,fb 		; store by to m

	jsr @j 			20,<j,>j 	; pc++

	inc @m 			ee,<m,>m 	; m++
	bne @% 			d0,?%
	inc @m+1 		ee,+m,>m

@% 	jmp @8 			4c,<8,>8

