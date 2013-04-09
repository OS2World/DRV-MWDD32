//
// $Header: d:\\32bits\\ext2-os2\\skeleton\\basedev\\rcs\\drv32_irq.c,v 1.2 1997/03/16 12:51:42 Willm Exp $
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

#include <os2.h>
#include <os2/types.h>
#include <os2/devhlp32.h>

int drv32_irq_count = 0;

unsigned short irq_level;

/*
 * sample 32 bits IRQ entry point
 */
int DRV32ENTRY drv32_irq(void) {

    /*
     * Dummy interrupt processing
     */
    drv32_irq_count ++;

    /*
     * Sends EOI to the interrupt controller
     */
    DevHlp32_EOI(irq_level);

    /*
     * Returns to the 16:16 stub IRQ routine
     */
    return 0;
}

