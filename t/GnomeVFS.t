#!/usr/bin/perl -w
use strict;
use Gnome2::VFS;

use Test::More tests => 1;

# $Header$

###############################################################################

Gnome2::VFS -> init();

ok(Gnome2::VFS -> initialized());

###############################################################################

# XXX: how to reliably test this? seems to require a running nautilus.
# my ($result, $uri) = Gnome2::VFS -> find_directory("/home", "desktop", 0, 1, 0755);
# is($result, "ok");
# isa_ok($uri, "Gnome2::VFS::URI");

###############################################################################

Gnome2::VFS -> shutdown();