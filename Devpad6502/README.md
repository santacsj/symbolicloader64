# Devpad 6502

A digital notepad that helps learning machine code programming using the Symbolic Machine Code Loader syntax.

## Features

- Disassembles machine code on the fly to assembly language source code to aid in learning MOS 6502 opcodes
- Counts bytes used to aid optimizing for space
- Keeps track of available and already used symbols
- Outputs formatted BASIC DATA lines for the Symbolic Machine Code Loader, ready to be pasted into VICE
- Saves the edited source code to browser local storage
- Uses [ace.c9.io](https://ace.c9.io/) for the code editor

## Syntax

Syntax is the same as the Symbolic Machine Code Loader, except ...

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
