#
# $Header: D:/32bits/ext2-os2/skeleton/ifs/RCS/makefile,v 1.4 1997/03/16 13:01:55 Willm Exp Willm $
#

# 32 bits OS/2 device driver and IFS support. Provides 32 bits kernel
# services (DevHelp) and utility functions to 32 bits OS/2 ring 0 code
# (device drivers and installable file system drivers).
# Copyright (C) 1995, 1996, 1997  Matthieu WILLM (willm@ibm.net)
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.

#
# Path definitions
#
!include ../../makefile.inc

CC       = icc -q
CFLAGS   = -Ge- -Gs- -Gr+ -Rn -Ss+ -O -G5
#CFLAGS   = -Ge- -Gs- -Gr+ -Rn -Ss+ -Ti+

AS        = alp
ASFLAGS   = -Mb -Li

CDEFINES  = -DFSD32 -DDYNAMIC_DEVHELP -DMWDD32_VER=$(MWDD32_VERSION)
CINCLUDES = -I.                       \
            -I../../include           \
            -I$(VACPATH)/include      \
            -I$(VACPATH)/include/os2  \
            -I\os2\security\dev\h     \
            -I$(DDKPATH)/h

ADEFINES   = -D:FSD32
AINCLUDES = -Fdi:$(DDKPATH)\inc -Fdi:..\..\include\os2

.c.obj:
        @echo $<
        @$(CC) -c $(CFLAGS) $(CDEFINES) -Fa$(@:.obj=.s) -Fo$@ $(CINCLUDES) $<

.asm.obj:
        @echo $<
        @$(AS) $(ASFLAGS) $(ADEFINES) $(AINCLUDES) $< -Fo:$@ -Fl:$(@:.obj=.lst)

all:fsd32.ifs

AOBJS = fs_attribute.obj         \
        fs_name.obj              \

COBJS = fs32_allocatepagespace.obj \
        fs32_chdir.obj           \
        fs32_chgfileptr.obj      \
        fs32_close.obj           \
        fs32_commit.obj          \
        fs32_delete.obj          \
        fs32_dopageio.obj        \
        fs32_init.obj            \
        fs32_exit.obj            \
        fs32_fileattribute.obj   \
        fs32_fileinfo.obj        \
        fs32_findclose.obj       \
        fs32_findfirst.obj       \
        fs32_findfromname.obj    \
        fs32_findnext.obj        \
        fs32_flushbuf.obj        \
        fs32_fsctl.obj           \
        fs32_fsinfo.obj          \
        fs32_ioctl.obj           \
        fs32_mkdir.obj           \
        fs32_mount.obj           \
        fs32_move.obj            \
        fs32_newsize.obj         \
        fs32_opencreate.obj      \
        fs32_openpagefile.obj    \
        fs32_pathinfo.obj        \
        fs32_read.obj            \
        fs32_rmdir.obj           \
        fs32_shutdown.obj        \
        fs32_banner.obj          \
        fs32_write.obj

fsd32.ifs:fsd32.def $(AOBJS) $(COBJS)
        icc @<<
$(CFLAGS) -Fe$@ -Q -B"/MAP /EXEPACK:2 /ALIGNMENT:4"
$(AOBJS)
$(COBJS)
$(DDKPATH)\lib\os2386p.lib
$(DDKPATH)\lib\vdh.lib
$(IFSTKTPATH)\fshelper.lib
fsd32.def
$(EXT2OS2_BASE)\fsh32\fsh32.lib
<<
        mapsym $(@:.ifs=.map)
        -copy $(@:.ifs=.sym) e:\mwfs
        -copy $@ e:\mwfs

clean:
        -del *.obj
        -del *.s
        -del *.lst
        -del *.ifs
        -del *.map
        -del *.sym
