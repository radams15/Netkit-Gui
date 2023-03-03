#!/usr/bin/perl

use warnings;
use strict;

use lib './lib';

use Env qw(HOME);

use Glib::IO;
use Vte;
use Gtk4;

use Lab;

=pod
my $lab = Lab->new('/home/rhys/nklabs/lab02-abr/');

my @machines = $lab->machines;

for (@machines) {
	print "$_\n";
}

my @a_ttys = $lab->machine_ttys('a');

for my ($id, $path) (@a_ttys) {
	print "tty$id = port $path\n";
}
=cut

sub get_term {
	my @cmds = @_;
	
	my $out = Vte::Terminal->new;
	
	$out->spawn_sync (
		'default',
		$HOME,
		\@cmds,
		[],
		'do_not_reap_child',
		undef,
		undef,
	);
	
	return $out;
}

my $app = Gtk4::Application->new('com.example.App', 'flags-none');

# When the application is launched…
$app->signal_connect(activate => sub {
  # … create a new window …
  my $win = Gtk4::ApplicationWindow->new($app);

  my $term = &get_term("/bin/sh", "-c", "ls");

  $win->set_child($term);
  $win->present();
});

# Run the application
$app->run();
