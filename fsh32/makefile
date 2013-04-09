#
# $Header: d:\\32bits\\ext2-os2\\fsh32\\rcs\\makefile,v 1.4 1997/03/15 17:52:54 Willm Exp $
#

# 32 bits OS/2 device driver and IFS support. Provides 32 bits kernel
# services (DevHelp) and utility functions to 32 bits OS/2 ring 0 code
# (device drivers and installable file system drivers).
# Copyright (C) 1995, 1996, 1997  Matthieu WILLM
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
!include ../makefile.inc

CC        = icc -q
CFLAGS    = -Ge- -Gs- -Gr+ -Rn -Ss+ -O -G5
#CFLAGS   = -Ge- -Gs- -Gr+ -Rn -Ss+ -Ti+

AS        = alp
ASFLAGS   = -Mb -Li

CDEFINES  = -DFSD32 -DDYNAMIC_DEVHELP
CINCLUDES = -I.                       \
            -I../../include               \
            -I$(VACPATH)/include      \
            -I$(VACPATH)/include/os2  \
            -I\os2\security\dev\h     \
            -I$(DDKPATH)/h

ADEFINES   = -D:FSD32
AINCLUDES = -Fdi:$(DDKPATH)\inc -Fdi:..\include\os2

.c.obj:
        @echo $<
        @$(CC) -c $(CFLAGS) $(CDEFINES) -Fa$(@:.obj=.s) -Fo$@ $(CINCLUDES) $<

.asm.obj:
        @echo $<
        @$(AS) $(ASFLAGS) $(ADEFINES) $(AINCLUDES) $< -Fo:$@ -Fl:$(@:.obj=.lst)

all:fsh32.lib

AOBJS = fs_init.obj              \
        fs_thunks.obj            \
        fsh32_devioctl.obj       \
        fsh32_dovolio.obj        \
        fsh32_findduphvpb.obj    \
        fsh32_forcenoswap.obj    \
        fsh32_getvolparm.obj     \
        fsh32_qsysinfo.obj       \
        fsh32_addshare.obj       \
        fsh32_removeshare.obj    \
        fsh32_setvolume.obj      \
        fsh32_ioboost.obj        \
        fsh32_segalloc.obj

COBJS =

fsh32.lib : $(AOBJS)
        !ilib /noi /noe /q $@ -+$?;


clean:
        -del *.obj
        -del *.s
        -del *.lst
        -del *.lib
        -del *.bak
