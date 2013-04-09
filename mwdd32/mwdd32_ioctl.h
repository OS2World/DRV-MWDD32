//
// $Header: d:\\32bits\\ext2-os2\\mwdd32\\rcs\\mwdd32_ioctl.h,v 1.3 1997/03/16 12:44:29 Willm Exp $
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

#ifndef __mwdd32_ioctl_h
#define __mwdd32_ioctl_h

#define MWDD32_IOCTL_CATEGORY            0xF0

/*
 * Function 1 : init FSD
 * input :
 *     parm - magic number (dword)
 *     data - FLAT  address of fs32_init()
 *            16:16 pointer to FS_INIT parameters
 * output :
 *     parm - magic number               (dword)
 *     data - return code of fs32_init() (dword)
 */
#define MWDD32_IOCTL_FUNCTION_INIT_FSD   0x41
#define INIT_FSD_MAGIC_IN  0xAAAAAAAA
#define INIT_FSD_MAGIC_OUT 0xBBBBBBBB
    union mwdd32_ioctl_int_fsd_parm {
        struct {
           unsigned long magic_in;  // INIT_FSD_MAGIC_IN
        } input;
        struct {
           unsigned long magic_out; // INIT_FSD_MAGIC_OUT
        } output;
    };
    union mwdd32_ioctl_int_fsd_data {
        struct {
           int(* FS32INIT  fs32_init)(void *);
           PTR16  fs32_init_parms;
           void **pTKSSBase;
           struct DevHelp32 *pDevHelp32;
        } input;
        struct {
           int fs32_init_rc;
        } output;
    };


/*
 * Function 2 : init device
 * input :
 *     parm - magic number (dword)
 *     data - FLAT  address of device_init()
 *            16:16 pointer to INIT request packet
 * output :
 *     parm - magic number                 (dword)
 *     data - return code of device_init() (dword)
 */
#define MWDD32_IOCTL_FUNCTION_INIT_DEVICE   0x42
#define INIT_DEVICE_MAGIC_IN  0xAAAAAAAA
#define INIT_DEVICE_MAGIC_OUT 0xBBBBBBBB
    union mwdd32_ioctl_init_device_parm {
        struct {
           unsigned long magic_in;  // INIT_DEVICE_MAGIC_IN
        } input;
        struct {
           unsigned long magic_out; // INIT_DEVICE_MAGIC_OUT
        } output;
    };
    union mwdd32_ioctl_init_device_data {
        struct {
           int(* DEV32ENTRY device_init)(PTR16);
           PTR16  reqpkt;
           void **pTKSSBase;
           struct DevHelp32 *pDevHelp32;
        } input;
        struct {
           int device_init_rc;
        } output;
    };

#endif

