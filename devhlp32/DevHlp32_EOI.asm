;
; $Header: d:\\32bits\\ext2-os2\\devhlp32\\rcs\\DevHlp32_EOI.asm,v 1.3 1997/03/15 16:38:23 Willm Exp $
;

; 32 bits OS/2 device driver and IFS support. Provides 32 bits kernel 
; services (DevHelp) and utility functions to 32 bits OS/2 ring 0 code 
; (device drivers and installable file system drivers).
; Copyright (C) 1995, 1996, 1997  Matthieu WILLM (willm@ibm.net)
;
; This program is free software; you can redistribute it and/or modify
; it under the terms of the GNU General Public License as published by
; the Free Software Foundation; either version 2 of the License, or
; (at your option) any later version.
;
; This program is distributed in the hope that it will be useful,
; but WITHOUT ANY WARRANTY; without even the implied warranty of
; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
; GNU General Public License for more details.
;
; You should have received a copy of the GNU General Public License
; along with this program; if not, write to the Free Software
; Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.

        .386p

        INCL_DOSERRORS equ 1
        include bseerr.inc
        include devhlp.inc
        include segdef.inc
        include r0thunk.inc

CODE16 segment
        ASSUME CS:CODE16, DS:FLAT

        public thunk16$DevHlp32_EOI

thunk16$DevHlp32_EOI:
        call [DevHelp2]
;        jmp far ptr FLAT:thunk32$DevHlp32_EOI
        jmp32 thunk32$DevHlp32_EOI

CODE16 ends

CODE32 segment
ASSUME CS:FLAT, DS:FLAT, ES:FLAT, SS:NOTHING

        public thunk32$DevHlp32_EOI
        public         DevHlp32_EOI

;
; int DH32ENTRY2 DevHlp32_EOI(
;		              unsigned short interrupt_level,	/* ax */
;                            );
;
DevHlp32_EOI proc near
        mov   dl, DevHlp_EOI
        jmp far ptr thunk16$DevHlp32_EOI
thunk32$DevHlp32_EOI:
	xor eax, eax
        ret
DevHlp32_EOI endp

CODE32  ends

        end
