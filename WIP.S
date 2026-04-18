
$033C–$03FB (828–1019 in decimal)
	
64 symbol entries

0, if not found

3 byte record
	petscii code
	address low byte
	address high byte



@l 	0 		; table length
@k 	0 		; table key
@v	0, 0 	; table value


; fd/fe = table start
;
@a 	ldx $2f 		a6,2f
	ldy $30 		a4,30
	stx $fd 		86,fd
	sty $fe 		84,fe
	rts				60


; fd/fe + a
;
@b 	clc 			18
	adc $fd 		65,fd
	sta $fd 		85,fd
	lda #$00 		a9,00
	adc $fe 		65,fe
	sta $fe 		85,fe
	rts 			60


; clear table
;
@c 	jsr @a 			20,<a,>a
	lda #$00 		a9,00
	sta @l 			8d,<l,>l
	rts 			60


; (fd/fe) = k,v
;
@d	ldy #$00 		a0,00
	lda @k 			ad,<k,>k
	sta ($fd),y 	91,fd
	iny 			c8
	lda @v 			ad,<v,>v
	sta ($fd),y 	91,fd
	iny 			c8
	lda @v+1 		ad,+v,>v
	sta ($fd),y 	91,fd
	rts 			60


; v = (fd/fe)
;
@e	ldy #$01  		a0,01
	lda ($fd),y 	b1,fd
	sta @v 			8d,<v,>v
	iny 			c8
	lda ($fd),y 	b1,fd
	sta @v+1 		8d,+v,>v
	rts 			60


; find k
; C set, if k found, fd/fe points to elem
;
@f 	jsr @a 			20,<a,>a
	ldx #$00 		a2,00
	ldy #$00 		a0,00

@1	cpx @l 			ec,<l,>l
	bne @2 			d0,?2
	clc 			18
	rts 			60

@2	lda ($fd),y 	b1,fd
	cmp @k 			cd,<k,>k
	bne @3 			d0,?3
	sec 			38
	rts 			60

@3	lda #$03 		a9,03
	jsr @b 			20,<b,>b
	inx 			e8 			; ha wrap around van akkor nem talaltuk meg!
	jmp @1 			4c,<1,>1


; set or append k,v
;
@h 	jsr @f 			20,<f,>f
	bcs @5 			b0,?5
	inc @l  		ee,<l,>l
@5	jsr @d 			20,<d,>d
	rts 			60


; get v by k
;
@g 	jsr @f 			20,<f,>f
 	bcc @4 			90,?4
 	jsr @e 			20,<e,>e
 	rts 			60
@4 	lda #$00 		a9,00
	sta @v 			8d,<v,>v
	sta @v+1 		8d,+v,>v
	rts 			60



200 data @a,a6,2f,a4,30,86,fd,84,fe,60
210 data @b,18,65,fd,85,fd,a9,00,65,fe,85,fe,60
220 data @c,20,<a,>a,a9,00,8d,<l,>l,60
230 data @d,a0,00,ad,<k,>k,91,fd
231 data c8,ad,<v,>v,91,fd,c8,ad,+v,>v,91,fd,60
240 data @e,a0,01,b1,fd,8d,<v,>v,c8,b1,fd,8d,+v,>v,60
250 data @f,20,<a,>a,a2,00,a0,00
251 data @1,ec,<l,>l,d0,?2,18,60
252 data @2,b1,fd,cd,<k,>k,d0,?3,38,60
253 data @3,a9,03,20,<b,>b,e8,4c,<1,>1
260 data @h,20,<f,>f,b0,?5,ee,<l,>l,@5,20,<d,>d,60
270 data @g,20,<f,>f,90,?4,20,<e,>e,60,@4,a9,00,8d,<v,>v,8d,+v,>v,60
900 data @l,00,@k,00,@v,00,00
990 data end
