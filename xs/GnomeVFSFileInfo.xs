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

/* ------------------------------------------------------------------------- */

#define VFS2PERL_CHECK_AND_STORE(_type, _key, _sv) \
		if (info->valid_fields & _type) \
			hv_store (object, _key, strlen (_key), _sv, 0);

SV *
newSVGnomeVFSFileInfo (GnomeVFSFileInfo *info)
{
	HV *object = newHV ();

	if (info && info->name && info->valid_fields) {
		hv_store (object, "name", 4, newSVpv (info->name, PL_na), 0);
		hv_store (object, "valid_fields", 12, newSVGnomeVFSFileInfoFields (info->valid_fields), 0);

		VFS2PERL_CHECK_AND_STORE (GNOME_VFS_FILE_INFO_FIELDS_TYPE, "type", newSVGnomeVFSFileType (info->type));
		VFS2PERL_CHECK_AND_STORE (GNOME_VFS_FILE_INFO_FIELDS_PERMISSIONS, "permissions", newSVGnomeVFSFilePermissions (info->permissions));
		VFS2PERL_CHECK_AND_STORE (GNOME_VFS_FILE_INFO_FIELDS_FLAGS, "flags", newSVGnomeVFSFileFlags (info->flags));
		VFS2PERL_CHECK_AND_STORE (GNOME_VFS_FILE_INFO_FIELDS_DEVICE, "device", newSViv (info->device));
		VFS2PERL_CHECK_AND_STORE (GNOME_VFS_FILE_INFO_FIELDS_INODE, "inode", newSVuv (info->inode));
		VFS2PERL_CHECK_AND_STORE (GNOME_VFS_FILE_INFO_FIELDS_LINK_COUNT, "link_count", newSVuv (info->link_count));
		VFS2PERL_CHECK_AND_STORE (GNOME_VFS_FILE_INFO_FIELDS_SIZE, "size", newSVGnomeVFSFileSize (info->size));
		VFS2PERL_CHECK_AND_STORE (GNOME_VFS_FILE_INFO_FIELDS_BLOCK_COUNT, "block_count", newSVGnomeVFSFileSize (info->block_count));
		VFS2PERL_CHECK_AND_STORE (GNOME_VFS_FILE_INFO_FIELDS_IO_BLOCK_SIZE, "io_block_size", newSVuv (info->io_block_size));
		VFS2PERL_CHECK_AND_STORE (GNOME_VFS_FILE_INFO_FIELDS_ATIME, "atime", newSViv (info->atime));
		VFS2PERL_CHECK_AND_STORE (GNOME_VFS_FILE_INFO_FIELDS_MTIME, "mtime", newSViv (info->mtime));
		VFS2PERL_CHECK_AND_STORE (GNOME_VFS_FILE_INFO_FIELDS_CTIME, "ctime", newSViv (info->ctime));
		VFS2PERL_CHECK_AND_STORE (GNOME_VFS_FILE_INFO_FIELDS_SYMLINK_NAME, "symlink_name", newSVpv (info->symlink_name, PL_na));
		VFS2PERL_CHECK_AND_STORE (GNOME_VFS_FILE_INFO_FIELDS_MIME_TYPE, "mime_type", newSVpv (info->mime_type, PL_na));
		
		/* FIXME: what about GNOME_VFS_FILE_INFO_FIELDS_ACCESS? */
	}

	return sv_bless (newRV_noinc ((SV *) object),
	                 gv_stashpv ("Gnome2::VFS::FileInfo", 1));
}

#define VFS2PERL_FETCH_AND_CHECK(_type, _key, _member, _sv) \
		if (hv_exists (hv, _key, strlen (_key))) { \
			value = hv_fetch (hv, _key, strlen (_key), FALSE); \
			if (value) _member = _sv; \
			info->valid_fields |= _type; \
		}

