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
#include <libgnomevfs/gnome-vfs-mime-handlers.h>
#include <libgnomevfs/gnome-vfs-mime-monitor.h>
#include <libgnomevfs/gnome-vfs-application-registry.h>

/* ------------------------------------------------------------------------- */

#define GNOME_VFS_TYPE_VFS_URI (vfs2perl_gnome_vfs_uri_get_type ())
GType vfs2perl_gnome_vfs_uri_get_type (void) G_GNUC_CONST;

#define GNOME_VFS_TYPE_VFS_HANDLE (vfs2perl_gnome_vfs_handle_get_type ())
GType vfs2perl_gnome_vfs_handle_get_type (void) G_GNUC_CONST;

#define GNOME_VFS_TYPE_VFS_MONITOR_HANDLE (vfs2perl_gnome_vfs_monitor_handle_get_type ())
GType vfs2perl_gnome_vfs_monitor_handle_get_type (void) G_GNUC_CONST;

#define GNOME_VFS_TYPE_VFS_DIRECTORY_HANDLE (vfs2perl_gnome_vfs_directory_handle_get_type ())
GType vfs2perl_gnome_vfs_directory_handle_get_type (void) G_GNUC_CONST;

#define GNOME_VFS_TYPE_VFS_ASYNC_HANDLE (vfs2perl_gnome_vfs_async_handle_get_type ())
GType vfs2perl_gnome_vfs_async_handle_get_type (void) G_GNUC_CONST;

/* ------------------------------------------------------------------------- */

#include "vfs2perl-gtypes.h"
#include "vfs2perl-version.h"

/* i'm just guessing here.  if you get a message about failed assertions
 * that something is a GFlags type in GnomeVFSDirectory.t, then you probably
 * need to set this to include your version.
 */
#if !VFS_CHECK_VERSION (2, 1, 0)
# define VFS2PERL_BROKEN_FILE_PERMISSIONS
# undef GNOME_VFS_TYPE_VFS_FILE_PERMISSIONS
# define GNOME_VFS_TYPE_VFS_FILE_PERMISSIONS (_vfs2perl_gnome_vfs_file_permissions_get_type ())
  GType _vfs2perl_gnome_vfs_file_permissions_get_type (void) G_GNUC_CONST;
#endif

#include "vfs2perl-autogen.h"

/* ------------------------------------------------------------------------- */

SV * newSVGnomeVFSFileSize (GnomeVFSFileSize size);
GnomeVFSFileSize SvGnomeVFSFileSize (SV *size);

SV * newSVGnomeVFSFileOffset (GnomeVFSFileOffset offset);
GnomeVFSFileOffset SvGnomeVFSFileOffset (SV *offset);

/* ------------------------------------------------------------------------- */

typedef const char GnomeVFSApplication;

const char * SvGnomeVFSApplication (SV *object);
SV * newSVGnomeVFSApplication (const char *app_id);

typedef const char GnomeVFSMimeType;

const char * SvGnomeVFSMimeType (SV *object);
SV * newSVGnomeVFSMimeType (const char *mime_type);

/* ------------------------------------------------------------------------- */

SV * newSVGnomeVFSMimeApplication (GnomeVFSMimeApplication *application);
GnomeVFSMimeApplication * SvGnomeVFSMimeApplication (SV *object);

GnomeVFSFileInfo * SvGnomeVFSFileInfo (SV *object);
SV * newSVGnomeVFSFileInfo (GnomeVFSFileInfo *info);

SV * newSVGnomeVFSXferProgressInfo (GnomeVFSXferProgressInfo *info);

/* ------------------------------------------------------------------------- */

GList * SvPVGList (SV *ref);

GList * SvGnomeVFSURIGList (SV *ref);

char ** SvEnvArray (SV *ref);

SV * newSVGnomeVFSFileInfoGList (GList *list);

SV * newSVGnomeVFSGetFileInfoResultGList (GList *list);

SV * newSVGnomeVFSFindDirectoryResultGList (GList *list);

/* ------------------------------------------------------------------------- */

#endif /* _VFS2PERL_H_ */
