#include "vfs2perl.h"

/* ------------------------------------------------------------------------- */

GnomeVFSAsyncHandle *
SvGnomeVFSAsyncHandle (SV *object)
{
	MAGIC *mg;

	if (!object || !SvOK (object) || !SvROK (object) || !(mg = mg_find (SvRV (object), PERL_MAGIC_ext)))
		return NULL;

	return (GnomeVFSAsyncHandle *) mg->mg_ptr;
}

SV *
newSVGnomeVFSAsyncHandle (GnomeVFSAsyncHandle *handle)
{
	SV *rv;
	HV *stash;
	SV *object = (SV *) newHV ();

	sv_magic (object, 0, PERL_MAGIC_ext, (const char *) handle, 0);

	rv = newRV_noinc (object);
	stash = gv_stashpv ("Gnome2::VFS::Async::Handle", 1);

	return sv_bless (rv, stash);
}

/* ------------------------------------------------------------------------- */

void
vfs2perl_async_open_callback (GnomeVFSAsyncHandle *handle,
                              GnomeVFSResult result,
                              GPerlCallback *callback)
{
	dSP;

	ENTER;
	SAVETMPS;

	PUSHMARK (SP);

	EXTEND (SP, 2);
	PUSHs (sv_2mortal (newSVGnomeVFSAsyncHandle (handle)));
	PUSHs (sv_2mortal (newSVGnomeVFSResult (result)));
	if (callback->data)
		XPUSHs (sv_2mortal (newSVsv (callback->data)));

	PUTBACK;

	call_sv (callback->func, G_DISCARD);

	FREETMPS;
	LEAVE;
}

void
vfs2perl_async_read_callback (GnomeVFSAsyncHandle *handle,
                              GnomeVFSResult result,
                              char* buffer,
                              GnomeVFSFileSize bytes_requested,
                              GnomeVFSFileSize bytes_read,
                              GPerlCallback *callback)
{
	dSP;

	ENTER;
	SAVETMPS;

	PUSHMARK (SP);

	EXTEND (SP, 5);
	PUSHs (sv_2mortal (newSVGnomeVFSAsyncHandle (handle)));
	PUSHs (sv_2mortal (newSVGnomeVFSResult (result)));
	PUSHs (sv_2mortal (newSVpv (buffer, bytes_read)));
	PUSHs (sv_2mortal (newSVGnomeVFSFileSize (bytes_requested)));
	PUSHs (sv_2mortal (newSVGnomeVFSFileSize (bytes_read)));
	if (callback->data)
		XPUSHs (sv_2mortal (newSVsv (callback->data)));

	PUTBACK;

	call_sv (callback->func, G_DISCARD);

	FREETMPS;
	LEAVE;
}

void
vfs2perl_async_write_callback (GnomeVFSAsyncHandle *handle,
                               GnomeVFSResult result,
                               char* buffer,
                               GnomeVFSFileSize bytes_requested,
                               GnomeVFSFileSize bytes_written,
                               GPerlCallback *callback)
{
	dSP;

	ENTER;
	SAVETMPS;

	PUSHMARK (SP);

	EXTEND (SP, 5);
	PUSHs (sv_2mortal (newSVGnomeVFSAsyncHandle (handle)));
	PUSHs (sv_2mortal (newSVGnomeVFSResult (result)));
	PUSHs (sv_2mortal (newSVpv (buffer, bytes_written)));
	PUSHs (sv_2mortal (newSVGnomeVFSFileSize (bytes_requested)));
	PUSHs (sv_2mortal (newSVGnomeVFSFileSize (bytes_written)));
	if (callback->data)
		XPUSHs (sv_2mortal (newSVsv (callback->data)));

	PUTBACK;

	call_sv (callback->func, G_DISCARD);

	FREETMPS;
	LEAVE;
}

void
vfs2perl_async_directory_load_callback (GnomeVFSAsyncHandle *handle,
                                        GnomeVFSResult result,
                                        GList *list,
                                        guint entries_read,
                                        GPerlCallback *callback)
{
	dSP;

	ENTER;
	SAVETMPS;

	PUSHMARK (SP);

	EXTEND (SP, 4);
	PUSHs (sv_2mortal (newSVGnomeVFSAsyncHandle (handle)));
	PUSHs (sv_2mortal (newSVGnomeVFSResult (result)));
	PUSHs (sv_2mortal (newSVGnomeVFSFileInfoGList (list)));
	PUSHs (sv_2mortal (newSVuv (entries_read)));
	if (callback->data)
		XPUSHs (sv_2mortal (newSVsv (callback->data)));

	PUTBACK;

	call_sv (callback->func, G_DISCARD);

	FREETMPS;
	LEAVE;
}

