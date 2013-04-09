#
# $Header: d:\\32bits\\ext2-os2\\distrib\\rcs\\makefile,v 1.4 1997/03/15 16:44:50 Willm Exp $
#

# 32 bits Linux ext2 file system driver for OS/2 WARP - Allows OS/2 to
# access your Linux ext2fs partitions as normal drive letters.
# Copyright (C) 1995, 1996, 1997  Matthieu WILLM (willm@ibm.net)
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

!include ../makefile.inc
!include  ./files.lst

all : 32drv$(MWDD32_PKG_VER).zip    \
      ext2_$(EXT2OS2_PKG_VER).zip


#
# ext2-os2 package (ext2_xxx.zip)
#
ext2_$(EXT2OS2_PKG_VER).zip : $(EXT2OS2_DISTRIB_FILES)
        zip -j $@ -@ < <<
$(EXT2OS2_DISTRIB_FILES)
<<
        zipnote -w $@ < zipnote.ext2-os2


#
# mwdd32 package (32drvxxx.zip)
#
32drv$(MWDD32_PKG_VER).zip : $(MWDD32_DISTRIB_FILES)
        zip -j $@ -@ < <<
$(MWDD32_DISTRIB_FILES)
<<
        zipnote -w $@ < zipnote.mwdd32

#
# ext2-os2 sources (ext2_src.zip)
#
ext2_src.zip :                          \
                 $(EXT2OS2_FILES)       \
                 $(CONSOLE_SRC)         \
                 $(UTILS_SRC)           \
                 $(VFSAPI_SRC)          \
                 $(EXT2OS2_DOC_SRC)     \
                 $(EXT2OS2_PKG_FILES)   \
                 $(EXT2FLT_SRC)         \
                 $(MICROFSD_SRC)        \
                 $(MINIFSD_SRC)         \
                 $(E2FSPROGS_FILES)
        @zip $@ -@ < <<
$(EXT2OS2_FILES)
$(CONSOLE_SRC)
$(UTILS_SRC)
$(VFSAPI_SRC)
$(EXT2OS2_DOC_SRC)
$(EXT2OS2_PKG_FILES)
$(EXT2FLT_SRC)
$(E2FSPROGS_FILES)
$(MICROFSD_SRC)
$(MINIFSD_SRC)
<<
        zipnote -w $@ < zipnote.ext2-os2

#
# mwdd32 sources (mwdd_src.zip)
#
mwdd_src.zip :                         \
                 $(MWDD32_FILES)       \
                 $(BASEDEV_SKEL_FILES) \
                 $(DEVICE_SKEL_FILES) \
                 $(IFS_SKEL_FILES)     \
                 $(SES_SKEL_FILES)     \
                 $(MWDD32_DOC_FILES)   \
                 $(MWDD32_PKG_FILES)   \
                 $(FSH32_FILES)        \
                 $(MWDD32_INF_FILES)   \
                 $(WATCOMSAMPLE_SKEL_FILES)
        @zip $@ -@ < <<
$(MWDD32_FILES)
$(BASEDEV_SKEL_FILES)
$(DEVICE_SKEL_FILES)
$(IFS_SKEL_FILES)
$(SES_SKEL_FILES)
$(MWDD32_DOC_FILES)
$(MWDD32_PKG_FILES)
$(FSH32_FILES)
$(MWDD32_INF_FILES)
$(WATCOMSAMPLE_SKEL_FILES)
<<
        zipnote -w $@ < zipnote.mwdd32

clean:
        -del 32drv$(MWDD32_PKG_VER).zip
        -del mwdd_src.zip
        -del ext2_$(EXT2OS2_PKG_VER).zip
        -del ext2_src.zip


#
# ext2-os2.sym
#
$(EXT2OS2_BASE)\ext2-os2.sym : $(EXT2OS2_BASE)\ext2-os2.ifs

#
# ext2-os2.ifs
#
$(EXT2OS2_BASE)\ext2-os2.ifs : $(EXT2OS2_BASE)\fsh32\fsh32.lib   \
                               $(EXT2OS2_BASE)\mwdd32\mwdd32.sys \
                               $(EXT2OS2_FILES)
        @cd $(EXT2OS2_BASE)
        @$(MAKE) -f makefile.ext2-os2
        @cd $(EXT2OS2_BASE)\distrib

#
# fsh32/fsh32.lib
#
$(EXT2OS2_BASE)\fsh32\fsh32.lib: $(FSH32_FILES)
        @cd $(EXT2OS2_BASE)\fsh32
        @$(MAKE)
        @cd $(EXT2OS2_BASE)\distrib


#
# mwdd32/mwdd32.sym
#
$(EXT2OS2_BASE)\mwdd32\mwdd32.sym : $(EXT2OS2_BASE)\mwdd32\mwdd32.sys

#
# mwdd32/mwdd32.sys
#
$(EXT2OS2_BASE)\mwdd32\mwdd32.sys : $(MWDD32_FILES)
        @cd $(EXT2OS2_BASE)\mwdd32
        @$(MAKE)
        @cd $(EXT2OS2_BASE)\distrib

#
# skeleton/ifs/fsd32.sym
#
$(EXT2OS2_BASE)\skeleton\ifs\fsd32.sym : $(EXT2OS2_BASE)\skeleton\ifs\fsd32.ifs


#
# skeleton/ifs/fsd32.ifs
#
$(EXT2OS2_BASE)\skeleton\ifs\fsd32.ifs : $(EXT2OS2_BASE)\fsh32\fsh32.lib $(EXT2OS2_BASE)\mwdd32\mwdd32.sys
        @cd $(EXT2OS2_BASE)\skeleton\ifs
        @$(MAKE)
        @cd $(EXT2OS2_BASE)\distrib


