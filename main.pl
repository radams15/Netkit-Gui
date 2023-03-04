#!/usr/bin/perl

use warnings;
use strict;

use lib './lib';

use Lab;
use MainWindow;

my $lab_dir = $ARGV[0] or die "Lab directory required!";

my $lab = Lab->new($lab_dir);

if(! $lab->is_started) {
	print "Lab not started, starting lab!\n";
	$lab->start;
}

my $win = MainWindow->new($lab);

$win->run;
