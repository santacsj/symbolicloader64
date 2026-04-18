# Symbolic Machine Code Loader for the Commodore 64

Learn C64 machine code the hard way, by programming on paper :). You do the assembling and this short BASIC program automates the annoying address calculations for you. Copy and paste the BASIC source to VICE and start practicing!

A machine language version is also available. For details, see below.

## BASIC Version

### Addresses
Variable `O` (as origin) sets the address for the PC which is used for address calculations. Variable `M` (as memory) sets the address where the program is actually loaded to in memory.

### Syntax
1. `;` marks the end of data
2. `hex`, a single PETSCII character, can only be 0-9 or A-F
3. `label`, a single PETSCII character
4. `token`, fixed two characters, can be any of ...
    - `[hex][hex]` stored as a byte
    - `@[label]` save the address of the next byte under 'label'
    - `?[label]` calculate and store a relative address between the current and the saved address
    - `>[label]` recall and store the saved address' high byte
    - `<[label]` recall and store the saved address' low byte
    - `+[label]` recall and store the saved address' low byte + 1
    - `#[label]` recall and store the saved address' low byte + 2
5. `[token],[token], ... ,[token],;` a series of tokens should be separated by comma and the last token should be followed by a `;`

### Usage
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
DATA ;
```
which in turn is loaded to memory as
```
C000: A2 FF A9 40 20 D2 FF CA D0 FA 4C 00 C0
```

## ML Version

### Memory
The code is stored on pages $CE-CF. Another 512 bytes are used for symbols, starting at the BASIC array variable area (ARYTAB).

### Usage
```
10 O=49152
15 M=49152
20 SYS 52777
30 DATA @1,A2,FF
40 DATA A9,40
50 DATA @2,20,D2,FF
60 DATA CA
70 DATA D0,?2
80 DATA 4C,<1,>1
90 DATA ;
```

### Addresses
Setting `O` and `M` is optional. Variable `O` (origin), if not set, defaults to `49152`. Variable `M` (memory), if not set, defaults to the value of `O`.
