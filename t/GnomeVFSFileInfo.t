#!/usr/bin/perl -w
use strict;
use Gnome2::VFS;

use Test::More tests => 4;

# $Header$

###############################################################################

Gnome2::VFS -> init();

###############################################################################

my $info_one = Gnome2::VFS -> get_file_info("/usr/bin/perl", qw(get-mime-type));
my $info_two = Gnome2::VFS -> get_file_info("/usr/bin/perl", qw(get-mime-type));

isa_ok($info_one, "Gnome2::VFS::FileInfo");
isa_ok($info_two, "Gnome2::VFS::FileInfo");

ok($info_one -> matches($info_two));
is($info_one -> get_mime_type(), $info_two -> { mime_type });

###############################################################################

Gnome2::VFS -> shutdown();
