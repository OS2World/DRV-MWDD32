//
// $Header: d:\\32bits\\ext2-os2\\include\\os2\\rcs\\fsh32.h,v 1.4 1997/03/15 18:10:17 Willm Exp $
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

#ifndef __fsh32_h
#define __fsh32_h

#include <builtin.h>

#include <os2/types.h>
#include <os2/devhlp32.h>
#include <os2/fsd32.h>

extern void FSH32ENTRY fsh32_yield(void);
#if 0
extern void FSH32ENTRY fsh32_interr(char *msg, int size);
#else
INLINE void FSH32ENTRY fsh32_interr(char *msg, int size) {
    DevHlp32_InternalError(msg, size);
}
#endif

/*
 * For the moment, the fsh32_semXXX routines are just poor hacks...
 */

INLINE int fsh32_semwait(void *sem, int timeout)
{
    int rc = NO_ERROR;

    _disable();
    while (*(int *)sem) {
        rc = DevHlp32_ProcBlock((unsigned long)sem, timeout, 0);
        if (rc != NO_ERROR) {
            break;
        }
        _disable();
    }
    _enable();

    return rc;
}

#if 0
INLINE void fsh32_semwait(void *sem, int timeout)
{
    int rc;

    if (*(int *)sem)
           rc = __fsh32_semwait(sem);
    else
           rc = NO_ERROR;

    return rc;
}
#endif

INLINE int fsh32_semrequest(void *sem, int timeout)
{
    int rc = NO_ERROR;

    _disable();
    while (__lxchg((volatile int *)sem, 1)) {
        rc = DevHlp32_ProcBlock((unsigned long)sem, timeout, 0);
        if (rc != NO_ERROR) {
            break;
        }
        _disable();
    }
    _enable();

    return rc;
}

INLINE int fsh32_semset(void *sem)
{
    int rc;
    int res;

    _disable();
    res = __lxchg((volatile int *)sem, 1);
    _enable();

    if (res)
        rc = ERROR_EXCL_SEM_ALREADY_OWNED;
    else
       rc = NO_ERROR;

    return rc;
}

INLINE void fsh32_semclear(void *sem)
{
        *(int *)sem = 0;
        DevHlp32_ProcRun((unsigned long)sem);
}


int FSH32ENTRY fsh32_dovolio(
                   int operation,               /* ebp + 8  */
                   int fAllowed,                /* ebp + 12 */
                   unsigned short hVPB,                    /* ebp + 16 */
                   void *pData,                 /* ebp + 20 */
                   unsigned long *pcSec,        /* ebp + 24 */
                   unsigned long  iSec          /* ebp + 28 */
                  );

/*  Flags for operation
 */
#define DVIO_OPREAD     0x0000          /*  no bit on => readi                */
#define DVIO_OPWRITE    0x0001          /*  ON => write else read             */
#define DVIO_OPBYPASS   0x0002          /*  ON => cache bypass else no bypass */
#define DVIO_OPVERIFY   0x0004          /*  ON => verify after write          */
#define DVIO_OPHARDERR  0x0008          /*  ON => return hard errors directly */
#define DVIO_OPWRTHRU   0x0010          /*  ON => write thru                  */
#define DVIO_OPNCACHE   0x0020          /*  ON => don't cache data            */
#define DVIO_OPRESMEM   0x0040          /*  ON => don't lock this memory      */

/*  Flags for fAllowed
 */
#define DVIO_ALLFAIL    0x0001          /*  FAIL allowed                      */
#define DVIO_ALLABORT   0x0002          /*  ABORT allowed                     */
#define DVIO_ALLRETRY   0x0004          /*  RETRY allowed                     */
#define DVIO_ALLIGNORE  0x0008          /*  IGNORE allowed                    */
#define DVIO_ALLACK     0x0010          /*  ACK allowed                       */



int FSH32ENTRY fsh32_segalloc(
                              int flags,                /* ebp + 8  */
                              int length,               /* ebp + 12 */
                              unsigned short *pSel      /* ebp + 16 */
                             );

#define SA_FLDT         0x0001          /*  ON => alloc LDT else GDT          */
#define SA_FSWAP        0x0002          /*  ON => swappable memory            */

#define SA_FRINGMASK    0x6000          /*  mask for isolating ring           */
#define SA_FRING0       0x0000          /*  ring 0                            */
#define SA_FRING1       0x2000          /*  ring 1                            */
#define SA_FRING2       0x4000          /*  ring 2                            */
#define SA_FRING3       0x6000          /*  ring 3                            */

#pragma pack(1)
union fsh32_qsysinfo_parms {
    unsigned short max_sector_size;        // level 1 info
    struct {
        unsigned short uid;
        unsigned short pid;
        unsigned short pdb;
    } process_info;                        // level 2
    unsigned short abs_tid;                // level 3
    unsigned char  verify_on_write;        // level 4
};
#pragma pack()

int FSH32ENTRY fsh32_qsysinfo(
                              int level,                        /* ebp + 8  */
                              union fsh32_qsysinfo_parms *info  /* ebp + 12 */
                             );


int FSH32ENTRY fsh32_getvolparm(
                                unsigned short  hVPB,       /* ebp + 8  */
                                PTR16          *ppvpfsi,    /* ebp + 12 */
                                PTR16          *ppvpfsd     /* ebp + 16 */
                               );

int FSH32ENTRY fsh32_devioctl(
    unsigned short FSDRaisedFlag ,   /* ebp + 8  */
    unsigned long hDev,              /* ebp + 12 */
    unsigned short sfn,              /* ebp + 16 */
    unsigned short cat,              /* ebp + 20 */
    unsigned short func,             /* ebp + 24 */
    PTR16 pParm,                     /* ebp + 28 */
    unsigned short cbParm,           /* ebp + 32 */
    PTR16 pData,                     /* ebp + 36 */
    unsigned short cbData            /* ebp + 40 */
);

extern  int FSH32ENTRY fsh32_findduphvpb(
                                         unsigned short hVPB,         /* ebp + 8  */
                                         unsigned short *phVPB        /* ebp + 12 */
                                        );

extern  int FSH32ENTRY2 fsh32_forcenoswap(
                                          unsigned short selector	/* ax */
                                         );


extern int FSH32ENTRY fsh32_addshare(
                                     PTR16           pName,		/* ebp + 8  */
                                     unsigned short  mode,		/* ebp + 12 */
                                     unsigned short  hVPB,		/* ebp + 16 */
                                     unsigned long  *phShare		/* ebp + 20 */
                                    );

extern void FSH32ENTRY2 fsh32_removeshare(
                                          unsigned long hShare	/* eax */
                                         );

extern int FSH32ENTRY2 fsh32_setvolume(
                                       unsigned short hVPB,     /*  ax */
                                       unsigned long  fControl  /* edx */
                                      );

extern void FSH32ENTRY fsh32_ioboost(
                                     void
                                    );

#endif