void
vfs2perl_async_get_file_info_callback (GnomeVFSAsyncHandle *handle,
                                       GList *results,
                                       GPerlCallback *callback)
{
	dSP;

	ENTER;
	SAVETMPS;

	PUSHMARK (SP);

	EXTEND (SP, 2);
	PUSHs (sv_2mortal (newSVGnomeVFSAsyncHandle (handle)));
	PUSHs (sv_2mortal (newSVGnomeVFSGetFileInfoResultGList (results)));
	if (callback->data)
		XPUSHs (sv_2mortal (newSVsv (callback->data)));

	PUTBACK;

	call_sv (callback->func, G_DISCARD);

	FREETMPS;
	LEAVE;
}

void
vfs2perl_async_xfer_progress_callback (GnomeVFSAsyncHandle *handle,
                                       GnomeVFSXferProgressInfo *info,
                                       GPerlCallback *callback)
{
	dSP;

	ENTER;
	SAVETMPS;

	PUSHMARK (SP);

	EXTEND (SP, 2);
	PUSHs (sv_2mortal (newSVGnomeVFSAsyncHandle (handle)));
	PUSHs (sv_2mortal (newSVGnomeVFSXferProgressInfo (info)));
	if (callback->data)
		XPUSHs (sv_2mortal (newSVsv (callback->data)));

	PUTBACK;

	call_sv (callback->func, G_DISCARD);

	FREETMPS;
	LEAVE;
}

extern gint vfs2perl_xfer_progress_callback (GnomeVFSXferProgressInfo *info,
                                             GPerlCallback *callback);

/* ------------------------------------------------------------------------- */

/* FIXME: does that AV leak? */
SV *
newSVGnomeVFSFileInfoGList (GList *list)
{
	AV *array = newAV ();

	for (; list != NULL; list = list->next)
		av_push (array, newSVGnomeVFSFileInfo (list->data));

	return newRV_noinc ((SV *) array);
}

/* FIXME: leak? */
SV *
newSVGnomeVFSGetFileInfoResultGList (GList *list)
{
	AV *array = newAV ();

	for (; list != NULL; list = list->next) {
		HV *hash = newHV ();
		GnomeVFSGetFileInfoResult* result = list->data;

		gnome_vfs_uri_ref (result->uri);

		hv_store (hash, "uri", 3, newSVGnomeVFSURI (result->uri), 0);
		hv_store (hash, "result", 6, newSVGnomeVFSResult (result->result), 0);
		hv_store (hash, "file_info", 9, newSVGnomeVFSFileInfo (result->file_info), 0);

		av_push (array, newRV_noinc ((SV *) hash));
	}

	return newRV_noinc ((SV *) array);
}

/* ------------------------------------------------------------------------- */

MODULE = Gnome2::VFS::Async	PACKAGE = Gnome2::VFS::Async	PREFIX = gnome_vfs_async_

##  void gnome_vfs_async_set_job_limit (int limit) 
void
gnome_vfs_async_set_job_limit (class, limit)
	int limit
    C_ARGS:
	limit

##  int gnome_vfs_async_get_job_limit (void) 
int
gnome_vfs_async_get_job_limit (class)
    C_ARGS:
	/* void */

##  void gnome_vfs_async_open (GnomeVFSAsyncHandle **handle_return, const gchar *text_uri, GnomeVFSOpenMode open_mode, int priority, GnomeVFSAsyncOpenCallback callback, gpointer callback_data) 
GnomeVFSAsyncHandle *
gnome_vfs_async_open (class, text_uri, open_mode, priority, func, data=NULL)
	const gchar *text_uri
	GnomeVFSOpenMode open_mode
	int priority
	SV *func
	SV *data
    CODE:
	GPerlCallback *callback = gperl_callback_new (func, data, 0, NULL, 0);

	gnome_vfs_async_open (&RETVAL,
                              text_uri,
                              open_mode,
                              priority,
                              (GnomeVFSAsyncOpenCallback)
                                vfs2perl_async_open_callback,
                              callback);

	/* FIXME, FIXME, FIXME: what about callback destruction? */
    OUTPUT:
	RETVAL

