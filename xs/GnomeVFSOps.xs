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

#include "vfs2perl.h"
#include <gperl_marshal.h>

/* ------------------------------------------------------------------------- */

GnomeVFSHandle *
SvGnomeVFSHandle (SV *object)
{
	MAGIC *mg;

	if (!object || !SvOK (object) || !SvROK (object) || !(mg = mg_find (SvRV (object), PERL_MAGIC_ext)))
		return NULL;

	return (GnomeVFSHandle *) mg->mg_ptr;
}

SV *
newSVGnomeVFSHandle (GnomeVFSHandle *handle)
{
	SV *rv;
	HV *stash;
	SV *object = (SV *) newHV ();

	sv_magic (object, 0, PERL_MAGIC_ext, (const char *) handle, 0);

	rv = newRV_noinc (object);
	stash = gv_stashpv ("Gnome2::VFS::Handle", 1);

	return sv_bless (rv, stash);
}

/* ------------------------------------------------------------------------- */

GnomeVFSMonitorHandle *
SvGnomeVFSMonitorHandle (SV *object)
{
	MAGIC *mg;

	if (!object || !SvOK (object) || !SvROK (object) || !(mg = mg_find (SvRV (object), PERL_MAGIC_ext)))
		return NULL;

	return (GnomeVFSMonitorHandle *) mg->mg_ptr;
}

SV *
newSVGnomeVFSMonitorHandle (GnomeVFSMonitorHandle *handle)
{
	SV *rv;
	HV *stash;
	SV *object = (SV *) newHV ();

	sv_magic (object, 0, PERL_MAGIC_ext, (const char *) handle, 0);

	rv = newRV_noinc (object);
	stash = gv_stashpv ("Gnome2::VFS::Monitor::Handle", 1);

	return sv_bless (rv, stash);
}

/* ------------------------------------------------------------------------- */

gboolean
vfs2perl_monitor_callback (GnomeVFSMonitorHandle *handle,
                           const gchar *monitor_uri,
                           const gchar *info_uri,
                           GnomeVFSMonitorEventType event_type,
                           GPerlCallback *callback)
{
	dGPERL_CALLBACK_MARSHAL_SP;
	int n;

	GPERL_CALLBACK_MARSHAL_INIT (callback);

	ENTER;
	SAVETMPS;

	PUSHMARK (SP);

	EXTEND (SP, 4);
	PUSHs (sv_2mortal (newSVGnomeVFSMonitorHandle (handle)));
	PUSHs (sv_2mortal (newSVGChar (monitor_uri)));
	PUSHs (sv_2mortal (newSVGChar (info_uri)));
	PUSHs (sv_2mortal (newSVGnomeVFSMonitorEventType (event_type)));
	if (callback->data)
		XPUSHs (sv_2mortal (newSVsv (callback->data)));

	PUTBACK;

	call_sv (callback->func, G_DISCARD);

	SPAGAIN;

	FREETMPS;
	LEAVE;
}

/* ------------------------------------------------------------------------- */

MODULE = Gnome2::VFS::Ops	PACKAGE = Gnome2::VFS	PREFIX = gnome_vfs_

=for object Gnome2::VFS::main

=cut

=for apidoc

Returns a GnomeVFSResult and a GnomeVFSHandle.

=cut
##  GnomeVFSResult gnome_vfs_open (GnomeVFSHandle **handle, const gchar *text_uri, GnomeVFSOpenMode open_mode)
void
gnome_vfs_open (class, text_uri, open_mode)
	const gchar *text_uri
	GnomeVFSOpenMode open_mode
    PREINIT:
	GnomeVFSResult result;
	GnomeVFSHandle *handle;
    PPCODE:
	result = gnome_vfs_open (&handle, text_uri, open_mode);
	EXTEND (sp, 2);
	PUSHs (sv_2mortal (newSVGnomeVFSResult (result)));
	PUSHs (sv_2mortal (newSVGnomeVFSHandle (handle)));


=for apidoc

Returns a GnomeVFSResult and a GnomeVFSHandle.

=cut
##  GnomeVFSResult gnome_vfs_create (GnomeVFSHandle **handle, const gchar *text_uri, GnomeVFSOpenMode open_mode, gboolean exclusive, guint perm) 
void
gnome_vfs_create (class, text_uri, open_mode, exclusive, perm)
	const gchar *text_uri
	GnomeVFSOpenMode open_mode
	gboolean exclusive
	guint perm
    PREINIT:
	GnomeVFSResult result;
	GnomeVFSHandle *handle;
    PPCODE:
	result = gnome_vfs_create (&handle, text_uri, open_mode, exclusive, perm);
	EXTEND (sp, 2);
	PUSHs (sv_2mortal (newSVGnomeVFSResult (result)));
	PUSHs (sv_2mortal (newSVGnomeVFSHandle (handle)));

