/*
 * Copyright (C) 2003 by the gtk2-perl team
 * 
 * This library is free software; you can redistribute it and/or
 * modify it under the terms of the GNU Lesser General Public
 * License as published by the Free Software Foundation; either
 * version 2.1 of the License, or (at your option) any later version.
 * 
 * This library is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 * Lesser General Public License for more details.
 * 
 * You should have received a copy of the GNU Lesser General Public
 * License along with this library; if not, write to the Free Software
 * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
 *
 * $Header$
 */

#ifndef _VFS2PERL_H_
#define _VFS2PERL_H_

#include <gtk2perl.h>

#include <libgnomevfs/gnome-vfs.h>
#include <libgnomevfs/gnome-vfs-uri.h>
#include <libgnomevfs/gnome-vfs-handle.h>

#include "vfs2perl-gtypes.h"
#include "vfs2perl-version.h"
#include "vfs2perl-autogen.h"

/* ------------------------------------------------------------------------- */

SV * newSVGnomeVFSFileSize (GnomeVFSFileSize size);
GnomeVFSFileSize SvGnomeVFSFileSize (SV *size);

SV * newSVGnomeVFSFileOffset (GnomeVFSFileOffset offset);
GnomeVFSFileOffset SvGnomeVFSFileOffset (SV *offset);

/* ------------------------------------------------------------------------- */

const char * SvGnomeVFSApplication (SV *object);
SV * newSVGnomeVFSApplication (const char *app_id);

GnomeVFSURI * SvGnomeVFSURI (SV *object);
SV * newSVGnomeVFSURI (GnomeVFSURI *uri);

GnomeVFSFileInfo * SvGnomeVFSFileInfo (SV *object);
SV * newSVGnomeVFSFileInfo (GnomeVFSFileInfo *info);

SV * newSVGnomeVFSXferProgressInfo (GnomeVFSXferProgressInfo *info);

/* ------------------------------------------------------------------------- */

GnomeVFSHandle * SvGnomeVFSHandle (SV *object);
SV * newSVGnomeVFSHandle (GnomeVFSHandle *handle);

GnomeVFSDirectoryHandle * SvGnomeVFSDirectoryHandle (SV *object);
SV * newSVGnomeVFSDirectoryHandle (GnomeVFSDirectoryHandle *handle);

GnomeVFSAsyncHandle * SvGnomeVFSAsyncHandle (SV *object);
SV * newSVGnomeVFSAsyncHandle (GnomeVFSAsyncHandle *handle);

GnomeVFSMonitorHandle * SvGnomeVFSMonitorHandle (SV *object);
SV * newSVGnomeVFSMonitorHandle (GnomeVFSMonitorHandle *handle);

/* ------------------------------------------------------------------------- */

GList * SvPVGList (SV *ref);

GList * SvGnomeVFSURIGList (SV *ref);

SV * newSVGnomeVFSFileInfoGList (GList *list);

SV * newSVGnomeVFSGetFileInfoResultGList (GList *list);

/* ------------------------------------------------------------------------- */

#endif /* _VFS2PERL_H_ */
