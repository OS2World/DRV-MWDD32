//
// $Header: D:/32bits/ext2-os2/skeleton/ifs/rcs/fs32_init.c,v 1.3 1997/03/16 13:01:55 Willm Exp Willm $
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


#include <string.h>

#include <os2/types.h>
#include <os2/StackToFlat.h>
#include <os2/fsd32.h>
#include <os2/devhlp32.h>




char msg[]="\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n";
char msg1[]="\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n";
extern char banner[];


struct DevHelp32 DevHelp32 = {DEVHELP32_MAGIC, DEVHELP32_VERSION,};
void  *TKSSBase;
unsigned long DevHelp2;
int _dllentry = 0;

/*
 * struct fs32_init_parms {
 *     PTR16 pMiniFSD;
 *     PTR16 DevHelp;
 *     PTR16 cmdline;
 * };
 */
int FS32INIT fs32_init(struct fs32_init_parms *parms) {


    /*
     * Insert your code here ...
     */

    DevHlp32_SaveMessage(msg, strlen(msg) + 1);
    DevHlp32_SaveMessage(banner, strlen(banner)+1);
    DevHlp32_SaveMessage(msg1, strlen(msg1) + 1);

    return NO_ERROR;
}
