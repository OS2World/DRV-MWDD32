;
; $Header$
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

        include fsd32_segdef.inc
        include r0thunk.inc
        include fsd.inc

thunk_fs macro name, size
public FS_&name
FS_&name proc far
        enter 0, 0
        push ds
        push es
        mov ax, Dos32FlatDS
        mov ds, ax
        mov es, ax

        assume DS:FLAT, ES:FLAT

        lea eax, [bp + 6]       ; adress of FS_MOUNT parameter
        add eax, _TKSSBase      ; ... converted to 32 bits FLAT
        push eax                ; ... and passed to 32 bits routine
        call32 FS32_&name

        assume DS:NOTHING, ES:NOTHING

        pop es
        pop ds

        leave
        retf size
FS_&name endp
endm

nothunk_fs macro name, rc, size
    public FS_&name

FS_&name proc far
    mov ax, rc
    retf size
FS_&name endp
endm



CODE16 segment

assume CS:CODE16

thunk_fs ALLOCATEPAGESPACE, 16
thunk_fs CHDIR            , 16
thunk_fs CHGFILEPTR       , 16
thunk_fs CLOSE            , 12
thunk_fs COMMIT           , 12
thunk_fs DELETE           , 14
thunk_fs DOPAGEIO         , 12
thunk_fs EXIT             , 6
thunk_fs FILEATTRIBUTE    , 14
thunk_fs FILEINFO         , 20
thunk_fs FINDCLOSE        , 8
thunk_fs FINDFIRST        , 38
thunk_fs FINDFROMNAME     , 30
thunk_fs FINDNEXT         , 22
thunk_fs FLUSHBUF         , 4
thunk_fs FSCTL            , 28
thunk_fs FSINFO           , 12
thunk_fs IOCTL            , 32
thunk_fs MKDIR            , 20
thunk_fs MOUNT            , 16
thunk_fs MOVE             , 22
thunk_fs NEWSIZE          , 14
thunk_fs OPENCREATE       , 42
thunk_fs OPENPAGEFILE     , 30
thunk_fs PATHINFO         , 24
thunk_fs READ             , 18
thunk_fs RMDIR            , 14
thunk_fs SHUTDOWN         , 6
thunk_fs WRITE            , 18


nothunk_fs ATTACH           , ERROR_NOT_SUPPORTED, 22
nothunk_fs CANCELLOCKREQUEST, ERROR_NOT_SUPPORTED, 12
nothunk_fs COPY             , ERROR_CANNOT_COPY  , 14
nothunk_fs FILEIO           , ERROR_NOT_SUPPORTED, 20
nothunk_fs FILELOCKS        , ERROR_NOT_SUPPORTED, 24
nothunk_fs FINDNOTIFYCLOSE  , ERROR_NOT_SUPPORTED, 2
nothunk_fs FINDNOTIFYFIRST  , ERROR_NOT_SUPPORTED, 36
nothunk_fs FINDNOTIFYNEXT   , ERROR_NOT_SUPPORTED, 18
nothunk_fs NMPIPE           , ERROR_NOT_SUPPORTED, 22
nothunk_fs PROCESSNAME      , NO_ERROR           , 4
nothunk_fs SETSWAP          , ERROR_NOT_SUPPORTED, 8


;    FS_INIT                         Called directly by MWDD32.SYS
;    FS_VERIFYUNCNAME                N/A : local FSD

CODE16 ends

CODE32 segment
	assume CS:FLAT, DS:FLAT

	public _fs32_allocatepagespace

_fs32_allocatepagespace proc near
	push eax	
	db 09ah
	dd offset FLAT:FS32_ALLOCATEPAGESPACE
	dw Dos32FlatCS
	ret
_fs32_allocatepagespace endp

	public _fs32_opencreate

_fs32_opencreate proc near
	push eax
	db 09ah
 	dd offset FLAT:FS32_OPENCREATE
	dw Dos32FlatCS
	ret
_fs32_opencreate endp

CODE32 ends

        end
