;
; $Header: d:\\32bits\\ext2-os2\\skeleton\\basedev\\rcs\\drv32_pre_init_base.asm,v 1.3 1997/03/16 12:51:42 Willm Exp $
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

        include devhlp.inc
        include drv32_segdef.inc

reqPacket       struc
reqLenght       db ?
reqUnit         db ?
reqCommand      db ?
reqStatus       dw ?
reqFlags        db ?
                db 3 dup (?)    ; Reserved field
reqLink         dd ?
reqPacket       ends

rpInitIn        struc
i_rph           db size reqPacket dup (?)
i_unit          db ?
i_devHelp       dd ?
i_initArgs      dd ?
i_driveNum      db ?
rpInitIn        ends

DATA32 segment
    extrn  TKSSBase  : dword
    extrn  DevHelp32 : dword
DATA32 ends

CODE16 segment
ASSUME CS:CODE16, DS:NOTHING, ES:FLAT

        public thunk16$drv32_pre_init_base_1
        public thunk16$drv32_pre_init_base_2

thunk16$drv32_pre_init_base_1:
        call dword ptr [ebp - 24]
        jmp far ptr FLAT:thunk32$drv32_pre_init_base_1

ASSUME CS:CODE16, DS:FLAT, ES:FLAT

thunk16$drv32_pre_init_base_2:
        call dword ptr [ebp - 6]
        jmp far ptr FLAT:thunk32$drv32_pre_init_base_2

CODE16 ends

CODE32 segment
ASSUME CS:FLAT, DS:FLAT, ES:FLAT

        public thunk32$drv32_pre_init_base_1
        public thunk32$drv32_pre_init_base_2
        public         drv32_pre_init_base

;
; int DH32ENTRY drv32_pre_init_base(
;                                   PTR16 reqpkt      /* ebp + 8 */
;                                  );
;
drv32_pre_init_base proc near
        enter 24,0
;
;ebp - 24 (4 bytes) DevHelp
;ebp - 20 (8 bytes) "mwdd32$ "
;ebp - 12 (12 bytes) ddtable
;

        push es
        push ebx
        push esi
        push edi

        ;
        ; Saves the DevHelp entry point
        ;
        push es
        les bx, dword ptr[ebp + 8]   ; es:bx points to the INIT request packet
        movzx ebx, bx
        mov ebx, es:[ebx].i_devHelp  ; Device Helper entry point
        mov [ebp - 24], ebx          ; saved into DevHelp2
        pop es


        ;
        ; Try to attach to MWDD32.SYS
        ;
        mov eax, ss
        mov ds, eax
        lea ebx, [ebp - 20]             ; offset ddname
        lea edi, [ebp - 12]             ; offset ddtable
	mov dl, DevHlp_AttachDD
        mov [ebp - 20], dword ptr 'ddwm'
        mov [ebp - 16], dword ptr ' $23'
        jmp far ptr thunk16$drv32_pre_init_base_1
thunk32$drv32_pre_init_base_1:
        mov ecx, es
        mov ds, ecx
        jc short @@error

        ;
        ; Calls MWDD32.SYS to get 32 bits helper entry points
        ;
        push offset FLAT:TKSSBase
        push offset FLAT:DevHelp32
	push dword ptr 1		; function
	push dword ptr 061153275h	; magic
	push dword ptr 0		; zero to recognize non V1.00 request
        jmp far ptr thunk16$drv32_pre_init_base_2
thunk32$drv32_pre_init_base_2:
	add esp, 20
@@error:
        movzx eax, ax
        pop edi
        pop esi
        pop ebx
        pop es
        leave
        ret
drv32_pre_init_base endp

CODE32 ends

        end
