# Devpad 6502

A digital notepad to help learning machine code programming using the Symbolic Machine Code Loader syntax.

## Features

- Disassembles machine code to assembly language source code on the fly to aid in learning MOS 6502 opcodes
- Counts used bytes to aid space optimization
- Keeps track of available and already used symbols
- Output formatted BASIC DATA lines in Symbolic Machine Code Loader syntax (just copy and paste it into VICE)
- Saves the edited source code to browser local storage
- Uses [ace.c9.io](https://ace.c9.io/) for the code editor (Thanks, guys!)

## Syntax

The syntax is the same as with the Symbolic Machine Code Loader, except ...

- `;` is used for comments in Devpad 6502
- `; .byte` a special comment to denote the line as byte input (and be formatted as such)

## Example

Copy and paste the following into the editor:
```
; Print 'ABC'
;
a9,<s,a0,>s,20,1e,ab ; print zero terminated string
60

@s,41,42,43,00 ;.byte
```
... or for a longer example, see `SELF.S`.
