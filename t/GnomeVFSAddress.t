#!/usr/bin/perl -w
use strict;
use Gnome2::VFS;

use Test::More;

# $Header$

unless (-d "$ENV{ HOME }/.gnome") {
  plan(skip_all => "You have no ~/.gnome");
}

unless (Gnome2::VFS -> CHECK_VERSION(2, 7, 4)) { # FIXME: 2.8
  plan(skip_all => "This is new in 2.8");
}

plan(tests => 3);

Gnome2::VFS -> init();

###############################################################################

my $address = Gnome2::VFS::Address -> new_from_string("127.0.0.1");
isa_ok($address, "Gnome2::VFS::Address");
like($address -> get_family_type(), qr/^\d+$/);
is($address -> to_string(), "127.0.0.1");

###############################################################################

Gnome2::VFS -> shutdown();