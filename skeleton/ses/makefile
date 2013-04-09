#
# $Header: d:\\32bits\\ext2-os2\\skeleton\\ses\\rcs\\makefile,v 1.3 1997/03/16 13:13:43 Willm Exp $
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
AINCLUDES  = -Fdi:$(DDKPATH)/inc -Fdi:../include/os2

.c.obj:
        @echo $<
        @$(CC) -c $(CFLAGS) $(CDEFINES) -Fa$(@:.obj=.s) -Fo$@ $(CINCLUDES) $<

.asm.obj:
        @echo $<
        @$(AS) $(ASFLAGS) $(ADEFINES) $(AINCLUDES) $< -Fo:$@ -Fl:$(@:.obj=.lst)

all:sec32.sys

AOBJS =   sec32_pre_init_base.obj

COBJS =   sec32_idc.obj                               \
          sec32_open.obj                              \
          sec32_close.obj                             \
          sec32_ioctl.obj                             \
          sec32_init_base.obj                         \
          sec32_strategy.obj                          \
          sec32_shutdown.obj                          \
          sec32_init_complete.obj                     \
          sec32_data.obj                              \
          sec32_banner.obj                            \
          sec32_callbacks.obj                         \
          sec32_open_pre.obj                          \
          sec32_open_post.obj                         \
          sec32_invalid_command.obj

sec32.sys: $(AOBJS)             \
            $(COBJS)            \
            sec32_start.obj     \
            sec32_end.obj       \
            sec32.def
        $(LD) @<<
$(CFLAGS) -Fe$@ -B"/MAP /EXEPACK:2 /NOD /ALIGNMENT:4"
sec32_start.obj
$(AOBJS)
$(COBJS)
sec32_end.obj
$(DDKPATH)\lib\os2386p.lib
sec32.def
<<
        mapsym $(@:.sys=.map)
        -copy $@             g:\os2
        -copy $(@:.sys=.sym) g:\os2


clean::
        -del sec32.sys
        -del sec32.map
        -del sec32.sym
        -del *.obj
        -del *.lst
        -del *.s

