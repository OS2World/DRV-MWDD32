;
; $Header: D:/32bits/ext2-os2/fsh32/rcs/fs_init.asm,v 1.4 1997/03/15 17:52:54 Willm Exp Willm $
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

        INCL_DOS        equ 1
        INCL_DOSERRORS  equ 1
        include os2.inc
        include devhlp.inc

        include segdef.inc
        include r0thunk.inc
        include fsd.inc
        include mwdd32_ioctl.inc


DATA32 segment
;        public TKSSBase
        extrn DevHelp32 : dword
        extrn TKSSBase : dword

;        TKSSBase dd (?)
DATA32 ends

CODE16 segment
        assume CS:CODE16

        public FS_INIT

        extrn DOS16OPEN       : far
        extrn DOS16DEVIOCTL   : far
        extrn DOS16CLOSE      : far
        extrn DOS16PUTMESSAGE : far

        FileName db "mwdd32$", 0



;
;int far pascal FS_INIT(
;                       char far * cmdline,
;                       unsigned long DevHelp,
;                       unsigned long far * pMiniFSD
;                      );
;
FS_INIT proc far
        enter 24, 0
        push si
        push di
        ;
        ; bp + 14 -> cmdline
        ; bp + 10 -> DevHelp
        ; bp + 6  -> pMiniFSD
        ; bp + 2  -> FS_INIT
        ; bp      ->  old bp
        ; bp - 2  -> FileHandle
        ; bp - 4  -> ActionTaken
        ; bp - 8  -> IOCTL parm (4 bytes)  : union mwdd32_ioctl_int_fsd_parm
        ; bp - 24 -> IOCTL data (16 bytes) : union mwdd32_ioctl_int_fsd_data

        ;
        ; Opens mwdd32$
        ;
        push seg CODE16                 ; seg  FileName
        push offset CODE16:FileName     ; ofs  FileName
        push ss                         ; seg &FileHandle
        lea ax, [bp - 2]
        push ax                         ; ofs &FileHandle
        push ss                         ; seg &ActionTaken
        lea ax, [bp - 4]
        push ax                         ; ofs &ActionTaken
        push dword ptr 0                ; file size
        push 0                          ; file attributes
        push OPEN_ACTION_FAIL_IF_NEW + OPEN_ACTION_OPEN_IF_EXISTS
        push OPEN_SHARE_DENYNONE + OPEN_ACCESS_READONLY
        push dword ptr 0                ; reserved
        call DOS16OPEN
        cmp ax, NO_ERROR
        jnz short fs_init_out


;APIRET  APIENTRY DosDevIOCtl2(PVOID pData, USHORT cbData, PVOID pParm,
;                             USHORT cbParm, USHORT usFun, USHORT usCategory,
;                             HFILE hDev);

        lea si, [bp - 8]                ; parm
        lea di, [bp - 24]               ; data
        mov dword ptr [bp - 8].magic, INIT_FSD_MAGIC_IN                ; parm->input.magic_in
        mov dword ptr [bp - 24].fs32_init_ptr , offset FLAT:fs32_init      ; data->input.fs32_init
        lea ax, [bp + 6]
        mov [bp - 24].fs32_init_parms_ofs , ax   ; data->input.fs32_init_parms (ofs)
        mov ax, ss
        mov [bp - 24].fs32_init_parms_seg , ax   ; data->input.fs32_init_parms (seg)
        mov dword ptr [bp - 24].pTKSSBase, offset FLAT:TKSSBase
        mov dword ptr [bp - 24].pDevHelp32, offset FLAT:DevHelp32
        push ss                         ; seg pData
        push di                         ; ofs pData
;        push word ptr 8                        ; cbData
        push ss                         ; seg pParm
        push si                         ; ofs pParm
;       push word ptr 4                 ; cbParm
        push word ptr 041h              ; func
        push word ptr 0f0h              ; cat
        push word ptr [bp - 2]          ; FileHandle
        call DOS16DEVIOCTL
        cmp ax, NO_ERROR
        jnz short fs_init_out


        ;
        ; Closes mwdd32$
        ;
        push word ptr [bp - 2]                   ; FileHandle
        call DOS16CLOSE
        cmp ax, NO_ERROR
        jnz short fs_init_out


        ;
        ; Tests magic number in answer from mwdd32.sys
        ;
        cmp dword ptr [bp - 8].magic, INIT_FSD_MAGIC_OUT
        jne       not_ok

        ;
        ; Retrieves fs32_init's return code from mwdd32.sys answer
        ;
        mov ax, word ptr [bp - 24].fs32_init_rc     ; rc from fs32_init
        jmp short fs_init_out

not_ok:
        mov ax, ERROR_INVALID_PARAMETER

fs_init_out:
        pop di
        pop si
        leave
        retf 12
FS_INIT endp
CODE16 ends


        end