###  void gnome_vfs_async_open_uri (GnomeVFSAsyncHandle **handle_return, GnomeVFSURI *uri, GnomeVFSOpenMode open_mode, int priority, GnomeVFSAsyncOpenCallback callback, gpointer callback_data) 
GnomeVFSAsyncHandle *
gnome_vfs_async_open_uri (class, uri, open_mode, priority, func, data=NULL)
	GnomeVFSURI *uri
	GnomeVFSOpenMode open_mode
	int priority
	SV *func
	SV *data
    CODE:
	GPerlCallback *callback = gperl_callback_new (func, data, 0, NULL, 0);

	gnome_vfs_async_open_uri (&RETVAL,
                                  uri,
                                  open_mode,
                                  priority,
                                  (GnomeVFSAsyncOpenCallback)
                                    vfs2perl_async_open_callback,
                                  callback);

	/* FIXME, FIXME, FIXME: what about callback destruction? */
    OUTPUT:
	RETVAL

###  void gnome_vfs_async_open_as_channel (GnomeVFSAsyncHandle **handle_return, const gchar *text_uri, GnomeVFSOpenMode open_mode, guint advised_block_size, int priority, GnomeVFSAsyncOpenAsChannelCallback callback, gpointer callback_data) 
#void
#gnome_vfs_async_open_as_channel (handle_return, text_uri, open_mode, advised_block_size, priority, callback, callback_data)
#	GnomeVFSAsyncHandle **handle_return
#	const gchar *text_uri
#	GnomeVFSOpenMode open_mode
#	guint advised_block_size
#	int priority
#	GnomeVFSAsyncOpenAsChannelCallback callback
#	gpointer callback_data

###  void gnome_vfs_async_open_uri_as_channel (GnomeVFSAsyncHandle **handle_return, GnomeVFSURI *uri, GnomeVFSOpenMode open_mode, guint advised_block_size, int priority, GnomeVFSAsyncOpenAsChannelCallback callback, gpointer callback_data) 
#void
#gnome_vfs_async_open_uri_as_channel (handle_return, uri, open_mode, advised_block_size, priority, callback, callback_data)
#	GnomeVFSAsyncHandle **handle_return
#	GnomeVFSURI *uri
#	GnomeVFSOpenMode open_mode
#	guint advised_block_size
#	int priority
#	GnomeVFSAsyncOpenAsChannelCallback callback
#	gpointer callback_data

##  void gnome_vfs_async_create (GnomeVFSAsyncHandle **handle_return, const gchar *text_uri, GnomeVFSOpenMode open_mode, gboolean exclusive, guint perm, int priority, GnomeVFSAsyncOpenCallback callback, gpointer callback_data) 
GnomeVFSAsyncHandle *
gnome_vfs_async_create (class, text_uri, open_mode, exclusive, perm, priority, func, data=NULL)
	const gchar *text_uri
	GnomeVFSOpenMode open_mode
	gboolean exclusive
	guint perm
	int priority
	SV *func
	SV *data
    CODE:
	GPerlCallback *callback = gperl_callback_new (func, data, 0, NULL, 0);

	gnome_vfs_async_create (&RETVAL,
	                        text_uri,
	                        open_mode,
	                        exclusive,
	                        perm,
	                        priority,
	                        (GnomeVFSAsyncOpenCallback)
	                          vfs2perl_async_open_callback,
	                        callback);

	/* FIXME, FIXME, FIXME: what about callback destruction? */
    OUTPUT:
	RETVAL

##  void gnome_vfs_async_create_uri (GnomeVFSAsyncHandle **handle_return, GnomeVFSURI *uri, GnomeVFSOpenMode open_mode, gboolean exclusive, guint perm, int priority, GnomeVFSAsyncOpenCallback callback, gpointer callback_data) 
GnomeVFSAsyncHandle *
gnome_vfs_async_create_uri (class, uri, open_mode, exclusive, perm, priority, func, data=NULL)
	GnomeVFSURI *uri
	GnomeVFSOpenMode open_mode
	gboolean exclusive
	guint perm
	int priority
	SV *func
	SV *data
    CODE:
	GPerlCallback *callback = gperl_callback_new (func, data, 0, NULL, 0);

	gnome_vfs_async_create_uri (&RETVAL,
	                            uri,
	                            open_mode,
	                            exclusive,
	                            perm,
	                            priority,
	                            (GnomeVFSAsyncOpenCallback)
	                              vfs2perl_async_open_callback,
	                            callback);

	/* FIXME, FIXME, FIXME: what about callback destruction? */
    OUTPUT:
	RETVAL

