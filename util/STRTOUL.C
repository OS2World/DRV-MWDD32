//
// $Header: d:\\32bits\\ext2-os2\\util\\rcs\\STRTOUL.C,v 1.2 1997/03/16 13:21:33 Willm Exp $
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

/* From:                                                             */
/* strtoul.c (emx+gcc) -- Copyright (c) 1990-1995 by Eberhard Mattes */

#ifndef MWDD32
#include <stdlib.h>
#include <limits.h>
#include <ctype.h>
#include <errno.h>
#else
#define NULL 0
#include <os2/types.h>
#include <os2/ctype.h>
#include <limits.h>
#endif

#ifndef MWDD32
unsigned long strtoul (const char *string, char **end_ptr, int radix)
#else
unsigned long DH32ENTRY __mwdd32_strtoul (const char *string, char **end_ptr, int radix)
#endif
{
  const unsigned char *s;
  char neg;
  unsigned long result;

  s = string;
  while (isspace (*s))
    ++s;

  neg = 0;
  if (*s == '-')
    {
      neg = 1; ++s;
    }
  else if (*s == '+')
    ++s;

  if ((radix == 0 || radix == 16) && s[0] == '0'
      && (s[1] == 'x' || s[1] == 'X'))
    {
      radix = 16; s += 2;
    }
  if (radix == 0)
    radix = (s[0] == '0' ? 8 : 10);

  result = 0;                   /* Keep the compiler happy */
  if (radix >= 2 && radix <= 36)
    {
      unsigned long n, max1, max2;
      enum {no_number, ok, overflow} state;
      unsigned char c;

      max1 = ULONG_MAX / radix;
      max2 = ULONG_MAX - max1 * radix;
      n = 0; state = no_number;
      for (;;)
        {
          c = *s;
          if (c >= '0' && c <= '9')
            c = c - '0';
          else if (c >= 'A' && c <= 'Z')
            c = c - 'A' + 10;
          else if (c >= 'a' && c <= 'z')
            c = c - 'a' + 10;
          else
            break;
          if (c >= radix)
            break;
          if (n >= max1 && (n > max1 || (unsigned long)c > max2))
            state = overflow;
          if (state != overflow)
            {
              n = n * radix + (unsigned long)c;
              state = ok;
            }
          ++s;
        }
      switch (state)
        {
        case no_number:
          result = 0;
          s = string;
          /* Don't set errno!? */
          break;
        case ok:
          result = (neg ? -n : n);
          break;
        case overflow:
          result = ULONG_MAX;
#ifndef MWDD32
          errno = ERANGE;
#endif
          break;
        }
    }
  else
    {
      result = 0;
#ifndef MWDD32
      errno = EDOM;
#endif
    }
  if (end_ptr != NULL)
    *end_ptr = (char *)s;
  return result;
}