#
# skeleton/basedev/drv32.sym
#
$(EXT2OS2_BASE)\skeleton\basedev\drv32.sym : $(EXT2OS2_BASE)\skeleton\basedev\drv32.sys


#
# skeleton/basedev/drv32.sys
#
$(EXT2OS2_BASE)\skeleton\basedev\drv32.sys : $(EXT2OS2_BASE)\mwdd32\mwdd32.sys
        @cd $(EXT2OS2_BASE)\skeleton\basedev
        @$(MAKE)
        @cd $(EXT2OS2_BASE)\distrib

#
# doc/mwdd32/mwdd32.inf
#
$(EXT2OS2_BASE)\doc\mwdd32\mwdd32.inf : $(MWDD32_INF_FILES)
        @cd $(EXT2OS2_BASE)\doc\mwdd32
        @$(MAKE)
        @cd $(EXT2OS2_BASE)\distrib

#
# console/ext2-os2.exe
#
$(EXT2OS2_BASE)\console\ext2-os2.exe : $(CONSOLE_SRC) $(EXT2OS2_BASE)\vfsapi\vfsapi.lib
        @cd $(EXT2OS2_BASE)\console
        @$(MAKE)
        @cd $(EXT2OS2_BASE)\distrib

#
# misc/ext2_lw.exe
#
$(EXT2OS2_BASE)\misc\ext2_lw.exe : $(UTILS_SRC) $(EXT2OS2_BASE)\vfsapi\vfsapi.lib
        @cd $(EXT2OS2_BASE)\misc
        @$(MAKE) ext2_lw.exe
        @cd $(EXT2OS2_BASE)\distrib

#
# misc/sync.exe
#
$(EXT2OS2_BASE)\misc\sync.exe : $(UTILS_SRC) $(EXT2OS2_BASE)\vfsapi\vfsapi.lib
        @cd $(EXT2OS2_BASE)\misc
        @$(MAKE) sync.exe
        @cd $(EXT2OS2_BASE)\distrib


#
# vfsapi/vfsapi.lib
#
$(EXT2OS2_BASE)\vfsapi\vfsapi.lib : $(EXT2OS2_BASE)\vfsapi\vfsapi.dll

#
# vfsapi/vfsapi.dll
#
$(EXT2OS2_BASE)\vfsapi\vfsapi.dll : $(VFSAPI_SRC)
        @cd $(EXT2OS2_BASE)\vfsapi
        @$(MAKE)
        @cd $(EXT2OS2_BASE)\distrib

#
# doc/ext2-os2/ext2-os2.htm
#
$(EXT2OS2_BASE)\doc\ext2-os2\ext2-os2.htm : $(EXT2OS2_BASE)\doc\ext2-os2\ext2-os2.inf

#
# doc/ext2-os2/ext2-os2.inf
#
$(EXT2OS2_BASE)\doc\ext2-os2\ext2-os2.inf : $(EXT2OS2_DOC_SRC)
        @cd $(EXT2OS2_BASE)\doc\ext2-os2
        @$(MAKE)
        @cd $(EXT2OS2_BASE)\distrib

#
# ext2flt/ext2flt.flt
#
$(EXT2OS2_BASE)\ext2flt\ext2flt.flt : $(EXT2FLT_SRC)
        @cd $(EXT2OS2_BASE)\ext2flt
        @$(MAKE)
        @cd $(EXT2OS2_BASE)\distrib

#
# uext2/uext2.dll
#
$(EXT2OS2_BASE)\uext2\uext2.dll : $(UTILS_SRC)
        @cd $(EXT2OS2_BASE)\uext2
        @$(MAKE)
        @cd $(EXT2OS2_BASE)\distrib

#
# skeleton/device/dev32.sym
#
$(EXT2OS2_BASE)\skeleton\device\dev32.sym : $(EXT2OS2_BASE)\skeleton\device\dev32.sys


#
# skeleton/device/dev32.sys
#
$(EXT2OS2_BASE)\skeleton\device\dev32.sys : $(EXT2OS2_BASE)\mwdd32\mwdd32.sys
        @cd $(EXT2OS2_BASE)\skeleton\device
        @$(MAKE)
        @cd $(EXT2OS2_BASE)\distrib

#
# skeleton/ses/sec32.sym
#
$(EXT2OS2_BASE)\skeleton\ses\sec32.sym : $(EXT2OS2_BASE)\skeleton\ses\sec32.sys


#
# skeleton/ses/sec32.sys
#
$(EXT2OS2_BASE)\skeleton\ses\sec32.sys : $(EXT2OS2_BASE)\mwdd32\mwdd32.sys
        @cd $(EXT2OS2_BASE)\skeleton\ses
        @$(MAKE)
        @cd $(EXT2OS2_BASE)\distrib

$(E2FSPROGS)\e2fsck\e2fsck.exe : $(E2FSPROGS_FILES)
        @cd $(E2FSPROGS)\e2fsck
        @$(MAKE) -f makefile.os2
        @cd $(EXT2OS2_BASE)\distrib

$(E2FSPROGS)\debugfs\debugfs.exe : $(E2FSPROGS_FILES)
        @cd $(E2FSPROGS)\debugfs
        @$(MAKE) -f makefile.os2
        @cd $(EXT2OS2_BASE)\distrib

$(E2FSPROGS)\misc\mke2fs.exe : $(E2FSPROGS_FILES)
        @cd $(E2FSPROGS)\misc
        @$(MAKE) -f makefile.os2
        @cd $(EXT2OS2_BASE)\distrib

$(E2FSPROGS)\misc\badblocks.exe : $(E2FSPROGS_FILES)
        @cd $(E2FSPROGS)\misc
        @$(MAKE) -f makefile.os2
        @cd $(EXT2OS2_BASE)\distrib