##  void gnome_vfs_async_create_symbolic_link (GnomeVFSAsyncHandle **handle_return, GnomeVFSURI *uri, const gchar *uri_reference, int priority, GnomeVFSAsyncOpenCallback callback, gpointer callback_data) 
GnomeVFSAsyncHandle *
gnome_vfs_async_create_symbolic_link (class, uri, uri_reference, priority, func, data=NULL)
	GnomeVFSURI *uri
	const gchar *uri_reference
	int priority
	SV *func
	SV *data
    CODE:
	GPerlCallback *callback = gperl_callback_new (func, data, 0, NULL, 0);

	gnome_vfs_async_create_symbolic_link (&RETVAL,
	                                      uri,
	                                      uri_reference,
	                                      priority,
	                                      (GnomeVFSAsyncOpenCallback)
	                                        vfs2perl_async_open_callback,
	                                      callback);

	/* FIXME, FIXME, FIXME: what about callback destruction? */
    OUTPUT:
	RETVAL

##  void gnome_vfs_async_get_file_info (GnomeVFSAsyncHandle **handle_return, GList *uri_list, GnomeVFSFileInfoOptions options, int priority, GnomeVFSAsyncGetFileInfoCallback callback, gpointer callback_data) 
GnomeVFSAsyncHandle *
gnome_vfs_async_get_file_info (class, uri_ref, options, priority, func, data=NULL)
	SV *uri_ref
	GnomeVFSFileInfoOptions options
	int priority
	SV *func
	SV *data
    CODE:
	GPerlCallback *callback = gperl_callback_new (func, data, 0, NULL, 0);
	GList *uri_list = SvGnomeVFSURIGList (uri_ref);

	gnome_vfs_async_get_file_info (&RETVAL,
	                               uri_list,
	                               options,
	                               priority,
	                               (GnomeVFSAsyncGetFileInfoCallback)
	                                 vfs2perl_async_get_file_info_callback,
	                               callback);

	/* FIXME, FIXME, FIXME: what about callback destruction? */
    OUTPUT:
	RETVAL

###  void gnome_vfs_async_set_file_info (GnomeVFSAsyncHandle **handle_return, GnomeVFSURI *uri, GnomeVFSFileInfo *info, GnomeVFSSetFileInfoMask mask, GnomeVFSFileInfoOptions options, int priority, GnomeVFSAsyncSetFileInfoCallback callback, gpointer callback_data) 
#void
#gnome_vfs_async_set_file_info (handle_return, uri, info, mask, options, priority, callback, callback_data)
#	GnomeVFSAsyncHandle **handle_return
#	GnomeVFSURI *uri
#	GnomeVFSFileInfo *info
#	GnomeVFSSetFileInfoMask mask
#	GnomeVFSFileInfoOptions options
#	int priority
#	GnomeVFSAsyncSetFileInfoCallback callback
#	gpointer callback_data

##  void gnome_vfs_async_load_directory (GnomeVFSAsyncHandle **handle_return, const gchar *text_uri, GnomeVFSFileInfoOptions options, guint items_per_notification, int priority, GnomeVFSAsyncDirectoryLoadCallback callback, gpointer callback_data) 
GnomeVFSAsyncHandle *
gnome_vfs_async_load_directory (class, text_uri, options, items_per_notification, priority, func, data=NULL)
	const gchar *text_uri
	GnomeVFSFileInfoOptions options
	guint items_per_notification
	int priority
	SV *func
	SV *data
    CODE:
	GPerlCallback *callback = gperl_callback_new (func, data, 0, NULL, 0);

	gnome_vfs_async_load_directory (&RETVAL,
	                                text_uri,
	                                options,
                                        items_per_notification,
	                                priority,
	                                (GnomeVFSAsyncDirectoryLoadCallback)
	                                  vfs2perl_async_directory_load_callback,
	                                callback);

	/* FIXME, FIXME, FIXME: what about callback destruction? */
    OUTPUT:
	RETVAL

