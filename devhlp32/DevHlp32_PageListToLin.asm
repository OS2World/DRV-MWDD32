;
; $Header: d:\\32bits\\ext2-os2\\devhlp32\\rcs\\DevHlp32_PageListToLin.asm,v 1.3 1997/03/15 16:38:23 Willm Exp $
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

        public thunk16$DevHlp32_PageListToLin

thunk16$DevHlp32_PageListToLin:
        call [DevHelp2]
;        jmp far ptr FLAT:thunk32$DevHlp32_PageListToLin
        jmp32 thunk32$DevHlp32_PageListToLin

CODE16 ends

CODE32 segment
ASSUME CS:FLAT, DS:FLAT, ES:FLAT, SS:NOTHING

        public thunk32$DevHlp32_PageListToLin
        public         DevHlp32_PageListToLin

;
; int DH32ENTRY DevHlp32_PageListToLin(
;                                      unsigned long     size,        /* ebp + 8 */
;                                      struct PageList  *pPageList,   /* ebp + 12 */
;                                      void            **pLin         /* ebp + 16 */
;                                     );
;
DevHlp32_PageListToLin proc near
	enter 0, 0
        push edi
	push ebx

        mov   ecx, [ebp + 8]                 ; size
        mov   edi, [ebp + 12]                ; pPageList
        mov   dl, DevHlp_PageListToLin
        jmp far ptr thunk16$DevHlp32_PageListToLin
thunk32$DevHlp32_PageListToLin:
        jc short @@error

        mov   ebx, [ebp + 16]                ; pLin
	cmp ebx, 0
	jz short @@out
        mov   [ebx], eax
        mov   eax, NO_ERROR
@@error:
        pop ebx
        pop edi
        leave
        ret

@@out:
	mov eax, ERROR_INVALID_PARAMETER
	jmp short @@error
DevHlp32_PageListToLin endp

CODE32  ends

        end
