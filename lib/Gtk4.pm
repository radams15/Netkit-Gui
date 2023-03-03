# SPDX-FileCopyrightText: 2022  Emmanuele Bassi
# SPDX-License-Identifier: LGPL-2.1-or-later

package Gtk4;

=encoding utf8

=head1 NAME

Gtk4 - Perl interface to the 4.x series of the GTK toolkit

=head1 SYNOPSIS

  use Gtk4;

  my $app = Gtk4::Application->new('com.example.App', 'default-flags');
  $app->signal_connect(activate => sub {
      my $win = Gtk4::ApplicationWindow->new($app);
      $win->set_title('Hello, Perl');
      $win->present();
  });
  $app->run();

=head1 ABSTRACT

Perl binding to the 4.x series of the GTK toolkit.

=head1 DESCRIPTION

The C<Gtk4> module allows a Perl developer to use the GTK graphical user
interface library.

=cut

use strict;
use warnings;

use Carp qw/croak/;
use Cairo::GObject;
use Glib::Object::Introspection;
use Exporter;

our @ISA = qw(Exporter);

=head2 Wrapped libraries

GTK depends on the GDK and GSK API, provided by the same underlying C library.
The C<Gtk4> module automatically exposes those namespaces as sub-packages:

  Namespace | Package
  ----------+--------
  Gtk-4.0   | Gtk4
  Gdk-4.0   | Gtk4::Gdk
  Gsk-4.0   | Gtk4::Gsk

=cut

my $_GTK_BASENAME = 'Gtk';
my $_GTK_VERSION = '4.0';
my $_GTK_PACKAGE = 'Gtk4';

my $_GDK_BASENAME = 'Gdk';
my $_GDK_VERSION = '4.0';
my $_GDK_PACKAGE = 'Gtk4::Gdk';

my $_GSK_BASENAME = 'Gsk';
my $_GSK_VERSION = '4.0';
my $_GSK_PACKAGE = 'Gtk4::Gsk';

sub import {
    my $class = shift;

    Glib::Object::Introspection->setup(
        basename => $_GTK_BASENAME,
        version => $_GTK_VERSION,
        package => $_GTK_PACKAGE,
    );

    Glib::Object::Introspection->setup(
        basename => $_GDK_BASENAME,
        version => $_GDK_VERSION,
        package => $_GDK_PACKAGE,
    );

    Glib::Object::Introspection->setup(
        basename => $_GSK_BASENAME,
        version => $_GSK_VERSION,
        package => $_GSK_PACKAGE,
    );
}

1;

__END__

=head2 Porting from Gtk3 to Gtk4

=head1 SEE ALSO

=head1 AUTHORS

=head1 COPYRIGHT AND LICENSE

=cut