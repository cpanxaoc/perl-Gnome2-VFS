#!/usr/bin/perl -w
use strict;
use Gnome2::VFS;

use Test::More tests => 20;

# $Header$

###############################################################################

Gnome2::VFS -> init();

###############################################################################

# Gnome2::VFS -> escape_set(...);
# Gnome2::VFS -> icon_path_from_filename(...);

is(Gnome2::VFS -> format_file_size_for_display(1200000000), "1.1 GB");

foreach (Gnome2::VFS -> escape_string('%$§'),
         Gnome2::VFS -> escape_path_string('%$§'),
         Gnome2::VFS -> escape_host_and_path_string('%$§')) {
  is($_, '%25%24%A7');
  is(Gnome2::VFS -> unescape_string($_), '%$§');
}

is(Gnome2::VFS -> escape_slashes("/%/"), "%2F%25%2F");
is(Gnome2::VFS -> make_uri_canonical("bla/bla.txt"), "file:///bla/bla.txt");
is(Gnome2::VFS -> make_path_name_canonical("/bla"), "/bla");
is(Gnome2::VFS -> expand_initial_tilde("~/bla"), "$ENV{ HOME }/bla");
is(Gnome2::VFS -> unescape_string_for_display("%2F%25%2F"), "/%/");
is(Gnome2::VFS -> get_local_path_from_uri("file:///bla"), "/bla");
is(Gnome2::VFS -> get_uri_from_local_path("/bla"), "file:///bla");
ok(Gnome2::VFS -> is_executable_command_string("perl -wle 'print bla'"));

my ($result, $size) = Gnome2::VFS -> get_volume_free_space(Gnome2::VFS::URI -> new("file:///usr"));
is($result, "ok");
like($size, qr/^\d+$/);

ok(Gnome2::VFS -> is_primary_thread());
is(Gnome2::VFS -> get_uri_scheme("http://gtk2-perl.sf.net"), "http");
ok(Gnome2::VFS -> uris_match("http://gtk2-perl.sf.net", "http://gtk2-perl.sf.net"));

###############################################################################

Gnome2::VFS -> shutdown();