##  GnomeVFSResult gnome_vfs_unlink (const gchar *text_uri) 
GnomeVFSResult
gnome_vfs_unlink (class, text_uri)
	const gchar *text_uri
    C_ARGS:
	text_uri

##  GnomeVFSResult gnome_vfs_move (const gchar *old_text_uri, const gchar *new_text_uri, gboolean force_replace) 
GnomeVFSResult
gnome_vfs_move (class, old_text_uri, new_text_uri, force_replace)
	const gchar *old_text_uri
	const gchar *new_text_uri
	gboolean force_replace
    C_ARGS:
	old_text_uri, new_text_uri, force_replace


=for apidoc

Returns a GnomeVFSResult and a boolean.

=cut
##  GnomeVFSResult gnome_vfs_check_same_fs (const gchar *source, const gchar *target, gboolean *same_fs_return) 
void
gnome_vfs_check_same_fs (class, source, target)
	const gchar *source
	const gchar *target
    PREINIT:
	GnomeVFSResult result;
	gboolean same_fs_return;
    PPCODE:
	result = gnome_vfs_check_same_fs (source, target, &same_fs_return);
	EXTEND (sp, 2);
	PUSHs (sv_2mortal (newSVGnomeVFSResult (result)));
	PUSHs (sv_2mortal (newSVuv (same_fs_return)));

##  GnomeVFSResult gnome_vfs_create_symbolic_link (GnomeVFSURI *uri, const gchar *target_reference) 
GnomeVFSResult
gnome_vfs_create_symbolic_link (class, uri, target_reference)
	GnomeVFSURI *uri
	const gchar *target_reference
    C_ARGS:
	uri, target_reference


=for apidoc

Returns a GnomeVFSResult and a GnomeVFSFileInfo.

=cut
##  GnomeVFSResult gnome_vfs_get_file_info (const gchar *text_uri, GnomeVFSFileInfo *info, GnomeVFSFileInfoOptions options) 
void
gnome_vfs_get_file_info (class, text_uri, options)
	const gchar *text_uri
	GnomeVFSFileInfoOptions options
    PREINIT:
	GnomeVFSResult result;
	GnomeVFSFileInfo *info;
    PPCODE:
	info = gnome_vfs_file_info_new ();
	result = gnome_vfs_get_file_info (text_uri, info, options);
	EXTEND (sp, 2);
	PUSHs (sv_2mortal (newSVGnomeVFSResult (result)));
	PUSHs (sv_2mortal (newSVGnomeVFSFileInfo (info)));
	gnome_vfs_file_info_unref (info);

##  GnomeVFSResult gnome_vfs_truncate (const gchar *text_uri, GnomeVFSFileSize length) 
GnomeVFSResult
gnome_vfs_truncate (class, text_uri, length)
	const gchar *text_uri
	GnomeVFSFileSize length
    C_ARGS:
	text_uri, length

##  GnomeVFSResult gnome_vfs_make_directory (const gchar *text_uri, guint perm) 
GnomeVFSResult
gnome_vfs_make_directory (class, text_uri, perm)
	const gchar *text_uri
	guint perm
    C_ARGS:
	text_uri, perm

##  GnomeVFSResult gnome_vfs_remove_directory (const gchar *text_uri) 
GnomeVFSResult
gnome_vfs_remove_directory (class, text_uri)
	const gchar *text_uri
    C_ARGS:
	text_uri

# --------------------------------------------------------------------------- #

MODULE = Gnome2::VFS::Ops	PACKAGE = Gnome2::VFS::Handle	PREFIX = gnome_vfs_

void
DESTROY (rv)
	SV *rv
    CODE:
	MAGIC *mg;

	if (!rv || !SvOK (rv) || !SvROK (rv) || !(mg = mg_find (SvRV (rv), PERL_MAGIC_ext)))
		return;

	sv_unmagic (SvRV (rv), PERL_MAGIC_ext);

##  GnomeVFSResult gnome_vfs_close (GnomeVFSHandle *handle) 
GnomeVFSResult
gnome_vfs_close (handle)
	GnomeVFSHandle *handle

=for apidoc

Returns a GnomeVFSResult, the number of bytes read and the buffer containing
the read content.

