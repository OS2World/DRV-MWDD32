#
# $Header: d:\\32bits\\ext2-os2\\rcs\\makefile,v 1.2 1997/03/15 16:21:39 Willm Exp $
#

# 32 bits Linux ext2 file system driver for OS/2 WARP - Allows OS/2 to
# access your Linux ext2fs partitions as normal drive letters.
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


all:
        @cd distrib
        @$(MAKE)
        @cd ..

clean:
        cd fsh32
        nmake clean
        cd ..\mwdd32
        nmake clean
        cd ..\doc\mwdd32
        nmake clean
        cd ..\..\doc\ext2-os2
        nmake clean
        cd ..\..\distrib
        nmake clean
        cd ..\skeleton\ifs
        nmake clean
        cd ..\..\skeleton\basedev
        nmake clean
        cd ..\..
        nmake -f makefile.ext2-os2 clean
        cd console
        nmake clean
        cd ..\misc
        nmake clean
        cd ..\uext2
        nmake clean
        cd ..\vfsapi
        nmake clean
        cd ..\ext2flt
        nmake -f makefile.msc clean
        cd ..\skeleton\device
        nmake clean
        cd ..\..\skeleton\ses
        nmake clean
        cd ..\..\minifsd
        nmake clean
        cd ..\microfsd
        nmake clean
        cd ..\e2fsprogs-1.10
        nmake -f makefile.os2 clean



