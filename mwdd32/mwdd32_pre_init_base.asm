;
; $Header: d:\\32bits\\ext2-os2\\mwdd32\\rcs\\mwdd32_pre_init_base.asm,v 1.2 1997/03/16 12:44:29 Willm Exp $
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
;        include devcmd.inc
;        include devsym.inc
        include segdef.inc
	include r0thunk.inc

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

DosTable2 struc
        d2_ErrMap24                     dd ?
        d2_MsgMap24                     dd ?
        d2_Err_Table_24                 dd ?
        d2_CDSAddr                      dd ?
        d2_GDT_RDR1                     dd ?
        d2_InterruptLevel               dd ?
        d2__cInDos                      dd ?
        d2_zero_1                       dd ?
        d2_zero_2                       dd ?
        d2_FlatCS                       dd ?
        d2_FlatDS                       dd ?
        d2__TKSSBase                    dd ?
        d2_intSwitchStack               dd ?
        d2_privateStack                 dd ?
        d2_PhysDiskTablePtr             dd ?
        d2_forceEMHandler               dd ?
        d2_ReserveVM                    dd ?
        d2_pgpPageDir                   dd ?
        d2_unknown                      dd ?
DosTable2 ends

DATA32 segment
        extrn TKSSBase        : dword
DATA32 ends

CODE16 segment
ASSUME CS:CODE16, DS:FLAT

	public thunk16$mwdd32_pre_init_base

thunk16$mwdd32_pre_init_base:
        call dword ptr [DevHelp2]
        jmp far ptr FLAT:thunk32$mwdd32_pre_init_base

CODE16 ends

CODE32 segment
ASSUME CS:FLAT, DS:FLAT, ES:FLAT

        public thunk32$mwdd32_pre_init_base
        public         mwdd32_pre_init_base

;
; int mwdd32_pre_init_base(
;                          PTR16 reqpkt      /* ebp + 8 */
;                         );
;
mwdd32_pre_init_base proc near
        push ebp
        mov ebp, esp
        push es
        push ebx
        push esi
        push edi

        ;
        ; Saves the DevHelp entry point
        ;
        les bx, dword ptr[ebp + 8]   ; es:bx points to the INIT request packet
        movzx ebx, bx
        mov ebx, es:[ebx].i_devHelp  ; Device Helper entry point
        mov DevHelp2, ebx            ; saved into DevHelp2

        ;
        ; Gets the TKSSBase pointer from DosTable. TKSSBase is used by
        ; __StackToFlat() to convert a stack based address to a FLAT address
        ; without the overhead of DevHlp_VirtToLin
        ;
        ; DosTable is obtained through GetDOSVar with undocumented index 9
        ; The layout is :
        ;     byte      count of following dword (n)
        ;     dword 1   -+
        ;       .        |
        ;       .        | this is DosTable1
        ;       .        |
        ;     dword n   -+
        ;     byte      count of following dword (p)
        ;     dword 1   -+
        ;       .        |
        ;       .        | this is DosTable2
        ;       .        |
        ;     dword p   -+
        ;
        ; Flat CS  is dword number 10 in DosTable2
        ; Flat DS  is dword number 11 in DosTable2
        ; TKSSBase is dword number 12 in DosTable2
        ;
        mov eax, 9                       ; undocumented DosVar : DosTable pointer
        xor ecx, ecx
        mov edx, DevHlp_GetDOSVar
        jmp far ptr thunk16$mwdd32_pre_init_base ; ax:bx points to DosTable
thunk32$mwdd32_pre_init_base:
        jc short mwdd32_pre_init_base_err
        mov es, ax                       ; es:bx points to DosTable
        movzx ebx, bx
        movzx ecx, byte ptr es:[ebx]     ; count of dword in DosTable1
        mov eax, es:[ebx + 4 * ecx + 2].d2__TKSSBase
        mov TKSSBase, eax

        mov eax, NO_ERROR
mwdd32_pre_init_base_err:
        pop edi
        pop esi
        pop ebx
        pop es
        leave
        ret
mwdd32_pre_init_base endp

CODE32 ends



	end