=cut
##  GnomeVFSResult gnome_vfs_read (GnomeVFSHandle *handle, gpointer buffer, GnomeVFSFileSize bytes, GnomeVFSFileSize *bytes_read) 
void
gnome_vfs_read (handle, bytes)
	GnomeVFSHandle *handle
	GnomeVFSFileSize bytes
    PREINIT:
	char *buffer;
	GnomeVFSResult result;
	GnomeVFSFileSize bytes_read = bytes;
    PPCODE:
	buffer = g_new0 (char, bytes);
	result = gnome_vfs_read (handle, buffer, bytes, &bytes_read);
	EXTEND (sp, 3);
	PUSHs (sv_2mortal (newSVGnomeVFSResult (result)));
	PUSHs (sv_2mortal (newSVuv (bytes_read)));
	PUSHs (sv_2mortal (newSVpv (buffer, bytes_read)));
	g_free (buffer);

##  GnomeVFSResult gnome_vfs_write (GnomeVFSHandle *handle, gconstpointer buffer, GnomeVFSFileSize bytes, GnomeVFSFileSize *bytes_written) 
GnomeVFSResult
gnome_vfs_write (handle, buffer, bytes)
	GnomeVFSHandle *handle
	char *buffer;
	GnomeVFSFileSize bytes
    PREINIT:
	GnomeVFSResult result;
	GnomeVFSFileSize bytes_written = bytes;
    PPCODE:
	result = gnome_vfs_write (handle, buffer, bytes, &bytes_written);
	EXTEND (sp, 3);
	PUSHs (sv_2mortal (newSVGnomeVFSResult (result)));
	PUSHs (sv_2mortal (newSVuv (bytes_written)));

##  GnomeVFSResult gnome_vfs_seek (GnomeVFSHandle *handle, GnomeVFSSeekPosition whence, GnomeVFSFileOffset offset) 
GnomeVFSResult
gnome_vfs_seek (handle, whence, offset)
	GnomeVFSHandle *handle
	GnomeVFSSeekPosition whence
	GnomeVFSFileOffset offset

=for apidoc

Returns a GnomeVFSResult and the offset.

=cut
##  GnomeVFSResult gnome_vfs_tell (GnomeVFSHandle *handle, GnomeVFSFileSize *offset_return) 
void
gnome_vfs_tell (handle)
	GnomeVFSHandle *handle
    PREINIT:
	GnomeVFSResult result;
	GnomeVFSFileSize offset_return;
    PPCODE:
	result = gnome_vfs_tell (handle, &offset_return);
	EXTEND (sp, 2);
	PUSHs (sv_2mortal (newSVGnomeVFSResult (result)));
	PUSHs (sv_2mortal (newSViv (offset_return)));

##  GnomeVFSResult gnome_vfs_get_file_info_from_handle (GnomeVFSHandle *handle, GnomeVFSFileInfo *info, GnomeVFSFileInfoOptions options) 
GnomeVFSResult
gnome_vfs_get_file_info_from_handle (handle, options)
	GnomeVFSHandle *handle
	GnomeVFSFileInfoOptions options
    ALIAS:
	Gnome2::VFS::Handle::get_file_info = 0
    PREINIT:
	GnomeVFSResult result;
	GnomeVFSFileInfo *info;
    PPCODE:
	info = gnome_vfs_file_info_new ();
	result = gnome_vfs_get_file_info_from_handle (handle, info, options);
	EXTEND (sp, 2);
	PUSHs (sv_2mortal (newSVGnomeVFSResult (result)));
	PUSHs (sv_2mortal (newSVGnomeVFSFileInfo (info)));
	g_free (info);

##  GnomeVFSResult gnome_vfs_truncate_handle (GnomeVFSHandle *handle, GnomeVFSFileSize length) 
GnomeVFSResult
gnome_vfs_truncate_handle (handle, length)
	GnomeVFSHandle *handle
	GnomeVFSFileSize length
    ALIAS:
	Gnome2::VFS::Handle::truncate = 0

# --------------------------------------------------------------------------- #

MODULE = Gnome2::VFS::Ops	PACKAGE = Gnome2::VFS::URI	PREFIX = gnome_vfs_uri_

=for apidoc

Returns a GnomeVFSResult and a GnomeVFSHandle.

=cut
##  GnomeVFSResult gnome_vfs_open_uri (GnomeVFSHandle **handle, GnomeVFSURI *uri, GnomeVFSOpenMode open_mode) 
void
gnome_vfs_open_uri (uri, open_mode)
	GnomeVFSURI *uri
	GnomeVFSOpenMode open_mode
    ALIAS:
	Gnome2::VFS::URI::open = 0
    PREINIT:
	GnomeVFSResult result;
	GnomeVFSHandle *handle;
    PPCODE:
	result = gnome_vfs_open_uri (&handle, uri, open_mode);
	EXTEND (sp, 2);
	PUSHs (sv_2mortal (newSVGnomeVFSResult (result)));
	PUSHs (sv_2mortal (newSVGnomeVFSHandle (handle)));

