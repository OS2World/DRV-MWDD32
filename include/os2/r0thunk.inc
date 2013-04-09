;
; $Header: d:\\32bits\\ext2-os2\\include\\os2\\rcs\\r0thunk.inc,v 1.2 1997/03/15 18:10:17 Willm Exp $
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

extrn Dos32FlatCS : abs                ; ring 0 FLAT kernel data selector
extrn Dos32FlatDS : abs                ; ring 0 FLAT kernel data selector


DATA32 segment
        extrn DevHelp2  : dword
ifdef FSD32
	extrn _TKSSBase : dword
endif
DATA32 ends

ifdef FSD32
;%out  FSD32 defined !
jmp32 macro target
        db 066h
        db 0eah
        dd offset FLAT:target
        dw Dos32FlatCS
endm
endif
ifdef MWDD32
;%out MWDD32 defined !
jmp32 macro target
        jmp far ptr FLAT:target
endm
endif

ifdef FSD32
;%out  FSD32 defined !
call32 macro target
        db 066h
        db 09ah
        dd offset FLAT:target
        dw Dos32FlatCS
endm
endif
ifdef MWDD32
;%out  MWDD32 defined !
call32 macro target
        call far ptr FLAT:target
endm
endif
