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

typedef const char GnomeVFSApplication;

const char *
SvGnomeVFSApplication (SV *object)
{
	MAGIC *mg;

	if (!object || !SvOK (object) || !SvROK (object) || !(mg = mg_find (SvRV (object), PERL_MAGIC_ext)))
		return NULL;

	return (const char *) mg->mg_ptr;
}

SV *
newSVGnomeVFSApplication (const char *app_id)
{
	SV *rv;
	HV *stash;
	SV *object = (SV *) newHV ();

	sv_magic (object, 0, PERL_MAGIC_ext, app_id, 0);

	rv = newRV (object);
	stash = gv_stashpv ("Gnome2::VFS::Application", 1);

	return sv_bless (rv, stash);
}

/* -------------------------------------------------------------------------  */

MODULE = Gnome2::VFS::ApplicationRegistry	PACKAGE = Gnome2::VFS::ApplicationRegistry	PREFIX = gnome_vfs_application_registry_

SV *
gnome_vfs_application_registry_new (class, app_id)
	const char *app_id
    CODE:
	RETVAL = newSVGnomeVFSApplication (app_id);
    OUTPUT:
	RETVAL

MODULE = Gnome2::VFS::ApplicationRegistry	PACKAGE = Gnome2::VFS::Application	PREFIX = gnome_vfs_application_registry_

##  gboolean gnome_vfs_application_registry_exists (const char *app_id) 
gboolean
gnome_vfs_application_registry_exists (app_id)
	GnomeVFSApplication *app_id

##  GList *gnome_vfs_application_registry_get_keys (const char *app_id) 
void
gnome_vfs_application_registry_get_keys (app_id)
	GnomeVFSApplication *app_id
    PREINIT:
	GList *results;
    PPCODE:
	results = gnome_vfs_application_registry_get_keys (app_id);
	for (; results != NULL; results = results->next)
		XPUSHs (sv_2mortal (newSVpv (results->data, PL_na)));

##  const char *gnome_vfs_application_registry_peek_value (const char *app_id, const char *key)
const char *
gnome_vfs_application_registry_peek_value (app_id, key)
	GnomeVFSApplication *app_id
	const char *key

##  gboolean gnome_vfs_application_registry_get_bool_value (const char *app_id, const char *key, gboolean *got_key) 
void
gnome_vfs_application_registry_get_bool_value (app_id, key)
	GnomeVFSApplication *app_id
	const char *key
    PREINIT:
	gboolean result;
	gboolean got_key;
    PPCODE:
	result = gnome_vfs_application_registry_get_bool_value (app_id, key, &got_key);
	EXTEND (sp, 2);
	PUSHs (sv_2mortal (newSVuv (result)));
	PUSHs (sv_2mortal (newSVuv (got_key)));

##  void gnome_vfs_application_registry_remove_application(const char *app_id) 
void
gnome_vfs_application_registry_remove_application (app_id)
	GnomeVFSApplication *app_id

##  void gnome_vfs_application_registry_set_value (const char *app_id, const char *key, const char *value) 
void
gnome_vfs_application_registry_set_value (app_id, key, value)
	GnomeVFSApplication *app_id
	const char *key
	const char *value

##  void gnome_vfs_application_registry_set_bool_value (const char *app_id, const char *key, gboolean value) 
void
gnome_vfs_application_registry_set_bool_value (app_id, key, value)
	GnomeVFSApplication *app_id
	const char *key
	gboolean value

##  void gnome_vfs_application_registry_unset_key (const char *app_id, const char *key) 
void
gnome_vfs_application_registry_unset_key (app_id, key)
	GnomeVFSApplication *app_id
	const char *key

##  GList *gnome_vfs_application_registry_get_applications(const char *mime_type) 
void
gnome_vfs_application_registry_get_applications (class, mime_type=NULL)
	const char *mime_type
    PREINIT:
	GList *result;
    PPCODE:
	result = gnome_vfs_application_registry_get_applications (mime_type);
	for (; result != NULL; result = result->next)
		XPUSHs (sv_2mortal (newSVpv (result->data, PL_na)));

##  GList *gnome_vfs_application_registry_get_mime_types (const char *app_id) 
void
gnome_vfs_application_registry_get_mime_types (app_id)
	GnomeVFSApplication *app_id
    PREINIT:
	GList *result;
    PPCODE:
	result = gnome_vfs_application_registry_get_mime_types (app_id);
	for (result = result; result != NULL; result = result->next)
		XPUSHs (sv_2mortal (newSVpv (result->data, PL_na)));

##  gboolean gnome_vfs_application_registry_supports_mime_type (const char *app_id, const char *mime_type) 
gboolean
gnome_vfs_application_registry_supports_mime_type (app_id, mime_type)
	GnomeVFSApplication *app_id
	const char *mime_type

##  gboolean gnome_vfs_application_registry_supports_uri_scheme (const char *app_id, const char *uri_scheme) 
gboolean
gnome_vfs_application_registry_supports_uri_scheme (app_id, uri_scheme)
	GnomeVFSApplication *app_id
	const char *uri_scheme

# FIXME: Implement GnomeVFSMimeApplication.
###  gboolean gnome_vfs_application_is_user_owned_application (const GnomeVFSMimeApplication *application) 
#gboolean
#gnome_vfs_application_is_user_owned_application (application)
#	const GnomeVFSMimeApplication *application

##  void gnome_vfs_application_registry_clear_mime_types (const char *app_id) 
void
gnome_vfs_application_registry_clear_mime_types (app_id)
	GnomeVFSApplication *app_id

##  void gnome_vfs_application_registry_add_mime_type (const char *app_id, const char *mime_type) 
void
gnome_vfs_application_registry_add_mime_type (app_id, mime_type)
	GnomeVFSApplication *app_id
	const char *mime_type

##  void gnome_vfs_application_registry_remove_mime_type (const char *app_id, const char *mime_type) 
void
gnome_vfs_application_registry_remove_mime_type (app_id, mime_type)
	GnomeVFSApplication *app_id
	const char *mime_type

##  GnomeVFSResult gnome_vfs_application_registry_sync (void) 
GnomeVFSResult
gnome_vfs_application_registry_sync (class)
    C_ARGS:
	/* void */

##  void gnome_vfs_application_registry_shutdown (void) 
void
gnome_vfs_application_registry_shutdown (class)
    C_ARGS:
	/* void */

##  void gnome_vfs_application_registry_reload (void) 
void
gnome_vfs_application_registry_reload (class)
    C_ARGS:
	/* void */

# FIXME: Implement GnomeVFSMimeApplication.
###  GnomeVFSMimeApplication * gnome_vfs_application_registry_get_mime_application(const char *app_id) 
#GnomeVFSMimeApplication *
#gnome_vfs_application_registry_get_mime_application (app_id)
#	const char *app_id

# FIXME: Implement GnomeVFSMimeApplication.
###  void gnome_vfs_application_registry_save_mime_application(const GnomeVFSMimeApplication *application) 
#void
#gnome_vfs_application_registry_save_mime_application (application)
#	const GnomeVFSMimeApplication *application