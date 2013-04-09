//
// $Header: d:\\32bits\\ext2-os2\\skeleton\\ses\\rcs\\sec32_callbacks.c,v 1.2 1997/03/16 13:13:43 Willm Exp $
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
#include <secure.h>

#include <os2/types.h>
#include <os2/StackToFlat.h>
#include <os2/devhlp32.h>

#include "sec32.h"

struct SecImp_s SecurityImports = {
   SEC_IMPORT_MAJOR_VERSION,  		// USHORT siVersionMajor;
   SEC_IMPORT_MINOR_VERSION, 		// USHORT siVersionMinor;
   OPEN_PRE, 				// ULONG (* CallType OPEN_PRE) (PSZ pszPath, ULONG fsOpenFlags, ULONG fsOpenMode, ULONG SFN);
   OPEN_POST, 				// ULONG (* CallType OPEN_POST)(PSZ pszPath, ULONG fsOpenFlags, ULONG fsOpenMode, ULONG SFN, ULONG Action, ULONG RC);
   0, 					// ULONG (* CallType READ_PRE) (ULONG SFN, PUCHAR pBuffer, ULONG cbBuf);
   0, 					// VOID  (* CallType READ_POST)(ULONG SFN, PUCHAR PBUFFER, ULONG CBBYTESREAD,ULONG RC);
   0, 					// ULONG (* CallType WRITE_PRE)(ULONG SFN, PUCHAR pBuffer, ULONG cbBuf);
   0, 					// VOID  (* CallType WRITE_POST)(ULONG SFN, PUCHAR PBUFFER, ULONG CBBUF,
                                 	//        ULONG cbBytesWritten, ULONG RC);
   0, 					// VOID  (* CallType CLOSE)( ULONG SFN);
   0, 					// VOID  (* CallType CHGFILEPTR)(ULONG SFN, PLONG  SeekOff, PUSHORT SeekType, PLONG Absolute,PLONG pLogical);
   0, 					// ULONG (* CallType DELETE_PRE) ( PSZ pszPath );
   0, 					// VOID  (* CallType DELETE_POST)( PSZ pszPath, ULONG RC );
   0, 					// ULONG (* CallType MOVE_PRE)  ( PSZ pszNewPath, PSZ pszOldPath );
   0, 					// VOID  (* CallType MOVE_POST) ( PSZ pszNewPath, PSZ pszOldPath, ULONG RC );
   0, 					// ULONG (* CallType LOADEROPEN)( PSZ pszPath, ULONG SFN);
   0, 					// ULONG (* CallType GETMODULE) ( PSZ pszPath );
   0, 					// ULONG (* CallType EXECPGM)   ( PSZ pszPath, PCHAR pchArgs );
   0, 					// ULONG (* CallType FINDFIRST) ( PFINDPARMS pParms);
   0, 					// ULONG (* CallType CALLGATE16)(VOID);
   0, 					// ULONG (* CallType CALLGATE32)(VOID);
   0, 					// ULONG (* CallType SETFILESIZE)(ULONG SFN, PULONG pSize);
   0, 					// ULONG (* CallType QUERYFILEINFO)( ULONG  SFN,
	                                //        PUCHAR pBuffer,
             		                //        ULONG  cbBuffer,
                          	        //        ULONG  InfoLevel );
   0, 					// ULONG (* CallType MAKEDIR)   ( PSZ pszPath);
   0, 					// ULONG (* CallType CHANGEDIR) ( PSZ pszPath);
   0, 					// ULONG (* CallType REMOVEDIR) ( PSZ pszPath);
   0, 					// ULONG (* CallType FINDNEXT) ( PFINDPARMS pParms);
   0, 					// ULONG (* CallType FINDFIRST3X) ( ULONG ulSrchHandle, PSZ pszPath);  //DGE02
   0, 					// VOID  (* CallType FINDCLOSE) ( ULONG ulSearchHandle );              //DGE02
   0, 					// ULONG (* CallType FINDFIRSTNEXT3X) (ULONG ulSrchHandle,PSZ pszFile);//DGE02
   0, 					// ULONG (* CallType FINDCLOSE3X) ( ULONG ulSrchHandle );              //DGE02
   0, 					// VOID  (* CallType EXECPGMPOST) (PSZ pszPath, PCHAR pchArgs, ULONG NewPID);
   0, 					// ULONG (* CallType CREATEVDM)   (PSZ pszProgram, PSZ pszArgs);
   0, 					// VOID  (* CallType CREATEVDMPOST) (int rc);
   0, 					// ULONG (* CallType SETDATETIME) ( PDATETIME pDateTimeBuf );
   0, 					// ULONG (* CallType SETFILEINFO) ( ULONG  SFN,
		                        //            PUCHAR pBuffer,
                		        //            ULONG  cbBuffer,
                                	//	    ULONG  InfoLevel );
   0, 					// ULONG (* CallType SETFILEMODE) ( PSZ     pszPath,
		                        //            PUSHORT pNewAttribute );
   0, 					// ULONG (* CallType SETPATHINFO) ( PSZ    pszPathName,
                                    	// 	ULONG  InfoLevel,
                                    	//	PUCHAR pBuffer,
                                    	//	ULONG  cbBuffer,
                                    	//	ULONG  InfoFlags );
   0, 					// ULONG (* CallType DEVIOCTL) ( ULONG  SFN,
		                        //       ULONG  Category, /* Category 8 and 9 only.*/
                		        //       ULONG  Function,
                                	//	 PUCHAR pParmList,
		                        //         ULONG  cbParmList,
                		        //         PUCHAR pDataArea,
                                	//	 ULONG  cbDataArea,
		                        //         ULONG  PhysicalDiskNumber ); /* Category 9 only */
   0, 					// ULONG (* CallType TRUSTEDPATHCONTROL) ( VOID );