##  void gnome_vfs_async_load_directory_uri (GnomeVFSAsyncHandle **handle_return, GnomeVFSURI *uri, GnomeVFSFileInfoOptions options, guint items_per_notification, int priority, GnomeVFSAsyncDirectoryLoadCallback callback, gpointer callback_data) 
GnomeVFSAsyncHandle *
gnome_vfs_async_load_directory_uri (class, uri, options, items_per_notification, priority, func, data=NULL)
	GnomeVFSURI *uri
	GnomeVFSFileInfoOptions options
	guint items_per_notification
	int priority
	SV *func
	SV *data
    CODE:
	GPerlCallback *callback = gperl_callback_new (func, data, 0, NULL, 0);

	gnome_vfs_async_load_directory_uri (&RETVAL,
	                                    uri,
	                                    options,
                                            items_per_notification,
	                                    priority,
	                                    (GnomeVFSAsyncDirectoryLoadCallback)
	                                      vfs2perl_async_directory_load_callback,
	                                    callback);

	/* FIXME, FIXME, FIXME: what about callback destruction? */
    OUTPUT:
	RETVAL

##  GnomeVFSResult gnome_vfs_async_xfer (GnomeVFSAsyncHandle **handle_return, GList *source_uri_list, GList *target_uri_list, GnomeVFSXferOptions xfer_options, GnomeVFSXferErrorMode error_mode, GnomeVFSXferOverwriteMode overwrite_mode, int priority, GnomeVFSAsyncXferProgressCallback progress_update_callback, gpointer update_callback_data, GnomeVFSXferProgressCallback progress_sync_callback, gpointer sync_callback_data) 
void
gnome_vfs_async_xfer (class, source_ref, target_ref, xfer_options, error_mode, overwrite_mode, priority, func_update, data_update, func_sync, data_sync=NULL)
	SV *source_ref
	SV *target_ref
	GnomeVFSXferOptions xfer_options
	GnomeVFSXferErrorMode error_mode
	GnomeVFSXferOverwriteMode overwrite_mode
	int priority
	SV *func_update
	SV *data_update
	SV *func_sync
	SV *data_sync
    PREINIT:
	GnomeVFSResult result;
	GnomeVFSAsyncHandle *handle_return;
    PPCODE:
	GList *source_uri_list = SvGnomeVFSURIGList (source_ref);
	GList *target_uri_list = SvGnomeVFSURIGList (target_ref);

	GPerlCallback *callback_update = gperl_callback_new (func_update, data_update, 0, NULL, 0);
	GPerlCallback *callback_sync = gperl_callback_new (func_sync, data_sync, 0, NULL, G_TYPE_INT);

	result = gnome_vfs_async_xfer (&handle_return,
	                               source_uri_list,
	                               target_uri_list,
	                               xfer_options,
	                               error_mode,
	                               overwrite_mode,
	                               priority,
	                               (GnomeVFSAsyncXferProgressCallback)
	                                 vfs2perl_async_xfer_progress_callback,
	                               callback_update,
	                               (GnomeVFSXferProgressCallback)
	                                 vfs2perl_xfer_progress_callback,
	                               callback_sync);

	g_list_free (source_uri_list);
	g_list_free (target_uri_list);

	EXTEND (sp, 2);
	PUSHs (sv_2mortal (newSVGnomeVFSResult (result)));
	PUSHs (sv_2mortal (newSVGnomeVFSAsyncHandle (handle_return)));

	/* FIXME, FIXME, FIXME: what about callback destruction? */

###  void gnome_vfs_async_create_as_channel (GnomeVFSAsyncHandle **handle_return, const gchar *text_uri, GnomeVFSOpenMode open_mode, gboolean exclusive, guint perm, int priority, GnomeVFSAsyncCreateAsChannelCallback callback, gpointer callback_data) 
#void
#gnome_vfs_async_create_as_channel (handle_return, text_uri, open_mode, exclusive, perm, priority, callback, callback_data)
#	GnomeVFSAsyncHandle **handle_return
#	const gchar *text_uri
#	GnomeVFSOpenMode open_mode
#	gboolean exclusive
#	guint perm
#	int priority
#	GnomeVFSAsyncCreateAsChannelCallback callback
#	gpointer callback_data

###  void gnome_vfs_async_create_uri_as_channel (GnomeVFSAsyncHandle **handle_return, GnomeVFSURI *uri, GnomeVFSOpenMode open_mode, gboolean exclusive, guint perm, int priority, GnomeVFSAsyncCreateAsChannelCallback callback, gpointer callback_data) 
#void
#gnome_vfs_async_create_uri_as_channel (handle_return, uri, open_mode, exclusive, perm, priority, callback, callback_data)
#	GnomeVFSAsyncHandle **handle_return
#	GnomeVFSURI *uri
#	GnomeVFSOpenMode open_mode
#	gboolean exclusive
#	guint perm
#	int priority
#	GnomeVFSAsyncCreateAsChannelCallback callback
#	gpointer callback_data

