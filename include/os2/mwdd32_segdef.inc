;
; $Header: d:\\32bits\\ext2-os2\\include\\os2\\rcs\\mwdd32_segdef.inc,v 1.2 1997/03/15 18:10:17 Willm Exp $
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

;
; segment definitions for mwdd32.sys
;

DATA16 segment word public use16 'DATA16'
DATA16 ends

CODE16 segment word public use16 'CODE'
CODE16 ends

CODE32 segment dword public use32 'CODE'
CODE32 ends

BSS32   segment dword use32 public 'BSS'
BSS32   ends
c_common        segment dword use32 public 'DATA'
c_common        ends

CONST32_RO      segment dword use32 public 'CONST'
CONST32_RO      ends

DATA32  segment dword use32 public 'DATA'
DATA32  ends

DGROUP   group BSS32, DATA32

