#!/usr/bin/perl -w
use strict;
use Gnome2::VFS;

use Test::More tests => 26;

# $Header$

###############################################################################

Gnome2::VFS -> init();

my $result;

###############################################################################

my $handle;

foreach ([Gnome2::VFS::Directory -> open("/tmp", qw(default))],
         [Gnome2::VFS::Directory -> open_from_uri(Gnome2::VFS::URI -> new("/tmp"), qw(default))]) {
  ($result, $handle) = @{$_};

  is($result, "ok");
  isa_ok($handle, "Gnome2::VFS::Directory::Handle");

  is($handle -> close(), "ok");
}

###############################################################################

my $info;

$handle = Gnome2::VFS::Directory -> open("/tmp", qw(default));

($result, $info) = $handle -> read_next();
is($result, "ok");
is($info -> { name }, ".");
is($info -> { type }, "directory");

$handle -> close();

###############################################################################

my $callback = sub {
  my ($node, $info, $will_loop) = @_;

  ok(-e "/tmp/" . $node);
  is($info -> { name }, $node);
  ok($will_loop == 0 || $will_loop == 1);

  return (0, 1);
};

is(Gnome2::VFS::Directory -> visit("/tmp",
                                   qw(default),
                                   qw(default),
                                   $callback), "ok");

is(Gnome2::VFS::Directory -> visit_uri(Gnome2::VFS::URI -> new("/tmp"),
                                       qw(default),
                                       qw(default),
                                       $callback), "ok");

Gnome2::VFS -> create("/tmp/bla", "write", 1, 0644);
Gnome2::VFS -> create("/tmp/blu", "write", 1, 0644);

is(Gnome2::VFS::Directory -> visit_files("/tmp",
                                         [qw(bla blu)],
                                         qw(default),
                                         qw(default),
                                         $callback), "ok");

is(Gnome2::VFS::Directory -> visit_files_at_uri(Gnome2::VFS::URI -> new("/tmp"),
                                                [qw(bla blu)],
                                                qw(default),
                                                qw(default),
                                                $callback), "ok");

Gnome2::VFS -> unlink("/tmp/blu");
Gnome2::VFS -> unlink("/tmp/bla");

###############################################################################

my @infos;

($result, @infos) = Gnome2::VFS::Directory -> list_load("/tmp", qw(default));
ok(-e "/tmp/" . $infos[0] -> { name });

###############################################################################

Gnome2::VFS -> shutdown();
