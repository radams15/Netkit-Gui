#!/usr/bin/perl

use warnings;
use strict;

use lib './lib';

use Lab;
use MainWindow;

my $lab = Lab->new('/home/rhys/nklabs/lab02-abr/');

my $win = MainWindow->new($lab);

$win->run;
