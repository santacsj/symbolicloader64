# Symbolic Machine Code Loader for the Commodore 64

Learn C64 machine code the hard way, by programming on paper :). You are the assembler, but this short BASIC program can automate the annoying address calculations for you. Copy and paste the BASIC source to VICE and start practicing!

### Start address and Program Counter
Variable `O` (as origin), in line 12, is used to store the start address and it holds PC value when loading the data.

### Syntax
1. Hex, a single PETSCII character, can only be 0-9 or A-F
2. Label, one single PETSCII character
3. Token, fixed length, two characters
    - `@[label]` save the current address in variable `O` for a label
    - `![label]` recall and store the saved address (a word) in memory 
    - `?[label]` calculate and store a relative address between the current and the address saved stored for label
    - `>[label]` recall and store the saved address' low byte in memory 
    - `<[label]` recall and store the saved address' high byte in memory 
    - `[hex][hex]` stored as a byte in memory
4. `"[token] [token] ... [token]"` a series of tokens, should be separated by a single space character
5. `"END"` marks the end of the data

### Example
```
                * = $c000
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
C000: A2 FF A9 40 20 D2 FF CA D0 FA 4C 00 C0
```
