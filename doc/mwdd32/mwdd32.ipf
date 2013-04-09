.*
.* $Header: d:\\32bits\\ext2-os2\\doc\\mwdd32\\rcs\\mwdd32.ipf,v 1.8 1997/03/15 17:13:14 Willm Exp $
.*

.* 32 bits OS/2 device driver and IFS support. Provides 32 bits kernel 
.* services (DevHelp) and utility functions to 32 bits OS/2 ring 0 code 
.* (device drivers and installable file system drivers).
.* Copyright (C) 1995, 1996, 1997  Matthieu WILLM (willm@ibm.net)
.*
.* This program is free software; you can redistribute it and/or modify
.* it under the terms of the GNU General Public License as published by
.* the Free Software Foundation; either version 2 of the License, or
.* (at your option) any later version.
.*
.* This program is distributed in the hope that it will be useful,
.* but WITHOUT ANY WARRANTY; without even the implied warranty of
.* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
.* GNU General Public License for more details.
.*
.* You should have received a copy of the GNU General Public License
.* along with this program; if not, write to the Free Software
.* Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.

:userdoc.


:title. 32 bits OS/2 device driver and IFS support.

:h1.Title page

:font facename=Helv size=24x20.

.ce 32 bits OS/2 device driver and IFS support
.ce MWDD32 VERSION 1.70
.ce Copyright (C) Matthieu WILLM 1995, 1996, 1997 (willm@ibm.net)

:font facename=default size=0x0.

.*******************************************************************************
.*** I - Introduction                                                        ***
.*******************************************************************************

.* .im intro.im


.*******************************************************************************
.*** II - Copyright information                                              ***
.*******************************************************************************

.im copyright.im

.*******************************************************************************
.*** III - 32 bits ring 0 considerations                                     ***
.*******************************************************************************

.im ring0.im    

.*******************************************************************************
.*** III- DevHlp32 calls description                                         ***
.*******************************************************************************

.im devhlp32.im

.*******************************************************************************
.*** IV - fsh32 calls description                                            ***
.*******************************************************************************

.im fsh32.im

.*******************************************************************************
.*** V - Utility functions description.                                     ***
.*******************************************************************************

.im utils.im

.*******************************************************************************
.*** VI- Sample 32 bits device drivers                                      ***
.*******************************************************************************

.im samples.im

.*******************************************************************************
.*** VI- History of changes.                                                ***
.*******************************************************************************

.im changes.im

:euserdoc.
