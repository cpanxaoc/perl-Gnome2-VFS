#!/usr/bin/perl -w
use strict;
use Gnome2::VFS;

use Test::More tests => 59;

# $Header$

###############################################################################

Gnome2::VFS -> init();

###############################################################################

my ($result, $handle);

foreach ([Gnome2::VFS -> open("/usr/bin/perl", "read")],
         [Gnome2::VFS::URI -> new("/usr/bin/perl") -> open("read")],
         [Gnome2::VFS -> create("/tmp/blaaaaaaaaa", "write", 1, 0755)],
         [Gnome2::VFS::URI -> new("/tmp/bleeeeeeeee") -> create("write", 1, 0644)]) {
  ($result, $handle) = @{$_};

  is($result, "ok");
  isa_ok($handle, "Gnome2::VFS::Handle");

  is($handle -> close(), "ok");
}

###############################################################################

is(Gnome2::VFS -> move("/tmp/blaaaaaaaaa", "/tmp/bla", 0), "ok");
is(Gnome2::VFS::URI -> new("/tmp/bleeeeeeeee") -> move(Gnome2::VFS::URI -> new("/tmp/ble"), 0), "ok");

is_deeply([Gnome2::VFS -> check_same_fs("/tmp/bla", "/tmp/ble")], ["ok", 1]);
is_deeply([Gnome2::VFS::URI -> new("/tmp/bla") -> check_same_fs(Gnome2::VFS::URI -> new("/tmp/ble"))], ["ok", 1]);

is(Gnome2::VFS -> create_symbolic_link(Gnome2::VFS::URI -> new("/tmp/bli"), "/usr/bin/perl"), "ok");

is(Gnome2::VFS -> unlink("/tmp/bla"), "ok");
is(Gnome2::VFS -> unlink("/tmp/bli"), "ok");

my $uri = Gnome2::VFS::URI -> new("/tmp/ble");

ok($uri -> exists());
is($uri -> unlink(), "ok");

###############################################################################

($result, $handle) = Gnome2::VFS -> create("/tmp/blu", "write", 1, 0644);
is($result, "ok");
is_deeply([$handle -> write("blaaa!", 6)], ["ok", 6]);

($result, $handle) = Gnome2::VFS -> open("/tmp/blu", "read");
is($result, "ok");
is_deeply([$handle -> read(6)], ["ok", 6, "blaaa!"]);

is_deeply([$handle -> tell()], ["ok", 6]);

# XXX: why doesn't that work?
# is($handle -> seek("start", 2), "ok");
# is_deeply([$handle -> read(4)], ["ok", 4, "aaa!"]);

is($handle -> close(), "ok");

# XXX: truncating not working at all?
# warn $handle -> truncate(3);
# warn Gnome2::VFS::URI -> new("/tmp/blu") -> truncate(4);
# warn Gnome2::VFS -> truncate("/tmp/blu", 5);

###############################################################################

($result, $handle) = Gnome2::VFS -> open("/tmp/blu", [qw(read write random)]);
is($result, "ok");

my $info;

($result, $info) = Gnome2::VFS -> get_file_info("/tmp/blu", qw(default));
is($result, "ok");
is($info -> { size }, 6);

($result, $info) = Gnome2::VFS::URI -> new("/tmp/blu") -> get_file_info(qw(get-mime-type));
is($result, "ok");
is($info -> { mime_type }, "text/plain");

($result, $info) = $handle -> get_file_info(qw(default));
is($result, "ok");
is_deeply($info -> { permissions }, [qw(user-read user-write user-all group-read group-all other-read other-all)]);

is($handle -> close(), "ok");

is(Gnome2::VFS -> unlink("/tmp/blu"), "ok");

###############################################################################

my $monitor;

($result, $monitor) = Gnome2::VFS::Monitor -> add("/tmp", qw(directory), sub {
  my ($handle, $monitor_uri, $info_uri, $event_type) = @_;

  isa_ok($handle, "Gnome2::VFS::Monitor::Handle");
  is($monitor_uri, "file:///tmp");
  is($info_uri, "file:///tmp/ulb");
  ok($event_type eq "created" or $event_type eq "deleted");
});

is($result, "ok");
isa_ok($monitor, "Gnome2::VFS::Monitor::Handle");

###############################################################################

is(Gnome2::VFS -> make_directory("/tmp/ulb", 0755), "ok");
is(Gnome2::VFS -> remove_directory("/tmp/ulb"), "ok");

$uri = Gnome2::VFS::URI -> new("/tmp/ulb");

is($uri -> make_directory(0755), "ok");
is($uri -> remove_directory(), "ok");

###############################################################################

# shortly enter the main loop so that the monitor receives the events.
Glib::Idle -> add(sub {
  Gtk2 -> main_quit();
  return 0;
});

Gtk2 -> main();

is($monitor -> cancel(), "ok");

###############################################################################

Gnome2::VFS -> shutdown();
