//
// $Header: d:\\32bits\\ext2-os2\\util\\rcs\\strtok.c,v 1.3 1997/03/16 13:21:33 Willm Exp $
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

/* From :                                                           */
/* strtok.c (emx+gcc) -- Copyright (c) 1990-1995 by Eberhard Mattes */

#if !defined( FSD32) && !defined(MWDD32)
#include <sys/emx.h>
#endif
#include <string.h>

char *strtok (char *string1, const char *string2)
{
  char table[256];
  unsigned char *p, *result;
#if defined (__MT__)
  struct _thread *tp = _thread ();
#define next (tp->_th_strtok_ptr)
#else
    static unsigned char *next = NULL;
#endif
  if (string1 != NULL)
    p = (unsigned char *)string1;
  else
    {
      if (next == NULL)
        return NULL;
      p = next;
    }
  memset (table, 0, 256);
  while (*string2 != 0)
    table[(unsigned char)*string2++] = 1;
  table[0] = 0;
  while (table[*p])
    ++p;
  result = p;
  table[0] = 1;
  while (!table[*p])
    ++p;
  if (*p == 0)
    {
      if (p == result)
        {
          next = NULL;
          return NULL;
        }
    }
  else
    *p++ = 0;
  next = p;
  return (char *)result;
}
