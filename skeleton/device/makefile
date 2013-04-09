#
# $Header: d:\\32bits\\ext2-os2\\skeleton\\device\\rcs\\makefile,v 1.3 1997/03/16 13:07:14 Willm Exp $
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

CC        = icc -q
CFLAGS    = -Ge- -Gs- -Gr+ -Rn -Ss+ -O -G5

LD        = icc

AS        = alp
ASFLAGS   = -Mb -Li

CDEFINES   = -DDYNAMIC_DEVHELP -DMWDD32_VER=$(MWDD32_VERSION)
ADEFINES   = -D:DYNAMIC_DEVHELP
CINCLUDES  = -I$(VACPATH)\include\os2 -I$(DDKPATH)\h -I$(DDKPATH)/src/dev/dasd/diskh -I/os2/security/dev/h -I/os2/security/dev/ssskpi -I. -I../../include -I../../include/os2
AINCLUDES  = -Fdi:$(DDKPATH)/inc -Fdi:../../include/os2

.c.obj:
        @echo $<
        @$(CC) -c $(CFLAGS) $(CDEFINES) -Fa$(@:.obj=.s) -Fo$@ $(CINCLUDES) $<

.asm.obj:
        @echo $<
        @$(AS) $(ASFLAGS) $(ADEFINES) $(AINCLUDES) $< -Fo:$@ -Fl:$(@:.obj=.lst)

all:dev32.sys

AOBJS =

COBJS =   dev32_idc.obj                               \
          dev32_open.obj                              \
          dev32_close.obj                             \
          dev32_ioctl.obj                             \
          dev32_init.obj                              \
          dev32_strategy.obj                          \
          dev32_shutdown.obj                          \
          dev32_init_complete.obj                     \
          dev32_data.obj                              \
          dev32_banner.obj                            \
          dev32_invalid_command.obj

dev32.sys: $(AOBJS)             \
            $(COBJS)            \
            dev32_start.obj     \
            dev32_end.obj       \
            dev32.def
        $(LD) @<<
$(CFLAGS) -Fe$@ -B"/MAP /EXEPACK:2 /NOD /ALIGNMENT:4"
dev32_start.obj
$(AOBJS)
$(COBJS)
dev32_end.obj
$(DDKPATH)\lib\os2386.lib
dev32.def
<<
        mapsym $(@:.sys=.map)
        -copy $@             g:\os2
        -copy $(@:.sys=.sym) g:\os2


clean::
        -del dev32.sys
        -del dev32.map
        -del dev32.sym
        -del *.obj
        -del *.lst
        -del *.s

