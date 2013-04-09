#
# $Header: d:\\32bits\\ext2-os2\\mwdd32\\rcs\\makefile,v 1.5 1997/03/16 12:44:29 Willm Exp $
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
!include ../makefile.inc

CC       = icc -q
CFLAGS   = -Ge- -Gs- -Gr+ -Rn -Ss+ -O -G5

LD       = ilink

AS        = alp
ASFLAGS   = -Mb -Li

CDEFINES   = -DOS2 -DMWDD32 -DMWDD32_VER=$(MWDD32_VERSION)
ADEFINES   = -D:MWDD32
CINCLUDES  = -I$(VACPATH)\include\os2 -I$(DDKPATH)\h -I$(DDKPATH)/src/dev/dasd/diskh -I/os2/security/dev/h -I/os2/security/dev/ssskpi -I. -I../include -I../include/os2
AINCLUDES  = -Fdi:$(DDKPATH)/inc -Fdi:../include/os2

.c.obj_dd:
        @echo $<
        @$(CC) -c $(CFLAGS) $(CDEFINES) -Fa$(@:.obj_dd=.s_dd) -Fo$@ $(CINCLUDES) $<

.asm.obj_dd:
        @echo $<
        @$(AS) $(ASFLAGS) $(ADEFINES) $(AINCLUDES) $< -Fo:$@ -Fl:$(@:.obj_dd=.lst_dd)

all:mwdd32.sys

AOBJS =   ../devhlp32/DevHlp32_VMLock.obj_dd             \
          ../devhlp32/DevHlp32_VMUnLock.obj_dd           \
          ../devhlp32/DevHlp32_VirtToLin.obj_dd          \
          ../devhlp32/DevHlp32_GetDosVar.obj_dd          \
          ../devhlp32/DevHlp32_Security.obj_dd           \
          ../devhlp32/DevHlp32_AttachToDD.obj_dd         \
          ../devhlp32/DevHlp32_AllocOneGDTSelector.obj_dd\
          ../devhlp32/DevHlp32_FreeGDTSelector.obj_dd    \
          ../devhlp32/DevHlp32_SaveMessage.obj_dd        \
          ../devhlp32/DevHlp32_setIRQ.obj_dd             \
          ../devhlp32/DevHlp32_UnSetIRQ.obj_dd           \
          ../devhlp32/DevHlp32_EOI.obj_dd                \
          ../devhlp32/DevHlp32_InternalError.obj_dd      \
          ../devhlp32/DevHlp32_VMAlloc.obj_dd            \
          ../devhlp32/DevHlp32_VMFree.obj_dd             \
          ../devhlp32/DevHlp32_ProcBlock.obj_dd          \
          ../devhlp32/DevHlp32_ProcRun.obj_dd            \
          ../devhlp32/DevHlp32_LinToPageList.obj_dd      \
          ../devhlp32/DevHlp32_PageListToLin.obj_dd      \
          ../devhlp32/DevHlp32_yield.obj_dd              \
          ../devhlp32/DevHlp32_GetInfoSegs.obj_dd        \
          ../devhlp32/DevHlp32_VerifyAccess.obj_dd       \
          ../devhlp32/DevHlp32_OpenEventSem.obj_dd       \
          ../devhlp32/DevHlp32_CloseEventSem.obj_dd      \
          ../devhlp32/DevHlp32_PostEventSem.obj_dd       \
          ../devhlp32/DevHlp32_ResetEventSem.obj_dd      \
          ../util/sec32_attach_ses.obj_dd                \
          mwdd32_pre_init_base.obj_dd

COBJS =   mwdd32_idc.obj_dd                              \
          mwdd32_open.obj_dd                             \
          mwdd32_close.obj_dd                            \
          mwdd32_ioctl.obj_dd                            \
          mwdd32_init_base.obj_dd                        \
          mwdd32_strategy.obj_dd                         \
          mwdd32_shutdown.obj_dd                         \
          mwdd32_init_complete.obj_dd                    \
          mwdd32_banner.obj_dd                           \
          mwdd32_invalid_command.obj_dd                  \
          ../devhlp32/DevHlp32_AttachDD.obj_dd           \
          ../devhlp32/DevHlp32_AllocGDTSelector.obj_dd   \
          ../util/vsprintf.obj_dd                        \
          ../util/strtoul.obj_dd                         \
          ../util/strtol.obj_dd                          \
          ../util/ctype.obj_dd                           \
          ../util/atol.obj_dd                            \
          ../util/strupr.obj_dd                          \
          ../util/strpbrk.obj_dd                         \
          ../util/strtok.obj_dd                          \
          ../util/fnmatch.obj_dd

mwdd32.sys: $(AOBJS)            \
            $(COBJS)            \
            mwdd32_start.obj_dd \
            mwdd32_end.obj_dd   \
            mwdd32.def
        $(LD) @<<
/MAP /EXEPACK:2 /NOD /ALIGNMENT:4
mwdd32_start.obj_dd
$(AOBJS)
$(COBJS)
mwdd32_end.obj_dd
$(DDKPATH)\lib\os2386p.lib
mwdd32.def
/O:mwdd32.sys
<<
        mapsym $(@:.sys=.map)
        -copy $@             g:\os2
        -copy $(@:.sys=.sym) g:\os2


clean::
        -del mwdd32.sys
        -del mwdd32.map
        -del mwdd32.sym
        -del *.obj_dd
        -del *.lst_dd
        -del *.s_dd
        -del ..\*.obj_dd
        -del ..\*.lst_dd
        -del ..\*.s_dd
        -del ..\devhlp32\*.obj_dd
        -del ..\devhlp32\*.lst_dd
        -del ..\devhlp32\*.s_dd
        -del ..\util\*.obj_dd
        -del ..\util\*.lst_dd
        -del ..\util\*.s_dd



