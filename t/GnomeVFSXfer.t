#!/usr/bin/perl -w
use strict;
use Gnome2::VFS;

use Test::More tests => 68;

# $Header$

###############################################################################

Gnome2::VFS -> init();

###############################################################################

my $progress = sub {
  my ($info) = @_;

  isa_ok($info, "HASH");

  if ($info -> { status } eq "ok") {
    return 1;
  }
  elsif ($info -> { status } eq "vfserror") {
    return "abort";
  }
  elsif ($info -> { status } eq "overwrite") {
    return "replace";
  }

  return 0;
};

###############################################################################

foreach (qw(a e i o)) {
  my $handle = Gnome2::VFS -> create("/tmp/bl" . $_, "write", 1, 0644);
  $handle -> write("blaaa!", 6);
  $handle -> close();
}

###############################################################################

my $source = Gnome2::VFS::URI -> new("file:///tmp/bla");
my $destination = Gnome2::VFS::URI -> new("file:///tmp/blaa");

is(Gnome2::VFS::Xfer -> uri($source,
                            $destination,
                            qw(default),
                            qw(query),
                            qw(query),
                            $progress), "ok");

ok(-e $destination -> to_string(qw(toplevel-method)));

is($source -> unlink(), "ok");
is($destination -> unlink(), "ok");

###############################################################################

my @source = (Gnome2::VFS::URI -> new("file:///tmp/ble"),
              Gnome2::VFS::URI -> new("file:///tmp/bli"),
              Gnome2::VFS::URI -> new("file:///tmp/blo"));

my @destination = (Gnome2::VFS::URI -> new("file:///tmp/blee"),
                   Gnome2::VFS::URI -> new("file:///tmp/blii"),
                   Gnome2::VFS::URI -> new("file:///tmp/bloo"));

is(Gnome2::VFS::Xfer -> uri_list(\@source,
                                 \@destination,
                                 qw(default),
                                 qw(query),
                                 qw(query),
                                 $progress), "ok");

foreach (@destination) {
  ok(-e $_ -> to_string(qw(toplevel-method)));
}

is(Gnome2::VFS::Xfer -> delete_list(\@source,
                                    qw(query),
                                    qw(default),
                                    $progress), "ok");

is(Gnome2::VFS::Xfer -> delete_list(\@destination,
                                    qw(query),
                                    qw(default),
                                    $progress), "ok");

###############################################################################

Gnome2::VFS -> shutdown();
