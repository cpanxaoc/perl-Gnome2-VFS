# $Header$

package Gnome2::VFS;

use 5.008;
use strict;
use warnings;

use Gtk2;

require DynaLoader;

our @ISA = qw(DynaLoader);

our $VERSION = '0.01';

sub dl_load_flags { 0x01 }

Gnome2::VFS -> bootstrap($VERSION);

# Preloaded methods go here.

1;
__END__
# Below is stub documentation for your module. You'd better edit it!

=head1 NAME

Gnome2::VFS - Perl interface to the 2.x series of the GNOME VFS library

=head1 SYNOPSIS

  use Gnome2::VFS;
  Gnome2::VFS -> init();

  sub die_a_bloody_death {
    my ($action) = @_;
    die("An error occured while $action.\n");
  }

  # Open /usr/bin/perl.
  my ($result, $handle) = Gnome2::VFS -> open("/usr/bin/perl", "read");

  unless ($result eq "ok") {
    die_a_bloody_death("opening '/usr/bin/perl'");
  }

  # Read from /usr/bin/perl.
  my $bytes = 1024;
  my ($bytes_read, $buffer);

  ($result, $bytes_read, $buffer) = $handle -> read($bytes);

  unless ($result eq "ok") {
    die_a_bloody_death("reading $bytes bytes from '/usr/bin/perl'");
  }

  # Close /usr/bin/perl.
  $result = $handle -> close();

  unless ($result eq "ok") {
    die_a_bloody_death("closing '/usr/bin/perl'");
  }

  # Create /tmp/perl-head.
  my $uri = Gnome2::VFS::URI -> new("/tmp/perl-head");

  ($result, $handle) = $uri -> create("write", 1, 0644);

  unless ($result eq "ok") {
    die_a_bloody_death("creating '/tmp/perl-head'");
  }

  # Write to /tmp/perl-head.
  my $bytes_written;

  ($result, $bytes_written) = $handle -> write($buffer, $bytes);

  unless ($result eq "ok" && $bytes_written == $bytes) {
    die_a_bloody_death("writing $bytes byte to '/tmp/perl-head'");
  }

  # Close /tmp/perl-head.
  $result = $handle -> close();

  unless ($result eq "ok") {
    die_a_bloody_death("closing '/tmp/perl-head'");
  }

  Gnome2::VFS -> shutdown();

=head1 ABSTRACT

Perl bindings to the 2.x series of the GNOME VFS library.  This module allows
you to interface with the gnome-vfs libraries.

=head1 DESCRIPTION

Since this module tries to stick very closely to the C API the documentation
found at

  http://developer.gnome.org/doc/API/2.0/gnome-vfs-2.0/

is the canonical reference.

The mapping described in L<Gtk2::api>(3pm) also applies to this module.

To discuss this module, ask questions and flame/praise the authors, join
gtk-perl-list@gnome.org at lists.gnome.org.

=head1 SEE ALSO

L<perl>(1), L<Glib>(3pm), L<Gtk2>(3pm), L<Gtk2::api>(3pm).

=head1 AUTHOR

Torsten Schoenfeld E<lt>kaffeetisch@web.deE<gt>.

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2003 by the gtk2-perl team

This library is free software; you can redistribute it and/or modify it under
the terms of the GNU Lesser General Public License as published by the Free
Software Foundation; either version 2.1 of the License, or (at your option) any
later version.

This library is distributed in the hope that it will be useful, but WITHOUT ANY
WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A
PARTICULAR PURPOSE.  See the GNU Lesser General Public License for more
details.

You should have received a copy of the GNU Lesser General Public License along
with this library; if not, write to the Free Software Foundation, Inc.,
59 Temple Place, Suite 330, Boston, MA  02111-1307  USA

=cut