##  GnomeVFSResult gnome_vfs_create_uri (GnomeVFSHandle **handle, GnomeVFSURI *uri, GnomeVFSOpenMode open_mode, gboolean exclusive, guint perm) 
GnomeVFSResult
gnome_vfs_create_uri (uri, open_mode, exclusive, perm)
	GnomeVFSURI *uri
	GnomeVFSOpenMode open_mode
	gboolean exclusive
	guint perm
    ALIAS:
	Gnome2::VFS::URI::create = 0
    PREINIT:
	GnomeVFSResult result;
	GnomeVFSHandle *handle;
    PPCODE:
	result = gnome_vfs_create_uri (&handle, uri, open_mode, exclusive, perm);
	EXTEND (sp, 2);
	PUSHs (sv_2mortal (newSVGnomeVFSResult (result)));
	PUSHs (sv_2mortal (newSVGnomeVFSHandle (handle)));

##  GnomeVFSResult gnome_vfs_move_uri (GnomeVFSURI *old_uri, GnomeVFSURI *new_uri, gboolean force_replace) 
GnomeVFSResult
gnome_vfs_move_uri (old_uri, new_uri, force_replace)
	GnomeVFSURI *old_uri
	GnomeVFSURI *new_uri
	gboolean force_replace
    ALIAS:
	Gnome2::VFS::URI::move = 0

=for apidoc

Returns a GnomeVFSResult and a boolean.

=cut
##  GnomeVFSResult gnome_vfs_check_same_fs_uris (GnomeVFSURI *source_uri, GnomeVFSURI *target_uri, gboolean *same_fs_return) 
void
gnome_vfs_check_same_fs_uris (source_uri, target_uri)
	GnomeVFSURI *source_uri
	GnomeVFSURI *target_uri
    ALIAS:
	Gnome2::VFS::URI::check_same_fs = 0
    PREINIT:
	GnomeVFSResult result;
	gboolean same_fs_return;
    PPCODE:
	result = gnome_vfs_check_same_fs_uris (source_uri, target_uri, &same_fs_return);
	EXTEND (sp, 2);
	PUSHs (sv_2mortal (newSVGnomeVFSResult (result)));
	PUSHs (sv_2mortal (newSVuv (same_fs_return)));

##  gboolean gnome_vfs_uri_exists (GnomeVFSURI *uri) 
gboolean
gnome_vfs_uri_exists (uri)
	GnomeVFSURI *uri

##  GnomeVFSResult gnome_vfs_unlink_from_uri (GnomeVFSURI *uri) 
GnomeVFSResult
gnome_vfs_unlink_from_uri (uri)
	GnomeVFSURI *uri
    ALIAS:
	Gnome2::VFS::URI::unlink = 0

=for apidoc

Returns a GnomeVFSResult and a GnomeVFSFileInfo.

=cut
##  GnomeVFSResult gnome_vfs_get_file_info_uri (GnomeVFSURI *uri, GnomeVFSFileInfo *info, GnomeVFSFileInfoOptions options) 
void
gnome_vfs_get_file_info_uri (uri, options)
	GnomeVFSURI *uri
	GnomeVFSFileInfoOptions options
    ALIAS:
	Gnome2::VFS::URI::get_file_info = 0
    PREINIT:
	GnomeVFSResult result;
	GnomeVFSFileInfo *info;
    PPCODE:
	info = gnome_vfs_file_info_new ();
	result = gnome_vfs_get_file_info_uri (uri, info, options);
	EXTEND (sp, 2);
	PUSHs (sv_2mortal (newSVGnomeVFSResult (result)));
	PUSHs (sv_2mortal (newSVGnomeVFSFileInfo (info)));
	g_free (info);

##  GnomeVFSResult gnome_vfs_truncate_uri (GnomeVFSURI *uri, GnomeVFSFileSize length) 
GnomeVFSResult
gnome_vfs_truncate_uri (uri, length)
	GnomeVFSURI *uri
	GnomeVFSFileSize length
    ALIAS:
	Gnome2::VFS::URI::truncate = 0

##  GnomeVFSResult gnome_vfs_make_directory_for_uri (GnomeVFSURI *uri, guint perm) 
GnomeVFSResult
gnome_vfs_make_directory_for_uri (uri, perm)
	GnomeVFSURI *uri
	guint perm
    ALIAS:
	Gnome2::VFS::URI::make_directory = 0

