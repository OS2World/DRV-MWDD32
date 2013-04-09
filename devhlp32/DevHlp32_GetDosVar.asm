;
; $Header: d:\\32bits\\ext2-os2\\devhlp32\\rcs\\DevHlp32_GetDosVar.asm,v 1.4 1997/03/15 16:38:23 Willm Exp $
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

        public thunk16$DevHlp32_GetDosVar

thunk16$DevHlp32_GetDosVar:
        call [DevHelp2]
;        jmp far ptr FLAT:thunk32$DevHlp32_GetDosVar
        jmp32 thunk32$DevHlp32_GetDosVar

CODE16 ends

CODE32 segment
ASSUME CS:FLAT, DS:FLAT, ES:FLAT, SS:NOTHING

        public thunk32$DevHlp32_GetDosVar
        public         DevHlp32_GetDosVar

;
; int DH32ENTRY DevHlp32_GetDosVar(
;                                  int     index,      /* ebp + 8  */
;                                  PTR16  *value,      /* ebp + 12 */
;                                  int     member      /* ebp + 16 */
;                                 );
;
DevHlp32_GetDosVar proc near
        enter 0, 0
	push ebx
	push esi
	push edi

	mov eax, [ebp + 8]			; index
	mov ecx, [ebp + 16]			; member
        mov dl, DevHlp_GetDOSVar
        jmp far ptr thunk16$DevHlp32_GetDosVar
thunk32$DevHlp32_GetDosVar:
        jc short @@error           		; if error, EAX = error code
	mov edi, [ebp + 12]
	mov [edi], bx 		                ; value (ofs)
	mov [edi + 2], ax 		        ; value (seg)
        mov eax, NO_ERROR
@@error:
	pop edi
	pop esi
	pop ebx
        leave
        ret
DevHlp32_GetDosVar endp

CODE32  ends

        end
