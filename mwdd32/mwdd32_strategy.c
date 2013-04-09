//
// $Header: d:\\32bits\\ext2-os2\\mwdd32\\rcs\\mwdd32_strategy.c,v 1.2 1997/03/16 12:44:29 Willm Exp $
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
#include <mwdd32_entry_points.h>
#include <reqpkt32.h>

static int (*driver_routing_table[32])() = {
    mwdd32_invalid_command,  // 0 = Init
    mwdd32_invalid_command,  // 1 = Media Check
    mwdd32_invalid_command,  // 2 = Build BPB
    mwdd32_invalid_command,  // 3 = Reserved
    mwdd32_invalid_command,  // 4 = Read
    mwdd32_invalid_command,  // 5 = Non-Destruct Read NoWait
    mwdd32_invalid_command,  // 6 = Input Status
    mwdd32_invalid_command,  // 7 = Input Flush
    mwdd32_invalid_command,  // 8 = Write
    mwdd32_invalid_command,  // 9 = Write w/Verify
    mwdd32_invalid_command,  // A = Output Status
    mwdd32_invalid_command,  // B = Output Flush
    mwdd32_invalid_command,  // C = Reserved
    mwdd32_open,             // D = Device Open (R/M)
    mwdd32_close,            // E = Device Close (R/M)
    mwdd32_invalid_command,  // F = Removable Media (R/M)
    mwdd32_ioctl,            // 10 = Generic Ioctl
    mwdd32_invalid_command,  // 11 = Reset Media
    mwdd32_invalid_command,  // 12 = Get Logical Drive Map
    mwdd32_invalid_command,  // 13 = Set Logical Drive Map
    mwdd32_invalid_command,  // 14 = DeInstall
    mwdd32_invalid_command,  // 15 = 
    mwdd32_invalid_command,  // 16 = Get # Partitions
    mwdd32_invalid_command,  // 17 = Get Unit map
    mwdd32_invalid_command,  // 18 = No caching read
    mwdd32_invalid_command,  // 19 = No caching write
    mwdd32_invalid_command,  // 1A = No caching write w/Verify
    mwdd32_init_base,        // 1B = Initialize
    mwdd32_shutdown,         // 1C = Shutdown
    mwdd32_invalid_command,  // 1D = Get DCS/VCS
    mwdd32_invalid_command,  // 1E = ???
    mwdd32_init_complete     // 1F = Init Complete
};


/*
 * This is the 32 bits strategy entry point
 */
int DRV32ENTRY mwdd32_strategy(PTR16 reqpkt, int index) {
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
