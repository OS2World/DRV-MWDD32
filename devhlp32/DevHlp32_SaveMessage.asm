;
; $Header: d:\\32bits\\ext2-os2\\devhlp32\\rcs\\DevHlp32_SaveMessage.asm,v 1.3 1997/03/15 16:38:23 Willm Exp $
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
        ASSUME CS:CODE16, DS:FLAT, ES:FLAT

        public thunk16$DevHlp32_SaveMessage_1
        public thunk16$DevHlp32_SaveMessage_2
        public thunk16$DevHlp32_SaveMessage_3
        public thunk16$DevHlp32_SaveMessage_4

thunk16$DevHlp32_SaveMessage_1:
        call [DevHelp2]
;        jmp far ptr FLAT:thunk32$DevHlp32_SaveMessage_1
        jmp32 thunk32$DevHlp32_SaveMessage_1

thunk16$DevHlp32_SaveMessage_2:
        call [DevHelp2]
;        jmp far ptr FLAT:thunk32$DevHlp32_SaveMessage_2
        jmp32 thunk32$DevHlp32_SaveMessage_2

thunk16$DevHlp32_SaveMessage_3:
        call es:[DevHelp2]
;        jmp far ptr FLAT:thunk32$DevHlp32_SaveMessage_3
        jmp32 thunk32$DevHlp32_SaveMessage_3

thunk16$DevHlp32_SaveMessage_4:
        call [DevHelp2]
;        jmp far ptr FLAT:thunk32$DevHlp32_SaveMessage_4
        jmp32 thunk32$DevHlp32_SaveMessage_4

CODE16 ends


DATA16 segment
	public begin_msg
begin_msg label byte
	msgid   dw 1178
	nr      dw 1
	msg_ofs dw 0
	msg_seg dw ?

DATA16 ends

CODE32 segment
ASSUME CS:FLAT, DS:FLAT, ES:FLAT, SS:NOTHING

        public         DevHlp32_SaveMessage
        public thunk32$DevHlp32_SaveMessage_1
        public thunk32$DevHlp32_SaveMessage_2
        public thunk32$DevHlp32_SaveMessage_3
        public thunk32$DevHlp32_SaveMessage_4

;
; int DH32ENTRY DevHlp32_SaveMessage(
;                                    char *msg,         /* ebp + 8  */
;                                    int   len          /* ebp + 12 */
;                                   );
;
DevHlp32_SaveMessage proc near
        enter 10, 0
	push ds
        push es
        push ebx
        push esi
        push edi
;
; ebp - 4  -> msg16  (dword)
; ebp - 6  -> nr     (word)
; ebp - 8  -> msgid  (word)
; ebp - 10 -> rc     (word)
;

        ;
        ; rc = 0
        ;
        mov word ptr [ebp - 10], 0

        mov ax, seg DATA16
        mov es, ax
	ASSUME ES:DATA16
        mov di, offset DATA16:msg_seg
        mov ecx, 1                              ; one selector
        mov dl, DevHlp_AllocGDTSelector
        jmp far ptr thunk16$DevHlp32_SaveMessage_1
thunk32$DevHlp32_SaveMessage_1:
        jc @@error

        mov ax, es:msg_seg                      ; sel
        mov ebx, [ebp + 8]                      ; msg
        mov ecx, [ebp + 12]                     ; len
        mov dl, DevHlp_LinToGDTSelector
        jmp far ptr thunk16$DevHlp32_SaveMessage_2
thunk32$DevHlp32_SaveMessage_2:
        mov [ebp - 10], ax                       ; rc
        jc short @@error_2

	mov ax, es				 ; DATA16
	mov bx, ds				 ; FLAT
	mov ds, ax
	mov es, bx
	ASSUME DS:DATA16, ES:FLAT
        mov si, offset DATA16:msgid
        xor bx, bx
        mov dl, DevHlp_Save_Message
        jmp far ptr thunk16$DevHlp32_SaveMessage_3
thunk32$DevHlp32_SaveMessage_3:
        jc @@error_2
        mov [ebp - 10], ax                       ; rc

@@error_2:
        mov ax, msg_seg
	push es
	pop ds					 ; FLAT
	ASSUME DS:FLAT, ES:FLAT
        mov dl, DevHlp_FreeGDTSelector
        jmp far ptr thunk16$DevHlp32_SaveMessage_4
thunk32$DevHlp32_SaveMessage_4:
        jc @@error

        mov ax, [ebp - 10]                    ; rc
        cmp ax, 0
        jnz @@error

@@error:
        movzx eax, ax
        pop edi
        pop esi
        pop ebx
        pop es
	pop ds
        leave
        ret
DevHlp32_SaveMessage endp

CODE32  ends

        end