###  void gnome_vfs_async_find_directory (GnomeVFSAsyncHandle **handle_return, GList *near_uri_list, GnomeVFSFindDirectoryKind kind, gboolean create_if_needed, gboolean find_if_needed, guint permissions, int priority, GnomeVFSAsyncFindDirectoryCallback callback, gpointer user_data) 
#void
#gnome_vfs_async_find_directory (handle_return, near_uri_list, kind, create_if_needed, find_if_needed, permissions, priority, callback, user_data)
#	GnomeVFSAsyncHandle **handle_return
#	GList *near_uri_list
#	GnomeVFSFindDirectoryKind kind
#	gboolean create_if_needed
#	gboolean find_if_needed
#	guint permissions
#	int priority
#	GnomeVFSAsyncFindDirectoryCallback callback
#	gpointer user_data

###  void gnome_vfs_async_file_control (GnomeVFSAsyncHandle *handle, const char *operation, gpointer operation_data, GDestroyNotify operation_data_destroy_func, GnomeVFSAsyncFileControlCallback callback, gpointer callback_data) 
#void
#gnome_vfs_async_file_control (handle, operation, operation_data, operation_data_destroy_func, callback, callback_data)
#	GnomeVFSAsyncHandle *handle
#	const char *operation
#	gpointer operation_data
#	GDestroyNotify operation_data_destroy_func
#	GnomeVFSAsyncFileControlCallback callback
#	gpointer callback_data

# --------------------------------------------------------------------------- #

MODULE = Gnome2::VFS::Async	PACKAGE = Gnome2::VFS::Async::Handle	PREFIX = gnome_vfs_async_

void
DESTROY (rv)
	SV *rv
    CODE:
	MAGIC *mg;

	if (!rv || !SvOK (rv) || !SvROK (rv) || !(mg = mg_find (SvRV (rv), PERL_MAGIC_ext)))
		return;

	sv_unmagic (SvRV (rv), PERL_MAGIC_ext);

##  void gnome_vfs_async_close (GnomeVFSAsyncHandle *handle, GnomeVFSAsyncCloseCallback callback, gpointer callback_data) 
void
gnome_vfs_async_close (handle, func, data=NULL)
	GnomeVFSAsyncHandle *handle
	SV *func
	SV *data
    CODE:
	GPerlCallback *callback = gperl_callback_new (func, data, 0, NULL, 0);

	gnome_vfs_async_close (handle,
                               (GnomeVFSAsyncCloseCallback)
                                 vfs2perl_async_open_callback,
                               callback);

	/* FIXME, FIXME, FIXME: what about callback destruction? */

# FIXME: destroy callback here?  docs say:
# «Its possible to still receive another call or two on the callback.»
##  void gnome_vfs_async_cancel (GnomeVFSAsyncHandle *handle) 
void
gnome_vfs_async_cancel (handle)
	GnomeVFSAsyncHandle *handle

##  void gnome_vfs_async_read (GnomeVFSAsyncHandle *handle, gpointer buffer, guint bytes, GnomeVFSAsyncReadCallback callback, gpointer callback_data) 
void
gnome_vfs_async_read (handle, bytes, func, data=NULL)
	GnomeVFSAsyncHandle *handle
	guint bytes
	SV *func
	SV *data
    PREINIT:
	char *buffer;
    CODE:
	GPerlCallback *callback = gperl_callback_new (func, data, 0, NULL, 0);
	buffer = g_new0 (char, bytes);

	gnome_vfs_async_read (handle,
	                      buffer,
	                      bytes,
	                      (GnomeVFSAsyncReadCallback)
	                        vfs2perl_async_read_callback,
	                      callback);

	/* FIXME, FIXME, FIXME: what about callback destruction?
	                        and the buffer? */

##  void gnome_vfs_async_write (GnomeVFSAsyncHandle *handle, gconstpointer buffer, guint bytes, GnomeVFSAsyncWriteCallback callback, gpointer callback_data) 
void
gnome_vfs_async_write (handle, buffer, bytes, func, data=NULL)
	GnomeVFSAsyncHandle *handle
	char* buffer
	guint bytes
	SV *func
	SV *data
    CODE:
	GPerlCallback *callback = gperl_callback_new (func, data, 0, NULL, 0);

	gnome_vfs_async_write (handle,
	                       buffer,
	                       bytes,
	                       (GnomeVFSAsyncWriteCallback)
	                         vfs2perl_async_write_callback,
	                       callback);

	/* FIXME, FIXME, FIXME: what about callback destruction? */
