package MachineWidget;

use warnings;
use strict;

use Env qw(HOME);

use Glib::IO;
use Vte;
use Gtk4;

sub new {
	my $class = shift;
	
	my $lab = shift;
	my $machine = shift;
	

	my $self = Gtk4::Box->new('vertical', 5);
	
	$self->{tty_notebook} = Gtk4::Notebook->new();
	
	my %ttys = $lab->machine_ttys($machine);
	
	for my $id (sort { $a cmp $b } keys %ttys) {
		my $port = @ttys{$id};
		
		my $label = Gtk4::Label->new("TTY$id");
		my $term = &get_term("telnet", "localhost", $port);
		
		$self->{tty_notebook}->append_page($term, $label);
	}

	$self->append($self->{tty_notebook});

	return $self;
}

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

1;
