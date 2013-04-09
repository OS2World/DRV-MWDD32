;
; $Header: d:\\32bits\\ext2-os2\\util\\rcs\\sec32_attach_ses.asm,v 1.2 1997/03/16 13:21:33 Willm Exp $
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
        include os2.inc

        include devhlp.inc
        include segdef.inc
        include r0thunk.inc

_SecHlpUISEPList   struc

   Offset_QuerySubjectHandle        dd    1 dup (?)
   Offset_QuerySubjectInfo          dd    1 dup (?)
   Offset_QueryContextStatus        dd    1 dup (?)
   Offset_QuerySecurityContext      dd    1 dup (?)
   Offset_QuerySubjectHandleInfo    dd    1 dup (?)
   Offset_SetSubjectHandle          dd    1 dup (?)
   Offset_SetSecurityContext        dd    1 dup (?)
   Offset_SetContextStatus          dd    1 dup (?)
   Offset_ResetThreadContext        dd    1 dup (?)
   Offset_QueryAuthID               dd    1 dup (?)
   Offset_SetAuthID                 dd    1 dup (?)
   Offset_ReserveHandle             dd    1 dup (?)
   Offset_ReleaseHandle             dd    1 dup (?)
   Offset_SetChildSecurityContext   dd    1 dup (?)

_SecHlpUISEPList ends


CODE16 segment
ASSUME CS:CODE16, DS:FLAT

        public thunk16$sec32_attach_ses_1
        public thunk16$sec32_attach_ses_2

thunk16$sec32_attach_ses_1:
        call es:[DevHelp2]
        jmp far ptr FLAT:thunk32$sec32_attach_ses_1


thunk16$sec32_attach_ses_2:
        call dword ptr [ebp - 6]
        jmp far ptr FLAT:thunk32$sec32_attach_ses_2

CODE16 ends

CODE32 segment
ASSUME CS:FLAT, DS:FLAT, ES:FLAT

        public thunk32$sec32_attach_ses_1
        public thunk32$sec32_attach_ses_2
        public         sec32_attach_ses

;
; int DH32ENTRY sec32_attach_ses(void *SecHlp);
;
sec32_attach_ses proc near
        enter 20 + size _SecHlpUISEPList ,0
;
;ebp - 20 - size _SecHlpUISEPList tmp SecHlp
;ebp - 20 (8 bytes) "sesdd32$"
;ebp - 12 (12 bytes) ddtable
;

        push ds
        push es
        push ebx
        push esi
        push edi

        ;
        ; Try to attach to sesdd32.sys
        ;
        mov eax, ss
        mov ds, eax
        lea ebx, [ebp - 20]             ; offset ddname
        lea edi, [ebp - 12]             ; offset ddtable
        mov dl, DevHlp_AttachDD
        mov [ebp - 20], dword ptr 'DSES'
        mov [ebp - 16], dword ptr '$23D'
        jmp far ptr thunk16$sec32_attach_ses_1
thunk32$sec32_attach_ses_1:
        mov ecx, es
        mov ds, ecx
        jc short @@error

        ;
        ; Calls SEDDD32.SYS to get SecHlp entry points
        ;
        mov eax, ss
        mov ds, eax
        lea esi, [ebp - 20 - size _SecHlpUISEPList]
        push esi
        jmp far ptr thunk16$sec32_attach_ses_2
thunk32$sec32_attach_ses_2:
        add esp, 4

        ;
        ; Copy returned entry points from stack to SecHelp
        ;
        mov edi, [ebp + 8]
        mov ecx, size _SecHlpUISEPList / 4
        cld
        rep movsd

        mov eax, NO_ERROR
@@error:
        movzx eax, ax
        pop edi
        pop esi
        pop ebx
        pop es
        pop ds
        leave
        ret
sec32_attach_ses endp

CODE32 ends

        end
