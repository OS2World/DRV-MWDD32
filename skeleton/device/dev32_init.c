//
// $Header: d:\\32bits\\ext2-os2\\skeleton\\device\\rcs\\dev32_init.c,v 1.2 1997/03/16 13:07:14 Willm Exp $
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

#define INCL_DOSERRORS
#define INCL_NOPMAPI
#include <os2.h>

#include <string.h>

#include <os2/types.h>
#include <os2/StackToFlat.h>
#include <os2/DevHlp32.h>
#include <os2/reqpkt32.h>

#include "dev32.h"

extern unsigned short codeend;
extern unsigned short dataend;
extern PTR16          DevHelp2;


extern char code32_end;
extern char data32_end;

extern void begin_code32(void);
extern int  begin_data32;

int LockSegments(void) {
    APIRET rc;
    ULONG  PgCount;
    char   lock[12];

    /*
     * Locks DGROUP into physical memory
     */
    if ((rc = DevHlp32_VMLock(
                        VMDHL_LONG | VMDHL_WRITE | VMDHL_VERIFY,
                        &begin_data32,
                        (ULONG)(&data32_end) - (ULONG)(&begin_data32),
                        (void *)-1,
                        __StackToFlat(lock),
                        __StackToFlat(&PgCount))) == NO_ERROR) {
        /*
         * Locks CODE32 into physical memory
         */
        if ((rc = DevHlp32_VMLock(
                            VMDHL_LONG | VMDHL_VERIFY,
                            (void *)begin_code32,
                            (ULONG)(&code32_end) - (ULONG)begin_code32,
                            (void *)-1,
                            __StackToFlat(lock),
                            __StackToFlat(&PgCount))) == NO_ERROR) {
            /*
             * Nothing else to do ...
             */
        }
    }
    return rc;
}


extern char banner[];



/*
 * Variable required to use DevHlp32 calls
 */
struct DevHelp32 DevHelp32 = {DEVHELP32_MAGIC, DEVHELP32_VERSION, };
void *TKSSBase;

int dev32_init(PTR16 reqpkt) {
    int                 quiet = 0;
    int                 status;
    int                 rc;
    struct reqpkt_init *request;
    char               *tmp;
    char               *szParm;
    unsigned short      tmpsel;

    /*
     * Initialize request status
     */
    status = 0;

        /*
         * Now we convert the 16:16 request packet pointer to FLAT
         */
        if ((rc = DevHlp32_VirtToLin(reqpkt, __StackToFlat(&request))) == NO_ERROR) {
            /*
             * Now we convert the 16:16 command line pointer to FLAT
             */
            if ((rc = DevHlp32_VirtToLin(request->u.input.initarg, __StackToFlat(&szParm))) == NO_ERROR) {
                    strupr(szParm);
                    for (tmp = strpbrk(szParm, "-/"); tmp; tmp = strpbrk(tmp, "-/")) {
  		        tmp ++;
                        //
                        // Quiet initialization.
                        //
                        if (strncmp(tmp, "Q", sizeof("Q") - 1) == 0) {
                            quiet = 1;
                            continue;
                        }
                    }

                    if ((rc = LockSegments()) == NO_ERROR) {
			if (!quiet)
     		 	    DevHlp32_SaveMessage(banner, strlen(banner) + 1);
                        request->u.output.codeend = codeend;
                        request->u.output.dataend = dataend;
                    } else {
                        /*
                         * couldn't lock 32 bits segments
                         */
                        status |= STERR + ERROR_I24_QUIET_INIT_FAIL;
                    }
            } else {
                /*
                 * Error while thunking command line pointer
                 */
                status |= STERR + ERROR_I24_QUIET_INIT_FAIL;
            }
        } else {
            /*
             * Error while thunking reqpkt
             */
            status |= STERR + ERROR_I24_QUIET_INIT_FAIL;
        }

    return (status | STDON);
}

