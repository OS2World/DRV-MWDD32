//
// $Header: d:\\32bits\\ext2-os2\\devhlp32\\rcs\\DevHlp32_AllocGDTSelector.c,v 1.3 1997/03/15 16:38:23 Willm Exp $
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
#include <string.h>
#include <os2/types.h>
#include <os2/StackToFlat.h>
#include <os2/DevHlp32.h>

extern int DH32ENTRY DevHlp32_AllocOneGDTSelector(
                    unsigned short *psel               /* eax !!! STACK BASED !!! */
                   );

int DH32ENTRY DevHlp32_AllocGDTSelector(unsigned short *psel, int count) {
    int            rc;
    unsigned short sel;             
    int            i;

    i  = 0;
    rc = NO_ERROR;
    while ((rc == NO_ERROR) && (i < count)) {
        rc = DevHlp32_AllocOneGDTSelector(&sel);
        if (rc == NO_ERROR) {
            psel[i++] = sel;
        }
    }

    /*
     * In case of error we should free successfuly allocated GDT selectors
     */
    if (rc != NO_ERROR) {
        while (i) DevHlp32_FreeGDTSelector(psel[--i]);
    }

    return rc;
}
