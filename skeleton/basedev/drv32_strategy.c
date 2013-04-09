//
// $Header: d:\\32bits\\ext2-os2\\skeleton\\basedev\\rcs\\drv32_strategy.c,v 1.3 1997/03/16 12:51:42 Willm Exp $
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
#define INCL_DOS
#define INCL_NOPMAPI
#include <os2.h>

#include <os2/types.h>
#include <os2/devhlp32.h>
#include <reqpkt32.h>

#include "drv32_entry_points.h"

static int (*driver_routing_table[32])() = {
    drv32_invalid_command,  // 0 = Init
    drv32_invalid_command,  // 1 = Media Check
    drv32_invalid_command,  // 2 = Build BPB
    drv32_invalid_command,  // 3 = Reserved
    drv32_read,             // 4 = Read
    drv32_invalid_command,  // 5 = Non-Destruct Read NoWait
    drv32_invalid_command,  // 6 = Input Status
    drv32_invalid_command,  // 7 = Input Flush
    drv32_write,            // 8 = Write
    drv32_invalid_command,  // 9 = Write w/Verify
    drv32_invalid_command,  // A = Output Status
    drv32_invalid_command,  // B = Output Flush
    drv32_invalid_command,  // C = Reserved
    drv32_open,             // D = Device Open (R/M)
    drv32_close,            // E = Device Close (R/M)
    drv32_invalid_command,  // F = Removable Media (R/M)
    drv32_ioctl,            // 10 = Generic Ioctl
    drv32_invalid_command,  // 11 = Reset Media
    drv32_invalid_command,  // 12 = Get Logical Drive Map
    drv32_invalid_command,  // 13 = Set Logical Drive Map
    drv32_invalid_command,  // 14 = DeInstall
    drv32_invalid_command,  // 15 = 
    drv32_invalid_command,  // 16 = Get # Partitions
    drv32_invalid_command,  // 17 = Get Unit map
    drv32_invalid_command,  // 18 = No caching read
    drv32_invalid_command,  // 19 = No caching write
    drv32_invalid_command,  // 1A = No caching write w/Verify
    drv32_init_base,        // 1B = Initialize
    drv32_shutdown,         // 1C = Shutdown
    drv32_invalid_command,  // 1D = Get DCS/VCS
    drv32_invalid_command,  // 1E = ???
    drv32_init_complete     // 1F = Init Complete
};


/*
 * This is the 32 bits strategy entry point
 */
int DRV32ENTRY drv32_strategy(PTR16 reqpkt, int index) {
    int status;

    if (index < sizeof(driver_routing_table) / sizeof(*driver_routing_table)) {
        /*
         * Valid command received
         */
        status = driver_routing_table[index](reqpkt);
    } else {
        /*
         * Invalid command received
         */
        status = STDON + STERR + ERROR_I24_INVALID_PARAMETER;
    }
    return status;
}
