#!/usr/bin/perl -w
use strict;
use Gnome2::VFS;

use Cwd qw(cwd);

use Test::More;

# $Header$

plan -d "$ENV{ HOME }/.gnome" ?
  (tests => 3) :
  (skip_all => "You have no ~/.gnome");

Gnome2::VFS -> init();

###############################################################################

my $info = Gnome2::VFS -> get_file_info(cwd() . "/" . $0, qw(get-mime-type));

isa_ok($info, "Gnome2::VFS::FileInfo");
ok($info -> matches($info));
is($info -> get_mime_type(), $info -> { mime_type });

###############################################################################

Gnome2::VFS -> shutdown();
