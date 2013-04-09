//
// $Header: d:\\32bits\\ext2-os2\\mwdd32\\rcs\\mwdd32_ioctl.c,v 1.6 1997/03/16 12:44:29 Willm Exp $
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

#define INCL_DOS
#define INCL_DOSERRORS
#define INCL_NOPMAPI
#include <os2.h>

#include <os2/types.h>
#include <os2/StackToFlat.h>
#include <os2/DevHlp32.h>
#include <reqpkt32.h>
#include <mwdd32_ioctl.h>

#include "mwdd32_entry_points.h"
#include "mwdd32.h"

struct DevHelp32 DevHlp32 = {
    DEVHELP32_MAGIC,
    DEVHELP32_VERSION,
    {
        DevHlp32_SaveMessage,
        DevHlp32_InternalError,
        DevHlp32_VMAlloc,
        DevHlp32_VMFree,
        DevHlp32_VMLock,
        DevHlp32_VMUnlock,
        DevHlp32_VirtToLin,
        DevHlp32_ProcBlock,
        DevHlp32_ProcRun,
        DevHlp32_LinToPageList,
        DevHlp32_Security,
        DevHlp32_Yield,
        DevHlp32_GetInfoSegs,
	vsprintf,
        __mwdd32_strtoul,
        __mwdd32_atol,
        __mwdd32_strupr,
        __mwdd32_strpbrk,
        __mwdd32_fnmatch,
        __mwdd32_strtol,
	sec32_attach_ses,
	DevHlp32_setIRQ,
	DevHlp32_EOI,
	DevHlp32_UnSetIRQ,
	DevHlp32_PageListToLin,
	DevHlp32_AllocGDTSelector,
        DevHlp32_FreeGDTSelector,
        DevHlp32_AttachDD,
        DevHlp32_GetDosVar,
	DevHlp32_VerifyAccess,
	DevHlp32_CloseEventSem,
	DevHlp32_OpenEventSem,
	DevHlp32_PostEventSem,
	DevHlp32_ResetEventSem
    }
};

