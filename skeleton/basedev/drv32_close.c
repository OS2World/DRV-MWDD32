//
// $Header: d:\\32bits\\ext2-os2\\skeleton\\basedev\\rcs\\drv32_close.c,v 1.2 1997/03/16 12:51:42 Willm Exp $
//

// 32 bits OS/2 device driver and IFS support. Provides 32 bits kernel 
// services (DevHelp) and utility functions to 32 bits OS/2 ring 0 code 
// (device drivers and installable file system drivers).
// Copyright (C) 1995, 1996, 1997  Matthieu WILLM (willm@ibm.net)
//
// This program is free software; you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation; either version 2 of the License, or
// (at your option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with this program; if not, write to the Free Software
// Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.

#define INCL_DOS
#define INCL_DOSERRORS
#define INCL_NOPMAPI
#include <os2.h>

#include <os2/types.h>
#include <os2/StackToFlat.h>
#include <os2/DevHlp32.h>
#include <os2/reqpkt32.h>

#include "drv32_entry_points.h"

extern int open_count;

int drv32_close(PTR16 reqpkt) {
    int                  status;
    int                  rc;
    struct reqpkt_close *request;

    status = 0;
    if ((rc = DevHlp32_VirtToLin(reqpkt, __StackToFlat(&request))) == NO_ERROR) {
        open_count --;
    } else {
        status |= STERR + ERROR_I24_INVALID_PARAMETER;
    }

    return (status | STDON);
}
