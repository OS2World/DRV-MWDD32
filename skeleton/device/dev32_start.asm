;
; $Header: d:\\32bits\\ext2-os2\\skeleton\\device\\rcs\\dev32_start.asm,v 1.4 1997/03/16 13:07:14 Willm Exp $
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
        include devcmd.inc
        include devsym.inc

        include dev32_segdef.inc
        include mwdd32_ioctl.inc


; Definition of the request packet header.

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


DATA16 segment
                extrn data16_end : byte
		public device_header

;*********************************************************************************************
;************************* Device Driver Header **********************************************
;*********************************************************************************************
device_header   dd -1                           ; Pointer to next driver
                dw 1100100110000000b            ; Device attributes
;                  ||||| +-+   ||||
;                  ||||| | |   |||+------------------ STDIN
;                  ||||| | |   ||+------------------- STDOUT
;                  ||||| | |   |+-------------------- NULL
;                  ||||| | |   +--------------------- CLOCK
;                  ||||| | |
;                  ||||| | +------------------------+ (001) OS/2
;                  ||||| |                          | (010) DosDevIOCtl2 + SHUTDOWN
;                  ||||| +--------------------------+ (011) Capability bit strip
;                  |||||
;                  ||||+----------------------------- OPEN/CLOSE (char) or Removable (blk)
;                  |||+------------------------------ Sharing support
;                  ||+------------------------------- IBM
;                  |+-------------------------------- IDC entry point
;                  +--------------------------------- char/block device driver

                dw offset CODE16:dev32_stub_strategy; Strategy routine entry point
                dw offset CODE16:dev32_stub_IDC     ; IDC routine entry point
                db 'dev32$  '                   ; Device name
                db 8 dup (0)                    ; Reserved
                dw 0000000000010011b            ; Level 3 device driver capabilities
;                             |||||
;                             ||||+------------------ DosDevIOCtl2 + Shutdown
;                             |||+------------------- More than 16 MB support
;                             ||+-------------------- Parallel port driver
;                             |+--------------------- Adapter device driver
;                             +---------------------- InitComplete
                dw 0000000000000000b
DATA16 ends

CODE16 segment
        assume cs:CODE16, ds:DATA16

        extrn code16_end : byte

        public dev32_stub_strategy
        public dev32_stub_IDC

        extrn DOS16OPEN       : far
        extrn DOS16DEVIOCTL   : far
        extrn DOS16CLOSE      : far

dev32_stub_strategy proc far
;	int 3
        push es                                 ; seg reqpkt
        push bx                                 ; ofs reqpkt
        movzx eax, byte ptr es:[bx].reqCommand
        cmp eax, 0
        jz short @@init
        push eax                                ; command
        mov word ptr es:[bx].reqStatus, 0       ; updates the request status
        call far ptr FLAT:DEV32_STRATEGY        ; 32 bits strategy entry point
        mov word ptr es:[bx].reqStatus, ax      ; updates the request status
        retf

@@init:
        ;
        ; DEVICE= initialization
        ;
	call device_init
        mov word ptr es:[bx].reqStatus, ax
	test ax, STERR
	jnz short init_err
        retf
init_err:
	mov dword ptr es:[bx].i_devHelp, 0
	retf

dev32_stub_strategy endp

        FileName db "mwdd32$", 0

device_init proc near
	enter 24, 0
	push ds
	push es
	push bx
	push si
	push di

        ; bp      ->  old bp
        ; bp - 2  -> FileHandle
        ; bp - 4  -> ActionTaken
        ; bp - 8  -> IOCTL parm (4 bytes)  : union mwdd32_ioctl_init_device_parm
        ; bp - 24 -> IOCTL data (16 bytes) : union mwdd32_ioctl_init_device_data


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
        jnz short @@error

	;
	; Calls IOCTL cat F0 func 42
	;
        lea si, [bp - 8]                ; parm
        lea di, [bp - 24]               ; data
        mov dword ptr [bp - 8].b_magic, INIT_DEVICE_MAGIC_IN                   ; parm->input.magic_in
        mov dword ptr [bp - 24].b_device_init_ptr , offset FLAT:dev32_init     ; data->input.device_init
        mov eax, [bp + 4]		                                       ; pReqPkt
        mov dword ptr [bp - 24].b_pReqPkt   , eax                              ; data->input.pReqPkt
        mov dword ptr [bp - 24].b_pTKSSBase , offset FLAT:TKSSBase
        mov dword ptr [bp - 24].b_pDevHelp32, offset FLAT:DevHelp32
        push ss                         ; seg pData
        push di                         ; ofs pData
;        push word ptr 8                        ; cbData
        push ss                         ; seg pParm
        push si                         ; ofs pParm
;       push word ptr 4                 ; cbParm
        push word ptr 042h              ; func
        push word ptr 0f0h              ; cat
        push word ptr [bp - 2]          ; FileHandle
        call DOS16DEVIOCTL
        cmp ax, NO_ERROR
        jnz short @@error

        ;
        ; Closes mwdd32$
        ;
        push word ptr [bp - 2]                   ; FileHandle
        call DOS16CLOSE
        cmp ax, NO_ERROR
        jnz short @@error


        ;
        ; Tests magic number in answer from mwdd32.sys
        ;
        cmp dword ptr [bp - 8].b_magic, INIT_DEVICE_MAGIC_OUT
        jne short @@error

        ;
        ; Retrieves device_init's return code from mwdd32.sys answer
        ;
        mov ax, word ptr [bp - 24].b_device_init_rc     ; rc from device_init

@@out:
	pop di
	pop si
	pop bx
	pop es
	pop ds
	leave
	ret 4

@@error:
	mov ax, STDON + STERR + ERROR_I24_GEN_FAILURE
	jmp short @@out

device_init endp


dev32_stub_IDC proc far
        call far ptr FLAT:DEV32_IDC
        retf
dev32_stub_IDC endp


;*********************************************************************************************
;**************** Everything below this line will be unloaded after init *********************
;*********************************************************************************************
end_of_code:

CODE16 ends

CODE32 segment
ASSUME CS:FLAT, DS:FLAT, ES:FLAT

        public begin_code32

        extrn  DEV32_STRATEGY  : far
        extrn  DEV32_IDC       : far
	extrn  dev32_init      : near

begin_code32:
CODE32 ends

DATA32 segment
    public  codeend
    public  dataend

    codeend dw offset CODE16:code16_end
    dataend dw offset DATA16:data16_end

    extrn  TKSSBase  : dword
    extrn  DevHelp32 : dword

DATA32 ends

BSS32 segment
        public  begin_data32

        begin_data32 dd (?)
BSS32 ends
end

