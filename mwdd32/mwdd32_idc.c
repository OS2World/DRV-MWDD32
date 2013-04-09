//
// $Header: d:\\32bits\\ext2-os2\\mwdd32\\rcs\\mwdd32_idc.c,v 1.6 1997/03/16 12:44:29 Willm Exp $
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

#include "mwdd32.h"

short mwdd32_export_devhelp32(void **pTKSSBase, struct DevHelp32 *pDevHelp32) {
    short rc;

    rc = ERROR_INVALID_PARAMETER;
    if (pTKSSBase) {
        /*
         * Updates TKSSBase
         */
        *pTKSSBase = TKSSBase;
   
        if ((pDevHelp32) && (pDevHelp32->magic == DEVHELP32_MAGIC)) {
            switch (pDevHelp32->version) {
	    	case 1:
		    memcpy(&(pDevHelp32->version_1), &(DevHlp32.version_1), sizeof(DevHlp32.version_1));
		    rc = NO_ERROR;
		    break;
		case 2:
		    memcpy(&(pDevHelp32->version_2), &(DevHlp32.version_2), sizeof(DevHlp32.version_2));
		    rc = NO_ERROR;
		    break;
		case 3:
		    memcpy(&(pDevHelp32->version_3), &(DevHlp32.version_3), sizeof(DevHlp32.version_3));
		    rc = NO_ERROR;
		    break;
		case 4:
		    memcpy(&(pDevHelp32->version_4), &(DevHlp32.version_4), sizeof(DevHlp32.version_4));
		    rc = NO_ERROR;
		    break;
		case 5:
		    memcpy(&(pDevHelp32->version_5), &(DevHlp32.version_5), sizeof(DevHlp32.version_5));
		    rc = NO_ERROR;
		    break;
		case 6:
		    memcpy(&(pDevHelp32->version_6), &(DevHlp32.version_6), sizeof(DevHlp32.version_6));
		    rc = NO_ERROR;
		    break;
		case 7:
		    memcpy(&(pDevHelp32->version_7), &(DevHlp32.version_7), sizeof(DevHlp32.version_7));
		    rc = NO_ERROR;
		    break;
                default:
		    break;
	    }
        }
    }
    return rc;
}

struct mwdd32_idc_parms {
    union {
        struct {
	    int zero;
	    int magic;
            int func;
            union {
                struct {
                    struct DevHelp32  *pDevHelp32;
                    void             **pTKSSBase;
                } func_1;
            };
        } new_interface;
        struct {
            void             **pTKSSBase;
            struct DevHelp32  *pDevHelp32;
        } old_interface;
    };   
};


/*
 * 32 bits IDC entry point
 */
unsigned long mwdd32_idc(struct mwdd32_idc_parms *parms) {
    unsigned long rc;

    parms = __StackToFlat(parms);

    rc = ERROR_INVALID_PARAMETER;
    if ((parms->new_interface.zero == 0) && (parms->new_interface.magic == 0x61153275)) {
        /*
         * this is a new post V1.00 interface
         */
        switch(parms->new_interface.func) {
   	    case 1:
                rc = (unsigned long)mwdd32_export_devhelp32(parms->new_interface.func_1.pTKSSBase, parms->new_interface.func_1.pDevHelp32);
                break;
            default :
                break;
        }
        rc &= 0xFFFF;
    } else {
        /*
         * this is the old V1.00 interface
         */
        rc  = (unsigned long)mwdd32_export_devhelp32(parms->old_interface.pTKSSBase, parms->old_interface.pDevHelp32);
        rc |= 0xFFFF0000;
    }
    return rc;
}

