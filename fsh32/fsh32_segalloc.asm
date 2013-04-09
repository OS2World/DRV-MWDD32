;
; $Header: d:\\32bits\\ext2-os2\\fsh32\\rcs\\fsh32_segalloc.asm,v 1.3 1997/03/15 17:52:54 Willm Exp $
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

	extrn FSH_SEGALLOC : far

        public thunk16$fsh32_segalloc

thunk16$fsh32_segalloc:
        call FSH_SEGALLOC
;        jmp far ptr FLAT:thunk32$fsh32_segalloc
        jmp32 thunk32$fsh32_segalloc

CODE16 ends

CODE32 segment
ASSUME CS:FLAT, DS:FLAT, ES:FLAT, SS:NOTHING

        public thunk32$fsh32_segalloc
        public         fsh32_segalloc

;
; int FSH32ENTRY fsh32_segalloc(
;                               int flags,		/* ebp + 8  */
;                               int length,		/* ebp + 12 */
;                               unsigned short *pSel	/* ebp + 16 */
;                              );
;
fsh32_segalloc proc near
	enter 4, 0
	push es
	push ebx

	sub esp, 10
	lea eax, [ebp - 4]
	mov [esp], ax
	mov eax, ss
	mov [esp + 2], ax
	mov eax, [ebp + 12]
	mov [esp + 4], eax
	mov ax, [ebp + 8]
	mov [esp + 8], ax	
        jmp far ptr thunk16$fsh32_segalloc
thunk32$fsh32_segalloc:
	movzx eax, ax
	cmp eax, NO_ERROR
	jnz @@error
	mov ax, [ebp - 4]
	mov ebx, [ebp + 16]
	mov [ebx], ax
	mov eax, NO_ERROR
@@error:
	pop ebx
	pop es
	leave
        ret
fsh32_segalloc endp

CODE32  ends

        end
