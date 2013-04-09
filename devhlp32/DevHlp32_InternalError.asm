;
; $Header: d:\\32bits\\ext2-os2\\devhlp32\\rcs\\DevHlp32_InternalError.asm,v 1.4 1997/03/15 16:38:23 Willm Exp $
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
        ASSUME CS:CODE16, DS:DATA16, ES:FLAT

        public thunk16$DevHlp32_InternalError

thunk16$DevHlp32_InternalError:
        call es:[DevHelp2]
	;
	; We should never reach this point
	;
	int 3
;        jmp far ptr FLAT:thunk32$DevHlp32_InternalError

CODE16 ends

DATA16 segment
	public panic_buffer
	panic_buffer db 512 dup (?)
DATA16 ends

CODE32 segment
ASSUME CS:FLAT, DS:FLAT, ES:FLAT, SS:NOTHING

        public         DevHlp32_InternalError

;
; void DH32ENTRY DevHlp32_InternalError(
;      				        char *msg,	/* ebp + 8  */
;					int   msglen    /* ebp + 12 */
;     				       );
;
DevHlp32_InternalError proc near
	enter 0, 0	
	mov ax, seg DATA16
	mov es, ax
	mov ax, offset DATA16:panic_buffer
	movzx edi, ax
	mov esi, [ebp + 8]
	mov ecx, [ebp + 12]
	and ecx, 511
	rep movsb

	mov edi, [ebp + 12]
	and edi, 511
	push ds
	pop es
	mov ax, seg DATA16
	mov ds, ax
	mov si, offset DATA16:panic_buffer
	mov dl, DevHlp_InternalError
        jmp far ptr thunk16$DevHlp32_InternalError
DevHlp32_InternalError endp

CODE32  ends

        end
