//
// $Header: d:\\32bits\\ext2-os2\\util\\rcs\\strupr.c,v 1.2 1997/03/16 13:21:33 Willm Exp $
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

/* From:                                                            */
/* strupr.c (emx+gcc) -- Copyright (c) 1990-1995 by Eberhard Mattes */

#ifdef MWDD32
#include <os2.h>
#include <os2/types.h>
#include <os2/ctype.h>
#include <os2/devhlp32.h>
#else
#include <string.h>
#include <ctype.h>
#endif
#ifdef MWDD32
char * DH32ENTRY __mwdd32_strupr (char *string)
#else
char *_strupr (char *string)
#endif
{
  unsigned char *p;

  for (p = (unsigned char *)string; *p != 0; ++p)
    if (islower (*p))
      *p = (unsigned char)_toupper (*p);
  return string;
}
