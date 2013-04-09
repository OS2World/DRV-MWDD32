//
// $Header: d:\\32bits\\ext2-os2\\util\\rcs\\ctype.c,v 1.2 1997/03/16 13:21:33 Willm Exp $
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

/* From:                                                           */
/* ctype.c (emx+gcc) -- Copyright (c) 1990-1993 by Eberhard Mattes */

#if defined(MWDD32) || defined(FSD32)
#include <os2/types.h>
#include <os2/ctype.h>
#else
#include <ctype.h>
#endif
unsigned char _ctype[257] =
          {
/* -1 */    0,
/* 00 */    _CNTRL,
/* 01 */    _CNTRL,
/* 02 */    _CNTRL,
/* 03 */    _CNTRL,
/* 04 */    _CNTRL,
/* 05 */    _CNTRL,
/* 06 */    _CNTRL,
/* 07 */    _CNTRL,
/* 08 */    _CNTRL,
/* 09 */    _CNTRL|_SPACE,
/* 0A */    _CNTRL|_SPACE,
/* 0B */    _CNTRL|_SPACE,
/* 0C */    _CNTRL|_SPACE,
/* 0D */    _CNTRL|_SPACE,
/* 0E */    _CNTRL,
/* 0F */    _CNTRL,
/* 10 */    _CNTRL,
/* 11 */    _CNTRL,
/* 12 */    _CNTRL,
/* 13 */    _CNTRL,
/* 14 */    _CNTRL,
/* 15 */    _CNTRL,
/* 16 */    _CNTRL,
/* 17 */    _CNTRL,
/* 18 */    _CNTRL,
/* 19 */    _CNTRL,
/* 1A */    _CNTRL,
/* 1B */    _CNTRL,
/* 1C */    _CNTRL,
/* 1D */    _CNTRL,
/* 1E */    _CNTRL,
/* 1F */    _CNTRL,
/* 20 */    _PRINT|_SPACE,
/* 21 */    _PRINT|_PUNCT,
/* 22 */    _PRINT|_PUNCT,
/* 23 */    _PRINT|_PUNCT,
/* 24 */    _PRINT|_PUNCT,
/* 25 */    _PRINT|_PUNCT,
/* 26 */    _PRINT|_PUNCT,
/* 27 */    _PRINT|_PUNCT,
/* 28 */    _PRINT|_PUNCT,
/* 29 */    _PRINT|_PUNCT,
/* 2A */    _PRINT|_PUNCT,
/* 2B */    _PRINT|_PUNCT,
/* 2C */    _PRINT|_PUNCT,
/* 2D */    _PRINT|_PUNCT,
/* 2E */    _PRINT|_PUNCT,
/* 2F */    _PRINT|_PUNCT,
/* 30 */    _PRINT|_DIGIT|_XDIGIT,
/* 31 */    _PRINT|_DIGIT|_XDIGIT,
/* 32 */    _PRINT|_DIGIT|_XDIGIT,
/* 33 */    _PRINT|_DIGIT|_XDIGIT,
/* 34 */    _PRINT|_DIGIT|_XDIGIT,
/* 35 */    _PRINT|_DIGIT|_XDIGIT,
/* 36 */    _PRINT|_DIGIT|_XDIGIT,
/* 37 */    _PRINT|_DIGIT|_XDIGIT,
/* 38 */    _PRINT|_DIGIT|_XDIGIT,
/* 39 */    _PRINT|_DIGIT|_XDIGIT,
/* 3A */    _PRINT|_PUNCT,
/* 3B */    _PRINT|_PUNCT,
/* 3C */    _PRINT|_PUNCT,
/* 3D */    _PRINT|_PUNCT,
/* 3E */    _PRINT|_PUNCT,
/* 3F */    _PRINT|_PUNCT,
/* 40 */    _PRINT|_PUNCT,
/* 41 */    _PRINT|_UPPER|_XDIGIT,
/* 42 */    _PRINT|_UPPER|_XDIGIT,
/* 43 */    _PRINT|_UPPER|_XDIGIT,
/* 44 */    _PRINT|_UPPER|_XDIGIT,
/* 45 */    _PRINT|_UPPER|_XDIGIT,
/* 46 */    _PRINT|_UPPER|_XDIGIT,
/* 47 */    _PRINT|_UPPER,
/* 48 */    _PRINT|_UPPER,
/* 49 */    _PRINT|_UPPER,
/* 4A */    _PRINT|_UPPER,
/* 4B */    _PRINT|_UPPER,
/* 4C */    _PRINT|_UPPER,
/* 4D */    _PRINT|_UPPER,
/* 4E */    _PRINT|_UPPER,
/* 4F */    _PRINT|_UPPER,
/* 50 */    _PRINT|_UPPER,
/* 51 */    _PRINT|_UPPER,
/* 52 */    _PRINT|_UPPER,
/* 53 */    _PRINT|_UPPER,
/* 54 */    _PRINT|_UPPER,
/* 55 */    _PRINT|_UPPER,
/* 56 */    _PRINT|_UPPER,
/* 57 */    _PRINT|_UPPER,
/* 58 */    _PRINT|_UPPER,
/* 59 */    _PRINT|_UPPER,
/* 5A */    _PRINT|_UPPER,
/* 5B */    _PRINT|_PUNCT,
/* 5C */    _PRINT|_PUNCT,
/* 5D */    _PRINT|_PUNCT,
/* 5E */    _PRINT|_PUNCT,
/* 5F */    _PRINT|_PUNCT,
/* 60 */    _PRINT|_PUNCT,
/* 61 */    _PRINT|_LOWER|_XDIGIT,
/* 62 */    _PRINT|_LOWER|_XDIGIT,
/* 63 */    _PRINT|_LOWER|_XDIGIT,
/* 64 */    _PRINT|_LOWER|_XDIGIT,
/* 65 */    _PRINT|_LOWER|_XDIGIT,
/* 66 */    _PRINT|_LOWER|_XDIGIT,
/* 67 */    _PRINT|_LOWER,
/* 68 */    _PRINT|_LOWER,
/* 69 */    _PRINT|_LOWER,
/* 6A */    _PRINT|_LOWER,
/* 6B */    _PRINT|_LOWER,
/* 6C */    _PRINT|_LOWER,
/* 6D */    _PRINT|_LOWER,
/* 6E */    _PRINT|_LOWER,
/* 6F */    _PRINT|_LOWER,
/* 70 */    _PRINT|_LOWER,
/* 71 */    _PRINT|_LOWER,
/* 72 */    _PRINT|_LOWER,
/* 73 */    _PRINT|_LOWER,
/* 74 */    _PRINT|_LOWER,
/* 75 */    _PRINT|_LOWER,
/* 76 */    _PRINT|_LOWER,
/* 77 */    _PRINT|_LOWER,
/* 78 */    _PRINT|_LOWER,
/* 79 */    _PRINT|_LOWER,
/* 7A */    _PRINT|_LOWER,
/* 7B */    _PRINT|_PUNCT,
/* 7C */    _PRINT|_PUNCT,
/* 7D */    _PRINT|_PUNCT,
/* 7E */    _PRINT|_PUNCT,
/* 7F */    _CNTRL,
/* 80 */    0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
/* 90 */    0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
/* A0 */    0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
/* B0 */    0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
/* C0 */    0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
/* D0 */    0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
/* E0 */    0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
/* F0 */    0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
          };
