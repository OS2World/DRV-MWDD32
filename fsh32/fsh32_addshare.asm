;
; $Header: d:\\32bits\\ext2-os2\\fsh32\\rcs\\fsh32_addshare.asm,v 1.3 1997/03/15 17:52:54 Willm Exp $
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

        extrn FSH_ADDSHARE : far

        public thunk16$fsh32_addshare

thunk16$fsh32_addshare:
        call FSH_ADDSHARE
;        jmp far ptr FLAT:thunk32$fsh32_addshare
        jmp32 thunk32$fsh32_addshare

CODE16 ends

CODE32 segment
ASSUME CS:FLAT, DS:FLAT, ES:FLAT, SS:NOTHING

        public thunk32$fsh32_addshare
        public         fsh32_addshare

;
; int FSH32ENTRY fsh32_addshare(
;                               PTR16           pName,		/* ebp + 8  */
;                               unsigned short  mode,		/* ebp + 12 */
;                               unsigned short  hVPB,		/* ebp + 16 */
;                               unsigned long  *phShare		/* ebp + 20 */
;                              );
;
fsh32_addshare proc near
        enter 4, 0
;
; ebp - 4 : tmphShare (dword)
;
	push es
        push ebx
        sub esp, 12
	mov eax, [ebp + 8]		; pName
	mov [esp + 8], eax
	mov ax, [ebp + 12]		; mode
	mov [esp + 6], ax
        mov ax, [ebp + 16]              ; hVPB
        mov [esp + 4], ax
        mov eax, ss
        mov [esp + 2], ax               ; seg tmphShare
        lea eax, [ebp - 4]
        mov [esp], ax                   ; ofs tmphShare
        jmp far ptr thunk16$fsh32_addshare
thunk32$fsh32_addshare:
        movzx eax, ax
        cmp eax, NO_ERROR
        jnz short @@error
        mov eax, [ebp - 4]
        mov ebx, [ebp + 20]
        mov [ebx], eax
        mov eax, NO_ERROR
@@error:
        pop ebx
	pop es
        leave
        ret
fsh32_addshare endp

CODE32  ends

        end