##  GnomeVFSResult gnome_vfs_remove_directory_from_uri (GnomeVFSURI *uri) 
GnomeVFSResult
gnome_vfs_remove_directory_from_uri (uri)
	GnomeVFSURI *uri
    ALIAS:
	Gnome2::VFS::URI::remove_directory = 0

# --------------------------------------------------------------------------- #

MODULE = Gnome2::VFS::Ops	PACKAGE = Gnome2::VFS::Monitor	PREFIX = gnome_vfs_monitor_

=for apidoc

Returns a GnomeVFSResult and a GnomeVFSMonitorHandle.

=cut
##  GnomeVFSResult gnome_vfs_monitor_add (GnomeVFSMonitorHandle **handle, const gchar *text_uri, GnomeVFSMonitorType monitor_type, GnomeVFSMonitorCallback callback, gpointer user_data) 
void
gnome_vfs_monitor_add (class, text_uri, monitor_type, func, data=NULL)
	const gchar *text_uri
	GnomeVFSMonitorType monitor_type
	SV *func
	SV *data
    PREINIT:
	GnomeVFSResult result;
	GnomeVFSMonitorHandle *handle;
    PPCODE:
	GPerlCallback *callback = gperl_callback_new (func, data, 0, NULL, 0);

	result = gnome_vfs_monitor_add (&handle,
	                                text_uri,
	                                monitor_type,
	                                (GnomeVFSMonitorCallback)
	                                  vfs2perl_monitor_callback,
	                                callback);

	EXTEND (sp, 2);
	PUSHs (sv_2mortal (newSVGnomeVFSResult (result)));
	PUSHs (sv_2mortal (newSVGnomeVFSMonitorHandle (handle)));

# --------------------------------------------------------------------------- #

MODULE = Gnome2::VFS::Ops	PACKAGE = Gnome2::VFS::Monitor::Handle	PREFIX = gnome_vfs_monitor_

# FIXME: also cancel the monitor here?
void
DESTROY (rv)
	SV *rv
    CODE:
	MAGIC *mg;
	GnomeVFSMonitorHandle *handle;

	if (!rv || !SvOK (rv) || !SvROK (rv) || !(mg = mg_find (SvRV (rv), PERL_MAGIC_ext)))
		return;

	/* FIXME, FIXME, FIXME: why do I get «dereferencing pointer to incomplete type» here?
	handle = mg->mg_ptr;

	if (handle->user_data)
		gperl_callback_destroy ((GPerlCallback *) handle->user_data); */

	sv_unmagic (SvRV (rv), PERL_MAGIC_ext);

##  GnomeVFSResult gnome_vfs_monitor_cancel (GnomeVFSMonitorHandle *handle) 
GnomeVFSResult
gnome_vfs_monitor_cancel (handle)
	GnomeVFSMonitorHandle *handle
    CODE:
	/* FIXME, FIXME, FIXME: why do I get «dereferencing pointer to incomplete type» here?
	if (handle->user_data)
		gperl_callback_destroy ((GPerlCallback *) handle->user_data); */

	RETVAL = gnome_vfs_monitor_cancel (handle);
    OUTPUT:
	RETVAL

# --------------------------------------------------------------------------- #

# FIXME: why would you want to use these?
###  GnomeVFSResult gnome_vfs_set_file_info_uri (GnomeVFSURI *uri, GnomeVFSFileInfo *info, GnomeVFSSetFileInfoMask mask) 
#GnomeVFSResult
#gnome_vfs_set_file_info_uri (uri, info, mask)
#	GnomeVFSURI *uri
#	GnomeVFSFileInfo *info
#	GnomeVFSSetFileInfoMask mask

###  GnomeVFSResult gnome_vfs_set_file_info (const gchar *text_uri, GnomeVFSFileInfo *info, GnomeVFSSetFileInfoMask mask) 
#GnomeVFSResult
#gnome_vfs_set_file_info (text_uri, info, mask)
#	const gchar *text_uri
#	GnomeVFSFileInfo *info
#	GnomeVFSSetFileInfoMask mask

# --------------------------------------------------------------------------- #

# according to the docs, not intended to be used directly.
###  GnomeVFSResult gnome_vfs_file_control (GnomeVFSHandle *handle, const char *operation, gpointer operation_data) 
#GnomeVFSResult
#gnome_vfs_file_control (handle, operation, operation_data)
#	GnomeVFSHandle *handle
#	const char *operation
#	gpointer operation_data
