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

SV *
newSVGnomeVFSFileInfo (GnomeVFSFileInfo *info)
{
	HV *object = newHV ();

	if (info && info->name && info->valid_fields) {
		hv_store (object, "name", 4, newSVpv (info->name, PL_na), 0);
		hv_store (object, "valid_fields", 12, newSVGnomeVFSFileInfoFields (info->valid_fields), 0);
		
		if (info->valid_fields & GNOME_VFS_FILE_INFO_FIELDS_TYPE)
			hv_store (object, "type", 4, newSVGnomeVFSFileType (info->type), 0);
		
		if (info->valid_fields & GNOME_VFS_FILE_INFO_FIELDS_PERMISSIONS)
			hv_store (object, "permissions", 11, newSVGnomeVFSFilePermissions (info->permissions), 0);
		
		if (info->valid_fields & GNOME_VFS_FILE_INFO_FIELDS_FLAGS)
			hv_store (object, "flags", 5, newSVGnomeVFSFileFlags (info->flags), 0);
		
		if (info->valid_fields & GNOME_VFS_FILE_INFO_FIELDS_DEVICE)
			hv_store (object, "device", 6, newSViv (info->device), 0);
		
		if (info->valid_fields & GNOME_VFS_FILE_INFO_FIELDS_INODE)
			hv_store (object, "inode", 5, newSVuv (info->inode), 0);
		
		if (info->valid_fields & GNOME_VFS_FILE_INFO_FIELDS_LINK_COUNT)
			hv_store (object, "link_count", 10, newSVuv (info->link_count), 0);
		
		if (info->valid_fields & GNOME_VFS_FILE_INFO_FIELDS_SIZE)
			hv_store (object, "size", 4, newSVuv (info->size), 0);
		
		if (info->valid_fields & GNOME_VFS_FILE_INFO_FIELDS_BLOCK_COUNT)
			hv_store (object, "block_count", 11, newSVuv (info->block_count), 0);
		
		if (info->valid_fields & GNOME_VFS_FILE_INFO_FIELDS_IO_BLOCK_SIZE)
			hv_store (object, "io_block_size", 13, newSVuv (info->io_block_size), 0);
		
		if (info->valid_fields & GNOME_VFS_FILE_INFO_FIELDS_ATIME)
			hv_store (object, "atime", 5, newSViv (info->atime), 0);
		
		if (info->valid_fields & GNOME_VFS_FILE_INFO_FIELDS_MTIME)
			hv_store (object, "mtime", 5, newSViv (info->mtime), 0);
		
		if (info->valid_fields & GNOME_VFS_FILE_INFO_FIELDS_CTIME)
			hv_store (object, "ctime", 5, newSViv (info->ctime), 0);
		
		if (info->valid_fields & GNOME_VFS_FILE_INFO_FIELDS_SYMLINK_NAME)
			hv_store (object, "symlink_name", 12, newSVpv (info->symlink_name, PL_na), 0);
		
		if (info->valid_fields & GNOME_VFS_FILE_INFO_FIELDS_MIME_TYPE)
			hv_store (object, "mime_type", 9, newSVpv (info->mime_type, PL_na), 0);
		
		/* FIXME: what about GNOME_VFS_FILE_INFO_FIELDS_ACCESS? */
	}

	return sv_bless (newRV_noinc ((SV *) object),
	                 gv_stashpv ("Gnome2::VFS::FileInfo", 1));
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

		if (hv_exists (hv, "type", 4)) {
			value = hv_fetch (hv, "type", 4, FALSE);
			if (value) info->type = SvGnomeVFSFileType (*value);
			info->valid_fields |= GNOME_VFS_FILE_INFO_FIELDS_TYPE;
		}

		if (hv_exists (hv, "permissions", 11)) {
			value = hv_fetch (hv, "permissions", 11, FALSE);
			if (value) info->permissions = SvGnomeVFSFilePermissions (*value);
			info->valid_fields |= GNOME_VFS_FILE_INFO_FIELDS_PERMISSIONS;
		}

		if (hv_exists (hv, "flags", 5)) {
			value = hv_fetch (hv, "flags", 5, FALSE);
			if (value) info->flags = SvGnomeVFSFileFlags (*value);
			info->valid_fields |= GNOME_VFS_FILE_INFO_FIELDS_FLAGS;
		}

		if (hv_exists (hv, "device", 6)) {
			value = hv_fetch (hv, "device", 6, FALSE);
			if (value) info->device = SvIV (*value);
			info->valid_fields |= GNOME_VFS_FILE_INFO_FIELDS_DEVICE;
		}

		if (hv_exists (hv, "inode", 5)) {
			value = hv_fetch (hv, "inode", 5, FALSE);
			if (value) info->inode = SvUV (*value);
			info->valid_fields |= GNOME_VFS_FILE_INFO_FIELDS_INODE;
		}

		if (hv_exists (hv, "link_count", 10)) {
			value = hv_fetch (hv, "link_count", 10, FALSE);
			if (value) info->link_count = SvUV (*value);
			info->valid_fields |= GNOME_VFS_FILE_INFO_FIELDS_LINK_COUNT;
		}

		if (hv_exists (hv, "size", 4)) {
			value = hv_fetch (hv, "size", 4, FALSE);
			if (value) info->size = SvUV (*value);
			info->valid_fields |= GNOME_VFS_FILE_INFO_FIELDS_SIZE;
		}

		if (hv_exists (hv, "block_count", 11)) {
			value = hv_fetch (hv, "block_count", 11, FALSE);
			if (value) info->block_count = SvUV (*value);
			info->valid_fields |= GNOME_VFS_FILE_INFO_FIELDS_BLOCK_COUNT;
		}

		if (hv_exists (hv, "io_block_size", 13)) {
			value = hv_fetch (hv, "io_block_size", 13, FALSE);
			if (value) info->io_block_size = SvUV (*value);
			info->valid_fields |= GNOME_VFS_FILE_INFO_FIELDS_IO_BLOCK_SIZE;
		}

		if (hv_exists (hv, "atime", 5)) {
			value = hv_fetch (hv, "atime", 5, FALSE);
			if (value) info->atime = SvIV (*value);
			info->valid_fields |= GNOME_VFS_FILE_INFO_FIELDS_ATIME;
		}

		if (hv_exists (hv, "mtime", 5)) {
			value = hv_fetch (hv, "mtime", 5, FALSE);
			if (value) info->mtime = SvIV (*value);
			info->valid_fields |= GNOME_VFS_FILE_INFO_FIELDS_MTIME;
		}

		if (hv_exists (hv, "ctime", 5)) {
			value = hv_fetch (hv, "ctime", 5, FALSE);
			if (value) info->ctime = SvIV (*value);
			info->valid_fields |= GNOME_VFS_FILE_INFO_FIELDS_CTIME;
		}

		if (hv_exists (hv, "symlink_name", 12)) {
			value = hv_fetch (hv, "symlink_name", 12, FALSE);
			if (value) info->symlink_name = SvPV_nolen (*value);
			info->valid_fields |= GNOME_VFS_FILE_INFO_FIELDS_SYMLINK_NAME;
		}

		if (hv_exists (hv, "mime_type", 9)) {
			value = hv_fetch (hv, "mime_type", 9, FALSE);
			if (value) info->mime_type = SvPV_nolen (*value);
			info->valid_fields |= GNOME_VFS_FILE_INFO_FIELDS_MIME_TYPE;
		}
		
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
