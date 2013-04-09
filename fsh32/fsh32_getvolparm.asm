;
; $Header: d:\\32bits\\ext2-os2\\fsh32\\rcs\\fsh32_getvolparm.asm,v 1.3 1997/03/15 17:52:54 Willm Exp $
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

        extrn FSH_GETVOLPARM : far

        public thunk16$fsh32_getvolparm

thunk16$fsh32_getvolparm:
        call FSH_GETVOLPARM
;        jmp far ptr FLAT:thunk32$fsh32_getvolparm
        jmp32 thunk32$fsh32_getvolparm

CODE16 ends

CODE32 segment
ASSUME CS:FLAT, DS:FLAT, ES:FLAT, SS:NOTHING

        public thunk32$fsh32_getvolparm
        public         fsh32_getvolparm

;
; int FSH32ENTRY fsh32_getvolparm(
;                                 int hVPB,           /* ebp + 8  */
;                                 PTR16 *ppvpfsi,     /* ebp + 12 */
;                                 PTR16 *ppvpfsd      /* ebp + 16 */
;                                );
;
fsh32_getvolparm proc near
        enter 8, 0
;
; ebp - 4 -> tmpvpfsi
; ebp - 8 -> tmpvpfsd
;

	push es
        push ebx
        sub esp, 10
        mov ax, [ebp + 8]               ; hVPB
        mov [esp + 8], ax
        mov ax, ss
        mov [esp + 6], ax               ; seg tmpvpfsi
        mov [esp + 2], ax               ; seg tmpvpfsd
        lea eax, [ebp - 8]
        mov [esp], ax                   ; ofs tmpvpfsd
        lea eax, [ebp - 4]
        mov [esp + 4], ax               ; ofs tmpvpfsi
        jmp far ptr thunk16$fsh32_getvolparm
thunk32$fsh32_getvolparm:
        movzx eax, ax
        cmp eax, NO_ERROR
        jnz short @@error
        mov eax, [ebp - 8]
        mov ebx, [ebp + 16]
        mov [ebx], eax
        mov eax, [ebp - 4]
        mov ebx, [ebp + 12]
        mov [ebx], eax
        mov eax, NO_ERROR
@@error:
        pop ebx
	pop es
        leave
        ret
fsh32_getvolparm endp

	public __getvolume

__getvolume proc near
	assume ES:NOTHING	; ALP bug ...
	enter 0, 0
	push es
	push ebx
	les bx, [ebp + 8]	
	mov eax, es:[bx]	; sb
	pop ebx
	pop es
	leave
	ret
__getvolume endp

CODE32  ends

        end
