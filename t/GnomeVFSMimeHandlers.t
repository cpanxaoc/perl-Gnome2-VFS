#!/usr/bin/perl -w
use strict;
use Gnome2::VFS;

use Test::More tests => 20;

# $Header$

###############################################################################

Gnome2::VFS -> init();

###############################################################################

my $type = Gnome2::VFS::Mime::Type -> new("text/html");

my $application = $type -> get_default_application();
isa_ok($application, "Gnome2::VFS::Mime::Application");
ok(defined($application -> { id }));
isa_ok($application -> { supported_uri_schemes }, "ARRAY");

# is($application -> launch("http://gtk2-perl.sf.net"), "ok");

# isa_ok(Gnome2::VFS::Mime::Application -> new_from_id("xmms"), "Gnome2::VFS::Mime::Application");

isa_ok(($type -> get_short_list_applications())[0], "Gnome2::VFS::Mime::Application");
isa_ok(($type -> get_all_applications())[0], "Gnome2::VFS::Mime::Application");

# $type -> get_icon();
# $type -> set_icon(...);

is($type -> set_description("HTML Foo"), "ok");
is($type -> get_description(), "HTML Foo");

is($type -> set_can_be_executable(0), "ok");
ok(not $type -> can_be_executable());

is($type -> add_application_to_short_list("galeon"), "ok");
is($type -> remove_application_from_short_list("galeon"), "ok");

is($type -> add_extension("htm"), "ok");
is($type -> remove_extension("htm"), "ok");

is($type -> set_short_list_applications(qw(galeon epiphany)), "ok");

is($type -> extend_all_applications(qw(xmms)), "ok");
is($type -> remove_from_all_applications(qw(xmms)), "ok");

is($type -> set_default_application("galeon"), "ok");

is($type -> get_default_action_type(), "application");
is($type -> set_default_action_type("none"), "ok");
is($type -> get_default_action_type(), "none");

###############################################################################

Gnome2::VFS -> shutdown();