GnomeVFSFileInfo *
SvGnomeVFSFileInfo (SV *object)
{
	HV *hv = (HV *) SvRV (object);
	SV **value;

	GnomeVFSFileInfo *info = gperl_alloc_temp (sizeof (GnomeVFSFileInfo));

	if (object && SvOK (object) && SvROK (object) && SvTYPE (SvRV (object)) == SVt_PVHV) {
		value = hv_fetch (hv, "name", 4, FALSE);
		if (value) info->name = SvPV_nolen (*value);

		info->valid_fields = GNOME_VFS_FILE_INFO_FIELDS_NONE;

		VFS2PERL_FETCH_AND_CHECK (GNOME_VFS_FILE_INFO_FIELDS_TYPE, "type", info->type, SvGnomeVFSFileType (*value));
		VFS2PERL_FETCH_AND_CHECK (GNOME_VFS_FILE_INFO_FIELDS_PERMISSIONS, "permissions", info->permissions, SvGnomeVFSFilePermissions (*value));
		VFS2PERL_FETCH_AND_CHECK (GNOME_VFS_FILE_INFO_FIELDS_FLAGS, "flags", info->flags, SvGnomeVFSFileFlags (*value));
		VFS2PERL_FETCH_AND_CHECK (GNOME_VFS_FILE_INFO_FIELDS_DEVICE, "device", info->device, SvIV (*value));
		VFS2PERL_FETCH_AND_CHECK (GNOME_VFS_FILE_INFO_FIELDS_INODE, "inode", info->inode, SvUV (*value));
		VFS2PERL_FETCH_AND_CHECK (GNOME_VFS_FILE_INFO_FIELDS_LINK_COUNT, "link_count", info->link_count, SvUV (*value));
		VFS2PERL_FETCH_AND_CHECK (GNOME_VFS_FILE_INFO_FIELDS_SIZE, "size", info->size, SvGnomeVFSFileSize (*value));
		VFS2PERL_FETCH_AND_CHECK (GNOME_VFS_FILE_INFO_FIELDS_BLOCK_COUNT, "block_count", info->block_count, SvGnomeVFSFileSize (*value));
		VFS2PERL_FETCH_AND_CHECK (GNOME_VFS_FILE_INFO_FIELDS_IO_BLOCK_SIZE, "io_block_size", info->io_block_size, SvUV (*value));
		VFS2PERL_FETCH_AND_CHECK (GNOME_VFS_FILE_INFO_FIELDS_ATIME, "atime", info->atime, SvIV (*value));
		VFS2PERL_FETCH_AND_CHECK (GNOME_VFS_FILE_INFO_FIELDS_MTIME, "mtime", info->mtime, SvIV (*value));
		VFS2PERL_FETCH_AND_CHECK (GNOME_VFS_FILE_INFO_FIELDS_CTIME, "ctime", info->ctime, SvIV (*value));
		VFS2PERL_FETCH_AND_CHECK (GNOME_VFS_FILE_INFO_FIELDS_SYMLINK_NAME, "symlink_name", info->symlink_name, SvPV_nolen (*value));
		VFS2PERL_FETCH_AND_CHECK (GNOME_VFS_FILE_INFO_FIELDS_MIME_TYPE, "mime_type", info->mime_type, SvPV_nolen (*value));
		
		/* FIXME: what about GNOME_VFS_FILE_INFO_FIELDS_ACCESS? */
	}

	return info;
}

/* ------------------------------------------------------------------------- */

MODULE = Gnome2::VFS::FileInfo	PACKAGE = Gnome2::VFS::FileInfo	PREFIX = gnome_vfs_file_info_

##  gboolean gnome_vfs_file_info_matches (const GnomeVFSFileInfo *a, const GnomeVFSFileInfo *b) 
gboolean
gnome_vfs_file_info_matches (a, b)
	const GnomeVFSFileInfo *a
	const GnomeVFSFileInfo *b

##  const char * gnome_vfs_file_info_get_mime_type (GnomeVFSFileInfo *info)
const char *
gnome_vfs_file_info_get_mime_type (info)
	GnomeVFSFileInfo *info
