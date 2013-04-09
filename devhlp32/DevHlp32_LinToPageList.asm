;
; $Header: d:\\32bits\\ext2-os2\\devhlp32\\rcs\\DevHlp32_LinToPageList.asm,v 1.3 1997/03/15 16:38:23 Willm Exp $
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

        public thunk16$DevHlp32_LinToPageList

thunk16$DevHlp32_LinToPageList:
        call [DevHelp2]
;        jmp far ptr FLAT:thunk32$DevHlp32_LinToPageList
        jmp32 thunk32$DevHlp32_LinToPageList

CODE16 ends

CODE32 segment
ASSUME CS:FLAT, DS:FLAT, ES:FLAT, SS:NOTHING

        public thunk32$DevHlp32_LinToPageList
        public         DevHlp32_LinToPageList

;
; int DH32ENTRY DevHlp32_LinToPageList(
;                                void            *lin,         /* ebp + 8  */
;                                unsigned long    size,        /* ebp + 12 */
;                                struct PageList *pages        /* ebp + 16 */
;                                unsigned long   *nr_pages,    /* ebp + 20 */
;                               );
;
DevHlp32_LinToPageList proc near
        push ebp
        mov  ebp, esp
        push ebx
        push edi

        mov   eax, [ebp + 8]                 ; lin
        mov   ecx, [ebp + 12]                ; size
        mov   edi, [ebp + 16]                ; Flags
        mov   edx, DevHlp_LinToPageList
        jmp far ptr thunk16$DevHlp32_LinToPageList
thunk32$DevHlp32_LinToPageList:
        jc short @@error

        mov   ebx, [ebp + 20]                ; LinAddr
	cmp ebx, 0
	jz short @@out
        mov   [ebx], eax
@@out:
        mov   eax, NO_ERROR
@@error:
        pop edi
        pop ebx
        leave
        ret
DevHlp32_LinToPageList endp

CODE32  ends

        end
