;
; $Header: D:/32bits/ext2-os2/skeleton/ifs/rcs/fs_attribute.asm,v 1.2 1997/03/16 13:01:55 Willm Exp Willm $
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

        include fsd32_segdef.inc
        include r0thunk.inc
        include fsd.inc

CODE16 segment
        public FS_ATTRIBUTE

        FS_ATTRIBUTE dd 00000000000000000000000000000000b
        ;                                           ||||
        ;                     level 7 requests -----+|||
        ;                 lock notifications   ------+||
        ;                     UNC support      -------+|
        ;                     remote FSD       --------+

CODE16 ends

        end
