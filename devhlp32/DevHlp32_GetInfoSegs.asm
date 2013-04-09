;
; $Header: d:\\32bits\\ext2-os2\\devhlp32\\rcs\\DevHlp32_GetInfoSegs.asm,v 1.3 1997/03/15 16:38:23 Willm Exp $
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

SAS_SIG   equ      "SAS "

SAS struc
    SAS_signature db 4 dup (?)
    SAS_tables_data dw ?            ; offset to tables section
    SAS_flat_sel    dw ?            ; FLAT selector for kernel data
    SAS_config_data dw ?            ; offset to configuration section
    SAS_dd_data     dw ?            ; offset to device driver section
    SAS_vm_data     dw ?            ; offset to Virtual Memory section
    SAS_task_data   dw ?            ; offset to Tasking section
    SAS_RAS_data    dw ?            ; offset to RAS section
    SAS_file_data   dw ?            ; offset to File System section
    SAS_info_data   dw ?            ; offset to infoseg section
SAS ends

;/* Information Segment section */
SAS_info_section struc
    SAS_info_global  dw ?           ; selector for global info seg
    SAS_info_local   dd ?           ; address of curtask local infoseg
    SAS_info_localRM dd ?           ; address of DOS task's infoseg
    SAS_info_CDIB    dw ?           ; selector for Codepage Data Information Block (CDIB)
SAS_info_section ends

        extrn SAS_SEL : abs

CODE16 segment
        ASSUME CS:CODE16, DS:FLAT

        public thunk16$DevHlp32_GetInfoSegs_1
        public thunk16$DevHlp32_GetInfoSegs_2

thunk16$DevHlp32_GetInfoSegs_1:
        call [DevHelp2]
;        jmp far ptr FLAT:thunk32$DevHlp32_GetInfoSegs_1
        jmp32 thunk32$DevHlp32_GetInfoSegs_1

thunk16$DevHlp32_GetInfoSegs_2:
        call [DevHelp2]
        jmp32 thunk32$DevHlp32_GetInfoSegs_2
;        jmp far ptr FLAT:thunk32$DevHlp32_GetInfoSegs_2

CODE16 ends

CODE32 segment
ASSUME CS:FLAT, DS:FLAT, ES:FLAT, SS:NOTHING

        public DevHlp32_GetInfoSegs

        public thunk32$DevHlp32_GetInfoSegs_1
        public thunk32$DevHlp32_GetInfoSegs_2

;
; int DH32ENTRY DevHlp32_GetInfoSegs(
;                    struct InfoSeg_LDT **ppLocInfoSeg,   [ebp + 8]
;                    struct InfoSeg_GDT **ppSysInfoSeg    [ebp + 12]
;                   );
;
DevHlp32_GetInfoSegs proc near
        push ebp
        mov  ebp, esp
        push es
        push ebx
        push esi
        push edi

        mov esi, [ebp + 8]
        mov edi, [ebp + 8]

        mov eax, SAS_SEL
        mov es, eax
        xor ebx, ebx
        movzx ebx, word ptr es:[ebx].SAS_info_data
        movzx eax, word ptr es:[ebx].SAS_info_global
        xor esi, esi
        mov edx, DevHlp_VirtToLin
        jmp far ptr thunk16$DevHlp32_GetInfoSegs_1
thunk32$DevHlp32_GetInfoSegs_1:
        jc short @@error
        mov ecx, [ebp + 8]
        mov [ecx], eax

        movzx esi, word ptr es:[ebx].SAS_info_local
        movzx eax, word ptr es:[ebx + 2].SAS_info_local
        mov edx, DevHlp_VirtToLin
        jmp far ptr thunk16$DevHlp32_GetInfoSegs_2
thunk32$DevHlp32_GetInfoSegs_2:
        jc short @@error
        mov ecx, [ebp + 12]
        mov [ecx], eax


        mov eax, NO_ERROR
@@error:
        pop edi
        pop esi
        pop ebx
        pop es
        leave
        ret
DevHlp32_GetInfoSegs endp

CODE32  ends

        end
