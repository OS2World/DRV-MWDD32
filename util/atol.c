//
// $Header: d:\\32bits\\ext2-os2\\util\\rcs\\atol.c,v 1.2 1997/03/16 13:21:33 Willm Exp $
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

/* From:                                                          */
/* atol.c (emx+gcc) -- Copyright (c) 1990-1993 by Eberhard Mattes */

#ifndef MWDD32
#include <stdlib.h>
#else
#include <os2.h>
#include <os2/types.h>
#include <os2/devhlp32.h>
#endif

#ifndef MWDD32
long atol (const char *string)
#else
long DH32ENTRY __mwdd32_atol (const char *string)
#endif
{
  long n;
  char neg;
  
  n = 0; neg = 0;
  while (*string == ' ' || *string == '\t') ++string;
  if (*string == '+')
    ++string;
  else if (*string == '-')
    {
      ++string; neg = 1;
    }
  while (*string >= '0' && *string <= '9')
    {
      n = n * 10 + (*string - '0');
      ++string;
    }
  return (neg ? -n : n);
}
