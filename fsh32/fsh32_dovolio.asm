;
; $Header: d:\\32bits\\ext2-os2\\fsh32\\rcs\\fsh32_dovolio.asm,v 1.3 1997/03/15 17:52:54 Willm Exp $
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

        extrn FSH_DOVOLIO : far

        public thunk16$fsh32_dovolio_1
        public thunk16$fsh32_dovolio_2
        public thunk16$fsh32_dovolio_3
        public thunk16$fsh32_dovolio_4

thunk16$fsh32_dovolio_1:
        call [DevHelp2]
;        jmp far ptr FLAT:thunk32$fsh32_dovolio_1
        jmp32 thunk32$fsh32_dovolio_1

thunk16$fsh32_dovolio_2:
        call [DevHelp2]
;        jmp far ptr FLAT:thunk32$fsh32_dovolio_2
        jmp32 thunk32$fsh32_dovolio_2

thunk16$fsh32_dovolio_3:
        call FSH_DOVOLIO
;        jmp far ptr FLAT:thunk32$fsh32_dovolio_3
        jmp32 thunk32$fsh32_dovolio_3

thunk16$fsh32_dovolio_4:
        call [DevHelp2]
;        jmp far ptr FLAT:thunk32$fsh32_dovolio_4
        jmp32 thunk32$fsh32_dovolio_4

CODE16 ends

CODE32 segment
ASSUME CS:FLAT, DS:FLAT, ES:FLAT, SS:NOTHING

        public         fsh32_dovolio
        public thunk32$fsh32_dovolio_1
        public thunk32$fsh32_dovolio_2
        public thunk32$fsh32_dovolio_3
        public thunk32$fsh32_dovolio_4

;
; int fsh32_dovolio(
;                   int operation,              /* ebp + 8  */
;                   int fAllowed,               /* ebp + 12 */
;                   int hVPB,                   /* ebp + 16 */
;                   void *pData,                /* ebp + 20 */
;                   unsigned long *pcSec,       /* ebp + 24 */
;                   unsigned long  iSec         /* ebp + 28 */
;                  );
;
fsh32_dovolio proc near
        enter 12, 0
        push es
        push ebx
        push esi
        push edi
;
; ebp - 2 -> sel    (word) used to map pData to 16:16
; ebp - 4 -> *pcSec (word) local copy of *pcSec to get a 16:16 stack based address to it
; ebp - 6 -> rc     (word) used to store return codes
;

	;
	; rc = 0
	;
	mov [ebp - 6], 0


        mov ax, ss
        mov es, ax
        lea edi, [ebp - 2]                      ; &sel in ES:DI
        mov ecx, 1                              ; one selector
        mov dl, DevHlp_AllocGDTSelector
        jmp far ptr thunk16$fsh32_dovolio_1
thunk32$fsh32_dovolio_1:
        jc @@error

        mov ax, [ebp - 2]                       ; sel
        mov ebx, dword ptr [ebp + 20]           ; lin
	mov ecx, [ebp + 24]			; pcSec 
        movzx ecx, word ptr [ecx]                ; *pcSec (nr of sectors)
	mov [ebp - 4], cx
        shl ecx, 9                              ; 512 byte sector
        mov dl, DevHlp_LinToGDTSelector
        jmp far ptr thunk16$fsh32_dovolio_2
thunk32$fsh32_dovolio_2:
        mov [ebp - 6], ax                       ; rc
        jc short @@error_2


        sub esp, 18
        mov eax, [ebp + 8]                      ; operation
        mov [esp + 16], ax
        mov eax, [ebp + 12]                     ; fAllowed
        mov [esp + 14], ax
        mov eax, [ebp + 16]                     ; hVPB
        mov [esp + 12], ax
        mov ax, [ebp - 2]                       ; sel
        shl eax, 16
        mov [esp + 8], eax                      ; pData
        mov ax, ss
        shl eax, 16
        lea ebx, [ebp - 4]
        mov ax, bx
        mov [esp + 4], eax                      ; pcSec
        mov eax, [ebp + 28]
        mov [esp], eax                          ; iSec
        jmp far ptr thunk16$fsh32_dovolio_3
thunk32$fsh32_dovolio_3:
        mov [ebp - 6], ax                       ; rc

@@error_2:
        mov ax, [ebp - 2]
        mov dl, DevHlp_FreeGDTSelector
        jmp far ptr thunk16$fsh32_dovolio_4
thunk32$fsh32_dovolio_4:
        jc @@error

        mov ax, [ebp - 6]                    ; rc
        cmp ax, 0
        jnz @@error

        mov ebx, [ebp - 4]
        movzx ebx, bx
        mov edi, [ebp + 24]                     ;  pcSec
        mov [edi], ebx                          ; *pcSec
@@error:
        movzx eax, ax
        pop edi
        pop esi
        pop ebx
        pop es
        leave
        ret
fsh32_dovolio endp

CODE32  ends

        end
