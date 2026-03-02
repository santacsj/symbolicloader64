# Symbolic Machine Code Loader for the Commodore 64

Learn C64 assembly the hard way, by programming on paper :). You are the assembler, but this short BASIC program can automate the annoying address calculations for you.

### Tokens
- @ + a single PETSCII character, saves the current address stored in variable `O`
- ! + a single PETSCII character, recall and store the saved address (as a word) in memory 
- ? + a single PETSCII character, calculate and store a relative address between current and the stored address
- any other two character token is stored as a HEX byte
- "END" should be the last DATA line

### Example
```
A2 FF       @1  ldx #$ff
A9 40           lda #$40  ; the @ char
20 D2 FF    @2  jsr $ffd2
CA              dex
D0 FA           bne @2
4C 00 C0        jmp @1
```
can be stored in BASIC as
```
DATA "@1 A2 FF"
DATA "A9 40"
DATA "@2 20 D2 FF"
DATA "CA"
DATA "D0 ?2"
DATA "4C !1"
DATA "END"
```
which in turn is loaded to memory as
```
c000: a2 ff a9 40 20 d2 ff ca d0 fa 4c 00 c0
```
