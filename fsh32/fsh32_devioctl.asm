;
; $Header: d:\\32bits\\ext2-os2\\fsh32\\rcs\\fsh32_devioctl.asm,v 1.4 1997/03/15 17:52:54 Willm Exp $
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
        ASSUME CS:CODE16, DS:FLAT

	extrn FSH_DEVIOCTL : far

        public thunk16$fsh32_devioctl

thunk16$fsh32_devioctl:
        call FSH_DEVIOCTL
;        jmp far ptr FLAT:thunk32$fsh32_devioctl
        jmp32 thunk32$fsh32_devioctl

CODE16 ends

CODE32 segment
ASSUME CS:FLAT, DS:FLAT, ES:FLAT, SS:NOTHING

        public thunk32$fsh32_devioctl
        public         fsh32_devioctl

;
;int FSH32ENTRY fsh32_devioctl(
;    unsigned short FSDRaisedFlag ,   /* ebp + 8  */
;    unsigned long hDev,              /* ebp + 12 */
;    unsigned short sfn,              /* ebp + 16 */
;    unsigned short cat,              /* ebp + 20 */
;    unsigned short func,             /* ebp + 24 */
;    PTR16 pParm,                     /* ebp + 28 */
;    unsigned short cbParm,           /* ebp + 32 */
;    PTR16 pData,                     /* ebp + 36 */
;    unsigned short cbData            /* ebp + 40 */
;);
;
fsh32_devioctl proc near
	enter 0, 0
	push es
	push ebx

	sub esp, 24

	mov ax, [ebp + 8]
	mov [esp + 22], ax 	; flag

	mov eax, [ebp + 12]
	mov [esp + 18], eax 	; hDev

	mov ax, [ebp + 16]
	mov [esp + 16], ax 	; sfn

	mov ax, [ebp + 20]	; cat
	mov [esp + 14], ax 

	mov ax, [ebp + 24]
	mov [esp + 12], ax    	; func  

	mov eax, [ebp + 28]
	mov [esp + 8], eax 	; pParm

	mov ax, [ebp + 32]
	mov [esp + 6], ax 	; cbParm

	mov eax, [ebp + 36]
	mov [esp + 2], eax 	; pData

	mov ax, [ebp + 40]	; cbData
	mov [esp], ax

        jmp far ptr thunk16$fsh32_devioctl
thunk32$fsh32_devioctl:
	movzx eax, ax
	pop ebx
	pop es
	leave
        ret
fsh32_devioctl endp

CODE32  ends

        end
