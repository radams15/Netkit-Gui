#!/usr/bin/perl

use warnings;
use strict;

use lib './lib';

use Lab;

my $lab = Lab->new('/home/rhys/nklabs/lab02-abr/');

my @machines = $lab->machines;

for (@machines) {
	print "$_\n";
}

my @a_ttys = $lab->machine_ttys('a');

for my ($id, $path) (@a_ttys) {
	print "tty$id = port $path\n";
}
