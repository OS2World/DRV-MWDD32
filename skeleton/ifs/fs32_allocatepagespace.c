//
// $Header: D:/32bits/ext2-os2/skeleton/ifs/rcs/fs32_allocatepagespace.c,v 1.2 1997/03/16 13:01:55 Willm Exp Willm $
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

#ifdef __IBMC__
#pragma strings(readonly)
#endif


#define INCL_DOS
#define INCL_DOSERRORS
#define INCL_NOPMAPI
#include <os2.h>

#include <os2/types.h>
#include <os2/StackToFlat.h>
#include <os2/fsd32.h>
#include <os2/devhlp32.h>

/*
 * struct fs32_allocatepagespace_parms {
 *     PTR16 psffsi,                  ptr to fs independent SFT
 *     PTR16 psffsd,                  ptr to fs dependent SFT
 *     unsigned long     ulSize,      new size
 *     unsigned long     ulWantContig contiguous chunk size
 * };
 */
int FS32ENTRY fs32_allocatepagespace(struct fs32_allocatepagespace_parms *parms) {
    struct sffsi32 *psffsi;
    union  sffsd32 *psffsd;
    int             rc;


    if ((rc = DevHlp32_VirtToLin(parms->psffsi, __StackToFlat(&psffsi))) == NO_ERROR) {
        if ((rc = DevHlp32_VirtToLin(parms->psffsd, __StackToFlat(&psffsd))) == NO_ERROR) {
            /*
             * Insert your code here ...
             */
            rc = ERROR_NOT_SUPPORTED;
        }
    }

    return rc;
}
