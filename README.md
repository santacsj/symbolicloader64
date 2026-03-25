# Symbolic Machine Code Loader for the Commodore 64

Learn C64 machine code the hard way, by programming on paper :). You do the assembling and this short BASIC program automates the annoying address calculations for you. Copy and paste the BASIC source to VICE and start practicing!

### Addresses
Variable `M` (as memory) holds the address where the program is loaded to.
Variable `O` (as origin), holds the start address for the PC which is used for address calculations. By default `O` equals `M`.

### Syntax
1. Hex, one single PETSCII character, can only be 0-9 or A-F
2. Label, one single PETSCII character
3. Token, fixed length, two characters, can be any of ...
    - `@[label]` save the address of the next byte as 'label'
    - `?[label]` calculate and store a relative address between the current and the saved address
    - `<[label]` recall and store the saved address' low byte
    - `>[label]` recall and store the saved address' high byte
    - `+[label]` recall and store the saved address' low byte + 1
    - `#[label]` recall and store the saved address' low byte + 2
    - `[hex][hex]` stored as a byte
4. `"[token] [token] ... [token]"` a series of tokens, should be separated by one single space
5. `"END"` marks the end of the data

### Example

The following program
```
                *=  $c000
A2 FF       @1  ldx #$ff
A9 40           lda #$40  ; the @ char
20 D2 FF    @2  jsr $ffd2
CA              dex
D0 FA           bne @2
4C 00 C0        jmp @1
```
can be stored in BASIC as
```
DATA @1,A2,FF
DATA A9,40
DATA @2,20,D2,FF
DATA CA
DATA D0,?2
DATA 4C,<1,>1
DATA END
```
which in turn is loaded to memory as
```
C000: A2 FF A9 40 20 D2 FF CA D0 FA 4C 00 C0
```