   /*
    *  The following are all SCS (SES) API audit hooks.
    */
   0, 					// VOID (* CallType STARTEVENT) ( ULONG AuditRC,
                                  	// PSESSTARTEVENT pSESStartEvent );
   0, 					// VOID (* CallType WAITEVENT) ( ULONG AuditRC,
		                        //         PSESEVENT pSESEventInfo,
                  		        //       ULONG ulTimeout );
   0, 					// VOID (* CallType RETURNEVENTSTATUS) ( ULONG AuditRC,
                                        // PSESEVENT pSESEventInfo );
   0, 					// VOID (* CallType REGISTERDAEMON) ( ULONG AuditRC,
                                        // ULONG ulDaemonID,
                                        // ULONG ulEventList );
   0, 					// VOID (* CallType RETURNWAITEVENT) ( ULONG AuditRC,
                                        // PSESEVENT pSESEventInfo,
                                        // ULONG ulTimeout );
   0, 					// VOID (* CallType CREATESUBJECTHANDLE) ( ULONG AuditRC,
                                        //   PSUBJECTINFO pSubjectInfo );
   0, 					// VOID (* CallType DELETESUBJECTHANDLE) ( ULONG AuditRC,
                                        //   HSUBJECT SubjectHandle );
   0, 					// VOID (* CallType SETSUBJECTHANDLE) ( ULONG AuditRC,
                                        // ULONG TargetSubject,
                                        // HSUBJECT SubjectHandle );
   0, 					// VOID (* CallType QUERYSUBJECTHANDLE) ( ULONG AuditRC,
                                        //  PID pid,
                                        //  ULONG TargetSubject,
                                        //  HSUBJECT SubjectHandle );
   0, 					// VOID (* CallType QUERYSUBJECTINFO) ( ULONG AuditRC,
                                        // PID pid,
                                        // ULONG TargetSubject,
                                        // PSUBJECTINFO pSubjectInfo );
   0, 					// VOID (* CallType QUERYSUBJECTHANDLEINFO) ( ULONG AuditRC,
                                        //      HSUBJECT SubjectHandle,
                                        //      PSUBJECTINFO pSubjectInfo );
   0, 					// VOID (* CallType SETCONTEXTSTATUS) ( ULONG AuditRC,
                                        // ULONG ContextStatus );
   0, 					// VOID (* CallType QUERYCONTEXTSTATUS) ( ULONG AuditRC,
                                        //  PID pid,
                                        //  ULONG ContextStatus );
   0, 					// VOID (* CallType SETSECURITYCONTEXT) ( ULONG AuditRC,
                                        //  PSECURITYCONTEXT pSecurityContext );
   0, 					// VOID (* CallType QUERYSECURITYCONTEXT) ( ULONG AuditRC,
                                        //    PID pid,
                                        //    PSECURITYCONTEXT pSecurityContext );
   0, 					// VOID (* CallType QUERYAUTHORITYID) ( ULONG  AuditRC,
                                        // PUCHAR szAuthorityTag,
                                        // ULONG  AuthorityID );
   0, 					// VOID (* CallType CREATEINSTANCEHANDLE) ( ULONG AuditRC,
                                        //    HSUBJECT SubjectHandle );
   0, 					// VOID (* CallType RESERVESUBJECTHANDLE) ( ULONG AuditRC,
                                        //    ULONG TargetSubject );
   0, 					// VOID (* CallType RELEASESUBJECTHANDLE) ( ULONG AuditRC,
                                        //    ULONG TargetSubject,
                                        //    HSUBJECT SubjectHandle );
   0, 					// VOID (* CallType QUERYPROCESSINFO) ( ULONG    AuditRC,
                                        // ULONG    ActionCode,
                                        // HSUBJECT CUH,
                                        // ULONG    ProcessCount,
                                        // PVOID    ProcessBuf );
   0, 					// VOID (* CallType KILLPROCESS) ( ULONG AuditRC,
                                        // PID idProcessID );
   0, 					// VOID (* CallType INACTIVITYNOTIFY) ( ULONG AuditRC,
                                        // ULONG ulTimeout );
   0, 					// VOID (* CallType CONTROLPROCESSCREATION) ( ULONG AuditRC,
                                        //      ULONG ulActionCode );
   0, 					// VOID (* CallType RESETTHREADCONTEXT) ( ULONG AuditRC,
                                        //  ULONG TargetConext );
   0, 					// VOID (* CallType CREATEHANDLENOTIFY) ( ULONG        AuditRC,
                                        //  PSUBJECTINFO pSubjectInfo );
   0, 					// VOID (* CallType DELETEHANDLENOTIFY) ( ULONG    AuditRC,
                                        //  HSUBJECT SubjectHandle );
   0, 					// VOID (* CallType CONTROLKBDMONITORS) ( ULONG  AuditRC,
                                        //  ULONG  ActionCode,
                                        //  ULONG  Status );
   /*
    *  End of SCS (SES) API audit hooks.
    */
} ;
