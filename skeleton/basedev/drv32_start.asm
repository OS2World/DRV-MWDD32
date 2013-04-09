;
; $Header: d:\\32bits\\ext2-os2\\skeleton\\basedev\\rcs\\drv32_start.asm,v 1.4 1997/03/16 12:51:42 Willm Exp $
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
        include devcmd.inc
        include devsym.inc

        include drv32_segdef.inc


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
                dw offset CODE16:drv32_stub_strategy; Strategy routine entry point
                dw offset CODE16:drv32_stub_IDC     ; IDC routine entry point
                db 'drv32$  '                   ; Device name
                db 8 dup (0)                    ; Reserved
                dw 0000000000011011b            ; Level 3 device drive capabilities
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

        public drv32_stub_strategy
        public drv32_stub_IDC


drv32_stub_strategy proc far
;	int 3
        movzx eax, byte ptr es:[bx].reqCommand
        cmp eax, 0
        jz short @@error
        push es                                 ; seg reqpkt
        push bx                                 ; ofs reqpkt
        push eax                                ; command
        mov word ptr es:[bx].reqStatus, 0       ; updates the request status
        call far ptr FLAT:DRV32_STRATEGY        ; 32 bits strategy entry point
        mov word ptr es:[bx].reqStatus, ax      ; updates the request status
        retf

@@error:
        ;
        ; Cannot be initialized as a DEVICE statement. MUST be
        ; initialized as a BASEDEV statement. (ring 0 FLAT CS is
        ; unreachable at DEVICE INIT time ...)
        ;
        mov dword ptr es:[bx].i_devHelp, 0
        mov  word ptr es:[bx].reqStatus, STDON + STERR + ERROR_I24_BAD_COMMAND
        retf
drv32_stub_strategy endp

drv32_stub_IDC proc far
        call far ptr FLAT:DRV32_IDC
        retf
drv32_stub_IDC endp


;*********************************************************************************************
;**************** Everything below this line will be unloaded after init *********************
;*********************************************************************************************
end_of_code:

CODE16 ends

CODE32 segment
ASSUME CS:FLAT, DS:FLAT, ES:FLAT

        public begin_code32

        extrn  DRV32_STRATEGY  : far
        extrn  DRV32_IDC       : far

begin_code32:
CODE32 ends

DATA32 segment
        public  codeend
        public  dataend

        codeend dw offset CODE16:code16_end
        dataend dw offset DATA16:data16_end


DATA32 ends

BSS32 segment
        public  begin_data32

        begin_data32 dd (?)
BSS32 ends
end

