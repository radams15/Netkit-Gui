#!/usr/bin/perl

use warnings;
use strict;

use lib './lib';

use Lab;
use MainWindow;


#my $lab = Lab->new('/home/rhys/nklabs/nccd-arch/res/');
my $lab = Lab->new('/home/rhys/nklabs/lab02-abr/');

if(! $lab->is_started) {
	print "Lab not started, please start the lab!\n";
}

my $win = MainWindow->new($lab);

$win->run;
