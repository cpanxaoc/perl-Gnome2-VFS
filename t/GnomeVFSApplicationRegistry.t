#!/usr/bin/perl -w
use strict;
use Gnome2::VFS;

use Test::More tests => 9;

# $Header$

###############################################################################

Gnome2::VFS -> init();

###############################################################################

my $application = Gnome2::VFS::ApplicationRegistry -> new("gnome-terminal");
isa_ok($application, "Gnome2::VFS::Application");

ok($application -> exists());
ok($application -> get_keys());
is($application -> peek_value("name"), "Terminal");
is_deeply([$application -> get_bool_value("can_open_multiple_files")], [0, 1]);

# XXX: enable, but -> reload()?
# $application -> remove_application();
# $application -> set_value();
# $application -> set_bool_value();
# $application -> unset_key();
# $application -> clear_mime_types();
# $application -> add_mime_type();
# $application -> remove_mime_type();

# Gnome2::VFS::Application -> is_user_owned_application();
# $application -> get_mime_application();
# gnome_vfs_application_registry_save_mime_application();

# Gnome2::VFS::ApplicationRegistry -> sync();
# Gnome2::VFS::ApplicationRegistry -> shutdown();
# Gnome2::VFS::ApplicationRegistry -> reload();

ok($application -> get_applications("text/html"));
ok($application -> get_mime_types());
ok($application -> supports_mime_type(($application -> get_mime_types())[0]));

ok(not $application -> supports_uri_scheme("http"));

###############################################################################

Gnome2::VFS -> shutdown();