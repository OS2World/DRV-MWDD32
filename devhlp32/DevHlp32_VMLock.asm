;
; $Header: d:\\32bits\\ext2-os2\\devhlp32\\rcs\\DevHlp32_VMLock.asm,v 1.3 1997/03/15 16:38:23 Willm Exp $
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

        public thunk16$DevHlp32_VMLock

thunk16$DevHlp32_VMLock:
        call [DevHelp2]
;        jmp far ptr FLAT:thunk32$DevHlp32_VMLock
        jmp32 thunk32$DevHlp32_VMLock

CODE16 ends

CODE32 segment
ASSUME CS:FLAT, DS:FLAT, ES:FLAT, SS:NOTHING

        public thunk32$DevHlp32_VMLock
        public         DevHlp32_VMLock

;
; int DH32ENTRY DevHlp32_VMLock(
;                    unsigned long flags,                 [ebp + 8]
;                    unsigned long lin,                   [ebp + 12]
;                    unsigned long length,                [ebp + 16]
;                    void          *pPageList,            [ebp + 20]
;                    void          *pLockHandle,          [ebp + 24]
;                    unsigned long *pPageListCount        [ebp + 28]
;                   );
;
DevHlp32_VMLock proc near
        push ebp
        mov  ebp, esp
        push ebx
        push esi
        push edi

        mov ebx, [ebp + 12]        ; lin
        mov ecx, [ebp + 16]        ; length
        mov edi, [ebp + 20]        ; pPageList    (FLAT)
        mov esi, [ebp + 24]        ; pLockHandle  (FLAT)
        mov eax, [ebp + 8]         ; flags
        mov dl, DevHlp_VMLock
        jmp far ptr thunk16$DevHlp32_VMLock
thunk32$DevHlp32_VMLock:
        jc short @@error           ; if error, EAX = error code
        mov edi, [ebp + 28]        ; pPageListCount
        mov [edi], eax             ;*pPageListCount
        mov eax, NO_ERROR
@@error:
        pop edi
        pop esi
        pop ebx
        leave
        ret
DevHlp32_VMLock endp

CODE32  ends

        end
