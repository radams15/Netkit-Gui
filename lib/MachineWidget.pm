package MachineWidget;

use warnings;
use strict;

use Env qw(HOME);

use Glib::IO;
use Vte;
use Gtk3;

sub new {
	my $class = shift;
	
	my $lab = shift;
	my $machine = shift;
	my $headerbar = shift;

	my $self = Gtk3::Box->new('vertical', 5);
	
	$self->{tty_notebook} = Gtk3::Notebook->new();
	
	my %ttys = $lab->machine_ttys($machine);
	
	for my $id (sort { $a cmp $b } keys %ttys) {
		my $port = $ttys{$id};
		
		my $label = Gtk3::Label->new("TTY$id");
		my $term = &get_term("telnet", "localhost", $port);
		
		$self->{tty_notebook}->append_page($term, $label);
		$self->{tty_notebook}->child_set($term, tab_expand => 1);
	}

	$self->add($self->{tty_notebook});

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
		'default',
	);
	
	$out->set_vexpand(1);
	$out->set_hexpand(1);
	
	return $out;
}

1;