int mwdd32_ioctl(PTR16 reqpkt) {
    int                  rc;
    int                  status ;
    struct reqpkt_ioctl *request;
    void                *parm;
    void                *data;
    char                 lock_parm[12];
    char                 lock_data[12];
    ULONG                PgCount;

    status = 0;
    if ((rc = DevHlp32_VirtToLin(reqpkt, __StackToFlat(&request))) == NO_ERROR) {
        if (request->cat == MWDD32_IOCTL_CATEGORY) {
            switch(request->func) {
                /*
                 * Calls an IFS's fs32_init() entry point at ring 0
                 */
                case MWDD32_IOCTL_FUNCTION_INIT_FSD :
                    if ((rc = DevHlp32_VirtToLin(request->parm, __StackToFlat(&parm))) == NO_ERROR) {
                        if ((rc = DevHlp32_VirtToLin(request->data, __StackToFlat(&data))) == NO_ERROR) {
                            rc = DevHlp32_VMLock(VMDHL_WRITE | VMDHL_LONG | VMDHL_VERIFY, parm, sizeof(union mwdd32_ioctl_int_fsd_parm), (void *)-1, __StackToFlat(lock_parm), __StackToFlat(&PgCount));
                            if ((rc == NO_ERROR) || (rc == ERROR_NOBLOCK)) {
                                rc = DevHlp32_VMLock(VMDHL_WRITE | VMDHL_LONG | VMDHL_VERIFY, data, sizeof(union mwdd32_ioctl_int_fsd_data), (void *)-1, __StackToFlat(lock_data), __StackToFlat(&PgCount));
                                if ((rc == NO_ERROR) || (rc == ERROR_NOBLOCK)) {
                                    /*
                                     * OK now we can safely access both parm and data
                                     */
                                    union mwdd32_ioctl_int_fsd_parm *pparm = (union mwdd32_ioctl_int_fsd_parm *)parm;
                                    union mwdd32_ioctl_int_fsd_data *pdata = (union mwdd32_ioctl_int_fsd_data *)data;


                                    if (pparm->input.magic_in == INIT_FSD_MAGIC_IN) {
                                        void *fs32_init_parms;
                                        if ((rc = DevHlp32_VirtToLin(pdata->input.fs32_init_parms, __StackToFlat(&fs32_init_parms))) == NO_ERROR) {
                                            if ((rc = (int)mwdd32_export_devhelp32(pdata->input.pTKSSBase, pdata->input.pDevHelp32)) == NO_ERROR) {
                                                pparm->output.magic_out    = INIT_FSD_MAGIC_OUT;
                                                pdata->output.fs32_init_rc = pdata->input.fs32_init(fs32_init_parms);
                                            } else {
                                                pparm->output.magic_out     = INIT_FSD_MAGIC_OUT;
                                                pdata->output.fs32_init_rc  = 0;
                                                status                     |=  STERR + ERROR_I24_INVALID_PARAMETER;
                                            }
                                        } else {
                                            pparm->output.magic_out     = INIT_FSD_MAGIC_OUT;
                                            pdata->output.fs32_init_rc  = rc;
                                            status                     |=  STERR + ERROR_I24_INVALID_PARAMETER;

                                        }
                                    } else {
                                        pparm->output.magic_out    = INIT_FSD_MAGIC_OUT;
                                        pdata->output.fs32_init_rc = ERROR_INVALID_PARAMETER;
                                        status                    |=  STERR + ERROR_I24_INVALID_PARAMETER;
                                    }

                                    if ((rc = DevHlp32_VMUnlock(__StackToFlat(lock_data))) == NO_ERROR) {
                                        /*
                                         * no special processing here
                                         */
                                    } else {
                                        /*
                                         * error while unlocking request->data
                                         */
                                        status |=  STERR + ERROR_I24_GEN_FAILURE;
                                    }
                                } else {
                                    /*
                                     * error while locking request->data
                                     */
                                    status |= STERR + ERROR_I24_INVALID_PARAMETER;
                                }
                                if ((rc = DevHlp32_VMUnlock(__StackToFlat(lock_parm))) == NO_ERROR) {
                                    /*
                                     * no special processing
                                     */
                                } else {
                                    /*
                                     * error while unlocking request->parm
                                     */
                                   status |= STERR + ERROR_I24_GEN_FAILURE;
                                }
                            } else {
                                /*
                                 * error while locking request->parm
                                 */
                                status |= STERR + ERROR_I24_INVALID_PARAMETER;
                            }
                        } else {
                            /*
                             * error while thunking request->data
                             */
                            status |= STERR + ERROR_I24_INVALID_PARAMETER;
                        }
                    } else {
                        /*
                         * error while thunking request->parm
                         */
                        status |= STERR + ERROR_I24_INVALID_PARAMETER;
                    }
                    break;






                /*
                 * Calls an DEVICE device driver device_init() entry point at ring 0
                 */
                case MWDD32_IOCTL_FUNCTION_INIT_DEVICE :
                    if ((rc = DevHlp32_VirtToLin(request->parm, __StackToFlat(&parm))) == NO_ERROR) {
                        if ((rc = DevHlp32_VirtToLin(request->data, __StackToFlat(&data))) == NO_ERROR) {
                            rc = DevHlp32_VMLock(VMDHL_WRITE | VMDHL_LONG | VMDHL_VERIFY, parm, sizeof(union mwdd32_ioctl_int_fsd_parm), (void *)-1, __StackToFlat(lock_parm), __StackToFlat(&PgCount));
                            if ((rc == NO_ERROR) || (rc == ERROR_NOBLOCK)) {
                                rc = DevHlp32_VMLock(VMDHL_WRITE | VMDHL_LONG | VMDHL_VERIFY, data, sizeof(union mwdd32_ioctl_int_fsd_data), (void *)-1, __StackToFlat(lock_data), __StackToFlat(&PgCount));
                                if ((rc == NO_ERROR) || (rc == ERROR_NOBLOCK)) {
                                    /*
                                     * OK now we can safely access both parm and data
                                     */
                                    union mwdd32_ioctl_init_device_parm *pparm = (union mwdd32_ioctl_init_device_parm *)parm;
                                    union mwdd32_ioctl_init_device_data *pdata = (union mwdd32_ioctl_init_device_data *)data;


                                    if (pparm->input.magic_in == INIT_DEVICE_MAGIC_IN) {
                                        if ((rc = (int)mwdd32_export_devhelp32(pdata->input.pTKSSBase, pdata->input.pDevHelp32)) == NO_ERROR) {
                                            pparm->output.magic_out      = INIT_DEVICE_MAGIC_OUT;
                                            pdata->output.device_init_rc = pdata->input.device_init(pdata->input.reqpkt);
                                        } else {
                                            pparm->output.magic_out       = INIT_DEVICE_MAGIC_OUT;
                                            pdata->output.device_init_rc  = 0;
                                            status                       |=  STERR + ERROR_I24_INVALID_PARAMETER;
                                        }
                                    } else {
                                        pparm->output.magic_out      = INIT_DEVICE_MAGIC_OUT;
                                        pdata->output.device_init_rc = ERROR_INVALID_PARAMETER;
                                        status                      |= STERR + ERROR_I24_INVALID_PARAMETER;
                                    }

                                    if ((rc = DevHlp32_VMUnlock(__StackToFlat(lock_data))) == NO_ERROR) {
                                        /*
                                         * no special processing here
                                         */
                                    } else {
                                        /*
                                         * error while unlocking request->data
                                         */
                                        status |=  STERR + ERROR_I24_GEN_FAILURE;
                                    }
                                } else {
                                    /*
                                     * error while locking request->data
                                     */
                                    status |= STERR + ERROR_I24_INVALID_PARAMETER;
                                }
                                if ((rc = DevHlp32_VMUnlock(__StackToFlat(lock_parm))) == NO_ERROR) {
                                    /*
                                     * no special processing
                                     */
                                } else {
                                    /*
                                     * error while unlocking request->parm
                                     */
                                   status |= STERR + ERROR_I24_GEN_FAILURE;
                                }
                            } else {
                                /*
                                 * error while locking request->parm
                                 */
                                status |= STERR + ERROR_I24_INVALID_PARAMETER;
                            }
                        } else {
                            /*
                             * error while thunking request->data
                             */
                            status |= STERR + ERROR_I24_INVALID_PARAMETER;
                        }
                    } else {
                        /*
                         * error while thunking request->parm
                         */
                        status |= STERR + ERROR_I24_INVALID_PARAMETER;
                    }
                    break;


                /*
                 * Invalid ioctl function code
                 */
                default:
                    status |= STERR + ERROR_I24_BAD_COMMAND;
                    break;
            } /* end switch */
        } else {
            /*
             * invalid category
             */
            status |= STERR + ERROR_I24_BAD_COMMAND;
        }
    } else {
        /*
         * error while thunking reqpkt
         */
        status |= STERR + ERROR_I24_INVALID_PARAMETER;
    }
    return (status | STDON);
}
