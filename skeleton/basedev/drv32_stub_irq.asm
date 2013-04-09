;
; $Header: d:\\32bits\\ext2-os2\\skeleton\\basedev\\rcs\\drv32_stub_irq.asm,v 1.2 1997/03/16 12:51:42 Willm Exp $
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



        include drv32_segdef.inc


CODE16 segment
        assume cs:CODE16, ds:DATA16

        public drv32_stub_IRQ


;
; This is the main IRQ processing entry point. It must reside in the default 16 bits
; code segment.
;
drv32_stub_IRQ proc far
	;
 	; Calls our 32 bits interrupt service routine
	; 
        call far ptr FLAT:DRV32_IRQ
	;
 	; Set the carry flag if return code is nonzero
	; 
	neg eax
	;
	; Returns to the kernel
	;
        retf
drv32_stub_IRQ endp

CODE16 ends

CODE32 segment
ASSUME CS:FLAT, DS:FLAT, ES:FLAT

        extrn  DRV32_IRQ       : far

CODE32 ends

DATA32 segment
        public  drv32_stub_irq_offset
	public  drv32_data16_segment

        ;
        ; Alias for the 16:16 offset of the IRQ processing entry point.
        ;
        drv32_stub_irq_offset dw offset CODE16:drv32_stub_IRQ

        ;
        ; Alias for the device driver 16 bits data segment selector.
        ;
	drv32_data16_segment dw seg DATA16

DATA32 ends

end

