#!/usr/bin/perl

use warnings;
use strict;

use lib './lib';

use Lab;
use MainWindow;

my $lab = Lab->new('/home/rhys/nklabs/nccd-arch/res/');

my $win = MainWindow->new($lab);

$win->run;
