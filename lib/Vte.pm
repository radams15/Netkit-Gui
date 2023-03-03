package Vte;

use warnings;
use strict;


use Carp qw/croak/;
use Cairo::GObject;
use Glib::Object::Introspection;
use Exporter;

our @ISA = qw(Exporter);

my $_VTE_BASENAME = 'Vte';
my $_VTE_VERSION = '3.91';
my $_VTE_PACKAGE = 'Vte';

sub import {
    my $class = shift;

    Glib::Object::Introspection->setup(
        basename => $_VTE_BASENAME,
        version => $_VTE_VERSION,
        package => $_VTE_PACKAGE,
    );
}

1;

__END__

